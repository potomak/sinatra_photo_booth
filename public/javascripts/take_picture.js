var jsReady = false;

function isReady() {
  return jsReady;
}

function thisMovie(movieName) {
  if (navigator.appName.indexOf("Microsoft") != -1) {
    return window[movieName];
  } else {
    return document[movieName];
  }
}

function captureImage() {
  thisMovie("take_picture").captureImage();
}

function enableSave() {
  console.log("enabling the save button...");
}

function saveImage() {
  thisMovie("take_picture").saveImage();
}

function sendComplete(result) {
  document.getElementById("send_result").innerHTML = result;
}

function selfTimer(msecs) {
  console.log("selfTimer (msecs: " + msecs + ")");
  
  if(msecs > 0) {
    setTimeout(function() {
      selfTimer(msecs - 1000);
    },1000);
  }
  else {
    thisMovie("take_picture").captureImage();
  }
}

function selfTimerVisual(msecs) {
  var secs = (new Number(msecs/1000)).toFixed(0);
  if(secs > 0) {
    document.getElementById("self_timer").innerHTML = secs;
  }
  else {
    document.getElementById("self_timer").innerHTML = "^_^";
  }
  
  
  if(msecs > 0) {
    setTimeout(function() {
      selfTimerVisual(msecs - 1000);
    },1000);
  }
}

//
// TODO
//
// var TakePicture = (function () {
//   return {};
// })();