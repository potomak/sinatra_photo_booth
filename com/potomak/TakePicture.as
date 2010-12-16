package com.potomak {
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.media.Camera;
  import flash.media.Video;
  import flash.geom.Matrix;
  import flash.utils.ByteArray;
  import flash.utils.Timer;
  import flash.net.URLRequestHeader;
  import flash.net.URLRequestMethod;
  import flash.net.URLRequest;
  import flash.net.URLLoader;
  import flash.external.ExternalInterface;
  import com.adobe.images.JPGEncoder;
  import com.adobe.images.PNGEncoder;

  public class TakePicture extends Sprite {
    //var snd:Sound = new camerasound(); //new sound instance for the "capture" button click

    private var cam:Camera;
    private var video:Video;
    private var bitmapData:BitmapData;
    private var bitmap:Bitmap;
    private var urlLoader:URLLoader;
    
    private static const JPG:String = "jpg";
    private static const PNG:String = "png";

    public function TakePicture():void {
      logToConsole("initialization...");
      
      urlLoader = new URLLoader();
      urlLoader.addEventListener(Event.COMPLETE, sendComplete);
      
      attachExternalCallback("captureImage", captureImage);
      
      setupUi();
    }
    
    private function attachExternalCallback(functionName:String, closure:Function):void {
      if (ExternalInterface.available) {
        try {
          logToConsole("adding " + functionName + " callback...");
          ExternalInterface.addCallback(functionName, closure);
          if (checkJavaScriptReady()) {
            logToConsole("javascript is ready.");
          }
          else {
            logToConsole("javascript is not ready, creating timer.");
            var readyTimer:Timer = new Timer(100, 0);
            readyTimer.addEventListener(TimerEvent.TIMER, timerHandler);
            readyTimer.start();
          }
        }
        catch (error:SecurityError) {
          logToConsole("a SecurityError occurred: " + error.message);
        }
        catch (error:Error) {
          logToConsole("an Error occurred: " + error.message);
        }
      }
      else {
        logToConsole("external interface is not available for this container.");
      }
    }
    
    private function checkJavaScriptReady():Boolean {
      var isReady:Boolean = ExternalInterface.call("isReady");
      return isReady;
    }
    
    private function timerHandler(event:TimerEvent):void {
      logToConsole("checking javascript status...");
      var isReady:Boolean = checkJavaScriptReady();
      if (isReady) {
        logToConsole("javascript is ready.");
        Timer(event.target).stop();
      }
    }
    
    private function logToConsole(message:String):void {
      ExternalInterface.call("console.log", message);
    }
    
    private function setupUi():void {
      logToConsole("setup UI...");
      
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      
      var bandwidth:int = 0; // Maximum amount of bandwidth that the current outgoing video feed can use, in bytes per second.
      var quality:int = 100; // This value is 0-100 with 1 being the lowest quality.
      
      cam = Camera.getCamera();
      cam.setQuality(bandwidth, quality);
      cam.setMode(320, 240, 24, false); // setMode(videoWidth, videoHeight, video fps, favor area)
      video = new Video();
      video.attachCamera(cam);
/*      video.x = 2;
      video.y = 2;*/
      mirrorTransform(video);
      stage.addChild(video);
      
      logToConsole("video attached!");
      
      bitmapData = new BitmapData(video.width, video.height);
      
      bitmap = new Bitmap(bitmapData);
      bitmap.x = 320;
      //bitmap.y = 2;
      stage.addChild(bitmap);
      
      logToConsole("bitmap attached!");
    }
    
    private function mirrorTransform(displayObject:DisplayObject):void {
      var matrix:Matrix = displayObject.transform.matrix;
      matrix.a = -1;
      matrix.tx = displayObject.width + displayObject.x;
      displayObject.transform.matrix = matrix;
    }

    private function captureImage():void {
      //snd.play();
      
      bitmapData.draw(video, video.transform.matrix);
      
      //ExternalInterface.call("enableSave");
      
      attachExternalCallback("saveImage", savePNG);
    }
    
    private function saveImage(type:String):void {
      var byteArray:ByteArray;
      
      switch(type) {
        case JPG:
          var myEncoder:JPGEncoder = new JPGEncoder(100);
          byteArray = myEncoder.encode(bitmapData);
          break;
        case PNG:
          byteArray = PNGEncoder.encode(bitmapData);
          break;
      }

      var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");

      //var saveImage:URLRequest = new URLRequest("save.php");
      var saveImage:URLRequest = new URLRequest("save");
      saveImage.requestHeaders.push(header);
      saveImage.method = URLRequestMethod.POST;
      saveImage.data = byteArray;

      urlLoader.load(saveImage);
    }

    private function saveJPG():void {
      saveImage(TakePicture.JPG);
    }
    
    private function savePNG():void {
      saveImage(TakePicture.PNG);
    }
    
    private function sendComplete(e:Event):void {
      logToConsole("send complete!");
      logToConsole("send result: " + urlLoader.data);
    }
  }
}