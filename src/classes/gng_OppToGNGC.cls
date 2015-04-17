/*************************************************************************
*
* PURPOSE: Creating/Modifying Go/No-Go records based on Opportunity
*
* CLASS: gng_OppToGNGC
* CREATED: 10/15/2014 Ethos Solutions - www.ethos.com
* AUTHOR: Raghuveer Mandali
***************************************************************************/
public with sharing class gng_OppToGNGC {
	//Field map for Opp field => GNG field
	private static final Map<String, List<String>> ANZFieldMap = new Map<String, List<String>>{
		'CurrencyIsoCode' => new List<String>{'CurrencyIsoCode'},
		'Go_Probability__c' => new List<String>{'Market_Position_Q11__c'},
		'Probability_Stage__c' => new List<String>{'Market_Position_Q12__c'},
		'Construction_cost__c' => new List<String>{'Capital_Value__c'},
		'Project_DirectorUser__c' => new List<String>{'Project_Director__c', 'Bid_Director__c'},
		'Project_Director_EMEA__c' => new List<String>{'Project_Director__c'},
		'Capture_Manager_User__c' => new List<String>{'Bid_Manager__c', 'Project_Manager__c'},
		'Date_RFP_expected__c' => new List<String>{'RFT_Issue_Date__c'},
		'Estimated_work_start_date__c' => new List<String>{'Project_Start_Date__c'},
		//Removed mapping per AEGNG-133
		//'CloseDate' => 'Proposal_Due_Date__c',
		'Work_end_date_del__c' => new List<String>{'Project_Duration__c'},
		'Net_Revenue_To_Project__c' => new List<String>{'Staff_Time_FBLR_Fee__c'},
		'Business_Line_of_Primary_AECOM_Dept__c' => new List<String>{'Business_Line__c'},
		'Net_Revenue_Program__c' => new List<String>{'Net_Revenue_Program__c'},
		'Net_Revenue_TO_Project__c' => new List<String>{'Net_Revenue_TO_Project__c'},
		'B_P_Budget__c' => new List<String>{'Bid_Proposal_Budget__c'},
		'Account_Manager__c' => new List<String>{'Account_Manager__c'}
	};

	public static Set<Id> hasRanOpp = new Set<Id>();

	//Creating new Go/No-Go records from opportunites
	public static void createGNGFromOpportunity(Map<String, List<Opportunity>> oppMap) {
		List<RecordType> recordTypes = [select Id, Name from RecordType where sObjectType = 'Go_No_Go_Conversation__c'];
		Map<String, RecordType> recordTypeMap = new Map<String, RecordType>();
		List<Go_No_Go_Conversation__c> gng = new List<Go_No_Go_Conversation__c>();
		Set<Id> oppIds = new Set<Id>();

		for(List<Opportunity> oppList : oppMap.values()) {
			for(Opportunity o : oppList) {
				oppIds.add(o.Id);
			}
		}

		for(RecordType r : recordTypes) recordTypeMap.put(r.Name, r);
		for(String region : oppMap.keySet()) {
			for(Opportunity o : oppMap.get(region)) {
				if(hasRanOpp.contains(o.Id)) continue;
				Go_No_Go_Conversation__c newGNG = new Go_No_Go_Conversation__c();
				if(region == 'ANZ') newGNG.RecordTypeId = recordTypeMap.get('ANZ Why Go').Id;
				else if(region == 'North America') newGNG.RecordTypeId = recordTypeMap.get('Americas GNG').Id;
				else if(region == 'Europe') newGNG.RecordTypeId = recordTypeMap.get('Europe GNG').Id;
				else if(region == 'Asia' || region == 'Africa' || region == 'Middle East') newGNG.RecordTypeId = recordTypeMap.get('View Only').Id;
				newGNG.Opportunity__c = o.Id;
				newGNG.Client_Name__c = o.AccountId;
				newGNG.Subs_Fee__c = o.Subs_Other_Revenue__c;
				newGNG.Subs_Cost__c = o.Subs_Other_Revenue__c;
				newGNG.Project_Scope_Summary__c = o.Description;
				setFields(newGNG, o);
				hasRanOpp.add(o.Id);
				gng.add(newGNG); 
			}
		}
		insert gng;
	}

	//update existing Go/No-Go records
	public static void updateGNGFromOpportunity(Map<String, Opportunity> oppMap) {
    	Set<String> ids = oppMap.keySet();
    	String query = buildQueryString('Go_No_Go_Conversation__c')+ ', RecordType.Name' + ' from Go_No_Go_Conversation__c where Opportunity__c in: ids';
		Map<Id,Id> gngIdsToPD = new Map<Id,Id>();
		List<Go_No_Go_Conversation__c> gngsToUpdate = new List<Go_No_Go_Conversation__c>();
		Set<Id> lockedGNGs = new Set<Id>();
		gng_ApprovalProcessDao appDao = gng_ApprovalProcessDao.getInstance();

		Map<Id,Task> existingUserTask = new Map<Id,Task>();
		List<Task> tasks = new List<Task>();

		for(Go_No_Go_Conversation__c g : (List<Go_No_Go_Conversation__c>)Database.query(query)) {
			
			if(compareFields(g, oppMap.get(g.Opportunity__c))) {
				if(g.Approval_Status__c != 'Submitted for Approval - Pending') {
					gngsToUpdate.add(setFields(g, oppMap.get(g.Opportunity__c)));
				}
				else {
					if(appDao.recallWorkItem(g.Id, 'Recalling to Update')) lockedGNGs.add(g.Id);
					gngsToUpdate.add(setFields(g, oppMap.get(g.Opportunity__c)));
				}	
			}
			if(!gngIdsToPD.containsKey(g.Id) && !oppMap.get(g.Opportunity__c).StageName.startsWith('1') && !oppMap.get(g.Opportunity__c).StageName.startsWith('8') && !oppMap.get(g.Opportunity__c).StageName.startsWith('7') && !oppMap.get(g.Opportunity__c).StageName.startsWith('9') && g.RecordType.Name == 'Europe GNG' && g.Decision__c != 'Go' && g.Decision__c != 'No-Go') gngIdsToPD.put(g.Id,g.Project_Director__c);

		}
		update gngsToUpdate;
		for(Id gngId : lockedGNGs) appDao.submitApprovalProcess(gngId, 'Resubmitting for approval');
		for(Task t : [Select OwnerId,WhatId,Subject from Task where OwnerId IN: gngIdsToPD.values() AND WhatId IN: gngIdsToPD.keySet() AND Subject =: 'Opportunity has reached Stage 2 and Go/No Go record has not been approved or rejected.']) {
			existingUserTask.put(t.WhatId,t);
		}
		for(Id gngId : gngIdsToPD.keySet()) {
			Task existTask = existingUserTask.get(gngId);
			if(String.isNotBlank(gngIdsToPD.get(gngId)) // Checks if Opp has a PD
				&& (existTask == null ||  //Checks if there exists a Task already for OPP
					(existTask != null && existTask.OwnerId != gngIdsToPD.get(gngId)) // Checks if existing task matches Project director
			    )){
				tasks.add(createGNGTask(gngIdsToPD.get(gngId),gngId));
			}
		}
		insert tasks;
	}

	//delete existing Go/No-Go records
	public static void deleteGNGFromOpportunity(Set<Id> oppIds) {
		delete [select Id,Name from Go_No_Go_Conversation__c where Opportunity__c in: oppIds];
	}

	//set ANZ fields (TODO: update to encompass all regions)
	private static Go_No_Go_Conversation__c setFields(Go_No_Go_Conversation__c g, Opportunity o) {
		for(String oppField : ANZFieldMap.keySet()) {
			if(oppField == 'Project_DirectorUser__c' && (o.Geography_Formula__c == 'Europe' || o.Geography_Formula__c == 'Middle East' || o.Geography_Formula__c == 'Africa')) continue;
			else {
				for(String gngField : ANZFieldMap.get(oppField)) {
					g.put(gngField, o.get(oppField));
				}
			}
		}
		return g;
	} 

	//compares the fields between GNG and Opp to see if we need to update the GNG record
	private static Boolean compareFields(Go_No_Go_Conversation__c g, Opportunity o) {
		Boolean isUpdate = false;
		for(String oppField : ANZFieldMap.keySet()) {
			if(oppField == 'Project_DirectorUser__c' && (o.Geography_Formula__c == 'Europe' || o.Geography_Formula__c == 'Middle East' || o.Geography_Formula__c == 'Africa')) continue;
			else {
				for(String gngField : ANZFieldMap.get(oppField)) {
					if(g.get(gngField) != o.get(oppField)) isUpdate = true;
				}
			}
		}
		return isUpdate;
	}

	//build query string
	private static String buildQueryString(String objectName){
		SObjectType objToken = Schema.getGlobalDescribe().get(objectName);
    	DescribeSObjectResult objDef = objToken.getDescribe();
    	String fieldList = String.join(new List<String>(objDef.fields.getMap().keySet()), ',').toLowerCase();

    	return 'select ' + fieldList;
	}

	private static Task createGNGTask(Id ownerId, Id gngId) {
		Task newTask = new Task();
		newTask.Subject = 'Opportunity has reached Stage 2 and Go/No Go record has not been approved or rejected.';
		newTask.Status = 'Not Started';
		newTask.Priority = 'Normal';
		newTask.Type = 'Other';
		newTask.ActivityDate = Date.today();
		newTask.OwnerId = ownerId;
		newTask.WhatId = gngId;
		return newTask;
	}
}