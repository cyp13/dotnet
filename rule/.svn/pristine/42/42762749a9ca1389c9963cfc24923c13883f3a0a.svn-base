package com.zxj.rule.service.impl;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.zxj.rule.service.IHttpService;
import com.zxj.rule.util.RuleHttpUtils;

@Service
public class HttpService implements IHttpService{

	private static Logger log = Logger.getLogger(HttpService.class);
	
	@Override
	public Map<String, Object> post(String url, Map<String, Object> parameter) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			log.info("POST:" + url);
			result = RuleHttpUtils.post(url, parameter);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("HttpService请求地址：" + url + "失败");
		}
		return result;
	}

	@Override
	public Map<String, Object> postJSON(String url, Object data) {
		try {
			return RuleHttpUtils.postJSON(url, data);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public Map<String, Object> get(String url, Map<String, Object> parameter) {
		try {
			return RuleHttpUtils.get(url, parameter);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

}
