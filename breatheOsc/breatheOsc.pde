import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(400, 400);
  frameRate(30);

  oscP5 = new OscP5(this, 8764); // IGNORE THIS
  myRemoteLocation = new NetAddress("127.0.0.1", 8765); // THIS IS THE PORT
}

boolean someoneHere = true;

void draw() {
  float t = millis() * 0.001;
  background(0);
  stroke(100, 0, 255);
  noFill();
  strokeWeight(4);
  pushMatrix();
  translate(width/2, height/2);
  rect(-50, -50, 100, 100);
  fill(150, 50, 255);
  textAlign(CENTER, CENTER);
  textSize(24);
  text(someoneHere ? "someone\nhere" : "no one\nhere", 0, 0);
  popMatrix();

  float inhale, exhale;
  inhale = 0;
  exhale = 0;
  float T = t / 2;
  if (T % 4 < 1) {
    // inhale
    inhale = map(cos(T * PI * 2), 1, -1, 0, 1);
  } else if (T % 4 < 2) {
    // none
  } else if (T % 4 < 3) {
    // exhale
    exhale = map(cos(T * PI * 2), 1, -1, 0, 1);
  }
  println(inhale,exhale);
  pushMatrix();
  fill(255);
  translate(0, 300);
  textAlign(LEFT, CENTER);
  text("inhale", 20, -5);
  stroke(255, 0, 0);
  line(120, 0, map(inhale, 0, 1, 120, 370), 0);
  translate(0, 50);
  text("exhale", 20, -5);
  stroke(0, 255, 0);
  line(120, 0, map(exhale, 0, 1, 120, 370), 0);
  popMatrix();

  {
    OscMessage m = new OscMessage("/presence");
    m.add(someoneHere ? 1 : 0);
    oscP5.send(m, myRemoteLocation);
  }
  {
    OscMessage m = new OscMessage("/chan");
    m.add(inhale);
    m.add(exhale);
    oscP5.send(m, myRemoteLocation);
  }
}

void mousePressed() {
  if (150<=mouseX && mouseX<=250 && 150<=mouseX && mouseX<=250) {
    someoneHere = !someoneHere;
  }
}
