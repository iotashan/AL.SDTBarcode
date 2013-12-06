# AL.SDTBarcode Module

## Description

A wrapper for a large ammount of the SD-Toolkit barcode SDK for iOS and Android.

Why not just use z-lib based SDKs? Well they kinda suck. This SDK is inexpesive to license and royalty free. It also works WAY better!

We will be expanding this module as we need to for new projects and to update the SDK for existing projects. Feel free to contribute.

## Useage

var SDTBarcode = require('AL.SDTBarcode');
var win = Ti.UI.createWindow({
    backgroundColor:'white'
});
win.open();

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