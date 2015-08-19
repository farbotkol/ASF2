public without sharing class ECO_BudgetResourceTriggers {
	public static Boolean run = true;
	
	// runs before insert
	public static void defaultCostRevenueValuesOnHeader (List<BudgetResource__c> budResToDefault) {
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('BR_setDefaults')) {
			return;
		}
		
		Set<Id> allBudgetHeaderIds = new Set<Id>();
		Set<Id> allResourceIds = new Set<Id>();
		Set<String> allExpenditureTypes = new Set<String>();
		
		
		for (BudgetResource__c br : budResToDefault) {
			allBudgetHeaderIds.add(br.BudgetHeader__c);
			allResourceIds.add(br.ProjectTeamMember__c);
			allExpenditureTypes.add(br.ExpenditureType__c);
		}
		
		Map<Id, BudgetHeader__c> headerMap = new Map<Id, BudgetHeader__c>([SELECT Id 
																					, Project__r.DefaultUpliftLabor__c
																					, Project__r.DefaultUpliftSubs__c
																					, Project__r.DefaultUpliftODCs__c
																			FROM BudgetHeader__c
																			WHERE Id IN :allBudgetHeaderIds]);
																			
		Map<Id, ProjectTeamMember__c> resourceMap = new Map<Id, ProjectTeamMember__c>([SELECT Id
																								, Contact__r.pse__Default_Cost_Rate__c
																								, Contact__r.ExpenditureType__c
																						FROM ProjectTeamMember__c
																						WHERE Id IN :allResourceIds]);
		
		
		
		
		
		
		for (BudgetResource__c br : budResToDefault) {
			BudgetHeader__c thisBH = headerMap.get(br.BudgetHeader__c);
			
			if (thisBH != null) {
				if ('Labor/Person'.equalsIgnoreCase(br.ResourceType__c)) {
					br.OverrideUplift__c = thisBH.Project__r.DefaultUpliftLabor__c;
				} else if ('Subcontractor'.equalsIgnoreCase(br.ResourceType__c)) {
					br.OverrideUplift__c = thisBH.Project__r.DefaultUpliftSubs__c;
				} else if ('ODC/FEE'.equalsIgnoreCase(br.ResourceType__c)) {
					br.OverrideUplift__c = thisBH.Project__r.DefaultUpliftODCs__c;
				}
				
				// Old style, we replaced this with the stuff above
				//br.OverrideUplift__c = thisBH.Project__r.DefaultUplift__c;
			}
			
			ProjectTeamMember__c thisResource = resourceMap.get(br.ProjectTeamMember__c);
			
			if (thisResource != null) {
				system.debug('thisResource:  '+thisResource);
				system.debug('thisResource.pse__Default_Cost_Rate__c:  '+thisResource.Contact__r.pse__Default_Cost_Rate__c);
				
				br.OverrideRawCost__c = thisResource.Contact__r.pse__Default_Cost_Rate__c;
				
				br.ExpenditureType__c = thisResource.Contact__r.ExpenditureType__c;
			}
			
			
			// TODO:  These are totally temporary and need to be replaced with the burden schedule complex logic
			br.OverrideFringeMultiplier__c = 50;
			br.OverrideOverheadMultiplier__c = 50;
			
			br.OverrideRatesOnLines__c = true;
			
		}
		
		
	}
}