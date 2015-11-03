public with sharing class ECO_BudgetHeaderController {
	public ApexPages.StandardController stdController {get; set;}

	public Id headerId {get; set;}

	public List<ECO_DTO_BudgetTask> tasks {get; set;}

	public ECO_DTO_BudgetTask totalRow {get; set;}
    
    public String projectCurrency {get; set;}
    
    public pse__Proj__c theProject { get; set; }

	public ECO_BudgetHeaderController(ApexPages.StandardController stdController) {
		this.stdController = stdController;

		List<String> fields = new List<String>();

		fields.add('Project__c');

		stdController.addFields(fields);

		headerId = stdController.getId();

		reload();
        
        BudgetHeader__c budgetHeader = [SELECT Id, Project__c FROM BudgetHeader__c WHERE Id =: headerId];
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