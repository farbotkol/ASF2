public class ECO_MSATeamingPartnerController {
	
	public MSATeamingPartner__c msaTeamingPartner {get; set;}
	
	public ECO_MSATeamingPartnerController(ApexPages.StandardController standardController)
	{
		msaTeamingPartner = (MSATeamingPartner__c)standardController.getRecord();
	}

	public void init()
	{
		if(Apexpages.currentPage().getParameters().get('Agreement__c') != null)
		{
			msaTeamingPartner.Agreement__c = Apexpages.currentPage().getParameters().get('Agreement__c'); 		
		}
	}
	
	public PageReference save()
	{
		insert msaTeamingPartner;
		
		PageReference pageRef = new PageReference('/' + msaTeamingPartner.Agreement__c);
		return pageRef;
	}	
}