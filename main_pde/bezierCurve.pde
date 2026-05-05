class BezierCurve {
  PVector[] anchors;  // Puntos de anclaje de la curva
  PVector[] handlesOut;  // Puntos de control de salida
  PVector[] handlesIn;  // Puntos de control de entrada

  BezierCurve(PVector[] anchors_, PVector[] handlesOut_, PVector[] handlesIn_) {
    anchors = new PVector[anchors_.length];
    handlesOut = new PVector[handlesOut_.length];
    handlesIn = new PVector[handlesIn_.length];
    
    // Copiamos puntos para no modificar la array original
    for (int i = 0; i < anchors.length; i++) {
      anchors[i] = anchors_[i].copy();
      handlesOut[i] = handlesOut_[i].copy();
      handlesIn[i] = handlesIn_[i].copy();
    }
  }

  PVector getPoint(float uGlobal) {
    int numSegments = anchors.length;  // Tramos de la curva cerrada

    float scaledU = uGlobal * numSegments;  // Convertimos la U (representa el progreso de la curva) global a un valor escalado que recorre todos los tramos de la curva
    int segment = floor(scaledU);  // Obtenemos en qué tramo estamos con la parte entera del número
    
    // Corregimos el segmento para que no se salga del array
    if (segment >= numSegments) {
      segment = numSegments - 1;
    }
  
    float u = scaledU - segment;  // Calcula la U local

    int next = (segment + 1) % numSegments;  // Calcula el siguiente anchor, usando módulo para que se cierre la curva ya que tras el último va el primero
    
    PVector p0 = anchors[segment];  // Punto inicial del tramo
    PVector p1 = handlesOut[segment];  // Define hacia donde sale la curva
    PVector p2 = handlesIn[next];  // Define cómo entra la curva
    PVector p3 = anchors[next];  // Punto final del tramo

    return cubicBezierPoint(p0, p1, p2, p3, u);
  }

  PVector cubicBezierPoint(PVector p0, PVector p1, PVector p2, PVector p3, float u) {
    float oneMinusU = 1.0 - u;  // Calculamos 1 - u, que el el progreso de la curva a la inversa y se utiliza mucho en la fórmula
    
    // Los pesos que tendrá cada punto en función de la u
    float b0 = oneMinusU * oneMinusU * oneMinusU;  // Peso del punto inicial
    float b1 = 3.0 * oneMinusU * oneMinusU * u;  // Peso del primer punto de control
    float b2 = 3.0 * oneMinusU * u * u;  // Peso del segundo punto de control
    float b3 = u * u * u;  // Peso del punto final

    // CAlculamos cada coordenada como la combinación de los pesos de los puntos
    PVector p = new PVector();
    p.x = b0*p0.x + b1*p1.x + b2*p2.x + b3*p3.x;
    p.y = b0*p0.y + b1*p1.y + b2*p2.y + b3*p3.y;
    p.z = b0*p0.z + b1*p1.z + b2*p2.z + b3*p3.z;

    return p;  // Devuelve el vector
  }

  void displayCurve() {
    // Dibujamos las líneas de la curva en magenta
    strokeWeight(3);
    stroke(255, 0, 255);
    noFill();

    beginShape();
    // Recorremos toda la curva cerrada
    for (float u = 0.0; u <= 1.0; u += 0.005) {
      PVector p = getPoint(u);
      vertex(p.x, p.y, p.z);
    }
    endShape(CLOSE);

    // Dibujamos los puntos de anclaje en amarillo
    strokeWeight(8);
    stroke(255, 255, 0);
    for (int i = 0; i < anchors.length; i++) {
      point(anchors[i].x, anchors[i].y, anchors[i].z);
    }

    // Dibujamos los puntos de control y la linea del punto de anclaje a esta en naranja
    strokeWeight(5);
    stroke(255, 120, 0);
    for (int i = 0; i < anchors.length; i++) {
      point(handlesOut[i].x, handlesOut[i].y, handlesOut[i].z);
      point(handlesIn[i].x, handlesIn[i].y, handlesIn[i].z);

      strokeWeight(1);
      line(anchors[i].x, anchors[i].y, anchors[i].z,
           handlesOut[i].x, handlesOut[i].y, handlesOut[i].z);

      line(anchors[i].x, anchors[i].y, anchors[i].z,
           handlesIn[i].x, handlesIn[i].y, handlesIn[i].z);

      strokeWeight(5);
      stroke(255, 120, 0);
    }
  }
}
