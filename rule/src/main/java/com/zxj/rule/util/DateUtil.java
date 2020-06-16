package com.zxj.rule.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtil {
	public static int YEAR = 0;//年
	public static int HALFYEAR = 1;//半年
	public static int QUARTER = 2;//季度
	public static int MONTH = 3;//月份
	public static int DAY = 4;
	private static SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	
	public static Date add(Date date, int value, int pattern) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.add(pattern, value);
		return cal.getTime();
	}
	
	public static Date parse(String str) {
		try {
			return formatter.parse(str);
		} catch (ParseException e) {
			e.printStackTrace();
			return null;
		}
	}
	public static Date parse(String str, String pattern){
		try {
			return new SimpleDateFormat(pattern).parse(str);
		} catch (ParseException e) {
			e.printStackTrace();
			return null;
		}
	}
	public static String format(Date date) {
		return formatter.format(date);
	}
	public static String format(Date date, String pattern) {
		return new SimpleDateFormat(pattern).format(date);
	}
	
	public static String getAreaName(Date[] date, int pattern) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date[0]);
		int year = cal.get(Calendar.YEAR);
		if(YEAR==pattern) {
			return year+"";
		}else if(HALFYEAR==pattern) {
			int month = cal.get(Calendar.MONTH);
			if(month<6) {//上半年
				return year+"-1";
			}else {//下半年
				return year+"-2";
			}
		}else if(QUARTER==pattern) {
			int month = cal.get(Calendar.MONTH);
			if(month<3) {//一季度
				return year+"-1";
			}else if(month<6) {//二季度
				return year+"-2";
			}else if(month<9) {//三季度
				return year+"-3";
			}else{//四季度
				return year+"-4";
			}
		}else if(MONTH==pattern) {
			int month = cal.get(Calendar.MONTH);
			return year+"-"+(month+1);
		}else {
			return null;
		}
	}
	
	/**
	 * 获取最近的一个完整时间段，如当天为2019-04-09，获取最近一个完整年，结果为2018-01-01到2019-01-01*开区间
	 * @return
	 */
	public static Date[] getLastWholeArea(Date date, int pattern){
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		if(YEAR==pattern) {
			cal.add(Calendar.YEAR, -1);
		}else if(HALFYEAR==pattern) {
			int month = cal.get(Calendar.MONTH);
			if(month<6) {//上半年
				cal.add(Calendar.YEAR, -1);
				cal.set(Calendar.MONTH, 6);
			}else {//下半年
				cal.set(Calendar.MONTH, 1);
			}
		}else if(QUARTER==pattern) {
			int month = cal.get(Calendar.MONTH);
			if(month<3) {//第一季度
				cal.add(Calendar.YEAR, -1);
				cal.set(Calendar.MONTH, 9);
			}else if(month<6) {//第二季度
				cal.set(Calendar.MONTH, 0);
			}else if(month<9) {//第三季度
				cal.set(Calendar.MONTH, 3);
			}else {//第四季度
				cal.set(Calendar.MONTH, 6);
			}
		}else if(MONTH==pattern) {
			cal.add(Calendar.MONTH, -1);
		}
		date = cal.getTime();
		return getWholeArea(date, pattern);
	}
	public static Date[] getLastWholeArea(int pattern){
		return getLastWholeArea(new Date(), pattern);
	}
	/**
	 * 获取当前时间所在的一个完整时间段，如当天为2019-04-09，获取当前时间所在的一个完整年，结果为2019-01-014到2020-01-01*开
	 * @return
	 */
	public static Date[] getCurrentWholeArea(int pattern){
		return getCurrentWholeArea(new Date(), pattern);
	}
	public static Date[] getCurrentWholeArea(Date date, int pattern){
		return getWholeArea(date, pattern);
	}
	
	public static Date[] getWholeArea(Date date, int pattern) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		Date[] result = new Date[2];
		if(YEAR==pattern) {
			cal.set(Calendar.DAY_OF_YEAR, 1);
			result[0] = cal.getTime();
			cal.add(Calendar.YEAR, 1);
			result[1] = cal.getTime();
		}else if(HALFYEAR==pattern) {
			int month = cal.get(Calendar.MONTH);
			if(month<6) {//上半年
				cal.set(Calendar.DAY_OF_YEAR, 1);
				result[0] = cal.getTime();
				cal.set(Calendar.MONTH, 6);
				result[1] = cal.getTime();
			}else {//下半年
				cal.set(Calendar.MONTH, 6);
				cal.set(Calendar.DATE, 1);
				result[0] = cal.getTime();
				cal.add(Calendar.YEAR, 1);
				cal.set(Calendar.DAY_OF_YEAR, 1);
				result[1] = cal.getTime();
			}
		}else if(QUARTER==pattern) {
			int month = cal.get(Calendar.MONTH);
			if(month<3) {//第一季度
				cal.set(Calendar.DAY_OF_YEAR, 1);
				result[0] = cal.getTime();
				cal.set(Calendar.MONTH, 3);
				result[1] = cal.getTime();
			}else if(month<6) {//第二季度
				cal.set(Calendar.MONTH, 3);
				cal.set(Calendar.DATE, 1);
				result[0] = cal.getTime();
				cal.set(Calendar.MONTH, 6);
				result[1] = cal.getTime();
			}else if(month<9) {//第三季度
				cal.set(Calendar.MONTH, 6);
				cal.set(Calendar.DATE, 1);
				result[0] = cal.getTime();
				cal.set(Calendar.MONTH, 9);
				result[1] = cal.getTime();
			}else {//第四季度
				cal.set(Calendar.MONTH, 9);
				cal.set(Calendar.DATE, 1);
				result[0] = cal.getTime();
				cal.add(Calendar.YEAR, 1);
				cal.set(Calendar.DAY_OF_YEAR, 1);
				result[1] = cal.getTime();
			}
		}else if(MONTH==pattern) {
			cal.set(Calendar.DAY_OF_MONTH, 1);
			result[0] = cal.getTime();
			cal.add(Calendar.MONTH, 1);
			cal.set(Calendar.DAY_OF_MONTH, 1);
			result[1] = cal.getTime();
		}
		return result;
	}
}
