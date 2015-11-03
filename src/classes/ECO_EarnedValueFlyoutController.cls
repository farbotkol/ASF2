public with sharing class ECO_EarnedValueFlyoutController {
    public list<WeeklyRollupEntry__c> lWeeklyRollupEntries {get; set;}
    public String chartData {get; set;}
    public String chartData2 {get; set;}
    
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
                     , PeriodStartDate__c
                     , AppliedEstimatedCost__c
                     , AppliedRevenue__c
                     , AppliedAcctBurdenedCost__c
                     , AppliedAcctRawCost__c
                     , AppliedApprovedCost__c
                	 , EarnedValue__c
                	 , CPI__c
                	 , SPI__c
                FROM WeeklyRollupEntry__c
                WHERE
                    Project__c = :sProjectId
                ORDER BY
                    CompositeKey__c ASC]);
        }

        chartData = '[';
        
        chartData += '["Week", "Planned", "Estimate", "Actual", "Earned Value"],';
        
        chartData2 = '[';
        
        chartData2 += '["Week", "CPI", "SPI"],';
        
        Decimal estimatedCostCumm = 0;
        Decimal approvedCostCumm = 0;
        Decimal actualCostCumm = 0;
            
        for (WeeklyRollupEntry__c entry : lWeeklyRollupEntries) {
            Decimal estimatedCost = (entry.AppliedEstimatedCost__c != null) ? entry.AppliedEstimatedCost__c : 0;
            Decimal approvedCost = (entry.AppliedApprovedCost__c != null) ? entry.AppliedApprovedCost__c : 0;
            Decimal earnedValue = (entry.EarnedValue__c != null) ? entry.EarnedValue__c : 0;
            Decimal actualCost = (entry.AppliedAcctBurdenedCost__c != null) ? entry.AppliedAcctBurdenedCost__c : 0;

            estimatedCostCumm += estimatedCost;
            approvedCostCumm += approvedCost;
            actualCostCumm += actualCost;

            chartData += '["' + entry.PeriodStartDate__c.format() + '", ' + approvedCostCumm + ', ' + estimatedCostCumm + ', ' + actualCostCumm + ', ' + earnedValue + '],';
            
            chartData2 += '["' + entry.PeriodStartDate__c.format() + '", ' + entry.CPI__c + ', ' + entry.SPI__c + '],';
        }
        
        chartData = chartData.subString(0, chartData.length() - 1);
        chartData2 = chartData2.subString(0, chartData2.length() - 1);
        
        chartData += ']';
        chartData2 += ']';
	}    
}