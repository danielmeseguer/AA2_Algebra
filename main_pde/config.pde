// camara
boolean vistaIsometrica = true;

// pecera
float TAM = 300;
float ySuelo = 300;

float MIN_X = -TAM;
float MAX_X = TAM;

float MIN_Y = -100;
float MAX_Y = 300;

float MIN_Z = -TAM;
float MAX_Z = TAM;

// destino
PVector destino;
float velocidadDestino = 4;
float radioDestino = 15;

// teclas de movimiento
boolean moverW = false;
boolean moverA = false;
boolean moverS = false;
boolean moverD = false;
boolean moverEspacio = false;
boolean moverShift = false;

// Peces
Pez[] peces;
int numPeces = 200;
PShape[] modeloPez;

// Curvas del Líder
int tipoCurva = 0; // 0 = interpolacion, 1 = bezier
InterpolationCurve interpolationCurve;
BezierCurve bezierCurve;

ArrayList<PVector> puntosControl = new ArrayList<PVector>();
ArrayList<InterpolationCurve> curvas = new ArrayList<InterpolationCurve>();

int indiceCurvaLider = 0;

PVector[] controlPoints;
float uLider = 0.0;
float velocidadLider = 0.002;

boolean mostrarCurva = true;
boolean cambiandoCurva = false;

PVector objetivoCambioCurva;
float uObjetivoCambio = 0.0;
int tipoCurvaObjetivo = 0;

float velocidadTransicion = 2.5;
float distanciaLlegadaTransicion = 5.0;

// Movimiento de los peces
PVector viento = new PVector(0.2, 0, 0);

boolean vientoActivo = true;
boolean friccionActiva = true;

float maxVelPez = 3.0;
float radioFrenado = 50.0;
float fuerzaViento = 1.0;
float coefFriccion = 0.04;
