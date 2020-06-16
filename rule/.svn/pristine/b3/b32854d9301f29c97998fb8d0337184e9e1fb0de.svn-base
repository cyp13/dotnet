package com.zxj.rule.model;

import java.util.Date;

import com.zxj.rule.util.DateUtil;

public class CalTask {
	private int id;
	private int version;
	private String ruleCode;
	private String orgId;
	private String startDate;
	private String endDate;
	private String ruleName;//规则名
	private String ruleGroup;//规则分组
	private String downPattern;//下发模式
	private String useRange;//统计单位 1机构 0人
	private String lastRunTime;//最后运行时间
	private String timeAreaType;//时间段类型
	private String timeAreaName;//时间段名
	private String remark;
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public int getVersion() {
		return version;
	}
	public void setVersion(int version) {
		this.version = version;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getRuleCode() {
		return ruleCode;
	}
	public void setRuleCode(String ruleCode) {
		this.ruleCode = ruleCode;
	}
	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getRuleName() {
		return ruleName;
	}
	public void setRuleName(String ruleName) {
		this.ruleName = ruleName;
	}
	public String getRuleGroup() {
		return ruleGroup;
	}
	public void setRuleGroup(String ruleGroup) {
		this.ruleGroup = ruleGroup;
	}
	public String getDownPattern() {
		return downPattern;
	}
	public void setDownPattern(String downPattern) {
		this.downPattern = downPattern;
	}
	public String getUseRange() {
		return useRange;
	}
	public void setUseRange(String useRange) {
		this.useRange = useRange;
	}
	public String getTimeAreaType() {
		return timeAreaType;
	}
	public void setTimeAreaType(String timeAreaType) {
		this.timeAreaType = timeAreaType;
	}
	public String getTimeAreaName() {
		return timeAreaName;
	}
	public void setTimeAreaName(String timeAreaName) {
		this.timeAreaName = timeAreaName;
	}
	public String getLastRunTime() {
		return lastRunTime;
	}
	public void setLastRunTime(String lastRunTime) {
		this.lastRunTime = lastRunTime;
	}
	public void setData(CalculateItem calData) {
		calData.setCalacDate(DateUtil.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		calData.setId(this.getRuleCode());
		calData.setRealId(this.getId()+"");
		calData.setVersion(this.getVersion()+"");
		calData.setCheckItem(this.getRuleName());
		String systemName = "";
		String rg = this.getRuleGroup();
		if("1".equals(rg)) {
			systemName = "基础工作";
		}else if("2".equals(rg)) {
			systemName = "销售动作";
		}else if("3".equals(rg)) {
			systemName = "承包业绩";
		}
		calData.setSystemName(systemName);
		calData.setCycleType(this.getTimeAreaType());
		calData.setCycleValue(this.getTimeAreaName());
		String useRange = this.getUseRange();
		int dataBelong = 1;
		if("1".equals(useRange)) {
			dataBelong = 3;//机构
		}
		calData.setDataBelong(dataBelong);
	}
}
