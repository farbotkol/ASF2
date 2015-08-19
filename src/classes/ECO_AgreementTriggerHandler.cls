public class ECO_AgreementTriggerHandler {
	
	public static void handleSegmentationApproval(map<Id, Agreement__c> oldAgreementMap, map<Id, Agreement__c> newAgreementMap)
	{
		if (!ECO_TriggerSettings.getIsTriggerEnabled('AGREEMENT_segmentationApproval')) {
			return;
		}
		
		map<Id, Agreement__c> msaAgreements = new map<Id, Agreement__c>();
		map<Id, Agreement__c> nonMSAAgreements = new map<Id, Agreement__c>();
		list<pse__Proj__c> updatedProjects =  new list<pse__Proj__c>();
		
		for(Agreement__c agreement:newAgreementMap.values())
		{
			if(oldAgreementMap.get(agreement.Id).SegApprovalStatus__c != 'Approved' && agreement.SegApprovalStatus__c == 'Approved')
			{
				if(agreement.IsMSA__c)
					msaAgreements.put(agreement.Id, agreement);	
				else
					nonMSAAgreements.put(agreement.Id, agreement);
			}
		}
		
		if(msaAgreements.values().size() > 0)
		{
			map<Id, list<Agreement__c>> msaTaskOrderMap = new map<Id, list<Agreement__c>>();
			list<Agreement__c> taskOrders = [select Id, MSAReference__c from Agreement__c where MSAReference__c in :msaAgreements.keyset()];
			for(Agreement__c taskOrder:taskOrders)
			{
				if(msaTaskOrderMap.get(taskOrder.MSAReference__c) == null)
					msaTaskOrderMap.put(taskOrder.MSAReference__c, new list<Agreement__c>());
				msaTaskOrderMap.get(taskOrder.MSAReference__c).add(taskOrder);
			}
			
			map<Id, list<Id>> agreementProjectIdMap = new map<Id, list<Id>>();
			set<Id> projectIds = new set<Id>();		
			for(ProjectAgreement__c projectAgreement: [select Id, Project__c, Agreement__c from ProjectAgreement__c where Agreement__c in :taskOrders])
			{
				projectIds.add(projectAgreement.Project__c);
				if(agreementProjectIdMap.get(projectAgreement.Agreement__c) == null)
					agreementProjectIdMap.put(projectAgreement.Agreement__c, new list<Id>());
				agreementProjectIdMap.get(projectAgreement.Agreement__c).add(projectAgreement.Project__c);
			}
			map<Id, pse__Proj__c> projectMap = new map<Id, pse__Proj__c>([select Id, isSegmented__c from pse__Proj__c where Id in :projectIds]);
			
			//final processing for the msa agreement
			pse__Proj__c updatedProject;
			for(Agreement__c msaAgreement:msaAgreements.values())
			{
				for(Agreement__c taskOrder:msaTaskOrderMap.get(msaAgreement.Id))
				{
					for(Id projectId:agreementProjectIdMap.get(taskOrder.Id))
					{
						updatedProject = projectMap.get(projectId);
						if(msaAgreement.segAdherence__c == 'Yes')
						{
							updatedProject.isSegmented__c = true;
							updatedProject.SegmentationStatus__c = 'Segmented';
						}
						else if(msaAgreement.segOptionDoesNotQualify__c == 'Yes')
						{
							updatedProject.isSegmented__c = true;
							updatedProject.SegmentationStatus__c = 'Segmented for Mangement Purposes';
						}
						else
						{
							updatedProject.isSegmented__c = false;
							updatedProject.SegmentationStatus__c = 'Not Segmented';
						}
						updatedProjects.add(updatedProject);											
					}
				}				
			}
		}
		else if(nonMSAAgreements.size() > 0)
		{
			map<Id, list<Id>> agreementProjectIdMap = new map<Id, list<Id>>();
			set<Id> projectIds = new set<Id>();		
			
			for(ProjectAgreement__c projectAgreement:[select Id, Project__c, Agreement__c from ProjectAgreement__c where Agreement__c in :nonMSAAgreements.keyset()])
			{
				projectIds.add(projectAgreement.Project__c);
				if(agreementProjectIdMap.get(projectAgreement.Agreement__c) == null)
					agreementProjectIdMap.put(projectAgreement.Agreement__c, new list<Id>());
				agreementProjectIdMap.get(projectAgreement.Agreement__c).add(projectAgreement.Project__c);				
			}
			map<Id, pse__Proj__c> projectMap = new map<Id, pse__Proj__c>([select Id, isSegmented__c from pse__Proj__c where Id in :projectIds]);

			//final processing for the msa agreement
			pse__Proj__c updatedProject;
			for(Agreement__c agreement:nonMSAAgreements.values())
			{
				for(Id projectId:agreementProjectIdMap.get(agreement.Id))
				{
					updatedProject = projectMap.get(projectId);
					if(agreement.segAdherence__c == 'Yes')
					{
						updatedProject.isSegmented__c = true;
						updatedProject.SegmentationStatus__c = 'Segmented';
					}
					else if(agreement.segOptionDoesNotQualify__c == 'Yes')
					{
						updatedProject.isSegmented__c = true;
						updatedProject.SegmentationStatus__c = 'Segmented for Mangement Purposes';						
					}
					else
					{
						updatedProject.isSegmented__c = false;
						updatedProject.SegmentationStatus__c = 'Not Segmented';
					}
					updatedProjects.add(updatedProject);											
				}
			}				
		}
		if(updatedProjects.size() > 0)
			update updatedProjects;		
	}
	
	public static void handleAgreementBeforeUpdate(map<Id, Agreement__c> oldAgreementMap, map<Id, Agreement__c> newAgreementMap)
	{
		if (!ECO_TriggerSettings.getIsTriggerEnabled('AGREEMENT_populateAgreementNumber')) {
			return;
		}
		
		list<Id> projectIds = new list<Id>();
		list<Agreement__c> agreementsWithNoProjectNumber = new list<Agreement__c>();
		for(Agreement__c agreement:newAgreementMap.values())
		{		
			if(agreement.ChangeManagerApprovedForSynch__c == true && oldAgreementMap.get(agreement.Id).ChangeManagerApprovedForSynch__c == false)
			{
				if(agreement.AgreementNumber__c == null)
				{
					projectIds.add(agreement.Project__c);
					agreementsWithNoProjectNumber.add(agreement);
				}
			}	
		}
		
		if(!agreementsWithNoProjectNumber.isEmpty())
		{
			map<Id, pse__Proj__c> projectMap = new map<Id, pse__Proj__c>([select Id, OracleProjectNumber__c from pse__Proj__c where Id in :projectIds]);
			for(Agreement__c agreement:agreementsWithNoProjectNumber)
			{
				if(projectMap.get(agreement.Project__c).OracleProjectNumber__c == null)
				{
					agreement.addError('This agreement is associated to Project that does not have an Oracle Project Number.  Please get an Oracle Project Number before proceeding with Synch!');
				}
				else
				{
					agreement.AgreementNumber__c = projectMap.get(agreement.Project__c).OracleProjectNumber__c + '-' + String.ValueOf(agreement.ProjectAgreementRecordCount__c);
				}
			}	
		}					
	}
	
	public static void calculateTaskOrderValueForMSA(list<Agreement__c> agreements)
	{
		if (!ECO_TriggerSettings.getIsTriggerEnabled('AGREEMENT_CalcMSAValue')) {
			return;
		}
		
		set<Id> msaAgreementIds = new set<Id>();
		
		for(Agreement__c agreement:agreements)
		{
			if(agreement.IsTaskOrder__c && agreement.MSAReference__c != null)
				msaAgreementIds.add(agreement.MSAReference__c);				
		}
		
		if(msaAgreementIds.size() > 0)
		{		
			map<Id, list<Agreement__c>> msaTaskOrderMap = new map<Id, list<Agreement__c>>();
			for(Agreement__c taskOrder:[select Id, Amount__c, MSAReference__c, FundingCurrencyCode__c from Agreement__c where MSAReference__c in :msaAgreementIds and IsTaskOrder__c = true])
			{
				if(msaTaskOrderMap.get(taskOrder.MSAReference__c) == null)
					msaTaskOrderMap.put(taskOrder.MSAReference__c, new list<Agreement__c>());
				msaTaskOrderMap.get(taskOrder.MSAReference__c).add(taskOrder);		
			}

			Decimal totalMSAValue = 0;
			list<Agreement__c> msaAgreements = [select Id, FundingCurrencyCode__c, TotalTaskOrdersValue__c from Agreement__c where Id in :msaAgreementIds];
			for(Agreement__c msaAgreement:msaAgreements)
			{
				for(Agreement__c taskOrder:msaTaskOrderMap.get(msaAgreement.Id))
				{
					if(msaAgreement.FundingCurrencyCode__c != taskOrder.FundingCurrencyCode__c)
						totalMSAValue += taskOrder.Amount__c * ECO_Service_ExchangeRate.getExchangeRate(taskOrder.FundingCurrencyCode__c, msaAgreement.FundingCurrencyCode__c, Date.today());
					else
						totalMSAValue += taskOrder.Amount__c;
				}
				msaAgreement.TotalTaskOrdersValue__c =	totalMSAValue;	
			}
			if(msaAgreements.size() > 0)
				update msaAgreements;
		} 		
	}
}
//					agreement.addError('This agreement is associated to Project that does not have an Oracle Project Number.  Please get an Oracle Project Number before proceeding with Synch');