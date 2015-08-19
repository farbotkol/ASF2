public with sharing class ECO_CashFlowFlyoutController2 {
	public list<WeeklyRollupEntry__c> lWeeklyRollupEntries {get; set;}

	public String chartData {get; set;}

    public String chartJSON {get; set;}
    public String cpiAndSpiJSON {get; set;}

	public Decimal plannedCostTotal {get; set;}
	public Decimal cashInTotal {get; set;}

	public id sProjectId {
		get;

		set {
			sProjectId = value;

			reload(false);
		}
	}

	public void reload(Boolean force) {
		if ((lWeeklyRollupEntries == null) || force) {
			lWeeklyRollupEntries = new list<WeeklyRollupEntry__c>([
				SELECT Id
					 , Revenue__c
					 , AcctBurdenedCost__c
					 , AcctRawCost__c
					 , ApprovedCost__c
					 , PeriodStartDate__c
					 , OverrideRevenue__c
					 , OverrideAcctBurdenedCost__c
					 , OverrideAcctRawCost__c
					 , OverrideApprovedCost__c
					 , AppliedRevenue__c
					 , AppliedAcctBurdenedCost__c
					 , AppliedAcctRawCost__c
					 , AppliedApprovedCost__c
				FROM WeeklyRollupEntry__c
				WHERE
					Project__c = :sProjectId
				ORDER BY
					CompositeKey__c ASC]);
		}

		Decimal amountSoFar = 0;

		plannedCostTotal = 0.00;
		cashInTotal = 0.00;

		chartData = '[';
		
		chartData += '["Week", "Net Cash Position (In Period)", "Cash Flow (Cumulative)"],';
		
		for (WeeklyRollupEntry__c entry : lWeeklyRollupEntries) {
			Decimal approvedCost = (entry.AppliedApprovedCost__c != null) ? entry.AppliedApprovedCost__c : 0;
			Decimal revenue = (entry.AppliedRevenue__c != null) ? entry.AppliedRevenue__c : 0;

			Decimal netCashPosition = - approvedCost + revenue;
			amountSoFar += netCashPosition;

			plannedCostTotal += (entry.ApprovedCost__c != null) ? entry.ApprovedCost__c : 0;
			cashInTotal += (entry.Revenue__c != null) ? entry.Revenue__c : 0;

			chartData += '["' + entry.PeriodStartDate__c.format() + '", ' + netCashPosition + ', ' + amountSoFar + '],';
		}
		
		chartData = chartData.subString(0, chartData.length() - 1);
		
		chartData += ']';

		chartJSON = createEarnedValueGoogleChartJSON();
		cpiAndSpiJSON = createCpiAndSpiGoogleChartJSON();
	}

    private String createEarnedValueGoogleChartJSON(){	
    	list<WeeklyRollupEntry__c> lWeeklyRollupEntries = new list<WeeklyRollupEntry__c>([SELECT id
    																						   , PeriodStartDate__c
    																						   , AppliedApprovedCost__c
    																						   , ProjectFunctionalBurdenedCost__c
    																						   , EarnedValue__c
    																					 FROM WeeklyRollupEntry__c 
    																					 WHERE Project__c = :sProjectId]);

    	List<EarnedValueHeader__c> listOfEVRs = [SELECT Id 
												 	  , SnapshotDate__c
													  , (SELECT id
													  	      , TrendEAC1__c
													          , TrendEAC2__c
													     FROM Earned_Value_Tasks__r
													    )
												 FROM EarnedValueHeader__c
												 WHERE Project__c = :sProjectId
												 AND SnapshotDate__c != null
												 ORDER BY SnapshotDate__c DESC];
    	Decimal dTrendEAC1 = 0;
    	Decimal dTrendEAC2 = 0;

    	if (!listOfEVRs.isEmpty()) {
    		EarnedValueHeader__c existingReport = listOfEVRs.get(0);

    		for(EarnedValueTask__c oEarnedValueTask : existingReport.Earned_Value_Tasks__r){
    			dTrendEAC1 += ECO_Utils_String.NullCheck(oEarnedValueTask.TrendEAC1__c);
    			dTrendEAC2 += ECO_Utils_String.NullCheck(oEarnedValueTask.TrendEAC2__c);
    		}
    	}

    	String sTrendEAC1 = String.valueOf(dTrendEAC1);
    	String sTrendEAC2 = String.valueOf(dTrendEAC2);

    	list<list<String>> lResults = new list<list<String>>();

    	for(WeeklyRollupEntry__c oWeeklyRollupEntry : lWeeklyRollupEntries){
    		list<String> lResultLine = new list<String>();

    		lResultLine.add(String.valueOf(oWeeklyRollupEntry.PeriodStartDate__c));
    		lResultLine.add(String.valueOf(ECO_Utils_String.NullCheck(oWeeklyRollupEntry.AppliedApprovedCost__c)));
    		lResultLine.add(String.valueOf(ECO_Utils_String.NullCheck(oWeeklyRollupEntry.ProjectFunctionalBurdenedCost__c)));
    		lResultLine.add(String.valueOf(ECO_Utils_String.NullCheck(oWeeklyRollupEntry.EarnedValue__c)));
    		lResultLine.add(sTrendEAC1);
    		lResultLine.add(sTrendEAC2);

    		lResults.add(lResultLine);
    	}

    	return JSON.serialize(lResults);
    }

    private String createCpiAndSpiGoogleChartJSON(){	
    	list<WeeklyRollupEntry__c> lWeeklyRollupEntries = new list<WeeklyRollupEntry__c>([SELECT id
    																						   , PeriodStartDate__c
    																						   , SPI__c
    																						   , CPI__c
    																					 FROM WeeklyRollupEntry__c 
    																					 WHERE Project__c = :sProjectId]);

    	list<list<String>> lResults = new list<list<String>>();

    	for(WeeklyRollupEntry__c oWeeklyRollupEntry : lWeeklyRollupEntries){
    		list<String> lResultLine = new list<String>();

    		lResultLine.add(String.valueOf(oWeeklyRollupEntry.PeriodStartDate__c));
    		lResultLine.add(String.valueOf(ECO_Utils_String.NullCheck(oWeeklyRollupEntry.CPI__c)));
    		lResultLine.add(String.valueOf(ECO_Utils_String.NullCheck(oWeeklyRollupEntry.SPI__c)));

    		lResults.add(lResultLine);
    	}

    	return JSON.serialize(lResults);
    }

	public PageReference save() {
		update lWeeklyRollupEntries;

		reload(true);

		return null;
	}

	public PageReference clearAllOverrides() {
		for (WeeklyRollupEntry__c entry : lWeeklyRollupEntries) {
			entry.OverrideApprovedCost__c = null;
			entry.OverrideRevenue__c = null;
		}

		update lWeeklyRollupEntries;

		reload(true);

		return null;
	}
}