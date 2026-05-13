import React, { useRef, useState, useCallback } from 'react';
import Webcam from 'react-webcam';

const CameraCapture = ({ onValidate }) => {
  const webcamRef = useRef(null);
  const [imgSrc, setImgSrc] = useState(null);
  const [isValidated, setIsValidated] = useState(false);

  // Fonction pour prendre la photo
  const capture = useCallback(() => {
    const imageSrc = webcamRef.current.getScreenshot();
    setImgSrc(imageSrc);
    setIsValidated(false);
    if (onValidate) onValidate(null);
  }, [webcamRef]);

  // Fonction pour recommencer
  const retake = () => {
    setImgSrc(null);
    setIsValidated(false);
    if (onValidate) onValidate(null);
  };

  const validatePhoto = () => {
    if (!imgSrc) return;
    setIsValidated(true);
    if (onValidate) onValidate(imgSrc);
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '15px' }}>
      <h3>Capture Photo</h3>

      {!imgSrc ? (
        // Si aucune photo n'est prise, on affiche la webcam
        <>
          <Webcam
            audio={false}
            ref={webcamRef}
            screenshotFormat="image/jpeg"
            videoConstraints={{ facingMode: "user" }} // "user" pour caméra frontale, "environment" pour arrière
            style={{ borderRadius: '10px', width: '100%', maxWidth: '400px' }}
          />
          <button onClick={capture} style={btnStyle}>Prendre la photo</button>
        </>
      ) : (
        // Si une photo est prise, on affiche l'aperçu
        <>
          <img src={imgSrc} alt="Capture" style={{ borderRadius: '10px', maxWidth: '400px' }} />
          <div style={{ display: 'flex', gap: '10px' }}>
            <button onClick={retake} style={{ ...btnStyle, backgroundColor: '#ff4444' }}>
              Refaire
            </button>
            <button onClick={validatePhoto} style={btnStyle}>
              Valider la photo
            </button>
          </div>
          {isValidated && (
            <div style={{ fontSize: '0.85rem', color: '#2e7d32' }}>
              Photo validée
            </div>
          )}
        </>
      )}
    </div>
  );
};

// Petit style rapide pour les boutons
const btnStyle = {
  padding: '10px 20px',
  fontSize: '16px',
  cursor: 'pointer',
  backgroundColor: '#007bff',
  color: 'white',
  border: 'none',
  borderRadius: '5px'
};

export default CameraCapture;