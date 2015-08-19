public without sharing class ECO_KPICalculation {
	
	public CalculationHolder getProjectHealthCalculations(Id theProjectId) {
		return getProjectHealthCalculations(theProjectId, Date.today());
	}
	
	public static CalculationHolder getProjectHealthCalculations(Id theProjectId, date asOfDate) {
		CalculationHolder returnCalcs = new CalculationHolder();
		
		pse__Proj__c theProject = ECO_Service_Projects.getProjectById(theProjectId);
		User theProjectManager = ECO_Service_Users.getUserInfoById(theProject.OwnerId);

// Is PM Certified?	

		boolean answer = false;

		if(theProjectManager.Certified_PM__c == 'Yes'){
			answer = true;
		}

		returnCalcs.isPMCertified = answer;

// Is Scheduled End Date In Past?
		if(theProject.pse__End_Date__c != null)
		{
			returnCalcs.isScheduledEndDateInPast = (asOfDate >=  theProject.pse__End_Date__c) ? true : false;
		}

// Average Actual Labor Rate
		
		List<AggregateResult> averageActualLaborRate = [SELECT AVG(AcctBurdCostTimesQuantity__c) rate
														FROM CostDistributionLine__c
														WHERE GLDate__c <= :asOfDate
															AND ProjectNumber__c = :theProjectId
															AND ExpenditureItemID__r.ExpenditureType__c LIKE 'LAB%'];
															
		if(!averageActualLaborRate.isEmpty())
		{
			returnCalcs.averageActualLaborRate = (Decimal)averageActualLaborRate[0].get('rate');
		}

// Approved Budget Labor Rate
													
		List<AggregateResult> averageApprovedBudgetLaborRate = [SELECT AVG(FullyBurdenedCostRate__c) rate
																FROM BudgetAssignment__c
																WHERE BudgetResource__r.BudgetHeader__r.Project__c = :theProjectId
																	AND BudgetResource__r.ResourceType__c IN ('Labor/Person', 'Subcontractor')
																	AND BudgetResource__r.BudgetHeader__r.Status__c = 'Approved'];
																	
		if(!averageApprovedBudgetLaborRate.isEmpty())
		{
			returnCalcs.approvedBudgetLaborRate = (Decimal)averageApprovedBudgetLaborRate[0].get('rate');
		}

		//SPI CPI

		returnCalcs.SPI = 0;
		returnCalcs.CPI = 0;

		List<EarnedValueHeader__c> listOfEVRs = [	SELECT Id, 
														   Project__c, 
														   ReportName__c, 
														   Comments__c, 
														   SnapshotDate__c
    												FROM EarnedValueHeader__c
    												WHERE Project__c = :theProjectId
    												  AND SnapshotDate__c != null
    												ORDER BY SnapshotDate__c desc
    											];
    	if (!listOfEVRs.isEmpty()) {
    		EarnedValueHeader__c existingReport = listOfEVRs.get(0);
    		Date currentSnapshotDate = existingReport.SnapshotDate__c;
    	


			string sCompositeKey = ECO_Service_Snapshots.DateToSnapshotKey(currentSnapshotDate, theProjectId);
			List<WeeklyRollupEntry__c> lWeeklyRollupEntry = new List<WeeklyRollupEntry__c>([SELECT Id, SPI__c, CPI__c FROM WeeklyRollupEntry__c WHERE CompositeKey__c = :sCompositeKey]);
			WeeklyRollupEntry__c oWeeklyRollEntry = new WeeklyRollupEntry__c();

			if(lWeeklyRollupEntry.size() > 0){
				oWeeklyRollEntry = lWeeklyRollupEntry.get(0);
				// SPI
				returnCalcs.SPI = oWeeklyRollEntry.SPI__c; // TODO Calc this during earned value stuff

				// CPI
				returnCalcs.CPI = oWeeklyRollEntry.CPI__c; // TODO Calc this during earned value stuff
			}
		}

// EAC
		
		returnCalcs.EAC = theProject.TotalForecastCost__c;

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

// ETC		
		
		List<AggregateResult> actualCost = [SELECT SUM(AcctBurdCostTimesQuantity__c) totalCost
											FROM CostDistributionLine__c
											WHERE GLDate__c <= :asOfDate
												AND ProjectNumber__c = :theProjectId];
		
		if(!actualCost.isEmpty())
		{
			if(theProject.TotalForecastCost__c != null && actualCost[0].get('totalCost') != null)
			{
				returnCalcs.ETC = theProject.TotalForecastCost__c - (Decimal)actualCost[0].get('totalCost');
			}
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

		Decimal costSoFar;
		if(!actualCost.isEmpty())
		{
			costSoFar = (Decimal)actualCost[0].get('totalCost');
		}
		
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

		List<AggregateResult> actualNetCostResults = [SELECT SUM(AcctBurdCostTimesQuantity__c) totalAmount
															, GLPeriodName__c
													FROM CostDistributionLine__c
													WHERE ProjectNumber__c = :theProjectId
														AND GLPeriodName__c = :periodNames
													GROUP BY GLPeriodName__c];
													
		List<AggregateResult> actualRevenueResults = [SELECT SUM(Amount__c) totalAmount
															, GLPeriodName__c
													FROM Revenue__c
													WHERE ProjectNumber__c = :theProjectId
														AND GLPeriodName__c IN :periodNames
													GROUP BY GLPeriodName__c];
													
		Decimal thisPeriodRevenue;
		Decimal thisPeriodNetCost;
		Decimal lastPeriodRevenue;
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
		
		Decimal thisPeriodNetMargin;
		Decimal lastPeriodNetMargin;

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
				variance = lastPeriodNetMargin / thisPeriodNetMargin;
			} else {
				variance = -1 * (thisPeriodNetMargin / lastPeriodNetMargin);
			}
		}
		
		returnCalcs.actualVSPlannedMarginVarianceFromPriorMonth = variance;
		
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
		if(thisPeriodNetMargin != null && lastPeriodNetMargin != null)
		{
			returnCalcs.lastMonthNetMarginLessThanPrecedingMonth = (thisPeriodNetMargin < lastPeriodNetMargin) ? true : false;
		}
// approved budget gross revenue

		returnCalcs.approvedBudgetGrossRevenue = theProject.TotalApprovedRevenue__c;
		
// contractValue

		returnCalcs.contractValue = 0;  // TODO:  Calculate this when I receive direction from Jodi and Christina
		
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
		
		Set<Id> budgetHeaderIds = new Set<Id>();
		for (BudgetHeader__c bh : theProject.BudgetHeaders__r) {
			budgetHeaderIds.add(bh.Id);
		}
		
		List<ProcessInstance> processInstanceList = [SELECT Id, CompletedDate
													FROM ProcessInstance 
													WHERE TargetObjectId IN :budgetHeaderIds
														AND CompletedDate <= :asOfDate
														AND Status = 'Approved'
													ORDER BY CompletedDate DESC
													LIMIT 1];
													
		if (!processInstanceList.isEmpty()) {
			returnCalcs.lastEACUpdateInDays = processInstanceList[0].CompletedDate.date().daysBetween(asOfDate);
		} else {
			returnCalcs.lastEACUpdateInDays = -1;
		}
		
// ALL DONE!!
		
		return returnCalcs;
	}
	
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
		
	}
	
}