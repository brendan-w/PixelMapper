/*
 * Use this class when a fixture contains other fixtures (ie, pixels in an LEDBar)
 */

public abstract class ParentFixture extends Fixture
{
  protected Fixture[] children;
  protected int numChildren;

  public ParentFixture(int _universe, int _address, int _span, Rectangle _rect, int _numChildren)
  {
    super(_universe, _address, _span, _rect);
    numChildren = _numChildren;
    children = new Fixture[_numChildren];
    createChildren();
  }

  //require this method in the subclass
  public abstract void createChildren();

  //compute the children, and merge child DMX values into parent DMX values
  public void compute()
  {
    for (Fixture f : children)
    {
      if (f != null)
      {
        f.compute();

        int f_address    = f.getAddress();
        int[] f_channels = f.getChannels();

        //addresses are stored as relative offsets from the parent
        for (int c = 0; c < f_channels.length; c++)
        {
          channels[c + f_address] = f_channels[c];
        }
      }
    }
    if (overlays) {
      noFill();
      stroke(128, 255, 0);
      rect(rect.x-5, rect.y-5, rect.width+10, rect.height+10);
    }
  }
}

