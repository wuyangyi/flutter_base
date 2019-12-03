package com.example.flutter_base.util;

import com.baidu.mapapi.model.LatLng;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * author: wuyangyi
 * date: 2019-11-30
 */
public class UtilMessage {
    private static final double EARTH_RADIUS = 6371393; // 平均半径,单位：m
    public static SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式

    /**
     * 通过AB点经纬度获取距离
     * @param pointA A点(经，纬)
     * @param pointB B点(经，纬)
     * @return 距离(单位：米)
     */
    public static double getDistance(LatLng pointA, LatLng pointB) {
        // 经纬度（角度）转弧度。弧度用作参数，以调用Math.cos和Math.sin
        double radiansAX = Math.toRadians(pointA.latitude); // A经弧度
        double radiansAY = Math.toRadians(pointA.longitude); // A纬弧度
        double radiansBX = Math.toRadians(pointB.latitude); // B经弧度
        double radiansBY = Math.toRadians(pointB.longitude); // B纬弧度

        // 公式中“cosβ1cosβ2cos（α1-α2）+sinβ1sinβ2”的部分，得到∠AOB的cos值
        double cos = Math.cos(radiansAY) * Math.cos(radiansBY) * Math.cos(radiansAX - radiansBX)
                + Math.sin(radiansAY) * Math.sin(radiansBY);
//        System.out.println("cos = " + cos); // 值域[-1,1]
        double acos = Math.acos(cos); // 反余弦值
//        System.out.println("acos = " + acos); // 值域[0,π]
//        System.out.println("∠AOB = " + Math.toDegrees(acos)); // 球心角 值域[0,180]
        return EARTH_RADIUS * acos; // 最终结果
    }

    public static String getNowTimeForDate() {
        return df.format(new Date());
    }

    public static String getNowWeek() {
        String week = "";
        Date date = new Date();
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        int weekDay = c.get(Calendar.DAY_OF_WEEK);
        switch (weekDay) {
            case 1:
                week = "日";
                break;
            case 2:
                week = "一";
                break;
            case 3:
                week = "二";
                break;
            case 4:
                week = "三";
                break;
            case 5:
                week = "四";
                break;
            case 6:
                week = "五";
                break;
            case 7:
                week = "六";
                break;
        }
        return week;
    }

}
