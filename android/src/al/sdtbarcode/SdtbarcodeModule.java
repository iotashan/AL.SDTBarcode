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
	}

	@Kroll.method
	public void showScanner() {
		mCamDlg = new BarcodeScanDialog(TiApplication.getInstance().getCurrentActivity(),licenseKey,overlay.getOrCreateView().getNativeView());
//		mCamDlg = new BarcodeScanDialog(TiApplication.getInstance().getCurrentActivity(),licenseKey);

		if (mCamDlg != null) {
			mCamDlg.setBarcodeTypes(BarcodeReader.SDTBARCODE_CODE39|BarcodeReader.SDTBARCODE_CODE128);
			mCamDlg.showActiveArea(true);

			mCamDlg.setRecognitionListener(new OnRecognitionListener() {
				public void onRecognitionResults(List results, YuvImage srcImage) {
					// Populate results
					int resultCount = 0;
					List<HashMap> parsedResults = new ArrayList<HashMap>();
					TiBlob image;

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

					for (BarcodeReaderResult barcodeReaderResult : (List<BarcodeReaderResult>)results) {
						resultCount++;
						HashMap<String, Object> resultObject = new HashMap<String, Object>();
						resultObject.put("barcode_type", barcodeReaderResult.getTypeName());
						resultObject.put("value", barcodeReaderResult.getValue());
						parsedResults.add(resultObject);
					}
					Object[] retResults = parsedResults.toArray(new Object[parsedResults.size()]);

					KrollDict event = new KrollDict();
					event.put("resultCount",resultCount);
					event.put("results",retResults);
					event.put("image",image);

					fireEvent("recognitionComplete", event);
				}
			});
			mCamDlg.enableFlashlight(enableFlash);

			mCamDlg.show();
		}
	}

	@Kroll.method
	public void hideScanner() {
		if (mCamDlg != null) {
			mCamDlg.hide();
			mCamDlg.dismiss();
			mCamDlg = null;
		}
	}

	@Kroll.method
	public void flashOn() {
		if (mCamDlg != null) {
			mCamDlg.enableFlashlight(true);
		}
	}

	@Kroll.method
	public void flashOff() {
		if (mCamDlg != null) {
			mCamDlg.enableFlashlight(false);
		}
	}

}

