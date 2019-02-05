// VertexAnimation Project - Student Version
import java.io.*;
import java.util.*;

/*========== Monsters ==========*/
Animation monsterAnim;
ShapeInterpolator monsterForward = new ShapeInterpolator();
ShapeInterpolator monsterReverse = new ShapeInterpolator();
ShapeInterpolator monsterSnap = new ShapeInterpolator();

/*========== Sphere ==========*/
Animation sphereAnim; // Load from file
Animation spherePos; // Create manually
ShapeInterpolator sphereForward = new ShapeInterpolator();
PositionInterpolator spherePosition = new PositionInterpolator();

//cube
PShape cube;
PositionInterpolator[] cubes= new PositionInterpolator[11];
  
// TODO: Create animations for interpolators
//ArrayList<PositionInterpolator> cubes = new ArrayList<PositionInterpolator>();
cameraOps camOps;
void setup()
{
  camOps= new cameraOps();
  pixelDensity(2);
  size(1200, 800, P3D);
 strokeWeight(0);
 
  /*====== Load Animations ======*/
  monsterAnim = ReadAnimationFromFile("monster.txt");
  sphereAnim = ReadAnimationFromFile("sphere.txt");

  monsterForward.SetAnimation(monsterAnim);
  monsterReverse.SetAnimation(monsterAnim);
  monsterSnap.SetAnimation(monsterAnim);  
  monsterSnap.SetFrameSnapping(true);

  sphereForward.SetAnimation(sphereAnim);

  /*====== Create Animations For Cubes ======*/
  // When initializing animations, to offset them
  // you can "initialize" them by calling Update()
  // with a time value update. Each is 0.1 seconds
  // ahead of the previous one
  
  cube=createShape();
  cube.beginShape();
  cube.vertex(10,10,10);
  cube.vertex(-10,10,10);
  cube.vertex(-10,-10,10);
  cube.vertex(-10,-10,-10);
  cube.vertex(-10,10,-10);
  cube.vertex(10,10,-10);
  cube.vertex(10,-10,-10);
  cube.vertex(10,-10,10);
  cube.endShape();
  
  for(int i =0; i<11;i++){
    Animation cubeAnim=new Animation();
    cubeAnim.keyFrames.add(new KeyFrame(new PVector(i*18-100,0,-100),0));
    cubeAnim.keyFrames.add(new KeyFrame(new PVector(i*18-100,0,0),1));
    cubeAnim.keyFrames.add(new KeyFrame(new PVector(i*18-100,0,100),2));
    cubeAnim.keyFrames.add(new KeyFrame(new PVector(i*18-100,0,0),3));
    cubeAnim.keyFrames.add(new KeyFrame(new PVector(i*18-100,0,-100),4));

   cubes[i]=new PositionInterpolator();
   cubes[i].UpdateTime(.1*i);
   cubes[i].SetAnimation(cubeAnim);
   if(i%2!=0){
    cubes[i].snapping=true; 
   }
    
  }
  
  /*====== Create Animations For Spheroid ======*/
  Animation spherePos = new Animation();
  // Create and set keyframes
  
  spherePos.keyFrames.add(new KeyFrame(new PVector(100,0,100),0));
  spherePos.keyFrames.add(new KeyFrame(new PVector(100,0,-100),1));
  spherePos.keyFrames.add(new KeyFrame(new PVector(-100,0,-100),2));
  spherePos.keyFrames.add(new KeyFrame(new PVector(-100,0,100),3));
  spherePos.keyFrames.add(new KeyFrame(new PVector(100,0,100),4));
  spherePosition.SetAnimation(spherePos);
  

}

void draw()
{
  lights();
  background(100);
  DrawGrid();

  float playbackSpeed = 0.005f;

  // TODO: Implement your own camera
  camOps.Update();
  
  
  
  
  
  //====== Draw Forward Monster ======
  pushMatrix();
  translate(-40, 0, 0);
  monsterForward.fillColor = color(128, 200, 54);
  monsterForward.Update(playbackSpeed);
  shape(monsterForward.currentShape);
  popMatrix();
  
  //====== Draw Reverse Monster ======
  pushMatrix();
  translate(40, 0, 0);
  monsterReverse.fillColor = color(220, 80, 45);
  monsterReverse.Update(-playbackSpeed);
  shape(monsterReverse.currentShape);
  popMatrix();
  
  //*====== Draw Snapped Monster ======
  pushMatrix();
  translate(0, 0, -60);
  monsterSnap.fillColor = color(160, 120, 85);
  monsterSnap.Update(playbackSpeed);
  shape(monsterSnap.currentShape);
  popMatrix();
  
  //====== Draw Spheroid ======
  spherePosition.Update(playbackSpeed);
  //spherePosition.SetFrameSnapping(true);
  sphereForward.fillColor = color(39, 110, 190);
  sphereForward.Update(playbackSpeed);
  PVector pos = spherePosition.currentPosition;
  pushMatrix();
  translate(pos.x, pos.y, pos.z);
  shape(sphereForward.currentShape);
  popMatrix();
  
  //*====== TODO: Update and draw cubes ======
  // For each interpolator, update/draw
  for(int i =0;i<11;i++){
   
    cubes[i].Update(playbackSpeed);
    pos=cubes[i].currentPosition;
    pushMatrix();
    
    translate(pos.x,pos.y,pos.z);
    if(i%2==0){
      fill(0,255,0);
    }else{
      fill(255,0,0);
    }
   
    box(10);
    popMatrix();
    
    
    
    
  }
  
}

void mouseWheel(MouseEvent event)
{
  float e = event.getCount();
  // Zoom the camera
  camOps.zoom(e);
  // SomeCameraClass.zoom(e);
}

// Create and return an animation object
Animation ReadAnimationFromFile(String fileName)
{
  Animation animation = new Animation();

  // The BufferedReader class will let you read in the file data
  //try
  //{
    BufferedReader reader = createReader(fileName);
    
  //}
  //catch (FileNotFoundException ex)
  //{
    //println("File not found: " + fileName);
  //}
  //catch (IOException ex)
  //{
  //  ex.printStackTrace();
  //}
  int keyFrames=0;
  int dataPoints=0;
  try{
    keyFrames = Integer.parseInt(reader.readLine());
  }
  
   catch(IOException e){
     
   }
   try{
      dataPoints = Integer.parseInt(reader.readLine());
   }
   catch(IOException e){
     
     
   }
   for(int i =0; i<keyFrames;i++){
     KeyFrame current = new KeyFrame();
     try{
     current.time=Float.valueOf(reader.readLine());
     }
     catch(IOException e){
     }
     for(int j=0;j<dataPoints;j++){
       String line="";
       try{
         line = reader.readLine();
       }
       catch(IOException e){
       }
      
      String[] coor = split(line, ' ');
      float x = Float.valueOf(coor[0]);
      float y = Float.valueOf(coor[1]);
      float z = Float.valueOf(coor[2]);
      current.points.add(new PVector(x,y,z));
      
     }
     //may need to be sorted upon entry if creator was a dick
     animation.keyFrames.add(current);
     
   }
 
 
 
 
  return animation;
}

void DrawGrid()
{
  strokeWeight(1);
  // TODO: Draw the grid
  //grid
  for( int i =-10;i<=10;i++){
    stroke(0);
   line(10*i,0,100,10*i,0,-100);
   line(100,0,10*i,-100,0,10*i);
  }
  stroke(0,0,255);
  line(0,0,100,0,0,-100);
  stroke(255,0,0);
  line(100,0,0,-100,0,0);
  // Dimensions: 200x200 (-100 to +100 on X and Z)
  strokeWeight(0);
}
