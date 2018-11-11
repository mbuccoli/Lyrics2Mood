import java.io.FileNotFoundException;

public  class Config{
     
   private void saveConfig(){
      saveJSONObject(customConf, "config_CUSTOM.json", "indent=3");
   }
   public void load(){
     try{
       customConf = loadJSONObject("config_CUSTOM.json");
       println("CUSTOM config file successfully loaded");
     }
     catch (Exception e1) {
       println("CUSTOM config file not loaded!");
     }
    
     try{
       defaultConf = loadJSONObject("config_DEFAULT.json");
       println("DEFAULT config file successfully loaded");
     }
     catch (Exception e2) {
       println("DEFAULT config file not loaded!");
     }
     
     if (customConf == null){
       customConf = defaultConf; 
       saveConfig();
     }      
     
   }
   
   public JSONObject getJSon(String key) {
     try{
       return  customConf.getJSONObject(key);
     } catch (Exception e){
       return null;
     }     
   }
   public void setJSon(String key, JSONObject value){
     try{
       customConf.setJSONObject(key, value);
       saveConfig();
     } catch (Exception e){
       println("error saving key: {" + key + "} value: {" + value + "}");
     }
   }
   
   public String getString(String key){
     try{
       return  customConf.getString(key, defaultConf.getString(key));
     } catch (Exception e){
       return null;
     }
   }
   public void setString(String key, String value){
     try{
       customConf.setString(key, value);
       saveConfig();
     } catch (Exception e){
       println("error saving key: {" + key + "} value: {" + value + "}");
     }
   }
   
   public Integer getInteger(String key){
     try{
       return  customConf.getInt(key, defaultConf.getInt(key));
     } catch (Exception e){
       return null;
     }
   }
   public void setInteger(String key, Integer value){
     try{
       customConf.setInt(key, value);
       saveConfig();
     } catch (Exception e){
       println("error saving key: {" + key + "} value: {" + value + "}");
     }
   }
   
   public Float getFloat(String key){
     try{
       return  customConf.getFloat(key, defaultConf.getFloat(key));
     } catch (Exception e){
       return null;
     }
   } 
   public void setFloat(String key, Float value){
     try{
       customConf.setFloat(key, value);
       saveConfig();
     } catch (Exception e){
       println("error saving key: {" + key + "} value: {" + value + "}");
     }
   }
}
