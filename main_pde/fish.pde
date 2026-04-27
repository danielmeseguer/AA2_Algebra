class Pez {
  PVector pos;
  float escala;
  boolean esLider;

  Pez(float x, float y, float z, boolean lider) {
    pos = new PVector(x, y, z);
    escala = 5;
    esLider = lider;
  }

  void setPosition(PVector nuevaPos) {
    pos = nuevaPos.copy();
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);

    scale(escala);

    rotateY(-PI);
    rotateX(-PI);

    shape(modeloPez[0]);

    popMatrix();
  }
}

void drawFishes() {
  for (int i = 0; i < peces.length; i++) {
    if (peces[i] != null) {
      peces[i].display();
    }
  }
}
