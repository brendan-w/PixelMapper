/*
 * Simple square fixture
 * Represents the segments of an LEDBar
 */

public class RGBFixture extends Fixture
{
  protected color c;

  public RGBFixture(int _universe, int _address, Rectangle _rect)
  {
    super(_universe, _address, 3, _rect);
  }

  public void compute()
  {
    //do video reading and channel setting here
    c = video.pixels[rect.y*width+rect.x];

    //set channel values (GRB because the LED chips are like that)
    channels[1] = ((c >> 16) & 0xFF);  //Red
    channels[0] = ((c >> 8) & 0xFF);  //Green
    channels[2] =(c & 0xFF);  //Blue

    //draw locator
    if (overlays) {
      noStroke();
      //fill(channels[0],channels[1],channels[2]);
      fill(255-channels[0], 255-channels[1], 255-channels[2]);
      //rect(rect.x-3,rect.y-3,6,6);
      rect(rect.x, rect.y, 1, 1);
    }
  }
}

