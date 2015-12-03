public with sharing class ECO_CashFlowFlyoutController {
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
                     , OverrideRevenue__c
                     , OverrideAcctBurdenedCost__c
                     , OverrideAcctRawCost__c
                     , OverrideApprovedCost__c
                     , AppliedRevenue__c
                     , AppliedAcctBurdenedCost__c
                     , AppliedAcctRawCost__c
                     , AppliedApprovedCost__c
                     , Project__r.PercentageMargin__c

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