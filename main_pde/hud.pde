void dibujarHUD() {
  hint(DISABLE_DEPTH_TEST);
  camera();

  fill(0, 150);
  noStroke();
  rect(5, 5, 250, 500);

  fill(255);
  textSize(14);
  textAlign(LEFT, TOP);
  
  String nombreCurva = (tipoCurva == 0) ? "Interpolacion" : "Bezier";
  String info = "";
  info += "CONTROLES:\n";
  info += "1 -> Vista isometrica\n";
  info += "2 -> Vista superior\n\n";

  info += "MOVER DESTINO:\n";
  info += "W A S D -> mover en plano\n";
  info += "ESPACIO -> subir\n";
  info += "SHIFT -> bajar\n\n";
  
  info += "FISICA:\n";
  info += "V -> viento: " + (vientoActivo ? "ON" : "OFF") + "\n";
  info += "+ / - -> viento: " + nf(fuerzaViento, 1, 2) + "\n";
  info += "F -> friccion: " + (friccionActiva ? "ON" : "OFF") + "\n";
  info += "Q / E -> friccion: " + nf(coefFriccion, 1, 2) + "\n\n";

  info += "POSICION DESTINO:\n";
  info += "X,Y,Z: (" + nf(destino.x, 1, 0) + ",";
  info += nf(destino.y, 1, 0) + ",";
  info += nf(destino.z, 1, 0) + ")\n\n";
  
  info += "CURVA ACTIVA:\n";
  info += "LEFT / RIGHT -> cambiar curva\n";
  info += nombreCurva + "\n";
  

  text(info, 15, 15);

  hint(ENABLE_DEPTH_TEST);
}
