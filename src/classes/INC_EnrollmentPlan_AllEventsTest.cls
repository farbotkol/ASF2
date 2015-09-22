@isTest
private class INC_EnrollmentPlan_AllEventsTest {
    
    static testMethod void testCreateParticipantAcknowledgement() {
        IncentiveProject__c incentiveProject = INC_Utils_Testing.createIncentiveProject();
        insert incentiveProject;
        System.assertNotEquals(incentiveProject.Id, Null);
        
        EnrollmentPlan__c ePlan = INC_Utils_Testing.createEnrollmentApplication(incentiveProject);
        insert ePlan;
        System.assertNotEquals(ePlan.Id, Null);
        
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