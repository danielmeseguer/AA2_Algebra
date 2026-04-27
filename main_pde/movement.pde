void updateBoid(Pez pez) {
  if (pez.esLider) return;

  PVector objetivoLider = PVector.add(peces[0].pos, pez.offsetLider);
  
  aplicarFuerza(pez, seguirObjetivo(pez, objetivoLider, pez.pesoLider));
  aplicarFuerza(pez, seguirObjetivo(pez, destino, pez.pesoDestino));
  aplicarFuerza(pez, fuerzaOrbital(pez));
  aplicarFuerza(pez, fuerzaBordes(pez));

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
  float dt = 0.2;

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
