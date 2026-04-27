class BezierCurve {
  PVector[] anchors;
  PVector[] handlesOut;
  PVector[] handlesIn;

  BezierCurve(PVector[] anchors_, PVector[] handlesOut_, PVector[] handlesIn_) {
    anchors = new PVector[anchors_.length];
    handlesOut = new PVector[handlesOut_.length];
    handlesIn = new PVector[handlesIn_.length];

    for (int i = 0; i < anchors.length; i++) {
      anchors[i] = anchors_[i].copy();
      handlesOut[i] = handlesOut_[i].copy();
      handlesIn[i] = handlesIn_[i].copy();
    }
  }

  PVector getPoint(float uGlobal) {
    int numSegments = anchors.length;

    float scaledU = uGlobal * numSegments;
    int segment = floor(scaledU);

    if (segment >= numSegments) {
      segment = numSegments - 1;
    }

    float u = scaledU - segment;

    int next = (segment + 1) % numSegments;

    PVector p0 = anchors[segment];
    PVector p1 = handlesOut[segment];
    PVector p2 = handlesIn[next];
    PVector p3 = anchors[next];

    return cubicBezierPoint(p0, p1, p2, p3, u);
  }

  PVector cubicBezierPoint(PVector p0, PVector p1, PVector p2, PVector p3, float u) {
    float oneMinusU = 1.0 - u;

    float b0 = oneMinusU * oneMinusU * oneMinusU;
    float b1 = 3.0 * oneMinusU * oneMinusU * u;
    float b2 = 3.0 * oneMinusU * u * u;
    float b3 = u * u * u;

    PVector p = new PVector();
    p.x = b0*p0.x + b1*p1.x + b2*p2.x + b3*p3.x;
    p.y = b0*p0.y + b1*p1.y + b2*p2.y + b3*p3.y;
    p.z = b0*p0.z + b1*p1.z + b2*p2.z + b3*p3.z;

    return p;
  }

  void displayCurve() {
    strokeWeight(3);
    stroke(255, 0, 255);
    noFill();

    beginShape();
    for (float u = 0.0; u <= 1.0; u += 0.005) {
      PVector p = getPoint(u);
      vertex(p.x, p.y, p.z);
    }
    endShape(CLOSE);

    // anchors
    strokeWeight(8);
    stroke(255, 255, 0);
    for (int i = 0; i < anchors.length; i++) {
      point(anchors[i].x, anchors[i].y, anchors[i].z);
    }

    // handles
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
