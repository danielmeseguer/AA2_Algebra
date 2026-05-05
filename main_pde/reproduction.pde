void comprobarProcreacion() {
  for (int i = 1; i < peces.length; i++) {
    Pez a = peces[i];
    if (a == null || a.cooldownReproduccion > 0) continue;

    if (!a.isSleepy) continue;
    if (PVector.dist(a.pos, camaPos) > radioCama) continue;

    for (int j = i + 1; j < peces.length; j++) {
      Pez b = peces[j];
      if (b == null || b.cooldownReproduccion > 0) continue;

      if (!b.isSleepy) continue;
      if (PVector.dist(b.pos, camaPos) > radioCama) continue;

      float d = PVector.dist(a.pos, b.pos);

      if (d < distanciaProcrear) {
        crearNuevoPez(camaPos.copy());

        a.cooldownReproduccion = 600;
        b.cooldownReproduccion = 600;

        return;
      }
    }
  }
}


void crearNuevoPez(PVector posNacimiento) {
  for (int i = 1; i < peces.length; i++) {
    if (peces[i] == null) {
      PVector p = posNacimiento.copy();
      p.x += random(-20, 20);
      p.z += random(-20, 20);
      p.y -= 20;

      peces[i] = new Pez(p.x, p.y, p.z, false, true);
      println("Nuevo pez nacido en indice " + i);
      return;
    }
  }

  println("No hay espacio para mas peces");
}
