void dibujarPecera() {
  pushMatrix();

  float centroY = (MIN_Y + MAX_Y) / 2;
  translate(0, centroY, 0);

  stroke(255);
  noFill();

  box(TAM * 2, MAX_Y - MIN_Y, TAM * 2);

  popMatrix();
}

void dibujarSuelo() {
  fill(255, 255, 191);
  stroke(0);

  beginShape(QUADS);
  vertex(-TAM, ySuelo, -TAM);
  vertex( TAM, ySuelo, -TAM);
  vertex( TAM, ySuelo,  TAM);
  vertex(-TAM, ySuelo,  TAM);
  endShape();
}
