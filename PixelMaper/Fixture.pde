/*
 * Base class for fixtures
 * All fixture have DMX space, and video/pixel space
 */

public abstract class Fixture
{
  //DMX settings
  protected int address;
  protected int[] channels;
  protected int universe;
  protected int span;
  //Video mapping
  protected Rectangle rect;
  
  public Fixture(int _universe, int _address, int _span, Rectangle _rect)
  {
    //jus' checkin'
    if(_address < 1 || _address > 512) throw new IllegalArgumentException("The address " + _address + " is out of range");    
    if(_span < 0)                      throw new IllegalArgumentException("The channel span " + _span + " must be positive");
    if(_address + _span > (512*acn.universeTotal))         throw new IllegalArgumentException("The channel span falls off the end");
    if(_universe < 1 || _universe > acn.universeTotal ) throw new IllegalArgumentException("The universe " + _universe + " is out of range");
    span = _span;
    universe = _universe;
    address = (_address-1)+(512*(universe-1));  //start at 0 to make arrays easy
    channels = new int[span];
    rect = _rect;
  }
  
  //processes the video, and adjust the channels accordingly
  //method MUST be implemented by a subclass
  abstract void compute();
  
  //getters
  public int   getUniverse()  { return universe;  }
  public int   getAddress()  { return address;  }
  public int   getSpan()  { return span;  }
  public int[] getChannels() { return channels; }
}
