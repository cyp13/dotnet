package com.zxj.rule.util;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * 规则配置类
 * 
 * @author zmk
 *
 */
@Component
public class RuleConfig {

	@Value("${http.portal}")
	public String portal;

	@Value("${http.portal.token}")
	public String token;

	@Value("${http.portal.sysId}")
	public String sysId;

	@Value("${http.portal.parentId}")
	public String parentId;

	@Value("${http.cl}")
	public String cl;

	@Value("${http.cl.getData}")
	public String getData;

	@Value("${http.cl.pushData}")
	public String pushData;

	public String getGetData() {
		return getData;
	}

	public String getCl() {
		return cl;
	}

	public void setCl(String cl) {
		this.cl = cl;
	}

	public void setGetData(String getData) {
		this.getData = getData;
	}

	public String getPushData() {
		return pushData;
	}

	public void setPushData(String pushData) {
		this.pushData = pushData;
	}

	public String getSysId() {
		return sysId;
	}

	public void setSysId(String sysId) {
		this.sysId = sysId;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public String getPortal() {
		return portal;
	}

	public void setPortal(String portal) {
		this.portal = portal;
	}
}
