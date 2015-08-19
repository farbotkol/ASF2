public without sharing class INC_Utils_Testing {
	
	public static OrganizationString__c createTestOrg(){
		return ECO_Utils_Testing.createTestOrg();
	}

	public static IncentiveProject__c createIncentiveProject(){
		Integer randomNumber = Integer.valueOf(Math.random()*1000);
		IncentiveProject__c Test_IncentiveProject = new IncentiveProject__c();
		Test_IncentiveProject.Name = 'MP' + randomNumber +'-PM CENTRAL SERVICE';
		Test_IncentiveProject.CustomerName__c = 'REGIONAL MUNICIPALITY OF YORK';
		
		return Test_IncentiveProject;
	}

	public static User createTestUser(String sProfileName){
		return ECO_Utils_Testing.createTestUser(sProfileName);
	}
 
	public static RoutingMember__c createRoutingMember(User DTW_Admin){
		RoutingMember__c member = new RoutingMember__c();
		member.DTWAdmin__c = DTW_Admin.ID;
		return member;
	}

	public static Group createPublicGroup(String sName){
		Group grp = new Group(Name=sName,
							  Type='Regular',
							  DeveloperName=sName.Replace(' ','_'));
		return grp;
	}

	public static list<OrganizationString__c> createOrganizationString(){

		List<OrganizationString__c> lOrgStrings = new List<OrganizationString__c>();
		OrganizationString__c Org1 = INC_Utils_Testing.createTestOrg();
		OrganizationString__c Org2 = INC_Utils_Testing.createTestOrg();
		Org1.Name = Org1.OrganizationName__c;
		Org1.Region__c = 'Test Region';

		Org2.OrganizationName__c = 'Water Organization';
		Org2.Name = 'Water Organization';
		Org2.BusinessLineName__c = 'Water';
		Org2.Department__c = 'Water Department';
		Org2.District__c = 'Water District';
		Org2.Description__c = 'Water org string';
		Org2.GeographyName__c = 'Water Geo';
		Org2.Region__c = 'Water Region';
		Org2.OrgID__c = '227';
		Org2.OUID__c = '999';

		return new list<OrganizationString__c>{Org1,Org2};

	}
    
    /**
     * This method is responsible for creating test Enrollment Application record
     */
    public static EnrollmentPlan__c createEnrollmentApplication(IncentiveProject__c incentiveProject) {
        EnrollmentPlan__c eP = new EnrollmentPlan__c();
        eP.RecordTypeId = Schema.SObjectType.EnrollmentPlan__c.getRecordTypeInfosByName().get('Edit Application').getRecordTypeId();
        eP.IncentiveProject__c = incentiveProject.Id;
        eP.Name = 'Test Enrollment Plan';
        eP.CurrencyIsoCode = 'USD';
        eP.EnrollmentStatus__c = 'Pending PM Action';
        return eP;
    }
    
    public static Contact createEmployee() {
        User managerUser = INC_Utils_Testing.createTestUser('System Administrator');
        insert managerUser;
        
        User EmployeeUser = INC_Utils_Testing.createTestUser('System Administrator');
        EmployeeUser.ManagerId = managerUser.Id;
        insert EmployeeUser;
        
        Account account = new Account();
        account.Name = 'AECOM Test';
        insert account;
        
        Contact contact = new Contact();
        contact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('AECOM Employee').getRecordTypeId();
        contact.FirstName = 'FirstName';
        contact.LastName = 'LastName';
        contact.AccountId = account.Id;
        contact.Email = EmployeeUser.Email;
        contact.pse__Salesforce_User__c = EmployeeUser.Id;
        contact.Person_ID__c = '99999999';
        contact.Status__c = 'Active';            					
        
        return contact;        
    }
    
    public static EnrollmentParticipant__c createEnrollmentParticipant(EnrollmentPlan__c ePlan, Contact employee) {
        EnrollmentParticipant__c ePart = new EnrollmentParticipant__c();
        ePart.EnrollmentPlan__c = ePlan.Id;
        ePart.EmployeeName__c = employee.Id;
        ePart.ParticipantCategory__c = 'Technical Leader';
        ePart.TargetIncentivePoolAllocated__c = 25;
        
        return ePart;
    }
 

}