void updateBoid(Pez pez) {
  if (pez.esLider) return;  // El líder hace otro movimiento
  
  // Baja el cooldown de reproducción
  if (pez.cooldownReproduccion > 0) {
    pez.cooldownReproduccion = pez.cooldownReproduccion - 0.1f;
  }
  
  actualizarSleep(pez);  // Actualiza la energía del pez
  
  // Si el pez tiene sueño, toma la decisión de ir a dormir, ignorando el destino, el resto de peces y al pez líder, pero si evita obstáculos y los bordes de la pantalla
  if (pez.isSleepy) {
    aplicarFuerza(pez, seguirObjetivo(pez, camaPos, 1.0));
    aplicarFuerza(pez, fuerzaEvitarObstaculos(pez));
    aplicarFuerza(pez, fuerzaBordes(pez));
  
    float distanciaCama = PVector.dist(pez.pos, camaPos);
  
     // Si está cerca de la cama, aumenta la fricción para evitar rebotes
    if (distanciaCama < radioCama * 1.5) {
      aplicarFriccionExtra(pez, 0.25);
    }
    
    // Si entra en el radio de descanso, recupera energía
    if (distanciaCama < radioCama) {
      pez.energia += 0.4;
  
      aplicarFriccionExtra(pez, 0.4);
  
      if (pez.energia >= 100) {
        pez.energia = 100;
        pez.isSleepy = false;
      }
    }
  
    if (friccionActiva) {
      aplicarFriccion(pez);
    }
  
    moverVerlet(pez);
    return;
  }
  
  PVector objetivoLider = PVector.add(peces[0].pos, pez.offsetLider);  // Objetivo individual del líder
  
  // Fuerzas principales del comporta boid
  aplicarFuerza(pez, seguirObjetivo(pez, objetivoLider, pez.pesoLider));
  aplicarFuerza(pez, seguirObjetivo(pez, destino, pez.pesoDestino));
  aplicarFuerza(pez, fuerzaGrupo(pez));
  aplicarFuerza(pez, fuerzaBordes(pez));
  aplicarFuerza(pez, fuerzaEvitarObstaculos(pez));
  
  // Fuerza del viento (Corriente)
  if (vientoActivo) {
    PVector fViento = viento.copy();
    fViento.mult(fuerzaViento);
    aplicarFuerza(pez, fViento);
  }
  
  // Fuerza de fricción
  if (friccionActiva) {
    aplicarFriccion(pez);
  }

  moverVerlet(pez);
}

void aplicarFuerza(Pez pez, PVector fuerza) { 
  PVector f = fuerza.copy();  // Vector de fuerza
  f.div(pez.masa);  // Lo dividimos entre la masa para obtener la aceleración
  pez.acc.add(f);  // Aplica la aceleración al pez
}

PVector seguirObjetivo(Pez pez, PVector objetivo, float peso) {
  PVector direccion = PVector.sub(objetivo, pez.pos);  // Vector desde el pez hasta el objetivo
  float distancia = direccion.mag();

  if (distancia < 0.001) {
    return new PVector(0, 0, 0);
  }

  direccion.normalize();  // Nos quedamos con la dirección

  // Frenado suave si está cerca
  float factor = 1.0;
  if (distancia < radioFrenado) {
    factor = map(distancia, 0, radioFrenado, 0.2, 1);
  }

  direccion.mult(peso * factor);  // El peso decide la importancia del objetivo
  return direccion;
}

void aplicarFriccion(Pez pez) {
  PVector velocidad = PVector.sub(pez.pos, pez.oldPos);  // Velocidad = posición actual - anterior

  // La fricción va en sentido contrario a la velocidad
  PVector friccion = velocidad.copy();  
  friccion.mult(-coefFriccion);

  aplicarFuerza(pez, friccion);
}

void moverVerlet(Pez pez) {
  float dt = 0.32;

  PVector temp = pez.pos.copy();  // Guarda la posición antes de actualizar
  PVector velocidad = PVector.sub(pez.pos, pez.oldPos);
  
  // Se limita la velocidad máxima
  if (velocidad.mag() > maxVelPez) {
    velocidad.normalize();
    velocidad.mult(maxVelPez);
  }
  
  // Movemos al pez con verlet
  pez.pos.add(velocidad);
  pez.pos.add(PVector.mult(pez.acc, dt * dt));

  // Evita que el pez se salga de la pecera
  pez.pos.x = constrain(pez.pos.x, MIN_X + 10, MAX_X - 10);
  pez.pos.y = constrain(pez.pos.y, MIN_Y + 10, MAX_Y - 10);
  pez.pos.z = constrain(pez.pos.z, MIN_Z + 10, MAX_Z - 10);

  pez.oldPos = temp;
  
  pez.acc.mult(0);  // Resetea la aceleración acumulada
}

// Fuerza preventiva para que no toque los bordes
PVector fuerzaBordes(Pez pez) {
  float margen = 80;
  float fuerza = 0.8;

  PVector f = new PVector(0, 0, 0);

  if (pez.pos.x < MIN_X + margen) f.x += fuerza;
  if (pez.pos.x > MAX_X - margen) f.x -= fuerza;

  if (pez.pos.y < MIN_Y + margen) f.y += fuerza;
  if (pez.pos.y > MAX_Y - margen) f.y -= fuerza;

  if (pez.pos.z < MIN_Z + margen) f.z += fuerza;
  if (pez.pos.z > MAX_Z - margen) f.z -= fuerza;

  return f;
}


PVector fuerzaEvitarObstaculos(Pez pez) {
  PVector total = new PVector();

  for (int i = 0; i < obstaculos.length; i++) {
    Obstaculo o = obstaculos[i];

    PVector dir = PVector.sub(pez.pos, o.pos);  // Dirección del obstáculo al pez
    float distancia = dir.mag();  // Distancia entre estos dos
    float radioPez = 50;
    float rango = o.radio + radioPez + 60;  // Ajustamos algo el rango ya que el modelo del pez es más grande que como tal radio
    
    // Cuanto más cerca esté mayor es la fuerza de repulsión
    if (distancia < rango && distancia > 0.001) {
      dir.normalize();

      float intensidad = map(distancia, 0, rango, 1.5, 0);
      dir.mult(intensidad);

      total.add(dir);
    }
  }

  return total;
}

PVector fuerzaGrupo(Pez pez) {
  PVector centro = new PVector(); // Vector con el punto centro medio
  int contador = 0;  // Cuenta cuantos peces vecinos hay

  float radioVecinos = 90;  // Radio para encontrar vecinos

  // Recorremos todos los peces del sistema, sin contar el que movemos
  for (int i = 1; i < peces.length; i++) {
    Pez otro = peces[i];

    if (otro != null && otro != pez) {
      float d = PVector.dist(pez.pos, otro.pos);  // Distancia entre pez actual y el otro
      
      // Si está dentro del radio, se suma al centro
      if (d < radioVecinos) {
        centro.add(otro.pos);
        contador++;
      }
    }
  }
  // Si no hay vecinos, no aplicamos fuerza
  if (contador == 0) {
    return new PVector();
  }

  centro.div(contador);  // Dividimos el total de los centros entre sus integrantes dandonos el centro de masas

  return seguirObjetivo(pez, centro, pesoGrupo);  // Generamos una fuerza hacia este centro de masas
}

void actualizarSleep(Pez pez) {
  pez.energia -= pez.cansancio;  // Baja la energía según el cansancio del pez
  
  // Si se queda sin energía, entra en modo sueño y va a dormir
  if (pez.energia <= 0) {
    pez.energia = 0;
    pez.isSleepy = true;
  }
}

// Fricción extra para que al llegar a la cama no se pase de largo
void aplicarFriccionExtra(Pez pez, float cantidad) {
  PVector velocidad = PVector.sub(pez.pos, pez.oldPos);
  velocidad.mult(-cantidad);
  aplicarFuerza(pez, velocidad);
}
