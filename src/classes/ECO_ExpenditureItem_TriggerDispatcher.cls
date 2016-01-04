/*  When a record is saved AND the Expenditure Type value is changed (from null or another value), 
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
            if (newList != null) {
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
                    [SELECT Name, ExpenditureCategory__c, PLReportCategory__c, ResourceType__c, CostReportCategory__c
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
                        expItem.CostReportCategory__c = expType.CostReportCategory__c;
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
         list<date> enddatelist = new list<date>();
        for (ExpendItem__c ba : expendItems){
             if (ba.ExpenditureItemDate__c != null){ 
                 
                 enddatelist.add((ba.ExpenditureItemDate__c).addmonths(2));
                 enddatelist.add((ba.ExpenditureItemDate__c).addmonths(-3));
             }
        }
        system.debug('enddatelist----'+enddatelist);
         List<pse__Time_Period__c> timePeriods  = new  List<pse__Time_Period__c>();
        if(enddatelist.size()>0)
        {
            // Time period
          timePeriods = ECO_Utils_Date.calcTimePeriods(enddatelist,'Month'); 
        
        // Time period
        //List<pse__Time_Period__c> timePeriods = ECO_ProjectTaskService.calcTimePeriods;
        
        pse__Time_Period__c fm = null;
        for (ExpendItem__c ei : expendItems){
            if (ei.ExpenditureItemDate__c != null){ 
                fm = ECO_Utils_Date.getFiscalPeriod(ei.ExpenditureItemDate__c, 0, timePeriods);  
                if (fm != null){
                    ei.ExpenditureDateFiscalMonth__c = fm.TimePeriodCode__c;
                }   
                fm = ECO_Utils_Date.getFiscalPeriod(ei.ExpenditureItemDate__c, 1, timePeriods);  
                if (fm != null){
                    ei.ExpenditureDatePreviousFiscalMonth__c = fm.TimePeriodCode__c;
                }                               
            }
           } 
        }
    }
}