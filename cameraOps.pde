class cameraOps{
  PVector position;
  float phi;
  float theta;
  ArrayList<PVector> targets;
  PVector target;
  int targetIt;
  int radius;
  float zoomLevel;
  
  cameraOps(){
    radius=200;
      position=new PVector(0,100,100);
      targets=new ArrayList<PVector>();
      targetIt=0;
      target = new PVector(0,0,0);
      zoomLevel=50f;
  }
  
  
  
   public void Update(){
    
     phi=-map(mouseX,0,width-1,0,360);
     theta=map(mouseY,0,height-1,1,179);
     
     position.x = (radius * cos(radians(phi)) * sin(radians(theta)))+target.x;
     position.y = (radius * cos(radians(theta)))+target.y;
     position.z = (radius * sin(radians(theta)) * sin(radians(phi)))+target.z;
     
    camera(position.x, position.y, position.z, // Where is the camera?
           target.x, target.y, target.z, // Where is the camera looking?
           0, 1, 0); // Camera Up vector (0, 1, 0 often, but not always, works)
  
   }
   
   public void addLookAtCamera(PVector pvec){
     targets.add(pvec);
     if(targets.size()==1){
       target=pvec;
     }
   }
   
   public void cycleTarget(){
     if(targets.size()>1){
       if(targetIt==targets.size()-1){
        targetIt=0;
        
       }
       else{
        targetIt++; 
       }
     
     }
     target=targets.get(targetIt);
   }
   
   public void zoom(float z){
     zoomLevel+=z;
     perspective(radians(zoomLevel), width/(float)height, 0.1, 1000);
     
   }
}
