/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import <UIKit/UIKit.h>
#import "SDTBarcodeScannerViewController.h"
#import "TiUIView.h"

@interface ALSDTBarcodeView : TiUIView<SDTBarcodeScannerViewControllerDelegate> {
    SDTBarcodeScannerViewController* scaner;
}

- (BOOL)onRecognitionComplete:(SDTBarcodeEngine*)theEngine onImage:(CGImageRef)theImage orientation:(UIImageOrientation)theOrientation;
@end