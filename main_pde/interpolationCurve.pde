class InterpolationCurve {
  PVector[] controlPoints;  // Puntos por los que la curva debe pasar
  PVector[] coefficients;

  InterpolationCurve(PVector[] cp) {
    controlPoints = new PVector[4];
    coefficients = new PVector[4];

    for (int i = 0; i < 4; i++) {
      controlPoints[i] = cp[i];  // Guardamos los 4 puntos de interpolación
      coefficients[i] = new PVector();  // Reservamos espacio para cada coeficiente
    }
  }
  
  // Calcula los coeficientes
  void calcularCoeficientes() {
    // C0
    coefficients[0] = controlPoints[0].copy();

    // C1
    coefficients[1].x = -5.5*controlPoints[0].x + 9.0*controlPoints[1].x - 4.5*controlPoints[2].x + controlPoints[3].x;
    coefficients[1].y = -5.5*controlPoints[0].y + 9.0*controlPoints[1].y - 4.5*controlPoints[2].y + controlPoints[3].y;
    coefficients[1].z = -5.5*controlPoints[0].z + 9.0*controlPoints[1].z - 4.5*controlPoints[2].z + controlPoints[3].z;

    // C2
    coefficients[2].x = 9.0*controlPoints[0].x - 22.5*controlPoints[1].x + 18.0*controlPoints[2].x - 4.5*controlPoints[3].x;
    coefficients[2].y = 9.0*controlPoints[0].y - 22.5*controlPoints[1].y + 18.0*controlPoints[2].y - 4.5*controlPoints[3].y;
    coefficients[2].z = 9.0*controlPoints[0].z - 22.5*controlPoints[1].z + 18.0*controlPoints[2].z - 4.5*controlPoints[3].z;

    // C3
    coefficients[3].x = -4.5*controlPoints[0].x + 13.5*controlPoints[1].x - 13.5*controlPoints[2].x + 4.5*controlPoints[3].x;
    coefficients[3].y = -4.5*controlPoints[0].y + 13.5*controlPoints[1].y - 13.5*controlPoints[2].y + 4.5*controlPoints[3].y;
    coefficients[3].z = -4.5*controlPoints[0].z + 13.5*controlPoints[1].z - 13.5*controlPoints[2].z + 4.5*controlPoints[3].z;
  }

  PVector getPoint(float u) {
    PVector p = new PVector();
    
    // Valor del polinomio para cada cordenada
    p.x = coefficients[0].x + coefficients[1].x*u + coefficients[2].x*u*u + coefficients[3].x*u*u*u;
    p.y = coefficients[0].y + coefficients[1].y*u + coefficients[2].y*u*u + coefficients[3].y*u*u*u;
    p.z = coefficients[0].z + coefficients[1].z*u + coefficients[2].z*u*u + coefficients[3].z*u*u*u;

    return p;
  }

  void displayCurve() {
    //Dibuja la curva interpolada en verde
    strokeWeight(3);
    stroke(0, 255, 0);
    noFill();

    beginShape();
    for (float u = 0.0; u <= 1.0; u += 0.01) {
      PVector p = getPoint(u);
      vertex(p.x, p.y, p.z);
    }
    endShape();

    // Dibujamos los puntos de control en amarillo
    strokeWeight(8);
    stroke(255, 255, 0);
    for (int i = 0; i < 4; i++) {
      point(controlPoints[i].x, controlPoints[i].y, controlPoints[i].z);
    }
  }
}
