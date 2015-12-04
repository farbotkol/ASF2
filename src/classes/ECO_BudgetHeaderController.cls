public with sharing class ECO_BudgetHeaderController {
	public ApexPages.StandardController stdController {get; set;}

	public Id headerId {get; set;}

	public List<ECO_DTO_BudgetTask> tasks {get; set;}

	public ECO_DTO_BudgetTask totalRow {get; set;}
    
    public String projectCurrency {get; set;}
    public String laborPage {get; set;}
    public String subPage {get; set;}
    public String odcPage {get; set;}
    public String contingencyPage {get; set;}
    
    public pse__Proj__c theProject { get; set; }

	public ECO_BudgetHeaderController(ApexPages.StandardController stdController) {
		this.stdController = stdController;

		List<String> fields = new List<String>();

		fields.add('Project__c');

		stdController.addFields(fields);

		headerId = stdController.getId();

		reload();
        
        BudgetHeader__c budgetHeader = [SELECT Id, Project__c, RecordType.DeveloperName FROM BudgetHeader__c WHERE Id =: headerId];
        String recordTypeName = budgetHeader.RecordType.DeveloperName;
        if (recordTypeName != 'EAC') {
            laborPage = 'ECO_BudgetLabourDetail';
            subPage = 'ECO_BudgetSubDetail';
            odcPage = 'ECO_BudgetODCDetail';
            contingencyPage = 'ECO_BudgetContingency';
        } else {
            laborPage = 'ECO_BudgetLabourEAC';
            subPage = 'ECO_BudgetSubDetailEAC';
            odcPage = 'ECO_BudgetODCDetailEAC';
            contingencyPage = 'ECO_BudgetContingencyEAC';
        }

        theProject = ECO_Service_Projects.getProjectById(budgetHeader.Project__c);
	}
	
    public PageReference saveBudget() {
        stdController.save();
        
        List<BudgetTask__c> budgetTasks = new List<BudgetTask__c>();
        
        for (ECO_DTO_BudgetTask task : tasks) {
            budgetTasks.add(task.obudgetTask);
        }
        
        update budgetTasks;
        
        return null;
    }
    
	public void reload() {
		tasks = ECO_BudgetTaskService.getBudgetTaskList(headerId);

		totalRow = ECO_BudgetTaskService.getTotalRow(tasks);
	}
}