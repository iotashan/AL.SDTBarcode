/**
 * This file was auto-generated by the Titanium Module SDK helper for Android
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */
package al.sdtbarcode;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import sdt.brc.android.BarcodeReader;
import sdt.brc.android.BarcodeReaderResult;
import sdt.brc.android.BarcodeReaderUtil;
import sdt.brc.android.BarcodeScanActivity;
import sdt.brc.android.BarcodeScanDialog;
import sdt.brc.android.OnRecognitionListener;
import sdt.brc.android.OnBarcodeScanActivityRecognitionListener;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.YuvImage;
import android.view.View;

import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.Log;
import org.appcelerator.kroll.common.TiConfig;

import org.appcelerator.titanium.TiApplication;
import org.appcelerator.titanium.TiBlob;
import org.appcelerator.titanium.proxy.TiViewProxy;
import org.appcelerator.titanium.util.TiActivityResultHandler;


@Kroll.module(name="Sdtbarcode", id="al.sdtbarcode")
public class SdtbarcodeModule extends KrollModule
{

	// Standard Debugging variables
	private static final String LCAT = "SdtbarcodeModule";
	private static final boolean DBG = TiConfig.LOGD;

	// You can define constants with @Kroll.constant, for example:
	// @Kroll.constant public static final String EXTERNAL_NAME = value;

	BarcodeScanDialog mCamDlg = null;
	private String licenseKey = "DEVELOPER LICENSE";
	private TiViewProxy overlay;
	private boolean useFrontCamera = false;
	private boolean enableAutofocus = true;
	private boolean enableFlash = false;
	private boolean showActiveArea = false;
	private boolean timeToClose = false;
	
	public SdtbarcodeModule()
	{
		super();
	}

	private static SdtbarcodeModule _instance;

	public static SdtbarcodeModule getInstance() {
		return _instance;
	}

	@Kroll.onAppCreate
	public static void onAppCreate(TiApplication app)
	{
		Log.d(LCAT, "inside onAppCreate");
		// put module init code that needs to run when the application is created
	}

	// Methods
	@Kroll.method
	@SuppressWarnings({ "rawtypes" })
	public void init(@Kroll.argument(optional = false) HashMap args) {
		KrollDict argsDict = new KrollDict(args);

		licenseKey = argsDict.optString("licenseKey","DEVELOPER LICENSE");

		if (args.containsKey("overlay")) {
			overlay = (TiViewProxy) args.get("overlay");
		} else {
			overlay = null;
		}

		useFrontCamera = argsDict.optBoolean("useFrontCamera", false);
		enableAutofocus = argsDict.optBoolean("enableAutofocus", true);
		enableFlash = argsDict.optBoolean("enableFlash", false);
		showActiveArea = argsDict.optBoolean("showActiveArea", false);
	}

	@Kroll.method
	public void showScanner() {
        Log.d(LCAT, "************************** showScanner()");
		BarcodeScanActivity.showBarcodeScanActivityForResult(	TiApplication.getInstance().getCurrentActivity(),
																21734,
																licenseKey,
																BarcodeReader.SDTBARCODE_CODE39,
																enableFlash,
																showActiveArea,
																new	OnBarcodeScanActivityRecognitionListener() {
																	
																	@Override
																	public boolean onActivityRecognitionResults(List results, YuvImage srcImage) {
                                                                        Log.d(LCAT, "************************** onActivityRecognitionResults(List results, YuvImage srcImage)");
																		// Populate results
																		int resultCount = 0;
																		String firstResult = "";
																		List<HashMap> parsedResults = new ArrayList<HashMap>();
																		TiBlob image;
																		

																		for (BarcodeReaderResult barcodeReaderResult : (List<BarcodeReaderResult>)results) {
																			resultCount++;
                                                                            Log.d(LCAT, "************************** result "+resultCount+" : " + barcodeReaderResult.getValue());
																			HashMap<String, Object> resultObject = new HashMap<String, Object>();
																			resultObject.put("barcode_type", barcodeReaderResult.getTypeName());
																			resultObject.put("value", barcodeReaderResult.getValue());
																			if (firstResult == "") {
																				firstResult = barcodeReaderResult.getValue();
																			}
																			parsedResults.add(resultObject);
																		}
																		Object[] retResults = parsedResults.toArray(new Object[parsedResults.size()]);
																		
																		if (firstResult != "" && firstResult.length() > 16) {
Log.d(LCAT, "************************** firstResult.length() > 16");
																			// convert Yuv to TiBlob
																			if(srcImage != null) {
																				Bitmap bm = BarcodeReaderUtil.decodeImageToBitmap(srcImage);
																				// convert to png
																				ByteArrayOutputStream bos = new ByteArrayOutputStream();
																				bm.compress(CompressFormat.PNG, 100, bos);
						
																				image = TiBlob.blobFromData(bos.toByteArray(),"image/png");
																			} else {
																				image = null;
																			}

																			KrollDict event = new KrollDict();
																			event.put("resultCount",resultCount);
																			event.put("results",retResults);
																			event.put("image",image);

																			fireEvent("recognitionComplete", event);
																			
																			return true;
																		} else {
																			return false;
																		}
																	}
																},
																overlay.getOrCreateView().getNativeView()
															);
	}

	@Kroll.method
	public void hideScanner() {
		TiApplication.getInstance().getCurrentActivity().finishActivity(21734);
	}

	@Kroll.method
	public void flashOn() {
		return;
	}

	@Kroll.method
	public void flashOff() {
		return;
	}

}
