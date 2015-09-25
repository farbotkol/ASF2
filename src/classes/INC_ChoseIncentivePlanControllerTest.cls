@isTest
private class INC_ChoseIncentivePlanControllerTest
{
    @isTest
    static void testChoseIncentivePlanTemplate()
    {
        User RunningUser1 = INC_Utils_Testing.createTestUser('System Administrator');
        User ProjectManager1 = INC_Utils_Testing.createTestUser('System Administrator');
        list<User> lUser = new list<User>();
        lUser.add(RunningUser1);
        lUser.add(ProjectManager1);
        insert lUser;

        Test.StartTest();
        System.runAs(RunningUser1){
                IncentiveProject__c oIncentiveProject = INC_Utils_Testing.createIncentiveProject();
                oIncentiveProject.ProjectManager__c = ProjectManager1.ID;
                oIncentiveProject.RegionDescription__c = 'Midwest';            
                insert oIncentiveProject;
                
                INC_IncentiveProjectCreateEnrollment.createEnrollmentForm(oIncentiveProject.ID);
            }
            
        Test.StopTest();

        map<id,IncentiveProject__c> mapIncentives = new map<id,IncentiveProject__c>();
        For(IncentiveProject__c inp: [Select ID, Name, OwnerID, DTWAdminInitiated__c from IncentiveProject__c]){
            System.assert(inp.OwnerID == ProjectManager1.ID,'Owner Should be project Manager! Owner: ' +inp.OwnerID + ' PM: ' + ProjectManager1.ID);
            Date d = System.Today();
            System.assert(inp.DTWAdminInitiated__c == d, 'DTWAdminInitiated__c should be today: ' + inp.DTWAdminInitiated__c + ' d: ' + d);
            mapIncentives.put(inp.id,inp);
        }
        Integer iCnt = 0;
        EnrollmentPlan__c enrollmentPlan;
        For(EnrollmentPlan__c ep: [Select ID, Name, EnrollmentStatus__c, IncentiveProject__c, FPPOverallEligibility_c__c, TMPlanOverallEligibility__c, ProjectGeography__c from EnrollmentPlan__c where IncentiveProject__c =: mapIncentives.Keyset()]){
            iCnt ++;
            String sIncName = mapIncentives.get(ep.IncentiveProject__c).Name;
            String sEpName = ep.Name;
            sIncName = 'ENR: ' + sIncName;
            System.assert(sIncName == sEpName,'Names not equal');
            System.assert(ep.EnrollmentStatus__c == 'Pending PM Action', 'Status should be Pending PM Action not: ' + ep.EnrollmentStatus__c);
			enrollmentPlan = ep;
        }
        System.assert(icnt == 1,'There should only be 1 enrollment plan: ' + iCnt);
        
        IncentivePlanTemplate__c incentivePlanTemplate = new IncentivePlanTemplate__c();
        incentivePlanTemplate.GeographyAllocation__c = 'Americas';
        incentivePlanTemplate.ContractType__c = 'Fixed Price';
        incentivePlanTemplate.ContractSubType__c = 'Gross Margin';
        incentivePlanTemplate.Status__c = 'Active';
        insert incentivePlanTemplate;
        
        incentivePlanTemplate = new IncentivePlanTemplate__c();
        incentivePlanTemplate.GeographyAllocation__c = 'Americas';
        incentivePlanTemplate.ContractType__c = 'Fixed Price';
        incentivePlanTemplate.ContractSubType__c = 'Net Margin';
        incentivePlanTemplate.Status__c = 'Active';
        insert incentivePlanTemplate;
        
        incentivePlanTemplate = new IncentivePlanTemplate__c();
        incentivePlanTemplate.GeographyAllocation__c = 'Americas';
        incentivePlanTemplate.ContractType__c = 'Time & Material';
        incentivePlanTemplate.ContractSubType__c = 'Gross Margin';
        incentivePlanTemplate.Status__c = 'Active';
        insert incentivePlanTemplate;
        
        incentivePlanTemplate = new IncentivePlanTemplate__c();
        incentivePlanTemplate.GeographyAllocation__c = 'Americas';
        incentivePlanTemplate.ContractType__c = 'Time & Material';
        incentivePlanTemplate.ContractSubType__c = 'Net Margin';
        incentivePlanTemplate.Status__c = 'Active';
        insert incentivePlanTemplate;                

        ApexPages.StandardController sc = new ApexPages.StandardController(enrollmentPlan);      
        INC_ChoseIncentivePlanController controller = new INC_ChoseIncentivePlanController(sc);
                
        System.assertEquals(2, controller.getYesNoOptions().size());
        System.assertEquals(2, controller.getSelectionMethods().size());
        controller.getIsFixedPriceEligible();
        controller.getIsTMEligible();
        controller.getIsANZRegion();
        // System.AssertEquals('Americas', controller.getGeographyAllocation('Midwest'));
        // System.AssertEquals('EMEA', controller.getGeographyAllocation('UK & Ireland'));
        // System.AssertEquals('APAC', controller.getGeographyAllocation('SE Asia'));
        controller.getIsMultiPlanEligible();
        controller.selectedSelectionMethod = 'Guided';
        controller.submitQuestionnairre();
        controller.clearResults();
        controller.selectPlanForEnrollment();
        

    }
}