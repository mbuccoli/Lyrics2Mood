import ddf.minim.*;
import ddf.minim.analysis.*;
Minim minim=new Minim(this);

class Record extends Thread{
   int buffer,i;
   AudioInput in;  //mic
   AudioRecorder rec;
   View view;
   private Semaphore sem;
   Record(){
     //println("REC: Creting the buffer");
       this.sem = new Semaphore(0);
       this.buffer=0;
       this.i=0;
       this.view=null;
       this.in= minim.getLineIn(Minim.MONO, config.getInteger("frameLength"), config.getInteger("samplingRate"));
       this.rec=minim.createRecorder(in, "temp.wav");
       
   }
   void setView(View view){
     this.view=view;
   }
   Semaphore getSem(){
     return this.sem;
   }
   AudioInput getInput(){
     return this.in;
   }
   void run(){
     this.rec.beginRecord();
     view.startRecord();
     while(true){       
       //println("REC"+this.i + ": Im acquiring audio");
       // ACQUIRE AUDIO
       // SAVE TEMP.WAV
       delay(config.getInteger("recordTime")*1000);
       this.rec.endRecord();
       this.rec.save();
       //println("REC"+this.i + ": Im saving temp.wav");
       
       this.sem.release();
              
       //println("REC"+this.i + ": Im cleaning my buffer");
       this.rec=minim.createRecorder(in, "temp.wav");
       this.rec.beginRecord();
       if(this.i%2==1){
         view.startRecord();
       }
       this.i++;
     }
   }
     
  
  
}
