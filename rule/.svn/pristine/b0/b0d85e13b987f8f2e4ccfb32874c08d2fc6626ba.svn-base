package com.zxj.rule.util;

public class StringUtils {

	/**
	 * 将字符串数组转换成Integer
	 * 
	 * @param datas
	 * @return
	 */
	public static Integer fetchInteger(String[] datas) {
		if (null == datas || datas.length == 0) {
			return null;
		}
		String temp = datas[0];
		Integer dest = null;

		try {
			dest = Integer.valueOf(temp);
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}

		return dest;
	}

	/**
	 * 将字符串数组转换成Long
	 * 
	 * @param datas
	 * @return
	 */
	public static Long fetchLong(String[] datas) {
		if (null == datas || datas.length == 0) {
			return null;
		}
		String temp = datas[0];
		Long dest = null;

		try {
			dest = Long.valueOf(temp);
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}

		return dest;
	}

	/**
	 * 将字符串转换成Integer
	 * 
	 * @param str
	 * @return
	 */
	public static Integer fetchInt(String str) {
		if (null == str) {
			return null;
		}
		Integer dest = null;

		try {
			dest = Integer.valueOf(str);
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}

		return dest;
	}

	/**
	 * 将字符串转换成Long
	 * 
	 * @param str
	 * @return
	 */
	public static Long fetchLong(String str) {
		if (null == str) {
			return null;
		}
		Long dest = null;

		try {
			dest = Long.valueOf(str);
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}

		return dest;
	}

	/**
	 * 获取字符串数组中的字符串
	 * 
	 * @param datas
	 * @return
	 */
	public static String fetchString(String[] datas) {
		if (null == datas || datas.length == 0) {
			return null;
		}

		return datas[0];
	}

	public static boolean isEmpty(CharSequence cs) {
		return ((cs == null) || (cs.length() == 0));
	}

	public static boolean isNotEmpty(CharSequence cs) {
		return (!(isEmpty(cs)));
	}
}
