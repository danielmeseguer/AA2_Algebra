void dibujarHUD() {
  hint(DISABLE_DEPTH_TEST);
  camera();

  fill(0, 150);
  noStroke();
  rect(5, 5, 250, 190);

  fill(255);
  textSize(14);
  textAlign(LEFT, TOP);
  
  String nombreCurva = (tipoCurva == 0) ? "Interpolacion" : "Bezier";
  String info = "";
  info += "CONTROLES:\n";
  info += "1 -> Vista isometrica\n";
  info += "2 -> Vista superior\n\n";

  info += "Mover destino:\n";
  info += "W A S D -> mover en plano\n";
  info += "ESPACIO -> subir\n";
  info += "SHIFT -> bajar\n\n";

  info += "POSICION DESTINO:\n";
  info += "X,Y,Z: (" + nf(destino.x, 1, 0) + ",";
  info += nf(destino.y, 1, 0) + ",";
  info += nf(destino.z, 1, 0) + ")";
  
  info += "\nCURVA ACTIVA:\n";
  info += nombreCurva + "\n";
  info += "LEFT / RIGHT -> cambiar curva\n";

  text(info, 15, 15);

  hint(ENABLE_DEPTH_TEST);
}
