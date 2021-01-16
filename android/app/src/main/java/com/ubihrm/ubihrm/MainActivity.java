package com.ubihrm.ubihrm;

import android.Manifest;
import android.app.Activity;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.IntentSender;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import android.os.Build;
//import android.os.Bundle;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import android.provider.Settings;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;

import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.ResolvableApiException;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResponse;
import com.google.android.gms.location.LocationSettingsStatusCodes;
import com.google.android.gms.location.SettingsClient;
import com.google.android.gms.tasks.OnCanceledListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import io.flutter.Log;
//import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
//import io.flutter.plugins.GeneratedPluginRegistrant;
///
import io.flutter.embedding.android.FlutterActivity;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  // private LocationAssistant assistant;
  private static final String CHANNEL = "location.spoofing.check";
  private static final String CAMERA_CHANNEL = "update.camera.status";
  private static final String FACEBOOK_CHANNEL = "log.facebook.data";
  private boolean cameraOpened = false;
  //private BackgroundLocationService gpsService;
  private Location mCurrentLocation;


  private SettingsClient mSettingsClient;
  private LocationSettingsRequest mLocationSettingsRequest;
  private static final int REQUEST_CHECK_SETTINGS = 214;
  private static final int REQUEST_ENABLE_GPS = 516;

  private FusedLocationProviderClient fusedLocationClient;


  MethodChannel channel;
  private boolean mockLocationsEnabled = false;
  private Location lastMockLocation;
  private int numGoodReadings = 0;
  private LocationRequest locationRequest;
  private LocationCallback locationCallback;
  private String filePath = "1";
  private Context context = null;

  protected void createLocationRequest() {
    LocationRequest locationRequest = LocationRequest.create();
    locationRequest.setInterval(10000);
    locationRequest.setFastestInterval(5000);
    locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
  }

  private void startLocationUpdates() {
        /*
        fusedLocationClient.requestLocationUpdates(locationRequest,
                locationCallback,
                Looper.getMainLooper());*/
  }

  private void checkMockLocations() {
    // Starting with API level >= 18 we can (partially) rely on .isFromMockProvider()
    // (http://developer.android.com/reference/android/location/Location.html#isFromMockProvider%28%29)
    // For API level < 18 we have to check the Settings.Secure flag
    //checkInternet();
    if (Build.VERSION.SDK_INT < 18 &&
            !Settings.Secure.getString(getApplicationContext().getContentResolver(), Settings
                    .Secure.ALLOW_MOCK_LOCATION).equals("0")) {
      mockLocationsEnabled = true;

    } else
      mockLocationsEnabled = false;

    android.util.Log.i("shashank", "checking Mock Location " + mockLocationsEnabled);
  }

  private boolean isLocationPlausible(Location location) {
    checkMockLocations();
    if (location == null) return false;

    boolean isMock = mockLocationsEnabled || (Build.VERSION.SDK_INT >= 18 && location.isFromMockProvider());
    if (isMock) {
      lastMockLocation = location;
      numGoodReadings = 0;
    } else
      numGoodReadings = Math.min(numGoodReadings + 1, 1000000); // Prevent overflow

    // We only clear that incident record after a significant show of good behavior
    if (numGoodReadings >= 20) lastMockLocation = null;

    // If there's nothing to compare against, we have to trust it
    if (lastMockLocation == null) return true;

    // And finally, if it's more than 1km away from the last known mock, we'll trust it
    double d = location.distanceTo(lastMockLocation);
    return (d > 1000);
  }

  public void updateLocationToFlutter(MethodChannel channel, Location mLastLocation) {

    long previousTime = 0, currentTime = 0;

    boolean timeSpoofed = false;
    boolean plausible;
    String ifMocked = "";
    HashMap<String, String> responseMap = new HashMap<String, String>();
    //android.util.Log.i("LocationWOService", "LocationChanged: "+location);
    if (isLocationPlausible(mLastLocation)) {
      plausible = true;
      android.util.Log.i("shashank", "Plausible");
      ifMocked = "No";
    } else {
      plausible = false;
      ifMocked = "Yes";
      android.util.Log.i("shashank", "Not Plausible");
    }

    android.util.Log.i("TimeFromLocation", mLastLocation.getTime() + "");
    if (String.valueOf(mLastLocation.getTime()) != null) {
      currentTime = TimeUnit.MILLISECONDS.toMinutes(mLastLocation.getTime());
      if (previousTime != 0 && !timeSpoofed) {
        if ((currentTime - previousTime) > 10 || (currentTime - previousTime) < -10) {
          timeSpoofed = true;
          android.util.Log.i("TimeSpoofed", "detected");
        }

      }
      previousTime = currentTime;

    }

    if (String.valueOf(mLastLocation.getLatitude()) != null)
      responseMap.put("latitude", String.valueOf(mLastLocation.getLatitude()));
    if (String.valueOf(mLastLocation.getLongitude()) != null)
      responseMap.put("longitude", String.valueOf(mLastLocation.getLongitude()));
    responseMap.put("internet", "Internet Available");

    responseMap.put("mocked", ifMocked);
    responseMap.put("TimeSpoofed", timeSpoofed ? "Yes" : "No");

    channel.invokeMethod("locationAndInternet", responseMap);

    android.util.Log.i(getClass().getSimpleName(), " Lat: " + responseMap.get("latitude") + " Longi: " + responseMap.get("longitude"));


  }


  //LocationListenerExecuter listenerExecuter;
  @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    ActivityCompat.requestPermissions(this,
            new String[]{Manifest.permission.CAMERA, Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE/*,Manifest.permission.READ_CONTACTS*/}, 1);


    Log.i("Dialog", "hdghdgjdgjdgdjgdjgdjggggggg");

    channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
    fusedLocationClient = LocationServices.getFusedLocationProviderClient(this);
    for (int ij = 0; ij < 10; ij++) {
      if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
        // TODO: Consider calling
        //    ActivityCompat#requestPermissions
        // here to request the missing permissions, and then overriding
        //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
        //                                          int[] grantResults)
        // to handle the case where the user grants the permission. See the documentation
        // for ActivityCompat#requestPermissions for more details.
        return;
      }
      fusedLocationClient.getLastLocation()
              .addOnSuccessListener(this, new OnSuccessListener<Location>() {
                @Override
                public void onSuccess(Location location) {
                  // Got last known location. In some rare situations this can be null.
                  if (location != null) {

                    mCurrentLocation = location;
                    //if(mCurrentLocation.hasAccuracy())
                    updateLocationToFlutter(channel, mCurrentLocation);

                  }
                }
              });
    }

    locationRequest = LocationRequest.create();
    locationRequest.setInterval(10000);
    locationRequest.setFastestInterval(5000);
    locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
    locationCallback = new LocationCallback() {
      @Override
      public void onLocationResult(LocationResult locationResult) {
        if (locationResult == null) {
          return;
        }
        for (Location location : locationResult.getLocations()) {
          mCurrentLocation = location;
          if (mCurrentLocation.hasAccuracy())
            updateLocationToFlutter(channel, mCurrentLocation);
        }
      }

      ;
    };

    fusedLocationClient.requestLocationUpdates(locationRequest,
            locationCallback,
            Looper.getMainLooper());


/*
      Intent i=getIntent();
      final Handler handler = new Handler();
      handler.postDelayed(new Runnable() {
          @Override
          public void run() {
              onNewIntent(i);
          }
      }, 7000);

    //onNewIntent(i);
*/

    //showLocationDialog();
    // FacebookEventLoggers facebookLogger=new FacebookEventLoggers(getApplicationContext());
/*
      Intent intent1 = new Intent();

      String manufacturer = android.os.Build.MANUFACTURER;

      switch (manufacturer) {

          case "xiaomi":
              intent1.setComponent(new ComponentName("com.miui.securitycenter",
                      "com.miui.permcenter.autostart.AutoStartManagementActivity"));
              break;
          case "oppo":
              intent1.setComponent(new ComponentName("com.coloros.safecenter",
                      "com.coloros.safecenter.permission.startup.StartupAppListActivity"));

              break;
          case "vivo":
              intent1.setComponent(new ComponentName("com.vivo.permissionmanager",
                      "com.vivo.permissionmanager.activity.BgStartUpManagerActivity"));
              break;
      }

      List<ResolveInfo> arrayList =  getPackageManager().queryIntentActivities(intent1,
              PackageManager.MATCH_DEFAULT_ONLY);

      if (arrayList.size() > 0) {
          startActivity(intent1);
      }
*/

/*
      Intent intent111 = new Intent(getApplicationContext(), MainActivity.class);
      intent111.setAction(Intent.ACTION_RUN);
      intent111.putExtra("route", "settings");
      intent111.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      getApplicationContext().startActivity(intent111);
*/




  }

  private Map<Object, Runnable> listeners = new HashMap<>();

  void startListening(Object listener, EventChannel.EventSink emitter) {
    // Prepare a timer like self calling task
    // emitter.success("Hello listener! shashank " + (System.currentTimeMillis() / 1000));
    final Handler handler = new Handler();
    listeners.put(listener, new Runnable() {
      @Override
      public void run() {
        if (listeners.containsKey(listener)) {
          // Send some value to callback
          emitter.success(filePath);
          filePath = "1";
          Log.d("timer", "" + (System.currentTimeMillis() / 1000));
          if (!filePath.equals("1")) {
            Log.d("shashank11", "listener removed");
            handler.removeCallbacksAndMessages(null);

          } else {
            Log.d("shashank11", "listener delayed");
            handler.postDelayed(this, 1000);
          }
        }
      }
    });

    // Run task

    handler.postDelayed(listeners.get(listener), 1000);

  }

  void cancelListening(Object listener) {
    // Remove callback
    listeners.remove(listener);
    Log.d("Diego", "Count: " + listeners.size());
  }

  public void openLocationDialog() {


    LocationSettingsRequest.Builder builder = new LocationSettingsRequest.Builder();
    builder.addLocationRequest(new LocationRequest().setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY));
    builder.setAlwaysShow(true);
    mLocationSettingsRequest = builder.build();

    mSettingsClient = LocationServices.getSettingsClient(MainActivity.this);

    mSettingsClient
            .checkLocationSettings(mLocationSettingsRequest)
            .addOnSuccessListener(new OnSuccessListener<LocationSettingsResponse>() {
              @Override
              public void onSuccess(LocationSettingsResponse locationSettingsResponse) {
                //Success Perform Task Here
              }
            })
            .addOnFailureListener(new OnFailureListener() {
              @Override
              public void onFailure(@NonNull Exception e) {
                int statusCode = ((ApiException) e).getStatusCode();
                switch (statusCode) {
                  case LocationSettingsStatusCodes.RESOLUTION_REQUIRED:
                    try {
                      ResolvableApiException rae = (ResolvableApiException) e;
                      rae.startResolutionForResult(MainActivity.this, REQUEST_CHECK_SETTINGS);
                    } catch (IntentSender.SendIntentException sie) {
                      Log.e("GPS", "Unable to execute request.");
                    }
                    break;
                  case LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE:
                    Log.e("GPS", "Location settings are inadequate, and cannot be fixed here. Fix in Settings.");
                }
              }
            })
            .addOnCanceledListener(new OnCanceledListener() {
              @Override
              public void onCanceled() {
                Log.e("GPS", "checkLocationSettings -> onCanceled");
              }
            });


  }

  @Override
  public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
    super.onActivityResult(requestCode, resultCode, data);

    if (requestCode == REQUEST_CHECK_SETTINGS) {
      switch (resultCode) {
        case Activity.RESULT_OK:
          //Success Perform Task Here
          manuallyStartAssistant();
          break;
        case Activity.RESULT_CANCELED:
          Log.e("GPS", "User denied to access location");
          openLocationDialog();
          break;
      }
    } else if (requestCode == REQUEST_ENABLE_GPS) {
      LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
      boolean isGpsEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);

      if (!isGpsEnabled) {
        openLocationDialog();
      } else {

        //navigateToUser();
        // manuallyStartAssistant();
      }
    } else if (requestCode == 444) {
    /*    Log.i("request code",""+requestCode);
        triggerRebirth(MainActivity.this);
*/
    } else if (requestCode == 1001) {

      if (data != null) {
        String buttonPressed = data.getStringExtra("buttonPressed");

        if (buttonPressed.equals("ok"))
          this.filePath = data.getStringExtra("filePath");
        else
          this.filePath = "cancelled";
        Log.i("shashank11", "" + filePath);

      } else {
        this.filePath = "cancelled";
      }

    /*    Log.i("request code",""+requestCode);
        triggerRebirth(MainActivity.this);
*/
    }
  }

  private void openGpsEnableSetting() {
    Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
    startActivityForResult(intent, REQUEST_ENABLE_GPS);
  }


  public void manuallyStartAssistant() {
    try {
      onPause();
      onResume();
    } catch (Exception e) {

    }
  }

  @Override
  public void onDestroy() {
    try {

      // if(gpsService!=null)
      // gpsService.stopTracking();
    } catch (Exception e) {

    }
    super.onDestroy();

  }

  @Override
  protected void onResume() {
    super.onResume();
    try {


      for (int ij = 0; ij < 10; ij++) {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
          // TODO: Consider calling
          //    ActivityCompat#requestPermissions
          // here to request the missing permissions, and then overriding
          //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
          //                                          int[] grantResults)
          // to handle the case where the user grants the permission. See the documentation
          // for ActivityCompat#requestPermissions for more details.
          return;
        }
        fusedLocationClient.getLastLocation()
                .addOnSuccessListener(this, new OnSuccessListener<Location>() {
                  @Override
                  public void onSuccess(Location location) {
                    // Got last known location. In some rare situations this can be null.
                    if (location != null) {

                      mCurrentLocation = location;
                      //if(mCurrentLocation.hasAccuracy())
                      updateLocationToFlutter(channel, mCurrentLocation);

                    }
                  }
                });
      }

      fusedLocationClient.requestLocationUpdates(locationRequest,
              locationCallback,
              Looper.getMainLooper());

    } catch (Exception e) {

    }
    // assistant.start();
  }

  @Override
  protected void onPause() {
    // assistant.stop();
    //if(!cameraOpened)
    super.onPause();
    try {
      fusedLocationClient.removeLocationUpdates(locationCallback);

    } catch (Exception e) {

    }
    //super.onPause();
  }


  @Override
  public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    if (permissions != null && permissions.length > 0) {
      for (int i = 0; i < permissions.length; i++) {

        try {
          if (permissions[i].equals(Manifest.permission.ACCESS_FINE_LOCATION)) {
            Log.i("Peeeerrrr", requestCode + "detected");
            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
              // TODO: Consider calling
              //    ActivityCompat#requestPermissions
              // here to request the missing permissions, and then overriding
              //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
              //                                          int[] grantResults)
              // to handle the case where the user grants the permission. See the documentation
              // for ActivityCompat#requestPermissions for more details.
              return;
            }
            fusedLocationClient.requestLocationUpdates(locationRequest,
                    locationCallback,
                    Looper.getMainLooper());

          }
        }
        catch(Exception e){

        }

      }
    }

    // Log.i("Perrrrr",permissions[1]+grantResults);

  }


  @Override
  public void onNewIntent(Intent intent){
    Bundle extras = intent.getExtras();

    Log.e("INTENT","Notification Recieved");


    if(extras != null){
      if(extras.containsKey("whereToGo"))
      {
        Log.i("WhereToGo",extras.getString("whereToGo"));
        HashMap<String, String> responseMap = new HashMap<String, String>();
        responseMap.put("page",extras.getString("whereToGo"));
        if(channel!=null){
          channel.invokeMethod("navigateToPage", responseMap);
          Log.i("togo","akah"+extras.getString("whereToGo"));
        }
      }
    }


  }

}