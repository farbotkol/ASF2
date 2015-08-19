public with sharing class ECO_ExportControlController {

	public ExportControl__c oExportControl {get; set;}
	public ApexPages.StandardController oStandardController {get; set;}
	public list<SelectOption> lAnswerValues {get; set;}
	public Id sQuestionnaireSetId {get; set;}
	public Id sProjectId {get; set;}
	public list<Project_Site__c> lProjectSites {get; set;}
	public Project_Site__c oUltimateEndUser {get; set;}
	public Project_Site__c oClient {get; set;}
	public list<SelectOption> lCities {get; set;}
	public boolean bShowUltimateEndUserAddress {get; set;}
	public boolean bShowClientAddress {get; set;}
	
	public ECO_ExportControlController(ApexPages.StandardController oStandardController)
	{
		list<string> lFields = new list<string>();
        lFields.add('QuestionnaireSet__c');
        lFields.add('Project__c');
        oStandardController.addFields(lFields);
        
        this.oExportControl = (ExportControl__c)oStandardController.getRecord();
        this.oStandardController = oStandardController;
        this.sQuestionnaireSetId = oExportControl.QuestionnaireSet__c;
        this.sProjectId = oExportControl.Project__c;
        bShowUltimateEndUserAddress = false;
        bShowClientAddress = false;
        
        lAnswerValues = new list<SelectOption>{
            new SelectOption('Yes', 'Yes'),
            new SelectOption('No', 'No')
        };
        
        if(sQuestionnaireSetId == null)
        {
			ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.WARNING,'You have reached this page improperly, please access it from the Project screen.');
            ApexPages.addMessage(oPageMessage);
            return;
		}
		
		if(sProjectId != null)
		{
			lProjectSites = new list<Project_Site__c>([Select Is_Primary_End__c, 
															Is_Billing__c, 
															Site__r.Account__r.Id,
															Site__r.Account__r.Website, 
															Site__r.Account__r.Name, 
															Site__r.Account__r.BillingStreet, 
															Site__r.Account__r.BillingState, 
															Site__r.Account__r.BillingPostalCode, 
															Site__r.Account__r.BillingCountry, 
															Site__r.Account__r.BillingCity 
														From Project_Site__c
														Where Project__c = :sProjectId
														And (Is_Primary_End__c = true
															Or Is_Billing__c = true)
														Order By Account_Name__c]);
			for(Project_Site__c p : lProjectSites)
			{
				if(p.Is_Primary_End__c)
				{
					oUltimateEndUser = p;
					bShowUltimateEndUserAddress = true;
					break;
				}
			}

			for(Project_Site__c p : lProjectSites)
			{
				if(p.Is_Billing__c && p.Site__r.Account__r.Id != oUltimateEndUser.Site__r.Account__r.Id)
				{
					oClient = p;
					bShowClientAddress = true;
					break;
				}
			}
			lCities = new list<SelectOption>();
			lCities.add(new SelectOption('', 'Please Choose'));


			for(ProjectCity__c c : [Select Id, CityName__c From ProjectCity__c Where Project__c = :sProjectId Order By CityName__c])
			{
				lCities.add(new SelectOption(c.Id, c.CityName__c));
			}
		}
	}
	
	public PageReference SaveRecord()
	{
    	oStandardController.save();
    	return null;
    }
    
	public PageReference ReturnToSummary()
	{
    	PageReference oPageReference = Page.ECO_RMASummary;

    	oPageReference.getParameters().put('Id', oExportControl.QuestionnaireSet__c);
    	oPageReference.setRedirect(true);

    	return oPageReference;
    }
}