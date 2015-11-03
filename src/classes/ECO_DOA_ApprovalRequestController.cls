public with sharing class ECO_DOA_ApprovalRequestController {

    public list<DOA_TriggerWrapper> lstDOATriggers {get; set;}
    public list<DOAApprovalRequest__c> lstDOARequests {get; set;}
    public list<TemplateQuestion__c> lstTemplateQues {get;set;}
    public set<id> setRequestIds {get;set;}
    public id idQuestionID {get;set;}
    public id deleteId {get;set;}
    public list<DOAConditions__c> lstDOAConditions {get; set;}
    public set<Id> setDOARegister {get;set;}
    public list<DOARegister__c> lstDOARegister {get;set;}
    
    public string questionOne {get;set;}
    public string questionTwo {get;set;}
    public string questionThree {get;set;}
    public String selectBusiness {get;set;}
    public String selectGeography {get;set;}
    public String selectQuestionnaire {get;set;}
    
    public Integer totalRecs {get;set;}
	public Integer OffsetSize {get;set;}
	public Integer LimitSize {get;set;}
	    
    public list<SelectOption> types { get; set; }
    
    public DOARegister__c newTrigger {get;set;}
    public TemplateQuestion__c tQuestions {get;set;}

    public id projectID {get;set;}
    public pse__Proj__c theProject {get; set;}

    public ECO_DOA_ApprovalRequestController() {
        String projID = ApexPages.currentPage().getParameters().get('projectID');
        init(projID);
    }
    
    public ECO_DOA_ApprovalRequestController(String projectId) {
        init(projectId);
    }
    
    public void init(String projID) {
        lstDOATriggers = new list<DOA_TriggerWrapper>();
        lstDOARequests = new list<DOAApprovalRequest__c>();
        lstDOAConditions = new list<DOAConditions__c>();
        setRequestIds = new set<id>();
        totalRecs = 0;
        OffsetSize = 0;
		LimitSize= 20;
        if (projID != null) {
            this.projectID = projID;
            theProject = [select Id, Name,ProjectNumber__c from pse__Proj__c where Id = :projID];
            setDOARegister = new set<Id>();
            //setDOARegister = new set<Id>([Select Id from DOARegister__c Where TemplateQuestion__c != NULL AND Project__c = :projID]);
            for(DOARegister__c oDOA : [Select Id, TemplateQuestion__c from DOARegister__c Where TemplateQuestion__c != NULL AND Project__c = :projID]){
                setDOARegister.add(oDOA.TemplateQuestion__c);
            }
            System.debug('setDOARegister size: '+setDOARegister.size());
            
            loadTriggers();
            loadApprovalRequest();
            loadConditions();
            loadDOAList();
        }
        loadTriggers();
		loadDOAList();
        types = new List<SelectOption>();
        types.add(new SelectOption('No', 'No'));
        types.add(new SelectOption('Yes', 'Yes'));        

        newTrigger = new DOARegister__c();
        tQuestions = new TemplateQuestion__c();
    }
    

    private void loadTriggers(){

        string strSOQL = 'SELECT ';
            
        for (Schema.FieldSetMember fsmField: SObjectType.DOARegister__c.FieldSets.DOA_TriggerView.getFields()) {
            strSOQL += fsmField.getFieldPath() + ', ';
        }
        
        if(projectID != null)
        	strSOQL += 'ID, DOAApprovalRequest__c FROM DOARegister__c WHERE Project__c = \'' + projectID + '\' order by DOAApprovalRequest__c ASC';
		else
            strSOQL += 'ID, DOAApprovalRequest__c FROM DOARegister__c WHERE Project__c = null order by DOAApprovalRequest__c ASC';
        list<DOARegister__c> lstRiskSearch = (list<DOARegister__c>)Database.query(strSOQL);

        for(DOARegister__c DOAR: lstRiskSearch){
            lstDOATriggers.add(new DOA_TriggerWrapper(DOAR));
        }
    }

    private void loadApprovalRequest(){

        string strSOQL = 'SELECT ';
            
        for (Schema.FieldSetMember fsmField: SObjectType.DOAApprovalRequest__c.FieldSets.DOA_RequestView.getFields()) {
            strSOQL += fsmField.getFieldPath() + ', ';
        }
        if(projectID != null)
        	strSOQL += 'ID FROM DOAApprovalRequest__c WHERE Project__c = \'' + projectID + '\'';
        else
            strSOQL += 'ID FROM DOAApprovalRequest__c WHERE Project__c = null';

        lstDOARequests = (list<DOAApprovalRequest__c>)Database.query(strSOQL);

        for(DOAApprovalRequest__c AR: lstDOARequests){
            setRequestIds.add(AR.id);
        }
        

    }
   
    
    private void loadDOAList(){
        string strSOQL = 'SELECT ';
        string strSOQLsort;
        System.debug('selectBusiness : '+selectBusiness);
        System.debug('selectGeography : '+selectGeography);
        System.debug('selectQuestionnaire : '+selectQuestionnaire);
        if(selectBusiness == null)
            selectBusiness = 'ALL';
        if(selectGeography == null)
            selectGeography = 'ALL';
        List<TemplateQuestion__c> lstTQ = new List<TemplateQuestion__c>();
        
        for (Schema.FieldSetMember fsmField: SObjectType.TemplateQuestion__c.FieldSets.DOA_Register_Fields.getFields()) {
            strSOQL += fsmField.getFieldPath() + ', ';
        }
        strSOQLsort = strSOQL + 'ID FROM TemplateQuestion__c WHERE IsDoATrigger__c = TRUE ORDER BY QuestionnaireTemplate__c ASC';
        if(projectID != null){
            if(selectQuestionnaire == null){
                strSOQL += 'ID FROM TemplateQuestion__c WHERE IsDoATrigger__c = TRUE AND BusinessLinesAvailableTo__c = :selectBusiness AND GeographiesAvailableTo__c = :selectGeography ORDER BY QuestionnaireTemplate__c ASC LIMIT :LimitSize OFFSET :OffsetSize';
            }
            else
                strSOQL += 'ID FROM TemplateQuestion__c WHERE IsDoATrigger__c = TRUE AND BusinessLinesAvailableTo__c = :selectBusiness AND GeographiesAvailableTo__c = :selectGeography AND QuestionnaireTemplate__r.Name = :selectQuestionnaire ORDER BY QuestionnaireTemplate__c ASC LIMIT :LimitSize OFFSET :OffsetSize';
        	
        }
        else{
            if(selectQuestionnaire == null){
                strSOQL += 'ID FROM TemplateQuestion__c WHERE IsNonProjectRelated__c = TRUE AND BusinessLinesAvailableTo__c = :selectBusiness AND GeographiesAvailableTo__c = :selectGeography ORDER BY QuestionnaireTemplate__c ASC LIMIT :LimitSize OFFSET :OffsetSize';
            }
            else
            	strSOQL += 'ID FROM TemplateQuestion__c WHERE IsNonProjectRelated__c = TRUE AND BusinessLinesAvailableTo__c = :selectBusiness AND GeographiesAvailableTo__c = :selectGeography AND QuestionnaireTemplate__r.Name = :selectQuestionnaire ORDER BY QuestionnaireTemplate__c ASC LIMIT :LimitSize OFFSET :OffsetSize'; 
    	}
        
        lstTemplateQues = (list<TemplateQuestion__c>)Database.query(strSOQL);
        totalRecs = lstTQ.size();
        System.debug('lstTemplateQues.size:  '+lstTemplateQues.size());
    }
    
    private void loadConditions(){

        if(setRequestIds.size() >0){
            string strSOQL = 'SELECT ';
                
            for (Schema.FieldSetMember fsmField: SObjectType.DOAConditions__c.FieldSets.DOA_ApprovalView.getFields()) {
                strSOQL += fsmField.getFieldPath() + ', ';
            }
            
            strSOQL += 'ID, CreatedBy__c,  CreatedDate FROM DOAConditions__c WHERE DOAApprovalRequest__c IN: setRequestIds';

            lstDOAConditions = (list<DOAConditions__c>)Database.query(strSOQL);
        }
    }
    
    
    
    public Pagereference addQuestion(){
        try{
            System.debug('idQuestionID:    '+idQuestionID);
            newTrigger = new DOARegister__c();
            tQuestions = [Select Id, 
                                Question__c, 
                                DCSSubDOA__c, 
                                QuestionnaireTemplate__c, 
                                EnterpriseDOA__c, 
                                RiskTitle__c 
                                from TemplateQuestion__c 
                                Where Id = :idQuestionID];
            
            newTrigger.DOATrigger__c = tQuestions.Question__c;
            newTrigger.DCSsubDOA__c = tQuestions.DCSSubDOA__c;
            //newTrigger.Questionnaire__c = tQuestions.QuestionnaireTemplate__c;
            newTrigger.EnterpriseDOA__c = tQuestions.EnterpriseDOA__c;
            newTrigger.RiskTitle__c = tQuestions.RiskTitle__c;
            newTrigger.TemplateQuestion__c = tQuestions.Id;
            if(projectID != null)
            	newTrigger.Project__c = projectID;
            
            insert newTrigger;

            newTrigger = new DOARegister__c();
            
            lstDOATriggers = new list<DOA_TriggerWrapper>();
            loadTriggers();
            
            return null;
            
        } catch (Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to add a DOA Trigger. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
        }
    }
    
    public List<selectOption> getBusinessLines()
    {
        System.debug('inside getBusinessLines');
        List<selectOption> businessOptions = new List<selectOption>();
        //businessOptions.add(new selectOption('', '- None -'));
        
        Schema.DescribeFieldResult businessField = TemplateQuestion__c.BusinessLinesAvailableTo__c.getDescribe();
        List<Schema.PicklistEntry> plBusiness = businessField.getPicklistValues();
        
        for( Schema.PicklistEntry valueBusiness : plBusiness)
        {
            businessOptions.add(new SelectOption(valueBusiness.getLabel(), valueBusiness.getValue()));
        }       
        return businessOptions;
	}
    
    public List<selectOption> getGeographies()
    {
        System.debug('inside getGeographies');
        List<selectOption> options = new List<selectOption>();
        //options.add(new selectOption('', '- None -'));
        Schema.DescribeFieldResult fieldResult = TemplateQuestion__c.GeographiesAvailableTo__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
	}
	
    public List<selectOption> getQuestionnaires()
    {
        System.debug('inside getQuestionnaires');
        List<selectOption> options = new List<selectOption>();
        List<String> name = new List<String>();
        for(QuestionnaireTemplate__c oQT : [Select Name from QuestionnaireTemplate__c]){
            name.add(oQT.Name);
        }
        options.add(new selectOption('', '- None -'));
        
        /*Schema.DescribeFieldResult fieldResult = QuestionnaireTemplate__c.Name.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }*/
        for(String QuesName : name){
            options.add(new SelectOption(QuesName, QuesName));
        }
        return options;
	}
    
    public PageReference searchQuestionnaire(){
        System.debug('selectBusiness   '+selectBusiness);
        System.debug('selectGeography   '+selectGeography);
        System.debug('selectQuestionnaire   '+selectQuestionnaire);
        loadDOAList();
        return null;
    }
    
    public pageReference deleteDOA(){
        try{
            newTrigger = [Select Id from DOARegister__c where Id = :deleteId];
            
            delete newTrigger;
            
            newTrigger = new DOARegister__c();
            
            lstDOATriggers = new list<DOA_TriggerWrapper>();
            loadTriggers();
            
        	return null;
            
        }catch (Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to add a DOA Trigger. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
        }
        
    }
    
    /*public pagereference addTrigger(){
        try{
            newTrigger.Project__c = projectID;
            insert newTrigger;

            newTrigger = new DOARegister__c();

            lstDOATriggers = new list<DOA_TriggerWrapper>();
            loadTriggers();
            return null;

        } catch (Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to add a DOA Trigger. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
        }

        
    }*/

    public pagereference  questions(){

        boolean found = false;

        for(DOA_TriggerWrapper t: lstDOATriggers ){
            if(t.bChecked){
                found = true;
                break;
            }
        }

        if(found){
            return new pagereference('/apex/ECO_DOA_ApprovalRequestCreation');
        } else {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot make a request without selecting DOA Triggers.');
            ApexPages.addMessage(oMsg);         
            return null;
        }


        
    }

    public pagereference  back(){
        return new pagereference('/apex/ECO_DOA_ApprovalRequest');
    }

    public pagereference createRequest(){
        list<recordtype> lstDOART = new List<recordtype>();
		if(projectId != null)
        	lstDOART = [select id, name from recordtype where sObjectType='DOAApprovalRequest__c' and DeveloperName ='DOACreate'];
		else
			lstDOART = [select id, name from recordtype where sObjectType='DOAApprovalRequest__c' and DeveloperName ='NonEcosystemCreate'];            
        
        DOAApprovalRequest__c oNewDOA = new DOAApprovalRequest__c();
        
        oNewDOA.recordtypeid = lstDOART[0].id;
        oNewDOA.ApprovalStatus__c = 'Unapproved';
        if(projectID!= null)
        	oNewDOA.Project__c = projectID;
        Savepoint oSavePoint = Database.setSavepoint();
		
        
        try {
            insert oNewDOA;
        } catch (Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to create a DOA Request. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            Database.rollback(oSavePoint);
            return null;
        }

        list<DOARegister__c> lstTriggersToUpdate = new list<DOARegister__c>();

        for(DOA_TriggerWrapper t: lstDOATriggers ){
            if(t.bChecked){
                t.oTrigger.DOAApprovalRequest__c = oNewDOA.id;
                lstTriggersToUpdate.add(t.oTrigger);
            }
        }

        try {
            update lstTriggersToUpdate;
        } catch (Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to Update DOA Triggers. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            Database.rollback(oSavePoint);
            return null;
        }

        list<recordtype> lstRecordTypes = [select id, name from recordtype where sObjectType ='Form__c'];
        map<string, id> mapRecType = new map<string, id>();

        for(recordtype r: lstRecordTypes){
            mapRecType.put(r.name, r.id);
        }

        list<form__c> lstFormsToInsert = new list<form__c>();

        form__c newForm = new form__c();
        form__c newForm2 = new form__c();
        newForm.DOAApprovalRequest__c = oNewDOA.id;
        newForm2.DOAApprovalRequest__c = oNewDOA.id;

        if(questionOne == 'No'){
            newForm.recordtypeid = mapRecType.get('RFA');
            lstFormsToInsert.add(newForm);
        } else if(questionTwo == 'Yes'){
            newForm.recordtypeid = mapRecType.get('ORM Memo');
            lstFormsToInsert.add(newForm);
        } else if (questionThree == 'Yes'){
            //newForm.recordtypeid = mapRecType.get('RCST');
            //lstFormsToInsert.add(newForm);
            newForm2.recordtypeid = mapRecType.get('ORM Memo');
            lstFormsToInsert.add(newForm2);
            oNewDOA.Enable_RCST_Button__c = true;
        } else if (questionThree == 'No'){
            newForm.recordtypeid = mapRecType.get('RFA');
            lstFormsToInsert.add(newForm);
        }


        try {
            insert lstFormsToInsert;
            if(questionThree == 'Yes')
               update oNewDOA;
        } catch (Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to create a DOA Form. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            Database.rollback(oSavePoint);
            return null;
        }
        //return new pagereference('/' + oNewDOA.id);
        //return new pagereference('/'+ oNewDOA.id +'/e?retURL=/'+ oNewDOA.id);
        if(questionThree == 'Yes')
            //return new pagereference('/'+ newForm2.id +'/e?retURL=/'+ oNewDOA.id);
        	return new pagereference('/'+oNewDOA.id);
        else
        	return new pagereference('/'+ lstFormsToInsert[0].id +'/e?retURL=/'+ oNewDOA.id);
    }

    public pagereference stub(){
        return null;
    }

    public pagereference answerone(){
        questionTwo = null;
        questionThree = null;
        return null;
    }

    public pagereference answertwo(){
        questionThree = null;
        return null;
    }

    public pagereference answerthree(){
        return null;
    }   

    public class DOA_TriggerWrapper {

        public boolean bChecked {get;set;}
        public DOARegister__c oTrigger {get;set;}

        public DOA_TriggerWrapper(DOARegister__c oTrigger){
            this.oTrigger = oTrigger;
            bChecked = false;
        }
    }
    
    public void FirstPage(){
        OffsetSize = 0;
        loadDOAList();
    }
    
    public void Previous(){
        OffsetSize = OffsetSize - LimitSize;
        loadDOAList();
    }
    
    public void next(){
        OffsetSize = OffsetSize + LimitSize;
        loadDOAList();
    }
    
    public void lastPage(){
        OffsetSize = totalrecs - math.mod(totalrecs, LimitSize);
        loadDOAList();
    }
    
    public Boolean getPrev(){
        if(OffsetSize==0)
            return true;
        else
            return false;
    }
    
    public Boolean getNxt(){
        if((OffsetSize + LimitSize)>totalrecs)
            return true;
        else 
            return false;
    }
    
    /*public PageReference selectAllQuestions(){
        try{
            Integer count = 0;
            lstDOARegister = new List<DOARegister__c>();
            if(lstTemplateQues.size()>0){
                for(TemplateQuestion__c oQuestion : lstTemplateQues){
            		newTrigger = new DOARegister__c();
                    newTrigger.DOATrigger__c = oQuestion.Question__c;
                    newTrigger.DCSsubDOA__c = oQuestion.DCSSubDOA__c;
                    //newTrigger.Questionnaire__c = oQuestion.QuestionnaireTemplate__c;
                    newTrigger.EnterpriseDOA__c = oQuestion.EnterpriseDOA__c;
                    newTrigger.RiskTitle__c = oQuestion.RiskTitle__c;
                    newTrigger.TemplateQuestion__c = oQuestion.Id;
                    newTrigger.Project__c = projectID;
                    
                    lstDOARegister.add(newTrigger);
                    count++;
                    newTrigger = new DOARegister__c();
                
        		}
                if(lstDOARegister.size()>0)
                	insert lstDOARegister;
                loadTriggers();
            }
            System.debug('count:   '+count);
            return null;
        }catch(Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to add a DOA Trigger. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
        }
        
    }*/

}