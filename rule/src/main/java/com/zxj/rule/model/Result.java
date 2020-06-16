package com.zxj.rule.model;

/**
 * 统一返回json对象的封装结构
 * 
 * @author zmk
 *
 */
public class Result {

	/**
	 * 提示码，success是成功，fail是失败
	 */
	private String code = "success";
	/**
	 * 数据
	 */
	private Object data;
	/**
	 * 提示消息
	 */
	private String message;

	public Result() {
		super();
	}

	public Result(Object data) {
		super();
		this.data = data;
	}

	public Result(String code, String message) {
		super();
		this.code = code;
		this.message = message;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

}
