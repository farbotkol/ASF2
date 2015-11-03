public with sharing class ECO_EarnedValueEstimatedFlyoutController {
    public list<WeeklyRollupEntry__c> lWeeklyRollupEntries {get; set;}

    public String chartData {get; set;}

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
                     , OverrideEstimatedCost__c
                     , EstimatedCost__c
                     , OverrideRevenue__c
                     , OverrideAcctBurdenedCost__c
                     , OverrideAcctRawCost__c
                     , OverrideApprovedCost__c
                     , AppliedEstimatedCost__c
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
            Decimal approvedCost = (entry.AppliedEstimatedCost__c != null) ? entry.AppliedEstimatedCost__c : 0;
            Decimal revenue = (entry.AppliedRevenue__c != null) ? entry.AppliedRevenue__c : 0;

            Decimal netCashPosition = - approvedCost + revenue;
            amountSoFar += netCashPosition;

            plannedCostTotal += (entry.EstimatedCost__c != null) ? entry.EstimatedCost__c : 0;
            cashInTotal += (entry.Revenue__c != null) ? entry.Revenue__c : 0;

            chartData += '["' + entry.PeriodStartDate__c.format() + '", ' + netCashPosition + ', ' + amountSoFar + '],';
        }
        
        chartData = chartData.subString(0, chartData.length() - 1);
        
        chartData += ']';
    }

    public PageReference save() {
        update lWeeklyRollupEntries;

        reload(true);

        return null;
    }

    public PageReference clearAllOverrides() {
        for (WeeklyRollupEntry__c entry : lWeeklyRollupEntries) {
            entry.OverrideEstimatedCost__c = null;
            entry.OverrideRevenue__c = null;
        }

        update lWeeklyRollupEntries;

        reload(true);

        return null;
    }
}