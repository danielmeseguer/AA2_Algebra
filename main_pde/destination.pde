void moverDestino() {
  if (vistaIsometrica){
  if (moverW) destino.z -= velocidadDestino;
  if (moverS) destino.z += velocidadDestino;
  if (moverA) destino.x -= velocidadDestino;
  if (moverD) destino.x += velocidadDestino;
  }else{
  if (moverW) destino.z += velocidadDestino;
  if (moverS) destino.z -= velocidadDestino;
  if (moverA) destino.x += velocidadDestino;
  if (moverD) destino.x -= velocidadDestino;
  }
  

  // Y menor = más arriba
  if (moverEspacio) destino.y -= velocidadDestino;
  if (moverShift) destino.y += velocidadDestino;

  limitarDestino();
}

void limitarDestino() {
  destino.x = constrain(destino.x, MIN_X + radioDestino, MAX_X - radioDestino);
  destino.y = constrain(destino.y, MIN_Y + radioDestino, MAX_Y - radioDestino);
  destino.z = constrain(destino.z, MIN_Z + radioDestino, MAX_Z - radioDestino);
}

void dibujarDestino() {
  pushMatrix();
  translate(destino.x, destino.y, destino.z);

  noStroke();
  fill(255, 80, 80);
  sphere(radioDestino);

  popMatrix();
}
