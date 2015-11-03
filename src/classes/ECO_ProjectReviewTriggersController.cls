public with sharing class ECO_ProjectReviewTriggersController 
{
	public ApexPages.StandardController oStandardController {get; set;}
	public Project_Review_Trigger__c oProjectReviewTrigger {get; set;}
	public List<KPI_Metric__c> lKPIMetrics {get; set;}
	public Map<Id, KPI_Metric__c> mKPIMetrics {get; set;}
	public List<SelectOption> lMetricOptions {get; set;}
	public String unitOfMeasure {get; set;}
	public RecordType recordType {get; set;}
	
	public ECO_ProjectReviewTriggersController(ApexPages.StandardController oStandardController) 
	{
		this.oStandardController = oStandardController;
		oProjectReviewTrigger = (Project_Review_Trigger__c)oStandardController.getRecord();
		lKPIMetrics = new List<KPI_Metric__c>([Select Unit_of_Measure__c, Name, Is_Active__c, Database_Field_Mapping_API_Name__c, Data_Type__c From KPI_Metric__c Where Is_Active__c = true Order By Name]);
		lMetricOptions = new List<SelectOption>();
		mKPIMetrics = new Map<Id, KPI_Metric__c>();
		lMetricOptions.add(new SelectOption('', '-- Choose --'));
		for(KPI_Metric__c kpi : lKPIMetrics)
		{
			lMetricOptions.add(new SelectOption(kpi.Id, kpi.Name));
			mKPIMetrics.put(kpi.Id, kpi);
		}
		loadMetric();

		String recordTypeId = '';
		if(Apexpages.currentPage().getParameters().get('RecordType') != null)
			recordTypeId = Apexpages.currentPage().getParameters().get('RecordType');
		else
			recordTypeId = oProjectReviewTrigger.RecordTypeId;
		recordType = [select Id, Name from RecordType where Id = :recordTypeId];
	}

	public void loadMetric()
	{
		if(mKPIMetrics.containsKey(oProjectReviewTrigger.KPI_Metric__c))
		{
			unitOfMeasure = mKPIMetrics.get(oProjectReviewTrigger.KPI_Metric__c).Unit_of_Measure__c;
		}
	}

	public PageReference loadRegionDetails()
	{
		Project_Review_Trigger__c parentProjectReviewTrigger;
		if(oProjectReviewTrigger.ParentProjectReviewTrigger__c != null)
		{
			parentProjectReviewTrigger = [select Id, Name, KPI_Metric__c, Is_Active__c, TriggerDescription__c, Evaluation_Frequency__c, Operator__c, Comparator_1__c from Project_Review_Trigger__c where Id =  :oProjectReviewTrigger.ParentProjectReviewTrigger__c];
			oProjectReviewTrigger.Name = parentProjectReviewTrigger.Name;
			oProjectReviewTrigger.KPI_Metric__c = parentProjectReviewTrigger.KPI_Metric__c;
			oProjectReviewTrigger.Is_Active__c = parentProjectReviewTrigger.Is_Active__c;
			oProjectReviewTrigger.TriggerDescription__c = parentProjectReviewTrigger.TriggerDescription__c;
			oProjectReviewTrigger.Evaluation_Frequency__c = parentProjectReviewTrigger.Evaluation_Frequency__c;
			oProjectReviewTrigger.Operator__c = parentProjectReviewTrigger.Operator__c;
			oProjectReviewTrigger.Comparator_1__c = parentProjectReviewTrigger.Comparator_1__c;
		}
		return null;
	}

	public PageReference doSave()
	{
		PageReference pr;
		//try
		//{
			upsert oProjectReviewTrigger;
			//oStandardController.save();
			//String recordID = oProjectReviewTrigger.Id;
			//String prefix = recordID.substring(0,3);
			//pr = new PageReference('/' + prefix + '/o');
			//pr.setRedirect(true);
		//}
		//catch(Exception e)
		//{
		//	ApexPages.addMessages(e);
		//}
		//return pr;
		return null;
	}

	public PageReference returnToProjectReviewTriggers()
	{
		Project_Review_Trigger__c test = (Project_Review_Trigger__c)oStandardController.getRecord();
		String recordID = test.Id;
		String prefix = recordID.substring(0,3);
		PageReference pr;
		pr = new PageReference('/' + prefix + '/o');
		pr.setRedirect(true);	
		return pr;	
	}
}