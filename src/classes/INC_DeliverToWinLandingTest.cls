@isTest
private class INC_DeliverToWinLandingTest {
	
	@isTest static void test_method_one() {

        IncentiveProject__c incentiveProject = INC_Utils_Testing.createIncentiveProject();
        insert incentiveProject;
        System.assertNotEquals(incentiveProject.Id, Null);
        
        EnrollmentPlan__c ePlan = INC_Utils_Testing.createEnrollmentApplication(incentiveProject);
        insert ePlan;
        System.assertNotEquals(ePlan.Id, Null);
        
        list<IncentiveProject__c> lstIP = new list<IncentiveProject__c>();
        lstIP.add(INC_Utils_Testing.createIncentiveProject());
        lstIP.add(INC_Utils_Testing.createIncentiveProject());
        lstIP.add(INC_Utils_Testing.createIncentiveProject());
        lstIP.add(INC_Utils_Testing.createIncentiveProject());
        lstIP.add(INC_Utils_Testing.createIncentiveProject());
        lstIP.add(INC_Utils_Testing.createIncentiveProject());

        for(IncentiveProject__c ip: lstIP){
        	ip.EnrollmentPlan__c = ePlan.id;
        }

        insert lstIP;

        Contact employee = INC_Utils_Testing.createEmployee();
        insert employee;
        System.assertNotEquals(employee.Id, Null);
        
        EnrollmentParticipant__c ePart = INC_Utils_testing.createEnrollmentParticipant(ePlan, employee);
        insert ePart;

		list<ParticipantAcknowledgement__c> lpa = new list<ParticipantAcknowledgement__c>();
		lpa.add(new ParticipantAcknowledgement__c(ParticipantID__c = ePart.id));
		lpa.add(new ParticipantAcknowledgement__c(ParticipantID__c = ePart.id));
		lpa.add(new ParticipantAcknowledgement__c(ParticipantID__c = ePart.id));
		lpa.add(new ParticipantAcknowledgement__c(ParticipantID__c = ePart.id));
		lpa.add(new ParticipantAcknowledgement__c(ParticipantID__c = ePart.id));
		lpa.add(new ParticipantAcknowledgement__c(ParticipantID__c = ePart.id));
		lpa.add(new ParticipantAcknowledgement__c(ParticipantID__c = ePart.id));

		insert(lpa);


		INC_DeliverToWinLandingController ctr = new INC_DeliverToWinLandingController();

		system.assertEquals(ctr.lstApprovalItemShortPA.size(), 5);
		system.assertEquals(ctr.lstIPShort.size(), 5);

		ctr.more();
		system.assertEquals(ctr.bMore, true);

		ctr.less();
		system.assertEquals(ctr.bMore, false);

		ctr.moreAck();
		system.assertEquals(ctr.bMoreAck, true);

		ctr.lessAck();
		system.assertEquals(ctr.bMoreAck, false);

		ctr.moreProj();
		system.assertEquals(ctr.bMoreProj, true);

		ctr.lessProj();
		system.assertEquals(ctr.bMoreProj, false);
	}

	
}