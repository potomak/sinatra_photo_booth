package com.potomak {
  import flash.geom.Matrix;
  import flash.display.DisplayObject;
  
  public class MirrorTransform {
    public static function work(displayObject:DisplayObject):void {
      var matrix:Matrix = displayObject.transform.matrix;
      matrix.a = -1;
      matrix.tx = displayObject.width + displayObject.x;
      displayObject.transform.matrix = matrix;
    }
  }
}