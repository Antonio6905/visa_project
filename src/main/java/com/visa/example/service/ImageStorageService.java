package com.visa.example.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;

@Service
public class ImageStorageService {

    private static final String DATA_PREFIX = "data:";
    private static final String BASE64_MARKER = ";base64";
    private static final String URL_BASE = "/demande-search/image";

    private final Path baseImageDir;

    public ImageStorageService(@Value("${app.image.dir:demande-search/image}") String imageDir) {
        this.baseImageDir = Paths.get(imageDir).toAbsolutePath().normalize();
    }

    public String storeImageData(Long demandeId, String prefix, String dataUrl) throws IOException {
        if (demandeId == null) {
            throw new IllegalArgumentException("ID demande manquant.");
        }
        if (dataUrl == null || dataUrl.isBlank()) {
            throw new IllegalArgumentException("Image absente ou vide.");
        }

        DataUrlParts parts = parseDataUrl(dataUrl);
        byte[] bytes = Base64.getDecoder().decode(parts.base64Data);

        Path demandeDir = baseImageDir.resolve(String.valueOf(demandeId));
        Files.createDirectories(demandeDir);

        String extension = extensionForMime(parts.mimeType);
        String safePrefix = prefix == null ? "image" : prefix.replaceAll("[^A-Za-z0-9_-]", "_");
        String fileName = safePrefix + "_" + System.currentTimeMillis() + extension;
        Path targetPath = demandeDir.resolve(fileName);

        Files.write(targetPath, bytes);

        return URL_BASE + "/" + demandeId + "/" + fileName;
    }

    private DataUrlParts parseDataUrl(String dataUrl) {
        if (!dataUrl.startsWith(DATA_PREFIX)) {
            throw new IllegalArgumentException("Format d'image invalide.");
        }
        int commaIndex = dataUrl.indexOf(',');
        if (commaIndex < 0) {
            throw new IllegalArgumentException("Format d'image invalide.");
        }

        String header = dataUrl.substring(DATA_PREFIX.length(), commaIndex);
        if (!header.endsWith(BASE64_MARKER)) {
            throw new IllegalArgumentException("Format d'image invalide.");
        }

        String mimeType = header.substring(0, header.length() - BASE64_MARKER.length());
        String base64Data = dataUrl.substring(commaIndex + 1);
        if (mimeType.isBlank() || base64Data.isBlank()) {
            throw new IllegalArgumentException("Format d'image invalide.");
        }

        return new DataUrlParts(mimeType, base64Data);
    }

    private String extensionForMime(String mimeType) {
        if (mimeType == null) return ".png";
        switch (mimeType.toLowerCase()) {
            case "image/jpeg":
            case "image/jpg":
                return ".jpg";
            case "image/webp":
                return ".webp";
            case "image/png":
            default:
                return ".png";
        }
    }

    private static class DataUrlParts {
        private final String mimeType;
        private final String base64Data;

        private DataUrlParts(String mimeType, String base64Data) {
            this.mimeType = mimeType;
            this.base64Data = base64Data;
        }
    }
}
