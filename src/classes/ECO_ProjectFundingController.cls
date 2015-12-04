public class ECO_ProjectFundingController {
    
    String projectId = '';
    String agreementId = '';
    public Boolean creatingNewFunding {get; set;}
    public Id taskId {get; set;}
    public boolean topTask {get; set;}
    public Id fundingToDelete {get; set;}
    
    public list<pse__Project_Task__c> projectTasks {get; set;}
    
    public map<Id, list<Funding>> projectTasksFundedMap {get; set;}
    public map<Id, list<Funding>> projectTasksFundedAllAgreementsMap {get; set;}
    public map<Id, Decimal> projectTasksFundingTotalsMap {get; set;}
    public map<Id, pse__Project_Task__c> projectTasksMap {get; set;}
    private map<Id, String> projectTaskOriginalCurrencyMap;

    public list<Funding> projectLevelFunding {get; set;}
     
    public Funding__c newFunding {get; set;}

    public Agreement__c agreement {get; set;}
    public pse__Proj__c project {get; set;}

    public Decimal agreementFundingAllocation {get; set;}
    
    private set<Id> changedTasks = new set<Id>();
    
    public ECO_ProjectFundingController()
    {

    }
    
    public PageReference init()
    {
        creatingNewFunding = false;
        projectId = ApexPages.currentPage().getParameters().get('ProjectId');
        agreementId = ApexPages.currentPage().getParameters().get('AgreementId');
        
        if(projectId != null)
        {
            project = [select Id, Name, TotalApprovedRevenue__c, TotalForecastRevenue__c, ProjectLevelFundingFlag__c, ProjectCurrencyCode__c, isSegmented__c, SegmentationStatus__c, ProjectFunctionalCurrencyCode__c, EnableTopTaskCustomerFlag__c, DistributionRule__c, OUID__c  from pse__Proj__c where Id = :projectId];
        }
        else
        {
            list<ProjectAgreement__c> projectAgreements = [select Id, Agreement__c, Project__c from ProjectAgreement__c where Agreement__c = :agreementId];
            project = [select Id, Name, ProjectLevelFundingFlag__c, TotalApprovedRevenue__c, CurrencyIsoCode, TotalForecastRevenue__c, isSegmented__c, SegmentationStatus__c, ProjectCurrencyCode__c, ProjectFunctionalCurrencyCode__c, EnableTopTaskCustomerFlag__c, DistributionRule__c, OUID__c from pse__Proj__c where Id = :projectAgreements[0].Project__c];
            //topTask = project.EnableTopTaskCustomerFlag__c;
        }
        agreement = [select Id, Name, Amount__c, Account__c, Description__c, ChangeManagerIsNew__c, TotalApprovedRevenueLimit__c, UnallocatedFunding__c, FundingCurrencyCode__c, CurrencyIsoCode, ActionCode__c, Account__r.Name, TotalFundingAmount__c from Agreement__c where Id = :agreementId];
        
        if(!project.ProjectLevelFundingFlag__c)
        {
            initializeProjectTaskLevelFundingProjectTasks();
        	initializeProjectTaskLevelFundingLines();
        }
        else
            initializeProjectLevelFunding();    
        
        AggregateResult[]  projectAgreementAllocations = [select Agreement__c agreement, sum(AllocatedAmount__c) allocationAmount, sum(TotalBaselinedAmount__c) allocationAmount2 from Funding__c where Agreement__c = :agreementId group by Agreement__c];             
        if(projectAgreementAllocations.size() > 0)
        {
            if((Decimal)projectAgreementAllocations[0].get('allocationAmount2') != null && (Decimal)projectAgreementAllocations[0].get('allocationAmount') != null)
                agreementFundingAllocation = (Decimal)projectAgreementAllocations[0].get('allocationAmount') + (Decimal)projectAgreementAllocations[0].get('allocationAmount2');
            else if((Decimal)projectAgreementAllocations[0].get('allocationAmount2') != null)
                agreementFundingAllocation =  (Decimal)projectAgreementAllocations[0].get('allocationAmount2');
            else if((Decimal)projectAgreementAllocations[0].get('allocationAmount') != null)
                agreementFundingAllocation =  (Decimal)projectAgreementAllocations[0].get('allocationAmount');
            else
                agreementFundingAllocation = 0;
        }       
        else
            agreementFundingAllocation = 0;
            
        return null;
        
    }

    public void deleteFundingApex()
    {
        list<Funding__c> fundingsToDelete = [select Id from Funding__c where Id = :fundingToDelete];
        
        System.Debug('BrentBrentBrentfundingsize' + fundingsToDelete.size());
        if(!fundingsToDelete.isEmpty())
        {
            System.Debug('BrentBrentBrentfundingsize' + fundingsToDelete.size());
            delete fundingsToDelete;
        }

        if(!project.ProjectLevelFundingFlag__c)
        {
            initializeProjectTaskLevelFundingProjectTasks();
            initializeProjectTaskLevelFundingLines();            
        }

        if(project.ProjectLevelFundingFlag__c)
        {
            initializeProjectLevelFunding();
        }

        agreement = [select Id, Name, Amount__c, Account__c, Description__c, FundingCurrencyCode__c, ChangeManagerIsNew__c, TotalApprovedRevenueLimit__c, UnallocatedFunding__c, ActionCode__c, Account__r.Name, TotalFundingAmount__c from Agreement__c where Id = :agreementId];
        //System.Debug('BrentBrentBrentfundingsize2' + projectLevelFunding.size());
        //PageReference pageRef = new PageReference('/apex/ECO_ProjectFunding');
        //pageRef.getParameters().put('AgreementId', agreement.Id);
        //pageRef.getParameters().put('ProjectId', project.Id);
        //pageRef.setRedirect(true);
        //return pageRef;
        //return null;
    }    
    
    private void initializeProjectLevelFunding()
    {
        //projectLevelFunding = new list<Funding__c>();
        projectLevelFunding = new list<Funding>();
        for(Funding__c funding:[select Id, ChangeManagerIsNew__c, ProjectTask__c, Notes__c, Agreement__r.Name, Agreement__r.Account__c, Agreement__c, AllocatedAmount__c, DateAllocatedDate__c, FundingClassification__c, ProjFuncRateType__c, ProjFuncRateExchangeRate__c, ProjFuncRateDate__c, TotalBaselinedAmount__c, CreatedDate, ChangeManagerIsChanged__c, ChangeManagerApprovedForSynch__c from Funding__c where Agreement__c = :agreementId and Project__c = :projectId])
        {
            projectLevelFunding.add(new Funding(false, funding, true));
        }
    }
    
    private void initializeProjectTaskLevelFundingProjectTasks()
    {
        projectTasks = [select Id, Name, pse__Project__c, TotalApprovedCost__c, TopTaskOwningCustomer__c, TopTaskOwningCustomer__r.Name, TopTaskOwningCustomer__r.Account_Name__c, TotalFunding__c, CurrencyIsoCode, ProjectTaskNUmber__c from pse__Project_Task__c where pse__Project__c = :projectId and IsTopLevelTask__c = true];
        projectTasksFundedMap = new map<Id, list<Funding>>();
        projectTasksFundedAllAgreementsMap = new map<Id, list<Funding>>();
        projectTasksFundingTotalsMap = new map<Id, Decimal>();
        projectTaskOriginalCurrencyMap = new map<Id, String>();
        projectTasksMap = new map<Id, pse__Project_Task__c>();
        
        for(pse__Project_Task__c projectTask: projectTasks)
        {
            if(projectTasksFundedMap.get(projectTask.Id) == null)
            {
                projectTasksFundedMap.put(projectTask.Id, new list<Funding>());
                projectTasksFundedAllAgreementsMap.put(projectTask.Id, new list<Funding>());
                projectTasksFundingTotalsMap.put(projectTask.Id, 0);
                projectTaskOriginalCurrencyMap.put(projectTask.Id, projectTask.CurrencyIsoCode);
                projectTasksMap.put(projectTask.Id, projectTask);
            }           
        }
    }
    
    private void initializeProjectTaskLevelFundingLines()    
    {
        for(Funding__c funding:[select Id, ProjectTask__c, ChangeManagerIsNew__c, Notes__c, Agreement__r.Name, Agreement__r.Account__c, Agreement__c, AllocatedAmount__c, DateAllocatedDate__c, FundingClassification__c, ProjFuncRateType__c, ProjFuncRateExchangeRate__c, ProjFuncRateDate__c, TotalBaselinedAmount__c, CreatedDate, ChangeManagerApprovedForSynch__c, ChangeManagerIsChanged__c  from Funding__c where ProjectTask__c in :projectTasks])
        {
        	if(funding.Agreement__c == agreement.Id)
        	{
            	projectTasksFundedMap.get(funding.ProjectTask__c).add(new Funding(false, funding, true));
            	projectTasksmap.get(funding.ProjectTask__c).CurrencyIsoCode = agreement.CurrencyIsoCode;
            	if(projectTasksMap.get(funding.ProjectTask__c).TotalFunding__c == null)
       				projectTasksMap.get(funding.ProjectTask__c).TotalFunding__c = funding.AllocatedAmount__c;  
       			else
       			 	projectTasksMap.get(funding.ProjectTask__c).TotalFunding__c += funding.AllocatedAmount__c;          	
        	}
            projectTasksFundedAllAgreementsMap.get(funding.ProjectTask__c).add(new Funding(false, funding, true));
        }
        
        //AggregateResult[] projectTaskAllocations = [select ProjectTask__c task, sum(AllocatedAmount__c) allocationAmount, sum(TotalBaselinedAmount__c) allocationAmount2 from Funding__c where ProjectTask__c in :projectTasks and Agreement__c = :agreementId group by ProjectTask__c];             
        //for(AggregateResult projectTaskAllocation:projectTaskAllocations)
        //{
        //    if((Decimal)projectTaskAllocation.get('allocationAmount2') != null)
        //    {
        //        projectTasksFundingTotalsMap.put((Id)projectTaskAllocation.get('task'), (Decimal)projectTaskAllocation.get('allocationAmount')  + (Decimal)projectTaskAllocation.get('allocationAmount2') ); 
		//		projectTasksmap.get((ID)projectTaskAllocation.get('task')).CurrencyIsoCode = agreement.CurrencyIsoCode;
        //    	projectTasksMap.get((Id)projectTaskAllocation.get('task')).TotalFunding__c = (Decimal)projectTaskAllocation.get('allocationAmount')  + (Decimal)projectTaskAllocation.get('allocationAmount2');	
        //    }
        //    else
        //    {
       //         projectTasksFundingTotalsMap.put((Id)projectTaskAllocation.get('task'), (Decimal)projectTaskAllocation.get('allocationAmount'));

        //    }
        //}
               
    }
    
    public void taskChanged()
    {
        taskId = Apexpages.currentPage().getParameters().get('taskId');
        changedTasks.add(taskId);
    }
    
    public PageReference createFunding()
    {
        creatingNewFunding = true;

        if(!project.ProjectLevelFundingFlag__c)
        {
            taskId = Apexpages.currentPage().getParameters().get('taskId').substring(0,18);

            if(!project.isSegmented__c && projectTasksFundedMap.get(taskId).size() == 0)
            {
            	list<Funding__c> projectFundings = [select Id from Funding__c where Agreement__c = :agreementId and ProjectTask__c != :taskId];
           		if(projectFundings.size() > 0)
           		{
           			ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill out a Segment questionnaire for Projects that have multiple tasks!');
            		ApexPages.addMessage(oPageMessage);
            		return null;
           		}        			
            }
            	
            newFunding = new Funding__c(ProjectTask__c = taskId, Agreement__c = agreementId, Project__c = projectId, ChangeManagerApprovedForSynch__c = false, ChangeManagerIsChanged__c = true);
            projectTasksFundedMap.get(newFunding.ProjectTask__c).add(new Funding(true, newFunding, false));
        }
        else
        {
            newFunding = new Funding__c(Agreement__c = agreementId, Project__c = projectId, ChangeManagerApprovedForSynch__c = false, ChangeManagerIsChanged__c = true);
        	projectLevelFunding.add(new Funding(true, newFunding, false));
        }
            
        return null;
    }
    
    public PageReference returnToAgreement()
    {
        return new PageReference('/' + agreementId);        
    }

    public PageReference returnToProject()
    {
        return new PageReference('/' + projectId);
    }
    
    public PageReference save()
    {               
        list<Funding__c> fundingRecordsToBeSaved = new list<Funding__c>();
        //TotalApprovedRevenueLimit__c
        //TotalFundingAmount__c
        try
        {
                               
            if(project.ProjectLevelFundingFlag__c)
            {
                if(projectLevelFunding != null)
                {
                    for(Funding f:projectLevelFunding)
                    {
                    	if(f.newFunding)
                    	{
                            if(agreement.TotalApprovedRevenueLimit__c < (agreement.TotalFundingAmount__c + f.funding.AllocatedAmount__c))
                            {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The total funding amount is greater than the Agreements Total Approved Revenue Limit'));
                                return null;    
                            }
    						f.funding.CurrencyIsoCode = agreement.FundingCurrencyCode__c;   
                        	f.funding.ProjFuncRateType__c = 'Spot';
                        	f.funding.ProjFuncRateDate__c = f.funding.DateAllocatedDate__c;
                            f.funding.ChangeManagerIsNew__c = true;
                        	f.funding.ProjFuncRateExchangeRate__c = ECO_Service_ExchangeRate.getExchangeRate(agreement.FundingCurrencyCode__c, project.ProjectFunctionalCurrencyCode__c, f.funding.DateAllocatedDate__c);                	
                        	f.newFunding = false;
                        	fundingRecordsToBeSaved.add(f.funding);
                        	agreementFundingAllocation = agreementFundingAllocation + f.funding.AllocatedAmount__c; 
                    	}
                    	//handles allowing you to change rates
                        else if(!f.newFunding && !f.rateLocked)
                    	{
                    		fundingRecordsToBeSaved.add(f.funding); 
                            f.rateLocked = true;
                    	}
                    	//only synch approvals
                        else if(!f.newFunding && f.rateLocked && f.funding.ChangeManagerApprovedForSynch__c)    
                        {
                        	fundingRecordsToBeSaved.add(f.funding);     
                        } 
                    }
                }
            }
            else
            {
                if(projectTasksFundedMap != null)
                {
                    for(list<Funding> fundings:projectTasksFundedMap.values())
                    {
                        for(Funding f:fundings)
                        {
                            //handles first time you save funding.  this will save and pull back exchange rate.  will be allowed to save once more before funding is locked
                            if(f.newFunding)
                            {
                                if(agreement.TotalApprovedRevenueLimit__c < (agreement.TotalFundingAmount__c + f.funding.AllocatedAmount__c))
                                {
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The total funding amount is greater than the Agreements Total Approved Revenue Limit'));
                                    return null;    
                                }
                                f.funding.CurrencyIsoCode = agreement.FundingCurrencyCode__c;   
                                f.funding.ProjFuncRateType__c = 'Spot';
                                f.funding.ProjFuncRateDate__c = f.funding.DateAllocatedDate__c;
                                f.funding.ChangeManagerIsNew__c = true;
                                f.funding.ProjFuncRateExchangeRate__c = ECO_Service_ExchangeRate.getExchangeRate(agreement.FundingCurrencyCode__c, project.ProjectFunctionalCurrencyCode__c, f.funding.DateAllocatedDate__c);
                                fundingRecordsToBeSaved.add(f.funding); 
                                f.newFunding = false;   
                                
                                if(projectTasksMap.get(f.funding.ProjectTask__c).TotalFunding__c == null)
                                	projectTasksMap.get(f.funding.ProjectTask__c).TotalFunding__c = f.funding.AllocatedAmount__c;
                                else
                                	projectTasksMap.get(f.funding.ProjectTask__c).TotalFunding__c += f.funding.AllocatedAmount__c; 
                            }
                            //handles allowing you to change rates
                            else if(!f.newFunding && !f.rateLocked)
                            {
                                fundingRecordsToBeSaved.add(f.funding); 
                                f.rateLocked = true;
                            }
                            //only synch approvals
                            else if(!f.newFunding && f.rateLocked && f.funding.ChangeManagerApprovedForSynch__c)    
                            {
                                fundingRecordsToBeSaved.add(f.funding);     
                            }   
                        }           
                    }           
                }
                pse__Project_Task__c taskToUpdate;
                if(changedTasks.size() > 0)
                {
                    for(Id taskId: changedTasks)
                    {
                        taskToUpdate = projectTasksMap.get(taskId);
                        taskToUpdate.CurrencyISOCode = projectTaskOriginalCurrencyMap.get(taskId);
                        update taskToUpdate;            
                    }           
                }
                //initializeProjectTaskLevelFunding();          
            }
            
            if(fundingRecordsToBeSaved.size() > 0)
                upsert fundingRecordsToBeSaved;
            update project;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
                
        if(!project.ProjectLevelFundingFlag__c && (changedTasks.size() > 0 || fundingRecordsToBeSaved.size() == 0))
        {
            initializeProjectTaskLevelFundingProjectTasks();
            initializeProjectTaskLevelFundingLines();            
        }

        if(project.ProjectLevelFundingFlag__c && fundingRecordsToBeSaved.size() == 0)
        {
            initializeProjectLevelFunding();
        }

		agreement = [select Id, Name, Amount__c, Account__c, Description__c, ChangeManagerIsNew__c, TotalApprovedRevenueLimit__c, FundingCurrencyCode__c, UnallocatedFunding__c, ActionCode__c, Account__r.Name, TotalFundingAmount__c from Agreement__c where Id = :agreementId];
                
        creatingNewFunding = false; 

        return null;                
    }
    
    private Decimal getExchangeRate()
    {
        if(agreement.FundingCurrencyCode__c == project.ProjectFunctionalCurrencyCode__c)
            return 1;
        else
        {
            //Decimal rate1 = convertToOrgCurrency(agreement.FundingCurrencyCode__c, 1, newFunding.DateAllocatedDate__c);
            //Decimal rate2 = convertFromOrgCurrency(project.ProjectFunctionalCurrencyCode__c, rate1, newFunding.DateAllocatedDate__c);
            return 0;
        }       
    }
    
    public PageReference cancel()
    {
    	if(project.ProjectLevelFundingFlag__c)
    	{
    		for(Integer i = 0; i < projectLevelFunding.size(); i++)
    		{
    			if(projectLevelFunding[i].newFunding)
    				projectLevelFunding.remove(i);
    		}
    	}   	
    	else
    	{
        	for(list<Funding> fundings:projectTasksFundedMap.values())
        	{
            	Integer fundingCount = 0;
            	for(Integer i = 0; i < fundings.size(); i++)
            	{               
                	if(fundings[i].newFunding)
                    	fundings.remove(i);         
            	}
        	}
    	}
        creatingNewFunding = false;
        return null;
    }
        
    public PageReference launchSegmentationQuestionnaire()
    {
    	PageReference pageRef = new PageReference('/apex/ECO_ProjectSegmentation');
    	
    	pageRef.getParameters().put('AgreementId', agreement.Id);
    	pageRef.getParameters().put('Id', agreement.Id);
    	pageRef.getParameters().put('ProjectId', project.Id);
    	pageRef.getParameters().put('save_new', '1');
    	pageRef.getParameters().put('sfdc.override', '1');
    	
    	return pageRef;
    }
    
    public class Funding{
        public boolean newFunding {get; set;}
        public boolean rateLocked {get; set;}
        public Funding__c funding {get; set;}
        
        public Funding(boolean newFunding, Funding__c funding, boolean rateLocked)
        {
            this.newFunding = newFunding;
            this.funding = funding;
            this.rateLocked = rateLocked;
        }
    }   
}