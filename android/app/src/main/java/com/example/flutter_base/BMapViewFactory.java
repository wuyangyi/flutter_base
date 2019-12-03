package com.example.flutter_base;

import android.content.Context;
import android.view.View;

import com.baidu.mapapi.map.MapView;

import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * author: wuyangyi
 * date: 2019-11-28
 * PlatformViewFactory 的主要任务是，在 create() 方法中创建一个 View 并把它传给 Flutter
 */
public class BMapViewFactory extends PlatformViewFactory {

    private View view;

    public BMapViewFactory(MessageCodec<Object> createArgsCodec, View view) {
        super(createArgsCodec);
        this.view = view;
    }

    @Override
    public PlatformView create(final Context context, int i, Object o) {
        return new PlatformView() {
            @Override
            public View getView() {
                return view;
            }

            @Override
            public void dispose() {

            }
        };
    }
}
