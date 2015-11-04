public without sharing class ECO_RevenueTriggers {
	
	public static void calculateFiscalMonths(list<Revenue__c> revenues)
	{
		// Time period
		List<pse__Time_Period__c> timePeriods = [select Id, pse__Start_Date__c, pse__End_Date__c, TimePeriodCode__c 
													from pse__Time_Period__c 
													where pse__Type__c = 'Month'
													order by pse__End_Date__c asc];
		for (Revenue__c r : revenues){					
			for (Integer i = 0; i < timePeriods.size(); i++){
				System.Debug('Time:' + timePeriods[i].pse__Start_Date__c + timePeriods[i].pse__End_Date__c);
				System.Debug('GLDate' + r.GLDate__c );
				
				
				if (r.GLDate__c != null){
					if (r.GLDate__c <= timePeriods[i].pse__End_Date__c  &&
						r.GLDate__c >= timePeriods[i].pse__Start_Date__c){
						r.GLDateFiscalMonth__c = timePeriods[i].TimePeriodCode__c;
						if (i > 0){
							r.GLDatePreviousFiscalMonth__c = timePeriods[i-1].TimePeriodCode__c;
						}
					}
				}
				
				System.Debug('PADate' + r.PADate__c);
				if (r.PADate__c != null){
					if (r.PADate__c <= timePeriods[i].pse__End_Date__c  &&
						r.PADate__c >= timePeriods[i].pse__Start_Date__c){
						r.PADateFiscalMonth__c = timePeriods[i].TimePeriodCode__c;
						if (i > 0){
							r.PADatePreviousFiscalMonth__c = timePeriods[i-1].TimePeriodCode__c;
						}
					}
				}
			}
		}
	}

}