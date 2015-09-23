public without sharing class ECO_TriggerSettings {
	private static Map<String, ECO_TriggerSettings__c> triggerSettingsMap;
	private static System.LoggingLevel debugLevel = LoggingLevel.DEBUG;
	
	public static Boolean getIsTriggerEnabled (String triggerName){
		if(null == triggerSettingsMap){
			triggerSettingsMap = ECO_TriggerSettings__c.getAll();
		}
		
		ECO_TriggerSettings__c thisTriggerSetting = triggerSettingsMap.get(triggerName);
		
		Boolean returnFlag = true;
		
		if(null == thisTriggerSetting){
			system.debug(debugLevel, 'No setting found for trigger:  '+triggerName);
			returnFlag = true;
		} else {
			returnFlag = thisTriggerSetting.IsEnabled__c;
		}
		
		return returnFlag;
	}
}