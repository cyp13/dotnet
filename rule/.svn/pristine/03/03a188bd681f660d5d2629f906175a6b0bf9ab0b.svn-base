package com.zxj.rule.util;

import java.io.InputStream;
import java.util.Properties;

import org.springframework.beans.factory.annotation.Value;

public class FileUtils {
	
	@Value("http.querytest")
	private String address;
	
	private static Properties prop;

	/**
	 * 获取配置文件属性
	 * 
	 * @param key
	 * @return
	 * @throws Exception
	 */
	public static String getSysProp(String key) {
		try {
			if (null == prop) {
				prop = new Properties();
				InputStream in = FileUtils.class
						.getClassLoader().getResourceAsStream("*.properties");
				prop.load(in);
			}
			return prop.getProperty(key);
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * 获取配置文件属性,指定配置属性为null时的默认值
	 * 
	 * @param key
	 * @param defaultValue
	 *            配置读取值为null时的默认值
	 * @return
	 */
	public static String getSysProp(String key, String defaultValue) {
		String value = getSysProp(key);
		return value == null ? defaultValue : value;
	}
}
