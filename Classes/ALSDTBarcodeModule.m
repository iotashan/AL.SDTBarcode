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
	
	NSLog(@"[INFO] %@ loaded",self);

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

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
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
        }
        
        BOOL useFrontCamera = [TiUtils boolValue:@"useFrontCamera" properties:args def:false];
        
        BOOL enableAutofocus = [TiUtils boolValue:@"enableAutofocus" properties:args def:true];

        BOOL enableFlash = [TiUtils boolValue:@"enableFlash" properties:args def:false];

        NSString * licenseKey = [TiUtils stringValue:@"licenseKey" properties:args def:@"DEVELOPER LICENSE"];
        
        scaner = [[[SDTBarcodeScannerViewController alloc] initWithLicenseEx:licenseKey
                                                            callbackDelegate:self
                                                               customOverlay:overlayView
                                                              useFrontCamera:useFrontCamera
                                                             enableAutofocus:enableAutofocus
                                                                 enableFlash:enableFlash] retain];
        
    }, YES);
    return nil;
}

-(id)showScanner:(id)args
{
	if(scaner != nil){
        ENSURE_UI_THREAD(showScanner, args);

        // Specify barcode type flags
		[scaner setReadInputTypes:SDTBARCODETYPE_ALL_1D];
        [scaner startScan:[TiApp app].controller];
    }
    return nil;
}

-(id)hideScanner:(id)args {
    if (scaner != nil) {
        [scaner stopScan];
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
	
	//NSLog(@"onRecognitionComplete ->");
    
    
	if(theEngine != nil) {
		int resultCount = [theEngine getResultsCount];
		for (int c = 0; c < resultCount; c++) {
			NSMutableString* resultValue = [[NSMutableString alloc] init];
			NSMutableString* resultTypeName = [[NSMutableString alloc] init];
			
			[theEngine getResultValueAtPos:c storeIn:resultValue];
			[theEngine getResultTypeNameAtPos:c storeIn:resultTypeName];
            
            [self fireEvent:@"scan_complete" withObject:@{@"value":[resultValue copy], @"barcode_type":[resultTypeName copy]}];
			
			if(resultValue != nil) {
				[resultValue release];
			}
			if(resultTypeName != nil) {
				[resultTypeName release];
			}
		}
		
	}
	
    /*
	if(theImage != nil) {
		NSLog(@"sdt_brc_ios_sample3ViewController::onRecognitionComplete. Set image = %d", (id)theImage);
		
        //imageView.image = [[[UIImage alloc] initWithCGImage: theImage scale: 1.0 orientation: theOrientation] autorelease];
	}
    */
    
	//NSLog(@"onRecognitionComplete <-");
    
	//Returning YES will close scanner dialog
	return YES;
    
}

@end
