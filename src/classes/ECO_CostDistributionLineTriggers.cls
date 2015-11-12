public without sharing class ECO_CostDistributionLineTriggers {
	
	public static Boolean run = true;
	
	public static void rollUpCosts (List<CostDistLine__c> tOld, List<CostDistLine__c> tNew) {
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('CDL_rollup')) {
			return;
		}
		/*
		Set<Id> projectTaskIds = new Set<Id>();
		if (tOld != null) {
			for (CostDistLine__c cdl : tOld) {
				projectTaskIds.add(cdl.TaskNumber__c);
			}
		}
		
		if (tNew != null) {
			for (CostDistLine__c cdl : tNew) {
				projectTaskIds.add(cdl.TaskNumber__c);
			}
		}
												
		List<pse__Project_Task__c> projectTasksToUpdate = new List<pse__Project_Task__c>();
		
		for (AggregateResult ar : [SELECT TaskNumber__c
										, SUM(ProjectFunctionalBurdenedCost__c) totalActualCostAmount
									FROM CostDistLine__c
									WHERE TaskNumber__c IN :projectTaskIds
										AND TaskNumber__c != null
									GROUP BY TaskNumber__c]) {
										
			system.debug('ar:  '+ar);
			
			pse__Project_Task__c ptToUpdate = new pse__Project_Task__c();
			ptToUpdate.Id = (Id)ar.get('TaskNumber__c');
			ptToUpdate.TotalActualCost__c = (Decimal)ar.get('totalActualCostAmount');
			projectTasksToUpdate.add(ptToUpdate);
		}
		
		if (!projectTasksToUpdate.isEmpty()) {
			update projectTasksToUpdate;
		}
		*/

		map<string, Decimal> mFunctionalRawCost = new map<string, Decimal>();
		map<string, Decimal> mFunctionalBurdenedCost = new map<string, Decimal>();

		if(tNew != null){
			for(CostDistLine__c oCDL : tNew){
				string sSnapshotKey = ECO_Service_Snapshots.DateToSnapshotKey(oCDL.PADate__c, oCDL.ProjectNumber__c, oCDL.TaskNumber__c);

				Decimal dFunctionalRawCost = ECO_Utils_String.NullCheck(mFunctionalRawCost.get(sSnapshotKey)) + ECO_Utils_String.NullCheck(oCDL.ProjectFunctionalRawCost__c);
				mFunctionalRawCost.put(sSnapshotKey, dFunctionalRawCost);

				Decimal dFunctionalBurdenedCost = ECO_Utils_String.NullCheck(mFunctionalBurdenedCost.get(sSnapshotKey)) + ECO_Utils_String.NullCheck(oCDL.ProjectFunctionalBurdenedCost__c);
				mFunctionalBurdenedCost.put(sSnapshotKey, dFunctionalBurdenedCost);
			}
		}

		if(tOld != null){
			for(CostDistLine__c oCDL : tOld){
				string sSnapshotKey = ECO_Service_Snapshots.DateToSnapshotKey(oCDL.PADate__c, oCDL.ProjectNumber__c, oCDL.TaskNumber__c);

				Decimal dFunctionalRawCost = ECO_Utils_String.NullCheck(mFunctionalRawCost.get(sSnapshotKey)) - ECO_Utils_String.NullCheck(oCDL.ProjectFunctionalRawCost__c);
				mFunctionalRawCost.put(sSnapshotKey, dFunctionalRawCost);

				Decimal dFunctionalBurdenedCost = ECO_Utils_String.NullCheck(mFunctionalBurdenedCost.get(sSnapshotKey)) - ECO_Utils_String.NullCheck(oCDL.ProjectFunctionalBurdenedCost__c);
				mFunctionalBurdenedCost.put(sSnapshotKey, dFunctionalBurdenedCost);
			}
		}

		set<string> lSnapshotKeys = new set<string>();

		for(string s : mFunctionalRawCost.keySet()){
			lSnapshotKeys.add(s);
		}

		for(string s : mFunctionalBurdenedCost.keySet()){
			lSnapshotKeys.add(s);
		}

		list<EarnedValueSnapshot__c> lEarnedValueSnapshots = new list<EarnedValueSnapshot__c>([SELECT Id
																								    , SnapshotKey__c
																								    , ProjectFunctionalRawCost__c
																								    , ProjectFunctionalBurdenedCost__c 
																							  FROM EarnedValueSnapshot__c 
																							  WHERE SnapshotKey__c in :lSnapshotKeys]);

		list<EarnedValueSnapshot__c> lEarnedValueSnapshotsToUpdate = new list<EarnedValueSnapshot__c>();

		for(EarnedValueSnapshot__c oEarnedValueSnapshot : lEarnedValueSnapshots){
			string sSnapshotKey = oEarnedValueSnapshot.SnapshotKey__c;
			boolean bRecordToAdd = false;

			if(mFunctionalRawCost.containsKey(sSnapshotKey)){
				oEarnedValueSnapshot.ProjectFunctionalRawCost__c = ECO_Utils_String.NullCheck(oEarnedValueSnapshot.ProjectFunctionalRawCost__c) + ECO_Utils_String.NullCheck(mFunctionalRawCost.get(sSnapshotKey));

				bRecordToAdd = true;
			}

			if(mFunctionalBurdenedCost.containsKey(sSnapshotKey)){
				oEarnedValueSnapshot.ProjectFunctionalBurdenedCost__c = ECO_Utils_String.NullCheck(oEarnedValueSnapshot.ProjectFunctionalBurdenedCost__c) + ECO_Utils_String.NullCheck(mFunctionalBurdenedCost.get(sSnapshotKey));

				bRecordToAdd = true;
			}

			if(bRecordToAdd)
				lEarnedValueSnapshotsToUpdate.add(oEarnedValueSnapshot);
		}

		if (!lEarnedValueSnapshotsToUpdate.isEmpty()) {
			update lEarnedValueSnapshotsToUpdate;
		}
	}
	
	public static void calculateFiscalMonths(list<CostDistLine__c> costDistLines)
	{
		// Time period
		List<pse__Time_Period__c> timePeriods = ECO_ProjectTaskService.calcTimePeriods;
		
		pse__Time_Period__c fm = null;
		for (CostDistLine__c cdl : costDistLines){
												
			for (Integer i = 0; i < timePeriods.size(); i++){
				
				if (cdl.GLDate__c != null){	
					fm = ECO_Utils_Date.getFiscalPeriod(cdl.GLDate__c, 0, timePeriods);  
					if (fm != null){
						cdl.GLFiscalMonth__c = fm.TimePeriodCode__c;
					}
					
				}
				
				if (cdl.PADate__c != null){	
					fm = ECO_Utils_Date.getFiscalPeriod(cdl.PADate__c, 0, timePeriods);  
					if (fm != null){
						cdl.PAFiscalMonth__c = fm.TimePeriodCode__c;
					}
					
				}
			}
			
		}
	}
}