class Obstaculo {
  PVector pos;  // Posición
  float radio;  // Radio

  // Constructor
  Obstaculo(float x, float y, float z, float r) {
    pos = new PVector(x, y, z);
    radio = r;
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);  // Posicionamos la escena donde queremos crear el obstaculo
    
    // Color y forma al obstáculo
    fill(120, 80, 50);
    noStroke();
    sphere(radio);

    popMatrix();
  }
}

// Itera sobre el array de obstáculos y los muestra en pantalla
void drawObstaculos() {
  for (int i = 0; i < obstaculos.length; i++) {
    obstaculos[i].display();
  }
}
