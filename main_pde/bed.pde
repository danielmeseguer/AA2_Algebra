void drawCama() {
  pushMatrix();
  
  translate(camaPos.x, camaPos.y, camaPos.z);  // Movemos la escena de la cama a donde
  
  // Rotamos el modelo para que quede bien y le damos un tamaño y modelo
  rotateX(-PI/2);
  rotateY(PI);
  scale(escalaCama);
  shape(modeloCama);

  popMatrix();
}
