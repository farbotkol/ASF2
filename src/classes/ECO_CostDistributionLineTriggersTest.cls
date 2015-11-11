@isTest	
private class ECO_CostDistributionLineTriggersTest {
	
	@testSetup static void setupTestData() {	
		pse__Time_Period__c timePeriod = new pse__Time_Period__c();
		timePeriod.pse__Start_Date__c = Date.Today();
		timePeriod.pse__End_Date__c = Date.Today().addDays(7);
		timePeriod.TimePeriodCode__c = 'FY2015-02';
		timePeriod.pse__Type__c = 'Month';
		insert timePeriod;
		
		
		timePeriod = new pse__Time_Period__c();
		timePeriod.pse__Start_Date__c = Date.Today().AddDays(-8);
		timePeriod.pse__End_Date__c = Date.Today().addDays(-1);
		timePeriod.TimePeriodCode__c = 'FY2015-01';
		timePeriod.pse__Type__c = 'Month';
		insert timePeriod;
	}
	
	
	static testMethod void testcalculateFiscalMonths() {
		
		Test.startTest();
		CostDistLine__c costDistLine = new CostDistLine__c();
		costDistLine.PADate__c = Date.Today();
		costDistLine.GLDate__c = Date.Today();
		insert costDistLine;
		Test.stopTest();
		//[SELECT Id FROM CostDistLine__c LIMIT 1];
		
	}

}