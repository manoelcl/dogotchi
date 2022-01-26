//ANDROID ACCELEROMETER



//3D MODEL
PShape doge;
int counter;
float ry=0;

//BACKGROUND COLOR
float currH, currB;
float nextH, nextB;
float easing = 0.001;
int lastChange = 0;

//TEXT
String wordList[];
ArrayList<String> stringArray = new ArrayList<String>();
ArrayList<PVector> stringPosition = new ArrayList<PVector>();
ArrayList<PVector> textColor = new ArrayList<PVector>();
PFont comicFont;

//SHADER
PShader fragment;
float effectTime;
float falseTime;

void setup(){
 
  
  effectTime=random(5000)+millis();

  fragment=loadShader("dogotchiScreen.glsl");
  wordList=loadStrings("https://manoelcl.github.io/dogeWordList/");
  fullScreen(P3D);
  colorMode(HSB, 100);
  counter=0;
  doge=loadShape("doge.obj");
  addTextElement();
  comicFont=createFont("comics.ttf", 128);

}

void draw(){
  
  background(currH, currB, 100);
  for (int i = 0; i < stringArray.size(); i++){
    textFont(comicFont);
    textSize(128);
    fill(textColor.get(i).x, textColor.get(i).y, 75);
    text(stringArray.get(i), stringPosition.get(i).x, stringPosition.get(i).y, -400);
  }

  if (3000 < millis() - lastChange) { 
    //pickNextColor();
    lastChange = millis();
    if (stringArray.size()<9){
      addTextElement();
    }else{
      removeTextElement();
    }
  }

  lights();
  translate(width/2, height/2+25*sin(3*quantizedTime(50)), 0);
  
  rotateZ(PI);
  float rot=180+.8*sin(quantizedTime(50));
  
  rotateY(rot);
  shape(doge);
  
  ry += 0.02;
  fragment.set("sketchSize", float(width), float(height));
  float numberColors=4;
  float resolution=6;
  fragment.set("u_numberColors", numberColors);
  
  fragment.set("u_resolution", resolution);
 
  fragment.set("u_time", falseTime);
  filter(fragment);
  if (falseTime>200){
    falseTime=0.0;
  }else{
    falseTime+=.1;
  }
}

void addTextElement(){
  stringArray.add(wordList[int(random(wordList.length))]);
  stringPosition.add(new PVector(random(width*.75),random(25+height*.85)));
  textColor.add(new PVector(random(100),random(100)));
}

void removeTextElement(){
  stringArray.remove(0);
  stringPosition.remove(0);
  textColor.remove(0);
}

float quantizedTime(float amount){
  float q = floor(float(millis()/1000)*amount)/amount;
  return q;
}
