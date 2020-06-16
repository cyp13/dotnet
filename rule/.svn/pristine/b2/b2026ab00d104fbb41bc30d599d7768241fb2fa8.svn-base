package com.zxj.rule.util;

import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.springframework.util.StringUtils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

/**
 * 模拟发送http请求
 * @author zmk
 *
 */
public class RuleHttpUtils {
	
	private static final CloseableHttpClient httpClient= HttpClientBuilder.create().build();


	/**
	 * 发送http请求
	 * @param url
	 * @param parameter
	 * @return
	 * @throws Exception
	 */
	public static Map<String, Object> post(String url, Map<String, Object> parameter) throws Exception {
		HttpPost post = null;
		String jsonStr = "";
		parameter.put("ajax", "1");
		try {
			post = new HttpPost(url);
			if (null != parameter && !parameter.isEmpty()) {
				List<NameValuePair> params = new ArrayList<NameValuePair>();
				Set<String> keys = parameter.keySet();
				for (String key : keys) {
					params.add(new BasicNameValuePair(key, String.valueOf(parameter.get(key))));
				}
				post.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
			}
		
			CloseableHttpResponse httpResponse = httpClient.execute(post);
			jsonStr = EntityUtils.toString(httpResponse.getEntity());
		}finally{
			//释放连接
			if(null != post){
				post.releaseConnection();
			}
		}
		//校验数据是否获取成功
		if(StringUtils.isEmpty(jsonStr)){
			return new HashMap<String, Object>();
		}else{
			return JSONObject.parseObject(jsonStr, Map.class);
		}
	}
	public static Map<String, Object> get(String url, Map<String, Object> parameter) throws Exception {
		HttpGet get = null;
		String jsonStr = null;
		try {
			URIBuilder uriBuilder = new URIBuilder(url);
			if (null != parameter && !parameter.isEmpty()) {
				List<NameValuePair> params = new ArrayList<NameValuePair>();
				Set<String> keys = parameter.keySet();
				for (String key : keys) {
					params.add(new BasicNameValuePair(key, String.valueOf(parameter.get(key))));
				}
				uriBuilder.addParameters(params);
			}
			get = new HttpGet(uriBuilder.build());
			CloseableHttpResponse httpResponse = httpClient.execute(get);
			jsonStr = EntityUtils.toString(httpResponse.getEntity());
		}finally{
			//释放连接
			if(null != get){
				get.releaseConnection();
			}
		}
		//校验数据是否获取成功
		if(StringUtils.isEmpty(jsonStr)){
			return new HashMap<String, Object>();
		}else{
			return JSONObject.parseObject(jsonStr, Map.class);
		}
	}
	
	public static Map<String, Object> postJSON(String url, Object jsonObj) throws Exception {
		HttpPost post = null;
		String jsonStr = "";
		try {
			post = new HttpPost(url);
			post.setHeader("Content-type", "application/json; charset=utf-8");
	        post.setHeader("Connection", "Close");
			StringEntity entity = new StringEntity(JSON.toJSONString(jsonObj), Charset.forName("UTF-8"));
	        entity.setContentEncoding("UTF-8");
	        entity.setContentType("application/json");
	        post.setEntity(entity);
			CloseableHttpResponse httpResponse = httpClient.execute(post);
			jsonStr = EntityUtils.toString(httpResponse.getEntity());
		}finally{
			//释放连接
			if(null != post){
				post.releaseConnection();
			}
		}
		//校验数据是否获取成功
		if(StringUtils.isEmpty(jsonStr)){
			return new HashMap<String, Object>();
		}else{
			return JSONObject.parseObject(jsonStr, Map.class);
		}
	}
}
