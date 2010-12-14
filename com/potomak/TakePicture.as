package com.potomak {
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.media.Camera;
  import flash.media.Video;
  import flash.utils.ByteArray;
  import flash.net.URLRequestHeader;
  import flash.net.URLRequestMethod;
  import flash.net.URLRequest;
  import flash.net.URLLoader;
  import flash.external.ExternalInterface;
  import com.adobe.images.JPGEncoder;
  import com.adobe.images.PNGEncoder;
  import mx.containers.Canvas;
  import mx.core.UIComponent;
  import mx.controls.Button;

  public class TakePicture extends Canvas {
    //var snd:Sound = new camerasound(); //new sound instance for the "capture" button click

    private var cam:Camera;
    private var video:Video;
    private var bitmapData:BitmapData;
    private var bitmap:Bitmap;
    private var capture:Button;
    private var save:Button;
    private var urlLoader:URLLoader;
    
    private static const JPG:String = "jpg";
    private static const PNG:String = "png";

    public function TakePicture():void {
      logToConsole("starting...");
      
      urlLoader = new URLLoader();
      urlLoader.addEventListener(Event.COMPLETE, sendComplete);
      
      setupUi();
    }
    
    private function logToConsole(message:String):void {
      ExternalInterface.call("console.log", message);
    }
    
    private function setupUi():void {
      logToConsole("setupUi...");
      
      var bandwidth:int = 0; // Maximum amount of bandwidth that the current outgoing video feed can use, in bytes per second.
      var quality:int = 100; // This value is 0-100 with 1 being the lowest quality.
      
      cam = Camera.getCamera();
      cam.setQuality(bandwidth, quality);
      cam.setMode(320, 240, 24, false); // setMode(videoWidth, videoHeight, video fps, favor area)
      video = new Video();
      video.attachCamera(cam);
      var videoComponent:UIComponent = new UIComponent();
      videoComponent.x = 20;
      videoComponent.y = 20;
      videoComponent.addChild(video);
      addChild(videoComponent);
      
      logToConsole("video attached!");

      bitmapData = new BitmapData(video.width, video.height);

      bitmap = new Bitmap(bitmapData);
      var bitmapComponent:UIComponent = new UIComponent();
      bitmapComponent.x = 360;
      bitmapComponent.y = 20;
      bitmapComponent.addChild(bitmap);
      addChild(bitmapComponent);
      
      logToConsole("bitmap attached!");

      capture = new Button();
      capture.enabled = true;
      capture.label = "Capture";
      capture.width = 100;
      capture.x = 20;
      capture.y = 260;
      capture.addEventListener(MouseEvent.CLICK, captureImage);
      addChild(capture);
      
      logToConsole("capture button attached!");

      save = new Button();
      save.enabled = false;
      save.label = "Save";
      save.width = 100;
      save.x = 140;
      save.y = 260;
      save.addEventListener(MouseEvent.CLICK, saveJPG);
      addChild(save);
      
      logToConsole("save button attached!");
    }

    private function captureImage(e:MouseEvent):void {
      //snd.play();
      bitmapData.draw(video);
      save.enabled = true;
      //save.addEventListener(MouseEvent.CLICK, saveJPG);
      save.addEventListener(MouseEvent.CLICK, savePNG);
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

    private function saveJPG(e:Event):void {
      saveImage(TakePicture.JPG);
    }
    
    private function savePNG(e:Event):void {
      saveImage(TakePicture.PNG);
    }
    
    private function sendComplete(e:Event):void {
      logToConsole("send complete!");
      logToConsole(urlLoader.data);
    }
  }
}