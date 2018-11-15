import themidibus.*;

class Midi{
  private MidiBus myBus;
  int PROGRAMCHANGE= 0xC0;
  boolean isWorking;
  Midi(){
    this.isWorking=true;
    try{
      this.myBus = new MidiBus(this, config.getInteger("midiDeviceIn"), config.getInteger("midiDeviceOut"));
    }
    catch(Exception e){this.isWorking=false;}
  }
  
  void changePreset(int preset) {
    if(!this.isWorking){return;}
    myBus.sendMessage(PROGRAMCHANGE, 0, preset,0); 
  }
  
  void stop(){
    if(!this.isWorking){return;}
   myBus.close(); 
}
  
}