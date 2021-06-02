package com.example.lab_sound_flutter;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothProfile;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioManager;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;

/** LabSoundFlutterPlugin */
public class LabSoundFlutterPlugin implements FlutterPlugin, MethodCallHandler, StreamHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private static MethodChannel channel;
  private static EventChannel eventChannel;
  private static EventSink sink;
  private Context applicationContext;

  private static final String TAG = "HeadsetStatus";

  @Override
  public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
    this.applicationContext = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter.event/lab_sound_flutter/headset_status");
    eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "flutter.event/lab_sound_flutter/headset_status_handler");
    channel.setMethodCallHandler(this);
    eventChannel.setStreamHandler(this);
  }


  @Override
  public void onMethodCall(MethodCall call,  Result result) {
    if (call.method.equals("getHeadsetStatus")) {
      int i = getHeadsetStatus();  //刚进来获取状态
//      if(i == 1){
//        Log.d(TAG, "有线耳机处于连接状态");
//      }else if(i == 2){
//        Log.d(TAG, "蓝牙耳机处于连接状态");
//      }else {
//        Log.d(TAG, "当前未连接耳机");
//      }
      result.success(i);
    }else {
      result.notImplemented();
    }
  }

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {

    this.sink = events;
    registerHeadsetPlugReceiver();
  }

  @Override
  public void onCancel(Object arguments) {
    this.sink = null;
    unRegisterHeadsetPlugReceiver();
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    applicationContext = null;
    channel.setMethodCallHandler(null);
    channel = null;
    eventChannel.setStreamHandler(null);
    eventChannel = null;
  }


  /**
   * 获取耳机的连接状态
   * @return 根据返回的int值进行自己的逻辑操作
   */
  public int getHeadsetStatus(){
    AudioManager audioManager = (AudioManager)  new ContextWrapper(applicationContext).getSystemService(Context.AUDIO_SERVICE); //获取声音管理器
    if(audioManager.isWiredHeadsetOn()){  //有线耳机是否连接
      return 1;
    }

    BluetoothAdapter ba = BluetoothAdapter.getDefaultAdapter();  //蓝牙耳机
    if (ba == null){ //蓝牙耳机未连接
      return -1;
    } else if(ba.isEnabled()) {
      int a2dp = ba.getProfileConnectionState(BluetoothProfile.A2DP);              //可操控蓝牙设备，如带播放暂停功能的蓝牙耳机
      int headset = ba.getProfileConnectionState(BluetoothProfile.HEADSET);        //蓝牙头戴式耳机，支持语音输入输出
      int health = ba.getProfileConnectionState(BluetoothProfile.HEALTH);          //蓝牙穿戴式设备

      //查看是否蓝牙是否连接到三种设备的一种，以此来判断是否处于连接状态还是打开并没有连接的状态
      int flag = -1;
      if (a2dp == BluetoothProfile.STATE_CONNECTED) {
        flag = a2dp;
      } else if (headset == BluetoothProfile.STATE_CONNECTED) {
        flag = headset;
      } else if (health == BluetoothProfile.STATE_CONNECTED) {
        flag = health;
      }
      //说明连接上了三种设备的一种
      if (flag != -1) {
        return 2;
      }
    }
    return -2;
  }

  HashMap<String, Object> resultMap = new HashMap<>();
  /**
   * 注册监听
   */
  private void registerHeadsetPlugReceiver() {
    IntentFilter intentFilter = new IntentFilter();
    intentFilter.addAction(Intent.ACTION_HEADSET_PLUG);
    intentFilter.addAction(BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED);
    intentFilter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED);
    new ContextWrapper(applicationContext).registerReceiver(headsetPlugReceiver, intentFilter);
  }

  private BroadcastReceiver headsetPlugReceiver = new BroadcastReceiver() {

    @Override
    public void onReceive(Context context, Intent intent) {
      String action = intent.getAction();
      if (BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED.equals(action)) {
        resultMap.put("type","bluetooth_devices");
        int state = intent.getIntExtra(BluetoothAdapter.EXTRA_CONNECTION_STATE, -1);
        if (state == BluetoothAdapter.STATE_CONNECTED ) {
          resultMap.put("status","connect");
          sink.success(resultMap);
        }else if (state == BluetoothAdapter.STATE_DISCONNECTED){
          resultMap.put("status","disconnect");
          sink.success(resultMap);
        }
      }
      else if (BluetoothAdapter.ACTION_STATE_CHANGED.equals(action)) {
        int state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, -1);
        if (state == BluetoothAdapter.STATE_OFF) {
          resultMap.put("type","bluetooth_devices");
          resultMap.put("status","disconnect");
          sink.success(resultMap);
        }
      }else if ("android.intent.action.HEADSET_PLUG".equals(action)) {
        resultMap.put("type","headset_plug");
        if (intent.hasExtra("state")) {
          if (intent.getIntExtra("state", 0) == 0) {
            resultMap.put("status","disconnect");
            sink.success(resultMap);
          } else if(intent.getIntExtra("state", 0) == 1){
            resultMap.put("status","connect");
            sink.success(resultMap);
          }
        }
      }
    }

  };

  private void unRegisterHeadsetPlugReceiver(){
    new ContextWrapper(applicationContext).unregisterReceiver(headsetPlugReceiver);
  }


}
