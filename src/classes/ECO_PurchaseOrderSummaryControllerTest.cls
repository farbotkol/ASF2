@isTest
private class ECO_PurchaseOrderSummaryControllerTest{

    private static final Integer numTestProjectTasks = 10;	
	private static final Integer numTeamMembers = 1;

	static testMethod void testMissingUrlParams(){
		PageReference pageRef = new PageReference('/apex/ECO_PurchaseOrderSummary');
		test.setCurrentPage(pageRef);
		ECO_PurchaseOrderSummaryController con = new ECO_PurchaseOrderSummaryController(new ApexPages.StandardController(new POHeader__c()));
		system.assertEquals(true, con.hideEverything);	//flag to not display any of the form

	}



    static testMethod void testCreateNewPurchaseOrder() {
    	createTestData();
    	
		pse__Proj__c testProject = [SELECT Id, Name, pse__Account__c, pse__Project_Manager__c FROM pse__Proj__c LIMIT 1];
		testProject.pse__Project_Manager__r = null;
		update testProject;

		Agreement__c agreement = [SELECT Id, VendorName__c FROM Agreement__c WHERE Project__c = :testProject.Id];

		VendorSite__c vendor = [SELECT Id, Site__c, Site__r.PaymentTerms__c FROM VendorSite__c WHERE Project__c = :testProject.Id];

		List<pse__Project_Task__c> tasks = [SELECT Id FROM pse__Project_Task__c WHERE pse__Project__c = :testProject.Id];

    	PageReference pageRef = new PageReference('/apex/ECO_PurchaseOrderSummary');
		pageRef.getParameters().put('projectId', testProject.Id);    	
		pageRef.getParameters().put('agreementId', agreement.Id); 

    	test.setCurrentPage(pageRef);

    	ECO_PurchaseOrderSummaryController con = new ECO_PurchaseOrderSummaryController(new ApexPages.StandardController(new POHeader__c()));


    	//check params were processed and objects retrieved
    	system.assertEquals(true, con.showCreateAndSubmitForApproval);	//new purchase order 
    	system.assertEquals(false, con.allowRequestSubmit);	//flag that allow line items to be added
    	system.assertEquals(testProject.Id, con.poHeader.Project__c );
    	system.assertEquals(agreement.Id, con.poHeader.Agreement__c);
    	

    	system.debug('project pm = ' + testProject.pse__Project_Manager__c);

    	//test vendor is available
    	system.assertEquals(1, con.optSelectProjectSites.size());	

    	//json should be empty
    	system.assertEquals(true, String.isEmpty(con.sJSON));
    	
    	//verify other 
		system.assertEquals(true, con.validPOLineItems.isEmpty()); 
		system.assertEquals(true, con.invalidPOLineItems.isEmpty()); 

		system.assertEquals(false, con.hasBeenApproved);
		system.assertEquals(false, con.hasSyncHistory);
		system.assertEquals(false, con.hasSyncHistory);

		//test set vendor
		SelectOption vendorOpt = con.optSelectProjectSites.get(0);

		con.selProjectSiteId = vendorOpt.getValue();
		con.getDefaultPaymentTermsForVendor();
		system.assertEquals(vendor.Site__r.PaymentTerms__c, con.poHeader.PaymentTerm__c);

		PageReference pageRefAfterSave = con.updatePurchaseOrder();

		test.setCurrentPage(pageRefAfterSave);


		

		POHeader__c poHeader = [SELECT Id FROM POHeader__c WHERE Project__c = :testProject.Id];

		POLineItem__c poLineItem = new POLineItem__c();
		//poLineItem.ProjectTask__c = tasks.get(0).Id;
		poLineItem.POHeader__c = poHeader.Id;
		poLineItem.LineNumber__c = 1;
		poLineItem.LineType__c = 'Fixed Fee';
		poLineItem.UnitofMeasure__c = 'Lump SUm';

		insert poLineItem;

		ECO_PurchaseOrderSummaryController con2 = new ECO_PurchaseOrderSummaryController(new ApexPages.StandardController(poHeader));

/*
		//test save - should get set to approval appending since current user is not pm

	    PageReference savePageRef =	con.saveAndSubmitForApproval();

	    system.assertNotEquals(null, savePageRef);

	    POHeader__c poHeaderAfterSave = [SELECT Id, Status__c, PaymentTerm__c, Requestor__c, VendorSite__c, Project__c, Agreement__c
	    									FROM POHeader__c
	    									WHERE Project__c = :testProject.Id];

	    system.assertEquals('Pending', poHeaderAfterSave.Status__c);
*/

		poLineItem.ProjectTask__c = tasks.get(0).Id;
		update poLineItem;

		con2.validatePOLineItems();

		//test add po line item
		PageReference poLineItemPageRef = con2.gotoPOLineItemPage();


		con2.initiateOracleSyncRequest();


		con2.executeOracleSyncRequest();



		con2.cancelPurchaseOrder();

		con2.closeOutPurchaseOrder();

		PageReference projectPageRef = con2.returnToProject();

		con2.createMessageQueueRecord_start();

		con2.createMessageQueueRecord_complete();

		con2.sendPOSyncRequest_start();

		con2.sendPOSyncRequest_complete();

		con2.sendPOSyncRequest_Finish();

		con2.checkIfSyncHasBeenProcessed();

    }


    static void createTestData(){
    	//create account and project
		ECO_Utils_Testing.createTestDataForProjectSync(numTestProjectTasks, numTeamMembers);
		pse__Proj__c testProject = [SELECT Id, pse__Account__c FROM pse__Proj__c];

    	//create a vendor
    	Account vendor = new Account();
		vendor.Name = 'test vendor';

		insert vendor;

		Site__c site = new Site__c();
		site.Account__c = vendor.Id;
		site.PaymentTerms__c = 'Immediate';
		site.VendorSiteID__c  = '123456';
		insert site;

		VendorSite__c vendorSite = new VendorSite__c();
		vendorSite.Site__c = site.Id;
		vendorSite.Project__c = testProject.Id;

		insert vendorSite;

		//create an agreement
		Agreement__c agreement = new Agreement__c();		
		agreement.Project__c = testProject.Id;
		agreement.Account__c = testProject.pse__Account__c;
		insert agreement;
    }
}