class Controller extends Thread{
  Semaphore saSem;
  SentimentAnalysis sa;
  Player player;
  View view;
  Controller(Semaphore saSem,  SentimentAnalysis sa, Player player, View view){
    println("Creating controller");
    this.saSem=saSem;
    this.sa = sa;
    this.player=player;
    this.view=view;
  }

  void run(){
   while(true){
     try{
       this.saSem.acquire();
     }
     catch(Exception e){
       println(e);     
     }
     println("Controlling");
     // ACQUIRE AUDIO
     // SAVE TEMP.WAV
     float score = sa.getScore();
     float[] gains=new float[3];
     int guitarPreset=0;
     if(score<0.4){ //negative
       gains[0]=1;
       gains[1]=0;
       gains[2]=0;
       guitarPreset=config.getInteger("guitarPresetNegative");
     }
     else if(score<0.6){ //neutral
       gains[0]=0;
       gains[1]=1;
       gains[2]=0;
       guitarPreset=config.getInteger("guitarPresetNeutral");
     }
     else{ //positive
       gains[0]=0;
       gains[1]=0;
       gains[2]=1;
       guitarPreset=config.getInteger("guitarPresetPositive");
     }
     
     float elapsedTime=millis()-view.getT0();
     println(elapsedTime);
     delay(max(0,(int)(2*config.getInteger("recordTime")*1000-elapsedTime-SHIFTGAINMS)));
     
     view.setBackground(score);
     Midi midiBus = new Midi();
     midiBus.changePreset(guitarPreset);

     //view.setLyrics(sa.getLyrics());
     player.setGains(gains, true);
     println("Score is "+score);
     //delay(4000);
     
   }
 }
}