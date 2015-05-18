/*******************************************************************
  Name        :   User_ContractReviewPermissionSet
  Requester   :   CRS Requirments
  Author      :   AECOM - Luke Farbotko
  Version     :   1.0 
  Purpose     :   1. Add 'Contract_Reviewer' permision set if 'legal' flag is 
  					checked on the user
  				  2. remove 'Contract_Reviewer' permision set if 'legal' flag is 
  					unchecked on the user
  					
  				  3. Give all users access via 	'Contract Reviewer General User (SF)' 
  				     or 'Contract Reviewer General User' Permission set

  				  4. Give all users 'ECO Portal access' Permission set
  				     
  Date        :   17 Feb, 2015 

  Update : 5 May 2015 - add eco permissions sets.

********************************************************************/
trigger User_ContractReviewPermissionSet on User (after update) {
	if(StaticHelper.runME==true ){
		if (Test.isRunningTest())
		{
			
			StaticHelper.runME = !StaticHelper.excludeIt;
		}
	    // one query to reduce the number of SOQL Hits
		list<PermissionSet>  permissionSets = [Select id, Name From PermissionSet 
								where name in ('Contract_Reviewer','Contract_Reviewer_SF'
												,'Contract_Reviewer_General_User' , 'Contract_Reviewer_General_User_SF', 'ECOPortalaccess') 
												order by Name];
	
		PermissionSet permissionSet = permissionSets[0];
		PermissionSet permissionSetSF = permissionSets[3];
		
		PermissionSet generalPermissionSet = permissionSets[1];
		PermissionSet generalPermissionSetSF = permissionSets[2];

		PermissionSet ecoPermissionSetSF = permissionSets[4];
	
		
		//PermissionSet permissionSet = [Select id, Name From PermissionSet where name = 'Contract_Reviewer' LIMIT 1];
		//PermissionSet permissionSetSF = [Select id, Name From PermissionSet where name = 'Contract_Reviewer_SF' LIMIT 1];
		
		//PermissionSet generalPermissionSet = [Select id, Name From PermissionSet where name = 'Contract_Reviewer_General_User' LIMIT 1];
		//PermissionSet generalPermissionSetSF = [Select id, Name From PermissionSet where name = 'Contract_Reviewer_General_User_SF' LIMIT 1];
		
		List<Id> userListIdsInsert = new List<Id>();
		List<Id> userlistIdsRemove = new List<Id>();
		
		List<Id> generalUserListIdsInsert = new List<Id>();
		List<Id> ecoUserListIdsInsert = new List<Id>();

		//List<Id> generalUserlistIdsRemove = new List<Id>();
		
		//List<Id> userlistIdsRemove = new List<Id>();
	
		List<PermissionSetAssignment>  permissionSetAssignmentToUpdate = new List<PermissionSetAssignment>{};
		
		
		for(User user: Trigger.new){
			//Detirmine if we are removing or adding the permission set for each user
			User oldUser = Trigger.oldMap.get(user.ID);
			//if (user.Legal__c != oldUser.Legal__c || user.profile != oldUser.profile )
			//{
				if (user.Legal__c == true )
	   			{
	   				userListIdsInsert.add(user.Id);
	   			}
	   			else
	   			{
	   				// add to list of users to remove the permision set from 
	   				userlistIdsRemove.add(user.Id);
	   			}
	   			generalUserListIdsInsert.add(user.Id);
	   			ecoUserListIdsInsert.add(user.Id);
			//}
			
			
		}
		
		List<User> userListToInsert  = new  List<User>([SELECT id, profile.UserLicense.Name
			     										 FROM User
			     										 WHERE id IN :userListIdsInsert
			     										 	AND 
			     										 	 id not in (Select  AssigneeId From PermissionSetAssignment 
			     										 	 			where (PermissionSetId = :permissionSet.Id
																     			 OR PermissionSetId = :permissionSetSF.Id)
																     			 and AssigneeId IN :userListIdsInsert
																     	)]);	
																     	
																     	
		List<User> generalUserListToInsert  	= 		new  List<User>([SELECT id, profile.UserLicense.Name
			     										 FROM User
			     										 WHERE id IN :generalUserListIdsInsert
			     										 	AND 
			     										 	 id not in (Select  AssigneeId From PermissionSetAssignment 
			     										 	 			where (PermissionSetId = :generalPermissionSet.Id
																     			 OR PermissionSetId = :generalPermissionSetSF.Id)
																     			 and AssigneeId IN :generalUserListIdsInsert
																     	)]);			

		List<User> ecoUserListToInsert  	= 		new  List<User>([SELECT id, profile.UserLicense.Name
			     										 FROM User
			     										 WHERE id IN :ecoUserListIdsInsert
			     										 	AND 
			     										 	 id not in (Select  AssigneeId From PermissionSetAssignment 
			     										 	 			where PermissionSetId = :ecoPermissionSetSF.Id
																			and AssigneeId IN :ecoUserListIdsInsert
																     	)]);									     	
		
		for(User user : userListToInsert)
		{
	   		PermissionSetAssignment psa = new PermissionSetAssignment( AssigneeId = user.Id);
	   		if (user.profile.UserLicense.Name == 'salesforce' )
	   		{
	   			psa.PermissionSetId = permissionSetSF.Id;
	   		}
	   		else
	   		{
	   			psa.PermissionSetId = permissionSet.Id;
	   		}
	   		permissionSetAssignmentToUpdate.add(psa);
	   		
	   		
		}
		
		for(User user : generalUserListToInsert)
		{
	   		PermissionSetAssignment psa = new PermissionSetAssignment( AssigneeId = user.Id);
	   		if (user.profile.UserLicense.Name == 'salesforce' )
	   		{
	   			psa.PermissionSetId = generalPermissionSetSF.Id;
	   		}
	   		else
	   		{
	   			psa.PermissionSetId = generalPermissionSet.Id;
	   		}
	   		permissionSetAssignmentToUpdate.add(psa);
		}

		for(User user : ecoUserListToInsert)
		{
	   		PermissionSetAssignment psa = new PermissionSetAssignment( AssigneeId = user.Id);
	   	
	   		psa.PermissionSetId = ecoPermissionSetSF.Id;
	   		
	   		
	   		permissionSetAssignmentToUpdate.add(psa);
		}
		
		
		
		
	    List<PermissionSetAssignment> permissionSetAssignmentToRemove  = new  List<PermissionSetAssignment>([SELECT id
																     										 FROM PermissionSetAssignment
																     										 WHERE (PermissionSetId = :permissionSet.Id
																     										 OR PermissionSetId = :permissionSetSF.Id
																     										 ) and AssigneeId IN :userlistIdsRemove]);
		
		System.enqueueJob(new UserPermissionAssignmentUpdateQueue(permissionSetAssignmentToRemove,permissionSetAssignmentToUpdate));
		//delete permissionSetAssignmentToRemove;
		//insert permissionSetAssignmentToUpdate;
		
	}


}