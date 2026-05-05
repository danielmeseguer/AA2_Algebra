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

// obstaculos
Obstaculo[] obstaculos;
int numObstaculos = 4;

int obstaculoSeleccionado = -1;

// destino
PVector destino;
float velocidadDestino = 4;
float radioDestino = 15;

// cama
PVector camaPos;
PShape modeloCama;
float escalaCama = 0.30;
float radioCama = 60;

// teclas de control
int modoControl = 0; // 0 = destino, 1 = obstaculo
boolean moverW = false;
boolean moverA = false;
boolean moverS = false;
boolean moverD = false;
boolean moverEspacio = false;
boolean moverShift = false;

// Peces
Pez[] peces;
int numPeces = 20;
PShape modeloPez;
float escalaObjetivo;

// Curvas del Líder
int tipoCurva = 0; // 0 = interpolacion, 1 = bezier
InterpolationCurve interpolationCurve;
BezierCurve bezierCurve;

ArrayList<PVector> puntosControl = new ArrayList<PVector>();
ArrayList<InterpolationCurve> curvas = new ArrayList<InterpolationCurve>();

int indiceCurvaLider = 0;

PVector[] controlPoints;
float uLider = 0.0;
float velocidadInterpolacion = 0.002;
float velocidadBezier = 0.0008;

boolean mostrarCurva = true;
boolean cambiandoCurva = false;

PVector objetivoCambioCurva;
float uObjetivoCambio = 0.0;
int tipoCurvaObjetivo = 0;

float velocidadTransicion = 1.5;
float distanciaLlegadaTransicion = 5.0;

// Movimiento de los peces
PVector viento = new PVector(0.2, 0, 0);

boolean vientoActivo = true;
boolean friccionActiva = true;

float maxVelPez = 1.6;
float radioFrenado = 50.0;
float fuerzaViento = 1.0;
float coefFriccion = 0.04;
float pesoGrupo = 0.1;

//Procreación de peces
int maxPeces = 400;
int contadorProcreacion = 0;
int tiempoProcrear = 180;
float distanciaProcrear = 35;
