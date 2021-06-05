package com.example.lab_sound_flutter;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothProfile;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioDeviceCallback;
import android.media.AudioDeviceInfo;
import android.media.AudioManager;
import android.os.Build;
import android.util.Log;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;

/**
 * LabSoundFlutterPlugin
 */
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
    public void onMethodCall(MethodCall call, Result result) {
        if(call.method.equals("getDevices")) {
            ArrayList<Object> list = new ArrayList();
            AudioManager am = (AudioManager) applicationContext.getSystemService(Context.AUDIO_SERVICE);
            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.M) {
                AudioDeviceInfo[] devices = am.getDevices(AudioManager.GET_DEVICES_OUTPUTS);
                for (int i = 0; i < devices.length; i++) {
                    list.add(deviceInfoToMap(devices[i]));
                }
            }
            result.success(list);
        } else {
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

    HashMap<String, Object> deviceInfoToMap(AudioDeviceInfo device) {
        HashMap<String, Object> d = new HashMap<>();
        if (Build.VERSION.SDK_INT >= 23) {
            if(Build.VERSION.SDK_INT >= 30) {
                d.put("address", device.getAddress());
            }
            d.put("type", device.getType());
            d.put("id", device.getId());
            d.put("channelCounts", device.getChannelCounts());
            d.put("sampleRates", device.getSampleRates());
            d.put("productName", device.getProductName());
            d.put("isSink", device.isSink());
            d.put("isSource", device.isSource());
        }
        return d;
    }

    /**
     * 注册监听
     */
    private void registerHeadsetPlugReceiver() {

        if(Build.VERSION.SDK_INT >= 23) {
            AudioManager am = (AudioManager) applicationContext.getSystemService(Context.AUDIO_SERVICE);
            this.audioDeviceCallback = new AudioDeviceCallback() {
                @Override
                public void onAudioDevicesAdded(AudioDeviceInfo[] addedDevices) {
                    HashMap<String, Object> resultMap = new HashMap<>();
                    resultMap.put("type", "onAudioDevicesAdded");
                    ArrayList<Object> list = new ArrayList();
                    for (int i = 0; i < addedDevices.length; i++) {
                        list.add(deviceInfoToMap(addedDevices[i]));
                    }
                    resultMap.put("addedDevices", list);
                    sink.success(resultMap);
                }
                @Override
                public void onAudioDevicesRemoved(AudioDeviceInfo[] removedDevices) {
                    HashMap<String, Object> resultMap = new HashMap<>();
                    resultMap.put("type", "onAudioDevicesRemoved");
                    ArrayList<Object> list = new ArrayList();
                    for (int i = 0; i < removedDevices.length; i++) {
                        list.add(deviceInfoToMap(removedDevices[i]));
                    }
                    resultMap.put("removedDevices", list);
                    sink.success(resultMap);
                }
            };
            am.registerAudioDeviceCallback(this.audioDeviceCallback, null);
        }

        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED);
        intentFilter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED);

        // https://developer.android.com/reference/android/media/AudioManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            intentFilter.addAction(AudioManager.ACTION_HEADSET_PLUG);
            intentFilter.addAction(AudioManager.ACTION_HDMI_AUDIO_PLUG);
        }else {
            intentFilter.addAction(Intent.ACTION_HEADSET_PLUG);
        }

        new ContextWrapper(applicationContext).registerReceiver(headsetPlugReceiver, intentFilter);
    }

    private AudioDeviceCallback audioDeviceCallback;



    private BroadcastReceiver headsetPlugReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            HashMap<String, Object> resultMap = new HashMap<>();
            resultMap.put("type", action);
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                if(AudioManager.ACTION_HEADSET_PLUG.equals(action) || AudioManager.ACTION_HDMI_AUDIO_PLUG.equals(action)) {
                    if(intent.hasExtra(AudioManager.EXTRA_AUDIO_PLUG_STATE))
                        resultMap.put("AUDIO_PLUG_STATE", intent.getIntExtra(AudioManager.EXTRA_AUDIO_PLUG_STATE, -1));
                    if(intent.hasExtra(AudioManager.EXTRA_MAX_CHANNEL_COUNT))
                        resultMap.put("EXTRA_MAX_CHANNEL_COUNT", intent.getIntExtra(AudioManager.EXTRA_MAX_CHANNEL_COUNT, -1));
                    if(intent.hasExtra(AudioManager.EXTRA_ENCODINGS))
                        resultMap.put("EXTRA_ENCODINGS", intent.getIntExtra(AudioManager.EXTRA_ENCODINGS, -1));
                    if (intent.hasExtra("state"))
                        resultMap.put("state", intent.getIntExtra("state", -1));
                    if (intent.hasExtra("name"))
                        resultMap.put("name", intent.getStringExtra("name"));
                    if (intent.hasExtra("microphone"))
                        resultMap.put("microphone", intent.getIntExtra("microphone", -1));
                }
            } else {
                if(Intent.ACTION_HEADSET_PLUG.equals(action)) {
                    if (intent.hasExtra("state"))
                        resultMap.put("state", intent.getIntExtra("state", -1));
                    if (intent.hasExtra("name"))
                        resultMap.put("name", intent.getStringExtra("name"));
                    if (intent.hasExtra("microphone"))
                        resultMap.put("microphone", intent.getIntExtra("microphone", -1));
                }
            }
            if(BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED.equals(action)) {
                if (intent.hasExtra(BluetoothAdapter.EXTRA_CONNECTION_STATE))
                    resultMap.put("EXTRA_CONNECTION_STATE", intent.getIntExtra(BluetoothAdapter.EXTRA_CONNECTION_STATE, -1));
            }
            if(BluetoothAdapter.ACTION_STATE_CHANGED.equals(action)) {
                if (intent.hasExtra(BluetoothAdapter.EXTRA_STATE))
                    resultMap.put("EXTRA_STATE", intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, -1));
            }
            sink.success(resultMap);
        }

    };

    private void unRegisterHeadsetPlugReceiver() {
        new ContextWrapper(applicationContext).unregisterReceiver(headsetPlugReceiver);
    }


}
