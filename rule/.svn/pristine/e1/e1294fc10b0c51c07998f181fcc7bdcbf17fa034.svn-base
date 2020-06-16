package com.zxj.rule.commons;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.context.annotation.Configuration;

import com.zxj.rule.util.StringUtils;

@Configuration
@WebFilter(filterName="characterEncodingFilter", urlPatterns="/*")
public class SetCharacterEncodingFilter implements Filter {

	private static final Logger log = Logger
			.getLogger(SetCharacterEncodingFilter.class);

	public void init(FilterConfig filterConfig) throws ServletException {
		log.info("Initializing SetCharacterEncodingFilter");
	}

	public void doFilter(ServletRequest arg0, ServletResponse arg1,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) arg0;
		HttpServletResponse response = (HttpServletResponse) arg1;
		try {
			response.setHeader("P3P", "CP=CAO PSA OUR");
			response.setHeader("Cache-Control", "no-cache");
			response.setHeader("Pragma", "no-cache");
			response.setDateHeader("Expires", 0);
			response.setHeader("Access-Control-Allow-Origin", "*");
			response.setContentType("text/html;charset=UTF-8");
			request.setCharacterEncoding("UTF-8");
			chain.doFilter(new HttpServletRequestWrapperExt(request), response);
		} catch (Exception e) {
			response.sendError(500, e.getMessage());
		}
	}

	class HttpServletRequestWrapperExt extends HttpServletRequestWrapper {

		public HttpServletRequestWrapperExt(HttpServletRequest request) {
			super(request);
		}

		public String getParameter(String name) {
			String value = super.getParameter(name);
			try {
				if (StringUtils.isNotEmpty(value) && isMessyCode(value)) {
					value = new String(value.getBytes("ISO-8859-1"), "UTF-8");
				}
			} catch (UnsupportedEncodingException e) {
				log.error(e.getMessage(), e);
			}
			return value;
		}

		public String[] getParameterValues(String name) {
			List<String> values = new ArrayList<String>();
			try {
				String[] paramValues = super.getParameterValues(name);
				if (null != paramValues && paramValues.length > 0) {
					for (String paramValue : paramValues) {
						if (StringUtils.isNotEmpty(paramValue)) {
							if (isMessyCode(paramValue)) {
								paramValue = new String(
										paramValue.getBytes("ISO-8859-1"),
										"UTF-8");
							}
							values.add(paramValue);
						} else {
							values.add(null);
						}
					}
				}
			} catch (UnsupportedEncodingException e) {
				log.error(e.getMessage(), e);
			}
			return values.toArray(new String[0]);
		}

		public Map<String, String[]> getParameterMap() {
			Map<String, String[]> map = new HashMap<String, String[]>();
			try {
				Map<String, String[]> parameterMap = super.getParameterMap();
				for (String paramName : parameterMap.keySet()) {
					String[] paramValues = parameterMap.get(paramName);
					if (null != paramValues && paramValues.length > 0) {
						List<String> values = new ArrayList<String>();
						for (String paramValue : paramValues) {
							if (StringUtils.isNotEmpty(paramValue)) {
								if (isMessyCode(paramValue)) {
									paramValue = new String(
											paramValue.getBytes("ISO-8859-1"),
											"UTF-8");
								}
								values.add(paramValue);
							} else {
								values.add(null);
							}
						}
						if (!values.isEmpty()) {
							map.put(paramName, values.toArray(new String[0]));
						}
					}
				}
			} catch (UnsupportedEncodingException e) {
				log.error(e.getMessage(), e);
			}
			return map;
		}
	}

	public void destroy() {
		log.info("Destroying SetCharacterEncodingFilter");
	}

	private boolean isMessyCode(String str) {
		Pattern p = Pattern.compile("\\s*|\t*|\r*|\n*");
		Matcher m = p.matcher(str);
		String after = m.replaceAll("");
		String temp = after.replaceAll("\\p{P}", "");
		char[] ch = temp.trim().toCharArray();
		float chLength = 0, count = 0;
		for (int i = 0; i < ch.length; i++) {
			if (!isChinese(ch[i])) {
				count = count + 1;
			}
			chLength++;
		}
		if ((count / chLength) > 0.4) {
			return true;
		}
		return false;
	}

	private boolean isChinese(char c) {
		Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);
		if (ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS
				|| ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS
				|| ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A
				|| ub == Character.UnicodeBlock.GENERAL_PUNCTUATION
				|| ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION
				|| ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS
				|| ub == Character.UnicodeBlock.ENCLOSED_ALPHANUMERICS
				|| ub == Character.UnicodeBlock.BASIC_LATIN) {
			return true;
		}
		return false;
	}

	public static void main(String[] args) {
		System.out.println(new SetCharacterEncodingFilter()
				.isMessyCode("①~!@#$%^&*()_+`-={}|[]<>©"));
		System.out.println(new SetCharacterEncodingFilter()
				.isMessyCode("       ?640001，你 ?"));// é????
		System.out.println(new SetCharacterEncodingFilter()
				.isMessyCode("é????"));// é????
		System.out.println(new SetCharacterEncodingFilter().isMessyCode("?"));// é?????
	}
}
