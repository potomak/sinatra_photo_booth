package com.potomak {
  import flash.events.Event;
  import flash.utils.ByteArray;
  import flash.net.URLRequestHeader;
  import flash.net.URLRequestMethod;
  import flash.net.URLRequest;
  import flash.net.URLLoader;
  import flash.external.ExternalInterface;
  
  public class Uploader {
    private var urlLoader:URLLoader;
    
    public function Uploader():void {
      urlLoader = new URLLoader();
      urlLoader.addEventListener(Event.COMPLETE, sendComplete);
    }
    
    public function send(byteArray:ByteArray):void {
      var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
      
      var saveImage:URLRequest = new URLRequest("save");
      saveImage.requestHeaders.push(header);
      saveImage.method = URLRequestMethod.POST;
      saveImage.data = byteArray;

      urlLoader.load(saveImage);
    }
    
    private function sendComplete(e:Event):void {
      Logger.debug("send complete!");
      Logger.debug("send result: " + urlLoader.data);
      
      ExternalInterface.call("sendComplete", urlLoader.data);
    }
  }
}