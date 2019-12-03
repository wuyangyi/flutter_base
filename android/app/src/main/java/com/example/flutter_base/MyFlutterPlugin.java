package com.example.flutter_base;

import android.app.Activity;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * author: wuyangyi
 * date: 2019-11-29
 * 自定义插件
 */
public class MyFlutterPlugin implements MethodChannel.MethodCallHandler {
    private final Activity activity;
    private StartLocationClick startLocationClick;

    public MyFlutterPlugin(Activity activity) {
        this.activity = activity;
    }


    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("start_location")) {
            Integer userId = methodCall.argument("userId");
            String mockUser = String.format("{\"id\":%s}", userId);
            result.success(mockUser);
            Log.d("开始定位", "kais ");
            if(startLocationClick != null) {
                startLocationClick.startLocation(userId == null ? 0 : userId);
            }
        }
    }

    public static void registerWith(PluginRegistry registry, MyFlutterPlugin myFlutterPlugin) {
        String CHANNEL = "com.example.flutter_base/plugin";
        PluginRegistry.Registrar registrar = registry.registrarFor(CHANNEL);
        MethodChannel methodChannel = new MethodChannel(registrar.messenger(), CHANNEL);
        methodChannel.setMethodCallHandler(myFlutterPlugin);
    }

    public void setStartLocationClick(StartLocationClick startLocationClick) {
        this.startLocationClick = startLocationClick;
    }


    interface StartLocationClick{
        void startLocation(int userId);
    }
}
