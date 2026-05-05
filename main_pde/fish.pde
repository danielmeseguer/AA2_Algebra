class Pez {
  PVector offsetLider;  // Offset para que cada pez siga al lider con una separación distinta
  
  // Posición actual, anterior aceleración y masa
  PVector pos;
  PVector oldPos;
  PVector acc;
  float masa;
  
  float escala;  // Tamaño del pez
  boolean esLider;  // Sólo es true si el pez es el líder
  
  float pesoLider;  // Peso de la fuerza del líder
  float pesoDestino;  // Peso de la fuerza del destino
  
  float energia;  // Tiempo que está el pez antes de ir a descansar
  float cansancio;  // Cantidad de energía que gasta el pez cada frame
  boolean isSleepy;  // Si es true, el pez irá a descansar
  
  float cooldownReproduccion;  // Tiempo de espera para volver a procrear
  
  boolean isFishy;  // True si acaba de nacer
  float velocidadCrecimiento;  // Velocidad a la que el recién nacido crecerá

  // Constructor del pez
  Pez(float x, float y, float z, boolean lider, boolean fishy) {
    pos = new PVector(x, y, z);
    oldPos = pos.copy();
    acc = new PVector(0, 0, 0);
    masa = 1.0;
    
    // Tamaño aleatorizado, además si es recién nacido, el tamáño es reducido
    escalaObjetivo = random(2,3.3);    
    if(!fishy) escala = escalaObjetivo;
    else escala = 0.5;
    
    velocidadCrecimiento = 0.0005;
    
    esLider = lider;
    isFishy = fishy;
    
    cooldownReproduccion = 0;
    
    // Pesos aleatorios para que cada pez tenga un patrón distinto
    pesoLider = random(0.8, 1.2);
    pesoDestino = random(0.2, 0.8);
    
    // Posición relativa respecto al líder
    offsetLider = PVector.random3D();
    offsetLider.mult(random(15, 35)); 
    
    // Energía y cansancio aleatorizados
    energia = random(40, 200);
    cansancio = random(0.005, 0.12);
    isSleepy = false;
  }

  // Actualiza la posición manteniendo la anterior para calcular la dirección
  void setPosition(PVector nuevaPos) {
    oldPos = pos.copy();
    pos = nuevaPos.copy();
  }
  
  void display() {
    pushMatrix();
    
    translate(pos.x, pos.y, pos.z);  // Movemos la escena dónde se colocará el pez
    
    PVector dir = PVector.sub(pos, oldPos);  // Dirección del movimiento al calcular con Verlet

    if (dir.mag() > 0.001) {  // Sólo si la dirección del movimiento es mayor al umbral, para que no gire si está parado
      float yaw = atan2(dir.x, dir.z);  // atan2 nos da el ángulo en el plano XZ según la dirección de movimiento
      float pitch = -asin(dir.y / dir.mag());  // asin calcula la inclinación según la componente vertical del movimiento
      
      // Rotamos el modelo
      rotateY(yaw);
      rotateX(pitch);
    }
    
    growUp();  // Crecimiento progresivo si es una cría
    scale(escala);
    
    // Ajuste de rotación del modelo y modelo
    rotateY(-PI);
    rotateX(-PI);
    shape(modeloPez);

    popMatrix();
  }
  
  // Hace crecer el pez hasta llegar a su escala objetivo
  void growUp() {
    if (escala < escalaObjetivo) {
      escala += velocidadCrecimiento;
  
      if (escala > escalaObjetivo) {
        escala = escalaObjetivo;
      }
    }
  }
}

// Actualizamos las posiciones de los peces
void updateFishes() {
  for (int i = 1; i < peces.length; i++) {
    if (peces[i] != null) {
      updateBoid(peces[i]);
    }
  }
}

// Itera sobre todos los peces y los dibuja
void drawFishes() {
  for (int i = 0; i < peces.length; i++) {
    if (peces[i] != null) {
      peces[i].display();
    }
  }
}
