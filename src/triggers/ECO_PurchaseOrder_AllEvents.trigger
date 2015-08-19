trigger ECO_PurchaseOrder_AllEvents on POHeader__c (after insert) {
    
    Id userId = UserInfo.getUserId();
/*
	if(trigger.isBefore && trigger.isInsert){
		
    	//auto approve po if submitted by PM
    	for(POHeader__c poHeader : trigger.new){
    		if(userId == poHeader.ProjectManager__c){
    			poHeader.Status__c = 'APPROVED';
    		}else{
    			poHeader.Status__c = 'Pending';
    		} 		
    	}
	}

    if(trigger.isAfter && trigger.isInsert){
    	
    	//auto approve po if submitted by PM
    	for(POHeader__c poHeader : trigger.new){
    		if(userId == poHeader.ProjectManager__c){
    			ECO_Service_PurchaseOrders.submitForApproval(poHeader, userId);
    		}    		
    	}
    }
*/
    
}