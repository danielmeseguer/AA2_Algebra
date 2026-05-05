void camaraIsometrica() {
  float d = 500;  // Distancia de la cámara al centro

  float angY = PI/4;  // Rotación horizontal
  float angX = PI/6;  // Rotación vertical

  // Punto al que mira la cámara
  float cx = 0;
  float cy = 150;
  float cz = 0;

  // Cálculo de la posición de la cámara utilizando trigonometría
  float ex = cx + d * cos(angX) * cos(angY);
  float ey = cy - d * sin(angX);
  float ez = cz + d * cos(angX) * sin(angY);
  
  camera(ex, ey, ez,  // Posición de la cámara
         cx, cy, cz,  // Posición a la que mira la cámara
         0, 1, 0);    // El vector de arriba es la Y positiva
}

void camaraSuperior() {
  // Punto al que mira la cámara
  float cx = 0;
  float cy = 150;  // 150 ya que la pecera no está en 0 exactamente y queda mejor así
  float cz = 0;

  float altura = 800;

  camera(cx, cy - altura, cz,   // Posición de la cámara
         cx, cy, cz,            // Posición a la que mira la cámara     
         0, 0, 1);              // El vector arriba es la Z positiva
}
