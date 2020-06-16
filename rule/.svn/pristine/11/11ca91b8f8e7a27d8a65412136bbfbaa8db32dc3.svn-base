package com.zxj.rule.model;

import java.math.BigDecimal;

public class CalculateItem {
	//考核规则
	private String Id;//考核项ID	string	Y	.
	private String realId;//真实id
	private String version;//版本号
	private String SystemName;//体系名称	string	Y	如：基础工资
	private String CheckItem;//考核项	string	Y	如：人员配置
	private String CycleType;//周期类型	int	Y	1：年、2：半年、3：季度、4：月
	private String CycleValue;//周期值	string	Y	如果周期类型是【年】，周期值为2019；
	//考核对象
	private int DataBelong;//数据所属对象	int	Y	1：个人、2：组织机构本身
	private String UserName;//用户账号	string	Y	当DataBelong字段值为2时，UserName值为空
	private String OrgId;//组织机构ID	string	Y	.
	//考核项目
	private int total_count;
	private int over_count;
	private int noover_count;
	private int nopass_count;
	//考核结果
	private String CompleteProgress;//完成度	string	Y	完成百分比，如：50
	private String AutoDeductionScore;//系统自动核算积分扣减	string	Y	如：-100
	private Double money;
	//数据来源，默认值：1
	private int DataFrom = 1;//数据来源	int	Y	1：接口、2：导入
	//时间
	private String CalacDate;//统计时间	datetime	Y
	public String getId() {
		return Id;
	}
	public void setId(String id) {
		Id = id;
	}
	public String getRealId() {
		return realId;
	}
	public void setRealId(String realId) {
		this.realId = realId;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public String getSystemName() {
		return SystemName;
	}
	public void setSystemName(String systemName) {
		SystemName = systemName;
	}
	public String getCheckItem() {
		return CheckItem;
	}
	public void setCheckItem(String checkItem) {
		CheckItem = checkItem;
	}
	public String getCycleType() {
		return CycleType;
	}
	public void setCycleType(String cycleType) {
		CycleType = cycleType;
	}
	public String getCycleValue() {
		return CycleValue;
	}
	public void setCycleValue(String cycleValue) {
		CycleValue = cycleValue;
	}
	public int getDataBelong() {
		return DataBelong;
	}
	public void setDataBelong(int dataBelong) {
		DataBelong = dataBelong;
	}
	public String getUserName() {
		return UserName;
	}
	public void setUserName(String userName) {
		UserName = userName;
	}
	public String getOrgId() {
		return OrgId;
	}
	public void setOrgId(String orgId) {
		OrgId = orgId;
	}
	public String getCalacDate() {
		return CalacDate;
	}
	public void setCalacDate(String calacDate) {
		CalacDate = calacDate;
	}
	public int getTotal_count() {
		return total_count;
	}
	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}
	public int getOver_count() {
		return over_count;
	}
	public void setOver_count(int over_count) {
		this.over_count = over_count;
	}
	public int getNopass_count() {
		return nopass_count;
	}
	public void setNopass_count(int nopass_count) {
		this.nopass_count = nopass_count;
	}
	public String getCompleteProgress() {
		return CompleteProgress;
	}
	public void setCompleteProgress(Double completeProgress) {
		BigDecimal bg = new BigDecimal(completeProgress);
		CompleteProgress = bg.setScale(2, BigDecimal.ROUND_HALF_UP).toString();
	}
	public String getAutoDeductionScore() {
		return AutoDeductionScore;
	}
	public void setAutoDeductionScore(Double autoDeductionScore) {
		BigDecimal bg = new BigDecimal(autoDeductionScore);
		AutoDeductionScore = bg.setScale(2, BigDecimal.ROUND_HALF_UP).toString();
	}
	public Double getMoney() {
		return money;
	}
	public void setMoney(Double money) {
		BigDecimal bg = new BigDecimal(money);
		this.money = bg.setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	}
	public int getNoover_count() {
		return noover_count;
	}
	public void setNoover_count(int noover_count) {
		this.noover_count = noover_count;
	}
	public int getDataFrom() {
		return DataFrom;
	}
	public void setDataFrom(int dataFrom) {
		DataFrom = dataFrom;
	}
}
