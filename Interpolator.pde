abstract class Interpolator
{
  Animation animation=new Animation();

  // Where we at in the animation?
  float currentTime = 0;

  // To interpolate, or not to interpolate... that is the question
  boolean snapping = false;

  void SetAnimation(Animation anim)
  {
    animation = anim;
  }

  void SetFrameSnapping(boolean snap)
  {
    snapping = snap;
  }

  void UpdateTime(float time)
  {
    // TODO: Update the current time
    //Status:Completed
    // Check to see if the time is out of bounds (0 / Animation_Duration)
    // If so, adjust by an appropriate amount to loop correctly

    currentTime+=time;
    if(animation.keyFrames.size()>0){
      if (currentTime>animation.keyFrames.get(animation.keyFrames.size()-1).time) {
        currentTime-=animation.keyFrames.get(animation.keyFrames.size()-1).time;
      } else if (currentTime<0) {
        currentTime=animation.keyFrames.get(animation.keyFrames.size()-1).time+time;
    }
    }
  }

  // Implement this in derived classes
  // Each of those should call UpdateTime() and pass the time parameter
  // Call that function FIRST to ensure proper synching of animations
  abstract void Update(float time);
}

class ShapeInterpolator extends Interpolator
{
  // The result of the data calculations - either snapping or interpolating
  PShape currentShape;

  // Changing mesh colors
  color fillColor;

  PShape GetShape()
  {
    return currentShape;
  }

  void Update(float time)
  {
    if(animation.keyFrames.get(0).time!=0){
     KeyFrame temp = new KeyFrame();
     temp.points=animation.keyFrames.get(animation.keyFrames.size()-1).points;
      temp.time=0;
      animation.keyFrames.add(0, temp);
      
    }
    UpdateTime(time);
    if (!snapping) {

      if (currentTime<0) {
        time = animation.keyFrames.get(animation.keyFrames.size()-1).time+time;
      }
      // TODO: Create a new PShape by interpolating between two existing key frames
      //status: complete not tested
      // using linear interpolation
      float tempTime;
      float tempTime2;
      int earlyFrame=0;

      for (int i =0; i < animation.keyFrames.size() - 1; i++) {
        tempTime = animation.keyFrames.get(i).time;
        tempTime2 = animation.keyFrames.get(i+1).time;
        if (currentTime>tempTime && currentTime<tempTime2) {
          earlyFrame=i;
          break;
        }
      }

      tempTime = animation.keyFrames.get(earlyFrame).time;
      KeyFrame frame1 = animation.keyFrames.get(earlyFrame);
      KeyFrame frame2=animation.keyFrames.get(earlyFrame+1);
      tempTime2=animation.keyFrames.get(earlyFrame+1).time;



      float percentToMove=(currentTime-tempTime)/(tempTime2-tempTime);
      
      float x;
      float y;
      float z;
      PShape shape = createShape();
      shape.setFill(fillColor);
      shape.beginShape(TRIANGLES);
      for (int i =0; i<animation.keyFrames.get(earlyFrame).points.size(); i++) {
        
        
          x=(percentToMove*(frame2.points.get(i).x-frame1.points.get(i).x))+frame1.points.get(i).x;
          y=(percentToMove*(frame2.points.get(i).y-frame1.points.get(i).y))+frame1.points.get(i).y;
          z=(percentToMove*(frame2.points.get(i).z-frame1.points.get(i).z))+frame1.points.get(i).z;
        
        /*
        x=frame1.points.get(i).x;
        y=frame1.points.get(i).y;
        z=frame1.points.get(i).z;
        */
        shape.vertex(x, y, z);
      }
      shape.endShape();
      currentShape=shape;
    } 
    
    
    else {//snapping
      
      if (currentTime<0) {
        time = animation.keyFrames.get(animation.keyFrames.size()-1).time+time;
      }
      // TODO: Create a new PShape by interpolating between two existing key frames
      //status: complete not tested
      // using linear interpolation
      float tempTime;
      float tempTime2;
      int earlyFrame=0;

      for (int i =0; i < animation.keyFrames.size() - 1; i++) {
        tempTime = animation.keyFrames.get(i).time;
        tempTime2 = animation.keyFrames.get(i+1).time;
        if (currentTime>tempTime && currentTime<tempTime2) {
          earlyFrame=i;
        }
      }

      tempTime = animation.keyFrames.get(earlyFrame).time;
      KeyFrame frame1 = animation.keyFrames.get(earlyFrame);
      tempTime2=animation.keyFrames.get(earlyFrame+1).time;



      
      float x;
      float y;
      float z;
      PShape shape = createShape();
      shape.setFill(fillColor);
      shape.beginShape(TRIANGLES);
      for (int i =0; i<animation.keyFrames.get(earlyFrame).points.size(); i++) {
        /*
        x=percentToMove*(frame2.points.get(i).x-frame1.points.get(i).x)+frame1.points.get(i).x;
        y=percentToMove*(frame2.points.get(i).y-frame1.points.get(i).y)+frame1.points.get(i).y;
        z=percentToMove*(frame2.points.get(i).z-frame1.points.get(i).z)+frame1.points.get(i).z;
        */
        x=frame1.points.get(i).x;
        y=frame1.points.get(i).y;
        z=frame1.points.get(i).z;
        shape.vertex(x, y, z);
      }
      shape.endShape();
      currentShape=shape;
    }
  }
}
    class PositionInterpolator extends Interpolator
    {
      PVector currentPosition;

      void Update(float time)
      {
        
        UpdateTime(time);
        //status:completed not tested
        // The same type of process as the ShapeInterpolator class... except
        // this only operates on a single point
        if(!snapping){
          float tempTime;
          float tempTime2;
          int earlyFrame = 0;
          float x=0;
          float y=0;
          float z=0;
          
          for (int i =0; i < animation.keyFrames.size()-1; i++) {
            tempTime = animation.keyFrames.get(i).time;
            tempTime2 = animation.keyFrames.get(i+1).time;
            if (currentTime>tempTime && currentTime<tempTime2) {
              earlyFrame=i;
            }
            
            tempTime = animation.keyFrames.get(earlyFrame).time;
            tempTime2 = animation.keyFrames.get(earlyFrame+1).time;
            
            float percentToMove=(currentTime-tempTime)/(tempTime2-tempTime);
             x = animation.keyFrames.get(earlyFrame).position.x+percentToMove*(animation.keyFrames.get(earlyFrame+1).position.x-animation.keyFrames.get(earlyFrame).position.x);
             y = animation.keyFrames.get(earlyFrame).position.y+percentToMove*(animation.keyFrames.get(earlyFrame+1).position.y-animation.keyFrames.get(earlyFrame).position.y);
             z = animation.keyFrames.get(earlyFrame).position.z+percentToMove*(animation.keyFrames.get(earlyFrame+1).position.z-animation.keyFrames.get(earlyFrame).position.z);

          }
          currentPosition = new PVector(x, y, z);

        }
        else{//snapping
        PVector pos=new PVector(0,0,0);;
          for (int i =0; i < animation.keyFrames.size(); i++) {
            if(currentTime>=animation.keyFrames.get(i).time){
             
              pos=animation.keyFrames.get(i).position;
              
            }
            
          }
          currentPosition=pos;
        
        
        }
      }
    }
