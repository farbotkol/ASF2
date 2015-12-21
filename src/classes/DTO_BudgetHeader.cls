// Git Demo for DTW team - just a test
public class DTO_BudgetHeader {
	public BudgetHeader__c oBudgetHeader {get; set;}
    
    public static final String STATUS_APPROVED = 'Approved';
    public static final String STATUS_FORECAST = 'Forecast';
    public static final String STATUS_WORKATRISK = 'Work at Risk';
    
    public String budgetName{
        get {return oBudgetHeader.BudgetName__c;}
        private set;
    }
    
    public DateTime createdDate {
        get {return oBudgetHeader.CreatedDate;}
        private set;
    }
    
    public String status {
        get {return oBudgetHeader.Status__c;}
        private set;
    }
    
    public decimal dTotalCost {
        get {return oBudgetHeader.TotalCost__c;}
        private set;
    }
    
    public decimal dTotalRevenue {
        get {return oBudgetHeader.TotalRevenue__c;}
        private set;
    }
    
    public decimal dTotalApprovedCost {
        get{
            if(oBudgetHeader.Status__c == STATUS_APPROVED)
                return oBudgetHeader.TotalCost__c;
            
            return 0.0;
        }
        
        private set;
    }
    
    public decimal dTotalApprovedRevenue {
        get{
            if(oBudgetHeader.Status__c == STATUS_APPROVED)
                return oBudgetHeader.TotalRevenue__c;
            
            return 0.0;
        }
        
        private set;
    }
    
    public decimal dTotalForecastCost {
        get{
            if(oBudgetHeader.Status__c == STATUS_APPROVED || oBudgetHeader.Status__c == STATUS_FORECAST)
                return oBudgetHeader.TotalCost__c;
            
            return 0.0;
        }
        
        private set;
    }
    
    public decimal dTotalForecastRevenue {
        get{
            if(oBudgetHeader.Status__c == STATUS_APPROVED || oBudgetHeader.Status__c == STATUS_FORECAST)
                return oBudgetHeader.TotalRevenue__c;
            
            return 0.0;
        }
        
        private set;
    }
    
    public decimal dTotalWorkAtRiskCost {
        get{
            if(oBudgetHeader.Status__c == STATUS_WORKATRISK)
                return oBudgetHeader.TotalCost__c;
            
            return 0.0;
        }
        
        private set;
    }
    
    public decimal dTotalWorkAtRiskRevenue {
        get{
            if(oBudgetHeader.Status__c == STATUS_WORKATRISK)
                return oBudgetHeader.TotalRevenue__c;
            
            return 0.0;
        }
        
        private set;
    }
    
    public DTO_BudgetHeader(BudgetHeader__c o_BudgetHeader){
        oBudgetHeader = o_BudgetHeader;
    }
}