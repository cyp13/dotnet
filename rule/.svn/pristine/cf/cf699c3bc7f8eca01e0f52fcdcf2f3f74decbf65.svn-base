/**
 * 
 */
package com.zxj.rule.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializeConfig;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.alibaba.fastjson.serializer.SimpleDateFormatSerializer;

/**
 * @author yove
 * 
 */
public class BaseController {

	@Autowired(required = false)
	protected HttpServletRequest request;

	@Autowired(required = false)
	protected HttpServletResponse response;

	protected final static String DEFAULT_FORMAT = "yyyy-MM-dd HH:mm:ss";

	protected static SerializeConfig mapping = new SerializeConfig();

	protected static SerializerFeature[] serializerFeature;

	static {
		mapping.put(Date.class, new SimpleDateFormatSerializer(DEFAULT_FORMAT));
		mapping.put(Timestamp.class, new SimpleDateFormatSerializer(DEFAULT_FORMAT));
		mapping.put(java.sql.Date.class, new SimpleDateFormatSerializer(DEFAULT_FORMAT));

		serializerFeature = new SerializerFeature[3];
//		serializerFeature[0] = SerializerFeature.WriteNullStringAsEmpty;
		serializerFeature[0] = SerializerFeature.WriteNullNumberAsZero;
		serializerFeature[1] = SerializerFeature.WriteNullBooleanAsFalse;
		serializerFeature[2] = SerializerFeature.WriteNullListAsEmpty;
		// serializerFeature[4] = SerializerFeature.WriteDateUseDateFormat;
	}

	protected String toJSONString(Object obj) {
		String json = JSON.toJSONString(obj, mapping, serializerFeature);
		String jsonp = request.getParameter("callback");
		if (jsonp!=null&&jsonp.length()>0) {
			return jsonp + "(" + json + ")";
		}
		return json;
	}

	protected String toJSONString(Object obj, String dateFormat) {
		String json = JSON.toJSONStringWithDateFormat(obj, dateFormat,
				serializerFeature);
		String jsonp = request.getParameter("callback");
		if (jsonp!=null&&jsonp.length()>0) {
			return jsonp + "(" + json + ")";
		}
		return json;
	}

	protected void write(String str, HttpServletResponse response)
			throws IOException {
		ServletOutputStream out = response.getOutputStream();
		out.write(str.getBytes("UTF-8"));
		out.close();
	}
}