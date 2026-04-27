void keyPressed() {
  if (key == '1') vistaIsometrica = true;
  if (key == '2') vistaIsometrica = false;

  if (key == 'w' || key == 'W') moverW = true;
  if (key == 'a' || key == 'A') moverA = true;
  if (key == 's' || key == 'S') moverS = true;
  if (key == 'd' || key == 'D') moverD = true;

  if (key == ' ') moverEspacio = true;
  if (keyCode == SHIFT) moverShift = true;
  if (keyCode == LEFT) {
    solicitarCambioCurva(0);
  }
if (keyCode == RIGHT) {
    solicitarCambioCurva(1);
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') moverW = false;
  if (key == 'a' || key == 'A') moverA = false;
  if (key == 's' || key == 'S') moverS = false;
  if (key == 'd' || key == 'D') moverD = false;

  if (key == ' ') moverEspacio = false;
  if (keyCode == SHIFT) moverShift = false;
}
