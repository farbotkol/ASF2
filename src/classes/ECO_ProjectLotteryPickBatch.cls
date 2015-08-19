global class ECO_ProjectLotteryPickBatch implements Database.Batchable<sObject>{

	private String query = 'select Id, Name, clAECOMProjectReviewCategory__c, pse__Project_Manager__r.User__c, Project_Manager_User__c, TotalForecastRevenue__c, TotalApprovedRevenue__c from pse__Proj__c where isActive__c = true and (clAECOMProjectReviewCategory__c != null or clAECOMProjectReviewCategory__c !=\'\')';
	
    global Database.QueryLocator start(Database.BatchableContext projectLotteryBatchContext)
    {   
    	System.Debug(LoggingLevel.Info, 'Query ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext projectLotteryBatchContext, list<pse__Proj__c> projects)
    {  	
    	system.debug('Projects Size' + projects.size());
    	list<pse__Proj__c> monthlyPerformanceReviews = new list<pse__Proj__c>();
    	list<pse__Proj__c> quarterlyPerformanceReviews = new list<pse__Proj__c>();
    	list<pse__Proj__c> lotteryPerformanceReviews = new list<pse__Proj__c>();
    	   	
    	map<Id, pse__Proj__c> projectMap = new map<Id, pse__Proj__c>();
    	for(pse__Proj__c project:projects)
    	{
    		if(project.clAECOMProjectReviewCategory__c == 'C-0' || project.clAECOMProjectReviewCategory__c == 'C-1')
    		{
    			monthlyPerformanceReviews.add(project);
    		}
    		else if((project.clAECOMProjectReviewCategory__c == 'C-2' || project.clAECOMProjectReviewCategory__c == 'C-3') && (project.TotalForecastRevenue__c > 500000) && ((project.TotalForecastRevenue__c - project.TotalApprovedRevenue__c) > 100000))
    		{
    			monthlyPerformanceReviews.add(project);
    		}
    		else
    			lotteryPerformanceReviews.add(project);    		
    	}

		Id recordTypeId = ECO_Utils_Meta.getRecordTypeId(ProjectReview__c.sObjectType, 'Project Performance Review');

    	list<ProjectReview__c> projectReviews = new list<ProjectReview__c>();
    	ProjectReview__c projectReview;
    	for(pse__Proj__c project:monthlyPerformanceReviews)
    	{
    		projectReview = new ProjectReview__c(Project__c = project.Id, RecordTypeId = recordTypeId);
    		projectReviews.add(projectReview);
    	}

    	for(pse__Proj__c project:quarterlyPerformanceReviews)
    	{
    		projectReview = new ProjectReview__c(Project__c = project.Id, RecordTypeId = recordTypeId);
    		projectReviews.add(projectReview);
    	}    	
		//C-2
		Integer c2ReviewCount = Integer.valueOf(lotteryPerformanceReviews.size() * .10);
		System.Debug(LoggingLevel.DEBUG, 'c2ReviewCount' + c2ReviewCount);
		for(Integer index:randomWithLimit(lotteryPerformanceReviews.size(), Integer.valueOf(lotteryPerformanceReviews.size() * .10)))
		{
			System.Debug(LoggingLevel.DEBUG, 'index' + index);
			projectReview = new ProjectReview__c(Project__c = lotteryPerformanceReviews.get(index).Id, RecordTypeId = recordTypeId);
			projectReviews.add(projectReview);
			System.Debug(LoggingLevel.DEBUG,projectReviews.size());
		}

    	system.debug(LoggingLevel.DEBUG, 'Projects Size' + projectReviews.size());
    	if(projectReviews.size() > 0)
    		insert projectReviews;   	   	

	}
	
	private set<Integer> randomWithLimit(Integer upperLimit, Integer numberOfRands)
	{
   		set<Integer> selected = new set<Integer>();
   		for (Integer i =0; i< numberOfRands; i++){
      		Integer rand = Math.mod(Math.round(Math.random()*1000), upperLimit);
      	selected.add(rand);
    	}
    	
    	System.Debug('selected' + selected.size());
 		return selected;
	}
   
    
    global void finish(Database.BatchableContext projectLotteryBatchContext)
    {   	    	
        system.debug('Batch completed');
    }    
}