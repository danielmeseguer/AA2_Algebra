void initLeaderCurve() {
  // Escoge que curva inicial hace según la asignada
  if (tipoCurva == 0) {
    initLeaderInterpolation();
  } else {
    initLeaderBezier();
  }

  uLider = 0.0;
  cambiandoCurva = false;
}

void initLeaderInterpolation() {
  curvas.clear();

  PVector[] puntos = {
    new PVector(-180, 220, -120), // P0
    new PVector(-80,  210, -200), // P1
    new PVector(80,   210, -200), // P2
    new PVector(180,  220, -120), // P3
    new PVector(200,  240,  40),  // P4
    new PVector(80,   260,  180), // P5
    new PVector(-80,  260,  180), // P6
    new PVector(-200, 240,  40),  // P7
    new PVector(-220, 230, -60)   // P8
  };
  // Creamos las distintas curvas de interpolación, creando un bucle
  agregarCurva(puntos[0], puntos[1], puntos[2], puntos[3]);
  agregarCurva(puntos[3], puntos[4], puntos[5], puntos[6]);
  agregarCurva(puntos[6], puntos[7], puntos[8], puntos[0]);
  
  // Calculamos los coeficientes de cada tramo
  for (InterpolationCurve c : curvas) {
    c.calcularCoeficientes();
  }
  
  indiceCurvaLider = 0;  // Empieza el recorrido en el primer tramo
}

void agregarCurva(PVector p0, PVector p1, PVector p2, PVector p3) {
  PVector[] cp = {p0, p1, p2, p3};  // Creamos un array de 4 puntos para definir un tramo
  curvas.add(new InterpolationCurve(cp));  // añadimos el tramo a la lista de curvas de interpolación
}

void initLeaderBezier() {
  PVector[] anchors = new PVector[4];
  PVector[] handlesOut = new PVector[4];
  PVector[] handlesIn = new PVector[4];

  anchors[0] = new PVector(-180, 140, -120);
  anchors[1] = new PVector(160, 90, -100);
  anchors[2] = new PVector(180, 170, 140);
  anchors[3] = new PVector(-150, 120, 160);
  
  float f = 0.4;  // Factor que controla la distancia de los handles respecto a los anclajes
  
  // Se crean puntos de control
  handlesOut[0] = PVector.add(anchors[0], new PVector(120*f, 60*f, -80*f));
  handlesIn[0]  = PVector.add(anchors[0], new PVector(-120*f, -60*f, 80*f));

  handlesOut[1] = PVector.add(anchors[1], new PVector(80*f, -40*f, 120*f));
  handlesIn[1]  = PVector.add(anchors[1], new PVector(-80*f, 40*f, -120*f));

  handlesOut[2] = PVector.add(anchors[2], new PVector(-100*f, 60*f, 100*f));
  handlesIn[2]  = PVector.add(anchors[2], new PVector(100*f, -60*f, -100*f));

  handlesOut[3] = PVector.add(anchors[3], new PVector(-120*f, -40*f, -80*f));
  handlesIn[3]  = PVector.add(anchors[3], new PVector(120*f, 40*f, 80*f));

  bezierCurve = new BezierCurve(anchors, handlesOut, handlesIn);  // Se crea una curva de bezier
}

void updateLeaderCurve() {
  if (peces == null || peces[0] == null) return;  // Si no hay líder no actualiza

  // Si cambia la curva, el líder se mueve hacia la nueva curva
  if (cambiandoCurva) {
    updateCurveTransition();
    return;
  }
  
  // La U se modifica según el tipo de curva, ya que con bezier vá mucho más rápido con la misma U
  if (tipoCurva == 0) {
    uLider += velocidadInterpolacion;
  } else {
    uLider += velocidadBezier;
  }
  
  // Si termina el tramo actual, reinicia la U
  if (uLider > 1.0) {
  uLider = 0.0;
    
    // Avanzamos tramos
    if (tipoCurva == 0) {
      indiceCurvaLider++;
      if (indiceCurvaLider >= curvas.size()) {
        indiceCurvaLider = 0;
      }
    }
  }

  PVector p = null;

  // Obtiene la posición del líder en la curva actual
  if (tipoCurva == 0) {
    if (curvas == null || curvas.size() == 0) return;
  
    p = curvas.get(indiceCurvaLider).getPoint(uLider);
  } else {
    if (bezierCurve == null) return;
    p = bezierCurve.getPoint(uLider);
  }
  // El líder evita obstáculos, se aplica como un desvío en la posición de la curva
  if (p != null) {
    PVector evitacion = fuerzaEvitarObstaculos(peces[0]);
    evitacion.mult(25);
    
    PVector posicionFinal = PVector.add(p, evitacion);
    peces[0].setPosition(posicionFinal);
  }
}

void drawLeaderCurve() {
  if (!mostrarCurva) return;

  // Dibuja la trayectoria de la curva activa
  if (tipoCurva == 0) {
    for (InterpolationCurve c : curvas) {
      c.displayCurve();
    }
  } else if (tipoCurva == 1 && bezierCurve != null) {
    bezierCurve.displayCurve();
  }
}

void curveChange(int nuevoTipoCurva) {
  if (nuevoTipoCurva == tipoCurva) return;  // Si la curva no cambia, retorna

  PVector posicionActual = peces[0].pos.copy();  // Guarda la posición del líder

  tipoCurvaObjetivo = nuevoTipoCurva;  // Guardamos el tipo de curva que tenemos como objetivo
  
  // Busca el punto más cercano a la posición actual y pone cambiandoCurva en true
  if (nuevoTipoCurva == 0) {
    initLeaderInterpolation();
    uObjetivoCambio = getClosestUInterpolation(posicionActual);
    objetivoCambioCurva = curvas.get(indiceCurvaLider).getPoint(uObjetivoCambio).copy();
  } else {
    initLeaderBezier();
    uObjetivoCambio = getClosestUBezier(posicionActual);
    objetivoCambioCurva = bezierCurve.getPoint(uObjetivoCambio).copy();
  }

  cambiandoCurva = true;
}

float getClosestUInterpolation(PVector objetivo) {
  float mejorU = 0.0;
  float mejorDist = Float.MAX_VALUE;
  // Recorre todos los tramos de interpolación y encuentra el punto más cercano al que moverse
  for (int i = 0; i < curvas.size(); i++) {
    for (float u = 0.0; u <= 1.0; u += 0.005) {
      PVector p = curvas.get(i).getPoint(u);
      float d = PVector.dist(objetivo, p);
  
      if (d < mejorDist) {
        mejorDist = d;
        mejorU = u;
        indiceCurvaLider = i;
      }
    }
  }
  return mejorU;
}

float getClosestUBezier(PVector objetivo) {
  float mejorU = 0.0;
  float mejorDist = Float.MAX_VALUE;
  // Recorre toda la curva de bézier y encuentra el punto más cercano al que moverse
  for (float u = 0.0; u <= 1.0; u += 0.005) {
    PVector p = bezierCurve.getPoint(u);
    float d = PVector.dist(objetivo, p);

    if (d < mejorDist) {
      mejorDist = d;
      mejorU = u;
    }
  }

  return mejorU;
}

void updateCurveTransition() {
  if (!cambiandoCurva) return;
  
  // Vector desde la posición actual del líder hasta el punto objetivo
  PVector direccion = PVector.sub(objetivoCambioCurva, peces[0].pos);
  float distancia = direccion.mag();
  
  // Si ya estamos cerca, termina la transición
  if (distancia < distanciaLlegadaTransicion) {
    peces[0].setPosition(objetivoCambioCurva);

    tipoCurva = tipoCurvaObjetivo;
    uLider = uObjetivoCambio;

    cambiandoCurva = false;
    return;
  }

  direccion.normalize();  // Normaliza la dirección para mantener la velocidad constante
  direccion.mult(velocidadTransicion);  // Aplicamos la velocidad de transmisión
  
  // Mueve al líder al punto más cercano de la nueva curva
  PVector nuevaPos = PVector.add(peces[0].pos, direccion);
  peces[0].setPosition(nuevaPos);
}
