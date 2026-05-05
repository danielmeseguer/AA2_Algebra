void moverDestino() {
  PVector objetivo;  // Apunta al objeto controlado actualmente

  // Modo 0 = destino, Modo 1 = obstáculo
  if (modoControl == 0) {
    objetivo = destino;
  } else {
    if (obstaculoSeleccionado < 0 || obstaculoSeleccionado >= obstaculos.length) return;  // Si no hay un obstáculo bien seleccionado, retorna
    objetivo = obstaculos[obstaculoSeleccionado].pos;  // Se pone como objetivo el obstáculo seleccionado
  }
  
  // Movimiento en plano X Z
  if (moverW) objetivo.z -= velocidadDestino;
  if (moverS) objetivo.z += velocidadDestino;
  if (moverA) objetivo.x -= velocidadDestino;
  if (moverD) objetivo.x += velocidadDestino;
  

  // Movimiento en plano Y
  if (moverEspacio) objetivo.y -= velocidadDestino;
  if (moverShift) objetivo.y += velocidadDestino;
  
  limitarDestino(objetivo);  // Para que no salga de la pecera
}

void limitarDestino(PVector p) {
  float radio = radioDestino;  // Usamos el radio del destino por defecto

  if (modoControl == 1 && obstaculoSeleccionado >= 0) {  // Si hay un obstáculo seleccionado cambiamos el radio al del obstáculo
    radio = obstaculos[obstaculoSeleccionado].radio;
  }
  
  // Limitamos la posición teniendo en cuenta el radio del objetivo seleccionado
  p.x = constrain(p.x, MIN_X + radio, MAX_X - radio);
  p.y = constrain(p.y, MIN_Y + radio, MAX_Y - radio);
  p.z = constrain(p.z, MIN_Z + radio, MAX_Z - radio);
}

void drawDestino() {
  pushMatrix();
  translate(destino.x, destino.y, destino.z);  // Posicionamos la escena en el punto en el que queremos dibujar el destino

  // Dibujamos el destino
  noStroke();
  fill(255, 80, 80);
  sphere(radioDestino);

  popMatrix();
}
