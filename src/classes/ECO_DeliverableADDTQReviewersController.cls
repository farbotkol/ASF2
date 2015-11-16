public with sharing class ECO_DeliverableADDTQReviewersController {

    public Deliverable__c oDeliverable ;

    private string retUrl;
    private string idProject {get;set;}
    private string idDeliverable {get;set;}

    public boolean bDeliverablePassedIn {get;set;}

    public map<Integer,Project_TeamWrapper> mapDisplayTeamAvailable {get;set;}
    public map<Integer,TQT_Wrapper> mapDisplayTQTExisting {get;set;}
    public list<Integer> ListDisplayTeamKeys{get;set;}
    public list<Integer> listDisplayTQTKeys{get;set;}
    public list<ProjectRole__c> lstProjectRoles {get;set;}

    
    /*Constructor*/
    public ECO_DeliverableADDTQReviewersController(ApexPages.StandardController stdController) {
        
        bDeliverablePassedIn = true;

        oDeliverable = (Deliverable__c)stdController.getRecord();
        
        oDeliverable = ECO_Service_Deliverable.getDeliverable(new set<String>{oDeliverable.id})[0];

        if(oDeliverable == null){
            ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.WARNING,'You have reached this page improperly, please access it from the Deliverables screen.');
            ApexPages.addMessage(oPageMessage);
        }else{
            loadValues();
        }

        lstProjectRoles = [select id, name, definition__c from ProjectRole__c where Active__c = true order by name ASC];
    }
  
    private void loadValues(){
        set<id> setUsersInTQT = new set<id>();
        //first load Technical quailtiy team
        integer iRow = 1;
        mapDisplayTQTExisting = new map<Integer,TQT_Wrapper>();
        mapDisplayTeamAvailable = new map<Integer,Project_TeamWrapper>();
        ListDisplayTeamKeys = new list<Integer>();
        listDisplayTQTKeys = new list<Integer>();

        for(TechnicalQualityTeam__c oTQT: getTQTFromDeliverableIDs(new set<String>{oDeliverable.id})){
            System.Debug(logginglevel.error,'oTQT ' + oTQT);
            mapDisplayTQTExisting.put(iRow,new TQT_Wrapper(oTQT));
            setUsersInTQT.add(oTQT.TechnicalQualityTeamMember__c);
            listDisplayTQTKeys.add(iRow);
            iRow ++;
        }
       
        iRow = 1;
        boolean bExists = false;
        for(ProjectTeamMember__c oPTM: getProjectTeamByProjectID(new set<String>{oDeliverable.Project__c})){
            System.Debug(logginglevel.error,'oPtm.user__r.Name ' + oPtm);
            if(setUsersInTQT == null || !setUsersInTQT.contains(oPTM.Contact__r.pse__Salesforce_User__c)){
                bExists = false;
            }
            else{
                bExists = true;
            }
            System.Debug(logginglevel.error,'bExists: ' + bExists + ' ' + oPTM);
            mapDisplayTeamAvailable.put(iRow,new Project_TeamWrapper(oPTM,bExists));
            if(!bExists){
                ListDisplayTeamKeys.add(iRow);
            }
            iRow++;
        }
        System.Debug(logginglevel.error,'ListDisplayTeamKeys: ' + ListDisplayTeamKeys);
        System.Debug(logginglevel.error,'mapDisplayTeamAvailable: ' + mapDisplayTeamAvailable);
    }

    public void resetRowNumberDisplay(){
       list<Integer> lRows = new list<Integer>(mapDisplayTQTExisting.keyset());
       lRows.Sort();
       Integer iNewRow = 1;
       map<Integer,TQT_Wrapper> mapTemp = new map<Integer,TQT_Wrapper>();
       for(Integer iRow: lRows){
           mapTemp.put(iNewRow,mapDisplayTQTExisting.get(iRow));
           iNewRow ++;
       }
       mapDisplayTQTExisting.clear();
       for(Integer iRow: mapTemp.keySet()){
         mapDisplayTQTExisting.put(iRow,mapTemp.get(iRow));
       }
    }

    public void addNewMemberNotInTeam(){
       resetRowNumberDisplay();
       set<Integer> setRows = mapDisplayTQTExisting.keyset();
       System.Debug(logginglevel.error,'setRows: ' + setRows);
       Integer iRow = setRows.size() + 1;

       TechnicalQualityTeam__c oTQTMember = new TechnicalQualityTeam__c(
                                                     Deliverable__c = oDeliverable.id);
        TQT_Wrapper oTQTWrapper = new TQT_Wrapper(oTQTMember);
        mapDisplayTQTExisting.put(iRow,oTQTWrapper);
    }

    public void moveMembersDown(){
       set<Integer> setRows = mapDisplayTQTExisting.keyset();
       Integer iRow = setRows.size() + 1;
       set<Integer> setRowsToRemove = new set<Integer>();

       for(Integer iDisplayRow: mapDisplayTeamAvailable.Keyset()){
        Project_TeamWrapper PTW = mapDisplayTeamAvailable.get(iDisplayRow);
        System.Debug(logginglevel.error,'Selected: ' + PTW.bSelected);
          if(PTW.bSelected){
            PTW.bSelected = false;
            setRowsToRemove.add(iDisplayRow);
            PTW.bAlreadyTeamMember = true;
            String sRole = ECO_Service_Deliverable.getTQTRoleFromProjectRole(PTW.oProjectTeamMember.ProjectRole__r.Name);
            if(!isRoleValidForTechTeam(sRole)){
                sRole = '';
            }
            TechnicalQualityTeam__c oTQTMember = new TechnicalQualityTeam__c(
                                                     Deliverable__c = oDeliverable.id,
                                                     TechnicalQualityTeamMember__c = PTW.oProjectTeamMember.Contact__r.pse__Salesforce_User__c,
                                                     Role__c = sRole);
            TQT_Wrapper oTQTWrapper = new TQT_Wrapper(oTQTMember);
            oTQTWrapper.sUserName = PTW.oProjectTeamMember.Contact__r.Name;
            mapDisplayTQTExisting.put(iRow,oTQTWrapper);
            iRow ++;
          }
       }

       if(setRowsToRemove != null && setRowsToRemove.size() > 0){
        list<Integer> lTemp = new list<Integer>();
        for(Integer i: ListDisplayTeamKeys){
            if(setRowsToRemove.contains(i)){
                continue;
            }else{
                lTemp.add(i);
            }
        }
        ListDisplayTeamKeys.clear();
        ListDisplayTeamKeys.addAll(lTemp);
       }
        
    }
    public void removeSelectedMembers(){
        set<id> setRedisplaymembers = new set<id>();
        for(Integer iRow : mapDisplayTQTExisting.keyset()){
            TQT_Wrapper oTQTW = mapDisplayTQTExisting.get(iRow);
            System.debug('oTQTW.oPTM::::'+oTQTW.oPTM);
            System.debug('oTQTW.oTechnicalQualityTeam.TechnicalQualityTeamMember__c:::::'+oTQTW.oTechnicalQualityTeam.TechnicalQualityTeamMember__c);
            if(oTQTW.bSelected){
                System.debug('oTQTW::::::'+oTQTW);
                System.debug('oTQTW.oTechnicalQualityTeam:::::'+oTQTW.oTechnicalQualityTeam.Id);
                if(oTQTW.oPTM == null){ //means existing project team record
                    setRedisplaymembers.add(oTQTW.oTechnicalQualityTeam.TechnicalQualityTeamMember__c);
                }
                mapDisplayTQTExisting.remove(iRow);
                try{
                    delete oTQTW.oTechnicalQualityTeam;
                }catch(Exception e){
                    ApexPages.addMessages(e);
                }
                
            }
        }

        for(Integer iRow : mapDisplayTeamAvailable.keyset()){
            Project_TeamWrapper oPTW = mapDisplayTeamAvailable.get(iRow);
            if(setRedisplaymembers.Contains(oPTW.oProjectTeamMember.Contact__r.pse__Salesforce_User__c)){
                ListDisplayTeamKeys.add(iRow);
            }
        }
        ListDisplayTeamKeys.sort();
    }

    public pageReference cancel(){
        pageReference pr = new pageReference('/'+oDeliverable.id);
        pr.setredirect(true);
        return pr;
    }


    public pageReference saveandContiue(){
        pageReference pr = new pageReference('/'+oDeliverable.id);
        pr.setredirect(true);
        saveChanges();
        return pr;
    }

    public void saveChanges(){
        if(!checkForErrors()){
            //first look for members to add and build those records before changing anything
            list<ProjectTeamMember__c> lInsertTeamMembers = addMemberToProjectTeam();
            //now build the TQT's to insert
            list<TechnicalQualityTeam__c> lUpdatesInserts = prepareTeamForSave();

            if(lUpdatesInserts != null && lUpdatesInserts.size() > 0){
                System.savePoint sp = Database.setSavePoint();
                try{
                    upsert lUpdatesInserts;
                    insert lInsertTeamMembers;
                    loadValues();

                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Save Successful.'));
                }catch(Exception e){
                    system.debug('Handling Exception:  '+e.getMessage());
                    Database.rollBack(sp);
                    ApexPages.addMessages(e);
                }
            }
            
        }else{
            ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.Error,'Please enter all required information for the highlighted rows.');
            ApexPages.addMessage(oPageMessage);
        }

    }
    public boolean checkForErrors(){
        boolean bReturn = false;
        for(TQT_Wrapper oTQTW: mapDisplayTQTExisting.Values()){
            if(oTQTW.oTechnicalQualityTeam.Role__c == null || oTQTW.oTechnicalQualityTeam.Role__c == ''){
                oTQTW.bHasError = true;
                bReturn = true;
            }
            if(oTQTW.oTechnicalQualityTeam.TechnicalQualityTeamMember__c == null){
                if(oTQTW.oPTM.Contact__c == null){
                    oTQTW.bHasError = true;
                }
            }
        }

        return bReturn;
    }
    public list<TechnicalQualityTeam__c> prepareTeamForSave(){

        list<TechnicalQualityTeam__c> lReturn = new list<TechnicalQualityTeam__c>();
        set<id> setContactID = new set<id>();
        map<id,Contact> mapContacts = new map<id,Contact>();
        
        System.Debug(logginglevel.error,'mapDisplayTQTExisting ' + mapDisplayTQTExisting);


        for(Integer iRow : mapDisplayTQTExisting.keyset()){
            TQT_Wrapper oTempTQTW = mapDisplayTQTExisting.get(iRow);

            System.Debug(logginglevel.error,'test*** TQTM: ' + oTempTQTW.oTechnicalQualityTeam.TechnicalQualityTeamMember__c);
            System.Debug(logginglevel.error,'test*** CONTACT: ' + oTempTQTW.oPTM.Contact__c);

            if(oTempTQTW.oPTM.Contact__c != null && oTempTQTW.oTechnicalQualityTeam.TechnicalQualityTeamMember__c == null){
                System.Debug(logginglevel.error,'test***** : ' + oTempTQTW.oPTM.Contact__c);
                setContactID.add(oTempTQTW.oPTM.Contact__c);
            }
        }

        System.Debug(logginglevel.error,'setContactID ' + setContactID);

        if(setContactID != null && setContactID.size() > 0){
            mapContacts = getUserByContact(setContactID);
        }
        System.Debug(logginglevel.error,'mapContacts ' + mapContacts);
        
        for(TQT_Wrapper oTQTW: mapDisplayTQTExisting.Values()){
            // if(oTQTW.bNewRecord){ 
                if(oTQTW.oTechnicalQualityTeam.TechnicalQualityTeamMember__c == null){
                    oTQTW.oTechnicalQualityTeam.TechnicalQualityTeamMember__c = mapContacts.get(oTQTW.oPTM.Contact__c).pse__Salesforce_User__c;
                }
                lReturn.add(oTQTW.oTechnicalQualityTeam);
            /*}else{
                lReturn.add(oTQTW.oTechnicalQualityTeam);
            }*/
        }

        return lReturn;
    }
    
    /*
        Items for Utility class or separate class
    */
    public list<TechnicalQualityTeam__c> getTQTFromDeliverableIDs(set<String> setID){
        return[Select id
                        , ApprovalNeeded__c
                        , Deliverable__c
                        , RequiredDate__c
                        , Role__c
                        , Status__c
                        , Submit_For_Approval__c
                        , TechnicalQualityTeamMember__c
                        , TechnicalQualityTeamMember__r.Name
                      From TechnicalQualityTeam__c where Deliverable__c =: setID];
    }
    
    public list<ProjectTeamMember__c> getProjectTeamByProjectID(set<String>setID){
        return [Select id
                         , Contact__c
                         , Contact__r.Name
                         , Contact__r.pse__Salesforce_User__c
                         , ProjectRole__c
                         , ProjectRole__r.Name
                         , User__c
                         , User__r.Name
                         , Role__c 
                         , Active__c
                From ProjectTeamMember__c where Project__c =: setID and (EndDate__c = null or EndDate__c > TODAY)];
                //need to find out the difference between Active__c and Is_Active__c
                //will need to use one of those to only get active members.
    }

    private boolean isRoleValidForTechTeam(String sRole){
        boolean bReturn = false;
        for(SelectOption SO: ECO_Service_Deliverable.getTechTeamRoles()){
            if(SO.getLabel() == sRole){
                bReturn = true;
                break;
            }
        }

        return bReturn;
    }

    private map<id,Contact> getUserByContact(set<id> setContacts){
        return new map<id,Contact>([Select id
                                             , pse__Salesforce_User__c
                                    from Contact
                                    Where id =: setContacts]);
    }

    private list<ProjectTeamMember__c> addMemberToProjectTeam(){
        list<ProjectTeamMember__c> lAddMembers = new list<ProjectTeamMember__c>();

            for(TQT_Wrapper oTQT: mapDisplayTQTExisting.Values()){
                if(oTQT.bNewRecord && oTQT.oTechnicalQualityTeam.TechnicalQualityTeamMember__c == null){
                    System.debug('oTQT.oPTM.Contact__c:   '+oTQT.oPTM.Contact__c);
                    lAddMembers.add(new ProjectTeamMember__c(Contact__c = oTQT.oPTM.Contact__c,
                                                             Project__c = oDeliverable.Project__c,
                                                             ProjectRole__c = ECO_Service_Deliverable.getProjectTeamRoleFromTQTRole(oTQT.oTechnicalQualityTeam),
                                                             RecordTypeID = ECO_Utils_Meta.getRecordTypeId(ProjectTeamMember__c.sObjectType,'Team Member')));
                }
            }
        return lAddMembers;
    }

    public class Project_TeamWrapper{
        public boolean bAlreadyTeamMember {get;set;}
        public ProjectTeamMember__c oProjectTeamMember{get;set;}
        public boolean bSelected {get;set;}
        public boolean bCanBeUser {get;set;}
        public string approvalMessage {get;set;}
        public Project_TeamWrapper(ProjectTeamMember__c oProjectTeamMember, boolean bAlreadyTeamMember){
            bSelected = false;
            bCanBeUser = false;
            this.oProjectTeamMember = oProjectTeamMember;
            this.bAlreadyTeamMember = bAlreadyTeamMember;

            if(oProjectTeamMember.Active__c){
                if(oProjectTeamMember.Contact__r.pse__Salesforce_User__c != null){
                    bCanBeUser = true;
                } else {
                    approvalMessage = 'User does not have a Salesforce license';
                }                
            } else {
                approvalMessage = 'Team Member is not currently active on the project';
            }



            
        }

    }

    public class TQT_Wrapper{
        public boolean bSelected {get;set;}
        public TechnicalQualityTeam__c oTechnicalQualityTeam {get;set;}
        public boolean bNewRecord{get;set;}
        public ProjectTeamMember__c oPTM{get;set;}
        public String sUserName {get;set;}
        public boolean bHasError{get;set;}
        
        public TQT_Wrapper(TechnicalQualityTeam__c oTeam){
            bSelected = false;
            bHasError = false;
            
            oTechnicalQualityTeam = oTeam;
            if(oTeam.Id == null){
                bNewRecord = true;
                /*if(oTeam.TechnicalQualityTeamMember__c == null){
                    oPTM = new ProjectTeamMember__c();

                }*/

            }else{
                sUserName = oTeam.TechnicalQualityTeamMember__r.Name;
                bNewRecord = false;
            }

                if(oTeam.TechnicalQualityTeamMember__c == null){
                    oPTM = new ProjectTeamMember__c();

                }

        }

        
    }
}