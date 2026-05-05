class Obstaculo {
  PVector pos;
  float radio;

  Obstaculo(float x, float y, float z, float r) {
    pos = new PVector(x, y, z);
    radio = r;
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);

    fill(120, 80, 50);
    stroke(40);
    sphere(radio);

    popMatrix();
  }
}

void drawObstaculos() {
  for (int i = 0; i < obstaculos.length; i++) {
    obstaculos[i].display();
  }
}
