package com.zxj.rule.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.InetAddress;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.log4j.Logger;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.alibaba.fastjson.JSONArray;

/**
 * @author yove
 * 
 */
public class Utils {
	private static final Logger log = Logger.getLogger(Utils.class);

	private static Properties prop;

	private static CloseableHttpClient client = null;

	private static final String host = Utils.getSysProp("host.portal");

	private static final String sendMsgUrl = "/api/ws/rest/sendMsg";

	public static HttpServletRequest getRequest() {
		try {
			return ((ServletRequestAttributes) RequestContextHolder
					.getRequestAttributes()).getRequest();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	static {
		try {
			client = HttpClientBuilder.create().build();
		} catch (Exception e) {
			log.error(e.getMessage());
		}
	}

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
				InputStream in = Utils.class
						.getResourceAsStream("/sys.properties");
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

	public static Map<String, String> mapStr2Map(String str) {
		str = str.substring(1, str.length() - 1);
		String[] strs = str.split(",");
		Map<String, String> map = new HashMap<String, String>();
		for (String string : strs) {
			String key = string.split("=")[0];
			String value = "";
			if (string.split("=").length > 1) {
				value = string.split("=")[1];
			}
			map.put(key.trim(), value);
		}
		return map;
	}

	/**
	 * @param parameterMap
	 * @return
	 * @throws Exception
	 */
	public static Map getMap(Map<?, ?> parameterMap) throws Exception {
		Map map = new HashMap();
		String value = "";
		for (Map.Entry m : parameterMap.entrySet()) {
			String k = (String) m.getKey();
			Object v = m.getValue();
			if (null != v) {
				if (v instanceof String[]) {
					String[] values = (String[]) v;
					for (int i = 0; i < values.length; i++) {
						value += null == values[i] ? "" : values[i] + ",";
					}
					value = value.length() > 0 ? value.substring(0,
							value.length() - 1) : "";
				} else {
					value = v.toString();
				}
			}
			map.put(k, value);
			value = "";
		}
		return map;
	}

	/**
	 * @param parameterMap
	 * @return
	 * @throws Exception
	 */
	public static Map getMap(HttpServletRequest request) throws Exception {
		Map map = new HashMap();
		Enumeration<String> e = request.getParameterNames();
		while (e.hasMoreElements()) {
			String value = (String) e.nextElement();// 调用nextElement方法获得元素
			String[] a = request.getParameterValues(value);
			if (a.length == 1) {
				map.put(value, a[0]);
			} else {
				map.put(value, a);
			}

		}

		return map;
	}

	/**
	 * @param obj
	 * @return
	 */
	public static boolean isEmpty(Object obj) {
		if (obj instanceof String) {
			if (null == obj || "".equals(obj))
				return true;
		} else {
			if (null == obj)
				return true;
		}
		return false;
	}

	/**
	 * @param obj
	 * @return
	 */
	public static boolean isNotEmpty(Object obj) {
		return !isEmpty(obj);
	}



	/**
	 * @return
	 */
	public static String getTime() {
		SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss");
		return formatter.format(new Date());
	}

	/**
	 * @return
	 */
	public static String getDate() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		return formatter.format(new Date());
	}

	/**
	 * @return
	 */
	public static String getDateTime() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return formatter.format(new Date());
	}

	/**
	 * @return
	 */
	public static String getDateTimeStr() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		return formatter.format(new Date());
	}

	/**
	 * @param date
	 * @param format
	 * @return
	 */
	public static String formatDate(Date date, String format) {
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(date);
	}

	/**
	 * @param date
	 * @param format
	 * @return
	 */
	public static String formatDate(long date, String format) {
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(new Date(date));
	}

	/**
	 * @return
	 */
	public static Date parseDate() {
		Calendar calendar = Calendar.getInstance();
		return calendar.getTime();
	}

	/**
	 * @param date
	 * @param format
	 * @return
	 * @throws ParseException
	 */
	public static Date parseDate(String date, String format)
			throws ParseException {
		SimpleDateFormat formatter = new SimpleDateFormat(format);
		return formatter.parse(date);
	}

	/**
	 * @param date
	 * @return
	 */
	public static java.sql.Date parseSqlDate(Date date) {
		return new java.sql.Date(date.getTime());
	}

	/**
	 * @param date
	 * @return
	 */
	public static Timestamp parseTimestamp(Date date) {
		return new Timestamp(date.getTime());
	}

	/**
	 * 获取IP地址
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static String getIpAddr(HttpServletRequest request) throws Exception {
		try {
			String ip = request.getHeader("x-forwarded-for");
			if (Utils.isEmpty(ip) || "unknown".equalsIgnoreCase(ip)) {
				ip = request.getHeader("Proxy-Client-IP");
			}
			if (Utils.isEmpty(ip) || "unknown".equalsIgnoreCase(ip)) {
				ip = request.getHeader("WL-Proxy-Client-IP");
			}
			if (Utils.isEmpty(ip) || "unknown".equalsIgnoreCase(ip)) {
				ip = request.getRemoteAddr();
				if ("127.0.0.1".equals(ip) || "0:0:0:0:0:0:0:1".equals(ip)) {
					InetAddress inet = InetAddress.getLocalHost();
					ip = inet.getHostAddress();
				}
			}
			if (!Utils.isEmpty(ip)) {
				ip = ip.split(",")[0];
			}
			return ip;
		} catch (Exception e) {
			throw new Exception("获取IP地址失败！", e);
		}
	}

	/**
	 * 获取上级文件
	 * 
	 * @param file
	 * @return
	 * @throws Exception
	 */
	public static List<File> getParentFiles(File file) throws Exception {
		try {
			List<File> lists = new ArrayList<File>();
			if (file.exists()) {
				if (file.isDirectory()) {
					File[] files = file.listFiles();
					for (File f : files) {
						if (!f.isDirectory()) {
							lists.add(f);
						}
					}
				} else {
					lists.add(file);
				}
				if (null != file.getParent()) {
					lists.addAll(getParentFiles(file.getParentFile()));
				}
			}
			return lists;
		} catch (Exception e) {
			throw new Exception("获取上级文件失败！", e);
		}
	}

	/**
	 * 获取下级文件
	 * 
	 * @param file
	 * @return
	 * @throws Exception
	 */
	public static List<File> getChildFiles(File file) throws Exception {
		try {
			List<File> lists = new ArrayList<File>();
			if (file.exists()) {
				if (file.isDirectory()) {
					File[] files = file.listFiles();
					for (File f : files) {
						lists.addAll(getChildFiles(f));
					}
				} else {
					lists.add(file);
				}
			}
			return lists;
		} catch (Exception e) {
			throw new Exception("获取下级文件失败！", e);
		}
	}

	/**
	 * 上传附件只需传入一个request和文件保存路径
	 * 
	 * @param request
	 * @param path
	 *            保持的文件路径
	 * @return fileNames
	 * @throws Exception
	 */
	public static String upload(HttpServletRequest request, String path)
			throws Exception {
		try {
			StringBuffer fileNames = new StringBuffer();
			if (null != request) {
				boolean isMultipart = ServletFileUpload
						.isMultipartContent(request);
				if (isMultipart) {
					MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
					Iterator<String> iter = multipartRequest.getFileNames();
					while (iter.hasNext()) {
						String name = iter.next();
						List<MultipartFile> files = multipartRequest
								.getFiles(name);
						for (MultipartFile mf : files) {
							if (null != mf && !mf.isEmpty()) {
								File file = new File(path + File.separator
										+ mf.getOriginalFilename());
								File dir = file.getParentFile();
								if (!dir.exists()) {
									dir.mkdirs();
								}
								FileCopyUtils.copy(mf.getBytes(), file);
								fileNames.append(mf.getOriginalFilename() + ",");
							}
						}
					}
				}
			}
			return fileNames.toString();
		} catch (Exception e) {
			throw new Exception("上传文件失败！", e);
		}
	}

	public static void download(String Url, String fileName,
			HttpServletResponse response) throws Exception {
		// 获取文件名，此处看个人如何设计的

		try {
			String path = Url;
			File file = new File(path);
			// 如果文件不存在
			if (!file.exists()) {
				throw new Exception("文件不存在！");
			}

			response.setContentType("application/octet-stream");
			// response.reset();//清除response中的缓存
			// 设置reponse响应头，真实文件名重命名，就是在这里设置，设置编码
			response.setHeader("Content-disposition", "attachment; filename="
					+ new String(fileName.getBytes("utf-8"), "ISO8859-1"));
			// 读取要下载的文件，保存到文件输入流
			FileInputStream in = new FileInputStream(path);
			// 创建输出流
			OutputStream out = response.getOutputStream();
			// 缓存区
			byte buffer[] = new byte[1024];
			int len = 0;
			// 循环将输入流中的内容读取到缓冲区中
			while ((len = in.read(buffer)) > 0) {
				out.write(buffer, 0, len);
			}
			// 关闭
			in.close();
			out.close();
		} catch (Exception e) {
			throw new Exception("下载文件失败！", e);
		}
	}

	/**
	 * 根据文件路径删除文件
	 * 
	 * @param fileName
	 * @return
	 */
	public static boolean deleteFile(String fileName) throws Exception {
		try {
			File file = new File(fileName);
			// 如果文件路径所对应的文件存在，并且是一个文件，则直接删除
			if (file.exists() && file.isFile()) {
				if (file.delete()) {
					System.out.println("删除单个文件" + fileName + "成功！");
					return true;
				} else {
					System.out.println("删除单个文件" + fileName + "失败！");
					return false;
				}
			} else {
				System.out.println("删除单个文件失败：" + fileName + "不存在！");
				return false;
			}
		} catch (Exception e) {
			throw new Exception("删除文件失败！", e);
		}
	}

	/**
	 * 从request中获取文件列表
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static List<MultipartFile> getFilesByrequest(
			HttpServletRequest request) throws Exception {
		List<MultipartFile> files = null;
		try {
			if (null != request) {
				boolean isMultipart = ServletFileUpload
						.isMultipartContent(request);
				if (isMultipart) {
					MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
					Iterator<String> iter = multipartRequest.getFileNames();
					while (iter.hasNext()) {
						String name = iter.next();
						files = multipartRequest.getFiles(name);
					}
				}
			}
		} catch (Exception e) {
			throw new Exception("获取文件失败！", e);
		}
		return files;
	}

	/**
	 * 获取文件扩展名
	 * 
	 * @param filename
	 * @return
	 */
	public static String getExt(String filename) {
		if ((filename != null) && (filename.length() > 0)) {
			int dot = filename.lastIndexOf('.');
			if ((dot > -1) && (dot < (filename.length() - 1))) {
				return filename.substring(dot + 1);
			}
		}
		return filename;
	}

	/**
	 * Java文件操作 获取不带扩展名的文件名
	 * 
	 */
	public static String getFileNameNoEx(String filename) {
		if ((filename != null) && (filename.length() > 0)) {
			int dot = filename.lastIndexOf('.');
			if ((dot > -1) && (dot < (filename.length()))) {
				return filename.substring(0, dot);
			}
		}
		return filename;
	}

	/**
	 * 返回两个时间字符串之间的所有月份
	 * 
	 * @param minDate
	 * @param maxDate
	 * @return
	 */
	public static List<String> getMonthBetween(String minDate, String maxDate)
			throws Exception {
		ArrayList<String> result = new ArrayList<String>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");// 格式化为年月

		Calendar min = Calendar.getInstance();
		Calendar max = Calendar.getInstance();

		try {
			min.setTime(sdf.parse(minDate));
			min.set(min.get(Calendar.YEAR), min.get(Calendar.MONTH), 1);

			max.setTime(sdf.parse(maxDate));
		} catch (ParseException e) {
			throw new Exception("时间格式解析失败");
		}
		max.set(max.get(Calendar.YEAR), max.get(Calendar.MONTH), 2);

		Calendar curr = min;
		while (curr.before(max)) {
			result.add(sdf.format(curr.getTime()));
			curr.add(Calendar.MONTH, 1);
		}

		return result;
	}

	/**
	 * 将13位的时间戳字符串，转换为"yyyy-MM-dd HH-mm-ss.SSS"的时间格式字符串
	 * 
	 * @param time
	 * @return
	 */
	public static String getTimeStampStr(String time) {
		String re_StrTime = null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH-mm-ss");
		long lcc_time = Long.valueOf(time.substring(0, 10));
		re_StrTime = sdf.format(new Date(lcc_time * 1000L));
		return re_StrTime + time.substring(10);
	}

	/**
	 * 内存分页
	 * 
	 * @param page
	 * @param pagesize
	 * @param data
	 * @return
	 */
	public static List page(String page, String pagesize, List data) {
		int ipage = Integer.valueOf(page);
		int ipagesize = Integer.valueOf(pagesize);
		int fromIndex = (ipage - 1) * ipagesize;
		if (fromIndex >= data.size()) {
			return Collections.emptyList();
		}
		int toIndex = ipage * ipagesize;
		if (toIndex >= data.size()) {
			toIndex = data.size();
		}
		return data.subList(fromIndex, toIndex);
	}

	/**
	 * 读取CSV文件
	 * 
	 * @param file
	 *            csv文件(路径+文件)
	 * @return
	 */
	public static List<String> readCsv(MultipartFile file) throws Exception {
		List<String> dataList = new ArrayList<String>();

		BufferedReader br = null;
		try {
			br = new BufferedReader(
					new InputStreamReader(file.getInputStream()));
			String line = "";
			while ((line = br.readLine()) != null) {
				if (!line.equals("")) {
					dataList.add(line);
				}
			}
			return dataList;
		} catch (Exception e) {
			throw new Exception("解析csv文件失败", e);
		} finally {
			if (br != null) {
				try {
					br.close();
					br = null;
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

	/**
	 * 输出 blob 字段图片 (传入 blob 类型的 obj 当参数)
	 * 
	 * @param obj
	 * @param response
	 */
	public static void outPutBlobImg(Object obj, HttpServletResponse response) {
		Blob imgBlob = null;
		OutputStream out = null;
		InputStream fis = null;
		try {
			imgBlob = (Blob) obj;
			if (obj == null || imgBlob.length() == 0) {
				return;
			}
			out = response.getOutputStream();
			fis = imgBlob.getBinaryStream();
			for (int b = fis.read(); b != -1; b = fis.read()) {
				out.write(b);
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				fis.close();
				out.flush();
				out.close();
			} catch (IOException e) {
				e.printStackTrace();
			}

		}

	}

	// 判断是否为数字
	public static boolean isNumeric(String str) {
		return str.matches("-?[0-9]+.*[0-9]*");
	}

	// 判断是否为车牌号
	public static boolean isCarNum(String str) {
		return str
				.matches("^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$");
	}

	// 下划线
	public static final char UNDERLINE = '_';

	/**
	 * 驼峰格式字符串转换为下划线格式字符串
	 * 
	 * @param param
	 * @return
	 */
	public static String camelToUnderline(String param) {
		if (param == null || "".equals(param.trim())) {
			return "";
		}
		int len = param.length();
		StringBuilder sb = new StringBuilder(len);
		for (int i = 0; i < len; i++) {
			char c = param.charAt(i);
			if (Character.isUpperCase(c)) {
				sb.append(UNDERLINE);
				sb.append(Character.toLowerCase(c));
			} else {
				sb.append(c);
			}
		}
		return sb.toString();
	}

	/**
	 * 下划线格式字符串转换为驼峰格式字符串
	 * 
	 * @param param
	 * @return
	 */
	public static String underlineToCamel(String param) {
		if (param == null || "".equals(param.trim())) {
			return "";
		}
		int len = param.length();
		StringBuilder sb = new StringBuilder(len);
		for (int i = 0; i < len; i++) {
			char c = param.charAt(i);
			if (c == UNDERLINE) {
				if (++i < len) {
					sb.append(Character.toUpperCase(param.charAt(i)));
				}
			} else {
				sb.append(c);
			}
		}
		return sb.toString();
	}

	/**
	 * datatable动态排序 生成order by 语句
	 * 
	 * @param map
	 * @return
	 */
	public static Map getOrderSql(Map map) {
		// 动态排序
		String order = (String) map.get("order[0][column]");// 排序的列号
		String orderDir = (String) map.get("order[0][dir]");// 排序的顺序asc or desc
		// 排序的列。注意，我页面上的列的名字要和表中列的名字一致或者驼峰命名，否则，会导致SQL拼接错误
		String orderColumn = camelToUnderline((String) map.get("columns["
				+ order + "][data]"));
		if (Utils.isNotEmpty(orderDir) && Utils.isNotEmpty(orderColumn)) {
			String orderStr = "order by " + orderColumn + " " + orderDir;
			map.put("orderStr", orderStr);
		}
		return map;
	}

	/**
	 * miniui动态排序 生成order by 语句
	 * 
	 * @param map
	 * @return
	 */
	public static Map getOrderSqlMini(Map map) {
		// 动态排序
		String orderColumn = (String) map.get("sortField");// 排序的字段
		String orderDir = (String) map.get("sortOrder");// 排序的顺序asc or desc
		if (Utils.isNotEmpty(orderDir) && Utils.isNotEmpty(orderColumn)) {
			String orderStr = "order by " + orderColumn + " " + orderDir;
			map.put("orderStr", orderStr);
		}
		// 分页
		String page = (String) map.remove("pageIndex");
		String pagesize = (String) map.remove("pageSize");
		if (Utils.isNotEmpty(page) && Utils.isNotEmpty(pagesize)) {
			map.put("page", Integer.parseInt(page) + 1);
			map.put("pagesize", pagesize);
		}
		return map;
	}


	// json转List
	public static <T> List<T> jsonToList(String jsonString, Class<T> clazz) {
		@SuppressWarnings("unchecked")
		List<T> ts = (List<T>) JSONArray.parseArray(jsonString, clazz);
		return ts;
	}

	public static Connection getConnection() throws Exception {
		String driver = Utils.getSysProp("jdbc.driver");
		String url = Utils.getSysProp("jdbc.url");
		String username = Utils.getSysProp("jdbc.username");
		String password = Utils.getSysProp("jdbc.password");
		Class.forName(driver);
		return DriverManager.getConnection(url, username, password);
	}
}
