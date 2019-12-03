package com.example.flutter_base;

import android.view.View;

import com.baidu.mapapi.map.MapView;
import com.shinow.qrscan.QrscanPlugin;
import com.tekartik.sqflite.SqflitePlugin;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugins.imagepicker.ImagePickerPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import io.flutter.plugins.webviewflutter.WebViewFlutterPlugin;
import io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin;
import xyz.luan.audioplayers.AudioplayersPlugin;

/**
 * author: wuyangyi
 * date: 2019-11-28
 * ViewRegistrant 类将该插件注册到 APP，ViewType 为 MapView。参数中新增实例化的百度地图 MapView。
 */
public final class ViewRegistrant {
    public static void registerWith(PluginRegistry registry, View view) {
        final String key = ViewRegistrant.class.getCanonicalName();

        if (registry.hasPlugin(key)) return;

        PluginRegistry.Registrar registrar = registry.registrarFor(key);
        registrar.platformViewRegistry().registerViewFactory("MapView", new BMapViewFactory(new StandardMessageCodec(), view));
        AudioplayersPlugin.registerWith(registry.registrarFor("xyz.luan.audioplayers.AudioplayersPlugin"));
        FluttertoastPlugin.registerWith(registry.registrarFor("io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin"));
        ImagePickerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.imagepicker.ImagePickerPlugin"));
        PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
        QrscanPlugin.registerWith(registry.registrarFor("com.shinow.qrscan.QrscanPlugin"));
        SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
        SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
        WebViewFlutterPlugin.registerWith(registry.registrarFor("io.flutter.plugins.webviewflutter.WebViewFlutterPlugin"));
    }
}
