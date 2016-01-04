public without sharing class ECO_BudgetResourceTriggers {
	public static Boolean run = true;
	
    public static Boolean areRatesEqual(BudgetResource__c oBudgetResource, BudgetAssignment__c oBudgetAssignment) {
		if (oBudgetAssignment.OverrideRawCost__c != oBudgetResource.OverrideRawCost__c) return false;
        if (oBudgetAssignment.OverrideFringeMultiplier__c != oBudgetResource.OverrideFringeMultiplier__c) return false;
        if (oBudgetAssignment.OverrideOverheadMultiplier__c != oBudgetResource.OverrideOverheadMultiplier__c) return false;
        if (oBudgetAssignment.OverrideUplift__c != oBudgetResource.OverrideUplift__c) return false;
        if (oBudgetAssignment.MarginType__c != oBudgetResource.MarginType__c) return false;
        if (oBudgetAssignment.OverrideBillRate__c != oBudgetResource.OverrideBillRate__c) return false;
        if (oBudgetAssignment.OverrideFringeMultiplierField__c != oBudgetResource.OverrideFringeMultiplierField__c) return false;
        if (oBudgetAssignment.OverrideOverheadMultiplierField__c != oBudgetResource.OverrideOverheadMultiplierField__c) return false;
        return true;
    }

    public static BudgetAssignment__c setRatesEqual(BudgetResource__c oBudgetResource, BudgetAssignment__c oBudgetAssignment) {
    	if (oBudgetResource.OverrideRatesOnLines__c) {
	    	oBudgetAssignment.OverrideRawCost__c = oBudgetResource.OverrideRawCost__c;
	        oBudgetAssignment.OverrideFringeMultiplier__c = oBudgetResource.OverrideFringeMultiplier__c;
	        oBudgetAssignment.OverrideOverheadMultiplier__c = oBudgetResource.OverrideOverheadMultiplier__c;
	        oBudgetAssignment.OverrideFringeMultiplierField__c = oBudgetResource.OverrideFringeMultiplierField__c;
	        oBudgetAssignment.OverrideOverheadMultiplierField__c = oBudgetResource.OverrideOverheadMultiplierField__c;
	        
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
        														OverrideFringeMultiplierField__c,
        														OverrideOverheadMultiplierField__c,
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
				
				if (br.OverrideRawCost__c == null) {
					br.OverrideRawCost__c = thisResource.Contact__r.pse__Default_Cost_Rate__c;
				}
				
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

	public static void setCurrency(List<BudgetResource__c> brNew) {
    	if (!run) {
    		return;
    	}
		
		Set<Id> bhIds = new Set<Id>();
		Map<Id, String> mapCurrencies = new Map<Id, String>();

		for (BudgetResource__c br : brNew) {
			bhIds.add(br.BudgetHeader__c);
		}   
		 	
    	// Get project currency
        for (BudgetHeader__c budgetHeader : [Select Id, Project__r.ProjectFunctionalCurrencyCode__c From BudgetHeader__c Where Id In :bhIds]) {
        	mapCurrencies.put(budgetHeader.Id, budgetHeader.Project__r.ProjectFunctionalCurrencyCode__c);
        }

        for (BudgetResource__c br : brNew) {
        	br.CurrencyIsoCode = mapCurrencies.get(br.BudgetHeader__c);
        }
    }

	public static void calculateMultiplier(List<BudgetResource__c> brNew) {
		if (!run) {
			return;
		}

		// ALERT - this table currently has 55 entries and it's easier to load the whole thing than to try and map
		// by OU ID, but if the table gets a lot bigger, or if there are dupes between orgs, then the mapping will have
		// to happen

		List<BurdenReference__c> references = [select id, Home_Field__c, Schedule__c from BurdenReference__c];

		Map<String, Set<String>> referenceMap = new Map<String, Set<String>>();

		for (BurdenReference__c reference : references) {
			Set<String> newSet = referenceMap.get(reference.Schedule__c);

			if (newSet == null) {
				newSet = new Set<String>();
				referenceMap.put(reference.Schedule__c, newSet);
			}

			newSet.add(reference.Home_Field__c);

			System.debug('referenceMap - ' + reference.id + ' - ' + reference.Schedule__c + ' - ' + reference.Home_Field__c);
		}

		Set<Id> resourceIds = new Set<Id>();
		Set<Id> headerIds = new Set<Id>();

		for (BudgetResource__c br : brNew) {
			resourceIds.add(br.Resource__c);
			headerIds.add(br.BudgetHeader__c);
		}

		List<Contact> resources = [select id, User__c, User__r.ExpenditureType__c, User__r.ECO_OUID__c, OrganizationString__r.OrgID__c from Contact where id in :resourceIds];

		Set<Id> userIds = new Set<Id>();

		for (Contact con : resources) {
			if ((con.User__r.ECO_OUID__c == null) || (con.User__r.ECO_OUID__c.trim().equals(''))) {
				userIds.add(con.User__c);
			}
		}

		if (userIds.size() > 0) {
			List<User> updateUsers = [select id, ECO_OrganizationName__c from User where id in :userIds];
			
			update updateUsers;

			resources = [select id, User__c, User__r.ExpenditureType__c, User__r.ECO_OUID__c, OrganizationString__r.OrgID__c from Contact where id in :resourceIds];
		}

		Map<Id, String> expenditureMap = new Map<Id, String>();

		Set<String> orgIds = new Set<String>();
		Set<String> needed = new Set<String>();

		Map<Id, String> contactOrgMap = new Map<Id, String>();
		Map<Id, String> contactOUIdMap = new Map<Id, String>();

		for (Contact resource : resources) {
			expenditureMap.put(resource.id, resource.User__r.ExpenditureType__c);
			orgIds.add(resource.OrganizationString__r.OrgID__c);
			needed.add(resource.OrganizationString__r.OrgID__c);
			contactOrgMap.put(resource.id, resource.OrganizationString__r.OrgID__c);
			contactOUIdMap.put(resource.id, resource.User__r.ECO_OUID__c);
		}

		List<BudgetHeader__c> headers = [select id, Project__r.CarryingOutOrganization__r.OrgId__c, Project__r.CarryingOutOrganization__r.OUID__c from BudgetHeader__c where id in :headerIds];

		Map<Id, String> orgMap = new Map<Id, String>();
		Map<Id, String> ouIdMap = new Map<Id, String>();
		Map<String, String> parentMap = new Map<String, String>();

		for (BudgetHeader__c header : headers) {
			orgIds.add(header.Project__r.CarryingOutOrganization__r.OrgId__c);
			needed.add(header.Project__r.CarryingOutOrganization__r.OrgId__c);
			orgMap.put(header.id, header.Project__r.CarryingOutOrganization__r.OrgId__c);
			ouIdMap.put(header.id, header.Project__r.CarryingOutOrganization__r.OUID__c);
		}

		List<Burden_Org_Hierarchy__c> hierarchy = [select organization_id__c, parent_organization_id__c from burden_org_hierarchy__c where organization_id__c in :needed];

		while (hierarchy.size() > 0) {
			needed = new Set<String>();

			for (Burden_Org_Hierarchy__c level : hierarchy) {
				System.debug('here - ' + level.organization_id__c + ' - ' + level.parent_organization_id__c);

				orgIds.add(level.organization_id__c);

				if (level.parent_organization_id__c != null) {
					needed.add(level.parent_organization_id__c);

					parentMap.put(level.organization_id__c, level.parent_organization_id__c);

					System.debug('putting parent map - ' + level.organization_id__c + ' - ' + level.parent_organization_id__c);
				}
			}

			hierarchy = [select organization_id__c, parent_organization_id__c from burden_org_hierarchy__c where organization_id__c in :needed and organization_id__c not in :orgIds];
		}

		orgIds.addAll(needed);

		List<BurdenSchedule__c> schedules = [select id, OracleRateScheduleName__c, CostCode__c, Multiplier__c, OrgId__c from BurdenSchedule__c where OrgId__c in :orgIds and ((EffectiveFromDate__c = null) or (EffectiveFromDate__c <= TODAY)) and ((EffectiveToDate__c = null) or (EffectiveToDate__c >= TODAY))];

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

		List<BurdenStructure__c> structures = [select id, CostPlusStructure__c, ExpenditureType__c, CostCode__c from BurdenStructure__c where CostCode__c in :costCodes and CostPlusStructure__c != null];

		Set<String> costPlusStructures = new Set<String>();

		Map<String, List<BurdenStructure__c>> structureMap = new Map<String, List<BurdenStructure__c>>();

		for (BurdenStructure__c structure : structures) {
			costPlusStructures.add(structure.CostPlusStructure__c);

			String key = structure.CostCode__c + '~' + structure.ExpenditureType__c;

			List<BurdenStructure__c> theList = structureMap.get(key);

			if (theList == null) {
				theList = new List<BurdenStructure__c>();
				structureMap.put(key, theList);
			}

			theList.add(structure);
		}

		List<BurdenSchedule__c> schedules2 = [select id, OracleRateScheduleName__c, CostPlusStructure__c, OrgId__c from BurdenSchedule__c where CostPlusStructure__c in :costPlusStructures and OrgId__c in :orgIds];


		Map<String, List<BurdenSchedule__c>> rateNameMap = new Map<String, List<BurdenSchedule__c>>();

		for (BurdenSchedule__c schedule : schedules2) {
			String key = schedule.CostPlusStructure__c + '~' + schedule.OracleRateScheduleName__c + '~' + schedule.OrgId__c;

			List<BurdenSchedule__c> theList = rateNameMap.get(key);

			if (theList == null) {
				theList = new List<BurdenSchedule__c>();
				rateNameMap.put(key, theList);
			}

			theList.add(schedule);
		}		

		for (BudgetResource__c resource : brNew) {
			System.debug('processing resource - ' + resource);

			String expenditureType = expenditureMap.get(resource.Resource__c);

			System.debug('expenditureType - ' + expenditureType);

			if (expenditureType == null)
				continue;

			Decimal OverrideFringeMultiplier = null;
			Decimal OverrideOverheadMultiplier = null;
			Decimal OverrideFringeMultiplierField = null;
			Decimal OverrideOverheadMultiplierField = null; 	

			String headerOuID = ouIdMap.get(resource.BudgetHeader__c);
			String contactOuID = contactOUIdMap.get(resource.Resource__c);

			String orgId = null;

			if (headerOuID == null)
				throw new ECO_BurdenMultiplierException('Missing Header OU ID' + resource.BudgetHeader__c);

			if (contactOuID == null)
				throw new ECO_BurdenMultiplierException('Missing Contact OU ID' + resource.Resource__c);

			if (headerOuID.equals(contactOuID)) {
				orgId = orgMap.get(resource.BudgetHeader__c);
			} else {
				orgId = contactOrgMap.get(resource.Resource__c);
				System.debug('*** cross-charging *** -- ' + headerOuID + ' - ' + contactOuID + ' - ' + orgId);
			}

			while ((OverrideFringeMultiplier == null) || (OverrideOverheadMultiplier == null) || (OverrideFringeMultiplierField == null) || (OverrideOverheadMultiplierField == null)) {
				if (orgId == null)
					break;

				List<BurdenSchedule__c> codeList = costCodeMap.get(orgId);

				if (codeList == null) {
					orgId = parentMap.get(orgId);
					System.debug('no code list found - going to parent - ' + orgId);

					continue;
				}

				System.debug('codeList size - ' + codeList.size());

				for (BurdenSchedule__c schedule : codeList) {
					if ((OverrideFringeMultiplier != null) && (OverrideOverheadMultiplier != null) && (OverrideFringeMultiplierField != null) && (OverrideOverheadMultiplierField != null))
						break;

					String code = schedule.CostCode__c;

					if (code == null) 
						continue;

					String key2 = code + '~' + expenditureType;

					List<BurdenStructure__c> burdenStructureList = structureMap.get(key2);

					if (burdenStructureList == null)
						continue;

					System.debug('burdenStructureList size  - ' + burdenStructureList.size());	

					for (BurdenStructure__c structure : burdenStructureList) {
						if ((OverrideFringeMultiplier != null) && (OverrideOverheadMultiplier != null) && (OverrideFringeMultiplierField != null) && (OverrideOverheadMultiplierField != null))
							break;

						String key1 = structure.CostPlusStructure__c + '~' + schedule.OracleRateScheduleName__c + '~' + orgId;

						List<BurdenSchedule__c> rateNames = rateNameMap.get(key1);

						if (rateNames == null)
							continue;

						System.debug('rateNames size - ' + rateNames.size());

						for (BurdenSchedule__c schedule2 : rateNames) {
							if ((OverrideFringeMultiplier != null) && (OverrideOverheadMultiplier != null) && (OverrideFringeMultiplierField != null) && (OverrideOverheadMultiplierField != null))
								break;

							String rateName = schedule2.OracleRateScheduleName__c;

							Set<String> rateNameLookup = referenceMap.get(rateName);

							if (rateNameLookup == null)
								continue;

							Boolean foundOne = false;

							if (rateNameLookup.contains('HOME_OFFICE')) {
								if (code.containsIgnoreCase('fringe')) {
									if (OverrideFringeMultiplier == null) {
										OverrideFringeMultiplier = schedule.Multiplier__c;

										System.debug('set home office/fringe to ' + schedule.Multiplier__c);
										foundOne = true;
									}
								} else if (code.containsIgnoreCase('overhead')) {
									if (OverrideOverheadMultiplier == null) {
										OverrideOverheadMultiplier = schedule.Multiplier__c;

										System.debug('set home office/overhead to ' + schedule.Multiplier__c);
										foundOne = true;
									}
								}
							}

							if (rateNameLookup.contains('FIELD_OFFICE')) {
								if (code.containsIgnoreCase('fringe')) {
									if (OverrideFringeMultiplierField == null) {
										OverrideFringeMultiplierField = schedule.Multiplier__c;

										System.debug('set field office/fringe to ' + schedule.Multiplier__c);
										foundOne = true;
									}
								} else if (code.containsIgnoreCase('overhead')) {
									if (OverrideOverheadMultiplierField == null) {
										OverrideOverheadMultiplierField = schedule.Multiplier__c;

										System.debug('set field office/overhead to ' + schedule.Multiplier__c);
										foundOne = true;
									}
								}
							}

							if (foundOne) {
								System.debug('orgId - ' + orgId);
								System.debug('schedule - ' + schedule);
								System.debug('multiplier - ' + schedule.multiplier__c);
								System.debug('costCode - ' + code);
								System.debug('expenditureType matched - ' + expenditureType);
								System.debug('burdenStructure - ' + structure);
								System.debug('rateNames size - ' + rateNames.size());	
								System.debug('rateName - ' + rateName);
								System.debug('ratenamelookup - ' + rateNameLookup);
							}
						}
					}	
				}

				String oldOrgId = orgId;

				orgId = parentMap.get(orgId);

				if (orgId == null) {
					break;
				}

				if (orgId.equals(oldOrgId)) {
					System.debug('not right - the same parent and child - ' + orgId);

					break;
				}
			}	

			resource.OverrideFringeMultiplier__c = (OverrideFringeMultiplier == null) ? null : 100.0 * OverrideFringeMultiplier;
			resource.OverrideOverheadMultiplier__c = (OverrideOverheadMultiplier == null) ? null : 100.0 * OverrideOverheadMultiplier;
			resource.OverrideFringeMultiplierField__c = (OverrideFringeMultiplierField == null) ? null : 100.0 * OverrideFringeMultiplierField;
			resource.OverrideOverheadMultiplierField__c = (OverrideOverheadMultiplierField == null) ? null : 100.0 * OverrideOverheadMultiplierField;
		}
	}
}