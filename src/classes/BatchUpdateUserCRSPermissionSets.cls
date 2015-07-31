global class BatchUpdateUserCRSPermissionSets implements Database.Batchable<sObject>{

	global Database.querylocator start(Database.BatchableContext BC){
		if (Test.isRunningTest())
		{
			
            return Database.getQueryLocator('Select id , u.Nationality__c From User u where isActive = true LIMIT 1');
		}
		else
		{
			 return Database.getQueryLocator('SELECT  ID, name, Geography_Allocation__c, ProfileId , u.Nationality__c FROM USER u ' +
													'WHERE ID NOT IN  ' +
													'( ' +
													'Select AssigneeId ' +
													'From PermissionSetAssignment ' +
													'where PermissionSet.Name like \'%Contract%\') ' +
													'and isActive = true ' +
													'and ProfileId  not in ( \'00e30000001YHnrAAG\', \'00e30000001YZfqAAG\')');
		}            		
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
	   try {
		    List<User> user = new List<User>();
		
		   for(sObject s : scope){
		   		User a = (User)s;
		   		if (a.Nationality__c == ''){
			    	a.Nationality__c= '.';
	           	 	user.add(a);
		   		}
	        }
		
		   update user;
	   } 
	   catch(Exception e){}
	}
	
	global void finish(Database.BatchableContext BC){
	
	}
}