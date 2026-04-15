<footer class="footer mt-5 py-3 bg-light border-top">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                    <span class="text-muted">
                        <i class="bi bi-c-circle"></i> 2024 Gestion Cinéma - Tous droits réservés
                    </span>
            </div>
            <div class="col-md-6 text-end">
                    <span class="text-muted">
                        Version 1.0.0 | Spring Boot 3.2.5
                    </span>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 JS Bundle CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>

<!-- Scripts personnalisés -->
<script>
    // Scripts temporaires
    $(document).ready(function() {
        // Auto-dismiss des alertes
        setTimeout(function() {
            $('.alert').alert('close');
        }, 5000);

        // Confirmation suppression
        $('.btn-delete').on('click', function(e) {
            if (!confirm('Êtes-vous sûr de vouloir supprimer cet élément ?')) {
                e.preventDefault();
            }
        });
    });
</script>
</body>
</html>