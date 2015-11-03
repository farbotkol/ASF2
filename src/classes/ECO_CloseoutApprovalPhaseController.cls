public with sharing class ECO_CloseoutApprovalPhaseController {

    private Transient Attachment recommendationAttachment;
    public String overrideRecommedation  {get;set;}
    private Transient Attachment permissionAttachment;
    public String overridePermission  {get;set;}
    private Transient Attachment imageAttachment;
    public String overrideImage  {get;set;}

    private Transient Attachment lessonsAttachment;
    public String overrideLessons  {get;set;}
    private Transient Attachment certificateAttachment;
    public String overrideCertificate  {get;set;}


    public  pse__Proj__c oProject {get;set;}
    public  list<SelectOption> types { get; set; }
    public  list<SelectOption> types2 { get; set; }

    public list<Project_Site__c> ProjectSitesFound{get;set;}
    public list<Agreement__c> AgreementsProjectFound{get;set;}
    public list<VendorSite__c> VendorSitesProjectFound{get;set;}
    public list<Deliverable__c> DeliverablesFound{get;set;}
    public list<BudgetHeader__c> BudgetHeadersFound{get;set;}
    public list<DOAConditions__c> DOAConditionsFound{get;set;}
    public list<POHeader__c> POFound{get;set;}
    public list<Billing__c> BillingFound{get;set;}
    public list<BillingWrapper> BillingWrapperFound{get;set;}

    public list<task> listTask {get;set;}

    public id alertRecordTypeId {get;set;}

    public map<Id, Attachment> attachmentsMap {get; set;}

    private date oldClosureDate;

    private ApexPages.StandardController standardController;

    /* Custom classes to facilitate this controller */
    public class EcoControllerException extends Exception {}

    public class BillingWrapper{
        public Billing__c oB {get;set;}
        public account oS {get;set;}

        Public BillingWrapper(Billing__c oB){
            this.oB = ob;
        }
    }

    public ECO_CloseoutApprovalPhaseController getPageCont(){
        return this;
    }



    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public ECO_CloseoutApprovalPhaseController(ApexPages.StandardController stdController) {
        this.oProject = (pse__Proj__c)stdController.getRecord();

        oProject = [select  id 
                            ,name
                            ,EcoSystemReferenceNumber__c
                            ,RequestedProjectStatus__c
                            ,ClosureDate__c
                            ,ProjectClosureNotes__c
                            ,ScheduledOnHoldDate__c
                            ,ScheduledRestartDate__c
                            ,OnHoldReason__c
                            ,ProjectSectionHeaderName__c
                            ,pse__Opportunity__c
                            ,projclosePOPaidText__c
                            ,projclosePOPaid__c
                            ,projcloseScheduleMilestoneCompletion__c
                            ,projcloseScheduleMilestoneCompletionText__c
                            ,projcloseProjectTeamLessonsLearned__c
                            ,projcloseClientsClientsContacted__c
                            ,projcloseClientsContactedText__c
                            ,projcloseClientsFormalCompletionCert__c
                            ,projcloseClientsFollowonWork__c
                            ,projcloseSafetyincidents__c
                            ,projcloseSafetyincidentsText__c
                            ,projcloseAgreementsClientNotification__c
                            ,projcloseAgreementsClientNotifyText__c
                            ,projcloseAgreementsCancelled__c
                            ,projcloseAgreementsCancelledText__c
                            ,projcloseAgreementsCloseoutActions__c
                            ,projcloseAgreementsCloseoutActionsText__c
                            ,projectcloseScopeServicesIncluded__c
                            ,projectcloseScopeServicesIncludedText__c
                            ,projcloseSubsContractObligations__c
                            ,projcloseSubsContractObligationsText__c
                            ,projcloseSubsContractDeliverableDue__c
                            ,projcloseSubsContractDeliverableDueText__c
                            ,projcloseSubsPartnerReviews__c
                            ,projcloseSubsPartnerReviewsText__c
                            ,projcloseSubsInvoices__c
                            ,projcloseSubsInvoicesText__c
                            ,projcloseDeliverablesAccepted__c
                            ,projcloseDeliverablesAcceptedText__c
                            ,projcloseDocproperlySaved__c
                            ,projcloseDocproperlySavedText__c
                            ,projcloseDocHardCopy__c
                            ,projcloseDocHardCopyText__c
                            ,projcloseDocFilesCleaned__c
                            ,projcloseDocFilesCleanedText__c
                            ,projcloseStakeholderContactToSurvey__c
                            ,projcloseStakeholderCompleteSurvey__c
                            ,projcloseStakeholderCloseoutMeeting__c
                            ,projcloseStakeholderCloseoutMeetingText__c
                            ,projcloseStakeholderCommendation__c
                            ,projcloseRiskManMitigation__c
                            ,projcloseRiskManMitigationText__c
                            ,projcloseDoAConditionsCompleted__c
                            ,projcloseDoAConditionsCompletedText__c
                            ,projcloseBudgetContractDocuments__c
                            ,projcloseBudgetContractDocumentsText__c
                            ,projcloseBudgetFeesBilled__c
                            ,projcloseBudgetFeesBilledText__c
                            ,projcloseBudgetFinalinvoice__c
                            ,projcloseBudgetFinalinvoiceText__c
                            ,projcloseBudgetAcctsReceivable__c
                            ,projcloseBudgetAcctsReceivableText__c
                            ,projcloseProjDescFinalOutcomes__c
                            ,projcloseProjDescFutureMarketing__c
                            ,projcloseProjDescFutureMarketingText__c
                            ,projcloseDescPublishPermission__c
                            ,projcloseClaimsPending__c
                            ,projcloseClaimsPendingText__c
                            ,projcloseProjectTeamPerformanceReview__c
                            ,projcloseProjTeamPerformanceReviewText__c
                            ,projcloseClientsFormalCompletionCertText__c
                            ,ClosureRecommendationAttachment__c
                            ,ClosurePermissionAttachment__c
                            ,ClosureImageAttachment__c
                            ,ClosureLessonAttachment__c
                            ,ClosureCertificateAttachment__c
                            ,projcloseResilienceComplete__c
                            ,projclosResilienceCompleteExplantation__c
                            ,pse__Proj__c.pse__Stage__c 
                            ,CurrentApprovedCostBudget__c
                            ,CurrentApprovedRevenueBudget__c
                            ,CurrentForecastCostBudget__c
                            ,CurrentForecastRevenueBudget__c
                            ,AR_Value__c
                            ,UnbilledValue__c
                    from pse__Proj__c
                    where id =: oProject.id];

        types = new List<SelectOption>();
       
        types.add(new SelectOption('Yes', 'Yes'));  
        types.add(new SelectOption('No', 'No'));
        types.add(new SelectOption('N/A', 'N/A'));  

        types2 = new List<SelectOption>();
        types2.add(new SelectOption('Yes', 'Yes'));
        types2.add(new SelectOption('No', 'No'));
                  

        oldClosureDate = oProject.ClosureDate__c;

        ProjectSitesFound = [select id from Project_Site__c where Project__c =: oProject.id];
        AgreementsProjectFound = [select id from Agreement__c where Project__c =: oProject.id];
        VendorSitesProjectFound = [select id from VendorSite__c where Project__c =: oProject.id];
        DeliverablesFound = [select id from Deliverable__c where Project__c =: oProject.id];
        BudgetHeadersFound = [select id from BudgetHeader__c where Project__c =: oProject.id];
        DOAConditionsFound = [select id from DOAConditions__c where Project__c =: oProject.id];
        POFound = [select id from POHeader__c where Project__c =:oProject.id];
        BillingFound = [select id, RAInvoiceNumber__c, InvoiceDate__c, CustomerNumber__c, InvoiceAmount__c, BalanceDue__c from Billing__c where ProjectNumber__c =:oProject.id and BalanceDue__c > 0 ];

        BillingWrapperFound = new list<BillingWrapper>();
        set<string> customerid = new set<string>();

        for(Billing__c b:BillingFound){
            BillingWrapperFound.add(new BillingWrapper(b));
            customerid.add(b.CustomerNumber__c);
        }

        list<account> lstAccount = [select id, OracleCustomerNumber__c from account where OracleCustomerNumber__c IN: customerid];

        map<string, account> mapSite = new map<string, account>();

        for(account s: lstAccount ){
            mapSite.put(s.OracleCustomerNumber__c, s);
        }

        for(BillingWrapper bw:BillingWrapperFound){
            if(mapSite.containsKey(bw.oB.CustomerNumber__c)){
                bw.oS = mapSite.get(bw.oB.CustomerNumber__c);
            }
        }        


        alertRecordTypeId = ECO_Utils_Meta.getRecordTypeId(PortalMessage__c.sObjectType, ECO_Constants.PortalMessage_AlertRecordTypeName);
        attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :oproject.Id]);

        list<ExportControl__c> listEC = [select id from ExportControl__c where Project__c=: oproject.id];
        set<id> sECid = new set<id>();

        if(listEC.size() >0){
            for(ExportControl__c ec: listEC){
                sECid.add(ec.id);
            }            
        }

        if(sECid.size() > 0){
            listTask = [Select subject,Description,Id, WhatId, Ownerid, ActivityDate, Status From Task Where (WhatId=: oproject.id or WhatId IN: sECid) and Status != 'Completed'];
        } else {
            listTask = [Select subject,Description,Id, WhatId, Ownerid, ActivityDate, Status From Task Where WhatId=: oproject.id and Status != 'Completed'];
        }

        
    }

    public boolean validate(){

        boolean returnvalue = true;

        if(ApexPages.currentPage().getParameters().get('Mode') == 'Test'){
            return returnvalue;
        }


        for (Schema.FieldSetMember fsmField: SObjectType.pse__Proj__c.FieldSets.EcoProjectClosureValidation.getFields()) {
            if(oproject.get(fsmField.getFieldPath()) == null){
                ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The following question must be answered: ' + fsmField.getLabel());
                ApexPages.addMessage(oMsg);               
                returnvalue = false;
            }
        }

        if (oProject.projcloseClaimsPending__c == 'Yes'){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'This project has pending claims and therefore cannot be closed at this time. Please put the project on hold until all claims are resolved, at which point you can close the project.');
            ApexPages.addMessage(oMsg);               
            returnvalue = false;            
        }

        for(ChangeManager__c cm: [select id, name, ApprovalStatus__c  from ChangeManager__c where (ApprovalStatus__c = 'Submitted' or ApprovalStatus__c = 'Rejected') and Project__c =: oproject.id and IntExtContractManagement__c= true]){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Unapproved Change Management Found');
            ApexPages.addMessage(oMsg);     
            returnvalue = false;         
        }

        for(QuestionnaireSet__c qs: [select id, name, ApprovalStatus__c  from QuestionnaireSet__c where ApprovalStatus__c != 'Approved'  and Project__c =: oproject.id]){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Unapproved Risk and Market Assessment Found - ' + qs.name + ' - ' + qs.ApprovalStatus__c + '.');
            ApexPages.addMessage(oMsg);     
            returnvalue = false;         
        }

        for(ExportControl__c ec: [select id, name, ApprovalStatus__c  from ExportControl__c where ApprovalStatus__c != 'Approved'  and Project__c =: oproject.id]){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Unapproved Export Control Found - ' + ec.name + ' - ' + ec.ApprovalStatus__c + '.');
            ApexPages.addMessage(oMsg);     
            returnvalue = false;         
        }

        for(POHeader__c po: [select id, name, Status__c  from POHeader__c where Status__c != 'APPROVED'  and Project__c =: oproject.id]){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Unapproved Purchase Order Found - ' + po.name + ' - ' + po.Status__c + '.');
            ApexPages.addMessage(oMsg);     
            returnvalue = false;         
        }        

        for(ProjectReview__c pr: [select id, name, Status__c  from ProjectReview__c where Status__c != 'Approved'  and Project__c =: oproject.id]){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Unapproved Project Review Found - ' + pr.name + ' - ' + pr.Status__c + '.');
            ApexPages.addMessage(oMsg);     
            returnvalue = false;         
        }  

        for(Deliverable__c del: [select id, name, Status__c  from Deliverable__c where Status__c != 'Review Complete'  and Project__c =: oproject.id]){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Unapproved Deliverable Found - ' + del.name + ' - ' + del.Status__c + '.');
            ApexPages.addMessage(oMsg);     
            returnvalue = false;         
        }  

        for(DOAApprovalRequest__c doar: [select id, name, ApprovalStatus__c  from DOAApprovalRequest__c where (ApprovalStatus__c = 'Submitted' or ApprovalStatus__c = 'Rejected')  and Project__c =: oproject.id]){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Unapproved DOA Request Found - ' + doar.name + ' - ' + doar.ApprovalStatus__c + '.');
            ApexPages.addMessage(oMsg);     
            returnvalue = false;         
        }                   

        return returnvalue;
    }

    public pagereference createChangeManagement(){

        boolean goforward = true;

        if (oProject.RequestedProjectStatus__c == 'Closed'){
            goforward = validate();
        }

        if(goforward){

            Savepoint oSavePoint = Database.setSavepoint();

            try{
                //oProject.pse__Stage__c = 'Approved';
                update oProject;
            }catch(EcoControllerException e){
                ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to update project. Please contact your administrator with the following error: ' + e);
                ApexPages.addMessage(oMsg);
                Database.rollback(oSavePoint);
                return null; 
            } 

            list<RecordType> lstRT = [select id from recordtype where sObjectType='ChangeManager__c' and developername='InternalChange'];
			
			ChangeManager__c cm;
			if(oProject.RequestedProjectStatus__c == 'Closed')
            	cm = new ChangeManager__c(recordtypeid = lstRT[0].id, Project__c = oProject.id, IntExtProjectClosure__c=true);
			else
				cm = new ChangeManager__c(recordtypeid = lstRT[0].id, Project__c = oProject.id, IntExtProjectOnHold__c=true);	
            try{
                insert cm;
            }catch(EcoControllerException e){
                ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to insert Change Manager: ' + e);
                ApexPages.addMessage(oMsg);
                return null; 
            } 

            return new pagereference('/apex/eco_changemanagerdetail?id=' + cm.id + '&Mode=Edit');
        } else {
            return null;
        }

    }

    public pagereference createChangeManagementRestart(){

        oProject.RequestedProjectStatus__c = 'Approved';

        Savepoint oSavePoint = Database.setSavepoint();

        try{
            //oProject.pse__Stage__c = 'Approved';
            update oProject;
        }catch(EcoControllerException e){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to update project. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            Database.rollback(oSavePoint);
            return null; 
        } 

        list<RecordType> lstRT = [select id from recordtype where sObjectType='ChangeManager__c' and developername='InternalChange'];
        
        ChangeManager__c cm;
        
        cm = new ChangeManager__c(recordtypeid = lstRT[0].id, Project__c = oProject.id, IntExtProjectOnHold__c=true, IsProjectRestart__c=true);

        try{
            insert cm;
        }catch(EcoControllerException e){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to insert Change Manager: ' + e);
            ApexPages.addMessage(oMsg);
            return null; 
        } 

        return new pagereference('/apex/eco_changemanagerdetail?id=' + cm.id + '&Mode=Edit');


    }

    public Attachment doRecommendationAttachment
    {
        get
        {
            if(recommendationAttachment==null)
            {
                recommendationAttachment = new Attachment(parentid = oproject.id);
            }
            return recommendationAttachment;
        }
        set;
    }
    
    public Attachment docPermissionAttachment
    {
        get
        {
            if(permissionAttachment==null)
            {
                permissionAttachment = new Attachment(parentid = oproject.id);
            }
            return permissionAttachment;
        }
        set;
    }    
    
    public Attachment docImageAttachment
    {
        get
        {
            if(imageAttachment==null)
            {
                imageAttachment = new Attachment(parentid = oproject.id);
            }
            return imageAttachment;
        }
        set;
    } 

    public Attachment docLessonAttachment
    {
        get
        {
            if(lessonsAttachment==null)
            {
                lessonsAttachment = new Attachment(parentid = oproject.id);
            }
            return lessonsAttachment;
        }
        set;
    } 

    public Attachment docCertificateAttachment
    {
        get
        {
            if(certificateAttachment==null)
            {
                certificateAttachment = new Attachment(parentid = oproject.id);
            }
            return certificateAttachment;
        }
        set;
    }     


    private list<Attachment> getAttachmentListFromIdList(list<String> attachmentIds)
    {
        list<Attachment> attachments = new list<Attachment>();
        for(String attachmentId:attachmentIds)
        {
            if(attachmentsMap.containsKey(attachmentId) && attachmentId != null && attachmentId != '')
                attachments.add(attachmentsMap.get(attachmentId));
        }
        return attachments; 
    }
       
    public list<Attachment> getAttachedDocumentRecommended()
    {

        list<String> attachmentIds = new list<String>();
        if(oproject.ClosureRecommendationAttachment__c != null)
            attachmentIds = oproject.ClosureRecommendationAttachment__c.split(';');
            
        return getAttachmentListFromIdList(attachmentIds);
    }

    public void saveRecommendationAndProject()
    {
        if(recommendationAttachment.Body != null)
        {   
            if(overrideRecommedation != null && overrideRecommedation != '')
                recommendationAttachment.Name = overrideRecommedation;               
            insert recommendationAttachment;
            
            if(oproject.ClosureRecommendationAttachment__c != null)
                oproject.ClosureRecommendationAttachment__c += recommendationAttachment.Id + ';';
            else
                oproject.ClosureRecommendationAttachment__c = recommendationAttachment.Id + ';';          
            update oproject;
            
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :oproject.Id]);
            recommendationAttachment = null;
        }           
    }

    public list<Attachment> getAttachedDocumentPermission()
    {

        list<String> attachmentIds = new list<String>();
        if(oproject.ClosurePermissionAttachment__c != null)
            attachmentIds = oproject.ClosurePermissionAttachment__c.split(';');
            
        return getAttachmentListFromIdList(attachmentIds);
    }

    public void savePermissionAndProject()
    {
        if(permissionAttachment.Body != null)
        {   
            if(overridePermission != null && overridePermission != '')
                permissionAttachment.Name = overridePermission;               
            insert permissionAttachment;
            
            if(oproject.ClosurePermissionAttachment__c != null)
                oproject.ClosurePermissionAttachment__c += permissionAttachment.Id + ';';
            else
                oproject.ClosurePermissionAttachment__c = permissionAttachment.Id + ';';          
            update oproject;
            
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :oproject.Id]);
            permissionAttachment = null;
        }           
    }

    public list<Attachment> getAttachedDocumentImage()
    {

        list<String> attachmentIds = new list<String>();
        if(oproject.ClosureImageAttachment__c != null)
            attachmentIds = oproject.ClosureImageAttachment__c.split(';');
            
        return getAttachmentListFromIdList(attachmentIds);
    }

    public void saveImageAndProject()
    {
        if(imageAttachment.Body != null)
        {   
            if(overrideImage != null && overrideImage != '')
                imageAttachment.Name = overrideImage;               
            insert imageAttachment;
            
            if(oproject.ClosureImageAttachment__c != null)
                oproject.ClosureImageAttachment__c += imageAttachment.Id + ';';
            else
                oproject.ClosureImageAttachment__c = imageAttachment.Id + ';';          
            update oproject;
            
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :oproject.Id]);
            imageAttachment = null;
        }           
    }

    public list<Attachment> getAttachedDocumentLesson()
    {

        list<String> attachmentIds = new list<String>();
        if(oproject.ClosureLessonAttachment__c != null)
            attachmentIds = oproject.ClosureLessonAttachment__c.split(';');
            
        return getAttachmentListFromIdList(attachmentIds);
    }

    public void saveLessonAndProject()
    {
        if(lessonsAttachment.Body != null)
        {   
            if(overrideLessons != null && overrideLessons != '')
                lessonsAttachment.Name = overrideLessons;               
            insert lessonsAttachment;
            
            if(oproject.ClosureLessonAttachment__c != null)
                oproject.ClosureLessonAttachment__c += lessonsAttachment.Id + ';';
            else
                oproject.ClosureLessonAttachment__c = lessonsAttachment.Id + ';';          
            update oproject;
            
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :oproject.Id]);
            lessonsAttachment = null;
        }           
    }

    public list<Attachment> getAttachedDocumentCertificate()
    {

        list<String> attachmentIds = new list<String>();
        if(oproject.ClosureCertificateAttachment__c != null)
            attachmentIds = oproject.ClosureCertificateAttachment__c.split(';');
            
        return getAttachmentListFromIdList(attachmentIds);
    }

    public void saveCertificateAndProject()
    {
        if(certificateAttachment.Body != null)
        {   
            if(overrideCertificate != null && overrideCertificate != '')
                certificateAttachment.Name = overrideCertificate;               
            insert certificateAttachment;
            
            if(oproject.ClosureCertificateAttachment__c != null)
                oproject.ClosureCertificateAttachment__c += certificateAttachment.Id + ';';
            else
                oproject.ClosureCertificateAttachment__c = certificateAttachment.Id + ';';          
            update oproject;
            
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :oproject.Id]);
            certificateAttachment = null;
        }           
    }




    public pagereference stub(){
        return null;
    }

    public pagereference back(){
        return new pagereference('/' + oProject.id);
    }

    public pagereference closesave(){
        system.debug('HERE1');
        Savepoint oSavePoint = Database.setSavepoint();

        try{
            //oProject.pse__Stage__c = 'Approved';
            update oProject;
        }catch(EcoControllerException e){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to update project. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            Database.rollback(oSavePoint);
            return null; 
        } 

        createAlertsForClosure();

        return null;
    }

    public pagereference restart(){
        Savepoint oSavePoint = Database.setSavepoint();

        try{
            oProject.pse__Stage__c = 'Approved';
            update oProject;
        }catch(EcoControllerException e){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to update project. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            Database.rollback(oSavePoint);
            return null; 
        } 

        createAlertsForClosure();

        return new pagereference('/apex/ECO_ProjectSummary?projectId=' + oProject.id);

        //return null;
    }

    private boolean createAlertsForClosure(){

        boolean success = true;

        list<EmailTemplate> et = [select id from EmailTemplate where developername='EcoProjectTeamClosureNotify'];
        Contact c = [select id, Email from Contact where email <> null limit 1];

        if(oldClosureDate != oProject.ClosureDate__c){
            List<PortalMessage__c> messagesToAdd = new List<PortalMessage__c>();
            List<Messaging.SingleEmailMessage> emailList = new list<Messaging.SingleEmailMessage>();

            List<ProjectTeamMember__c> lProjectTeamMembers = new List<ProjectTeamMember__c>([Select Id
                                                                                                    , ProjectRole__c
                                                                                                    , ProjectRole__r.Name
                                                                                                    , ProjectRole__r.Type__c
                                                                                                    , Contact__c
                                                                                                    , contact__r.pse__Salesforce_User__c
                                                                                                    , contact__r.pse__Is_Resource_Active__c
                                                                                                    , ProjectRoleTitle__c
                                                                                                    , Project__c
                                                                                                    , StartDate__c
                                                                                                    , EndDate__c
                                                                                                    , Phone__c
                                                                                                    , Email__c
                                                                                                    , Active__c 
                                                                                                    From ProjectTeamMember__c Where Active__c = true and Project__c = :oProject.Id]);


            // This code is used to combat a silly limitation in SFDC. As of 06/2015 the whatid cannot be used with a targetobjectid OTHER than a contact.
            // This is not what we want.
            // However, the work around is to generate a dummy email using ANY contact, send the email (rollback the transaction - emailer sender waits for the transaction to complete....) and extract
            // the merged content for our purposes.
            List<Messaging.SingleEmailMessage> lstdummyemail = new list<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage demail = new Messaging.SingleEmailMessage();   
            demail.setTargetObjectId(c.id);
            demail.setSaveAsActivity(false);
            demail.setTemplateId(et[0].id);
            demail.setWhatId(oProject.id);
            lstdummyemail.add(demail);               

            Savepoint sp = Database.setSavepoint();
            //Messaging.sendEmail(lstdummyemail);
            Database.rollback(sp);
            
            for(ProjectTeamMember__c ptm: lProjectTeamMembers){
                if(ptm.contact__r.pse__Salesforce_User__c != null && et.size() > 0){
                    messagesToAdd.add(createNewAlert( oProject, ptm.contact__r.pse__Salesforce_User__c, date.today(), 'Closure date has been set to ' + oProject.ClosureDate__c.format(), alertRecordTypeId));

                    //for(integer i=0; i < 1000; i++){
                        Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();     
                        semail.setTargetObjectId(ptm.contact__r.pse__Salesforce_User__c);
                        semail.setSaveAsActivity(false);
                        //semail.setTemplateId(et[0].id);
                        //semail.setWhatId(oProject.id);

                        semail.setPlainTextBody(demail.getPlainTextBody());
                        semail.setHTMLBody(demail.getHTMLBody());
                        semail.setSubject(demail.getSubject());

                        emailList.add(semail);                           
                    //}

     
                }

            }

            try{
                if(messagesToAdd.size() > 0){
                    insert messagesToAdd;
                }

                EcoDisableProjectTeamClosureEmail__c settings = EcoDisableProjectTeamClosureEmail__c.getOrgDefaults();

                if(emailList.size() > 0 && settings.EcoDisableProjectTeamClosureEmail__c == false) {

                    Messaging.sendEmail(emailList);
                }
                
            }catch(EcoControllerException e){
                ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to create portal messages regarding closure date. Please contact your administrator with the following error: ' + e);
                ApexPages.addMessage(oMsg);
                success = false;
                return success;
            } 

        }

        return success;
    }


    private PortalMessage__c createNewAlert (pse__Proj__c proj, id userid, Date theDate, String theMessage, id msgrecordtypeid) {


        PortalMessage__c newPM = new PortalMessage__c();

        newPM.Project_Number__c = proj.EcoSystemReferenceNumber__c;
        newPM.User__c = userid;
        newPM.RecordTypeId = msgrecordtypeid;
        newPM.StartDate__c = theDate;
        newPM.EndDate__c = theDate.adddays(2);
        newPM.IsEscalationAlert__c = true;
        newPM.Subject__c = proj.name;
        newPM.LinkToRecord__c = URL.getSalesforceBaseUrl().toExternalForm()+'/'+proj.Id;
        newPM.LongDescriptionMaxLength__c = theMessage;
        return newPM;
    }
}