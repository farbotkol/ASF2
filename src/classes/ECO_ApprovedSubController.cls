public class ECO_ApprovedSubController {
	
	public Approved_Sub__c approvedSub {get; set;}

	public ECO_ApprovedSubController(ApexPages.standardController controller)
	{
		approvedSub = (Approved_Sub__c)controller.getRecord();	
	}
	
	public void init()
	{
		if(Apexpages.currentPage().getParameters().get('Agreement__c') != null)
		{
			approvedSub.Agreement__c = Apexpages.currentPage().getParameters().get('Agreement__c'); 		
		}
	}
	
	public PageReference save()
	{
		insert approvedSub;
		
		PageReference pageRef = new PageReference('/' + approvedSub.Agreement__c);
		return pageRef;
	}
	
}