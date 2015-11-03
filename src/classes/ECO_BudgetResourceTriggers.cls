public without sharing class ECO_BudgetResourceTriggers {
	public static Boolean run = true;
	
    public static Boolean areRatesEqual(BudgetResource__c oBudgetResource, BudgetAssignment__c oBudgetAssignment) {
		if (oBudgetAssignment.OverrideRawCost__c != oBudgetResource.OverrideRawCost__c) return false;
        if (oBudgetAssignment.OverrideFringeMultiplier__c != oBudgetResource.OverrideFringeMultiplier__c) return false;
        if (oBudgetAssignment.OverrideOverheadMultiplier__c != oBudgetResource.OverrideOverheadMultiplier__c) return false;
        if (oBudgetAssignment.MarginType__c != oBudgetResource.MarginType__c) return false;
        if (oBudgetAssignment.OverrideBillRate__c != oBudgetResource.OverrideBillRate__c) return false;
        if (oBudgetAssignment.OverrideUplift__c != oBudgetResource.OverrideUplift__c) return false;

        return true;
    }

    public static BudgetAssignment__c setRatesEqual(BudgetResource__c oBudgetResource, BudgetAssignment__c oBudgetAssignment) {
    	if (oBudgetResource.OverrideRatesOnLines__c) {
	    	oBudgetAssignment.OverrideRawCost__c = oBudgetResource.OverrideRawCost__c;
	        oBudgetAssignment.OverrideFringeMultiplier__c = oBudgetResource.OverrideFringeMultiplier__c;
	        oBudgetAssignment.OverrideOverheadMultiplier__c = oBudgetResource.OverrideOverheadMultiplier__c;
	        
	        oBudgetAssignment.MarginType__c = oBudgetResource.MarginType__c;
	        oBudgetAssignment.OverrideBillRate__c = oBudgetResource.OverrideBillRate__c;
	        oBudgetAssignment.OverrideUplift__c = oBudgetResource.OverrideUplift__c;
		}

        return oBudgetAssignment;
    }

    public static void setDefaultValues (map<Id, BudgetResource__c> mBudgetResources){
        list<BudgetAssignment__c> lBudgetAssignmentsToUpdate = new list<BudgetAssignment__c>();

        system.debug(mBudgetResources);
        
        for(BudgetAssignment__c oBudgetAssignment : [SELECT id, BudgetResource__c, 
        														OverrideRawCost__c, 
        														OverrideFringeMultiplier__c,
        														OverrideOverheadMultiplier__c,
        														MarginType__c,
        														OverrideBillRate__c,
        														OverrideUplift__c 
        														FROM BudgetAssignment__c WHERE BudgetResource__c in :mBudgetResources.keySet() ]) {

            BudgetResource__c oBudgetResource = mBudgetResources.get(oBudgetAssignment.BudgetResource__c);
            
            system.debug(oBudgetResource);
            
            if (oBudgetResource.OverrideRatesOnLines__c && !areRatesEqual(oBudgetResource, oBudgetAssignment) ) {
                setRatesEqual(oBudgetResource, oBudgetAssignment);
                
                system.debug(oBudgetAssignment);
                
                lBudgetAssignmentsToUpdate.add(oBudgetAssignment);
            }
        }
        
        system.debug(lBudgetAssignmentsToUpdate);
        
        update lBudgetAssignmentsToUpdate;
    }
    
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
				if (br.OverrideUplift__c == null) {
					if ('Labor/Person'.equalsIgnoreCase(br.ResourceType__c)) {
						br.OverrideUplift__c = thisBH.Project__r.DefaultUpliftLabor__c;
					} else if ('Subcontractor'.equalsIgnoreCase(br.ResourceType__c)) {
						br.OverrideUplift__c = thisBH.Project__r.DefaultUpliftSubs__c;
					} else if ('ODC/FEE'.equalsIgnoreCase(br.ResourceType__c)) {
						br.OverrideUplift__c = thisBH.Project__r.DefaultUpliftODCs__c;
					}
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
			/*
			if (br.ResourceType__c == 'Labor/Person') {
				br.OverrideFringeMultiplier__c = 50;
				br.OverrideOverheadMultiplier__c = 50;
			}
			*/
			
			br.OverrideRatesOnLines__c = true;
			
		}
		
		
	}

	public static void calculateMultiplier(List<BudgetResource__c> brNew) {
		if (!run) {
			return;
		}

		Set<Id> resourceIds = new Set<Id>();
		Set<Id> headerIds = new Set<Id>();

		for (BudgetResource__c br : brNew) {
			resourceIds.add(br.Resource__c);
			headerIds.add(br.BudgetHeader__c);
		}

		List<Contact> resources = [select id, User__r.ExpenditureType__c from Contact where id in :resourceIds];

		Map<Id, String> expenditureMap = new Map<Id, String>();

		for (Contact resource : resources) {
			expenditureMap.put(resource.id, resource.User__r.ExpenditureType__c);
		}

		List<BudgetHeader__c> headers = [select id, Project__r.CarryingOutOrganization__r.OrgId__c from BudgetHeader__c where id in :headerIds];

		Set<String> orgIds = new Set<String>();
		Map<Id, String> orgMap = new Map<Id, String>();

		for (BudgetHeader__c header : headers) {
			orgIds.add(header.Project__r.CarryingOutOrganization__r.OrgId__c);
			orgMap.put(header.id, header.Project__r.CarryingOutOrganization__r.OrgId__c);
		}

		List<BurdenSchedule__c> schedules = [select id, OracleRateScheduleName__c, CostCode__c, Multiplier__c, OrgId__c from BurdenSchedule__c where OrgId__c in :orgIds];

		Set<String> costCodes = new Set<String>();
		Map<String, List<BurdenSchedule__c>> costCodeMap = new Map<String, List<BurdenSchedule__c>>();

		for (BurdenSchedule__c schedule : schedules) {
			costCodes.add(schedule.CostCode__c);

			List<BurdenSchedule__c> theList = costCodeMap.get(schedule.OrgId__c);

			if (theList == null) {
				theList = new List<BurdenSchedule__c>();
				costCodeMap.put(schedule.OrgId__c, theList);
			}

			theList.add(schedule);
		}

		List<BurdenStructure__c> structures = [select id, CostPlusStructure__c, ExpenditureType__c, CostCode__c from BurdenStructure__c where CostCode__c in :costCodes];

		Set<String> costPlusStructures = new Set<String>();
		Map<String, List<BurdenStructure__c>> structureMap = new Map<String, List<BurdenStructure__c>>();

		for (BurdenStructure__c structure : structures) {
			costPlusStructures.add(structure.CostPlusStructure__c);

			List<BurdenStructure__c> theList = structureMap.get(structure.CostCode__c);

			if (theList == null) {
				theList = new List<BurdenStructure__c>();
				structureMap.put(structure.CostCode__c, theList);
			}

			theList.add(structure);
		}

		List<BurdenSchedule__c> schedules2 = [select id, OracleRateScheduleName__c, CostPlusStructure__c, OrgId__c from BurdenSchedule__c where CostPlusStructure__c in :costPlusStructures and (OracleRateScheduleName__c like '%Home Office%' or OracleRateScheduleName__c like '%Field Office%') and OrgId__c in :orgIds];

		Map<String, List<BurdenSchedule__c>> rateNameMap = new Map<String, List<BurdenSchedule__c>>();

		for (BurdenSchedule__c schedule : schedules2) {
			List<BurdenSchedule__c> theList = rateNameMap.get(schedule.CostPlusStructure__c);

			if (theList == null) {
				theList = new List<BurdenSchedule__c>();
				rateNameMap.put(schedule.CostPlusStructure__c, theList);
			}

			theList.add(schedule);
		}

		for (BudgetResource__c resource : brNew) {
			System.debug('processing resource - ' + resource);

			String expenditureType = expenditureMap.get(resource.Resource__c);

			System.debug('expenditureType - ' + expenditureType);

			if (expenditureType == null)
				continue;

			String orgId = orgMap.get(resource.BudgetHeader__c);

			System.debug('orgId - ' + orgId);

			if (orgId == null)
				continue;

			List<BurdenSchedule__c> codeList = costCodeMap.get(orgId);

			if (codeList == null)
				continue;

			System.debug('codeList size - ' + codeList.size());

			for (BurdenSchedule__c schedule : codeList) {
				System.debug('schedule - ' + schedule);

				System.debug('multiplier - ' + schedule.multiplier__c);

				String code = schedule.CostCode__c;

				System.debug('costCode - ' + code);

				if (code == null)
					continue;

				List<BurdenStructure__c> burdenStructureList = structureMap.get(code);

				if (burdenStructureList == null)
					continue;

				System.debug('burdenStructureList size - ' + burdenStructureList.size());	

				for (BurdenStructure__c structure : burdenStructureList) {
					if (structure.ExpenditureType__c != expenditureType)
						continue;

					System.debug('burdenStructure - ' + structure);

					System.debug('expenditureType matched - ' + expenditureType);

					if (structure.CostPlusStructure__c == null)
						continue;

					List<BurdenSchedule__c> rateNames = rateNameMap.get(structure.CostPlusStructure__c);

					if (rateNames == null)
						continue;

					System.debug('rateNames size - ' + rateNames.size());	

					for (BurdenSchedule__c schedule2 : rateNames) {
						if (schedule2.OrgId__c != orgId)
							continue;

						String rateName = schedule2.OracleRateScheduleName__c;

						if (rateName != schedule.OracleRateScheduleName__c)
							continue;

						System.debug('rateName - ' + rateName);

						if (rateName.containsIgnoreCase('Home Office')) {
							if (code.containsIgnoreCase('fringe')) {
								if (resource.OverrideFringeMultiplier__c == null) {
									resource.OverrideFringeMultiplier__c = schedule.Multiplier__c;

									System.debug('set home office/fringe to ' + schedule.Multiplier__c);
								} else if (resource.OverrideFringeMultiplier__c != schedule.Multiplier__c) {
									throw new ECO_BurdenMultiplierException('duplicate home office/fringe - ' + resource.OverrideFringeMultiplier__c);
								}
							} else if (code.containsIgnoreCase('overhead')) {
								if (resource.OverrideOverheadMultiplier__c == null) {
									resource.OverrideOverheadMultiplier__c = schedule.Multiplier__c;

									System.debug('set home office/overhead to ' + schedule.Multiplier__c);
								} else if (resource.OverrideOverheadMultiplier__c != schedule.Multiplier__c) {
									throw new ECO_BurdenMultiplierException('duplicate home office/overhead - ' + resource.OverrideOverheadMultiplier__c);
								}
							}
						} else if (rateName.containsIgnoreCase('Field Office')) {
							if (code.containsIgnoreCase('fringe')) {
								if (resource.OverrideFringeMultiplierField__c == null) {
									resource.OverrideFringeMultiplierField__c = schedule.Multiplier__c;

									System.debug('set field office/fringe to ' + schedule.Multiplier__c);
								} else if (resource.OverrideFringeMultiplierField__c != schedule.Multiplier__c) {
									throw new ECO_BurdenMultiplierException('duplicate field office/fringe - ' + resource.OverrideFringeMultiplierField__c);
								}
							} else if (code.containsIgnoreCase('overhead')) {
								if (resource.OverrideOverheadMultiplierField__c == null) {
									resource.OverrideOverheadMultiplierField__c = schedule.Multiplier__c;

									System.debug('set field office/overhead to ' + schedule.Multiplier__c);
								} else if (resource.OverrideOverheadMultiplierField__c != schedule.Multiplier__c) {
									throw new ECO_BurdenMultiplierException('duplicate field office/overhead - ' + resource.OverrideOverheadMultiplierField__c);
								}
							}
						}
					}
				}	
			}	
		}
	}
}