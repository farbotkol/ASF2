public class ECO_ProjectChangeManagerController {
        
        public pse__Proj__c project {get; set;}
        private list<String> changeManagerSubmittedIds;
        
        public ECO_ProjectChangeManagerController(ApexPages.standardController controller)
        {
                project = (pse__Proj__c)controller.getRecord();
                changeManagerSubmittedIds = ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id);
        }
                
        public boolean getIsChangedTasks()
        {
                return ECO_ChangeManager_Service.isChangedTasks(project.Id, changeManagerSubmittedIds);         
        }
        
        public boolean getIsChangedKeyMembers()
        {
                return ECO_ChangeManager_Service.isChangedKeyMembers(project.Id, changeManagerSubmittedIds);
        }
        
        public boolean getIsChangedCustomers()
        {
                return ECO_ChangeManager_Service.isChangedCustomers(project.Id, changeManagerSubmittedIds);
        }

        public boolean getIsChangedClassifications()
        {
                return ECO_ChangeManager_Service.isChangedClassifications(project.Id);
        }

        public boolean getIsChangedSHE()
        {
                return ECO_ChangeManager_Service.isChangedSafetyHealthEnv(project.Id);
        }
        
        public boolean getIsChangedAgreements()
        {
                return ECO_ChangeManager_Service.isChangedAgreements(project.Id, changeManagerSubmittedIds);
        }

        public boolean getIsChangedFunding()
        {
                return ECO_ChangeManager_Service.isChangedFunding(project.Id, changeManagerSubmittedIds);
        }       

        public boolean getIsChangedDocManage()
        {
                return ECO_ChangeManager_Service.isChangedDocumentManagement(project.Id);
        }               
        
        public boolean getIsChangedStakeComm()
        {
                return ECO_ChangeManager_Service.isChangedStakeholders(project.Id, changeManagerSubmittedIds);
        }       
        
        public boolean getIsChangedResources()
        {
                return ECO_ChangeManager_Service.isChangedResources(project.Id, changeManagerSubmittedIds);
        }       
        
        public boolean getIsChangedDeliverables()
        {
                return ECO_ChangeManager_Service.isChangedDeliverables(project.Id, changeManagerSubmittedIds);
        }       
        
        public boolean getIsChangedScope()
        {
                return ECO_ChangeManager_Service.isChangedScope(project.Id, changeManagerSubmittedIds);
        }       
        
        public boolean getIsChangedResilience()
        {
                return ECO_ChangeManager_Service.isChangedResilence(project.Id);
        }       

        public boolean getIsChangedRisk()
        {
                return ECO_ChangeManager_Service.isChangedRisk(project.Id, changeManagerSubmittedIds);
        }       

}