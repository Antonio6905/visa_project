package com.visa.example.service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;

/**
 * Service pour générer des codes QR
 */
@Service
public class QRCodeService {

    private final QRCodeWriter qrCodeWriter = new QRCodeWriter();
    private static final int WIDTH = 300;
    private static final int HEIGHT = 300;

    /**
     * Génère un code QR à partir d'une URL et le retourne en Base64
     *
     * @param url l'URL à encoder dans le QR code
     * @return le QR code en format Base64
     * @throws WriterException si la génération du QR code échoue
     * @throws IOException si l'encodage en image échoue
     */
    public String generateQRCodeBase64(String url) throws WriterException, IOException {
        // Créer la matrice du QR code
        BitMatrix bitMatrix = qrCodeWriter.encode(url, BarcodeFormat.QR_CODE, WIDTH, HEIGHT);

        // Convertir la matrice en image PNG
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        MatrixToImageWriter.writeToStream(bitMatrix, "PNG", outputStream);

        // Encoder en Base64
        byte[] imageBytes = outputStream.toByteArray();
        return Base64.getEncoder().encodeToString(imageBytes);
    }

    /**
     * Génère un code QR à partir d'une URL et le retourne en Base64 avec le data URI
     *
     * @param url l'URL à encoder dans le QR code
     * @return le QR code en format data URI
     */
    public String generateQRCodeDataURI(String url) {
        try {
            String base64 = generateQRCodeBase64(url);
            return "data:image/png;base64," + base64;
        } catch (WriterException | IOException e) {
            throw new RuntimeException("Erreur lors de la génération du QR code : " + e.getMessage(), e);
        }
    }
}
