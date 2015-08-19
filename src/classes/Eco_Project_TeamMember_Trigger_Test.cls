@isTest (seeAllData=false) 

private class Eco_Project_TeamMember_Trigger_Test {

    	static testMethod void testCreateSharingForTeamMembers(){

		User testUser = ECO_Utils_Testing.createTestUser('System Administrator');
		
		insert testUser;
                        
            ECO_Utils_Testing.createTestDataForProjectSync( 2, 2 );
            
            /*Project__c p = new Project__c();
            p.Name = 'Proj';
            p.ownerId = testUser.id;
            insert p;*/
            
            pse__Proj__c projectOne = ECO_Utils_Testing.createTestProject('Project One');
            Insert projectOne;
            
            list<ProjectTeamMember__c> lptm = [select id from ProjectTeamMember__c];
            
            system.debug( 'lp size ' + lptm.size() );

            for(ProjectTeamMember__c p : lptm)
            {
                //p.Active__c = false;
                p.EndDate__c = Date.today().addDays(-4);
                p.StartDate__c = Date.today().addDays(-14);
            }
            
            update lptm;
            
            BatchDeleteProjectSharing myBatchObject = new BatchDeleteProjectSharing();
            Database.executeBatch(myBatchObject);            
            
            //ProjectTeamMember__c tm1 = new ProjectTeamMember__c();
            //insert tm1;
        }
}