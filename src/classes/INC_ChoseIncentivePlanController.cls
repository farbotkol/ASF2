public class INC_ChoseIncentivePlanController {
	
	public EnrollmentPlan__c enrollmentPlan {get;set;}
	public String question1Answer {get; set;}
	public String question2Answer {get; set;}
	public String question3Answer {get; set;}
	public String question4Answer {get; set;}
	public String selectedIncentivePlan {get; set;}
	public String selectedSelectionMethod {get; set;}
	public map<String, list<IncentivePlanTemplate__c>> planMapByRegion;
	public map<String, list<IncentivePlanTemplate__c>> planMapByContractType;
	
	public list<IncentivePlanTemplate__c> availablePlans {get; set;}
		
	public INC_ChoseIncentivePlanController(ApexPages.StandardController controller)
	{
		enrollmentPlan = (EnrollmentPlan__c)controller.getRecord();
		enrollmentPlan = INC_Service_EnrollmentPlan.getEnrollmentPlan(new set<id>{enrollmentPlan.ID})[0];
		availablePlans = new list<IncentivePlanTemplate__c>();
		buildPlanMaps();	
	}
	
	private void buildPlanMaps()
	{
		list<IncentivePlanTemplate__c> plans = [select Id
														 , Name
														 , ContractType__c
														 , ContractSubType__c
														 , PlanCriteria__c
														 , GeographyAllocation__c
														 , HelpText__c 
												from IncentivePlanTemplate__c
												where Status__c =: 'Active'];
		planMapByRegion = new map<string, list<IncentivePlanTemplate__c>>();
		planMapByContractType = new map<string, list<IncentivePlanTemplate__c>>();
		
		for(IncentivePlanTemplate__c plan:plans)
		{
			if(planMapByRegion.get(plan.GeographyAllocation__c) == null)
				planMapByRegion.put(plan.GeographyAllocation__c, new list<IncentivePlanTemplate__c>());
			planMapByRegion.get(plan.GeographyAllocation__c).add(plan);
			
			if(planMapByContractType.get(plan.ContractType__c + '-' + plan.ContractSubType__c) == null)
				planMapByContractType.put(plan.ContractType__c + '-' + plan.ContractSubType__c + '-' + plan.GeographyAllocation__c, new list<IncentivePlanTemplate__c>());
			planMapByContractType.get(plan.ContractType__c + '-' + plan.ContractSubType__c + '-' + plan.GeographyAllocation__c).add(plan);
		}				
	}
	
	public list<SelectOption> getYesNoOptions()
	{
	    list<SelectOption> options = new list<SelectOption>();
	    options.add(new SelectOption('Yes', 'Yes'));
	    options.add(new SelectOption('No', 'No'));
	
	    return options;
	}
	
	public list<SelectOption> getSelectionMethods()
	{
	    list<SelectOption> options = new list<SelectOption>();
	    options.add(new SelectOption('Guided', 'Guided'));
	    options.add(new SelectOption('Manual', 'Manual'));
	
	    return options;		
	}
	
	public boolean getIsFixedPriceEligible()
	{
		if(enrollmentPlan.FPPOverallEligibility_c__c == null ||enrollmentPlan.FPPOverallEligibility_c__c == 'No')
			return false;
		return true;
	}
	
	public boolean getIsTMEligible()
	{
		if(enrollmentPlan.TMPlanOverallEligibility__c == null || enrollmentPlan.TMPlanOverallEligibility__c == 'No')
			return false;
		return true;
	}
	
	public boolean getIsANZRegion()
	{
		if(enrollmentPlan.ProjectGeography__c == 'ANZ')
			return true;
		return false;
	}
	
	public String getGeographyAllocation(String projectGeography)
	{
		if(projectGeography == 'Midwest' || projectGeography ==  'Southeast' || projectGeography ==  'Northeast' || projectGeography == 'Pacific' || projectGeography == 'West/Gulf Coast' )
			return 'Americas';
		
		if(projectGeography == 'UK & Ireland')
			return 'EMEA';
		
		if(projectGeography =='SE Asia' || projectGeography == 'Greater China')
			return 'APAC';
		
		return 'Americas';		
	}	
	
	public boolean getIsMultiPlanEligible()
	{
		if(getIsFixedPriceEligible() && getIsTMEligible())
			return true;
		return false;
	}
	
	private String getFixedPriceOrTAndM()
	{
		if(getIsMultiPlanEligible() && question3Answer == 'Yes' && question4Answer == 'Yes')
			return 'Fixed Price';
		if(getIsMultiPlanEligible())
			return 'Time & Material';
		if(getIsFixedPriceEligible())	
			return 'Fixed Price';
		return 'Time & Material';
	}
	
	private String getNetMarginOrGrossMargin()
	{
		if(question2Answer == 'Yes')
			return 'Net Margin';	
		return 'Gross Margin';
	}
	
	public PageReference returnHome(){ 
		PageReference PR = new PageReference('/apex/INC_EnrollmentApp?id=' + enrollmentPlan.id);
		PR.setRedirect(true);
		return PR;
	}

	public PageReference submitQuestionnairre()
	{
		string geoAlloc = getGeographyALlocation(enrollmentPlan.ProjectGeography__c);
		string mainType = '';
		string subType = '';
		
		if(question1Answer == 'No' && selectedSelectionMethod != 'Manual')
		{
			ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error, 'Application should not be started until contract is fully executed!'));
			return null;
		}
		
		if(selectedSelectionMethod == 'Manual')
		{
			availablePlans.clear();
			availablePlans.addall(planMapByRegion.get(geoAlloc));
			return null;		
		}
		
		if(getIsANZRegion())
		{
			selectedIncentivePlan = 'TM-NM-ANZ Plan';
			return null;
		}

		if(selectedSelectionMethod == 'Guided')
		{		
			mainType = getFixedPriceOrTAndM();
			subType = getNetMarginOrGrossMargin();
			availablePlans.clear();
			System.debug(logginglevel.error,'planMapByContractType ' + planMapByContractType);
			System.debug(logginglevel.error,'Values: ' + mainType + '-' + subType + '-' + geoAlloc);
			availablePlans.addall(planMapByContractType.get(mainType + '-' + subType + '-' + geoAlloc));
			return null;
		}
				
		
		selectedIncentivePlan = mainType + '-' + subType + '-' + geoAlloc + ' Plan';
			
		return null;
		//return new PageReference('/' + enrollmentPlan.Id );
	}
	
	public PageReference selectPlanForEnrollment()
	{
		enrollmentPlan.IncentivePlan__c = Apexpages.currentPage().getParameters().get('planId');
		update enrollmentPlan;
		
		return new PageReference('/' + enrollmentPlan.Id );
	}
	
	public void clearResults()
	{
		availablePlans.clear();
	}

}