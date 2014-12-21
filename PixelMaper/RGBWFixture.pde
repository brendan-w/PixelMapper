/*
 * Simple square fixture
 * Represents the segments of an LEDBar
 */

public class RGBWFixture extends Fixture
{

  protected color c;
  protected float white;

  public RGBWFixture(int _universe, int _address, Point _point)
  {
    super(_universe, _address, 4, new Rectangle(_point.x, _point.y, 1, 1));
  }

  public void compute()
  {
    //do video reading and channel setting here

      //get video color based on rectangle
    c = video.pixels[rect.y*width+rect.x];

    //set channel values
    channels[0] = ((c >> 16) & 0xFF);  //Red
    channels[1] = ((c >> 8) & 0xFF);  //Green
    channels[2] = (c & 0xFF);  //Blue

    //derive white color
    float max = max(max(channels[0], channels[1]), channels[2]);
    float min = min(min(channels[0], channels[1]), channels[2]);
    float saturation = (max-min)/max;
    if (max == 0) {
      saturation = 0;
    }
    white = max*(1-saturation);
    channels[3] = int(white);

    //draw locator
    if (overlays) {
      ellipseMode(CENTER);
      fill(channels[0], channels[1], channels[2]);
      stroke(255-channels[0], 255-channels[1], 255-channels[2]);
      ellipse(rect.x, rect.y, 10, 10);

      //noFill();
      //stroke(128, 255, 0);
      //ellipse(rect.x, rect.y, 50, 50);
    }
  }
}

