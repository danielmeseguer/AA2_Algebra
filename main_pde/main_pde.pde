void setup() {
  size(900, 700, P3D);
  surface.setLocation(100, 100);

  destino = new PVector(0, 100, 0);
  
  modeloPez = new PShape[1];
  modeloPez[0] = loadShape("fish.obj");
  
  modeloCama = loadShape("bed.obj");
  
  camaPos = new PVector(MAX_X - 100, MAX_Y - 20, MIN_Z + 100);
  obstaculos = new Obstaculo[numObstaculos];
  
  obstaculos[0] = new Obstaculo(-120, 220, -60, 35);
  obstaculos[1] = new Obstaculo(100, 230, -120, 40);
  obstaculos[2] = new Obstaculo(140, 240, 90, 30);
  obstaculos[3] = new Obstaculo(-90, 210, 120, 45);
  
  peces = new Pez[maxPeces];
  
  peces[0] = new Pez(0, 150, 0, true, false);
  initLeaderCurve();

  for (int i = 1; i < numPeces; i++) {
    float x = (0);
    float y = (150);
    float z = (0);

    peces[i] = new Pez(x, y, z, false, false);
  }
  
  
}

void draw() {
  background(66, 86, 148);
  ambientLight(120, 120, 120);
  directionalLight(255, 255, 255, -1, -1, -1);

  if (vistaIsometrica) {
    camaraIsometrica();
  } else {
    camaraSuperior();
  }

  moverDestino();
  updateLeaderCurve();
  updateFishes();
  comprobarProcreacion();

  dibujarPecera();
  dibujarSuelo();
  dibujarDestino();
  
  
  drawLeaderCurve();
  drawFishes();
  drawObstaculos();
  drawCama();
  
  dibujarHUD();
}
