<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Tabla de contenidos</summary>
  <ol>
    <li>
      <a href="#Autor">Autor</a>
    </li>
    <li>
      <a href="#Trabajo realizado">Trabajo realizado</a>
    </li>
    <li><a href="#decisiones-adoptadas">Decisiones adoptadas</a></li>
    <li><a href="#referencias">Referencias</a></li>
    <li><a href="#herramientas">Herramientas</a></li>
    <li><a href="#resultado">Resultado</a></li>
  </ol>
</details>




## Autor

El autor de este proyecto es el estudiante Alejandro Daniel Herrera Cárdenes para la asignatura Creando Interfaces de Usuario (CIU) para el profesor Modesto Fernando Castrillón Santana. 


## Trabajo realizado

El trabajo se basa en hacer usando la herramienta OpenCV situar enncima de la cabeza, ojos y boca un sombrero, gafas de sol y bigote respectivamente.

## Decisiones adoptadas

Las mayores decisiones tomadas y las que mas pruebas requirieron fue la colocación de los planetas y la iluminación.


* Metodos que manejan tanto la cámara como la iluminación.
  ```
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

 
 


## Referencias

Para ayudarme en la realización de esta aplicación usé la API que te proporciona [Processing](https://www.processing.org/).

* [Documentación de clase](https://ncvt-aep.ulpgc.es/cv/ulpgctp21/pluginfile.php/412240/mod_resource/content/40/CIU_Pr_cticas.pdf).

* [Processing](https://www.processing.org/)




## Resultado

Añado un GIF con el resultado de la aplicación final con el sistema planetario.

Al ir un poco lento de FPS para realizar el gif usé el programa [Gyazo](https://gyazo.com/) para que sea más visible el uso de la cámara. Se puede ver en el link a continuación. El video esta en la carpeta imágenes en caso de que el link no funcione.
* [Vídeo de la ejecución final](https://gyazo.com/fe843e34a0b2bb0985daa7e230e055d3).
