/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"
#import <UIKit/UIKit.h>
#import "SDTBarcodeScannerViewController.h"

@interface ALSDTBarcodeModule : TiModule<SDTBarcodeScannerViewControllerDelegate> {
    SDTBarcodeScannerViewController* scaner;
}

- (BOOL)onRecognitionComplete:(SDTBarcodeEngine*)theEngine onImage:(CGImageRef)theImage orientation:(UIImageOrientation)theOrientation;

@end
