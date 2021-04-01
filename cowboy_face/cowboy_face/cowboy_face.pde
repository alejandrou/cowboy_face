import java.lang.*;
import processing.video.*;
import cvimage.*;
import org.opencv.core.*;
//Detectores
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.objdetect.Objdetect;

Capture cam;
CVImage img;

//Cascadas para detección
CascadeClassifier face,leye,reye, mouth;
//Nombres de modelos
String faceFile, leyeFile,reyeFile, mouthFile, glassesFile, moustacheFile, topHatFile;
//PShape filters
PImage glasses, moustache, top_hat;

void setup() {
  size(640, 480);
  //Cámara
  cam = new Capture(this, width , height);
  cam.start(); 
  
  //OpenCV
  //Carga biblioteca core de OpenCV
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  img = new CVImage(cam.width, cam.height);
  
  //Detectores
  faceFile = "haarcascade_frontalface_default.xml";
  leyeFile = "haarcascade_mcs_lefteye.xml";
  reyeFile = "haarcascade_mcs_righteye.xml";
  mouthFile = "mouth.xml";
  face = new CascadeClassifier(dataPath(faceFile));
  leye = new CascadeClassifier(dataPath(leyeFile));
  reye = new CascadeClassifier(dataPath(reyeFile));
  mouth = new CascadeClassifier(dataPath(mouthFile));
  
  loadShapes();
}


void loadShapes(){
  glassesFile = "glasses.png";
  moustacheFile = "moustache.png";
  topHatFile = "top_hat.png";
  glasses = loadImage(glassesFile);
  top_hat = loadImage(topHatFile);
  moustache = loadImage(moustacheFile);
}

void draw() {  
  if (cam.available()) {
    background(0);
    cam.read();
    
    //Obtiene la imagen de la cámara
    img.copy(cam, 0, 0, cam.width, cam.height, 
    0, 0, img.width, img.height);
    img.copyTo();
    
    //Imagen de grises
    Mat gris = img.getGrey();
    
    //Imagen de entrada
    image(img,0,0);
    
    //Detección y pintado de contenedores
    FaceDetect(gris);
    
    gris.release();
  }
}

void FaceDetect(Mat grey)
{
  Mat auxroi;
  
  //Detección de rostros
  MatOfRect faces = new MatOfRect();
  face.detectMultiScale(grey, faces, 1.15, 3, 
    Objdetect.CASCADE_SCALE_IMAGE, 
    new Size(60, 60), new Size(200, 200));
  Rect [] facesArr = faces.toArray();
  
  //Búsqueda de ojos
  MatOfRect leyes,reyes;
  for (Rect r : facesArr) {    
    //Izquierdo (en la imagen)
    leyes = new MatOfRect();
    Rect roi=new Rect(r.x,r.y,(int)(r.width*0.7),(int)(r.height*0.6));
    auxroi= new Mat(grey, roi);
    
    //Detecta
    leye.detectMultiScale(auxroi, leyes, 1.15, 3, 
    Objdetect.CASCADE_SCALE_IMAGE, 
    new Size(30, 30), new Size(200, 200));
    Rect [] leyesArr = leyes.toArray();
    
    leyes.release();
    auxroi.release(); 
     
     
    //Derecho (en la imagen)
    reyes = new MatOfRect();
    roi=new Rect(r.x+(int)(r.width*0.3),r.y,(int)(r.width*0.7),(int)(r.height*0.6));
    auxroi= new Mat(grey, roi);
    
    //Detecta
    reye.detectMultiScale(auxroi, reyes, 1.15, 3, 
    Objdetect.CASCADE_SCALE_IMAGE, 
    new Size(30, 30), new Size(200, 200));
    Rect [] reyesArr = reyes.toArray();
    
    reyes.release();
    auxroi.release();
    
    drawOutfit(leyesArr, reyesArr, r);
  }
  
  faces.release();
}

void drawOutfit(Rect[] leyes, Rect[] reyes, Rect face){
  Rect[][] pairs = getPairs(leyes, reyes, face);
  for (int i = 0; i < pairs.length; i++){
    if (pairs[i][0] != null){
      PImage aux = glasses.copy();
      Rect r = pairs[i][0];
      Rect l = pairs[i][1];
      int imgWidth = l.x + l.width + 40 - r.x;
      int imgHeight = r.height;
      aux.resize(imgWidth, imgHeight);
      image(aux, r.x - 10, r.y);
      
      aux = moustache.copy();
      int x = r.x + (int)(r.width *0.7);
      int xEnd = l.x + (int)(l.width * 0.8);
      imgWidth = xEnd - x;
      imgHeight = (int)(face.height * 0.2);
      aux.resize(imgWidth, imgHeight);
      int y = face.y + (int)(face.height * 0.65);
      image(aux, x, y);
    }
  }
  
  if (face != null){
    PImage aux = top_hat.copy();
    float resolution = (float)aux.width / (float)aux.height;
    int imgWidth = face.width;
    int imgHeight = face.height;
    aux.resize(imgWidth, imgHeight);
    image(aux, face.x, face.y - imgHeight);
  }
}

Rect[][] getPairs(Rect[] leyes, Rect[] reyes, Rect face){
  Rect[][] result = new Rect[leyes.length][2];
  
  if (reyes.length != leyes.length) return result;
  
  Rect[] rightCopy = new Rect[reyes.length];
  System.arraycopy(reyes,0,rightCopy,0,reyes.length);
  
  for (int i = 0; i < leyes.length; i++){
    Rect l = leyes[i];
    Integer minDist = null;
    Rect chosenRight = null;
    int lx = l.x + l.width;
    
    for (int j = 0; j < rightCopy.length; j++){
      Rect r = rightCopy[j];
      int rx = r.x + (int)(0.3 * face.width);
      if (minDist == null || minDist > rx - lx){
        minDist = rx - lx;
        chosenRight = r;
      }
    }
    
    if (chosenRight != null){
      result[i][0] = new Rect(l.x + face.x, l.y + face.y, l.width, l.height);
      result[i][1] = new Rect(chosenRight.x + face.x + (int)(0.3 * face.width),
                              chosenRight.y + face.y, chosenRight.width , chosenRight.height);
    }
  }
   
  return result;
}
