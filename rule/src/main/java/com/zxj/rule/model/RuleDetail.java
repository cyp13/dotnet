package com.zxj.rule.model;

/**
 * 规则明细
 * @author zmk
 *
 */
public class RuleDetail {

	private Long id;
	/**
	 * 规则标题id
	 */
	private Long titleId;
	/**
	 * 下限值，一般大于等于，包含
	 */
	private Integer lowValue;
	/**
	 * 上限值，一般小于，不包含
	 */
	private Integer highValue;
	/**
	 * 规则计算表达式
	 */
	private String expression;
	/**
	 * 规则类型，0扣罚，1奖励
	 */
	private Integer ruleTyle;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getTitleId() {
		return titleId;
	}
	public void setTitleId(Long titleId) {
		this.titleId = titleId;
	}
	public Integer getLowValue() {
		return lowValue;
	}
	public void setLowValue(Integer lowValue) {
		this.lowValue = lowValue;
	}
	public Integer getHighValue() {
		return highValue;
	}
	public void setHighValue(Integer highValue) {
		this.highValue = highValue;
	}
	public String getExpression() {
		return expression;
	}
	public void setExpression(String expression) {
		this.expression = expression;
	}
	public Integer getRuleTyle() {
		return ruleTyle;
	}
	public void setRuleTyle(Integer ruleTyle) {
		this.ruleTyle = ruleTyle;
	}
	
}
