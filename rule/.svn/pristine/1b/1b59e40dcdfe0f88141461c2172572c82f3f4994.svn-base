package com.zxj.rule.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.zxj.rule.model.RuleDetail;
import com.zxj.rule.model.RuleTitle;

/**
 * 规则工具类
 * @author zmk
 *
 */
public class RuleUtils {


	/**
	 * 根据请求参数转换成功规则对象
	 * @param param
	 * @return
	 */
	public static RuleTitle convertToRule(Map<String, String[]> param){
		RuleTitle title = new RuleTitle();
		title.setAuditFlag(StringUtils.fetchInteger(param.get("auditFlag")));
		title.setAuditTarget(StringUtils.fetchInteger(param.get("auditTarget")));
		title.setAuditUnit(StringUtils.fetchInteger(param.get("auditUnit")));
		title.setDataLink(StringUtils.fetchString(param.get("dataLink")));
		title.setDataSource(StringUtils.fetchInteger(param.get("dataSource")));
		title.setForignKey(StringUtils.fetchString(param.get("forignKey")));
		title.setOrgCode(StringUtils.fetchString(param.get("orgCode")));
		title.setOrgId(StringUtils.fetchString(param.get("orgId")));
		title.setRuleStatus(StringUtils.fetchInteger(param.get("ruleStatus")));
		title.setRuleVersion(StringUtils.fetchInteger(param.get("ruleVersion")));
		title.setSample(StringUtils.fetchInteger(param.get("sample")));
		title.setServiceType(StringUtils.fetchInteger(param.get("serviceType")));
		title.setUseRange(StringUtils.fetchInteger(param.get("useRange")));
		//获取规则明细列表
		String[] rules = param.get("rules");
		
		List<RuleDetail> list = new ArrayList<RuleDetail>();
		RuleDetail temp = null;
		//规则明细结构待定
		if(null != rules && rules.length > 0){
			temp = new RuleDetail();
			for(String str : rules){
				
			}
//			temp.setExpression(expression);
		}
		
		return title;
	}
}
