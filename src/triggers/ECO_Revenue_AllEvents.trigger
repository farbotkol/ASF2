trigger ECO_Revenue_AllEvents on Revenue__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {
	
	if (Trigger.isBefore && !Trigger.isDelete){
		ECO_RevenueTriggers.calculateFiscalMonths(trigger.new);  
	}

}