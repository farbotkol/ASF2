public without sharing class ECO_BudgetAssignmentTriggers {
    public static Boolean run = true;
    
    public static void setCurrency(List<BudgetAssignment__c> baNew) {
        if (!run) {
            return;
        }

        Set<Id> btIds = new Set<Id>();
        Map<Id, BudgetTask__c> mapTasks = new Map<Id, BudgetTask__c>();

        for (BudgetAssignment__c ba : baNew) {
            btIds.add(ba.budgetTask__c);
        }   
            
        // Get project currency
        for (BudgetTask__c budgetTask : [Select Id, ProjectTask__r.WorkTypeName__c, BudgetHeader__r.Project__r.ProjectFunctionalCurrencyCode__c 
                                            From BudgetTask__c 
                                            Where Id IN :btIds]) {
            mapTasks.put(budgetTask.Id, budgetTask);
        }

         for (BudgetAssignment__c ba : baNew) {
            ba.CurrencyIsoCode = mapTasks.get(ba.BudgetTask__c).BudgetHeader__r.Project__r.ProjectFunctionalCurrencyCode__c;
            ba.WorkTypeName__c = mapTasks.get(ba.BudgetTask__c).ProjectTask__r.WorkTypeName__c;
        }
    }

    public static void setRateDefaults(List<BudgetAssignment__c> baNew) {
        if (!run) {
            return;
        }

        Set<Id> budgetResourceIds = new Set<Id>();
        for (BudgetAssignment__c ba : baNew) {
            budgetResourceIds.add(ba.BudgetResource__c);
        }
        
        Map<Id, BudgetResource__c> mapBudgetResourceById = new Map<Id, BudgetResource__c> (
                                                            [SELECT Id, 
                                                                OverrideRatesOnLines__c, 
                                                                OverrideRawCost__c, 
                                                                OverrideFringeMultiplier__c,
                                                                OverrideOverheadMultiplier__c,
                                                                OverrideFringeMultiplierField__c,
                                                                OverrideOverheadMultiplierField__c,
                                                                MarginType__c,
                                                                OverrideBillRate__c,
                                                                OverrideUplift__c  
                                                            FROM BudgetResource__c 
                                                            WHERE Id IN :budgetResourceIds]);
        

        for (BudgetAssignment__c ba : baNew) {
            BudgetResource__c br = mapBudgetResourceById.get(ba.BudgetResource__c);

            ECO_BudgetResourceTriggers.setRatesEqual(br, ba);
        }
    }

    public static void setDefaults (List<BudgetAssignment__c> baNew) {
        if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('BA_setDefaults')) {
            return;
        }
        
        Set<Id> budgetResourceIds = new Set<Id>();
        for (BudgetAssignment__c ba : baNew) {
            budgetResourceIds.add(ba.BudgetResource__c);
        }
        
        Map<Id, String> budgetResourceIdToApprovalStatusMap = new Map<Id, String>();
        for (BudgetResource__c br : [SELECT Id 
                                        , BudgetHeader__r.Status__c
                                    FROM BudgetResource__c 
                                    WHERE Id IN :budgetResourceIds]) {
            budgetResourceIdToApprovalStatusMap.put(br.Id, br.BudgetHeader__r.Status__c);
        }
        
        for (BudgetAssignment__c ba : baNew) {
            ba.ApprovalStatus__c = budgetResourceIdToApprovalStatusMap.get(ba.BudgetResource__c);
        }
    }

    public static void calculateMultiplier(List<BudgetAssignment__c> baNew) {
        if (!run) {
            return;
        }

        Set<Id> baIds = new Set<Id>();

        for (BudgetAssignment__c ba : baNew) {
            baIds.add(ba.id);
        }

        List<BudgetAssignment__c> budgetAssignments = [select id, ProjectTask__r.OrgID__c, BudgetTask__r.ProjectTask__r.Burden_Reference_Schedule_Name__c, BudgetResource__r.Resource__r.User__r.ExpenditureType__c from BudgetAssignment__c where id in :baIds];

        Set<String> scheduleNames = new Set<String>();

        for (BudgetAssignment__c budgetAssignment : budgetAssignments) {
            scheduleNames.add(budgetAssignment.BudgetTask__r.ProjectTask__r.Burden_Reference_Schedule_Name__c);
        }

        List<BurdenSchedule__c> burdenSchedules = [select id, CostCode__c, CostPlusStructure__c, OracleRateScheduleName__c from BurdenSchedule__c where OracleRateScheduleName__c in :scheduleNames];

        Set<String> costPlusStructures = new Set<String>();
        Map<String, Set<String>> scheduleNameToCostPlusStructures = new Map<String, Set<String>>();

        for (BurdenSchedule__c burdenSchedule : burdenSchedules) {
            costPlusStructures.add(burdenSchedule.CostPlusStructure__c);
            
            Set<String> costPlusStructureSet = scheduleNameToCostPlusStructures.get(burdenSchedule.CostPlusStructure__c);

            if (costPlusStructureSet == null) {
                costPlusStructureSet = new Set<String>();

                scheduleNameToCostPlusStructures.put(burdenSchedule.CostPlusStructure__c, costPlusStructureSet);
            }

            costPlusStructureSet.add(burdenSchedule.OracleRateScheduleName__c);
        }

        List<BurdenStructure__c> burdenStructures = [select id, ExpenditureType__c, CostCode__c, CostPlusStructure__c from BurdenStructure__c where CostPlusStructure__c in :costPlusStructures];

        Map<String, Set<String>> costCodeMap = new Map<String, Set<String>>();

        for (BurdenStructure__c burdenStructure : burdenStructures) {
            String key = burdenStructure.CostPlusStructure__c + '~' + burdenStructure.ExpenditureType__c;

            Set<String> costCodes = costCodeMap.get(key);

            if (costCodes == null) {
                costCodes = new Set<String>();

                costCodeMap.put(key, costCodes);
            }

            costCodes.add(burdenStructure.CostCode__c);
        }

        Set<String> allCostCodes = new Set<String>();

        for (BudgetAssignment__c budgetAssignment : budgetAssignments) {
            String scheduleName = budgetAssignment.BudgetTask__r.ProjectTask__r.Burden_Reference_Schedule_Name__c;
            String expenditureType = budgetAssignment.BudgetResource__r.Resource__r.User__r.ExpenditureType__c;
            
            Set<String> costPlusStructures2 = scheduleNameToCostPlusStructures.get(scheduleName);

            for (String costPlusStructure : costPlusStructures2) {
                String key = costPlusStructure + '~' + expenditureType;

                Set<String> costCodes = costCodeMap.get(key);

                allCostCodes.addAll(costCodes);
            }
        }


        List<BurdenSchedule__c> burdenSchedules2 = [select id, CostCode__c, OrgID__c from BurdenSchedule__c where CostCode__c in :allCostCodes];

        Map<String, Set<String>> orgMap = new Map<String, Set<String>>();

        for (BurdenSchedule__c burdenSchedule : burdenSchedules2) {
            Set<String> orgIds = orgMap.get(burdenSchedule.CostCode__c);

            if (orgIds == null) {
                orgIds = new Set<String>();

                orgMap.put(burdenSchedule.CostCode__c, orgIds);
            }

            orgIds.add(burdenSchedule.OrgID__c);
        }

        for (BudgetAssignment__c budgetAssignment : budgetAssignments) {
            String scheduleName = budgetAssignment.BudgetTask__r.ProjectTask__r.Burden_Reference_Schedule_Name__c;
            String expenditureType = budgetAssignment.BudgetResource__r.Resource__r.User__r.ExpenditureType__c;
            
            Set<String> costPlusStructures2 = scheduleNameToCostPlusStructures.get(scheduleName);

            for (String costPlusStructure : costPlusStructures2) {
                String key = costPlusStructure + '~' + expenditureType;

                Set<String> costCodes = costCodeMap.get(key);

                for (String costCode : costCodes) {
                    Set<String> orgIds = orgMap.get(costCode);

                    for (String orgId : orgIds) {
                        if (orgId == budgetAssignment.ProjectTask__r.OrgID__c) {
                            System.debug('hey - ' + orgId + ' - ' + costCode + ' - ' + budgetAssignment.id);
                        }
                    }
                }
            }
        }

    }

    public static void calculateFiscalMonths(list<BudgetAssignment__c> budgetAssignments)
    {
        
        list<date> enddatelist = new list<date>();
        for (BudgetAssignment__c ba : budgetAssignments){
             if (ba.EndDate__c != null){ 
                 
                 enddatelist.add((ba.EndDate__c).addmonths(2));
                 enddatelist.add((ba.EndDate__c).addmonths(-3));
             }
        }
        system.debug('enddatelist----'+enddatelist);
         List<pse__Time_Period__c> timePeriods  = new  List<pse__Time_Period__c>();
        if(enddatelist.size()>0)
        {
            // Time period
          timePeriods = ECO_Utils_Date.calcTimePeriods(enddatelist,'Month');
          //  List<pse__Time_Period__c> timePeriods = new list<pse__Time_Period__c>([select id,TimePeriodCode__c,pse__End_Date__c,pse__Start_Date__c from pse__Time_Period__c where pse__Type__c = 'Month' and pse__Start_Date__c <=:enddatelist and pse__End_Date__c  >=:enddatelist]);
          system.debug('timePeriods ----'+timePeriods );
            pse__Time_Period__c fm = null;
            for (BudgetAssignment__c ba : budgetAssignments){
                if (ba.EndDate__c != null){ 
                    fm = ECO_Utils_Date.getFiscalPeriod(ba.EndDate__c, 0, timePeriods);  
                    system.debug('207-----'+fm);
                    if (fm != null){
                        ba.EndDateFiscalMonth__c = fm.TimePeriodCode__c;
                    }
                    
                    fm = ECO_Utils_Date.getFiscalPeriod(ba.EndDate__c, 1, timePeriods);
                     system.debug('213-----'+fm);
                    if (fm != null){
                        ba.EndDatePreviousFiscalMonth__c = fm.TimePeriodCode__c; 
                    }
                }
            }
        }
    }
}