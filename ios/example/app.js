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
  height: 100,
  width: 320,
  backgroundColor: "green",
  opacity: 0.6,
});

var button = Ti.UI.createButton({
        bottom:2,
        right:20,
        height:35,
        width:35,
        backgroundColor:'blue',
        style:Ti.UI.iPhone.SystemButtonStyle.PLAIN,
    });
    button.addEventListener('click', function() {
  alert('works!');
})
overlay.add(button);

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