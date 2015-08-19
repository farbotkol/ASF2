public without sharing class ECO_Service_Actuals {
	public class ActualsHolder {
		public ActualsHolder () {
			totalCostLabor = 0;
			totalCostSubs = 0;
			totalCostFees = 0;
			totalCostContingency = 0;
			totalRevenue = 0;
			totalCost = 0;
			taskTotalMap = new Map<Id, Decimal>();
			taskPerTypeTotalMap = new Map<Id, PerTaskActualsHolder>();
		}
		public Decimal totalCost {get;set;}
		public Decimal totalCostLabor {get;set;}
		public Decimal totalCostSubs {get;set;}
		public Decimal totalCostFees {get;set;}
		public Decimal totalCostContingency {get;set;}
		public Decimal totalRevenue {get;set;}
		
		public Map<Id, Decimal> taskTotalMap {get;set;}
		public Map<Id, PerTaskActualsHolder> taskPerTypeTotalMap {get;set;}
	}
	
	public class PerTaskActualsHolder {
		public PerTaskActualsHolder () {
			totalCostLabor = 0;
			totalCostSubs = 0;
			totalCostFees = 0;
			totalCostContingency = 0;
		}
		public Decimal totalCostLabor {get;set;}
		public Decimal totalCostSubs {get;set;}
		public Decimal totalCostFees {get;set;}
		public Decimal totalCostContingency {get;set;}
	}
	
	public static ActualsHolder getActualsForProjectId (Id projectId) {
		ActualsHolder returnHolder = new ActualsHolder();
		
		List<AggregateResult> totalRevenue = [SELECT SUM(Amount__c) totalAmount
											FROM Revenue__c 
											WHERE ProjectNumber__c = :projectId];
											
		returnHolder.totalRevenue = (Decimal)totalRevenue[0].get('totalAmount');
		
		if (returnHolder.totalRevenue == null) {
			returnHolder.totalRevenue = 0;
		}
		
		system.debug('this Project number:  '+projectId);
		
		List<AggregateResult> totalActualCosts = [SELECT ExpenditureItemID__r.ExpenditureType__c 
														, TaskNumber__c
														, SUM(AcctRawCost__c) totalCost
												FROM CostDistributionLine__c
												WHERE ProjectNumber__c = :projectId
													AND (
														ExpenditureItemID__r.ExpenditureType__c LIKE 'LAB%'
														OR ExpenditureItemID__r.ExpenditureType__c LIKE 'FEE%'
														OR ExpenditureItemID__r.ExpenditureType__c LIKE 'SUB%'
														OR ExpenditureItemID__r.ExpenditureType__c LIKE 'CON%'
													)
												GROUP BY ROLLUP (ExpenditureItemID__r.ExpenditureType__c
																, TaskNumber__c)];
		
		for (AggregateResult ar : totalActualCosts) {
			
			system.debug('Summing this AR:  '+ar);
			
			Decimal amount = (Decimal)ar.get('totalCost');
			
			String expenditureType = (String)ar.get('ExpenditureType__c');
			Id projectTaskId = (Id)ar.get('TaskNumber__c');
			
			if (expenditureType == null || projectTaskId == null) {
				system.debug('Breaking out:  '+ar);
				continue;  // This avoids us using the subtotal/total lines
			}
			
			if (!returnHolder.taskTotalMap.keySet().contains(projectTaskId) 
				&& projectTaskId != null) {
					returnHolder.taskTotalMap.put(projectTaskId, 0);
					returnHolder.taskPerTypeTotalMap.put(projectTaskId, new PerTaskActualsHolder());
			}
			
			returnHolder.taskTotalMap.put(projectTaskId, returnHolder.taskTotalMap.get(projectTaskId) + amount);
			
			if (expenditureType.toUpperCase().startsWith('LAB')) {
				returnHolder.totalCostLabor += amount;
				returnHolder.taskPerTypeTotalMap.get(projectTaskId).totalCostLabor += amount;
			} else if (expenditureType.toUpperCase().startsWith('SUB')) {
				returnHolder.totalCostSubs += amount;
				returnHolder.taskPerTypeTotalMap.get(projectTaskId).totalCostSubs += amount;
			} else if (expenditureType.toUpperCase().startsWith('FEE')) {
				returnHolder.totalCostFees += amount;
				returnHolder.taskPerTypeTotalMap.get(projectTaskId).totalCostFees += amount;
			} else { // Contingency
				returnHolder.totalCostContingency += amount;
				returnHolder.taskPerTypeTotalMap.get(projectTaskId).totalCostContingency += amount;
			}
			
			returnHolder.totalCost += amount;
		}
		
		return returnHolder;
	}
}