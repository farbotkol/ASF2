public class ECO_OtherDirectCostController {
	
	public OtherDirectCost__c otherDirectCost {get; set;}
	
	public ECO_OtherDirectCostController(ApexPages.StandardController standardController)
	{
		otherDirectCost = (OtherDirectCost__c)standardController.getRecord();
	}

	public void init()
	{
		if(Apexpages.currentPage().getParameters().get('Agreement__c') != null)
		{
			otherDirectCost.Agreement__c = Apexpages.currentPage().getParameters().get('Agreement__c'); 		
		}
	}
	
	public PageReference save()
	{
		insert otherDirectCost;
		
		PageReference pageRef = new PageReference('/' + otherDirectCost.Agreement__c);
		return pageRef;
	}	
}