@isTest
private class ECO_Service_EarnedValueTest {

    static testMethod void sCurveTest () {
        Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;
		
		Contact testContact = new Contact();
		testContact.AccountId = testAccount.Id;
		testContact.RecordTypeId = ECO_Utils_Meta.getRecordTypeId(Contact.sObjectType, ECO_Constants.Contact_PSAResourceRecordTypeName);
		testContact.LastName = 'test last';
		testContact.pse__Is_Resource_Active__c = true;
		testContact.pse__Is_Resource__c = true;
		insert testContact;
		
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.pse__Account__c = testAccount.Id;
		insert testProject;
		
		pse__Project_Task__c projTask = new pse__Project_Task__c();
		projTask.pse__Project__c = testProject.Id;
		projTask.EarnedValueCurve__c = 'S Curve';
		projTask.pse__Start_Date_Time__c = Date.today();
		projTask.pse__End_Date_Time__c = Date.today().addDays(21); // 3 weeks
		projTask.TotalApprovedCost__c = 10000;
		
		test.startTest();
		insert projTask;
		test.stopTest();
		
		List<EarnedValueSnapshot__c> evsAfterTest = [SELECT Id FROM EarnedValueSnapshot__c];
		system.assertEquals(false, evsAfterTest.isEmpty());
    }
    
    static testMethod void frontLoadedTest () {
        Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;
		
		Contact testContact = new Contact();
		testContact.AccountId = testAccount.Id;
		testContact.RecordTypeId = ECO_Utils_Meta.getRecordTypeId(Contact.sObjectType, ECO_Constants.Contact_PSAResourceRecordTypeName);
		testContact.LastName = 'test last';
		testContact.pse__Is_Resource_Active__c = true;
		testContact.pse__Is_Resource__c = true;
		insert testContact;
		
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.pse__Account__c = testAccount.Id;
		insert testProject;
		
		pse__Project_Task__c projTask = new pse__Project_Task__c();
		projTask.pse__Project__c = testProject.Id;
		projTask.EarnedValueCurve__c = 'Front Loaded';
		projTask.pse__Start_Date_Time__c = Date.today();
		projTask.pse__End_Date_Time__c = Date.today().addDays(21); // 3 weeks
		projTask.TotalApprovedCost__c = 10000;
		
		test.startTest();
		insert projTask;
		test.stopTest();
		
		List<EarnedValueSnapshot__c> evsAfterTest = [SELECT Id FROM EarnedValueSnapshot__c];
		system.assertEquals(false, evsAfterTest.isEmpty());
    }
    
    static testMethod void backLoadedTest () {
        Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;
		
		Contact testContact = new Contact();
		testContact.AccountId = testAccount.Id;
		testContact.RecordTypeId = ECO_Utils_Meta.getRecordTypeId(Contact.sObjectType, ECO_Constants.Contact_PSAResourceRecordTypeName);
		testContact.LastName = 'test last';
		testContact.pse__Is_Resource_Active__c = true;
		testContact.pse__Is_Resource__c = true;
		insert testContact;
		
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.pse__Account__c = testAccount.Id;
		insert testProject;
		
		pse__Project_Task__c projTask = new pse__Project_Task__c();
		projTask.pse__Project__c = testProject.Id;
		projTask.EarnedValueCurve__c = 'Back Loaded';
		projTask.pse__Start_Date_Time__c = Date.today();
		projTask.pse__End_Date_Time__c = Date.today().addDays(21); // 3 weeks
		projTask.TotalApprovedCost__c = 10000;
		
		test.startTest();
		insert projTask;
		test.stopTest();
		
		List<EarnedValueSnapshot__c> evsAfterTest = [SELECT Id FROM EarnedValueSnapshot__c];
		system.assertEquals(false, evsAfterTest.isEmpty());
    }
    
    static testMethod void bellShapedTest () {
        Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;
		
		Contact testContact = new Contact();
		testContact.AccountId = testAccount.Id;
		testContact.RecordTypeId = ECO_Utils_Meta.getRecordTypeId(Contact.sObjectType, ECO_Constants.Contact_PSAResourceRecordTypeName);
		testContact.LastName = 'test last';
		testContact.pse__Is_Resource_Active__c = true;
		testContact.pse__Is_Resource__c = true;
		insert testContact;
		
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.pse__Account__c = testAccount.Id;
		insert testProject;
		
		pse__Project_Task__c projTask = new pse__Project_Task__c();
		projTask.pse__Project__c = testProject.Id;
		projTask.EarnedValueCurve__c = 'Bell Shaped';
		projTask.pse__Start_Date_Time__c = Date.today();
		projTask.pse__End_Date_Time__c = Date.today().addDays(21); // 3 weeks
		projTask.TotalApprovedCost__c = 10000;
		
		test.startTest();
		insert projTask;
		test.stopTest();
		
		List<EarnedValueSnapshot__c> evsAfterTest = [SELECT Id FROM EarnedValueSnapshot__c];
		system.assertEquals(false, evsAfterTest.isEmpty());
    }
    
    static testMethod void evenTest () {
        Account testAccount = new Account();
		testAccount.Name = 'test account';
		insert testAccount;
		
		Contact testContact = new Contact();
		testContact.AccountId = testAccount.Id;
		testContact.RecordTypeId = ECO_Utils_Meta.getRecordTypeId(Contact.sObjectType, ECO_Constants.Contact_PSAResourceRecordTypeName);
		testContact.LastName = 'test last';
		testContact.pse__Is_Resource_Active__c = true;
		testContact.pse__Is_Resource__c = true;
		insert testContact;
		
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.pse__Account__c = testAccount.Id;
		insert testProject;
		
		pse__Project_Task__c projTask = new pse__Project_Task__c();
		projTask.pse__Project__c = testProject.Id;
		projTask.EarnedValueCurve__c = 'Even';
		projTask.pse__Start_Date_Time__c = Date.today();
		projTask.pse__End_Date_Time__c = Date.today().addDays(21); // 3 weeks
		projTask.TotalApprovedCost__c = 10000;
		
		test.startTest();
		insert projTask;
		test.stopTest();
		
		List<EarnedValueSnapshot__c> evsAfterTest = [SELECT Id FROM EarnedValueSnapshot__c];
		system.assertEquals(false, evsAfterTest.isEmpty());
    }
}