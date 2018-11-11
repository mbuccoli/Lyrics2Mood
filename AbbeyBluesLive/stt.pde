class SpeechToText extends Thread{
  private Semaphore sem, semRecord;
  private int i;
  private String lyrics;
  private byte[] audiodata;
  View view;
  SpeechToText(Semaphore semRecord, View view){
    println("Initializing sst");
    this.semRecord=semRecord;
    this.sem=new Semaphore(0);
    this.view=view;
    this.i=0;
  }
  
  Semaphore getSem(){
     return this.sem;
  }
  
  String getLyrics(){
    return this.lyrics;
  }
  
  private void callAPI(){
    Config config = new Config();
    String URLapi = config.getString("url_stt");
    JSONObject header = config.getJSon("headers_stt");
    String apikey = header.getString("Ocp-Apim-Subscription-Key");
    String content_type = header.getString("Content-Type");
    String accept = header.getString("Accept");
    //JSONObject confjson = loadJSONObject("config.json");
    //JSONObject confhead = confjson.getJSONObject("headers");
    //String MYAPIKEY = confhead.getString("Ocp-Apim-Subscription-Key");
    //PostRequest post = new PostRequest("https://westus.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US");
    PostRequest post = new PostRequest(URLapi);
    post.addHeader("Ocp-Apim-Subscription-Key", apikey);
    post.addHeader("Content-Type", content_type);
    post.addHeader("Accept", accept);
    post.addData(content_type, audiodata); 
    post.send();
    JSONObject json = parseJSONObject(post.getContent());
    try{
      this.lyrics = json.getString("DisplayText");
    }
    catch(Exception e){
      this.lyrics="";
      println("Lyrics not found");
    }
    if(this.lyrics==null){this.lyrics="";}
  }
  
  void run(){
    while(true){
      try{
      this.semRecord.acquire();}
      catch(Exception e){
       println(e);     
     }
     println("STT"+this.i + ": Im loading temp.wav");
     audiodata = loadBytes("temp.wav");         
      
     println("STT"+this.i + ": Im calling STT API");
     callAPI();
     this.view.setLyrics(this.lyrics);
     this.sem.release();
     /*
     if(this.lyrics!="" && this.lyrics != null){
       
       println("STT"+this.i + " "+this.lyrics+ ": ASking for sentiment");
     }
     else{
       this
     }
     */
     this.i++;
    }
   }
}