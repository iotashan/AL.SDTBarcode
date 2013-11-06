// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
    backgroundColor:'white'
});
var label = Ti.UI.createLabel();
win.add(label);
win.open();

// TODO: write your module tests here
var SDTBarcode = require('AL.SDTBarcode');

var overlay = Ti.UI.createView({
  top: 10,
  left: 10,
  right: 10,
  height: 48,
  width: 60,
  backgroundColor: "green",
  opacity: 0.6,
});
overlay.add(Ti.UI.createLabel({
  top: 8,
  left: 8,
  text: 'scan your barcode using the camera',
}));

SDTBarcode.init({
    overlay: overlay,
    useFrontCamera: false,
    enableAutofocus: true,
    enableFlash: false
});

SDTBarcode.showScanner();
// SDTBarcode.hideScanner();
// SDTBarcode.flashOn();
// SDTBarcode.flashOff();