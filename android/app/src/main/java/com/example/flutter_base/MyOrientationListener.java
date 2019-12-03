package com.example.flutter_base;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.util.Log;

import java.util.Scanner;

/**
 * author: wuyangyi
 * date: 2019-11-29
 * 获取传感器方向和加速度
 */
public class MyOrientationListener implements SensorEventListener {

    private SensorManager mSensorManager;
    private Context mContext;
    private Sensor mSensor;
    private Sensor mWalkAllSensor;
    private float lastX;
    public static int mWalkNumber = -1;
    private int mStepCounter = 0;


    private double speed = 0; //速度

    public MyOrientationListener(Context context){
        this.mContext = context;
    }

    @SuppressWarnings("deprecation")
    public void start(){
        mSensorManager = (SensorManager) mContext
                .getSystemService(Context.SENSOR_SERVICE);
        if (mSensorManager != null){
            // 获得方向传感器
            mSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_ORIENTATION);
//            //获得加速度传感器
//            mSpeedSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION);
            //获得步行传感器
            mWalkAllSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER);//TYPE_STEP_DETECTOR为现在步数
        }

        if (mSensor != null){
            mSensorManager.registerListener(this, mSensor, SensorManager.SENSOR_DELAY_UI);
//            mSensorManager.registerListener(this, mSpeedSensor, SensorManager.SENSOR_DELAY_UI);
            mSensorManager.registerListener(this, mWalkAllSensor, SensorManager.SENSOR_DELAY_NORMAL);
        }
    }

    public void stop(){
        mSensorManager.unregisterListener(this);
        mSensor = null;
        mWalkAllSensor = null;
    }

    @Override
    public void onAccuracyChanged(Sensor arg0, int arg1){
        // TODO Auto-generated method stub
    }

    @SuppressWarnings({ "deprecation" })
    @Override
    public void onSensorChanged(SensorEvent event){
        if (event.sensor.getType() == Sensor.TYPE_ORIENTATION) { //方向
            float x = event.values[SensorManager.DATA_X];

            if (Math.abs(x - lastX) > 1.0) {
                if (mOnOrientationListener != null) {
                    mOnOrientationListener.onOrientationChanged(x);
                }
            }
            lastX = x;
//        } else if (event.sensor.getType() == Sensor.TYPE_LINEAR_ACCELERATION) { //加速度
//            //加速度
//            double a = getSpeedByXYZ(event.values[SensorManager.DATA_X], event.values[SensorManager.DATA_Y], event.values[SensorManager.DATA_Z]);
////            Log.d("加速度", a + "");
//            speed = speed + a * 0.1;
//            if (mOnOrientationListener != null && Math.abs(a) > 0.1) {
//                mOnOrientationListener.onSpeedChanged(speed);
//            }
        } else if (event.sensor.getType() == Sensor.TYPE_STEP_COUNTER) {
            mStepCounter = (int) event.values[0];

            if (mWalkNumber == -1) {
                mWalkNumber = mStepCounter;
            }

            Log.d("开始步数", mWalkNumber+"");
            Log.d("总步数", mStepCounter+"");

            int walk = mStepCounter - mWalkNumber;
            Log.d("运动步数", walk+"");
            if (mOnOrientationListener != null) {
                mOnOrientationListener.onWalkChanged(walk, mStepCounter);
            }
        }
    }

    private OnOrientationListener mOnOrientationListener;

    public void setOnOrientationListener(OnOrientationListener mOnOrientationListener){
        this.mOnOrientationListener = mOnOrientationListener;
    }

    public interface OnOrientationListener{
        void onOrientationChanged(float x);

//        //速度
//        void onSpeedChanged(double speed);

        //步数
        void onWalkChanged(int walkNumber, int allWalkNumber);
    }

    double getSpeedByXYZ(double x, double y,double z){
        int symbol = 1;
        if (x < 0) {
            symbol *= -1;
        }
        if (y < 0){
            symbol *= -1;
        }
        if (z < 0) {
            symbol += -1;
        }
        double s = 0.0;
        s = Math.sqrt(Math.abs(x) * Math.abs(x) + Math.abs(y) * Math.abs(y) + Math.abs(z) * Math.abs(z)) * symbol;
        return s;
    }
}
