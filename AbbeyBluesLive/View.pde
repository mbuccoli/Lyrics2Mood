



int[] SAD = {91,44,97};
int[] HAPPY = {60,150,42};
int[] MEDIO={180,120,80};
class View implements AudioListener{
  AudioInput in;  //mic
  AudioListener listener;
  private float[] left;
  private float[] right;
  private float[] lSub;
  private int factor=8;  
  private int[] rgb;
  float t0;
  int cX, cY;
  float radius;
  float radiusBeat;
  float ringAmp;
  String lyrics;
  View(AudioInput in){ 
    in.addListener(this);  
    left=null;  
    this.lSub=new float[in.bufferSize()/factor];
    right=null;
    this.rgb=new int[3];
    this.rgb[0]=MEDIO[0]; this.rgb[1]=MEDIO[1]; this.rgb[2]=MEDIO[2];
    this.t0=System.currentTimeMillis();
    this.cX=int(width/2);
    this.cY=int(height/2);
    this.radius=height/4;
    this.ringAmp=radius/2;
    this.radiusBeat=this.radius/6;
    this.lyrics="";
    println(this.cX+" "+this.cY+" "+this.radius+" "+this.ringAmp);
  }
  public synchronized void samples(float[] samp)
  {
    left = samp;
  }
  public synchronized void samples(float[] sampL,float[] sampR)
  {
    left = sampL;
    right = sampR;
  }
  void setBackground(float score){
  
  if (score <= 0.4){
    this.rgb=SAD; 
   }
   else if(score <0.6){
     this.rgb=MEDIO;
   }
   else{
    this.rgb=HAPPY;
   }
  
  }
   
  void setLyrics(String lyrics){
      this.lyrics=lyrics;
  
  }
  void subSample(){
    for(int i=0; i<this.lSub.length; i++){
      this.lSub[i]=0;
       for(int j=0; j<this.factor; j++){
         this.lSub[i]+=(float)(left[i*this.factor+j]);       
       }       
      this.lSub[i]=(float)(this.lSub[i]);
      
    }     
  }
  void drawCircleSig(){
    float[][] prev=new float[2][2];
    stroke(255);
    strokeWeight(2);
    /*
    for(int i=1; i<this.lSub.length; i++){
      line(i-1, this.cY+this.ringAmp*lSub[i-1],i,this.cY+this.ringAmp*lSub[i]);
    }*/
    for(int i=0; i<this.lSub.length; i++){
      
       double omega=(Math.PI*i)/(this.lSub.length-1);
       float radius=this.radius+this.lSub[i]*this.ringAmp;
       //println(this.lSub[i]);
       double dX=Math.sin(omega);
       double dY=Math.cos(omega);
       
       if (i==0){
         prev[0][0]=(float)(this.cX+radius*dX);
         prev[0][1]=(float)(this.cY+radius*dY);
         prev[1][0]=(float)(this.cX-radius*dX);
         prev[1][1]=(float)(this.cY+radius*dY);
       }
       else if(i<this.lSub.length-1){
         line(prev[0][0],prev[0][1],
              (float)(this.cX+radius*dX),(float)(this.cY+radius*dY));
         line(prev[1][0],prev[1][1],
              (float)(this.cX-radius*dX),(float)(this.cY+radius*dY));
         prev[0][0]=(float)(this.cX+radius*dX);
         prev[0][1]=(float)(this.cY+radius*dY);
         prev[1][0]=(float)(this.cX-radius*dX);
         prev[1][1]=(float)(this.cY+radius*dY);
       }
       else{
         line(prev[0][0],prev[0][1],
              (float)(this.cX+radius*dX),(float)(this.cY+radius*dY));
         line(prev[1][0],prev[1][1],
              (float)(this.cX-radius*dX),(float)(this.cY+radius*dY));        
       }
    }
  
  
  }
  void startRecord(){
    this.t0=millis();
    //println("t0="+this.t0);
  }
  void writeText(){
    fill(0, 0, 0);
    beginShape();
    vertex(width/2 - 350,height);
    vertex(width/2 - 250,height-90);
    vertex(width/2 + 250,height-90);
    vertex(width/2 + 350,height);
    endShape();
    fill (255,255,255);
    textAlign(CENTER);
    textSize(24);

    text(this.lyrics,width/2-250,height-80,500,90) ;
  }
  void drawBeats(){
    float t=millis()-this.t0;
    ellipseMode(RADIUS);
    stroke(255);
    //noFill();
//    println(t);
    int beat=(int)(Math.floor(1.0*t/1500));
    float lX=width/2-10.5*this.radiusBeat;
    for(int b=0; b<8; b++){
      if(b==beat){
        fill(200,200,200);
      }
      else{noFill();}
      ellipse(lX+(b*3)*this.radiusBeat, 2*this.radiusBeat, this.radiusBeat, this.radiusBeat);
         
    }
    
  }
  float getT0(){
    return this.t0;
  }
  synchronized void draw(){
    
    if(left!=null){
      background(this.rgb[0],this.rgb[1],this.rgb[2]);      
      drawBeats();
      this.subSample();
      this.drawCircleSig();
      this.writeText();
    }    
  }
}