import React, { useRef, useState, useEffect } from 'react';

const SignatureMouse = ({ onValidate }) => {
  const canvasRef = useRef(null);
  const [isDrawing, setIsDrawing] = useState(false);
  const [signatureSrc, setSignatureSrc] = useState(null);

  // Configuration initiale du canvas
  useEffect(() => {
    const canvas = canvasRef.current;
    const ctx = canvas.getContext('2d');
    ctx.lineCap = 'round';
    ctx.strokeStyle = 'black';
    ctx.lineWidth = 2;
  }, []);

  // Commencer à dessiner (mousedown)
  const startDrawing = ({ nativeEvent }) => {
    const { offsetX, offsetY } = nativeEvent;
    const ctx = canvasRef.current.getContext('2d');
    ctx.beginPath();
    ctx.moveTo(offsetX, offsetY);
    setIsDrawing(true);
    setSignatureSrc(null);
  };

  // Dessiner (mousemove)
  const draw = ({ nativeEvent }) => {
    if (!isDrawing) return;
    const { offsetX, offsetY } = nativeEvent;
    const ctx = canvasRef.current.getContext('2d');
    ctx.lineTo(offsetX, offsetY);
    ctx.stroke();
  };

  // Arrêter de dessiner (mouseup / mouseleave)
  const stopDrawing = () => {
    const ctx = canvasRef.current.getContext('2d');
    ctx.closePath();
    setIsDrawing(false);
  };

  // Effacer le champ
  const clearCanvas = () => {
    const canvas = canvasRef.current;
    const ctx = canvas.getContext('2d');
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    setSignatureSrc(null);
    if (onValidate) onValidate(null);
  };

  const validateSignature = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const dataUrl = canvas.toDataURL('image/png');
    setSignatureSrc(dataUrl);
    if (onValidate) onValidate(dataUrl);
  };

  return (
    <div style={{ textAlign: 'center' }}>
      <h3>Signez avec votre souris</h3>
      <canvas
        onMouseDown={startDrawing}
        onMouseMove={draw}
        onMouseUp={stopDrawing}
        onMouseLeave={stopDrawing}
        ref={canvasRef}
        width={500}
        height={200}
        style={{
          border: '2px dashed #ccc',
          cursor: 'crosshair',
          backgroundColor: '#f9f9f9',
          borderRadius: '8px'
        }}
      />
      <div style={{ marginTop: '10px', display: 'flex', justifyContent: 'center', gap: '10px' }}>
        <button onClick={clearCanvas}>Réinitialiser</button>
        <button onClick={validateSignature}>Valider la signature</button>
      </div>
      {signatureSrc && (
        <div style={{ marginTop: '12px' }}>
          <div style={{ fontSize: '0.85rem', color: '#555', marginBottom: '6px' }}>
            Aperçu de la signature
          </div>
          <img
            src={signatureSrc}
            alt="Signature"
            style={{ maxWidth: '100%', border: '1px solid #e5e7eb', borderRadius: '6px' }}
          />
        </div>
      )}
    </div>
  );
};

export default SignatureMouse;

