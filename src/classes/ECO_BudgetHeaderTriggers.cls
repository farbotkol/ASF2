public without sharing class ECO_BudgetHeaderTriggers {
	public static Boolean run = true;
	
	public static void setCurrency(List<BudgetHeader__c> newBHList) {
    	if (!run) {
    		return;
    	}

    	Id projId = newBHList[0].Project__c;
    	// Get project currency
        pse__Proj__c proj = [Select Id, CurrencyIsoCode From pse__Proj__c Where Id = :projId];


        String projectCurrency = proj.CurrencyIsoCode;

        for (BudgetHeader__c bh : newBHList) {
        	bh.CurrencyIsoCode = projectCurrency;
            
        }
    }
	public static void cascadeApprovalStatus (Map<Id, BudgetHeader__c> bhNew, Map<Id, BudgetHeader__c> bhOld) {
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('BH_cascadeApproval')) {
			return;
		}
		
		Set<Id> budgetHeaderIdsThatChangedStatus = new Set<Id>();
		
		for (BudgetHeader__c bh : bhNew.values()) {
			if (bh.Status__c != bhOld.get(bh.Id).Status__c) {  // Safe, since we always run after update.
				budgetHeaderIdsThatChangedStatus.add(bh.Id);
			}
		}
		
		List<BudgetAssignment__c> budgetAssignmentsToUpdate = new List<BudgetAssignment__c>();
		
		for (BudgetResource__c br : [SELECT Id 
											, (SELECT Id 
													, BudgetResource__r.BudgetHeader__r.Status__c
												FROM BudgetAssignments__r)
										FROM BudgetResource__c 
										WHERE BudgetHeader__c IN :budgetHeaderIdsThatChangedStatus]) {
			for (BudgetAssignment__c ba : br.BudgetAssignments__r) {
				ba.ApprovalStatus__c = ba.BudgetResource__r.BudgetHeader__r.Status__c;
				budgetAssignmentsToUpdate.add(ba);
			}
		}
		
		if (!budgetAssignmentsToUpdate.isEmpty()) {
			update budgetAssignmentsToUpdate;
		}
	}
	
	public static void rollUpValuesToProject (List<BudgetHeader__c> newBHList, List<BudgetHeader__c> oldBHList) {
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('BH_rollUpToProject')) {
			return;
		}
		
		Map<Id, pse__Proj__c> projectsToUpdate = new Map<Id, pse__Proj__c>();
		
		for (BudgetHeader__c bh : newBHList) {
			projectsToUpdate.put(bh.Project__c, new pse__Proj__c(Id = bh.Project__c
																, TotalApprovedRevenue__c = 0
																, TotalApprovedCost__c = 0
																, TotalForecastRevenue__c = 0
																, TotalForecastCost__c = 0));
		}
		
		for (BudgetHeader__c bh : oldBHList) {
			projectsToUpdate.put(bh.Project__c, new pse__Proj__c(Id = bh.Project__c
																, TotalApprovedRevenue__c = 0
																, TotalApprovedCost__c = 0
																, TotalForecastRevenue__c = 0
																, TotalForecastCost__c = 0));
		}
		
		for (AggregateResult ar : [SELECT Project__c
											, SUM(TotalRevenue__c) totalRevenue
											, SUM(TotalCost__c) totalCost
									FROM BudgetHeader__c
									WHERE Project__c IN :projectsToUpdate.keySet()
										AND Status__c = 'Approved'
									GROUP BY Project__c]) {
			pse__Proj__c projToUpdate = projectsToUpdate.get((Id)ar.get('Project__c'));
			projToUpdate.TotalApprovedRevenue__c = (Decimal)ar.get('totalRevenue');
			projToUpdate.TotalApprovedCost__c = (Decimal)ar.get('totalCost');
		}
		
		for (AggregateResult ar : [SELECT Project__c
											, SUM(TotalRevenue__c) totalRevenue
											, SUM(TotalCost__c) totalCost
									FROM BudgetHeader__c
									WHERE Project__c IN :projectsToUpdate.keySet()
										AND Status__c = 'Forecast'
									GROUP BY Project__c]) {
			pse__Proj__c projToUpdate = projectsToUpdate.get((Id)ar.get('Project__c'));
			projToUpdate.TotalForecastRevenue__c = (Decimal)ar.get('totalRevenue') + projToUpdate.TotalApprovedRevenue__c;
			projToUpdate.TotalForecastCost__c = (Decimal)ar.get('totalCost') + projToUpdate.TotalApprovedCost__c;
		}
		

		update projectsToUpdate.values(); // This will always have values in it... no need to check for isempty
		
	}
}