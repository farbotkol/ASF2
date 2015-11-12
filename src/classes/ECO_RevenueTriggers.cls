public without sharing class ECO_RevenueTriggers {
	
	public static void calculateFiscalMonths(list<Revenue__c> revenues)
	{
		// Time period
		List<pse__Time_Period__c> timePeriods = ECO_ProjectTaskService.calcTimePeriods;
		
		pse__Time_Period__c fm = null;
		for (Revenue__c r : revenues){
			
			if (r.GLDate__c != null){	
				fm = ECO_Utils_Date.getFiscalPeriod(r.GLDate__c, 0, timePeriods);  
				if (fm != null){
					r.GLDateFiscalMonth__c = fm.TimePeriodCode__c;
				}
				
				fm = ECO_Utils_Date.getFiscalPeriod(r.GLDate__c, 1, timePeriods);  
				if (fm != null){
					r.GLDatePreviousFiscalMonth__c = fm.TimePeriodCode__c;
				}
			}
			
			if (r.PADate__c != null){	
				fm = ECO_Utils_Date.getFiscalPeriod(r.PADate__c, 0, timePeriods);  
				if (fm != null){
					r.PADateFiscalMonth__c = fm.TimePeriodCode__c;
				}
				
				fm = ECO_Utils_Date.getFiscalPeriod(r.PADate__c, 1, timePeriods);  
				if (fm != null){
					r.PADatePreviousFiscalMonth__c = fm.TimePeriodCode__c;
				}
			}						
		}
	}

}