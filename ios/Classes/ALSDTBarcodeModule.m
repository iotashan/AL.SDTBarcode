/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ALSDTBarcodeModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"
#import "TiViewController.h"

UIView * ViewForViewProxy(TiViewProxy * proxy);

UIView * ViewForViewProxy(TiViewProxy * proxy)
{
    [[proxy view] setAutoresizingMask:UIViewAutoresizingNone];
    
    //make the proper resize !
    TiThreadPerformOnMainThread(^{
        [proxy windowWillOpen];
        [proxy reposition];
        [proxy windowDidOpen];
    },YES);
    return [[[TiViewController alloc] initWithViewProxy:proxy] autorelease].view;
}

#warning "Warning: Overriding default statusbar behavior for SDTBarcodeScannerViewController"
@implementation UIViewController(Privates)

- (BOOL)prefersStatusBarHidden {
    NSLog(@"%@", [self class])
    if ([NSStringFromClass([self class]) isEqualToString:@"SDTBarcodeScannerViewController"] ) {
        return YES;
    }
}


@end
@implementation ALSDTBarcodeModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"d7f0076e-356f-4c98-8948-86ebc379e3a2";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"AL.SDTBarcode";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma Public APIs

-(id)init:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);

    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSLog(@"capture device: %@", captureDevice);
    }

    TiThreadPerformOnMainThread(^{
        UIView *overlayView = nil;
        TiViewProxy *overlayProxy = [args objectForKey:@"overlay"];
        if (overlayProxy != nil)
        {
            ENSURE_TYPE(overlayProxy, TiViewProxy);
            overlayView = overlayProxy.view;
            
//            [TiUtils setView:overlayView positionRect:[UIScreen mainScreen].bounds];
        }
        
        BOOL useFrontCamera = [TiUtils boolValue:@"useFrontCamera" properties:args def:false];
        
        BOOL enableAutofocus = [TiUtils boolValue:@"enableAutofocus" properties:args def:true];

        BOOL enableFlash = [TiUtils boolValue:@"enableFlash" properties:args def:false];

        NSString* closeButtonText = [TiUtils stringValue:@"closeButtonText" properties:args def:@"Close"];

        NSString * licenseKey = [TiUtils stringValue:@"licenseKey" properties:args def:@"DEVELOPER LICENSE"];
        
        scaner = [[[SDTBarcodeScannerViewController alloc] initWithLicenseEx:licenseKey
                                                            callbackDelegate:self
                                                               customOverlay:overlayView
                                                              useFrontCamera:useFrontCamera
                                                             enableAutofocus:enableAutofocus
                                                                 enableFlash:enableFlash
                                                             closeButtonText: closeButtonText] retain];
        [scaner setSupportedOrientations: UIInterfaceOrientationMaskLandscapeLeft];

        
    }, YES);
    return nil;
}

-(id)showScanner:(id)args
{
	if(scaner != nil){
        ENSURE_UI_THREAD(showScanner, args);

        // Specify barcode type flags
		[scaner setReadInputTypes:SDTBARCODETYPE_CODE128|SDTBARCODETYPE_CODE39];
        [scaner startScan:[TiApp app].controller];
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {

            [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationNone];
        
        }
    }
    return nil;
}

-(id)hideScanner:(id)args {
    if (scaner != nil) {
        [scaner stopScan];
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {

            [[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:UIStatusBarAnimationNone];
        
        }

    }
    return nil;
}

-(id)flashOn:(id)args {
    if ([captureDevice hasTorch] && [captureDevice hasFlash]) {
        [captureDevice lockForConfiguration:nil];
        [captureDevice setTorchMode:AVCaptureTorchModeOn];
        [captureDevice setFlashMode:AVCaptureFlashModeOn];
        [captureDevice unlockForConfiguration];
    }
    return nil;
}

-(id)flashOff:(id)args {
    if ([captureDevice hasTorch] && [captureDevice hasFlash]) {
        [captureDevice lockForConfiguration:nil];
        [captureDevice setTorchMode:AVCaptureTorchModeOff];
        [captureDevice setFlashMode:AVCaptureFlashModeOff];
        [captureDevice unlockForConfiguration];
    }
    return nil;
}


// protocol SDTBarcodeScannerViewControllerDelegate implementation
- (BOOL)onRecognitionComplete:(SDTBarcodeEngine*)theEngine onImage:(CGImageRef)theImage orientation:(UIImageOrientation)theOrientation {
	 
	if(theEngine != nil) {
		int resultCount = [theEngine getResultsCount];
        if (!resultCount) {
            return NO; // on device, the scanner fires this method when it's not done
        }
        NSMutableArray* returnArray = [NSMutableArray array];
        NSMutableDictionary* returnObject = [[NSMutableDictionary alloc] init];
		for (int c = 0; c < resultCount; c++) {
			NSMutableString* resultValue = [[NSMutableString alloc] init];
			NSMutableString* resultTypeName = [[NSMutableString alloc] init];
			
			[theEngine getResultValueAtPos:c storeIn:resultValue];
			[theEngine getResultTypeNameAtPos:c storeIn:resultTypeName];
            
            [returnArray addObject:@{@"value":[resultValue copy], @"barcode_type":[resultTypeName copy]}];
            
			if(resultValue != nil) {
				[resultValue release];
			}
			if(resultTypeName != nil) {
				[resultTypeName release];
			}
		}
        
        [returnObject setObject:[NSNumber numberWithInteger:resultCount]  forKey:@"resultCount"];
        [returnObject setObject:returnArray  forKey:@"results"];
        [returnObject setObject: [[TiBlob alloc] initWithImage:[[[UIImage alloc] initWithCGImage: theImage scale: 1.0 orientation: theOrientation] autorelease]]  forKey:@"image"];
        
        [self fireEvent:@"recognitionComplete" withObject:returnObject];
        
        [returnArray release];

	}
	
	return NO;
    
}

@end
