//
// to compile run the command:
//   mxmlc -compiler.source-path=. -output=public/flash/TakePicture.swf com/potomak/TakePicture.as
//

package com.potomak {
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.media.Camera;
  import flash.media.Video;
  import flash.external.ExternalInterface;

  public class TakePicture extends Sprite {
    //var snd:Sound = new camerasound(); //new sound instance for the "capture" button click

    private var cam:Camera;
    private var video:Video;
    private var bitmapData:BitmapData;
    private var bitmap:Bitmap;

    public function TakePicture():void {
      Logger.debug("initialization...");
      
      TakePictureExternalInterface.attachExternalCallback("captureImage", captureImage);
      
      setupUi();
    }
    
    private function setupUi():void {
      Logger.debug("setup UI...");
      
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
      MirrorTransform.work(video);
      stage.addChild(video);
      
      Logger.debug("video attached!");
      
      bitmapData = new BitmapData(video.width, video.height);
      
      bitmap = new Bitmap(bitmapData);
      bitmap.x = 320;
      //bitmap.y = 2;
      stage.addChild(bitmap);
      
      Logger.debug("bitmap attached!");
    }

    private function captureImage():void {
      //snd.play();
      
      bitmapData.draw(video, video.transform.matrix);
      
      TakePictureExternalInterface.attachExternalCallback("saveImage", saveImage);
      ExternalInterface.call("enableSave");
    }
    
    private function saveImage():void {
      SavePicture.savePNG(bitmapData);
    }
  }
}