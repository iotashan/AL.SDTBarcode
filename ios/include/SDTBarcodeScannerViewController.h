//
//  SDTBarcodeScannerViewController.h
//  sdt-brc-ios-sample3
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVMetadataFormat.h>
#import "SDTBarcodeEngine.h"

@protocol SDTBarcodeScannerViewControllerDelegate 

- (BOOL)onRecognitionComplete:(SDTBarcodeEngine*)theEngine onImage:(CGImageRef)theImage orientation:(UIImageOrientation)theOrientation;

@end

@interface SDTBarcodeScannerViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>{

}

- (id)initWithLicenseEx:(NSString*)license
       callbackDelegate:(id<SDTBarcodeScannerViewControllerDelegate>) theDelegate
          customOverlay:(UIView*)customOverlay
         useFrontCamera:(BOOL)useFrontCamera
        enableAutofocus:(BOOL)enableAutofocus
            enableFlash:(BOOL)enableFlash
        closeButtonText:(NSString*)closeButtonText;

- (id)initWithLicenseEx:(NSString*)license
        callbackDelegate:(id<SDTBarcodeScannerViewControllerDelegate>) theDelegate
        customOverlay:(UIView*)customOverlay
        useFrontCamera:(BOOL)useFrontCamera
        enableAutofocus:(BOOL)enableAutofocus
        enableFlash:(BOOL)enableFlash;

- (id)initWithLicense:(NSString*)license callbackDelegate:(id<SDTBarcodeScannerViewControllerDelegate>) theDelegate;

- (void)setReadInputTypes:(int)flags;

- (void)setUpgradeLicense:(NSString*)license;

- (void)startScan:(UIViewController*)mainViewController;

- (void)stopScan;

- (void)setSupportedOrientations:(UIInterfaceOrientationMask)orientationsMask;

@end

