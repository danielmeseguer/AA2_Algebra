void camaraIsometrica() {
  float d = 600;

  float angY = PI/4;
  float angX = PI/6;

  float cx = 0;
  float cy = 150;
  float cz = 0;

  float ex = cx + d * cos(angX) * cos(angY);
  float ey = cy - d * sin(angX);
  float ez = cz + d * cos(angX) * sin(angY);

  camera(ex, ey, ez,
         cx, cy, cz,
         0, 1, 0);
}

void camaraSuperior() {
  float cx = 0;
  float cy = 150;
  float cz = 0;

  float altura = 800;

  camera(
    cx, cy - altura, cz,   
    cx, cy, cz,            
    0, 0, -1               
  );
}
