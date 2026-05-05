void initLeaderCurve() {
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
    new PVector(-180, 220, -120), // P0 inicio
    new PVector(-80,  210, -200), // P1
    new PVector(80,   210, -200), // P2
    new PVector(180,  220, -120), // P3

    new PVector(200,  240,  40),  // P4
    new PVector(80,   260,  180), // P5
    new PVector(-80,  260,  180), // P6

    new PVector(-200, 240,  40),  // P7
    new PVector(-220, 230, -60)   // P8
  };

  agregarCurva(puntos[0], puntos[1], puntos[2], puntos[3]);
  agregarCurva(puntos[3], puntos[4], puntos[5], puntos[6]);
  agregarCurva(puntos[6], puntos[7], puntos[8], puntos[0]);

  for (InterpolationCurve c : curvas) {
    c.calcularCoeficientes();
  }

  indiceCurvaLider = 0;
}

void agregarCurva(PVector p0, PVector p1, PVector p2, PVector p3) {
  PVector[] cp = {p0, p1, p2, p3};
  curvas.add(new InterpolationCurve(cp));
}

void initLeaderBezier() {
  PVector[] anchors = new PVector[4];
  PVector[] handlesOut = new PVector[4];
  PVector[] handlesIn = new PVector[4];

  anchors[0] = new PVector(-180, 140, -120);
  anchors[1] = new PVector(160, 90, -100);
  anchors[2] = new PVector(180, 170, 140);
  anchors[3] = new PVector(-150, 120, 160);

  float f = 0.4;

  handlesOut[0] = PVector.add(anchors[0], new PVector(120*f, 60*f, -80*f));
  handlesIn[0]  = PVector.add(anchors[0], new PVector(-120*f, -60*f, 80*f));

  handlesOut[1] = PVector.add(anchors[1], new PVector(80*f, -40*f, 120*f));
  handlesIn[1]  = PVector.add(anchors[1], new PVector(-80*f, 40*f, -120*f));

  handlesOut[2] = PVector.add(anchors[2], new PVector(-100*f, 60*f, 100*f));
  handlesIn[2]  = PVector.add(anchors[2], new PVector(100*f, -60*f, -100*f));

  handlesOut[3] = PVector.add(anchors[3], new PVector(-120*f, -40*f, -80*f));
  handlesIn[3]  = PVector.add(anchors[3], new PVector(120*f, 40*f, 80*f));

  bezierCurve = new BezierCurve(anchors, handlesOut, handlesIn);
}

void updateLeaderCurve() {
  if (peces == null || peces[0] == null) return;

  if (cambiandoCurva) {
    updateCurveTransition();
    return;
  }

  if (tipoCurva == 0) {
    uLider += velocidadInterpolacion;
  } else {
    uLider += velocidadBezier;
  }
  if (uLider > 1.0) {
  uLider = 0.0;

    if (tipoCurva == 0) {
      indiceCurvaLider++;
      if (indiceCurvaLider >= curvas.size()) {
        indiceCurvaLider = 0;
      }
    }
  }

  PVector p = null;

  if (tipoCurva == 0) {
  if (curvas == null || curvas.size() == 0) return;

  p = curvas.get(indiceCurvaLider).getPoint(uLider);
  } else {
    if (bezierCurve == null) return;
    p = bezierCurve.getPoint(uLider);
  }

  if (p != null) {
    PVector evitacion = fuerzaEvitarObstaculos(peces[0]);
    evitacion.mult(25);
    
    PVector posicionFinal = PVector.add(p, evitacion);
    peces[0].setPosition(posicionFinal);
  }
}

void drawLeaderCurve() {
  if (!mostrarCurva) return;

  if (tipoCurva == 0) {
    for (InterpolationCurve c : curvas) {
      c.displayCurve();
    }
  } else if (tipoCurva == 1 && bezierCurve != null) {
    bezierCurve.displayCurve();
  }
}

void curveChange(int nuevoTipoCurva) {
  if (nuevoTipoCurva == tipoCurva) return;

  PVector posicionActual = peces[0].pos.copy();

  tipoCurvaObjetivo = nuevoTipoCurva;

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

  PVector direccion = PVector.sub(objetivoCambioCurva, peces[0].pos);
  float distancia = direccion.mag();

  if (distancia < distanciaLlegadaTransicion) {
    peces[0].setPosition(objetivoCambioCurva);

    tipoCurva = tipoCurvaObjetivo;
    uLider = uObjetivoCambio;

    cambiandoCurva = false;
    return;
  }

  direccion.normalize();
  direccion.mult(velocidadTransicion);

  PVector nuevaPos = PVector.add(peces[0].pos, direccion);
  peces[0].setPosition(nuevaPos);
}
