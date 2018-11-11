int SHIFTGAINMS=100;
class Player extends Thread{
  String[] songNames;
  AudioPlayer[] songPlayers;
  float[] currentGains;
  float[] currentConvertedGains;
  int Nsongs;
  Player(String[] songs){
    
    this.Nsongs=songs.length;
    this.songNames=new String[this.Nsongs];
    this.songPlayers=new AudioPlayer[this.Nsongs];
    this.currentGains=new float[this.Nsongs];
    this.currentConvertedGains=new float[this.Nsongs];
    for(int p=0; p<this.Nsongs; p++){
      this.songNames[p]="file-audio/"+songs[p];
      ////println(this.songNames[p]);
      this.songPlayers[p]=minim.loadFile(this.songNames[p]);
      //this.currentGains[p]=0.5*1./this.Nsongs; // all tracks with same gain
      if(p == 1){ // second track playing
        this.currentGains[p] = 0.5; // second track playing
        midiBus.changePreset(config.getInteger("guitarPresetDefault"));
      }
      else{
        this.currentGains[p] = 0;
      }
      this.currentConvertedGains[p]=this.convertGain(this.currentGains[p]);
      ////println(this.currentGains[p]);
      this.songPlayers[p].setGain(this.currentConvertedGains[p]);      
    }
    
    //println("PLAYER: loading songs...");
  }
  float convertGain(float gain){
    double gpd=10.*Math.log10(1e-6+gain)-3;
    return (float)gpd;        
  }
  void setGains(float[] gains, boolean convert){
    boolean change=true;
    
    for(int p=0; p<this.Nsongs; p++){
      change=change && this.currentGains[p]==gains[p]; 
      //change=change || this.songPlayers[p].isShiftingGain();      
    }
    if(change){
      return;
    }
    for(int p=0; p<this.Nsongs; p++){
      this.currentGains[p]=gains[p];
      float gp=gains[p];
       if(convert){
         gp=this.convertGain(gains[p]);
       }      
      this.songPlayers[p].shiftGain(this.currentConvertedGains[p], gp,  SHIFTGAINMS);      
      this.currentConvertedGains[p]=gp;                  
    }
    println("PLAYER: setting gains "+this.currentConvertedGains[0]+"dB and "+this.currentConvertedGains[1]+"dB.");
  
  }
  void setGains(float[] gains){
    boolean change=true;
    
    
    for(int p=0; p<this.Nsongs; p++){
      change=change && this.currentGains[p]==gains[p];      
    }
    if(change){
      return;
    }
    
    for(int p=0; p<this.Nsongs; p++){     
      this.songPlayers[p].shiftVolume(this.currentGains[p], .5*gains[p],  SHIFTGAINMS);
      this.currentGains[p]=.5*gains[p];                  
    }
    //println("PLAYER: setting gains "+gains[0]+" "+gains[1]);
  }
  void play(){
    //println("PLAYER: Playing tracks");
    for(int p=0; p<this.Nsongs; p++){
      this.songPlayers[p].loop();      
    }
  }
  void run(){
      
  }
}
