public with sharing class ECO_ReviewMemberManagerController {

	public TechnicalQualityReview__c oTechnicalQualityReview {get;set;}

    public list<TQT_Wrapper> lstTQT_Wrapper {get;set;}
    public list<TechnicalQualityTeam__c> lstTQT_Team {get;set;}
    public list<ReviewMember__c> lstReviewMembers {get;set;}
    public list<RM_Wrapper> lstReviewMember_Wrapper {get;set;}
    public list<RecordType> lstRecordType {get;set;}
    public map<string, id> mapRecordType {get;set;}
    public string strTargetID {get;set;}
    public string tabNmae {get;set;}

    public ECO_ReviewMemberManagerController(ApexPages.StandardController stdController) {
        this.oTechnicalQualityReview = (TechnicalQualityReview__c)stdController.getRecord();

        tabNmae='tabOne';

        lstTQT_Wrapper = new list<TQT_Wrapper>();
        lstReviewMember_Wrapper = new list<RM_Wrapper>();

        if(oTechnicalQualityReview == null){
            ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.WARNING,'You have reached this page improperly, please access it from the Deliverables screen.');
            ApexPages.addMessage(oPageMessage);
        }else{
            loadValues();
        }
    }


    private void loadValues(){
        lstTQT_Wrapper = new list<TQT_Wrapper>();
        lstReviewMember_Wrapper = new list<RM_Wrapper>();
        map<id, ReviewMember__c> mapReviewMember = new map<id, ReviewMember__c>();
        lstRecordType = new list<RecordType>();
        mapRecordType = new map<string, id>();

        lstRecordType = [Select Id, Name From RecordType  Where SobjectType = 'ReviewMember__c'];

        for(RecordType rt: lstRecordType){
            mapRecordType.put(rt.Name, rt.Id);
        }


        lstReviewMembers = [select  id, 
                                    name, 
                                    TechnicalQualityTeamMember__c, 
                                    TechnicalQualityTeamMember__r.TechnicalQualityTeamMember__c, 
                                    TechnicalQualityTeamMember__r.Role__c, 
                                    Discipline__c,
                                    Status__c,
                                    Description__c,
                                    Comments__c,
                                    General_Description__c,
                                    Originator_Initials__c,
                                    Checker_Initials__c                

                            from ReviewMember__c where TechnicalQualityReview__c =: oTechnicalQualityReview.id];

        for(ReviewMember__c rm: lstReviewMembers){
            lstReviewMember_Wrapper.add(new RM_Wrapper(rm));
            mapReviewMember.put( rm.TechnicalQualityTeamMember__r.TechnicalQualityTeamMember__c, rm );
        }

        lstTQT_Team = [select id, TechnicalQualityTeamMember__c, Role__c, Status__c from TechnicalQualityTeam__c where Deliverable__c =: oTechnicalQualityReview.Deliverable__c];

        for(TechnicalQualityTeam__c TQT: lstTQT_Team){
            if(mapReviewMember.containskey(TQT.TechnicalQualityTeamMember__c)==false){
                lstTQT_Wrapper.add(new TQT_Wrapper(TQT));
            }
        }


    }


    public PageReference submitForApproval(){

        saveRM();

        list<Approval.ProcessSubmitRequest> lstSubmitRequest = new list<Approval.ProcessSubmitRequest>();

        for(RM_Wrapper RMW: lstReviewMember_Wrapper){
            if(RMW.bSelected && RMW.oReviewMember.status__c != 'Submitted'){

                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitting request for approval.');
                req.setObjectId(RMW.oReviewMember.id);

                lstSubmitRequest.add(req);
            }
        }

        if(lstSubmitRequest.size() > 0){
            list<Approval.ProcessResult> results = Approval.process(lstSubmitRequest);
        }

        loadValues();

        return null;
    }

    public PageReference killApproval(){

        list<ReviewMember__c> listRMApproved = new list<ReviewMember__c>();
        set<id> RMids = new set<id>();

        for(RM_Wrapper RMW: lstReviewMember_Wrapper){
            if(RMW.bSelected && RMW.oReviewMember.status__c =='Approved'){
                RMW.oReviewMember.status__c ='Recalled';
                listRMApproved.add(RMW.oReviewMember);
            }

            if(RMW.bSelected){
                RMids.add(RMW.oReviewMember.id);
            }
        }

        if(listRMApproved.size() > 0){  
            try {
                update listRMApproved;
            } catch (Exception e) {
                ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to update approved records');
                ApexPages.addMessage(oMsg);
                return null;
            }    

        }

        if(RMids.size() >0){

            // Find all pending requests and recall them.
            List<ProcessInstance> procins = new List<ProcessInstance>([select Id from ProcessInstance where Status = 'Pending' and TargetObjectId IN:RMids]);

            set<id> procIds = new set<id>();

            if (procins.size() > 0) {
                for (ProcessInstance p: procins) {
                    procIds.add(p.id);
                }

                List<ProcessInstanceWorkitem> workitem = new List<ProcessInstanceWorkitem>([select Id from ProcessInstanceWorkitem where ProcessInstanceId IN :procIds]);


                list<Approval.ProcessWorkitemRequest> itemsToUpdate = new list<Approval.ProcessWorkitemRequest>();

                for(ProcessInstanceWorkitem w: workitem){
                    Approval.ProcessWorkitemRequest PWR = new Approval.ProcessWorkitemRequest();
                    PWR.setComments('Killing Pending Request');
                    PWR.setAction('Removed');
                    PWR.setWorkItemId(w.Id);
                    itemsToUpdate.add(PWR);
                }                

                if(itemsToUpdate.size() > 0){
                    list<Approval.ProcessResult> results =  Approval.process(itemsToUpdate);
                }


            }
        }

        loadValues();

        return null;
    }

    private void saveRM(){
        list<ReviewMember__c> listRMSave = new list<ReviewMember__c>();

        for(RM_Wrapper RMW: lstReviewMember_Wrapper){
            if(RMW.bSelected){
                listRMSave.add(RMW.oReviewMember);
            }
        }    

        update listRMSave;    
    }


    public PageReference saveRequest(){

        upsert oTechnicalQualityReview;


        list<ReviewMember__c> lstReviewMemberstoInsert = new list<ReviewMember__c>();

        for(TQT_Wrapper TQTW: lstTQT_Wrapper){
            if(TQTW.bSelected) {

                id rectID = mapRecordType.values()[0];

                if(mapRecordType.containskey(TQTW.oTechnicalQualityTeam.Role__c.trim())){
                    rectID = mapRecordType.get(TQTW.oTechnicalQualityTeam.Role__c.trim());
                }

                lstReviewMemberstoInsert.add(new ReviewMember__c(TechnicalQualityReview__c = oTechnicalQualityReview.id, TechnicalQualityTeamMember__c = TQTW.oTechnicalQualityTeam.id, recordtypeid = rectID));
            }
        }

        upsert lstReviewMemberstoInsert;

        loadValues();
        return null;
    }


    public class TQT_Wrapper{
        public boolean bSelected {get;set;}
        public TechnicalQualityTeam__c oTechnicalQualityTeam {get;set;}


        public TQT_Wrapper(TechnicalQualityTeam__c oTeam){
            bSelected = false;
            oTechnicalQualityTeam = oTeam;
        }
    }

    public class RM_Wrapper{
        public boolean bSelected {get;set;}
        public ReviewMember__c oReviewMember {get;set;}


        public RM_Wrapper(ReviewMember__c oRM){

            if(ORM.TechnicalQualityTeamMember__r.TechnicalQualityTeamMember__c == UserInfo.getUserId()){
                bSelected = true;
            } else {
                bSelected = false;
            }

            
            oReviewMember = oRM;
        }
    }

}