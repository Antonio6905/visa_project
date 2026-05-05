import { useState, useRef, useEffect } from "react";

const API_BASE = "http://localhost:8000/api";

const statutColors = {
    "EN_ATTENTE":  { bg: "#FFF3CD", color: "#856404", border: "#FFECB5" },
    "EN_COURS":    { bg: "#CCE5FF", color: "#004085", border: "#B8DAFF" },
    "APPROUVEE":   { bg: "#D4EDDA", color: "#155724", border: "#C3E6CB" },
    "REJETEE":     { bg: "#F8D7DA", color: "#721C24", border: "#F5C6CB" },
    "DEFAULT":     { bg: "#E2E3E5", color: "#383D41", border: "#D6D8DB" },
};

function getStatutStyle(code) {
    return statutColors[code] || statutColors.DEFAULT;
}

function Badge({ label, code }) {
    const s = getStatutStyle(code);
    return (
        <span style={{
            background: s.bg, color: s.color, border: `1px solid ${s.border}`,
            borderRadius: "20px", padding: "2px 10px", fontSize: "0.75rem",
            fontWeight: 700, letterSpacing: "0.03em", whiteSpace: "nowrap",
        }}>
      {label}
    </span>
    );
}

function Spinner() {
    return (
        <div style={{ display: "flex", justifyContent: "center", padding: "40px 0" }}>
            <div style={{
                width: 36, height: 36, borderRadius: "50%",
                border: "3px solid #E2E8F0", borderTopColor: "#1A56DB",
                animation: "spin 0.7s linear infinite",
            }} />
            <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
        </div>
    );
}

function EmptyState({ message }) {
    return (
        <div style={{
            textAlign: "center", padding: "48px 24px", color: "#94A3B8",
        }}>
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" style={{ marginBottom: 12 }}>
                <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
            </svg>
            <p style={{ margin: 0, fontSize: "0.95rem" }}>{message}</p>
        </div>
    );
}

function DemandeRow({ demande, highlighted }) {
    const rowRef = useRef(null);

    useEffect(() => {
        if (highlighted && rowRef.current) {
            rowRef.current.scrollIntoView({ behavior: "smooth", block: "center" });
        }
    }, [highlighted]);

    const sdf = (d) => d ? new Date(d).toLocaleDateString("fr-FR", {
        day: "2-digit", month: "2-digit", year: "numeric", hour: "2-digit", minute: "2-digit"
    }) : "—";

    return (
        <tr
            ref={rowRef}
            style={{
                background: highlighted ? "#EFF6FF" : "transparent",
                transition: "background 0.3s",
                outline: highlighted ? "2px solid #1A56DB" : "none",
                outlineOffset: "-2px",
            }}
        >
            <td style={tdStyle}>
                <span style={{ fontWeight: 700, color: "#1A56DB" }}>#{demande.id}</span>
                {highlighted && (
                    <span style={{
                        marginLeft: 6, background: "#1A56DB", color: "#fff",
                        borderRadius: 4, fontSize: "0.65rem", padding: "1px 5px",
                        verticalAlign: "middle", fontWeight: 700,
                    }}>recherché</span>
                )}
            </td>
            <td style={tdStyle}>{sdf(demande.dateDemande)}</td>
            <td style={tdStyle}>{demande.nomDemandeur || "—"}</td>
            <td style={tdStyle}>{demande.typeDemande || "—"}</td>
            <td style={tdStyle}>{demande.typeVisa || "—"}</td>
            <td style={tdStyle}>
                <Badge label={demande.statutLibelle || "—"} code={demande.statutCode} />
            </td>
        </tr>
    );
}

const tdStyle = {
    padding: "12px 14px", fontSize: "0.875rem", color: "#334155",
    borderBottom: "1px solid #F1F5F9", verticalAlign: "middle",
};

const thStyle = {
    padding: "10px 14px", fontSize: "0.75rem", fontWeight: 700,
    color: "#64748B", textTransform: "uppercase", letterSpacing: "0.06em",
    borderBottom: "2px solid #E2E8F0", background: "#F8FAFC",
};

export default function DemandeSearch() {
    // Lire le paramètre ?q= ou /demandes/{id} depuis l'URL au montage
    const getInitialQuery = () => {
        const params = new URLSearchParams(window.location.search);
        if (params.get("q")) return params.get("q");

        // Support du path /demandes/{id} (lien direct depuis le QR code)
        const pathMatch = window.location.pathname.match(/\/demandes\/(\d+)/);
        if (pathMatch) return `DEMANDE-${pathMatch[1]}`;

        return "";
    };

    const [query, setQuery] = useState(getInitialQuery);
    const [results, setResults] = useState(null);
    const [highlightedId, setHighlightedId] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);
    const [searchMode, setSearchMode] = useState(null); // "id" | "passport"
    const inputRef = useRef(null);

    // Lancer la recherche automatiquement si un paramètre est présent dans l'URL
    useEffect(() => {
        if (query) handleSearch(query);
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    const parseQuery = (q) => {
        const trimmed = q.trim().toUpperCase();
        const demandeMatch = trimmed.match(/^DEMANDE-(\d+)$/);
        if (demandeMatch) return { type: "id", value: demandeMatch[1] };
        if (trimmed.length > 0) return { type: "passport", value: q.trim() };
        return null;
    };

    const handleSearch = async (overrideQuery) => {
        const parsed = parseQuery(overrideQuery ?? query);
        if (!parsed) return;

        setLoading(true);
        setError(null);
        setResults(null);
        setHighlightedId(null);
        setSearchMode(parsed.type);

        try {
            let url;
            if (parsed.type === "id") {
                url = `${API_BASE}/demandes/search/by-demande-id/${parsed.value}`;
            } else {
                url = `${API_BASE}/demandes/search/by-passport/${encodeURIComponent(parsed.value)}`;
            }

            const res = await fetch(url);
            if (!res.ok) {
                const msg = await res.text();
                throw new Error(msg || `Erreur ${res.status}`);
            }
            const data = await res.json();
            setResults(data.demandes || []);
            setHighlightedId(data.highlightedId || null);
        } catch (e) {
            setError(e.message);
        } finally {
            setLoading(false);
        }
    };

    const handleKeyDown = (e) => {
        if (e.key === "Enter") handleSearch();
    };

    const hint = (() => {
        const t = query.trim().toUpperCase();
        if (!t) return null;
        if (t.startsWith("DEMANDE-")) return { icon: "🔍", text: "Recherche par ID demande" };
        return { icon: "🛂", text: "Recherche par numéro de passeport" };
    })();

    return (
        <div style={{
            minHeight: "100vh", background: "linear-gradient(135deg, #F0F4FF 0%, #F8FAFC 60%, #E8F4FD 100%)",
            fontFamily: "'DM Sans', 'Segoe UI', sans-serif", padding: "0",
        }}>
            {/* Header */}
            <div style={{
                background: "linear-gradient(90deg, #1A3A8F 0%, #1A56DB 100%)",
                padding: "20px 32px", display: "flex", alignItems: "center", gap: 14,
                boxShadow: "0 2px 16px rgba(26,86,219,0.18)",
            }}>
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2">
                    <rect x="2" y="3" width="20" height="18" rx="2"/><path d="M8 7h8M8 11h8M8 15h4"/>
                </svg>
                <div>
                    <div style={{ color: "#fff", fontWeight: 800, fontSize: "1.1rem", letterSpacing: "0.01em" }}>
                        Visa — Recherche de demandes
                    </div>
                    <div style={{ color: "rgba(255,255,255,0.65)", fontSize: "0.78rem" }}>
                        Recherche par ID demande ou numéro de passeport
                    </div>
                </div>
            </div>

            <div style={{ maxWidth: 980, margin: "0 auto", padding: "40px 24px" }}>

                {/* Search card */}
                <div style={{
                    background: "#fff", borderRadius: 16, boxShadow: "0 4px 32px rgba(26,86,219,0.08)",
                    padding: "32px", marginBottom: 32,
                }}>
                    <label style={{
                        display: "block", fontSize: "0.8rem", fontWeight: 700, color: "#64748B",
                        letterSpacing: "0.08em", textTransform: "uppercase", marginBottom: 10,
                    }}>
                        Identifiant de recherche
                    </label>
                    <div style={{ display: "flex", gap: 12, alignItems: "stretch" }}>
                        <div style={{ flex: 1, position: "relative" }}>
                            <input
                                ref={inputRef}
                                value={query}
                                onChange={e => setQuery(e.target.value)}
                                onKeyDown={handleKeyDown}
                                placeholder="DEMANDE-42  ou  AB1234567"
                                style={{
                                    width: "100%", padding: "13px 16px", fontSize: "1rem",
                                    border: "2px solid #E2E8F0", borderRadius: 10, outline: "none",
                                    background: "#F8FAFC", color: "#1E293B", fontFamily: "inherit",
                                    boxSizing: "border-box", transition: "border-color 0.2s",
                                    letterSpacing: "0.03em",
                                }}
                                onFocus={e => e.target.style.borderColor = "#1A56DB"}
                                onBlur={e => e.target.style.borderColor = "#E2E8F0"}
                            />
                        </div>
                        <button
                            onClick={handleSearch}
                            disabled={!query.trim() || loading}
                            style={{
                                background: !query.trim() || loading ? "#CBD5E1" : "linear-gradient(135deg, #1A56DB, #1A3A8F)",
                                color: "#fff", border: "none", borderRadius: 10,
                                padding: "0 28px", fontWeight: 700, fontSize: "0.95rem",
                                cursor: !query.trim() || loading ? "not-allowed" : "pointer",
                                whiteSpace: "nowrap", letterSpacing: "0.02em",
                                transition: "background 0.2s, transform 0.1s",
                                boxShadow: !query.trim() || loading ? "none" : "0 2px 12px rgba(26,86,219,0.25)",
                            }}
                        >
                            Rechercher
                        </button>
                    </div>

                    {/* Hint */}
                    {hint && (
                        <div style={{
                            marginTop: 10, fontSize: "0.8rem", color: "#64748B",
                            display: "flex", alignItems: "center", gap: 6,
                        }}>
                            <span>{hint.icon}</span> <span>{hint.text}</span>
                        </div>
                    )}

                    {/* Legend */}
                    <div style={{
                        marginTop: 20, padding: "12px 16px", background: "#F8FAFC",
                        borderRadius: 8, fontSize: "0.78rem", color: "#64748B",
                        display: "flex", gap: 24, flexWrap: "wrap",
                    }}>
                        <span><strong style={{ color: "#1A56DB" }}>DEMANDE-{"{id}"}</strong> → toutes les demandes du même demandeur (focus sur celle recherchée)</span>
                        <span><strong style={{ color: "#1A56DB" }}>{"{num_passeport}"}</strong> → toutes les demandes liées au passeport, ordre chronologique</span>
                    </div>
                </div>

                {/* Results */}
                {loading && <Spinner />}

                {error && (
                    <div style={{
                        background: "#FEF2F2", border: "1px solid #FECACA", borderRadius: 10,
                        padding: "14px 18px", color: "#DC2626", fontSize: "0.875rem",
                        display: "flex", alignItems: "center", gap: 10,
                    }}>
                        <span>⚠️</span> {error}
                    </div>
                )}

                {!loading && results !== null && (
                    <div style={{
                        background: "#fff", borderRadius: 16,
                        boxShadow: "0 4px 32px rgba(26,86,219,0.08)", overflow: "hidden",
                    }}>
                        <div style={{
                            padding: "16px 24px", borderBottom: "1px solid #F1F5F9",
                            display: "flex", justifyContent: "space-between", alignItems: "center",
                            background: "linear-gradient(90deg, #1A56DB08, transparent)",
                        }}>
                            <div style={{ fontWeight: 700, color: "#1E293B", fontSize: "0.95rem" }}>
                                {searchMode === "id" ? "Demandes du même demandeur" : "Demandes liées au passeport"}
                            </div>
                            <span style={{
                                background: "#EFF6FF", color: "#1A56DB", border: "1px solid #BFDBFE",
                                borderRadius: 20, padding: "2px 12px", fontSize: "0.78rem", fontWeight: 700,
                            }}>
                {results.length} résultat{results.length !== 1 ? "s" : ""}
              </span>
                        </div>

                        {results.length === 0 ? (
                            <EmptyState message="Aucune demande trouvée pour cet identifiant." />
                        ) : (
                            <div style={{ overflowX: "auto" }}>
                                <table style={{ width: "100%", borderCollapse: "collapse" }}>
                                    <thead>
                                    <tr>
                                        {["ID", "Date demande", "Demandeur", "Type demande", "Type visa", "Statut"].map(h => (
                                            <th key={h} style={thStyle}>{h}</th>
                                        ))}
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {results.map(d => (
                                        <DemandeRow
                                            key={d.id}
                                            demande={d}
                                            highlighted={d.id === highlightedId}
                                        />
                                    ))}
                                    </tbody>
                                </table>
                            </div>
                        )}
                    </div>
                )}
            </div>
        </div>
    );
}