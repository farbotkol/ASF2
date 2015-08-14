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
	
}