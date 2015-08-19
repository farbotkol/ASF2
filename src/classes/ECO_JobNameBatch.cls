global class ECO_JobNameBatch implements Database.Batchable<sObject> {
	
	String query;
	
	global ECO_JobNameBatch() {
		query = 'select id, JobName__c from Contact where JobName__c != null';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Contact> scope) {
		Map<String, ECO_Job_Name__c> jobNameMap = ECO_Job_Name__c.getAll();

		Set<String> oldJobNames = new Set<String>();

		Integer highest = 0;

		for (ECO_Job_Name__c jobName : jobNameMap.values()) {
			oldJobNames.add(jobName.name__c);

			Integer current = Integer.valueOf(jobName.name);

			if (current > highest)
				highest = current;
		}

		Set<String> newJobNames = new Set<String>();

		for (Contact con : scope) {
			if (con.JobName__c.trim().equals(''))
				continue;

			if (oldJobNames.contains(con.JobName__c))
				continue;

			newJobNames.add(con.JobName__c);
		}

		Integer i = highest + 1;

		List<ECO_Job_Name__c> jobNameList = new List<ECO_Job_Name__c>();

		for (String jobNameString : newJobNames) {
			ECO_Job_Name__c jobName = new ECO_Job_Name__c();

			jobName.name = String.valueOf(i);
			jobName.name__c = jobNameString;

			jobNameList.add(jobName);

			i++;
		}

		upsert jobNameList;
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}