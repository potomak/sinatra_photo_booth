package com.potomak {
  import flash.external.ExternalInterface;
  
  public class Logger {
    public static function debug(message:String):void {
      ExternalInterface.call("console.log", message);
    }
  }
}