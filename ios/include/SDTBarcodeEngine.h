//
//  SDTBarcodeEngine.h
//  The engine for reading barcode values form image data
//
//  Copyright 2012 SD-TOOLKIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SDTBARCODETYPE_UNKNOWN		0x00000000// Unknown
#define SDTBARCODETYPE_CODABAR		0x00000001// Codabar
#define SDTBARCODETYPE_CODE128		0x00000002// Code 128
#define SDTBARCODETYPE_CODE32		0x00000004// Code 32 (also known as Base 32, Pharma 32/39, and Italian Pharmacode)
#define SDTBARCODETYPE_CODE39		0x00000008// Code 39
#define SDTBARCODETYPE_CODE93		0x00000010// Code 93
#define SDTBARCODETYPE_CODE11		0x00000020// Code 11
#define SDTBARCODETYPE_EAN13		0x00000040// EAN13,
#define SDTBARCODETYPE_EAN8			0x00000080// EAN8
#define SDTBARCODETYPE_EAN5			0x00000100// EAN5
#define SDTBARCODETYPE_I2OF5		0x00000200// I2of5 (Interleaved 2 of 5)
#define SDTBARCODETYPE_PATCH_CODE	0x00000400// Patch code
#define SDTBARCODETYPE_POSTNET		0x00000800// Postnet
#define SDTBARCODETYPE_PLUS2		0x00001000// Plus2 (2-digit supplementals assoc. with EAN and UPC)
#define SDTBARCODETYPE_PLUS5		0x00002000// Plus5 (5-digit supplementals assoc. with EAN and UPC)
#define SDTBARCODETYPE_UPCA			0x00004000// UPC-A
#define SDTBARCODETYPE_UPCB			0x00008000// UPC-B
#define SDTBARCODETYPE_MSI			0x00100000 // MSI
#define SDTBARCODETYPE_UPCE			0x00200000 // UPC-E
#define SDTBARCODETYPE_PHARMACODE	0x00400000 // PHARMACODE

#define SDTBARCODETYPE_ALL_1D		0x0070ffff // All above 1-D Barcodes

#define SDTBARCODETYPE_INTELLIMAIL	0x00010000 // Intelligent Mail
#define SDTBARCODETYPE_DATAMATRIX	0x00020000// DataMatrix
#define SDTBARCODETYPE_PDF417		0x00040000// PDF417
#define SDTBARCODETYPE_QRCODE		0x00080000// QR Code

#define SDTBARCODETYPE_ALL_2D		0x000f0000// All above 2-D Barcodes

#define SDTREADDIRECTION_LTR		0x01 // Left-to-right
#define SDTREADDIRECTION_RTL		0x02 // Right-to-Left
#define SDTREADDIRECTION_TTB		0x04 // Top-to-Bottom
#define SDTREADDIRECTION_BTT		0x08 // Bottom-to-top

#define SDTREADDIRECTION_ALL		0x0f // All directions



@interface SDTBarcodeEngine : NSObject <UIAlertViewDelegate> {
	void* handle;
}


-(id)initWithLicense:(NSString*)license;

-(void)setUpgradeLicense:(NSString*)license;

-(void)setReadInputDirections:(int)flags;

-(void)setReadInputTypes:(int)flags;

-(void)setActiveScanRectangleLeft:(int)left andTop:(int)top andRight:(int)right andBottom:(int)bottom;

-(int)readImage:(CGImageRef)image;

-(int)getResultsCount;

-(int)getResultValueAtPos:(int)position storeIn:(NSMutableString*)outString;

-(int)getResultTypeAtPos:(int)position;

-(int)getResultTypeNameAtPos:(int)position storeIn:(NSMutableString*)outString;

-(int)getResultDirectionAtPos:(int)position;

-(int)getResultPositionLeftAtPos:(int)position;

-(int)getResultPositionTopAtPos:(int)position;

-(int)getResultPositionRightAtPos:(int)position;

-(int)getResultPositionBottomAtPos:(int)position;

-(void)setCameraSource:(BOOL)isCameraSource;

@end

