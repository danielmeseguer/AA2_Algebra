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
    curveChange(0);
  }
  if (keyCode == RIGHT) {
    curveChange(1);
  }
  
  if (key == 'v' || key == 'V') vientoActivo = !vientoActivo;
  if (key == '+') fuerzaViento += 0.2;
  if (key == '-') {
    fuerzaViento -= 0.2;
    fuerzaViento = max(0, fuerzaViento);
  }
  
  if (key == 'f' || key == 'F') friccionActiva = !friccionActiva;
  if (key == 'q' || key == 'Q') coefFriccion += 0.01;
  if (key == 'e' || key == 'E') {
    coefFriccion -= 0.01;
    coefFriccion = max(0, coefFriccion);
  }
  
  if (key == '0') {
    modoControl = 0;
    obstaculoSeleccionado = -1;
  }
  
  if (key == '4') {
    modoControl = 1;
    obstaculoSeleccionado = 0;
  }
  
  if (key == '5') {
    modoControl = 1;
    obstaculoSeleccionado = 1;
  }
  
  if (key == '6') {
    modoControl = 1;
    obstaculoSeleccionado = 2;
  }
  
  if (key == '7') {
    modoControl = 1;
    obstaculoSeleccionado = 3;
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
