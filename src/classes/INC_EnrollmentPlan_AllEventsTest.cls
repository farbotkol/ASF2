@isTest
private class INC_EnrollmentPlan_AllEventsTest {
    
    static testMethod void testCreateParticipantAcknowledgement() {
         
        ECO_TriggerSettings__c setting = new ECO_TriggerSettings__c();
        setting.Name = 'INC_IncentiveProject_AllEvents';
        setting.isEnabled__c = true;
        insert setting;

        ECO_TriggerSettings__c setting2 = new ECO_TriggerSettings__c();
        setting2.Name = 'INC_EnrollmentPlan_AllEvents';
        setting2.isEnabled__c = true;
        insert setting2;
        
        User oUser = INC_Utils_Testing.createUser();
        oUser.Email = '3' + oUser.email;
        oUser.UserName = oUser.UserName + '3';
        oUser.CommunityNickname = oUser.CommunityNickname + '3';
        oUser.FederationIdentifier = oUser.FederationIdentifier + '3';
        oUser.OracleEmployeeId__c = oUser.OracleEmployeeId__c + '3';
        oUser.TrackingID__c = oUser.TrackingID__c + '3';
        oUser.URS_FIM_GUID__c = oUser.URS_FIM_GUID__c + '3';
        insert oUser;
        
        map<string, User> mUsers = new map<string, User>();
        
        mUsers.put('Approver1', oUser);
        mUsers.put('Approver2', oUser);
        mUsers.put('Approver3', oUser);
        mUsers.put('DTW Admin', oUser);
        
        //Inser routing rules master data
        map<string, RoutingMember__c> mRoutingMember = INC_Utils_Testing.createRoutingMemberRules(mUsers);
        
        insert mRoutingMember.values();
        
        list<IncentivePlanTemplate__c> lPlanTemplates = INC_Utils_Testing.createIncentivePlan();
        
        insert lPlanTemplates;
        
        IncentivePlanTemplate__c oIncentivePlanTemplate = lPlanTemplates[0];

        //END: Setup Master Data
        
        //Initialize starting position
        IncentiveProject__c oIncentiveProject = INC_Utils_Testing.createIncentiveProject_TownAndCountry();
        
        //To Do: Implement RunAs for integration administrator user
        insert oIncentiveProject;
        
        //Find and Assign DTW Admin (Assume Batch Job is Run)
        INC_Service_Matching Inc_Match = new INC_Service_Matching();
        list<IncentiveProject__c> lIncentiveProjectsToInsert = Inc_Match.FindDTWAdmin(new list<IncentiveProject__c>{oIncentiveProject});
        
        update lIncentiveProjectsToInsert;
        
        //Check if DTW Admin was assigned
        list<IncentiveProject__c> lAssertCheck = new list<IncentiveProject__c>([SELECT Id, DTWAdmin__c FROM IncentiveProject__c WHERE Id = :oIncentiveProject.Id]);
        System.AssertEquals(lAssertCheck.get(0).DTWAdmin__c, oUser.Id);
        
        //User interacts with page and assigns project manager
        oIncentiveProject.ProjectManager__c = oUser.Id;
        
        //User hits save button
        update oIncentiveProject;
        
        //User interacts with button on incentive project to generate enrollment app
        INC_IncentiveProjectCreateEnrollment.createEnrollmentForm(oIncentiveProject.Id);

        //Check if Enrollment Plan was created
        list<EnrollmentPlan__c> lAssertCheckEnrollment = new list<EnrollmentPlan__c>([SELECT Id
                                                                                      FROM EnrollmentPlan__c WHERE IncentiveProject__c = :oIncentiveProject.Id]);
        System.Assert(lAssertCheckEnrollment.size() > 0);

        EnrollmentPlan__c ePlan;
        ePlan = INC_Service_EnrollmentPlan.getEnrollmentPlan(new set<id>{lAssertCheckEnrollment[0].Id})[0];

        
        Contact employee = INC_Utils_Testing.createEmployee();
        insert employee;
        System.assertNotEquals(employee.Id, Null);
        
        EnrollmentParticipant__c ePart = INC_Utils_testing.createEnrollmentParticipant(ePlan, employee);
        insert ePart;
        System.assertNotEquals(ePart.Id, Null);
        ePart = [SELECT Id, EmployeeName__r.Email, EmployeeName__r.pse__Salesforce_User__c, EmployeeName__r.pse__Salesforce_User__r.ManagerId, EmployeeStatus__c, TargetIncentivePoolAllocated__c, EnrollmentPlan__c 
				 FROM EnrollmentParticipant__c WHERE Id = :ePart.Id];
        System.assertEquals(ePart.EnrollmentPlan__c, ePlan.Id);
        System.assertEquals(ePart.EmployeeStatus__c, 'Active');
        System.assertEquals(ePart.TargetIncentivePoolAllocated__c, 25);
        
        List<EnrollmentParticipant__c> eParts = [SELECT Id, EmployeeName__r.Email, EmployeeName__r.pse__Salesforce_User__c, EmployeeName__r.pse__Salesforce_User__r.ManagerId, EmployeeStatus__c, TargetIncentivePoolAllocated__c, EnrollmentPlan__c 
                                             	 FROM EnrollmentParticipant__c 
                                             	 WHERE EnrollmentPlan__c =: ePlan.Id AND EmployeeStatus__c = 'Active' AND TargetIncentivePoolAllocated__c > 0];
        System.debug('eParts: ' + eParts);
        System.assertEquals(eParts.size(), 1);
        
        System.assertEquals(ePlan.EnrollmentStatus__c, 'Pending PM Action');
        Test.startTest();
      
        ePlan.EnrollmentStatus__c = 'Enrolled';
        System.Debug(logginglevel.error,'updateing Eplan ' + ePlan);
        // This is being done because for some reason the Test.startTest is not starting a new context and the it's not letting the code run.
        INC_EnrollmentPlanTriggers.afterRun = true;
        update ePlan;
        
        ePlan = [SELECT Id, EnrollmentStatus__c FROM EnrollmentPlan__c WHERE Id =:ePlan.Id];
        System.assertEquals(ePlan.EnrollmentStatus__c, 'Enrolled');
        
        List<EnrollmentParticipant__c> eParts2 = [SELECT Id, EmployeeName__r.Email, EmployeeName__r.pse__Salesforce_User__c, EmployeeName__r.pse__Salesforce_User__r.ManagerId, EmployeeStatus__c, TargetIncentivePoolAllocated__c, EnrollmentPlan__c 
                                             	 FROM EnrollmentParticipant__c 
                                             	 WHERE EnrollmentPlan__c =: ePlan.Id AND EmployeeStatus__c = 'Active' AND TargetIncentivePoolAllocated__c > 0];
        System.debug('eParts2: ' + eParts2);
        System.assertEquals(eParts2.size(), 1);
        
        List<ParticipantAcknowledgement__c> pA = [SELECT Id, RecordTypeId, OwnerId, Manager__c, ParticipantID__c FROM ParticipantAcknowledgement__c WHERE ParticipantID__c =: ePart.Id];
        System.assertEquals(pA.size(), 1);
        System.assertEquals(pA[0].recordTypeId, Schema.SObjectType.ParticipantAcknowledgement__c.getRecordTypeInfosByName().get('Sent').getRecordTypeId());
        System.assertEquals(pA[0].OwnerId, employee.pse__Salesforce_User__c);
        System.assertNotEquals(pA[0].Manager__c, Null);
        Test.stopTest();
    }
}