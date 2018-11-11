import http.requests.*;
import java.util.concurrent.Semaphore;
//NetAddress myRemoteLocation;

JSONObject defaultConf = null;
JSONObject customConf = null;

Semaphore s=new Semaphore(0);
Record record;
SpeechToText stt;
SentimentAnalysis sa;
Player player;
View view;
Controller controller;
Midi midiBus;
Config config;

boolean FULLSCREEN=true;

void setup(){
 config = new Config();
 config.load();
 midiBus = new Midi();
 fullScreen();
 //size(1280,720);
 println("Setup");
 record=new Record();
 view = new View(record.getInput());
 record.setView(view);
 stt=new SpeechToText(record.getSem(),view);
 sa=new SentimentAnalysis(stt.getSem(),stt);
 
 String[] songs={"SadTrack.wav","MedioTrack.wav","HappyTrack.wav"};
 player=new Player(songs);
 controller=new Controller(sa.getSem(),sa, player,  view);
 

 record.start();
 stt.start();
 sa.start();
 controller.start();
 player.play();
}
int i=0;


void draw(){
  i++;
  
  
  
  view.draw();
  
}

void stop(){
   midiBus.stop();
  ;

}