void drawCama() {
  pushMatrix();
  translate(camaPos.x, camaPos.y, camaPos.z);
  
  rotateX(-PI/2);
  rotateY(PI);
  scale(escalaCama);
  
  shape(modeloCama);

  popMatrix();
}
