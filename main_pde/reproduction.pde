void comprobarProcreacion() {
  // Itera sobre todos los peces exceptuando al líder
  for (int i = 1; i < peces.length; i++) {
    Pez a = peces[i];  // Primer pez
    if (a == null || a.cooldownReproduccion > 0) continue;  // Si es nulo o está en cooldown de reproducción, pasa al siguiente
    if (!a.isSleepy) continue;  // Si no tiene sueño, pasa al siguiente
    if (PVector.dist(a.pos, camaPos) > radioCama) continue;  // Si la distancia entre el pez y la cama es mayor a la del radio de la cama, no la está tocando, pasa al siguiente
    
    // Itera sobre los peces a partir del escogido
    for (int j = i + 1; j < peces.length; j++) {
      Pez b = peces[j];  // Segundo pez
      if (b == null || b.cooldownReproduccion > 0) continue;  // Si es nulo o está en cooldown de reproducción, pasa al siguiente
      if (!b.isSleepy) continue;// Si no tiene sueño, pasa al siguiente
      if (PVector.dist(b.pos, camaPos) > radioCama) continue;// Si la distancia entre el pez y la cama es mayor a la del radio de la cama, no la está tocando, pasa al siguiente

      float d = PVector.dist(a.pos, b.pos);  // Calcula la distancia entre peces
      
      // Si la distancia entre peces es menor a la distáncia mínima para procrear, crea un nuevo pez y asigna cooldown a los peces
      if (d < distanciaProcrear) {
        crearNuevoPez(camaPos.copy());

        a.cooldownReproduccion = 600;
        b.cooldownReproduccion = 600;

        return;
      }
    }
  }
}

// Mientras haya hueco en la pecera, crea un pez nuevo en la posición de la cama con la variable isFishy en true
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
