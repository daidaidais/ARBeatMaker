/**
 NyARToolkit for proce55ing/1.0.0
 (c)2008-2011 nyatla
 airmail(at)ebony.plala.or.jp
 
*/


import java.io.*; // for the loadPatternFilenames() function
import processing.video.*;
import jp.nyatla.nyar4psg.*;
import ddf.minim.*;
import pitaru.sonia_v2_9.*;
import processing.serial.*;

//Minim minim;
//AudioPlayer song1, song2;
Sample tune1, tune2, tune3, tune4, tune5;
//Serial myPort;

Capture cam;
MultiMarker nya;
static int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0, flag4 = 0, flag5 = 0;
static int para0 = 0, para1 = 0, para2 = 0, para3 = 0, para4 = 0, para5 = 0;
float[] matrix1 = new float[16];
float[] matrix2 = new float[16];
float[] matrix3 = new float[16];
float[] matrix4 = new float[16];
float[] matrix5 = new float[16];

float tempo1, tempo2, tempo3, tempo4, tempo5;

//String patternPath = "C:/Users/Daisuke/Documents/Processing/libraries/nyar4psg/patternMaker/examples/ARToolKit_Patterns";
String patternPath = "C:/Users/Daisuke/Documents/Processing/projects/pipeline2/beatmaker/data";
int numMarkers = 10;

int streamSize = 8192; // holds the streamSize value for the liveOutput.data[] array. 

float freq = 0.0;
float tempo = 0.0, out = 0.0;

String temp;

void setup() {
  size(640, 480, P3D);
  frame.setResizable(true);
  colorMode(RGB, 100);
  println(MultiMarker.VERSION);
  String[] devices = Capture.list();
  println(devices);
  cam=new Capture(this, 640, 480, "Logicool HD Webcam C615");
  //nya=new MultiMarker(this,width,height,"camera_para.dat",NyAR4PsgConfig.CONFIG_PSG);
  // setup serial port
  //myPort = new Serial(this, "COM3", 9600);


  //String[] patterns = loadPatternFilenames(patternPath);

  nya = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker(patternPath + "/patt.hiro", 80);
  nya.addARMarker(patternPath + "/patt.sample1", 80);
  nya.addARMarker(patternPath + "/patt.sample2", 80);
  nya.addARMarker(patternPath + "/patt.kanji", 80);
  nya.addARMarker(patternPath + "/patt.sacchi", 80);
  nya.addARMarker(patternPath + "/patt.jinja", 80);
  //nya.addARMarker(patternPath + "/" + patterns[1], 80);

  for (int j = 0; j < 15; j++) {
    matrix1[j] = 0; 
    matrix2[j] = 0;
    matrix3[j] = 0;
    matrix4[j] = 0;
    matrix5[j] = 0;
  }


  /*  
   for (int i = 0; i < numMarkers; i++){
   println(patterns[i]);
   nya = new MultiMarker(this,width,height,"camera_para.dat",NyAR4PsgConfig.CONFIG_PSG);
   nya.addARMarker(patternPath + "/" + patterns[i], 80);
   println(patterns[i] + " done");
   }
  */

  cam.start();

  /*
   minim = new Minim(this);
   song1 = minim.loadFile("./data/beat1.wav", 512);
   song2 = minim.loadFile("./data/effect1.wav", 512);
  */

  Sonia.start(this, 44100);
  tune1 = new Sample("./data/beat1.wav");
  tune2 = new Sample("./data/effect1.wav");
  tune3 = new Sample("./data/dubstep2.wav");
  tune4 = new Sample("./data/dubstep1.wav");
  tune5 = new Sample("./data/scratch1.wav");

  LiveOutput.start(streamSize, streamSize*2); // Start LiveOutput with a buffer. 
}

void draw()
{

  frame.setSize(640,480);
  
  if (cam.available() !=true) {
    return;
  }
  cam.read();
  nya.detect(cam);

  background(0);
  nya.drawBackground(cam);

  if ((!nya.isExistMarker(0))) {
    println("NO MARKER 0");
    tune1.stop();
    //song1.close();
    //song1 = minim.loadFile("./data/beat1.wav", 512);
    //return;
  }

  if ((!nya.isExistMarker(1))) {
    println("NO MARKER 1");
    //tune3.stop();
    LiveOutput.stopStream();
    flag1 = 0;
  }
  
  if ((!nya.isExistMarker(2))) {
    println("NO MARKER 2");
    tune3.stop();
    //song2.close();
    //song2 = minim.loadFile("./data/effect1.wav", 512);
    //return;
  }

  if ((!nya.isExistMarker(3))) {
    println("NO MARKER 3");
    tune2.stop();
    //song2.close();
    //song2 = minim.loadFile("./data/effect1.wav", 512);
    //return;
  }

  if ((!nya.isExistMarker(4))) {
    println("NO MARKER 4");
    tune4.stop();
    //song2.close();
    //song2 = minim.loadFile("./data/effect1.wav", 512);
    //return;
  }

  if ((!nya.isExistMarker(5))) {
    println("NO MARKER 5");
    tune5.stop();
    //song2.close();
    //song2 = minim.loadFile("./data/effect1.wav", 512);
    //return;
  }


  if ((nya.isExistMarker(0))) {

    nya.getMarkerMatrix(0).get(matrix1);
    //printArray(matrix1[0]);

    if (flag0 == 0) {
      tempo1 = map(matrix1[0], -1, 1, 0, 2.0);
      println("tempo0: " + tempo1);
      tune1.setSpeed(tempo1);
      tune1.play();
      //song1.play();
      flag0 = 1;
    }

    if (tune1.isPlaying() != true) {
      flag0 = 0;
      //tune1.rewind();
    }

    if(para0 <= 100){
      nya.beginTransform(0);
      fill(0, 0, 255);
      //translate(0, 0, 20);
      noStroke();
      ellipse(0, 0, 40+para0, 40 + para0);
      fill(255, 255, 255);
      rotateZ(90);
      textSize(30);
      translate(0, 0, 20);
      text(nf(120 * tempo1, 3, 1), 20, 20); // display the ID of the box in black text centered in the rectangle
      nya.endTransform();
      para0 += 1;
    }
    else{para0 = 0;}
  }
 

  if ((nya.isExistMarker(1))) {

    nya.getMarkerMatrix(1).get(matrix1);
    printArray("matrix1[0]: " + matrix1[0]);
    
    if(flag1 == 0){
     LiveOutput.startStream(); // Start the liveOutput stream, and activate the liveOutputEvent(){}
     flag1 = 1; 
    }


/*
    if (flag1 == 0) {
      float tempo3 = map(matrix2[0], -1, 1, 0, 2.0);
      tune3.setSpeed(tempo3);
      tune3.play();
      //song1.play();
      flag1 = 1;
    }

    if (tune3.isPlaying() != true) {
      flag1 = 0;
      //tune1.rewind();
    }
*/

    nya.beginTransform(1);
    fill(0, 255, 0);
    //translate(0, 0, 20);
    noStroke();
    ellipse(0, 0, freq * 4, freq * 4);
    fill(255, 255, 255);
    rotateZ(90);
    textSize(30);
    translate(0, 0, 20);
    text(nf(-freq, 3, 1), 20, 20); // display the ID of the box in black text centered in the rectangle
    nya.endTransform();
  }
  

  if ((nya.isExistMarker(2))) {

    nya.getMarkerMatrix(2).get(matrix2);
    //printArray(matrix1[0]);

    if (flag2 == 0) {
      tempo3 = map(matrix2[0], -1, 1, 0, 2.0);
      println("tempo3: " + tempo3);
      tune3.setSpeed(tempo3);
      tune3.play();
      //song1.play();
      flag2 = 1;
    }

    if (tune3.isPlaying() != true) {
      flag2 = 0;
      //tune1.rewind();
    }

    if(para2 <= 100){
      nya.beginTransform(2);
      fill(0, 255, 255);
      //translate(0, 0, 20);
      noStroke();
      ellipse(0, 0, 40+para2, 40 + para2);
      fill(255, 255, 255);
      rotateZ(90);
      textSize(30);
      translate(0, 0, 20);
      text(nf(120 * tempo3, 3, 1), 20, 20); // display the ID of the box in black text centered in the rectangle
      nya.endTransform();
      para2 += 1;
    }
    else{para2 = 0;}
  }



  if ((nya.isExistMarker(3))) {

    nya.getMarkerMatrix(3).get(matrix3);
    //printArray(matrix3[0]);

    if (flag3 == 0) {
      tempo2 = map(matrix3[0], -1, 1, 0, 2.0);
      tune2.setSpeed(tempo2);
      tune2.play();        
      //song2.play();
      flag3 = 1;
    }

    if (tune2.isPlaying() != true) {
      flag3 = 0;
      //song2.rewind();
    }

    if(para3 <= 100){
      nya.beginTransform(3);
      fill(255, 0, 0);
      //translate(0, 0, 20);
      noStroke();
      ellipse(0, 0, 40+para3, 40 + para3);
      fill(255, 255, 255);
      rotateZ(90);
      textSize(30);
      translate(0, 0, 20);
      text(nf(120 * tempo2, 3, 1), 20, 20); // display the ID of the box in black text centered in the rectangle
      nya.endTransform();
      para3 += 1;
    }
    else{para3 = 0;}
  }
  
  if ((nya.isExistMarker(4))) {

    nya.getMarkerMatrix(4).get(matrix4);
    //printArray(matrix3[0]);

    if (flag4 == 0) {
      tempo4 = map(matrix4[0], -1, 1, 0, 2.0);
      tune4.setSpeed(tempo4);
      tune4.play();        
      //song2.play();
      flag4 = 1;
    }

    if (tune4.isPlaying() != true) {
      flag4 = 0;
      //song2.rewind();
    }

    if(para4 <= 100){
      nya.beginTransform(4);
      fill(255, 255, 0);
      //translate(0, 0, 20);
      noStroke();
      ellipse(0, 0, 40+para4, 40 + para4);
      fill(255, 255, 255);
      rotateZ(90);
      textSize(30);
      translate(0, 0, 20);
      text(nf(120 * tempo4, 3, 1), 20, 20); // display the ID of the box in black text centered in the rectangle
      nya.endTransform();
      para4 += 1;
    }
    else{para4 = 0;}

  }

  if ((nya.isExistMarker(5))) {

    nya.getMarkerMatrix(5).get(matrix5);
    //printArray(matrix3[0]);

    if (flag5 == 0) {
      tempo5 = map(matrix5[0], -1, 1, 0, 2.0);
      tune5.setSpeed(tempo5);
      tune5.play();        
      //song2.play();
      flag5 = 1;
    }

    if (tune5.isPlaying() != true) {
      flag5 = 0;
      //song2.rewind();
    }

    if(para5 <= 100){
      nya.beginTransform(5);
      fill(255, 0, 255);
      //translate(0, 0, 20);
      noStroke();
      ellipse(0, 0, 40+para5, 40 + para5);
      fill(255, 255, 255);
      rotateZ(90);
      textSize(30);
      translate(0, 0, 20);
      text(nf(90 * tempo5, 3, 1), 20, 20); // display the ID of the box in black text centered in the rectangle
      nya.endTransform();
      para5 += 1;
    }
    else{para5 = 0;}

  }
  
}

void mousePressed() {
  //song1.play(); 
  //song1.rewind();
}

String[] loadPatternFilenames(String path) {
  File folder = new File(path);
  FilenameFilter pattFilter = new FilenameFilter() {
    public boolean accept(File dir, String name) {
      return name.toLowerCase().endsWith(".patt");
    }
  };
  return folder.list(pattFilter);
}

void liveOutputEvent() { 
  
  // Populate the LiveOutput.data[] data array with a sine-wave. 
  for (int i = 0; i < LiveOutput.data.length; i++) { 
    float oneCycle = TWO_PI/streamSize;
    //freq = map(matrix2[0], -1, 1, 0, 20);
    freq = matrix1[0] * 160;
    //freq = 10;
    float sinData = (freq*2) * oneCycle * i;
    LiveOutput.data[i] = sin(sinData);
  }
  
  println("liveOutput.data.length; " + LiveOutput.data.length);
  println("liveOutputEvent is activated, freq: " + freq);
} 


void serialEvent(Serial p) {
  //substitute x with the value read from serial
  temp = p.readStringUntil('\n');
}

