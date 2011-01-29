package com.potomak {
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  import flash.external.ExternalInterface;
  
  public class TakePictureExternalInterface {
    public static function attachExternalCallback(functionName:String, closure:Function):void {
      if (ExternalInterface.available) {
        try {
          Logger.debug("adding " + functionName + " callback...");
          ExternalInterface.addCallback(functionName, closure);
          if (checkJavaScriptReady()) {
            Logger.debug("javascript is ready.");
          }
          else {
            Logger.debug("javascript is not ready, creating timer.");
            var readyTimer:Timer = new Timer(100, 0);
            readyTimer.addEventListener(TimerEvent.TIMER, timerHandler);
            readyTimer.start();
          }
        }
        catch (error:SecurityError) {
          Logger.debug("a SecurityError occurred: " + error.message);
        }
        catch (error:Error) {
          Logger.debug("an Error occurred: " + error.message);
        }
      }
      else {
        Logger.debug("external interface is not available for this container.");
      }
    }
    
    private static function checkJavaScriptReady():Boolean {
      var isReady:Boolean = ExternalInterface.call("isReady");
      return isReady;
    }
    
    private static function timerHandler(event:TimerEvent):void {
      Logger.debug("checking javascript status...");
      var isReady:Boolean = checkJavaScriptReady();
      if (isReady) {
        Logger.debug("javascript is ready.");
        Timer(event.target).stop();
      }
    }
  }
}