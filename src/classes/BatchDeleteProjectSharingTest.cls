@isTest

public class BatchDeleteProjectSharingTest {
    
    static testMethod void TestBatchDeleteProjectSharing()
    {
        
        User testUser = ECO_Utils_Testing.createTestUser('System Administrator');
		
		insert testUser;
                        
        ECO_Utils_Testing.createTestDataForProjectSync( 2, 2 );
        
    	BatchDeleteProjectSharing myBatchObject = new BatchDeleteProjectSharing();
		Database.executeBatch(myBatchObject);
	}    
}