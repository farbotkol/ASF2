public with sharing class ECO_ProjectReviewTriggersController 
{
	public ApexPages.StandardController oStandardController {get; set;}
	public Project_Review_Trigger__c oProjectReviewTrigger {get; set;}
	public List<KPI_Metric__c> lKPIMetrics {get; set;}
	public Map<Id, KPI_Metric__c> mKPIMetrics {get; set;}
	public List<SelectOption> lMetricOptions {get; set;}
	public String unitOfMeasure {get; set;}
	
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
	}

	public void loadMetric()
	{
		if(mKPIMetrics.containsKey(oProjectReviewTrigger.KPI_Metric__c))
		{
			unitOfMeasure = mKPIMetrics.get(oProjectReviewTrigger.KPI_Metric__c).Unit_of_Measure__c;
		}
	}

	public PageReference doSave()
	{
		PageReference pr;
		try
		{
			oStandardController.save();
			String recordID = oProjectReviewTrigger.Id;
			String prefix = recordID.substring(0,3);
			pr = new PageReference('/' + prefix + '/o');
			pr.setRedirect(true);
		}
		catch(Exception e)
		{
			ApexPages.addMessages(e);
		}
		return pr;
	}
}