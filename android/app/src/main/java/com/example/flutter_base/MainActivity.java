package com.example.flutter_base;

import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.SystemClock;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.baidu.location.BDAbstractLocationListener;
import com.baidu.location.BDLocation;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdate;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.MyLocationConfiguration;
import com.baidu.mapapi.map.MyLocationData;
import com.baidu.mapapi.map.OverlayOptions;
import com.baidu.mapapi.map.Polyline;
import com.baidu.mapapi.map.PolylineOptions;
import com.baidu.mapapi.model.LatLng;
import com.baidu.trace.LBSTraceClient;
import com.baidu.trace.Trace;
import com.baidu.trace.api.track.HistoryTrackRequest;
import com.baidu.trace.api.track.HistoryTrackResponse;
import com.baidu.trace.api.track.OnTrackListener;
import com.baidu.trace.api.track.TrackPoint;
import com.baidu.trace.model.OnTraceListener;
import com.baidu.trace.model.PushMessage;
import com.baidu.trace.model.StatusCodes;
import com.example.flutter_base.bean.CallBackBean;
import com.example.flutter_base.util.UtilMessage;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import io.flutter.Log;
import io.flutter.app.FlutterActivity;

public class MainActivity extends FlutterActivity implements MyFlutterPlugin.StartLocationClick {

  private View view;
  //地图控件
  private MapView mMapView = null;
  //地图实例
  private BaiduMap mBaiduMap = null;
  private LocationClientOption option;
  //定位的客户端
  private LocationClient mLocationClient;
  //定位的监听器
  private MyLocationListener myListener;
  //方向传感器监听
  private MyOrientationListener myOrientationListener;
  //方向传感器X方向的值
  private int mXDirection;
  //当前精度
  private float mCurrentAccracy;

  // UI相关
  private boolean isFirstLoc = true; // 是否首次定位
  //当前经纬度
//  private double mLatitude;
//  private double mLongtitude;
  private LatLng mLatLng;

  private ImageView mIvLocation;
  private TextView tvStop;
  private TextView tvSpeed; //运动速度
  private TextView tvTime; //时间
  private TextView tvStepNumber; //运动步数
  private TextView tvAllStepNumber; //总步数
  private TextView tvPath; //里程
  private double allPath = 0.0; //总里程(米)
  private int stepNumber = 0;

  private LatLng startLatLng; //起点坐标
  private LatLng endLatLng; //终点坐标
  private MyFlutterPlugin myFlutterPlugin;

  private long serviceId = 217917; //鹰眼轨迹服务id
  private String entityName = "myRunTrace"; //设备标识
  boolean isNeedObjectStorage = false; // 是否需要对象存储服务
  private Trace mTrace; //轨迹服务
  private LBSTraceClient mTraceClient; // 初始化轨迹服务客户端

  private int tag = 217917; //请求标识

  private long startTime; //起始时间(s)
  private long endTime; //结束时间

  private Polyline mPolyline = null;

  private boolean endTrace = false; //是否结束

  private int time = 0; //运动时间（s）
  private long baseTimer; //开始的毫秒
  private LatLng lastLatLng; //上一个点的坐标

  private MyFlutterEventPlugin myFlutterEventPlugin;

//  private OverlayOptions startOverlayOptions; //起点的覆盖物
//  private OverlayOptions endOverlayOptions; //终点的覆盖物

  private CallBackBean mCallBackBean;

  private Handler handler = new Handler(){
    @Override
    public void handleMessage(Message msg) {
      if (0 == MainActivity.this.baseTimer) {
        MainActivity.this.baseTimer = SystemClock.elapsedRealtime();
      }
      time = (int)((SystemClock.elapsedRealtime() - MainActivity.this.baseTimer) / 1000);
      String hh = new DecimalFormat("00").format(time / 3600);
      String mm = new DecimalFormat("00").format(time % 3600 / 60);
      String ss = new DecimalFormat("00").format(time % 60);
      if (MainActivity.this.tvTime != null) {
        tvTime.setText(hh + ":" + mm + ":" + ss);
      }
      if (lastLatLng == null) {
        lastLatLng = mLatLng;
      } else {
        double speed = UtilMessage.getDistance(lastLatLng, mLatLng);
        if(speed == Double.NaN) {
          speed = 0.00;
        }
        allPath += speed;
        tvSpeed.setText(String.format("%.2f", speed));
        tvPath.setText(String.format("%.2f", allPath / 1000));
        lastLatLng = mLatLng;
      }
      if (!endTrace) {
        sendMessageDelayed(Message.obtain(this, 0x0), 1000);
      }
    }
  };

  // 初始化轨迹监听器
  private OnTrackListener mTrackListener = new OnTrackListener() {
    // 历史轨迹回调
    @Override
    public void onHistoryTrackCallback(HistoryTrackResponse response) {
      if (StatusCodes.SUCCESS != response.getStatus()) {
        Toast.makeText(MainActivity.this, "运动轨迹获取失败", Toast.LENGTH_SHORT).show();
      } else if(response.getTotal() == 0) {
        Toast.makeText(MainActivity.this, "未查询到轨迹", Toast.LENGTH_SHORT).show();
      } else  {
        List<TrackPoint> points = response.getTrackPoints();
        Log.d("返回数据", response.toString());
        drawLine(points);
      }
    }
  };

  //绘制路径
  private void drawLine(List<TrackPoint> points) {
    double lanSum = 0;
    double lonSum = 0;
    List<LatLng> latLngs = new ArrayList<>();
    for (TrackPoint trackPoint : points) {
      lanSum += trackPoint.getLocation().latitude;
      lonSum += trackPoint.getLocation().longitude;
      latLngs.add(new LatLng(trackPoint.getLocation().latitude, trackPoint.getLocation().longitude));
    }

    //中心点
    LatLng latLng = new LatLng(lanSum / points.size(), lonSum / points.size());
    //设置所有点的中心点 和放缩比例
    MapStatus.Builder builder = new MapStatus.Builder();
    builder.target(latLng).zoom(18f);

    //地图设置放缩状态
    mBaiduMap.animateMapStatus(MapStatusUpdateFactory.newMapStatus(builder.build()));

    //配置线段图层类
    OverlayOptions overlayOptions = new PolylineOptions().width(13).color(0xFF7C4DFF).points(latLngs);
    //在地图上画出线条图层，mPolyline：线条图层
    mPolyline = (Polyline) mBaiduMap.addOverlay(overlayOptions);
    mPolyline.setZIndex(3);

  }


  // 初始化轨迹服务监听器
  private OnTraceListener mOnTraceListener = new OnTraceListener() {
    @Override
    public void onBindServiceCallback(int i, String s) {
      Log.d("绑定服务", s);

    }

    @Override
    public void onStartTraceCallback(int i, String s) { //开启服务成功回调
      Log.d("开启服务", s);
      startTime = System.currentTimeMillis() / 1000;
      mTraceClient.startGather(mOnTraceListener); //开始采集,必须开启服务成功后才可以采集

    }

    @Override
    public void onStopTraceCallback(int i, String s) {
      Log.d("停止服务", s);
    }

    @Override
    public void onStartGatherCallback(int i, String s) {
      Log.d("开始采集", s);
    }

    @Override
    public void onStopGatherCallback(int i, String s) { //采集结束回调
      Log.d("结束采集", s);
      endTime = System.currentTimeMillis() / 1000;
      HistoryTrackRequest historyTrackRequest = new HistoryTrackRequest(tag, serviceId, entityName);
      historyTrackRequest.setStartTime(startTime); //轨迹起始时间
      historyTrackRequest.setEndTime(endTime); //轨迹结束时间
      //查询历史轨迹
      mTraceClient.queryHistoryTrack(historyTrackRequest, mTrackListener);
    }

    @Override
    public void onPushCallback(byte b, PushMessage pushMessage) {
      Log.d("上推返回", pushMessage.getMessage());
    }

    @Override
    public void onInitBOSCallback(int i, String s) {
      Log.d("InitBOS", s);
    }
  };




  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    initView();
    initMap();
    ViewRegistrant.registerWith(this, view);
//    GeneratedPluginRegistrant.registerWith(this);
    myFlutterPlugin = new MyFlutterPlugin(this);
    myFlutterPlugin.setStartLocationClick(this);
    MyFlutterPlugin.registerWith(this, myFlutterPlugin); //自定义插件注册
  }

  //初始化控件
  private void initView(){
    LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    view = inflater.inflate(R.layout.view_map, null);
    mMapView = view.findViewById(R.id.mMapView);
    mIvLocation = view.findViewById(R.id.iv_location);
    tvStop = view.findViewById(R.id.tvStop);
    tvSpeed = view.findViewById(R.id.tvSpeed);
    tvTime = view.findViewById(R.id.tvTime);
    tvStepNumber = view.findViewById(R.id.tvStepNumber);
    tvAllStepNumber = view.findViewById(R.id.tvAllStepNumber);
    tvPath = view.findViewById(R.id.tvPath);
    myFlutterEventPlugin = MyFlutterEventPlugin.registerWith(getFlutterView());
    initListener();
  }

  //事件监听
  private void initListener() {
    mIvLocation.setOnClickListener(v -> {
      LatLng latLng = new LatLng(mLatLng.latitude, mLatLng.longitude);
      MapStatusUpdate u = MapStatusUpdateFactory.newLatLng(latLng);
      mBaiduMap.animateMapStatus(u);
    });

    tvStop.setOnClickListener(v -> {
      if (endTrace) { //通知flutter关闭路由，并返回运动数据保存数据库
        if (mCallBackBean == null) {
          mCallBackBean = new CallBackBean();
        }
        mCallBackBean.setEndDate(UtilMessage.getNowTimeForDate());
        mCallBackBean.setStartTime(startTime);
        mCallBackBean.setEndTime(endTime);
        mCallBackBean.setPath(allPath / 1000);
        mCallBackBean.setWalkNumber(stepNumber);
        mCallBackBean.setTime(time);
        try {
          myFlutterEventPlugin.send(mCallBackBean.toJson());
        } catch (Exception e){
          e.printStackTrace();
          myFlutterEventPlugin.sendError("异常", "异常", e.getMessage());
        }
        myFlutterEventPlugin.cancel();
        endTrace = false;
        isFirstLoc = true;
        allPath = 0.0;
        startTime = 0;
        endTime = 0;
        time = 0;
        baseTimer = 0;
        lastLatLng = null;
        tvStop.setText("长按暂停");
        tvStop.setBackgroundResource(R.drawable.shape_20_bg);
      }
    });

    tvStop.setOnLongClickListener(v -> {
      if (!endTrace) {
        stop();
        endTrace = true;
        tvStop.setText("结束");
        tvStop.setBackgroundResource(R.drawable.shape_20_red_bg);
      }
      return true;
    });
  }

  //初始化地图
  private void initMap(){
    mMapView.showZoomControls(false);//隐藏放大缩小按钮
    mMapView.getChildAt(1).setVisibility(View.INVISIBLE); //隐藏百度地图logo
    mBaiduMap = mMapView.getMap();
    mBaiduMap.setIndoorEnable(true);// 开启室内图
    mBaiduMap.setMapType(BaiduMap.MAP_TYPE_NORMAL);//普通地图
    //开启交通图
    //mBaiduMap.setTrafficEnabled(true);
    //开启热力图
    //mBaiduMap.setBaiduHeatMapEnabled(true);

    //设置定位图标
    MyLocationConfiguration.LocationMode locationMode = MyLocationConfiguration.LocationMode.NORMAL;
//    BitmapDescriptor bitmapDescriptor = BitmapDescriptorFactory.fromResource(R.mipmap.ic_back);
    mBaiduMap.setMyLocationConfiguration(new MyLocationConfiguration(locationMode, true, null)); //为null使用默认的方向图片
    //定位初始化
    myListener = new MyLocationListener();
    mLocationClient = new LocationClient(this);
    initLocation();
    mLocationClient.registerLocationListener(myListener);//注册监听函数

    //图片点击事件，回到定位点
    mLocationClient.requestLocation();

    //鹰眼轨迹初始化
    initLBSTrace();

  }

  //初始化传感器及监听
  private void initOrientationListener() {
    myOrientationListener = new MyOrientationListener(this);
    myOrientationListener.setOnOrientationListener(new MyOrientationListener.OnOrientationListener() {
      @Override
      public void onOrientationChanged(float x) {
        mXDirection = (int) x;
        //构造定位数据
        MyLocationData locationData = new MyLocationData.Builder()
                .accuracy(mCurrentAccracy)
                .direction(mXDirection)
                .latitude(mLatLng.latitude)
                .longitude(mLatLng.longitude)
                .build();
        //设置定位数据
        mBaiduMap.setMyLocationData(locationData);
      }

      @Override
      public void onWalkChanged(int walkNumber, int allWalkNumber) {
        //现在运动的步数
        tvStepNumber.setText(walkNumber+"");
        stepNumber = walkNumber;
        //总步数
        tvAllStepNumber.setText("总步数："+allWalkNumber);
      }
    });
  }

  //配置定位SDK参数
  private void initLocation() {
    option = new LocationClientOption();
    option.setLocationMode(LocationClientOption.LocationMode.Hight_Accuracy);//可选，默认高精度，设置定位模式，高精度，低功耗，仅设备
    option.setOpenGps(true); //可选，默认false,设置是否使用gps
    option.setLocationNotify(true);//可选，默认false，设置是否当GPS有效时按照1S/1次频率输出GPS结果
    option.setCoorType("bd09ll"); // 设置坐标类型
    option.setScanSpan(1000); //设置发起定位的时间间隔  大于1000ms才有效
    option.setIsNeedAddress(true);//可选，设置是否需要地址信息，默认不需要
    option.setIsNeedLocationDescribe(true);//可选，默认false，设置是否需要位置语义化结果，可以在BDLocation
    option.setIsNeedLocationPoiList(false);//可选，默认false，设置是否需要POI结果，可以在BDLocation.getPoiList里得到
    option.setIgnoreKillProcess(false);
    option.SetIgnoreCacheException(false);//可选，默认false，设置是否收集CRASH信息，默认收集
    option.setEnableSimulateGps(false);//可选，默认false，设置是否需要过滤GPS仿真结果，默认需要
    mLocationClient.setLocOption(option);
  }

  //添加起点终点
  private OverlayOptions addPosition(LatLng latLng, int res) {
    if (latLng == null) {
      return null;
    }
    //构建Marker图标
    BitmapDescriptor bitmap = BitmapDescriptorFactory.fromResource(res);
    //构建MarkerOptions，用于在地图上添加Marker
    OverlayOptions overlayOptions = new MarkerOptions()
            .position(latLng)
            .icon(bitmap)
            .draggable(true)
            .flat(false) //设置平贴地图
            .alpha(1f);
    //在地图添加marker，并显示
    mBaiduMap.addOverlay(overlayOptions);
    return overlayOptions;
  }


  //初始化鹰眼轨迹
  private void initLBSTrace() {
    mTrace = new Trace(serviceId, entityName, isNeedObjectStorage);
    mTraceClient = new LBSTraceClient(this);
    mTraceClient.setInterval(5, 10); //定位周期和打包回传周期
  }

  @Override
  protected void onResume() {
    super.onResume();
    //在activity执行onResume时执行mMapView. onResume ()，实现地图生命周期管理
    mMapView.onResume();
  }

  @Override
  protected void onPause() {
    super.onPause();
    //在activity执行onPause时执行mMapView. onPause ()，实现地图生命周期管理
    mMapView.onPause();
  }

  @Override
  protected void onStop() {
    super.onStop();
  }

  //结束运动
  private void stop() {
    addPosition(endLatLng, R.mipmap.icon_end); //添加终点
    mTraceClient.stopGather(mOnTraceListener);
    //结束鹰眼轨迹
    mTraceClient.stopTrace(mTrace, mOnTraceListener); //结束服务
    // 关闭定位图层
    mBaiduMap.setMyLocationEnabled(false);
    // 退出时销毁定位
    if (mLocationClient != null) {
      mLocationClient.stop();
    }
    //停止方向传感器
    if (myOrientationListener != null) {
      myOrientationListener.stop();
    }

  }

  @Override
  protected void onDestroy() {
    super.onDestroy();
    stop();
    mBaiduMap.setMyLocationEnabled(false);
    mMapView.onDestroy();
    mMapView = null;

  }

  //开始定位
  @Override
  public void startLocation(int userId) {
    if (mLocationClient.isStarted()) { //已经在跑步状态返回
      return;
    }
    mCallBackBean = new CallBackBean();
    mCallBackBean.setStartDate(UtilMessage.getNowTimeForDate());
    mCallBackBean.setWeek(UtilMessage.getNowWeek());
    MyOrientationListener.mWalkNumber = -1;
    Log.d("定位", "开始");
    // 开启定位图层
    mBaiduMap.setMyLocationEnabled(true);
    if (!mLocationClient.isStarted()) {
      mLocationClient.start(); //开始定位
    }
    mTraceClient.startTrace(mTrace, mOnTraceListener); //开启服务
    baseTimer = 0;
    handler.sendMessageDelayed(Message.obtain(handler, 0x0), 1000);
  }

  //定位监听
  public class MyLocationListener extends BDAbstractLocationListener {
    @Override
    public void onReceiveLocation(BDLocation location) {
      //mapView 销毁后不在处理新接收的位置
      if (location == null || mMapView == null){
        return;
      }
      //更新经纬度
      mLatLng = new LatLng(location.getLatitude(), location.getLongitude());


      //初始化方向传感器
      initOrientationListener();
      myOrientationListener.start(); // 开启方向传感器

      MyLocationData locData = new MyLocationData.Builder()
              .accuracy(location.getRadius())
              // 此处设置开发者获取到的方向信息，顺时针0-360
              .direction(location.getDirection()).latitude(location.getLatitude())
              .longitude(location.getLongitude()).build();
      mBaiduMap.setMyLocationData(locData); // 设置定位数据
      mCurrentAccracy = location.getRadius();
      endLatLng = new LatLng(location.getLatitude(),
              location.getLongitude()); //终点坐标
      // 当不需要定位图层时关闭定位图层
      //mBaiduMap.setMyLocationEnabled(false);
      if (isFirstLoc) {
        isFirstLoc = false;
        LatLng ll = new LatLng(location.getLatitude(),
                location.getLongitude());
        startLatLng = ll;
        addPosition(startLatLng, R.mipmap.icon_start); //添加起点
        MapStatus.Builder builder = new MapStatus.Builder();
        builder.target(ll).zoom(16f);
        mBaiduMap.animateMapStatus(MapStatusUpdateFactory.newMapStatus(builder.build()));

//        if (location.getLocType() == BDLocation.TypeGpsLocation) {
//          // GPS定位结果
//          Toast.makeText(MainActivity.this, location.getAddrStr(), Toast.LENGTH_SHORT).show();
//        } else if (location.getLocType() == BDLocation.TypeNetWorkLocation) {
//          // 网络定位结果
//          Toast.makeText(MainActivity.this, location.getAddrStr(), Toast.LENGTH_SHORT).show();
//
//        } else if (location.getLocType() == BDLocation.TypeOffLineLocation) {
//          // 离线定位结果
//          Toast.makeText(MainActivity.this, location.getAddrStr(), Toast.LENGTH_SHORT).show();
//
//        } else if (location.getLocType() == BDLocation.TypeServerError) {
//          Toast.makeText(MainActivity.this, "服务器错误，请检查", Toast.LENGTH_SHORT).show();
//        } else if (location.getLocType() == BDLocation.TypeNetWorkException) {
//          Toast.makeText(MainActivity.this, "网络错误，请检查", Toast.LENGTH_SHORT).show();
//        } else if (location.getLocType() == BDLocation.TypeCriteriaException) {
//          Toast.makeText(MainActivity.this, "手机模式错误，请检查是否飞行", Toast.LENGTH_SHORT).show();
//        }
      }
    }
  }
}