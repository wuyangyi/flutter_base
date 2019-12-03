package com.example.flutter_base.bean;

/**
 * author: wuyangyi
 * date: 2019-12-02
 */
public class CallBackBean {

    private String startDate; //起始日期
    private String endDate;//结束日期
    private long startTime; //起始时间(s)
    private long endTime; //结束时间(s)
    private double path; //总里程
    private int walkNumber; //步数
    private int time; //总耗时（s）
    private String week; //星期数(一、二....)


    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public long getStartTime() {
        return startTime;
    }

    public void setStartTime(long startTime) {
        this.startTime = startTime;
    }

    public long getEndTime() {
        return endTime;
    }

    public void setEndTime(long endTime) {
        this.endTime = endTime;
    }

    public double getPath() {
        return path;
    }

    public void setPath(double path) {
        this.path = path;
    }

    public int getWalkNumber() {
        return walkNumber;
    }

    public void setWalkNumber(int walkNumber) {
        this.walkNumber = walkNumber;
    }

    public int getTime() {
        return time;
    }

    public void setTime(int time) {
        this.time = time;
    }

    public void setWeek(String week) {
        this.week = week;
    }

    public String getWeek() {
        return week;
    }

    @Override
    public String toString() {
        return "CallBackBean{" +
                "startDate='" + startDate + '\'' +
                ", endDate='" + endDate + '\'' +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", path=" + path +
                ", walkNumber=" + walkNumber +
                ", time=" + time +
                '}';
    }

    public String toJson() {
        return "{" +
                "\"startTime\":" + startTime +
                ", \"endTime\":" + endTime +
                ", \"startDate\":" + "\"" + startDate + "\"" +
                ", \"endDate\":" + "\"" + endDate + "\"" +
                ", \"path\":" + path +
                ", \"walkNumber\":" + walkNumber +
                ", \"time\":" + time +
                ", \"week\":" + "\"" + week + "\"" +
                "}";
    }
}
