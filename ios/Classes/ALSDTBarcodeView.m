/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ALSDTBarcodeView.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiViewController.h"

@implementation ALSDTBarcodeView

#pragma mark Internal


-(void)dealloc
{
    // Release objects and memory allocated by the view
    RELEASE_TO_NIL(scaner);
    
    [super dealloc];
}

-(void)initializeState
{
    // This method is called right after allocating the view and
    // is useful for initializing anything specific to the view
    
    [super initializeState];
}

#pragma Public APIs

-(id)showScanner:(id)args
{
    ENSURE_UI_THREAD(showScanner, args);

    NSLog(@"this far");
    SDTBarcodeEngine* barcodeEngine = [[SDTBarcodeEngine alloc] initWithLicense:@"YOUR DEVELOPER LICENSE"];

	if(scaner != nil){
        // Specify barcode type flags
		[scaner setReadInputTypes:SDTBARCODETYPE_ALL_1D];
		[scaner startScan: (UIViewController*) self];
    }

    UIView *overlayView = nil;
    TiViewProxy *overlayProxy = [args objectForKey:@"overlay"];
    if (overlayProxy != nil)
    {
        overlayView = [overlayProxy view];
        
        //[overlayProxy layoutChildren:NO];
        [TiUtils setView:overlayView positionRect:[UIScreen mainScreen].bounds];
    }
    
    BOOL *useFrontCamera = [[args objectForKey:@"useFrontCamera"] boolValue];
    if (!useFrontCamera) useFrontCamera = false;
    
    BOOL *enableAutofocus = [[args objectForKey:@"enableAutofocus"] boolValue];
    if (!enableAutofocus) enableAutofocus = true;

    BOOL *enableFlash = [[args objectForKey:@"enableFlash"] boolValue];
    if (!enableFlash) enableFlash = false;


	scaner = [[[SDTBarcodeScannerViewController alloc] initWithLicenseEx:@"DEVELOPER LICENSE"
                                                        callbackDelegate:self
                                                           customOverlay:overlayView
                                                          useFrontCamera:useFrontCamera
                                                         enableAutofocus:enableAutofocus
                                                             enableFlash:enableFlash] retain];
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
            
			//textView.text = [textView.text stringByAppendingFormat:@"%@ - %@", resultTypeName, resultValue];
            //textView.text = [textView.text stringByAppendingString:@"\n"];
			
			if(resultValue != nil) {
				[resultValue release];
			}
			if(resultTypeName != nil) {
				[resultTypeName release];
			}
		}
		
	}
	
    
	if(theImage != nil) {
		//NSLog(@"sdt_brc_ios_sample3ViewController::onRecognitionComplete. Set image = %d", (id)theImage);
		
        //imageView.image = [[[UIImage alloc] initWithCGImage: theImage scale: 1.0 orientation: theOrientation] autorelease];
	}
    
	//NSLog(@"onRecognitionComplete <-");
    
	//Returning YES will close scanner dialog
	return YES;
    
}

@end
