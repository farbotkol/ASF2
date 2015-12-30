public class ECO_DocumentManagementContoller {
    
    private Transient Attachment documentControlSystemAttachment;
    public String overrideControlSystemName  {get;set;}
    private Transient Attachment documentNamingConventionsAttachment;
    public String overrideNamingConventionsName  {get;set;}
    private Transient Attachment fileManagementStructureAttachment;
    public String overrideFileManagementStructureName  {get;set;}
    private Transient Attachment documentTransmittalsAttachment;
    public String overrideTransmittalsName {get;set;}
    private Transient Attachment documentRecordsAndArchivingAttachment;
    public String overrideRecordsArchivingName {get; set;}
    private Transient Attachment documentCommentsOtherNotesAttachment;
    public String overrideCommentsOtherNotesName {get; set;}
    
    public pse__Proj__c project;
    public map<Id, Attachment> attachmentsMap {get; set;}
    public list<SelectOption> types { get; set; }

    public boolean bAttachAvail {get;set;}
    
    public ECO_DocumentManagementContoller(ApexPages.StandardController controller)
    {
        project = (pse__Proj__c) controller.getRecord();
        
        attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :project.Id]);
        
        types = new List<SelectOption>();
        types.add(new SelectOption('AECOM', 'AECOM'));
        types.add(new SelectOption('Client/Project', 'Client/Project'));  

        bAttachAvail = true;
    }   
    
    public PageReference setDirty(){
        bAttachAvail = false;
        return null;
    }

    public Attachment docControlSystemAttachment
    {
        get
        {
            if(documentControlSystemAttachment==null)
            {
                documentControlSystemAttachment = new Attachment(parentid = project.id);
            }
            return documentControlSystemAttachment;
        }
        set;
    }
    
    public Attachment docNamingConventionsAttachment
    {
        get
        {
            if(documentNamingConventionsAttachment==null)
            {
                documentNamingConventionsAttachment = new Attachment(parentid = project.id);
            }
            return documentNamingConventionsAttachment;
        }
        set;
    }    
    
    public Attachment fManagementStructureAttachment
    {
        get
        {
            if(fileManagementStructureAttachment==null)
            {
                fileManagementStructureAttachment = new Attachment(parentid = project.id);
            }
            return fileManagementStructureAttachment;
        }
        set;
    } 
    
    public Attachment docTransmittalsAttachment
    {
        get
        {
            if(documentTransmittalsAttachment==null)
            {
                documentTransmittalsAttachment = new Attachment(parentid = project.id);
            }
            return documentTransmittalsAttachment;
        }
        set;
    }        
    
    public Attachment docRecordsAndArchivingAttachment
    {
        get
        {
            if(documentRecordsAndArchivingAttachment==null)
            {
                documentRecordsAndArchivingAttachment = new Attachment(parentid = project.id);
            }
            return documentRecordsAndArchivingAttachment;
        }
        set;
    } 
    
    public Attachment docCommentsOtherNotesAttachment
    {
        get
        {
            if(documentCommentsOtherNotesAttachment==null)
            {
                documentCommentsOtherNotesAttachment = new Attachment(parentid = project.id);
            }
            return documentCommentsOtherNotesAttachment;
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
       
    public list<Attachment> getAttachedDocumentControlSystemFiles()
    {

        list<String> attachmentIds = new list<String>();
        if(project.DocumentControlSystemAttachment__c != null)
            attachmentIds = project.DocumentControlSystemAttachment__c.split(';');
            
        return getAttachmentListFromIdList(attachmentIds);
    }
    
    public void saveDocumentControlSystemAttachmentAndProject()
    {
        if(documentControlSystemAttachment.Body != null)
        {   
            if(overrideControlSystemName != null && overrideControlSystemName != '')
                documentControlSystemAttachment.Name = overrideControlSystemName;               
            insert documentControlSystemAttachment;
            
            if(project.DocumentControlSystemAttachment__c != null)
                project.DocumentControlSystemAttachment__c += documentControlSystemAttachment.Id + ';';
            else
                project.DocumentControlSystemAttachment__c = documentControlSystemAttachment.Id + ';';          
            update project;
            
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :project.Id]);
            documentControlSystemAttachment = null;
        }           
    }
    
    public list<Attachment> getAttachedDocumentNamingConventionsFiles()
    {
        list<String> attachmentIds = new list<String>();
        if(project.DocumentNamingConventionsAttachment__c != null)
            attachmentIds = project.DocumentNamingConventionsAttachment__c.split(';');

        return getAttachmentListFromIdList(attachmentIds);
    }
    
    public void saveDocumentNamingConventionsAttachmentAndProject()
    {
        if(documentNamingConventionsAttachment.Body != null)
        {
            if(overrideNamingConventionsName != null && overrideNamingConventionsName != '')
                documentNamingConventionsAttachment.Name = overrideNamingConventionsName;                           
            insert documentNamingConventionsAttachment;
            
            if(project.DocumentNamingConventionsAttachment__c != null)
                project.DocumentNamingConventionsAttachment__c += documentNamingConventionsAttachment.Id + ';';
            else
                project.DocumentNamingConventionsAttachment__c = documentNamingConventionsAttachment.Id + ';';
            
            update project;
                
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :project.Id]);
            documentNamingConventionsAttachment = null; 
        }
    }
    
    public list<Attachment> getAttachedFileManagementStructureFiles()
    {
        list<String> attachmentIds = new list<String>();
        if(project.FileManagementStructureAttachment__c != null)
            attachmentIds = project.FileManagementStructureAttachment__c.split(';');

        return getAttachmentListFromIdList(attachmentIds);          
    }
    
    public void saveFileManagementStructureAttachmentAndProject()
    {
        if(fileManagementStructureAttachment.Body != null)
        {
            if(overrideFileManagementStructureName != null && overrideFileManagementStructureName != '')
                fileManagementStructureAttachment.Name = overrideFileManagementStructureName;                                       
            insert fileManagementStructureAttachment;
            
            if(project.FileManagementStructureAttachment__c != null)
                project.FileManagementStructureAttachment__c += fileManagementStructureAttachment.Id + ';';
            else
                project.FileManagementStructureAttachment__c = fileManagementStructureAttachment.Id + ';';
            
            update project;
                
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :project.Id]);
            fileManagementStructureAttachment = null;   
        }
    }    
    
    public list<Attachment> getAttachedDocumentTransmittalsFiles()
    {
        list<String> attachmentIds = new list<String>();
        if(project.DocumentTransmittalsAttachment__c != null)
            attachmentIds = project.DocumentTransmittalsAttachment__c.split(';');

        return getAttachmentListFromIdList(attachmentIds);          
    }    
    
    public void saveDocumentTransmittalsAttachmentAndProject()
    {
        if(documentTransmittalsAttachment.Body != null)
        {
            if(overrideTransmittalsName != null && overrideTransmittalsName != '')
                documentTransmittalsAttachment.Name = overrideTransmittalsName;             
            insert documentTransmittalsAttachment;
            
            if(project.DocumentTransmittalsAttachment__c != null)
                project.DocumentTransmittalsAttachment__c += documentTransmittalsAttachment.Id + ';';
            else
                project.DocumentTransmittalsAttachment__c = documentTransmittalsAttachment.Id + ';';
            
            update project;
                
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :project.Id]);
            documentTransmittalsAttachment = null;  
        }
    }    
      
    public list<Attachment> getAttachedDocumentRecordsAndArchivingFiles()
    {
        list<String> attachmentIds = new list<String>();
        if(project.DocumentRecordsArchivingAttachment__c != null)
            attachmentIds = project.DocumentRecordsArchivingAttachment__c.split(';');

        return getAttachmentListFromIdList(attachmentIds);          
    }     
                
    public void saveDocumentRecordsAndArchivingAttachmentAndProject()
    {
        if(documentRecordsAndArchivingAttachment.Body != null)
        {
            if(overrideRecordsArchivingName != null && overrideRecordsArchivingName != '')
                documentRecordsAndArchivingAttachment.Name = overrideRecordsArchivingName;              
            insert documentRecordsAndArchivingAttachment;
            
            if(project.DocumentRecordsArchivingAttachment__c != null)
                project.DocumentRecordsArchivingAttachment__c += documentRecordsAndArchivingAttachment.Id + ';';
            else
                project.DocumentRecordsArchivingAttachment__c = documentRecordsAndArchivingAttachment.Id + ';';
            
            update project;
                
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :project.Id]);
            documentRecordsAndArchivingAttachment = null;   
        }
    }     
           
    public list<Attachment> getAttachedDocumentCommentsOtherNotesFiles()
    {
        list<String> attachmentIds = new list<String>();
        if(project.DocumentOtherCommentsNotesAttachment__c != null)
            attachmentIds = project.DocumentOtherCommentsNotesAttachment__c.split(';');

        return getAttachmentListFromIdList(attachmentIds);          
    }     
    
    public void saveDocumentCommentsOtherNotesAttachmentAndProject()
    {
        if(documentCommentsOtherNotesAttachment.Body != null)
        {
            if(overrideCommentsOtherNotesName != null && overrideCommentsOtherNotesName != '')
                documentCommentsOtherNotesAttachment.Name = overrideCommentsOtherNotesName;             
            insert documentCommentsOtherNotesAttachment;
            
            if(project.DocumentOtherCommentsNotesAttachment__c != null)
                project.DocumentOtherCommentsNotesAttachment__c += documentCommentsOtherNotesAttachment.Id + ';';
            else
                project.DocumentOtherCommentsNotesAttachment__c = documentCommentsOtherNotesAttachment.Id + ';';
            
            update project;
                
            attachmentsMap = new Map<Id, Attachment>([select Id, Name, ContentType, LastModifiedDate, LastModifiedById from Attachment where parentId = :project.Id]);
            
            documentCommentsOtherNotesAttachment = null;    
        }
    } 
    
    public PageReference save()
    {                       
        update project;
        bAttachAvail = true;
                
        return null;
    }
}