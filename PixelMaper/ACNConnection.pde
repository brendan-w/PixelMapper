public class ACNConnection
{
  //output buffer
  public int[] DMX;
  public int universeTotal;
  public ArrayList<UDP> universes;

  private int count = 0;  //numbers packets so they can be ordered
  private byte[] data;  //master data array
  private byte[] header = {

    //Root layer
    0x00, 0x10, 
    0x00, 0x00, 
    0x41, 0x53, 0x43, 0x2d, 0x45, 0x31, 0x2e, 0x31, 0x37, 0x00, 0x00, 0x00, //E1.17 desriptor
    0x72, 0x6e, //Length for the lower 12 bits
    0x00, 0x00, 0x00, 0x04, //vector
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //UUID

    //framing layer
    0x72, 0x58, //Length for the lower 12 bits
    0x00, 0x00, 0x00, 0x02, //E1.31 ID
    //Souce name, UTF-8 string null terminated
    0x50, 0x69, 0x78, 0x65, 0x6c, 0x4d, 0x61, 0x70, 0x70, 0x65, 0x72, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x64, //Priorety at 100
    0x00, 0x00, //reserved
    0x00, //sequence number
    0x00, //terminate and preview flags
    0x00, 0x01, //universe

    //DMP layer
    0x72, 0x0B, //Length for the lower 12 bits
    0x02, //Vector
    byte(161), // identifies it as DMX data
    0x00, 0x00, //DMX start offset
    0x00, 0x01, //each channel is one octet
    0x02, 0x01, //number of DMX channels in packet
    0x00, //DMX start code
    //DMX data gets appended below here.
  };

  public ACNConnection(int _universeTotal)
  {
    universeTotal = _universeTotal;
    DMX = new int[512*universeTotal];
    universes = new ArrayList<UDP>();

    for (int u = 1; u < _universeTotal+1; u++)
    {
      UDP udp = new UDP( this, 5568, "239.255.0."+u );
      universes.add(udp);
    }

    data = new byte[512+header.length];
  }
  //commits a given fixture's values to the output buffer
  //ensures that fixtures can't set data on arbitrary channels
  public void commit(Fixture fixture)
  {
    int address    = fixture.getAddress();
    int[] channels = fixture.getChannels();

    for (int c = 0; c < channels.length; c++) //haha
    {
      DMX[c + address] = channels[c];
    }
  }


  public void send()
  {
    // bit-cannon here


    //iter through all universes
    for (int s = 0; s < universes.size (); s++)
    {
      if (count >= 255) {  
        count = 0;
      }
      //set packet number
      header[111] = byte(count);
      //set universe number
      header[114] = byte(s+1);
      //copy over dmx channels for this niverse
      for (int i = 0; i < data.length; ++i)
      {
        int channelToGet = i+(512*s);
        data[i] = i < header.length ? header[i] : byte(DMX[channelToGet - header.length]);
      }

      UDP udp = universes.get(s);
      udp.send( data );
      count ++;
    }
  }
}

