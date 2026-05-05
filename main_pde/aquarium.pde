void drawPecera() {
  pushMatrix();
  
  // Movemos el centro de la escena para centrar la pecera un poco abajo y se vea mejor
  float centroY = (MIN_Y + MAX_Y) / 2;
  translate(0, centroY, 0);

  stroke(255);  // Color blanco de línea
  noFill();  // Sin relleno

  box(TAM * 2, MAX_Y - MIN_Y, TAM * 2);  // Creamos la caja

  popMatrix();
}

void drawSuelo() {
  fill(255, 255, 191);  // Color del suelo
  stroke(0);
  
  // Dibujamos un plano con sus vertices
  beginShape(QUADS);  
  vertex(-TAM, ySuelo, -TAM);
  vertex( TAM, ySuelo, -TAM);
  vertex( TAM, ySuelo,  TAM);
  vertex(-TAM, ySuelo,  TAM);
  endShape();
}
