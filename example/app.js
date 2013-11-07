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
SDTBarcode.addEventListener("recognitionComplete", function(e) {
  Ti.API.info(JSON.stringify(e));
})

var overlay = Ti.UI.createView({
  top: 10,
  height: 48,
  width: Ti.UI.FILL,
  backgroundColor: "green",
  opacity: 0.6,
});
overlay.add(Ti.UI.createLabel({
  top: 8,
  left: 8,
  width: 260,
  height: 24,
  text: 'scan your barcode using the camera',
}));

SDTBarcode.init({
    licenseKey: "YOUR LICENSE KEY HERE",
    overlay: overlay,
    useFrontCamera: false,
    enableAutofocus: true,
    enableFlash: false
});

SDTBarcode.showScanner();
// SDTBarcode.hideScanner();
SDTBarcode.flashOn();
// SDTBarcode.flashOff();