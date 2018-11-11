class SentimentAnalysis extends Thread{
  Semaphore sem, sttSem;
  SpeechToText stt;
  int i;
  private String lyrics;
  private Float score;
  
  SentimentAnalysis(Semaphore sttSem, SpeechToText stt){
    println("Initializing sa");
    this.sem=new Semaphore(0);
    this.sttSem=sttSem;
    this.i=0;
    this.stt = stt;
    this.lyrics = "";
    this.score = -1.0;
  };
  Semaphore getSem(){
    return this.sem;
  }
  
  Float getScore(){
    return this.score;
  }
  String getLyrics(){
    return this.lyrics;
  }
  private void callAPI(){
    Config config = new Config();
    String URLapi = config.getString("url_sa");
    println(URLapi);
    JSONObject header = config.getJSon("headers_sa");
    println(header);
    String apikey = header.getString("Ocp-Apim-Subscription-Key");
    println(apikey);
    String content_type = header.getString("Content-Type");
    println(content_type);
    PostRequest post = new PostRequest(URLapi);

    post.addHeader("Ocp-Apim-Subscription-Key", apikey);
    post.addHeader("Content-Type", content_type);
    
    JSONObject json_req = new JSONObject();
    JSONArray json_lyrics = new JSONArray();
    JSONObject json_elem = new JSONObject();
    json_elem.setString("language","en");
    json_elem.setString("id", "1");
    json_elem.setString("text",this.lyrics);
    
    //println(json_elem);
    json_lyrics.setJSONObject(0, json_elem);
    json_req.setJSONArray("documents", json_lyrics);
    post.addJson(json_req.toString());
    println("Lyrics are"+ this.lyrics);
    println(json_req);
    post.send();
    
    JSONObject json = parseJSONObject(post.getContent());
    JSONArray arr = json.getJSONArray("documents");
    JSONObject elem =arr.getJSONObject(0);
    this.score = elem.getFloat("score");
    //score = json.getObject
    
  }
  
  
  void run(){
   while(true){
     try{
       this.sttSem.acquire();
     }
     catch(Exception e){
       println(e);     
     }
     println("SA"+this.i + ": Im acquiring text");
     // ACQUIRE AUDIO
     // SAVE TEMP.WAV
     this.lyrics = stt.getLyrics();
     if(this.lyrics!=""){
       println(lyrics);
       println("SA"+this.i + ": Im analyzing text");
       callAPI();}
     else{this.score=0.5;}
     this.sem.release();
     println("SA"+this.i + ": Im sending the sentiment");
     this.i++;
   }
 }
  


}