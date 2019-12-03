package com.example.flutter_base;

import android.app.Activity;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.view.FlutterView;

/**
 * author: wuyangyi
 * date: 2019-11-30
 * android调flutter 插件
 */
public class MyFlutterEventPlugin implements EventChannel.StreamHandler {
    private static final String TAG = MyFlutterEventPlugin.class.getSimpleName();
    private EventChannel.EventSink eventSink;
    private Activity activity;

    public static MyFlutterEventPlugin registerWith(FlutterView flutterView) {
        String CHANNEL = "com.example.flutter_base/event_plugin";
        MyFlutterEventPlugin myFlutterEventPlugin = new MyFlutterEventPlugin(flutterView);
        new EventChannel(flutterView, CHANNEL).setStreamHandler(myFlutterEventPlugin);
        return myFlutterEventPlugin;
    }

    private MyFlutterEventPlugin(FlutterView flutterView) {
        this.activity = (Activity) flutterView.getContext();
    }

    void send(Object params) {
        if (eventSink != null) {
            eventSink.success(params);
        }
    }

    void sendError(String str1, String str2, Object params) {
        if(eventSink != null) {
            eventSink.error(str1, str2, params);
        }
    }

    void cancel() {
        if (eventSink != null) {
            eventSink.endOfStream();
        }
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        this.eventSink = null;
    }
}
