@isTest
private class INC_ProjectCreateEnrollment_Test
{
	
	@isTest
	static void testDTWAdminEnrollment()
	{
		/*
		To Do:  
		      1. Create Running User to insert Incentive project for
		      2. Create User to assign as PM
		      3. Create Incentive Project as running user
		      4. Assign PM User and PM
		      5. Call webservice to create Enrollment
		*/

		/*
		To do for changes:
			  1. Create Users for Approvers 1,2,3
			  2. Create Org String(s)
			  3. Create Routing Members
			  	 1. Routing Member that matches Org String
			  	 2. Routing Member that doesn't match Org String
			  4. Validate that created Enrollment App as correct Approvers
			  5. Validate that updated Incentive Project has correct Approver attached
		*/
	
		list<User> lusers = new list<User>();
		User Approver1 = INC_Utils_Testing.createTestUser('Standard User');
		User Approver2 = INC_Utils_Testing.createTestUser('Standard User');
		User Approver3 = INC_Utils_Testing.createTestUser('Standard User');
		User DTWAdminWater = INC_Utils_Testing.createTestUser('Standard User');

		lUsers.add(DTWAdminWater);
		lUsers.add(Approver1);
		lUsers.add(Approver2);
		lUsers.add(Approver3);
		insert lUsers;

		list<OrganizationString__c> lOrgStrings = new list<OrganizationString__c>();
		lOrgStrings = INC_Utils_Testing.createOrganizationString();
		insert lOrgStrings;
		
		OrganizationString__c Org1;
		OrganizationString__c Org2;
		for(OrganizationString__c org: lOrgStrings){
			if(org.OrganizationName__c == 'Water Organization'){
				Org2 = org;
			}else{
				Org1 = org;
			}
		}
		
		//routing members
		list<RoutingMember__c> lRouting = new list<RoutingMember__c>();
		RoutingMember__c DefaultRout = INC_Utils_Testing.CreateRoutingMember(DTWAdminWater);
		DefaultRout.GeographyDescription__c = 'Water Geo';
		DefaultRout.GlobalDefault__c = true;
		lRouting.add(DefaultRout);
		RoutingMember__c DTWAdminActualWater = INC_Utils_Testing.CreateRoutingMember(DTWAdminWater);
		DTWAdminActualWater.GeographyDescription__c = Org2.GeographyName__c;
		DTWAdminActualWater.RegionDescription__c = Org2.Region__c;
		DTWAdminActualWater.BusinessLineDescription__c = Org2.BusinessLineName__c;
		DTWAdminActualWater.DistrictDescription__c = Org2.District__c;
		DTWAdminActualWater.Approver1__c = Approver1.id;
		DTWAdminActualWater.Approver2__c = Approver2.id;
		DTWAdminActualWater.Approver3__c = Approver3.id;
	
		lRouting.Add(DTWAdminActualWater);
	
		RoutingMember__c  TestingRouting = INC_Utils_Testing.createRoutingMember(Approver1);
		TestingRouting.GeographyDescription__c = Org1.GeographyName__c;
		TestingRouting.RegionDescription__c = Org1.Region__c;
		TestingRouting.BusinessLineDescription__c = Org1.BusinessLineName__c;
		TestingRouting.DistrictDescription__c = Org1.District__c;

		lRouting.add(TestingRouting);
		insert lRouting;

		User RunningUser = INC_Utils_Testing.createTestUser('System Administrator');
		User ProjectManager = INC_Utils_Testing.createTestUser('System Administrator');
		list<User> lUser = new list<User>();
		lUser.add(RunningUser);
		lUser.add(ProjectManager);
		insert lUser;

		Test.StartTest();
		System.runAs(RunningUser){
				IncentiveProject__c oIncentiveProject = INC_Utils_Testing.createIncentiveProject();
				oIncentiveProject.GeographyDescription__c = DTWAdminActualWater.GeographyDescription__c;
				oIncentiveProject.RegionDescription__c = DTWAdminActualWater.RegionDescription__c;
				oIncentiveProject.BusinessLineDescription__c = DTWAdminActualWater.BusinessLineDescription__c;
				oIncentiveProject.DistrictDescription__c = DTWAdminActualWater.DistrictDescription__c;

				oIncentiveProject.ProjectManager__c = ProjectManager.ID;
				oIncentiveProject.OrgCarryingOutProject__c = Org2.Name;
				insert oIncentiveProject;
				INC_IncentiveProjectCreateEnrollment.createEnrollmentForm(oIncentiveProject.ID);
				
				 //covering the approver 1 code since it's not used in production yet
		  		INC_Service_Matching IncMatch = new INC_Service_Matching();
		  		Map<id,INC_Service_Matching.RoutingMember_Wrapper> mapReturn = IncMatch.findApprover1(new List<IncentiveProject__c>{oIncentiveProject});
		

				RoutingMember__c DTWAdminActualWater2 = INC_Utils_Testing.CreateRoutingMember(DTWAdminWater);
				DTWAdminActualWater2.GeographyDescription__c = Org2.GeographyName__c;
				DTWAdminActualWater2.RegionDescription__c = Org2.Region__c;
				DTWAdminActualWater2.BusinessLineDescription__c = Org2.BusinessLineName__c;
				DTWAdminActualWater2.Approver1__c = Approver1.id;
				DTWAdminActualWater2.Approver2__c = Approver2.id;
				DTWAdminActualWater2.Approver3__c = Approver3.id;
				insert DTWAdminActualWater2;

				IncentiveProject__c oIncentiveProject2 = INC_Utils_Testing.createIncentiveProject();
				oIncentiveProject2.ProjectManager__c = ProjectManager.ID;
				oIncentiveProject2.OrgCarryingOutProject__c = Org2.Name;
				oIncentiveProject2.GeographyDescription__c = DTWAdminActualWater.GeographyDescription__c;
				oIncentiveProject2.RegionDescription__c = DTWAdminActualWater.RegionDescription__c;
				oIncentiveProject2.BusinessLineDescription__c = DTWAdminActualWater.BusinessLineDescription__c;
				oIncentiveProject2.DistrictDescription__c = DTWAdminActualWater.DistrictDescription__c;
				
				insert oIncentiveProject2;
				INC_IncentiveProjectCreateEnrollment.createEnrollmentForm(oIncentiveProject2.ID);
				
				 //covering the approver 1 code since it's not used in production yet
		  		mapReturn = IncMatch.findApprover1(new List<IncentiveProject__c>{oIncentiveProject});
				
				oIncentiveProject2.OrgCarryingOutProject__c = null;
				update oIncentiveProject2;
				INC_IncentiveProjectCreateEnrollment.createEnrollmentForm(oIncentiveProject2.ID);

			}
			
		Test.StopTest();

		map<id,IncentiveProject__c> mapIncentives = new map<id,IncentiveProject__c>();
		For(IncentiveProject__c inp: [Select ID
											   , Name
											   , OwnerID
											   , DTWAdminInitiated__c
											   , EnrollmentApprover1__c
											   , GeographyDescription__c
											   , DistrictDescription__c
											   , BusinessLineDescription__c
											   , RegionDescription__c
											    from IncentiveProject__c]){
			System.assert(inp.OwnerID == ProjectManager.ID,'Owner Should be project Manager! Owner: ' +inp.OwnerID + ' PM: ' + ProjectManager.ID);
			Date d = System.Today();
			System.assert(inp.DTWAdminInitiated__c == d, 'DTWAdminInitiated__c should be today: ' + inp.DTWAdminInitiated__c + ' d: ' + d);
			System.assert(inp.EnrollmentApprover1__c == Approver1.id, 'Incentive Project should be ' + Approver1.id + ' not: ' + inp.EnrollmentApprover1__c);
			mapIncentives.put(inp.id,inp);
		}
		System.Debug(logginglevel.error,'mapIncentives ' + mapIncentives);
		Integer iCnt = 0;
		For(EnrollmentPlan__c ep: [Select ID
											, Name
											, EnrollmentStatus__c
											, IncentiveProject__c 
											, Approver1__c
											, Approver2__c
											, Approver3__c
											from EnrollmentPlan__c where IncentiveProject__c =: mapIncentives.Keyset()]){
			iCnt ++;
			String sIncName = mapIncentives.get(ep.IncentiveProject__c).Name;
			String sEpName = ep.Name;
			sIncName = 'ENR: ' + sIncName;
			System.assert(sIncName == sEpName,'Names not equal');
			System.assert(ep.EnrollmentStatus__c == 'Pending PM Action', 'Status should be Pending PM Action not: ' + ep.EnrollmentStatus__c);
			System.Assert(ep.Approver1__c == Approver1.id,' Enrollment Approver 1 shoud be : '+ Approver1.id + ' not: ' + ep.Approver1__c);
			System.Assert(ep.Approver2__c == Approver2.id,' Enrollment Approver 2 shoud be : '+ Approver2.id + ' not: ' + ep.Approver2__c);
			System.Assert(ep.Approver3__c == Approver3.id,' Enrollment Approver 3 shoud be : '+ Approver3.id + ' not: ' + ep.Approver3__c);

		}
		System.assert(icnt == 3,'There should only be 3 enrollment plans: ' + iCnt);

	}
	
}