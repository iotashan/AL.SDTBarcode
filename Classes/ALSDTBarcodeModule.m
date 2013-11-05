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
    NSLog(@"test here 2");

    NSLog(@"test here3");

    ENSURE_UI_THREAD(init,args);
    ENSURE_SINGLE_ARG(args,NSDictionary);
    
    UIView *overlayView = nil;
    TiViewProxy *overlayProxy = [args objectForKey:@"overlay"];
    if (overlayProxy != nil)
    {
        ENSURE_TYPE(overlayProxy, TiViewProxy);
        overlayView = ViewForViewProxy(overlayProxy);

        //[overlayProxy layoutChildren:NO];
        [TiUtils setView:overlayView positionRect:[UIScreen mainScreen].bounds];
    }
    
    BOOL *useFrontCamera = [TiUtils boolValue: [args objectForKey:@"useFrontCamera"]];
    if (!useFrontCamera) useFrontCamera = false;
    
    BOOL *enableAutofocus = [TiUtils boolValue: [args objectForKey:@"enableAutofocus"]];
    if (!enableAutofocus) enableAutofocus = true;

    BOOL *enableFlash = [TiUtils boolValue: [args objectForKey:@"enableFlash"]];
    if (!enableFlash) enableFlash = false;

    scaner = [[[SDTBarcodeScannerViewController alloc] initWithLicenseEx:@"DEVELOPER LICENSE"
                                                        callbackDelegate:self
                                                           customOverlay:overlayView
                                                          useFrontCamera:false
                                                         enableAutofocus:true
                                                             enableFlash:false] retain];
}

-(id)showScanner:(id)args
{
    NSLog(@"test here");
	if(scaner != nil){
        ENSURE_UI_THREAD(showScanner, args);
        NSLog(@"test here 4");

        // Specify barcode type flags
		[scaner setReadInputTypes:SDTBARCODETYPE_ALL_1D];
		[scaner startScan: (UIViewController*) self];
        
    }
    
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
