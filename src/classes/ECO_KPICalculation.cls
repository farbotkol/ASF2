public without sharing class ECO_KPICalculation {

	private static Decimal thisPeriodRevenue;
	private static Decimal lastPeriodRevenue;
	private static Decimal thisPeriodNetMargin;
	private static Decimal lastPeriodNetMargin;
	
	public CalculationHolder getProjectHealthCalculations(Id theProjectId) {
		return getProjectHealthCalculations(theProjectId, Date.today());
	}
	
	public static CalculationHolder getProjectHealthCalculations(Id theProjectId, date asOfDate) {
		CalculationHolder returnCalcs = new CalculationHolder();
		pse__Proj__c theProject = ECO_Service_Projects.getProjectById(theProjectId);

		returnCalcs.isPMCertified = calculatePMCetified(theProject);
		returnCalcs.isScheduledEndDateInPast = calculateScheduledEndDateInThePast(theProject, asOfDate);
		returnCalcs.averageActualLaborRate = calculateAverageActualLaborRate(theProject, asOfDate);
		returnCalcs.approvedBudgetLaborRate = calculateApprovedBudgetLaborRate(theProject);
		returnCalcs.CPI = calculateCPI(theProject);
		returnCalcs.SPI = calculateSPI(theProject);
		returnCalcs.EAC = theProject.TotalForecastCost__c;
		returnCalcs.costSoFar = calculateCostSoFar(theProject, asOfDate);
		returnCalcs.ETC = calculateETC(theProject, asOfdate, returnCalcs.costSoFar);
		returnCalcs.etcRunRate = calculateETCRunRate(theProject, asOfdate, returnCalcs.costSoFar);
		returnCalcs.lastEACUpdateInDays = calculateNumberOfDaysSinceLastEACUpdate(theProject, asOfDate);
		returnCalcs.laborIncreaseOverPriorMonthMoreThan30Percent = calculateLaborIncreaseOverPriorMonthMoreThan30Percent(theProject, asOfDate);
		returnCalcs.actualVSPlannedMarginVarianceFromPriorMonth = calculateActualVersusPlannedMarginVariance(theProject, asOfDate);

		returnCalcs.negativeNetMargin = theProject.CurrentForecastCostBudget__c - theProject.CurrentForecastRevenueBudget__c;
		if(theProject.TotalApprovedRevenue__c == null)
			returnCalcs.approvedBudgetGrossRevenue = 0;
		else
			returnCalcs.approvedBudgetGrossRevenue = theProject.TotalApprovedRevenue__c;
		returnCalcs.contractValue = calculateContractValue(theProject); 
		returnCalcs.hasProjectPlan = calculateHasProjectPlan(theProject);

		//needs calculation
		returnCalcs.lastMonthNetMarginLessThanPrecedingMonth = false;
		returnCalcs.lastMonthNetMarginLessThanPrecedingMonth = false;
		returnCalcs.unBilledAmount60Days = calculateUnBillAmount60Days(theProject, asOfDate);
		returnCalcs.arGreaterThan90Days = calculateARGreaterThan90Days(theProject, asOfDate);

		return returnCalcs;
	}

	private static Boolean calculateUnBillAmount60Days(pse__Proj__c project, Date asOfDate )
	{
		Decimal totalBilled = 0;
		for(AggregateResult ar: [select SUM(InvoiceAmount__c) totalBilled
						from Billing__c where ProjectNumber__c = :project.Id])
		{
			if(ar.get('totalBilled') != null)
			{
				if((Decimal)ar.get('totalBilled') != null)
					totalBilled = (Decimal)ar.get('totalBilled');
			}
		}
		Date startDate = asOfDate.addDays(-60);

		for(AggregateResult ar:[select sum(Amount__c) totalRevenue from Revenue__c where ProjectNumber__c = :project.Id 
												and  GLDate__c < :startDate])
		{
			if((Decimal)ar.get('totalRevenue') != null)
				return (((Decimal)ar.get('totalRevenue') - totalBilled)) > 0 ? true: false ;
			else
				return false;
		}
		return false;
	}

	private static Boolean calculateARGreaterThan90Days(pse__Proj__c project, Date asOfDate)
	{
		list<Billing__c> billings = [select Id from Billing__c where ProjectNumber__c = :project.Id and
									InvoiceDate__c > :asOfdate.addDays(-90)];
		if(billings.isEmpty())
			return true;

		return false;
	}

	private static Boolean calculateHasProjectPlan(pse__Proj__c project)
	{
		if(project.ProgBarPrelimPlanApproval__c != 'Complete')
			return false;

		return true;
	}

	private static Decimal calculateContractValue(pse__Proj__c project)
	{
		List<AggregateResult> contractValues = [SELECT SUM(Amount__c) totalAmount
												FROM Agreement__c
												WHERE Project__c = :project.Id];

		if(!contractValues.isEmpty())
		{
			if(contractValues[0].get('totalAmount') != null)
				return (Decimal)contractValues[0].get('totalAmount');
		}

		return 0;
	}

	private static Decimal calculateLastMonthUnBilledAmountMoreThanZero(pse__Proj__c project, Date asOfDate)
	{
		List<AggregateResult> actualRevenueResultsSinceInception = [SELECT SUM(Amount__c) totalAmount
																	FROM Revenue__c
																	WHERE ProjectNumber__c = :project.Id
																		AND GLDate__c <= :asOfDate];
																		
		List<AggregateResult> billedAmount = [SELECT SUM(InvoiceAmount__c) totalAmount
												FROM Billing__c
												WHERE ProjectNumber__c = :project.Id
													AND InvoiceDate__c <= :asOfDate];
													
		Decimal unBilledAmount;
		if(!actualRevenueResultsSinceInception.isEmpty() && !billedAmount.isEmpty())
		{
			if(actualRevenueResultsSinceInception[0].get('totalAmount') != null && billedAmount[0].get('totalAmount') != null)
			{
				return (Decimal)actualRevenueResultsSinceInception[0].get('totalAmount') - (Decimal)billedAmount[0].get('totalAmount');
			}
		}
		
		return 0;
	}

	private static boolean calculatePMCetified(pse__Proj__c project)
	{
		User theProjectManager = ECO_Service_Users.getUserInfoById(project.OwnerId);

		if(theProjectManager.Certified_PM__c == 'Yes'){
			return true;
		}
		return false;
	}

	private static boolean calculateScheduledEndDateInThePast(pse__Proj__c project, Date asOfDate)
	{

		if(project.pse__End_Date__c != null)
		{
			return (asOfDate >=  project.pse__End_Date__c) ? true : false;
		}
		return true;
	}

	private static Decimal calculateAverageActualLaborRate(pse__Proj__c project, Date asOfDate)
	{
		List<AggregateResult> averageActualLaborRate = [SELECT AVG(AcctBurdCostTimesQuantity__c) rate
														FROM CostDistributionLine__c
														WHERE GLDate__c <= :asOfDate
															AND ProjectNumber__c = :project.Id
															AND ExpenditureItemID__r.ExpenditureType__c LIKE 'LAB%'];													
		if(!averageActualLaborRate.isEmpty())
		{
			if((Decimal)averageActualLaborRate[0].get('rate') != null)
				return (Decimal)averageActualLaborRate[0].get('rate');
		}	
		return 0;	
	}

	private static Decimal calculateApprovedBudgetLaborRate(pse__Proj__c project) 
	{
		List<AggregateResult> averageApprovedBudgetLaborRate = [SELECT AVG(FullyBurdenedCostRate__c) rate
																FROM BudgetAssignment__c
																WHERE BudgetResource__r.BudgetHeader__r.Project__c = :project.Id
																	AND BudgetResource__r.ResourceType__c IN ('Labor/Person', 'Subcontractor')
																	AND BudgetResource__r.BudgetHeader__r.Status__c = 'Approved'];															
		if(!averageApprovedBudgetLaborRate.isEmpty())
		{
			if((Decimal)averageApprovedBudgetLaborRate[0].get('rate') != null)
				return (Decimal)averageApprovedBudgetLaborRate[0].get('rate');
		}	
		return 0;	
	}	

	private static Decimal calculateCPI(pse__Proj__c project)
	{
		List<EarnedValueHeader__c> listOfEVRs = [SELECT Id, Project__c, ReportName__c, Comments__c, SnapshotDate__c
										    	FROM EarnedValueHeader__c WHERE Project__c = :project.Id												
    												  AND SnapshotDate__c != null ORDER BY SnapshotDate__c desc];
    												   											
    	if (!listOfEVRs.isEmpty()) {
    		EarnedValueHeader__c existingReport = listOfEVRs.get(0);
    		Date currentSnapshotDate = existingReport.SnapshotDate__c;
    	
			string sCompositeKey = ECO_Service_Snapshots.DateToSnapshotKey(currentSnapshotDate, project.Id);
			List<WeeklyRollupEntry__c> lWeeklyRollupEntry = new List<WeeklyRollupEntry__c>([SELECT Id, CPI__c FROM WeeklyRollupEntry__c WHERE CompositeKey__c = :sCompositeKey]);
			WeeklyRollupEntry__c oWeeklyRollEntry = new WeeklyRollupEntry__c();

			if(!lWeeklyRollupEntry.isEmpty()){
				oWeeklyRollEntry = lWeeklyRollupEntry.get(0);
				return oWeeklyRollEntry.CPI__c; 
			}
		}
		return 0;
	}

	private static Decimal calculateSPI(pse__Proj__c project)
	{
		List<EarnedValueHeader__c> listOfEVRs = [SELECT Id, Project__c, ReportName__c, Comments__c, SnapshotDate__c
										    	FROM EarnedValueHeader__c WHERE Project__c = :project.Id												
    												  AND SnapshotDate__c != null ORDER BY SnapshotDate__c desc];
    												   											
    	if (!listOfEVRs.isEmpty()) {
    		EarnedValueHeader__c existingReport = listOfEVRs.get(0);
    		Date currentSnapshotDate = existingReport.SnapshotDate__c;
    	
			string sCompositeKey = ECO_Service_Snapshots.DateToSnapshotKey(currentSnapshotDate, project.Id);
			List<WeeklyRollupEntry__c> lWeeklyRollupEntry = new List<WeeklyRollupEntry__c>([SELECT Id, SPI__c FROM WeeklyRollupEntry__c WHERE CompositeKey__c = :sCompositeKey]);
			WeeklyRollupEntry__c oWeeklyRollEntry = new WeeklyRollupEntry__c();

			if(!lWeeklyRollupEntry.isEmpty()){
				oWeeklyRollEntry = lWeeklyRollupEntry.get(0);
				return oWeeklyRollEntry.SPI__c; 
			}
		}
		return 0;
	}	

	private static Decimal calculateNumberOfDaysSinceLastEACUpdate(pse__Proj__c project, Date asOfDate)
	{
		Set<Id> budgetHeaderIds = new Set<Id>();
		for (BudgetHeader__c bh : project.BudgetHeaders__r) {
			budgetHeaderIds.add(bh.Id);
		}
		
		List<ProcessInstance> processInstanceList = [SELECT Id, CompletedDate
													FROM ProcessInstance 
													WHERE TargetObjectId IN :budgetHeaderIds
														AND CompletedDate <= :asOfDate
														AND Status = 'Approved'
													ORDER BY CompletedDate DESC
													LIMIT 1];
													
		if (!processInstanceList.isEmpty()) 
		{
			return processInstanceList[0].CompletedDate.date().daysBetween(asOfDate);
		} 
		return -1;
	}

	private static Decimal calculateCostSoFar(pse__Proj__c project, Date asOfDate)
	{
		List<AggregateResult> actualCost = [SELECT SUM(AcctBurdCostTimesQuantity__c) totalCost
											FROM CostDistributionLine__c
											WHERE GLDate__c <= :asOfDate
												AND ProjectNumber__c = :project.Id];	
		if(!actualCost.isEmpty())
		{
			if(actualCost[0].get('totalCost') != null)
				return (Decimal)actualCost[0].get('totalCost');
		}
		return 0;
	}

	private static Decimal calculateETC(pse__Proj__c project, Date asOfDate, Decimal costSoFar)
	{	
		if(project.TotalForecastCost__c != null)
		{
			return project.TotalForecastCost__c - costSoFar;
		}

		return 0 - costSoFar;
	}

	private static Decimal calculateETCRunRate(pse__Proj__c project, Date asOfDate, Decimal costSoFar)
	{
		return 0;
	}

	private static Boolean calculateLaborIncreaseOverPriorMonthMoreThan30Percent(pse__Proj__c project, Date asOfDate)
	{
		List<String> periodNames = new List<String>();
		periodNames.add(ECO_Utils_Date.getPeriodNameFromDate(asOfDate.addMonths(-1))); // Last Month
		periodNames.add(ECO_Utils_Date.getPeriodNameFromDate(asOfDate.addMonths(-2))); // Month before Last

		List<AggregateResult> laborAmountsPerPeriod = [SELECT GLPeriodName__c
															, SUM(AcctBurdCostTimesQuantity__c) totalAmount
														FROM CostDistributionLine__c
														WHERE GLDate__c <= :asOfDate
															AND ProjectNumber__c = :project.Id
															AND ExpenditureItemID__r.ExpenditureType__c LIKE 'LAB%'
															AND GLPeriodName__c IN :periodNames
														GROUP BY GLPeriodName__c
														ORDER BY GLPeriodName__c];
		
		Decimal thisPeriodLaborAmount;
		Decimal lastPeriodLaborAmount;
		for (AggregateResult ar : laborAmountsPerPeriod) {
			if (periodNames[0].equalsIgnoreCase((String)ar.get('GLPeriodName__c'))) {
				thisPeriodLaborAmount = (Decimal)ar.get('totalAmount');
			}
			
			if (periodNames[1].equalsIgnoreCase((String)ar.get('GLPeriodName__c'))) {
				thisPeriodLaborAmount = (Decimal)ar.get('totalAmount');
			}
		}
				
		if (lastPeriodLaborAmount < thisPeriodLaborAmount) {
			Decimal greaterDifferenceAmount = thisPeriodLaborAmount - lastPeriodLaborAmount;
			if ((greaterDifferenceAmount / lastPeriodLaborAmount) >= .3) {
				return true;
			}
		}		
		
		return false;
	}

	private static Decimal calculateActualVersusPlannedMarginVariance(pse__Proj__c project, Date asOfDate)
	{

		List<String> periodNames = new List<String>();
		periodNames.add(ECO_Utils_Date.getPeriodNameFromDate(asOfDate.addMonths(-1))); // Last Month
		periodNames.add(ECO_Utils_Date.getPeriodNameFromDate(asOfDate.addMonths(-2))); // Month before Last

		List<AggregateResult> actualNetCostResults = [SELECT SUM(AcctBurdCostTimesQuantity__c) totalAmount
															, GLPeriodName__c
													FROM CostDistributionLine__c
													WHERE ProjectNumber__c = :project.Id
														AND GLPeriodName__c = :periodNames
													GROUP BY GLPeriodName__c];
													
		List<AggregateResult> actualRevenueResults = [SELECT SUM(Amount__c) totalAmount
															, GLPeriodName__c
													FROM Revenue__c
													WHERE ProjectNumber__c = :project.Id
														AND GLPeriodName__c IN :periodNames
													GROUP BY GLPeriodName__c];
													
		Decimal thisPeriodNetCost;
		
		Decimal lastPeriodNetCost;
		
		for (AggregateResult ar : actualNetCostResults) {
			if (periodNames[0].equalsIgnoreCase((String)ar.get('GLPeriodName__c'))) {
				thisPeriodNetCost = (Decimal)ar.get('totalAmount');
			} else {
				lastPeriodNetCost = (Decimal)ar.get('totalAmount');
			}
		}
		
		for (AggregateResult ar : actualRevenueResults) {
			if (periodNames[0].equalsIgnoreCase((String)ar.get('GLPeriodName__c'))) {
				thisPeriodRevenue = (Decimal)ar.get('totalAmount');
			} else {
				lastPeriodRevenue = (Decimal)ar.get('totalAmount');
			}
		}
		
		if(thisPeriodRevenue != null && thisPeriodNetCost != null)
		{
			thisPeriodNetMargin = thisPeriodRevenue - thisPeriodNetCost;
		}
		if(lastPeriodRevenue != null && lastPeriodNetCost != null)
		{
			lastPeriodNetMargin = lastPeriodRevenue - lastPeriodNetCost;
		}
		Decimal variance;
		
		if(thisPeriodNetMargin != null && lastPeriodNetMargin != null)
		{
			if (thisPeriodNetMargin >= lastPeriodNetMargin) {
				return lastPeriodNetMargin / thisPeriodNetMargin;
			} else {
				return (-1 * (thisPeriodNetMargin / lastPeriodNetMargin));
			}
		}
		
		return 0;		
	}


	private static void tempMethod(pse__Proj__c theProject, Date asOfDate, Id theProjectId, Decimal costSoFar)
	{

		CalculationHolder returnCalcs;
// Geo Threshold
		
		List<GeographyThreshold__c> geoThresholdsList = [SELECT Id 
																, ThresholdAmount__c
														FROM GeographyThreshold__c 
														WHERE Name = :theProject.CarryingOutOrganization__r.GeographyName__c 
														LIMIT 1];
		
		if (!geoThresholdsList.isEmpty()) {
			returnCalcs.geographyThreshold = geoThresholdsList[0].ThresholdAmount__c;
		} else {
			returnCalcs.geographyThreshold = 0;
		}


		

// Labor Increase Over Prior Month More Than 30 Percent?
		
		// This list order will be important later.  We're using it to compare this month to last month.
		List<String> periodNames = new List<String>();
		periodNames.add(ECO_Utils_Date.getPeriodNameFromDate(asOfDate.addMonths(-1))); // Last Month
		periodNames.add(ECO_Utils_Date.getPeriodNameFromDate(asOfDate.addMonths(-2))); // Month before Last

		List<AggregateResult> laborAmountsPerPeriod = [SELECT GLPeriodName__c
															, SUM(AcctBurdCostTimesQuantity__c) totalAmount
														FROM CostDistributionLine__c
														WHERE GLDate__c <= :asOfDate
															AND ProjectNumber__c = :theProjectId
															AND ExpenditureItemID__r.ExpenditureType__c LIKE 'LAB%'
															AND GLPeriodName__c IN :periodNames
														GROUP BY GLPeriodName__c
														ORDER BY GLPeriodName__c];
		
		Decimal thisPeriodLaborAmount;
		Decimal lastPeriodLaborAmount;
		for (AggregateResult ar : laborAmountsPerPeriod) {
			if (periodNames[0].equalsIgnoreCase((String)ar.get('GLPeriodName__c'))) {
				thisPeriodLaborAmount = (Decimal)ar.get('totalAmount');
			}
			
			if (periodNames[1].equalsIgnoreCase((String)ar.get('GLPeriodName__c'))) {
				thisPeriodLaborAmount = (Decimal)ar.get('totalAmount');
			}
		}
		
		Boolean riseMoreThan30Percent = false;
		
		if (lastPeriodLaborAmount < thisPeriodLaborAmount) {
			Decimal greaterDifferenceAmount = thisPeriodLaborAmount - lastPeriodLaborAmount;
			if ((greaterDifferenceAmount / lastPeriodLaborAmount) >= .3) {
				riseMoreThan30Percent = true;
			}
		}		
		
		returnCalcs.laborIncreaseOverPriorMonthMoreThan30Percent = riseMoreThan30Percent;

// Project Completed more than 75%

		//Decimal costSoFar;
		//if(!actualCost.isEmpty())
		//{
		//	costSoFar = (Decimal)actualCost[0].get('totalCost');
		//}
		
		Boolean completedMoreThan75Percent = false;
		
		if(costSoFar != null && theProject.TotalForecastCost__c != null)
		{
			if ((costSoFar / theProject.TotalForecastCost__c) >= .75) 
			{
				completedMoreThan75Percent = true;
			}
		}
		
		returnCalcs.projectCompletedMoreThan75Percent = completedMoreThan75Percent;
		
// actual versus planned margin variance from prior month


		
// last month gross margin less than preceding month

		List<AggregateResult> actualGrossCostResults = [SELECT SUM(AcctRawCostTimesQuantity__c) totalAmount
															, GLPeriodName__c
													FROM CostDistributionLine__c
													WHERE ProjectNumber__c = :theProjectId
														AND GLPeriodName__c = :periodNames
													GROUP BY GLPeriodName__c];
		
		Decimal thisPeriodGrossCost;
		Decimal lastPeriodGrossCost;
		
		for (AggregateResult ar : actualGrossCostResults) {
			if (periodNames[0].equalsIgnoreCase((String)ar.get('GLPeriodName__c'))) {
				thisPeriodGrossCost = (Decimal)ar.get('totalAmount');
			} else {
				lastPeriodGrossCost = (Decimal)ar.get('totalAmount');
			}
		}
		Decimal thisPeriodGrossMargin;
		Decimal lastPeriodGrossMargin;
		returnCalcs.lastMonthGrossMarginLessThanPrecedingMonth = false;
		if(thisPeriodRevenue != null && thisPeriodGrossCost != null)
		{
			thisPeriodGrossMargin = thisPeriodRevenue - thisPeriodGrossCost;
		}
		if(lastPeriodRevenue != null && lastPeriodGrossCost != null)
		{
			lastPeriodGrossMargin = lastPeriodRevenue - lastPeriodGrossCost;
		}

		if(thisPeriodGrossMargin != null && lastPeriodGrossMargin != null)
		{
			returnCalcs.lastMonthGrossMarginLessThanPrecedingMonth = (thisPeriodGrossMargin < lastPeriodGrossMargin) ? true : false;
		}
		
// last month net margin less than preceding month
		returnCalcs.lastMonthNetMarginLessThanPrecedingMonth = false;
		if(thisPeriodNetMargin != null && lastPeriodNetMargin != null)
		{
			returnCalcs.lastMonthNetMarginLessThanPrecedingMonth = (thisPeriodNetMargin < lastPeriodNetMargin) ? true : false;
		}
// approved budget gross revenue


		
// contractValue

		 // TODO:  Calculate this when I receive direction from Jodi and Christina
		
// last month unbilled amount more than zero

		List<AggregateResult> actualRevenueResultsSinceInception = [SELECT SUM(Amount__c) totalAmount
																	FROM Revenue__c
																	WHERE ProjectNumber__c = :theProjectId
																		AND GLDate__c <= :asOfDate];
																		
		List<AggregateResult> billedAmount = [SELECT SUM(InvoiceAmount__c) totalAmount
												FROM Billing__c
												WHERE ProjectNumber__c = :theProjectId
													AND InvoiceDate__c <= :asOfDate];
													
		Decimal unBilledAmount;
		if(!actualRevenueResultsSinceInception.isEmpty() && !billedAmount.isEmpty())
		{
			if(actualRevenueResultsSinceInception[0].get('totalAmount') != null && billedAmount[0].get('totalAmount') != null)
			{
				unBilledAmount = (Decimal)actualRevenueResultsSinceInception[0].get('totalAmount') - (Decimal)billedAmount[0].get('totalAmount');
			}
		}
		
		returnCalcs.lastMonthUnBilledAmountMoreThanZero = (unBilledAmount > 0) ? true : false;

// last month labor charges are zero

		returnCalcs.lastMonthLaborChargesAreZero = (thisPeriodLaborAmount == 0) ? true : false;

// days since last update
		

		
// ALL DONE!!	
	}
	//}
	
	public class CalculationHolder {
		public Boolean isPMCertified;
		public Boolean isScheduledEndDateInPast;
		public Decimal averageActualLaborRate;
		public Decimal approvedBudgetLaborRate;
		public Decimal SPI;
		public Decimal CPI;
		public Decimal EAC;
		public Decimal geographyThreshold;
		public Decimal ETC;
		public Decimal etcRunRate;
		public Boolean laborIncreaseOverPriorMonthMoreThan30Percent;
		public Boolean projectCompletedMoreThan75Percent;
		public Decimal actualVSPlannedMarginVarianceFromPriorMonth;
		public Boolean lastMonthGrossMarginLessThanPrecedingMonth;
		public Boolean lastMonthNetMarginLessThanPrecedingMonth;
		public Decimal approvedBudgetGrossRevenue;
		public Decimal contractValue;		
		public Boolean lastMonthUnBilledAmountMoreThanZero;
		public Boolean lastMonthLaborChargesAreZero;
		public Decimal lastEACUpdateInDays;
		public Decimal costSoFar;
		public Boolean hasProjectPlan;
		public Decimal negativeNetMargin;
		public Boolean unBilledAmount60Days;
		public Boolean arGreaterThan90Days;		
	}
	
}