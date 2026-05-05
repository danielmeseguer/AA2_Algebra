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
  
  float energia;
  float cansancio;
  boolean isSleepy;
  
  float cooldownReproduccion;
  
  boolean isFishy;
  float velocidadCrecimiento;

  Pez(float x, float y, float z, boolean lider, boolean fishy) {
    pos = new PVector(x, y, z);
    oldPos = pos.copy();
    acc = new PVector(0, 0, 0);
    escalaObjetivo = random(2,3.3);
    cooldownReproduccion = 0;
    
    if(!fishy) escala = escalaObjetivo;
    else escala = 0.5;
    velocidadCrecimiento = 0.0005;
    masa = 1.0;
    esLider = lider;

    pesoLider = random(0.8, 1.2);
    pesoDestino = random(0.2, 0.8);
    
    offsetLider = PVector.random3D();
    offsetLider.mult(random(15, 35)); 
    
    energia = random(40, 200);
    cansancio = random(0.005, 0.12);
    isSleepy = false;
  }

  void setPosition(PVector nuevaPos) {
    oldPos = pos.copy();
    pos = nuevaPos.copy();
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    
    PVector vel = PVector.sub(pos, oldPos);

    if (vel.mag() > 0.001) {
      float yaw = atan2(vel.x, vel.z);
      float pitch = -asin(vel.y / vel.mag());
  
      rotateY(yaw);
      rotateX(pitch);
    }
    
    growUp();
    scale(escala);
    
    rotateY(-PI);
    rotateX(-PI);

    shape(modeloPez[0]);

    popMatrix();
  }
  
  void growUp() {
    if (escala < escalaObjetivo) {
      escala += velocidadCrecimiento;
  
      if (escala > escalaObjetivo) {
        escala = escalaObjetivo;
      }
    }
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
