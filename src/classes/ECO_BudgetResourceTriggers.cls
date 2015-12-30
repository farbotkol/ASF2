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
        for (BudgetHeader__c budgetHeader : [Select Id, Project__r.CurrencyIsoCode From BudgetHeader__c Where Id In :bhIds]) {
        	mapCurrencies.put(budgetHeader.Id, budgetHeader.Project__r.CurrencyIsoCode);
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

		Map<String, String> referenceMap = new Map<String, String>();

		for (BurdenReference__c reference : references) {
			referenceMap.put(reference.Schedule__c, reference.Home_Field__c);
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
		Set<String> needed = new Set<String>();
		Map<Id, String> orgMap = new Map<Id, String>();
		Map<String, String> parentMap = new Map<String, String>();

		for (BudgetHeader__c header : headers) {
			orgIds.add(header.Project__r.CarryingOutOrganization__r.OrgId__c);
			needed.add(header.Project__r.CarryingOutOrganization__r.OrgId__c);
			orgMap.put(header.id, header.Project__r.CarryingOutOrganization__r.OrgId__c);
		}

		List<Burden_Org_Hierarchy__c> hierarchy = [select organization_id__c, parent_organization_id__c from burden_org_hierarchy__c where organization_id__c in :needed];

		while (hierarchy.size() > 0) {
			needed = new Set<String>();

			for (Burden_Org_Hierarchy__c level : hierarchy) {
				orgIds.add(level.organization_id__c);

				if (level.parent_organization_id__c != null) {
					needed.add(level.parent_organization_id__c);

					parentMap.put(level.organization_id__c, level.parent_organization_id__c);

					System.debug('putting parent map - ' + level.organization_id__c + ' - ' + level.parent_organization_id__c);
				}
			}

			hierarchy = [select organization_id__c, parent_organization_id__c from burden_org_hierarchy__c where organization_id__c in :needed and organization_id__c not in :orgIds];
		}

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

		List<BurdenSchedule__c> schedules2 = [select id, OracleRateScheduleName__c, CostPlusStructure__c, OrgId__c from BurdenSchedule__c where CostPlusStructure__c in :costPlusStructures and OrgId__c in :orgIds];

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

			Decimal OverrideFringeMultiplier = null;
			Decimal OverrideOverheadMultiplier = null;
			Decimal OverrideFringeMultiplierField = null;
			Decimal OverrideOverheadMultiplierField = null; 	

			String orgId = orgMap.get(resource.BudgetHeader__c);

			while ((OverrideFringeMultiplier == null) || (OverrideOverheadMultiplier == null) || (OverrideFringeMultiplierField == null) || (OverrideOverheadMultiplierField == null)) {
				System.debug('orgId - ' + orgId);

				if (orgId == null)
					break;

				List<BurdenSchedule__c> codeList = costCodeMap.get(orgId);

				if (codeList == null) {
					orgId = parentMap.get(orgId);

					continue;
				}

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

					System.debug('burdenStructureList size  - ' + burdenStructureList.size());	

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

							String rateNameLookup = referenceMap.get(rateName);

							System.debug('ratenamelookup - ' + rateNameLookup);

							if (rateNameLookup == null)
								continue;

							if (rateNameLookup.equals('HOME_OFFICE')) {
								if (code.containsIgnoreCase('fringe')) {
									if (OverrideFringeMultiplier == null) {
										OverrideFringeMultiplier = schedule.Multiplier__c;

										System.debug('set home office/fringe to ' + schedule.Multiplier__c);
									}
								} else if (code.containsIgnoreCase('overhead')) {
									if (OverrideOverheadMultiplier == null) {
										OverrideOverheadMultiplier = schedule.Multiplier__c;

										System.debug('set home office/overhead to ' + schedule.Multiplier__c);
									}
								}
							} else if (rateNameLookup.equals('FIELD_OFFICE')) {
								if (code.containsIgnoreCase('fringe')) {
									if (OverrideFringeMultiplierField == null) {
										OverrideFringeMultiplierField = schedule.Multiplier__c;

										System.debug('set field office/fringe to ' + schedule.Multiplier__c);
									}
								} else if (code.containsIgnoreCase('overhead')) {
									if (OverrideOverheadMultiplierField == null) {
										OverrideOverheadMultiplierField = schedule.Multiplier__c;

										System.debug('set field office/overhead to ' + schedule.Multiplier__c);
									}
								}
							}
						}
					}	
				}

				String oldOrgId = orgId;

				orgId = parentMap.get(orgId);

				if (orgId.equals(oldOrgId)) {
					System.debug('not right - the same parent and child - ' + orgId);

					break;
				}
			}	

			OverrideFringeMultiplier = OverrideFringeMultiplier == null ? null : 100 * OverrideFringeMultiplier;
			OverrideOverheadMultiplier = OverrideOverheadMultiplier == null ? null : 100 * OverrideOverheadMultiplier;
			OverrideFringeMultiplierField = OverrideFringeMultiplierField == null ? null : 100 * OverrideFringeMultiplierField;
			OverrideOverheadMultiplierField = OverrideOverheadMultiplierField == null ? null : 100 * OverrideOverheadMultiplierField;
			
			resource.OverrideFringeMultiplier__c = OverrideFringeMultiplier;
			resource.OverrideOverheadMultiplier__c = OverrideOverheadMultiplier;
			resource.OverrideFringeMultiplierField__c = OverrideFringeMultiplierField;
			resource.OverrideOverheadMultiplierField__c = OverrideOverheadMultiplierField;
		}
	}

	public static void calculateMultiplierOld(List<BudgetResource__c> brNew) {
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

				System.debug('burdenStructureList size  - ' + burdenStructureList.size());	

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