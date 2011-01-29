package com.potomak {
  import flash.display.BitmapData;
  import flash.utils.ByteArray;
  import com.adobe.images.JPGEncoder;
  import com.adobe.images.PNGEncoder;
  
  public class SavePicture {
    private static const JPG:String = "jpg";
    private static const PNG:String = "png";
    
    private static function saveImage(bitmapData:BitmapData, type:String):void {
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

      var uploader:Uploader = new Uploader();
      uploader.send(byteArray);
    }

    public static function saveJPG(bitmapData:BitmapData):void {
      saveImage(bitmapData, JPG);
    }
    
    public static function savePNG(bitmapData:BitmapData):void {
      saveImage(bitmapData, PNG);
    }
  }
}