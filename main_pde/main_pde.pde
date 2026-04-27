void setup() {
  size(900, 700, P3D);
  surface.setLocation(100, 100);

  destino = new PVector(0, 100, 0);
  modeloPez = new PShape[1];
  modeloPez[0] = loadShape("fish.obj");
  peces = new Pez[numPeces];
  
  peces[0] = new Pez(0, 150, 0, true);
  initLeaderCurve();

  for (int i = 1; i < numPeces; i++) {
    float x = random(MIN_X + 30, MAX_X - 30);
    float y = random(MIN_Y + 30, MAX_Y - 30);
    float z = random(MIN_Z + 30, MAX_Z - 30);

    peces[i] = new Pez(x, y, z, false);
  }
}

void draw() {
  background(66, 86, 148);
  lights();

  if (vistaIsometrica) {
    camaraIsometrica();
  } else {
    camaraSuperior();
  }

  moverDestino();
  updateLeaderCurve();

  dibujarPecera();
  dibujarSuelo();
  dibujarDestino();
  
  drawLeaderCurve();
  drawFishes();
  
  dibujarHUD();
}
