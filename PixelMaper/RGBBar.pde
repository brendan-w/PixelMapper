
/*
 * LEDBar (which IS a ParentFixture) contains and sets up a bunch of PixelFixtures
 */

class RGBBar extends ParentFixture
{
  public RGBBar(int _universe, int _address, Rectangle _rect, int _segments)
  {
    super(_universe, _address, 3*_segments, _rect, _segments);
  }

  /*
    No need for a compute() method here, since it's handled by ParentFixture (calls compute on all the children and merges the channel spaces)
   */

  //called from ParentFixture
  //divide the given area into the desired segments
  public void createChildren()
  {
    if (rect.width >= rect.height)
    {
      //it's a horizontal bar
      float wf = (float) rect.width / (numChildren-1); //pixels per child
      int w = Math.round(wf);  //pixel per child rounded to int
      int h = rect.height;  //grabbing same height for everything (horizontal)

      for (int i = 0; i < numChildren; i++)
      {
        int x = rect.x + Math.round(wf * i);  //child X position
        int y = rect.y;
        //addresses are stored as relative offsets from their parent
        int new_address = 3 * i; //obviously, this is kindof arbitraty, and will almost certainly need to be changed
        children[i] = new RGBFixture(1, new_address+1, new Rectangle(x, y, w, h));
      }
    } else
    {
      //it's a vertical bar
      //etc... I've never found a succinct way of doing things like this...
      //it's a horizontal bar
      float hf = (float) rect.height / (numChildren-1); //pixels per child
      int h = Math.round(hf);  //pixel per child rounded to int
      int w = rect.width;  //grabbing same height for everything (horizontal)

      for (int i = 0; i < numChildren; i++)
      {
        int y = rect.y + Math.round(hf * (numChildren-i));  //child X position
        int x = rect.x;
        //addresses are stored as relative offsets from their parent
        int new_address = 3 * i; //obviously, this is kindof arbitraty, and will almost certainly need to be changed
        children[i] = new RGBFixture(1, new_address+1, new Rectangle(x, y, w, h));
      }
    }
  }
}

