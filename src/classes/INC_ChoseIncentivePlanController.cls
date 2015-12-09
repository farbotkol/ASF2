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
	public String fromWizard {get;set;}
	public String selectedPlan{get;set;}
	public boolean showsave{get;set;}

	public list<planWrapper> availablePlans {get; set;}
	
	public INC_ChoseIncentivePlanController(){
		System.Debug(logginglevel.error,'Here in choose IncentivePlan__c ' + fromWizard);
		showsave = false;
		selectedSelectionMethod = 'Guided'; //DTWINCCIPCSOGUIDE
		ID enrollID = Apexpages.currentPage().getParameters().get('id');
		enrollmentPlan = INC_Service_EnrollmentPlan.getEnrollmentPlan(new set<id>{enrollID})[0];
		availablePlans = new list<planWrapper>();
		buildPlanMaps();	
	}

	public INC_ChoseIncentivePlanController(ApexPages.StandardController controller)
	{
		System.Debug(logginglevel.error,'Here in choose also IncentivePlan__c ');
		enrollmentPlan = (EnrollmentPlan__c)controller.getRecord();
		enrollmentPlan = INC_Service_EnrollmentPlan.getEnrollmentPlan(new set<id>{enrollmentPlan.ID})[0];
		availablePlans = new list<planWrapper>();
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
												where Status__c =: 'Active'
												and GeographyAllocation__c =: enrollmentPlan.IncentiveProject__r.SuperGeography__c];
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

//		System.debug(logginglevel.error,'planMapByRegion: ' + planMapByRegion);
//		System.debug(logginglevel.error,'planMapByContractType: ' + planMapByContractType);

	}
	
	public list<SelectOption> getYesNoOptions()
	{
	    list<SelectOption> options = new list<SelectOption>();
	    options.add(new SelectOption('Yes', 'Yes')); //DTWINCCIPCSOYES
	    options.add(new SelectOption('No', 'No')); //DTWINCCIPCSONO
	
	    return options;
	}
	
	public list<SelectOption> getSelectionMethods()
	{
	    list<SelectOption> options = new list<SelectOption>();

	    //for translation only check output not key value hec 11/24
	    options.add(new SelectOption('Guided', 'Guided'));//DTWINCCIPCSOGUIDE
	    options.add(new SelectOption('Manual', 'Manual'));//DTWINCCIPCSOMAN
	
	    return options;		
	}
	
	
	
	public boolean getIsANZRegion()
	{
		if(enrollmentPlan.ProjectGeography__c == 'ANZ')
			return true;
		return false;
	}
	/*
	public String getGeographyAllocation(String projectGeography)
	{
		if(projectGeography == 'Midwest' || projectGeography ==  'Southeast' || projectGeography ==  'Northeast' || projectGeography == 'Pacific' || projectGeography == 'West/Gulf Coast' )
			return 'Americas';
		
		if(projectGeography == 'UK & Ireland')
			return 'EMEA';
		
		if(projectGeography =='SE Asia' || projectGeography == 'Greater China' || projectGeography == 'ANZ')
			return 'APAC';
		
		return 'Americas';		
	}	
	*/
	public boolean getIsMultiPlanEligible()
	{
		if(getIsFixedPriceEligible() && getIsTMEligible())
			return true;
		return false;
	}
	
	private String getFixedPriceOrTAndM()
	{
		System.Debug(logginglevel.error,'FP OR TM: ' + getIsMultiPlanEligible() + ' ' + question3Answer + question4Answer);
		if(question3Answer == 'Yes' && question4Answer == 'Yes'){
			return 'Fixed Price'; //DTWINCCIPCFP
		}
		
		if(question3Answer=='No' && question4Answer=='Yes'){
			return 'Both';//DTWINCCIPCBOTH
		}
		
		if(question3Answer=='Yes' && question4Answer=='No'){
			return 'Time & Material';//DTWINCCIPCTM
		}

		return 'Time & Material'; //DTWINCCIPCTM
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

	private String getNetMarginOrGrossMargin()
	{
		if(question2Answer == 'Yes')
			return 'Net Margin'; //DTWINCCIPCNM
		return 'Gross Margin'; //DTWINCCIPCGM
	}
	
	public PageReference returnHome(){ 
		PageReference PR = new PageReference('/apex/INC_EnrollmentApp?id=' + enrollmentPlan.id);
		PR.setRedirect(true);
		return PR;
	}

	public PageReference manualSelection(){
		if(selectedSelectionMethod == 'Manual'){
			return submitQuestionnairre();
		}
		availablePlans.clear();
		return null;
	}

	public PageReference submitQuestionnairre()
	{
		string geoAlloc = enrollmentPlan.IncentiveProject__r.SuperGeography__c;//getGeographyALlocation(enrollmentPlan.ProjectGeography__c);
		string mainType = '';
		string subType = '';
		
		System.Debug(logginglevel.error,'selectedSelectionMethod ' + selectedSelectionMethod);

		if(question1Answer == 'No' && selectedSelectionMethod != 'Manual')
		{
			//DTWINCCIPCAFEXERROR
			ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error, 'Application should not be started until contract is fully executed!'));
			return null;
		}
		
		if(selectedSelectionMethod == 'Manual') //DTWINCCIPCSOMAN
		{
			availablePlans.clear();
			//availablePlans.addall(planMapByRegion.get(geoAlloc));
		//	System.debug(logginglevel.error,'planMapByRegion: ' + planMapByRegion);
		//	System.Debug(logginglevel.error,'geoAllo Manual: '+ geoAlloc);
			buildAvailablePlans(planMapByRegion.get(geoAlloc));
			showsave = true;
			return null;		
		}
		

		/*if(getIsANZRegion())
		{
			selectedIncentivePlan = 'TM-NM-ANZ Plan';
			return null;
		}*/

		if(selectedSelectionMethod == 'Guided')//DTWINCCIPCSOGUIDE
		{		
			mainType = getFixedPriceOrTAndM();
			subType = getNetMarginOrGrossMargin();
			availablePlans.clear();
			System.debug(logginglevel.error,'planMapByContractType ' + planMapByContractType);
			System.debug(logginglevel.error,'Values: ' + mainType + '-' + subType + '-' + geoAlloc);
			System.debug(logginglevel.error,'availablePlans: ' + planMapByContractType.KeySet());
			//availablePlans.addall(planMapByContractType.get(mainType + '-' + subType + '-' + geoAlloc));
			System.Debug(logginglevel.error,'Key: ' + maintype + SubType + geoAlloc);
			System.Debug(logginglevel.error,planMapByContractType.KeySet());
			if(mainType !='Both'){
				buildAvailablePlans(planMapByContractType.get(mainType + '-' + subType + '-' + geoAlloc));
			}else{
				mainType='Fixed Price';
				buildAvailablePlans(planMapByContractType.get(mainType + '-' + subType + '-' + geoAlloc));
				mainType='Time & Material';
				buildAvailablePlans(planMapByContractType.get(mainType + '-' + subType + '-' + geoAlloc));
			}
			showsave=true;
			return null;
		}
				
		
		selectedIncentivePlan = mainType + '-' + subType + '-' + geoAlloc + ' Plan';
		
		return null;
		//return new PageReference('/' + enrollmentPlan.Id );
	}
	
	public void buildAvailablePlans(list<IncentivePlanTemplate__c> listLoad){
		System.debug(logginglevel.error,'listLoad: ' + listLoad);
		if(listLoad != null && listLoad.size() > 0){
			for(IncentivePlanTemplate__c icp: listLoad){
				planWrapper pw = new planWrapper(icp);
				if(icp.ID == enrollmentPlan.IncentivePlan__c){
					pw.selected = true;
				}

				availablePlans.add(pw);
			}
		}
	}

	public PageReference selectPlanForEnrollment()
	{
		for(Planwrapper pw: availablePlans){
			if(pw.selected){
				selectedPlan = pw.plan.id;
				enrollmentPlan.IncentivePlan__c = pw.plan.Id;
			}
		}
		//enrollmentPlan.IncentivePlan__c = Apexpages.currentPage().getParameters().get('planId');
		//selectedPlan = enrollmentPlan.IncentivePlan__c;
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Saved'));
            
		update enrollmentPlan;
		if(fromWizard == null || fromWizard == 'No'){
			return new PageReference('/' + enrollmentPlan.Id );
		}

		return null;
	}
	
	public void clearResults()
	{
		availablePlans.clear();
	}

	public class planWrapper{
		public IncentivePlanTemplate__c plan {get;set;}
		public boolean selected{get;set;}
		
		public planWrapper( IncentivePlanTemplate__c oplan){
			plan = oplan;
			selected = false;
		}
	}

}