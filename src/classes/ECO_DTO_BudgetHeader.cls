public class ECO_DTO_BudgetHeader {
	public BudgetHeader__c oBudgetHeader {get; set;}
    
    public Map<String, String> budgetHeaderChangeManagerMap {get; set;}
        
    public static final String STATUS_APPROVED = 'Approved';
    public static final String STATUS_FORECAST = 'Forecast';
    public static final String STATUS_WORKATRISK = 'Work at Risk';
    public static final String STATUS_ESTIMATE = 'Estimate';
    public static final String STATUS_ARCHIVE = 'Archive';

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
    
    public List<SelectOption> lstActions {
        get {
            List<SelectOption> listOptions = new List<SelectOption>();
            listOptions.add(new SelectOption('','Select Action'));
            if(oBudgetHeader.Status__c == STATUS_ESTIMATE && String.IsEmpty(budgetHeaderChangeManagerMap.get('Internal Change'))&& String.IsEmpty(budgetHeaderChangeManagerMap.get('External Change'))) {
                listOptions.add(new SelectOption('SubmitInternalChange','Submit Forecasted Change'));
            }
            
            if((oBudgetHeader.Status__c == STATUS_ESTIMATE || oBudgetHeader.Status__c == STATUS_FORECAST) && String.IsEmpty(budgetHeaderChangeManagerMap.get('External Change'))){
                listOptions.add(new SelectOption('SubmitExternalChange','Submit Approved Change'));
            }
            
            if(oBudgetHeader.Status__c != STATUS_APPROVED && oBudgetHeader.Status__c != STATUS_FORECAST 
                && oBudgetHeader.Status__c != STATUS_ARCHIVE) {
                listOptions.add(new SelectOption('ArchiveBudget','Archive Budget'));
            }

            if(oBudgetHeader.Status__c == STATUS_ARCHIVE) {
                listOptions.add(new SelectOption('UnArchiveBudget','UnArchive Budget'));
            }
           
            if(!String.IsEmpty(budgetHeaderChangeManagerMap.get('Internal Change'))) {
                listOptions.add(new SelectOption('ViewInternalChange','View Forecasted Change'));
            }
            
            if(!String.IsEmpty(budgetHeaderChangeManagerMap.get('External Change'))) {
                listOptions.add(new SelectOption('ViewExternalChange','View Approved Change'));
            }
            
            return listOptions;
        }
        
        private set;
    }
    
    public String strSelectedAction { get; set;}
    
    public ECO_DTO_BudgetHeader(BudgetHeader__c o_BudgetHeader){
        oBudgetHeader = o_BudgetHeader;
        
        budgetHeaderChangeManagerMap = new Map<String, String>();
        budgetHeaderChangeManagerMap.put('Internal Change', '');
        budgetHeaderChangeManagerMap.put('External Change', '');
        
        for(ChangeManager__c changeManager : oBudgetHeader.Change_Manager__r) {
            budgetHeaderChangeManagerMap.put(changeManager.RecordType.Name, changeManager.Id);
        }
        
    }
}