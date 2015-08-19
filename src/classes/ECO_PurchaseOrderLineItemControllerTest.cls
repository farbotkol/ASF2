@isTest
private class ECO_PurchaseOrderLineItemControllerTest{

	private static final Integer numTestProjectTasks = 10;	
	private static final Integer numTeamMembers = 1;


	static testMethod void testCreateAndUpdatePurchaseOrderLineItem() {
		ECO_Utils_Testing.createTestDataForProjectSync(numTestProjectTasks, numTeamMembers);
		pse__Proj__c testProject = [SELECT Id, pse__Account__c FROM pse__Proj__c];

		POHeader__c poHeader = new POHeader__c();
		poHeader.Project__c = testProject.Id;
		insert poHeader;

		PageReference pageRef = new PageReference('/apex/ECO_PurchaseOrderLineItem');
		pageRef.getParameters().put('poHeaderId', poHeader.Id);
		pageRef.getParameters().put('projectId', testProject.Id);

		test.setCurrentPage(pageRef);

		ECO_PurchaseOrderLineItemController con = new ECO_PurchaseOrderLineItemController(new ApexPages.StandardController(new POLineItem__c()));

		system.assertEquals(10, con.projectTasks.size());

        con.currentPOLineItem.LineDescription__c = 'test';
        con.currentPOLineItem.ExpenditureType__c = 'SUBC-Land Survey';
		con.currentPOLineItem.LineType__c = 'Unit Rate';
    	con.currentPOLineItem.LineNumber__c = 1;
    	con.currentPOLineItem.Quantity__c = 1;
    	con.currentPOLineItem.UnitPrice__c = 99.99;
    	con.currentPOLineItem.ProjectTask__c = con.projectTasks.get(0).Id;
        con.currentPOLineItem_TaskId = String.valueOf(con.projectTasks.get(0).Id);

    	PageReference savePageRef = con.saveCurrentPOLineItem();

    	POLineItem__c savedPOLineItem = [SELECT Id, LineType__c, LineNumber__c, Quantity__c, UnitPrice__c, ProjectTask__c, Amount__c
    										FROM POLineItem__c
    										WHERE POHeader__c = :poHeader.Id];

    	system.assertEquals(savedPOLineItem.LineType__c, 'Unit Rate');
    	system.assertEquals(savedPOLineItem.LineNumber__c, 1);
    	system.assertEquals(savedPOLineItem.Quantity__c, 1);
    	system.assertEquals(savedPOLineItem.UnitPrice__c, 99.99);
    	system.assertEquals(savedPOLineItem.ProjectTask__c, con.projectTasks.get(0).Id);
    	system.assertEquals(savedPOLineItem.Amount__c, 99.99);

    	PageReference editPageRef = new PageReference('/apex/ECO_PurchaseOrderLineItem');
    	editPageRef.getParameters().put('id',savedPOLineItem.Id);
    	test.setCurrentPage(editPageRef);

    	ECO_PurchaseOrderLineItemController con2 = new ECO_PurchaseOrderLineItemController(new ApexPages.StandardController(savedPOLineItem));

    	con2.currentPOLineItem.Quantity__c = 2;
    	savePageRef = con2.saveCurrentPOLineItem();

    	savedPOLineItem = [SELECT Id, LineType__c, LineNumber__c, Quantity__c, UnitPrice__c, ProjectTask__c, Amount__c
    										FROM POLineItem__c
    										WHERE POHeader__c = :poHeader.Id];

    	system.assertEquals(2, savedPOLineItem.Quantity__c);

    	savedPOLineItem.OracleSyncDateTime__c = Date.today();
    	update savedPOLineItem;

    	//test change request

    	ECO_PurchaseOrderLineItemController con3 = new ECO_PurchaseOrderLineItemController(new ApexPages.StandardController(savedPOLineItem));
    	con3.currentPOLineItem.Quantity__c = 3;
    	savePageRef = con3.saveCurrentPOLineItem();

    	List<POLineItem__c> poLineItems = [SELECT Id FROM POLineItem__c WHERE POHeader__c = :poHeader.Id];
    	system.assertEquals(2, poLineItems.size());

    	savePageRef = con3.cancelPurchaseOrderLineItem();

    	savedPOLineItem.OracleSyncDateTime__c = null;
    	update savedPOLineItem;

    	savePageRef = con3.cancelPurchaseOrderLineItem();

    	PageReference backPageRef = con3.returnToPurchaseOrder();

    }

   static testMethod void testCreateNewControllerInstance() {
		ECO_Utils_Testing.createTestDataForProjectSync(numTestProjectTasks, numTeamMembers);
		pse__Proj__c testProject = [SELECT Id, pse__Account__c FROM pse__Proj__c];

		POHeader__c poHeader = new POHeader__c();
		poHeader.Project__c = testProject.Id;
		insert poHeader;

		PageReference pageRef = new PageReference('/apex/ECO_PurchaseOrderLineItem');
		pageRef.getParameters().put('poHeaderId', poHeader.Id);
		pageRef.getParameters().put('projectId', testProject.Id);

		test.setCurrentPage(pageRef);

		ECO_PurchaseOrderLineItemController con = new ECO_PurchaseOrderLineItemController();

	}

}