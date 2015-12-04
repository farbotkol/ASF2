global class ECO_PMD_ListDemo_Controller {
    public ECO_PMD_ListDemo_Controller(){}

    
    @RemoteAction
    global static List<Risk__c> TopRisks(String projectNum)
    {
        
        Id projectId = projectNum;
        
        return [select Id,Name,RiskDescription__c,Project__c ,ContingencyDollars__c,RiskScore__c,CurrentStatus__c
            from Risk__c
            where CurrentStatus__c <> 'Cancelled' and CurrentStatus__c <> 'Expired'
            order by ContingencyDollars__c	asc
            limit 3];
    }
    
    
    @RemoteAction
    global static Decimal TotakContingencyDollars(String projectNum)
    {
        
        Id projectId = projectNum;
     
        Decimal cnt = (Decimal)[select sum(ContingencyDollars__c)sumd
            from Risk__c
            where CurrentStatus__c <> 'Cancelled' and CurrentStatus__c <> 'Expired'
            group by CurrentStatus__c
            having sum(ContingencyDollars__c) > 0
            limit 1][0].get('sumd');
        
        return cnt;
    }
}