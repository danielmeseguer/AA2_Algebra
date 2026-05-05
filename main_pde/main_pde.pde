void setup() {
  // Tamaño de ventana y render 3D
  size(900, 700, P3D);
  surface.setLocation(100, 100);

  // Inicializar destino que influencia el movimiento de los peces
  destino = new PVector(0, 100, 0);
  
  // Cargamos modelos 3D
  modeloPez = loadShape("fish.obj");
  
  modeloCama = loadShape("bed.obj");
  
  //  Creamos la posición de la cama en la pecera, dónde los peces irán a dormir y reproducirse
  camaPos = new PVector(MAX_X - 100, MAX_Y - 20, MIN_Z + 100);
  
  //  Inicializamos los obstáculos en pantalla
  obstaculos = new Obstaculo[numObstaculos];
  
  obstaculos[0] = new Obstaculo(-120, 220, -60, 35);
  obstaculos[1] = new Obstaculo(100, 230, -120, 40);
  obstaculos[2] = new Obstaculo(140, 240, 90, 30);
  obstaculos[3] = new Obstaculo(-90, 210, 120, 45);
  
  // Inicializamos una array de peces
  peces = new Pez[maxPeces];
  
  // Creamos al líder y lo ponemos a hacer su trayecto en curva
  peces[0] = new Pez(0, 150, 0, true, false);
  initLeaderCurve();

  // Creamos el resto de peces
  for (int i = 1; i < numPeces; i++) {
    float x = (0);
    float y = (150);
    float z = (0);

    peces[i] = new Pez(x, y, z, false, false);
  }
  
  
}

void draw() {
  // Fondo y luces para los modelos
  background(66, 86, 148);
  ambientLight(120, 120, 120);
  directionalLight(255, 255, 255, -1, -1, -1);

  // Selección de cámara
  if (vistaIsometrica) {
    camaraIsometrica();
  } else {
    camaraSuperior();
  }
  
  moverDestino();  // Movimiento del destino
  updateLeaderCurve();  // Curva del líder
  updateFishes();  // Movimiento de los peces
  comprobarProcreacion();  // Comprobar si los peces se reproducen
  
  // Dibujo de entorno
  drawPecera();
  drawSuelo();
  
  drawDestino();  // Dibujo de destino
  drawLeaderCurve();    // Dibujo de las curvas del líder
  drawFishes();  // Dibujo de los peces
  drawObstaculos();  // Dibujo  de los obstáculos en la pecera
  drawCama();  // Dibujo de la cama
  
  drawHUD();  // Dibujo del HUD con los controles
}
