/* 	When a record is saved AND the Expenditure Type value is changed (from null or another value), 
	take the Expenditure Type value, look it up in ExpenditureType.Name. Pick up the Group, Subgroup, 
	and Resource Type values and set them on the corresponding fields in the Expenditure Item object.
*/
public with sharing class ECO_ExpenditureItem_TriggerDispatcher
{
	public static void Main(List<ExpendItem__c> newList, Map<Id, ExpendItem__c> newMap, 
		List<ExpendItem__c> oldList, Map<Id, ExpendItem__c> oldMap, Boolean isBefore, Boolean isAfter, 
		Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isExecuting)
	{
		if (isBefore) {
			
			List<ExpendItem__c> expItemListToSave = new List<ExpendItem__c>();
			for (ExpendItem__c expItem : newList) {
				if (expItem.ExpenditureType__c != null) {
					if (isInsert) {
						System.debug('___isInsert: expItem='+expItem);
						expItemListToSave.add(expItem);
					}
					else if (isUpdate) {
	                    if (expItem.ExpenditureType__c != oldMap.get(expItem.id).ExpenditureType__c) {
	                    	System.debug('___isUpdate: expItem='+expItem);
							expItemListToSave.add(expItem);
	                    }
					}
				}
			}
			adjustExpenditureItems(expItemListToSave);
			
			if (!isDelete){
				calculateFiscalMonths(newList); 
			}
		} 
	}
		

	private static void adjustExpenditureItems(List<ExpendItem__c> expItemList) {
		System.debug('___START adjustExpenditureItems');
		if (expItemList != null && expItemList.size() > 0) {
			try {
				Set<String> expTypeSet = new Set<String>();
				for (ExpendItem__c expItem : expItemList) {
					expTypeSet.add(expItem.ExpenditureType__c);
				}
				System.debug('___expTypeSet='+expTypeSet);
				
				Map<String, ExpenditureType__c> expTypeMap = new Map<String, ExpenditureType__c>();
				List<ExpenditureType__c> expTypeList =
					[SELECT Name, ExpenditureCategory__c, PLReportCategory__c, ResourceType__c 
					 FROM ExpenditureType__c WHERE Name IN: expTypeSet];
				for (ExpenditureType__c et : expTypeList) {
					expTypeMap.put(et.Name, et);
				}
				System.debug('___expTypeMap='+expTypeMap);

				for (ExpendItem__c expItem : expItemList) {
					String expTypeName = expItem.ExpenditureType__c;
					ExpenditureType__c expType = (ExpenditureType__c) expTypeMap.get(expTypeName);
					System.debug('___expType='+expType);
					if (expType != null) {
						expItem.ExpenditureResourceType__c = expType.ResourceType__c;
						expItem.ExpenditureTypeCategory__c = expType.ExpenditureCategory__c;
						expItem.PLReportCategory__c = expType.PLReportCategory__c;
						System.debug('___Adjusted expItem='+expItem);
					}
				}
			}
			catch(Exception e) {
				System.debug(e.getStackTraceString());
			}
		}
		System.debug('___END adjustExpenditureItems');
	}
	
	private static void calculateFiscalMonths(list<ExpendItem__c> expendItems)
	{
		// Time period
		List<pse__Time_Period__c> timePeriods = [select Id, pse__Start_Date__c, pse__End_Date__c, TimePeriodCode__c 
													from pse__Time_Period__c 
													where pse__Type__c = 'Month'
													order by pse__End_Date__c asc];
		for (ExpendItem__c ei : expendItems){
			if (ei.ExpenditureItemDate__c != null){										
				for (Integer i = 0; i < timePeriods.size(); i++){
					if (ei.ExpenditureItemDate__c <= timePeriods[i].pse__End_Date__c  &&
						ei.ExpenditureItemDate__c >= timePeriods[i].pse__Start_Date__c){
						ei.ExpenditureDateFiscalMonth__c = timePeriods[i].TimePeriodCode__c;
						if (i > 0){
							ei.ExpenditureDatePreviousFiscalMonth__c = timePeriods[i-1].TimePeriodCode__c;
						}
					}
				}
			}
		}
	}
}