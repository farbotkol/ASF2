public class ECO_CloseoutOpportunityPhaseController {

    private Transient Attachment closureAttachment;
    public String overrideControlSystemName  {get;set;}
    public map<Id, Attachment> attachmentsMap {get; set;}

	public  pse__Proj__c oProject {get;set;}
    public  list<SelectOption> types { get; set; }

    public list<QuestionnaireSet__c> lstNogo {get;set;}

    /* Custom classes to facilitate this controller */
    public class EcoControllerException extends Exception {}

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public ECO_CloseoutOpportunityPhaseController(ApexPages.StandardController stdController) {
        this.oProject = (pse__Proj__c)stdController.getRecord();

        oProject = [select  id 
                            ,ClosureAttachment__c   
                            ,ProjOpptyClosureStatus__c
                            ,Reason_Won_or_Lost__c
                            ,StatusChangeDate__c
                            ,ProjOpptyCloseoutNotes__c
                            ,AlsoCloseRelatedOpportunityList__c
                            ,ClientDebrief__c
                            ,ClientDebriefNotes__c
                            ,InternalDebrief__c
                            ,InternalDebriefNotes__c
                            ,pse__Opportunity__c
                            ,pse__Opportunity__r.name
                            ,ProjectSectionHeaderName__c
                            ,ProjectClosureNotes__c
                    from pse__Proj__c
                    where id =: oProject.id];

        types = new List<SelectOption>();
        types.add(new SelectOption('No', 'No'));
        types.add(new SelectOption('Yes', 'Yes'));  
        

        lstNogo = [select id, GoNoGoDate__c from QuestionnaireSet__c where Project__c =: oProject.id and GoNoGoRecommendation__c = 'No Go' order by GoNoGoDate__c desc];

        if(lstNogo.size() > 0 && oProject.StatusChangeDate__c == null){
            oProject.StatusChangeDate__c = lstNogo[0].GoNoGoDate__c;
        }

        attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :oProject.Id]);
        
    }

    public pagereference createChangeManagement(){


        list<RecordType> lstRT = [select id from recordtype where sObjectType='ChangeManager__c' and developername='InternalChange'];

        ChangeManager__c cm = new ChangeManager__c(recordtypeid = lstRT[0].id, Project__c = oProject.id, IntExtProjectClosure__c=true);

        try{
            insert cm;
        }catch(EcoControllerException e){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to insert Change Manager: ' + e);
            ApexPages.addMessage(oMsg);
            return null; 
        } 

        return new pagereference('/apex/eco_changemanagerdetail?id=' + cm.id + '&Mode=Edit');


    }

    public pagereference createChangeManagementPlanning()
    {
        Id recordTypeId = [select Id from RecordType where Name = 'Customer Project (Planning)' limit 1].Id;
        oProject.RecordTypeId = recordTypeId;
        oProject.pse__Stage__c = 'Planning';

        Savepoint oSavePoint = Database.setSavepoint();

        try
        {
            update oProject;
        }
        catch(EcoControllerException e)
        {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to update project. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            Database.rollback(oSavePoint);
            return null; 
        } 

        /*list<RecordType> lstRT = [select id from recordtype where sObjectType='ChangeManager__c' and developername='InternalChange'];
        
        ChangeManager__c cm;
        
        cm = new ChangeManager__c(recordtypeid = lstRT[0].id, Project__c = oProject.id, IntExtProjectClosure__c=true,  IsProjectReOpen__c=true, IntExtProjectClosureComments__c = 'Putting Project back to Planning from No-Go');

        try{
            insert cm;
        }catch(EcoControllerException e){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to insert Change Manager: ' + e);
            ApexPages.addMessage(oMsg);
            return null; 
        } 

        return new pagereference('/apex/eco_changemanagerdetail?id=' + cm.id + '&Mode=');*/
        return new PageReference('/' + oProject.Id);
    }


    public Attachment dclosureAttachment
    {
        get
        {
            if(closureAttachment==null)
            {
                closureAttachment = new Attachment(parentid = oProject.id);
            }
            return closureAttachment;
        }
        set;
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
            if(oProject.ProjOpptyClosureStatus__c != null){
                oProject.pse__Stage__c = oProject.ProjOpptyClosureStatus__c.split(' ', 2)[1];
            }
            update oProject;
        }catch(EcoControllerException e){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to update project. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            Database.rollback(oSavePoint);
            return null; 
        } 

         system.debug('HERE2');
        if(oProject.AlsoCloseRelatedOpportunityList__c == 'Yes'){

            system.debug('HERE3');
            opportunity oOpp = [select id from opportunity where id=: oProject.pse__Opportunity__c];
            oOpp.StageName = oProject.ProjOpptyClosureStatus__c;
            oOpp.Reason_Won_or_Lost__c = oProject.Reason_Won_or_Lost__c;
            oOpp.Date_lost_cancelled_no_go__c = oProject.StatusChangeDate__c;
            oOpp.Reason_Won_or_Lost_Comment__c = oProject.ProjOpptyCloseoutNotes__c;

            try{
                update oOpp;
            
            }catch(EcoControllerException e){
                ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attmpting to update related opportunity. Please contact your administrator with the following error: ' + e);
                ApexPages.addMessage(oMsg);
                Database.rollback(oSavePoint);
                return null; 
            } 
        }

        return new pagereference('/' + oProject.id);
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

    public list<Attachment> getAttachedClosureFiles()
    {

        list<String> attachmentIds = new list<String>();
        if(oProject.ClosureAttachment__c != null)
            attachmentIds = oProject.ClosureAttachment__c.split(';');
            
        return getAttachmentListFromIdList(attachmentIds);
    }
    
    public pagereference saveClosureAttachmentAndProject()
    {
        if(closureAttachment.Body != null)
        {   
            if(overrideControlSystemName != null && overrideControlSystemName != '')
                closureAttachment.Name = overrideControlSystemName;               
            insert closureAttachment;
            
            if(oProject.ClosureAttachment__c != null)
                oProject.ClosureAttachment__c += closureAttachment.Id + ';';
            else
                oProject.ClosureAttachment__c = closureAttachment.Id + ';';          
            //update oProject;
            
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :oProject.Id]);
            closureAttachment = null;
        }   

        return null;        
    }
}