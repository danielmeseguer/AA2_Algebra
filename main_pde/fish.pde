class Pez {
  PVector offsetLider;
  PVector pos;
  PVector oldPos;
  PVector acc;
  float masa;
  
  float escala;
  boolean esLider;
  
  float pesoLider;
  float pesoDestino;

  Pez(float x, float y, float z, boolean lider) {
    pos = new PVector(x, y, z);
    oldPos = pos.copy();
    acc = new PVector(0, 0, 0);
    
    escala = 2;
    masa = 1.0;
    esLider = lider;

    pesoLider = random(0.8, 1.2);
    pesoDestino = random(0.5, 0.1);
    
    offsetLider = PVector.random3D();
    offsetLider.mult(random(15, 35)); 
  }

  void setPosition(PVector nuevaPos) {
    pos = nuevaPos.copy();
    oldPos = pos.copy();
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

void updateFishes() {
  for (int i = 1; i < peces.length; i++) {
    if (peces[i] != null) {
      updateBoid(peces[i]);
    }
  }
}

void drawFishes() {
  for (int i = 0; i < peces.length; i++) {
    if (peces[i] != null) {
      peces[i].display();
    }
  }
}
