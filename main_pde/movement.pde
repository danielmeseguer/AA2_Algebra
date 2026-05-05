void updateBoid(Pez pez) {
  if (pez.esLider) return;
  
  if (pez.cooldownReproduccion > 0) {
    pez.cooldownReproduccion = pez.cooldownReproduccion - 0.1f;
  }
  
  actualizarSleep(pez);

  if (pez.isSleepy) {
    aplicarFuerza(pez, seguirObjetivo(pez, camaPos, 1.0));
    aplicarFuerza(pez, fuerzaEvitarObstaculos(pez));
    aplicarFuerza(pez, fuerzaBordes(pez));
  
    float distanciaCama = PVector.dist(pez.pos, camaPos);
  
    if (distanciaCama < radioCama * 1.5) {
      aplicarFriccionExtra(pez, 0.25);
    }
  
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

  PVector objetivoLider = PVector.add(peces[0].pos, pez.offsetLider);
  
  aplicarFuerza(pez, seguirObjetivo(pez, objetivoLider, pez.pesoLider));
  aplicarFuerza(pez, seguirObjetivo(pez, destino, pez.pesoDestino));
  aplicarFuerza(pez, fuerzaGrupo(pez));
  aplicarFuerza(pez, fuerzaOrbital(pez));
  aplicarFuerza(pez, fuerzaBordes(pez));
  aplicarFuerza(pez, fuerzaEvitarObstaculos(pez));

  if (vientoActivo) {
    PVector fViento = viento.copy();
    fViento.mult(fuerzaViento);
    aplicarFuerza(pez, fViento);
  }

  if (friccionActiva) {
    aplicarFriccion(pez);
  }

  moverVerlet(pez);
}

void aplicarFuerza(Pez pez, PVector fuerza) {
  PVector f = fuerza.copy();
  f.div(pez.masa);
  pez.acc.add(f);
}

PVector seguirObjetivo(Pez pez, PVector objetivo, float peso) {
  PVector direccion = PVector.sub(objetivo, pez.pos);
  float distancia = direccion.mag();

  if (distancia < 0.001) {
    return new PVector(0, 0, 0);
  }

  direccion.normalize();

  float factor = 1.0;
  if (distancia < radioFrenado) {
    factor = map(distancia, 0, radioFrenado, 0.2, 1); // mínimo 0.2
  }

  direccion.mult(peso * factor);
  return direccion;
}

void aplicarFriccion(Pez pez) {
  PVector velocidad = PVector.sub(pez.pos, pez.oldPos);

  PVector friccion = velocidad.copy();
  friccion.mult(-coefFriccion);

  aplicarFuerza(pez, friccion);
}

void moverVerlet(Pez pez) {
  float dt = 0.32;

  PVector temp = pez.pos.copy();
  PVector velocidad = PVector.sub(pez.pos, pez.oldPos);

  if (velocidad.mag() > maxVelPez) {
    velocidad.normalize();
    velocidad.mult(maxVelPez);
  }

  pez.pos.add(velocidad);
  pez.pos.add(PVector.mult(pez.acc, dt * dt));

  pez.pos.x = constrain(pez.pos.x, MIN_X + 10, MAX_X - 10);
  pez.pos.y = constrain(pez.pos.y, MIN_Y + 10, MAX_Y - 10);
  pez.pos.z = constrain(pez.pos.z, MIN_Z + 10, MAX_Z - 10);

  pez.oldPos = temp;
  pez.acc.mult(0);
}

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

PVector fuerzaOrbital(Pez pez) {
  PVector haciaLider = PVector.sub(peces[0].pos, pez.pos);

  if (haciaLider.mag() < 0.001) {
    return new PVector(0, 0, 0);
  }

  haciaLider.normalize();

  PVector eje = new PVector(0, 1, 0);
  PVector tangente = haciaLider.cross(eje);

  if (tangente.mag() < 0.001) {
    return new PVector(0, 0, 0);
  }

  tangente.normalize();
  tangente.mult(0.035);

  return tangente;
}

PVector fuerzaEvitarObstaculos(Pez pez) {
  PVector total = new PVector();

  for (int i = 0; i < obstaculos.length; i++) {
    Obstaculo o = obstaculos[i];

    PVector dir = PVector.sub(pez.pos, o.pos);
    float distancia = dir.mag();
    float radioPez = 50;
    float rango = o.radio + radioPez + 60;

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
  PVector centro = new PVector();
  int contador = 0;

  float radioVecinos = 90;

  for (int i = 1; i < peces.length; i++) {
    Pez otro = peces[i];

    if (otro != null && otro != pez) {
      float d = PVector.dist(pez.pos, otro.pos);

      if (d < radioVecinos) {
        centro.add(otro.pos);
        contador++;
      }
    }
  }

  if (contador == 0) {
    return new PVector();
  }

  centro.div(contador);

  return seguirObjetivo(pez, centro, pesoGrupo);
}

void actualizarSleep(Pez pez) {
  pez.energia -= pez.cansancio;

  if (pez.energia <= 0) {
    pez.energia = 0;
    pez.isSleepy = true;
  }
}

void aplicarFriccionExtra(Pez pez, float cantidad) {
  PVector velocidad = PVector.sub(pez.pos, pez.oldPos);
  velocidad.mult(-cantidad);
  aplicarFuerza(pez, velocidad);
}
