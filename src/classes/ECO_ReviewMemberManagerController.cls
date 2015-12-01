public with sharing class ECO_ReviewMemberManagerController {

	public TechnicalQualityReview__c oTechnicalQualityReview {get;set;}

    public list<TQT_Wrapper> lstTQT_Wrapper {get;set;}
    public list<TechnicalQualityTeam__c> lstTQT_Team {get;set;}
    public list<ReviewMember__c> lstReviewMembers {get;set;}
    public list<RM_Wrapper> lstReviewMember_Wrapper {get;set;}
    public list<RM_Wrapper> lstReviewApprover_Wrapper {get;set;}
    public list<RecordType> lstRecordType {get;set;}
    public list<Attachment> RMAttachments {get;set;}
    public map<string, id> mapRecordType {get;set;}
    public map<id, list<Attachment>> RMAttachmentsMap {get; set;}
    public string strTargetID {get;set;}
    public string tabNmae {get;set;}
    public String sRMId2  {get; set;} 
    public string sRMName2  {get; set;}
    public Boolean inputFields {get;set;}
    public Boolean TQTapproval {get;set;}
    public Boolean bLockFields {get;set;}
    public Id idTQT {get;set;}
    public Id loggedUser {get;set;}
    public Attachment attach {get;set;}
    //public Blob blobFile {get; set;}
	public String contentType {get; set;}
	//public String fileName {get; set;}
    public Profile sysAdminProfile {get;set;}
    public DeliverableRevision__c devRevision {get;set;}
    
    public ECO_ReviewMemberManagerController(ApexPages.StandardController stdController) {
        this.oTechnicalQualityReview = (TechnicalQualityReview__c)stdController.getRecord();
		init();
        
    }
    private void init(){
        tabNmae='tabOne';
        if(oTechnicalQualityReview.Id != null || oTechnicalQualityReview.Id != ''){
            string strSOQL = 'SELECT ';
            String idTQR;
            idTQR = oTechnicalQualityReview.Id;
            
            for (Schema.FieldSetMember fsmField: SObjectType.TechnicalQualityReview__c.FieldSets.ReviewScopeSet.getFields()) {
                strSOQL += fsmField.getFieldPath() + ', ';
            }
            for (Schema.FieldSetMember fsmField: SObjectType.TechnicalQualityReview__c.FieldSets.TypeSet.getFields()) {
                strSOQL += fsmField.getFieldPath() + ', ';
            }
            for (Schema.FieldSetMember fsmField: SObjectType.TechnicalQualityReview__c.FieldSets.TQR_Field_View.getFields()) {
                strSOQL += fsmField.getFieldPath() + ', ';
            }
            //strSOQL += 'ID, TypeCalculationCheck__c, TypeDetailCheck__c, TypeIndependentReviewIR__c, TypeInterdisciplinaryCoordinationReview__c, TypeBidabilityReview__c, TypeDesignReview__c, TypeSpecificationPackageReview__c, TypeSubconsultantClient__c, TypeConstructabilityReview__c, TypeDesignAssumptions__c, TypeOther__c ';
            strSOQL += 'Deliverable__c, ReviewTypeComments__c , ReviewScopeComments__c, Deliverable__r.DeliverableOwner__r.Contact.pse__Salesforce_User__c, Deliverable__r.DeliverablesOwner__r.pse__Salesforce_User__c, Deliverable__r.Project__r.pse__Project_Manager__r.pse__Salesforce_User__c, Lock_Fields__c, Deliverable__r.Project__r.Name, ID FROM TechnicalQualityReview__c Where Id =:idTQR';
            System.debug('idTQR:   '+oTechnicalQualityReview.Id);        
            list<TechnicalQualityReview__c> lstTQR = (list<TechnicalQualityReview__c>)Database.query(strSOQL);
            if(lstTQR.size()>0)
            	oTechnicalQualityReview = lstTQR[0];
            bLockFields = oTechnicalQualityReview.Lock_Fields__c;
            System.debug('******DEBUG*******bLockFields:  '+bLockFields);
            System.debug('lstTQR size:   '+lstTQR.size());
        }
        System.debug('oTechnicalQualityReview.Deliverable__c:   '+oTechnicalQualityReview.Deliverable__c);
        lstTQT_Wrapper = new list<TQT_Wrapper>();
        lstReviewMember_Wrapper = new list<RM_Wrapper>();
        lstReviewApprover_Wrapper = new List<RM_Wrapper>();
        RMAttachmentsMap = new map<id, list<Attachment>>();
        devRevision = new DeliverableRevision__c();
        sysAdminProfile = [Select Id From Profile Where Name = 'System Administrator'];
		attach = new Attachment();
        if(oTechnicalQualityReview == null){
            ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.WARNING,'You have reached this page improperly, please access it from the Deliverables screen.');
            ApexPages.addMessage(oPageMessage);
        }else{
            System.debug('deliverable owner: '+ oTechnicalQualityReview.Deliverable__r.DeliverablesOwner__r.pse__Salesforce_User__c);
            System.debug('project manager:  '+oTechnicalQualityReview.Deliverable__r.Project__r.pse__Project_Manager__r.pse__Salesforce_User__c);
            System.debug('logged in user:  '+UserInfo.getUserId());
            loggedUser = UserInfo.getUserId();
            TQTapproval = false;
            
            System.debug('loggedUser    :'+loggedUser);
            System.debug('bLockFields:  '+bLockFields);
            loadValues();
        }
        lockFields();
    }
    private void lockFields(){
        if(bLockFields == false &&  (UserInfo.getUserId() == oTechnicalQualityReview.Deliverable__r.DeliverablesOwner__r.pse__Salesforce_User__c 
               || UserInfo.getUserId() == oTechnicalQualityReview.Deliverable__r.Project__r.pse__Project_Manager__r.pse__Salesforce_User__c
               || UserInfo.getProfileId() == sysAdminProfile.Id))
            	inputFields = true;
        else
            inputFields = false;
    }

    private void loadValues(){
        lstTQT_Wrapper = new list<TQT_Wrapper>();
        //lstReviewMember_Wrapper = new list<RM_Wrapper>();
        //lstReviewApprover_Wrapper = new List<RM_Wrapper>();
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
                            		,Approved__c
                            		,Role__c 
                            		,VerifierNoOutstandingIssues__c
                            		,VerifierUnresolvedIssues__c
                            		,CheckerDateTime__c
                            		,ReviewCompleted__c
                            		,TechnicalQualityReview__r.Deliverable__r.PracticeArea__c
                            		,TechnicalQualityTeamMember__r.TechnicalQualityTeamMember__r.Name
                            		,TechnicalQualityReview__r.DeliverableRevision__r.Review_Completed__c
                            from ReviewMember__c 
                            where TechnicalQualityReview__c =: oTechnicalQualityReview.id];
                            

        for(ReviewMember__c rm: lstReviewMembers){
            if(rm.Role__c == 'Approver')
                lstReviewApprover_Wrapper.add(new RM_Wrapper(rm));
            else
            	lstReviewMember_Wrapper.add(new RM_Wrapper(rm));
            mapReviewMember.put( rm.TechnicalQualityTeamMember__r.TechnicalQualityTeamMember__c, rm );
            RMAttachmentsMap.put(rm.Id, new list<Attachment>());
        }
		RMAttachments = [select Id, ParentId, Name from Attachment where ParentId in :lstReviewMembers];
        for(Attachment RMAttachment: RMAttachments)
            RMAttachmentsMap.get(RMAttachment.ParentId).add(RMAttachment);
        lstTQT_Team = [select id, TechnicalQualityTeamMember__c, Role__c, Status__c, Approved__c, Checker_Date_Time__c, TechnicalQualityTeamMember__r.Name from TechnicalQualityTeam__c where Deliverable__c =: oTechnicalQualityReview.Deliverable__c];
		System.debug('lstTQT_Team size:   '+lstTQT_Team.size());
        for(TechnicalQualityTeam__c TQT: lstTQT_Team){
            if(mapReviewMember.containskey(TQT.TechnicalQualityTeamMember__c)==false ){
                lstTQT_Wrapper.add(new TQT_Wrapper(TQT));
            }
        }
		System.debug('lstTQT_Wrapper size'+lstTQT_Wrapper.size());

    }

    /*public PageReference setDateTimeField(){
    	TechnicalQualityTeam__c oTQT = new TechnicalQualityTeam__c();
        //oTQT = [Select Id, Checker_Date_Time__c, Approved__c From TechnicalQualityTeam__c where Id = :idTQT];
        System.debug('idTQT:   '+idTQT);
        System.debug('oTQT.Approved__c :   '+oTQT.Approved__c );
        System.debug('TQTapproval  :'+TQTapproval);
        String app = System.currentPagereference().getParameters().get('TQTapproval');
        System.debug('app  :'+app);
        if(idTQT != null || idTQT != ''){
            oTQT = [Select Id, Checker_Date_Time__c, Approved__c From TechnicalQualityTeam__c where Id = :idTQT];
            if(TQTapproval == true){
                //oTQT.Checker_Date_Time__c = system.now();
                System.debug('Inside if oTQT.Checker_Date_Time__c:  '+oTQT.Checker_Date_Time__c);
            }
            else{
                //oTQT.Checker_Date_Time__c = null;
                System.debug('Inside else oTQT.Checker_Date_Time__c:   '+oTQT.Checker_Date_Time__c);
            }
        }
        return null;
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
    }*/

    private void saveRM(){
        try{
                //HelperMethods.sendTemplatedEmail(toRecipients, ccRecipients, templateApiName, targetObjId, whatId, orgWideEmailId, saveAsActivity, attachList);
                list<ReviewMember__c> listRMSave = new list<ReviewMember__c>();
                for(RM_Wrapper RMW: lstReviewMember_Wrapper){
                    if(RMW.bSelected){
                        if(RMW.oReviewMember.ReviewCompleted__c == true)
                            RMW.oReviewMember.CheckerDateTime__c = System.now();
                        else
                            RMW.oReviewMember.CheckerDateTime__c = null;
                        if(attach.Body != null && attach.Name != '' ){
                            System.debug('Inside attach file');
                            attach.OwnerId = UserInfo.getUserId();
                            if(attach.ParentId == null)
                                attach.ParentId = RMW.oReviewMember.Id;
                            attach.ContentType = contentType;
                        }
                        listRMSave.add(RMW.oReviewMember);
                    }
                }   
                for(RM_Wrapper RMW : lstReviewApprover_Wrapper){
                    if(RMW.bSelected){
                        if(RMW.oReviewMember.Approved__c == true){
                            RMW.oReviewMember.CheckerDateTime__c = System.now();
                            oTechnicalQualityReview.Lock_Fields__c = true;
                            devRevision = [Select Id, Review_Completed__c From DeliverableRevision__c Where Id = :RMW.oReviewMember.TechnicalQualityReview__r.DeliverableRevision__c];
                            devRevision.Review_Completed__c = true;
                            update devRevision;
                            update oTechnicalQualityReview;
                        }
                        else
                            RMW.oReviewMember.CheckerDateTime__c = null;
                        listRMSave.add(RMW.oReviewMember);
                    }
                }
                update listRMSave; 
                if(attach.Body != null && attach.Name != '' )
                    insert attach;
            	init();
            }catch(Exception e){
                ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while updating Technical Quality Review. Please contact your administrator with the following error: ' + e);
	            ApexPages.addMessage(oMsg);         
         	}finally {
                  attach.body = null;
            }
 
    }

    public PageReference saveReview(){
        saveRM();
        lockFields();
        return null;
    }
    
    public PageReference savePage(){
        try{
            System.debug('oTechnicalQualityReview fields: '+oTechnicalQualityReview.ReviewScopeComments__c);
            System.debug('oTechnicalQualityReview delvierable:   '+oTechnicalQualityReview.Deliverable__c);
            upsert oTechnicalQualityReview;
            loadValues();
            return null;
        }catch (Exception e) {
	            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to create technical quality review. Please contact your administrator with the following error: ' + e);
	            ApexPages.addMessage(oMsg);
	            return null;
		}
    }
    public PageReference saveRequest(){
        try{
            System.debug('inside saveRequest');
            upsert oTechnicalQualityReview;
            System.debug('oTechnicalQualityReview deliverable version:   '+oTechnicalQualityReview.DeliverableRevision__c);
    		list<ReviewMember__c> lstReviewMemberstoInsert = new list<ReviewMember__c>();
    
            for(TQT_Wrapper TQTW: lstTQT_Wrapper){
                if(TQTW.bSelected) {
    
                    id rectID = mapRecordType.values()[0];
    
                    if(mapRecordType.containskey(TQTW.oTechnicalQualityTeam.Role__c.trim())){
                        rectID = mapRecordType.get(TQTW.oTechnicalQualityTeam.Role__c.trim());
                    }
    
                    lstReviewMemberstoInsert.add(new ReviewMember__c(TechnicalQualityReview__c = oTechnicalQualityReview.id, TechnicalQualityTeamMember__c = TQTW.oTechnicalQualityTeam.id, recordtypeid = rectID, ReviewSubmitted__c = true));
                }
            }
    
            upsert lstReviewMemberstoInsert;
    
            //loadValues();
            init();
            return null;
        }catch (Exception e) {
	            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to create technical quality review. Please contact your administrator with the following error: ' + e);
	            ApexPages.addMessage(oMsg);
	            return null;
		}
    }
	
    public PageReference createRMAttachment(){
        PageReference myPage = new PageReference('/p/attach/NoteAttach?pid=' + sRMId2.left(15) + '&parentname=' + sRMName2 + '&retURL=/apex/ECO_ReviewMemberManager?id='+oTechnicalQualityReview.Id+'&sfdc.override=1');
        return myPage;
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