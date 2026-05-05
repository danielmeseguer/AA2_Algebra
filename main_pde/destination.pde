void moverDestino() {
  PVector objetivo;

  if (modoControl == 0) {
    objetivo = destino;
  } else {
    if (obstaculoSeleccionado < 0 || obstaculoSeleccionado >= obstaculos.length) return;
    objetivo = obstaculos[obstaculoSeleccionado].pos;
  }
  
  if (vistaIsometrica){
  if (moverW) objetivo.z -= velocidadDestino;
  if (moverS) objetivo.z += velocidadDestino;
  if (moverA) objetivo.x -= velocidadDestino;
  if (moverD) objetivo.x += velocidadDestino;
  }else{
  if (moverW) objetivo.z += velocidadDestino;
  if (moverS) objetivo.z -= velocidadDestino;
  if (moverA) objetivo.x += velocidadDestino;
  if (moverD) objetivo.x -= velocidadDestino;
  }
  

  // Y menor = más arriba
  if (moverEspacio) objetivo.y -= velocidadDestino;
  if (moverShift) objetivo.y += velocidadDestino;

  limitarDestino(objetivo);
}

void limitarDestino(PVector p) {
  float radio = radioDestino;

  if (modoControl == 1 && obstaculoSeleccionado >= 0) {
    radio = obstaculos[obstaculoSeleccionado].radio;
  }

  p.x = constrain(p.x, MIN_X + radio, MAX_X - radio);
  p.y = constrain(p.y, MIN_Y + radio, MAX_Y - radio);
  p.z = constrain(p.z, MIN_Z + radio, MAX_Z - radio);
}

void dibujarDestino() {
  pushMatrix();
  translate(destino.x, destino.y, destino.z);

  noStroke();
  fill(255, 80, 80);
  sphere(radioDestino);

  popMatrix();
}
