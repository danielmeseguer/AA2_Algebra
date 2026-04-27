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
    float x = (0);
    float y = (0);
    float z = (0);

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
  updateFishes();

  dibujarPecera();
  dibujarSuelo();
  dibujarDestino();
  
  drawLeaderCurve();
  drawFishes();
  
  dibujarHUD();
}
