import java.lang.IllegalArgumentException;
import java.util.ArrayList;
import java.awt.Rectangle;
import java.awt.Point;
import processing.video.*;
import hypermedia.net.*;
import codeanticode.syphon.*;


public PImage video;
public SyphonClient syphon;
public ACNConnection acn;
public ArrayList<Fixture> fixtures;
public int[] res = {
  100, 100
};
public boolean overlays = true;

public void setup()
{
  size(res[0], res[1], P3D);
  colorMode(RGB, 255);
  background(0);
  frameRate(60);
  //syphon = new SyphonClient(this, "Arena", "Composition");
  syphon = new SyphonClient(this);

  acn = new ACNConnection(5);  //number of universes to make
  fixtures = new ArrayList<Fixture>();
  video = new PImage(res[0], res[1]);

                //Top Cans
    RGBWFixture parcan = new RGBWFixture(1, 1, new Point(5, 5));  fixtures.add(parcan);
                parcan = new RGBWFixture(1, 5, new Point(15, 5));  fixtures.add(parcan);
                parcan = new RGBWFixture(1, 9, new Point(25, 5));  fixtures.add(parcan);
                //
                parcan = new RGBWFixture(1, 13, new Point(65, 5));  fixtures.add(parcan);
                parcan = new RGBWFixture(1, 17, new Point(75, 5));  fixtures.add(parcan);
                parcan = new RGBWFixture(1, 21, new Point(85, 5));  fixtures.add(parcan);
                //
                //Bottom Cans
                parcan = new RGBWFixture(1, 25, new Point(5, 90));  fixtures.add(parcan);
                parcan = new RGBWFixture(1, 29, new Point(15, 90));  fixtures.add(parcan);
                parcan = new RGBWFixture(1, 33, new Point(25, 90));  fixtures.add(parcan);
                //
                parcan = new RGBWFixture(1, 37, new Point(35, 90));  fixtures.add(parcan);
                parcan = new RGBWFixture(1, 41, new Point(45, 90));  fixtures.add(parcan);
                parcan = new RGBWFixture(1, 45, new Point(55, 90));  fixtures.add(parcan);
                //
                parcan = new RGBWFixture(1, 49, new Point(65, 90));  fixtures.add(parcan);
                parcan = new RGBWFixture(1, 53, new Point(75, 90));  fixtures.add(parcan);
                parcan = new RGBWFixture(1, 57, new Point(85, 90));  fixtures.add(parcan);
                //
                //Front Cans
                parcan = new RGBWFixture(1, 61, new Point(35, 5));  fixtures.add(parcan);
                parcan = new RGBWFixture(1, 65, new Point(45, 5));  fixtures.add(parcan);
                parcan = new RGBWFixture(1, 69, new Point(55, 5));  fixtures.add(parcan);


    RGBBar bar = new RGBBar(1, 73,  new Rectangle(5 , 12, 0, 69), 70);  fixtures.add(bar);
           bar = new RGBBar(1, 285, new Rectangle(15, 12, 0, 69), 70);  fixtures.add(bar);
           bar = new RGBBar(2, 1,   new Rectangle(25, 12, 0, 69), 70);  fixtures.add(bar);
           bar = new RGBBar(2, 212, new Rectangle(35, 12, 0, 69), 70);  fixtures.add(bar);
           bar = new RGBBar(3, 1,   new Rectangle(45, 12, 0, 69), 70);  fixtures.add(bar);
           bar = new RGBBar(3, 212, new Rectangle(55, 12, 0, 69), 70);  fixtures.add(bar);
           bar = new RGBBar(4, 1,   new Rectangle(65, 12, 0, 69), 70);  fixtures.add(bar);
           bar = new RGBBar(4, 212, new Rectangle(75, 12, 0, 69), 70);  fixtures.add(bar);
           bar = new RGBBar(5, 1,   new Rectangle(85, 12, 0, 69), 70);  fixtures.add(bar);
           bar = new RGBBar(5, 212, new Rectangle(95, 12, 0, 69), 70);  fixtures.add(bar);
        
}

public void draw()
{
  //render the current frame of the video
  if (syphon.available()) {
    video = syphon.getImage(video); // load the pixels array with the updated image info (slow)
    if(overlays){image(video, 0, 0);}
  }

  //compute DMX
  for (Fixture f : fixtures)
  {
    f.compute();
    acn.commit(f);
  }

  acn.send();
}

