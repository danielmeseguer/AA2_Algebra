void drawHUD() {
  hint(DISABLE_DEPTH_TEST);  // Desactivamos la profundidad para que el HUD se vea sobre el 3D
  camera();  // Reiniciamos cámara
  
  //  Panel de HUD
  fill(0, 150);
  noStroke();
  rect(5, 5, 250, 500);
  
  // Letras del HUD
  fill(255);
  textSize(14);
  textAlign(LEFT, TOP);
  
  //Info visible en el HUD
  String nombreCurva = (tipoCurva == 0) ? "Interpolacion" : "Bezier";
  String info = "";
  info += "CONTROLES:\n";
  info += "1 -> Vista isometrica\n";
  info += "2 -> Vista superior\n\n";
  
  info += "\nCONTROL ACTUAL: ";
  if (modoControl == 0) {
    info += "  Destino\n";
  } else {
    info += "  Obstaculo " + (obstaculoSeleccionado + 1) + "\n";
  }
  
  info += "0 -> escoger destino\n";
  info += "4/5/6/7 -> escoger obstaculos\n\n";

  info += "MOVER DESTINO/OBSTÁCULOS:\n";
  info += "W A S D -> mover en plano\n";
  info += "ESPACIO -> subir\n";
  info += "SHIFT -> bajar\n\n";
  
  info += "FÍSICA:\n";
  info += "V -> corriente: " + (vientoActivo ? "ON" : "OFF") + "\n";
  info += "- / + -> corriente: " + nf(fuerzaViento, 1, 2) + "\n";
  info += "F -> friccion: " + (friccionActiva ? "ON" : "OFF") + "\n";
  info += "Q / E -> friccion: " + nf(coefFriccion, 1, 2) + "\n\n";

  info += "POSICION DESTINO:\n";
  info += "X,Y,Z: (" + nf(destino.x, 1, 0) + ",";
  info += nf(destino.y, 1, 0) + ",";
  info += nf(destino.z, 1, 0) + ")\n\n";
  
  info += "CURVA ACTIVA:\n";
  info += "LEFT / RIGHT -> cambiar curva\n";
  info += nombreCurva + "\n";
  
  text(info, 15, 15);  // Dibuja el texto en la esquina superior izquierda

  hint(ENABLE_DEPTH_TEST);  // Reactivamos profundidad
}
