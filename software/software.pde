import de.voidplus.leapmotion.*;
import processing.serial.*;

Serial myPort;

LeapMotion leap;
GridManager panel;

boolean first = true;
int numberX = 24;
int numberY = 29;
float unitSizeX;
float unitSizeY;

void setup()
{
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 115200);
  fullScreen();
  unitSizeX = width / numberX;
  unitSizeY = height / numberY;
  leap = new LeapMotion(this);
  panel = new GridManager(unitSizeX,unitSizeY);
  drawGrid();
}

void draw()
{
  panel.tick();
  for (Hand hand : leap.getHands ()) {
    PVector indexTip = hand.getIndexFinger().getRawPositionOfJointTip();
    if(indexTip.z < 0)
    {
      sendFill(int(nf(map(indexTip.x, -200, 200, 0, width), 0, 1)),int(nf(map(indexTip.y, 400, 100, height, 0), 0, 1)));
      panel.updateGrid(map(indexTip.x, -200, 200, 0, width), map(indexTip.y, 100, 400, height, 0));
    }
  }
  drawGrid();
}

void drawGrid()
{
  for(int i = 0; i < 696; i++)
  {
    if(panel.getCell(i).getState())
    {
      fill(255);
    }
    else
    {
      fill(0);
    }
    rect(panel.getCell(i).getPos(true),panel.getCell(i).getPos(false),unitSizeX,unitSizeY);
  }
}

void send()
{
  for(int i = 0; i < 696; i++)
  {
    if(panel.getCell(i).getChanged())
    {
      panel.getCell(i).setChanged(false);
      String s = str(i);
      if (s.length() == 1)
        s = "00" + s;
       if (s.length() == 2)
         s = "0" + s;
      println(s);
      myPort.write(s);
  }
  first = false;
  }
}

void sendFill(float x, float y)
{
     x =   x / unitSizeX;
     y = y / unitSizeY;

     delay(100);
    int i = int(x) * 24 + (int(y)*-1);
      String s = str(i);
      if (s.length() == 1)
        s = "00" + s;
       if (s.length() == 2)
         s = "0" + s;
      println(s);
      myPort.write(s);

}
