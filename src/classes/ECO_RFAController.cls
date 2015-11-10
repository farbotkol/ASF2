public with sharing class ECO_RFAController {

	private final string PRMDelim = ',,,,';
	private final string PRMItemDelim = '!!';

	public Form__c oForm {get;set;}
	public list<DOARegister__c> DOARegisters {get;set;}
    public list<DOARegister__c> DOARegistersNP {get;set;}
	public list<DOARegister__c> NonProjectRelatedMatters {get;set;}
    public list<DOA_TriggerWrapper> lstDOATriggers {get; set;}
    public list<TemplateQuestion__c> lstTemplateQues {get;set;}
    public set<Id> setTemplateQuesIds {get;set;}
    public list<TemplateQuestion__c> lstTemplateQuestions {get;set;}
    
    public pse__Proj__c proj {get;set;}
    public DOARegister__c newTrigger {get;set;}
    public TemplateQuestion__c tQuestions {get;set;}
    
    public id doaRegisterId {get;set;}
    public id idQuestionID {get;set;}
	public integer selectedIndex {get;set;}
    
    public String selectBusiness {get;set;}
    public String selectGeography {get;set;}
    public String selectQuestionnaire {get;set;}
    public String doaRecordType {get;set;}
    public String projName {get;set;}
    public String opptyId {get;set;}
    public String ecosystem {get;set;}
    public String oracleProjNumber {get;set;}
    public Integer totalRecs {get;set;}
	public Integer OffsetSize {get;set;}
	public Integer LimitSize {get;set;}
    public String fromVisualforce {get;set;}
    public Boolean isNonProjectRelated {get;set;}
    public Boolean isDeleteRendered{get;set;}
	private integer index;

	public ECO_RFAController(ApexPages.StandardController stdController) {
		this.oForm = (Form__c)stdController.getRecord();
        fromVisualforce = null;
		fromVisualforce = ApexPages.currentPage().getParameters().get('vfp');
		if(oForm.id == null){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You have arrived to this page through inappropriate channels');
            ApexPages.addMessage(oMsg);
		}

		
        
        string strSOQL = 'SELECT ';
        string formid = oForm.id;
            
        for (Schema.FieldSetMember fsmField: SObjectType.Form__c.FieldSets.RFABusinessGroup.getFields()) {
            strSOQL += fsmField.getFieldPath() + ', ';
        }
        
        strSOQL += 'ID, DOAApprovalRequest__c, ReasonForRequest__c, ProposedReviewCategoryChange__c, DOAApprovalRequest__r.RecordType.DeveloperName, JustificationReviewCategoryChange__c, NonProjectRelatedMatters__c, Projid__c, Business_Group__c, OwningOrganization__c, ProjectNameSubject__c, OpportunityNumber__c, OracleProjectNumber__c FROM Form__c WHERE id=: formid';

        list<Form__c> lstform = (list<Form__c>)Database.query(strSOQL);
		oForm = lstform[0];
		
        proj = new pse__Proj__c();
        loadDoaMatters();
        doaRecordType = oForm.DOAApprovalRequest__r.RecordType.DeveloperName;
		System.debug('doa recordtype id:'+oForm.DOAApprovalRequest__r.RecordTypeId);

	}
    public Boolean getisNonProjectRelated(){
        if(oForm.Projid__c == null || oForm.Projid__c == '')
            isNonProjectRelated = true;
        else
            isNonProjectRelated = false;
        System.debug('isNonProjectRelated   :'+isNonProjectRelated);
        return isNonProjectRelated;
    }
    public Boolean getisDeleteRendered(){
        RecordType rt = [Select Id, DeveloperName From RecordType Where Id = :oForm.DOAApprovalRequest__r.RecordTypeId];
        System.debug('rt.DeveloperName:  '+rt.DeveloperName);
        if(rt.DeveloperName == 'DOAQueueEntry' || rt.DeveloperName == 'NonProject')
        	return false;
        else
            return true;
    }
    public void loadDoaMatters(){
        this.DOARegisters = [select id, name, EnterpriseDOA__c, DCSsubDOA__c, DOATrigger__c, RiskTitle__c, TemplateQuestion__c, TemplateQuestion__r.Question__c from DOARegister__c where DOAApprovalRequest__c =: oForm.DOAApprovalRequest__c];

		NonProjectRelatedMatters = new list<DOARegister__c>();

		index = 0;

		if(oForm.NonProjectRelatedMatters__c != null){
			list<string> lstPRM = oForm.NonProjectRelatedMatters__c.split(PRMDelim, 0);


			for(string PRM: lstPRM){

				if(PRM == null || PRM==''){
					continue;
				}

				index +=1;

				list<string> PRMitems = PRM.split(PRMItemDelim, 0);

				if(PRMitems.size() == 3){
					NonProjectRelatedMatters.add(new DOARegister__c(IndexNumber__c = index, EnterpriseDOA__c = PRMitems[0], DCSsubDOA__c = PRMitems[1], DOATrigger__c = PRMitems[0]));

				} else {
		            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Encountered an error while trying to read Non Project Related Matters: ' + PRM);
		            ApexPages.addMessage(oMsg);
				}	
			}
		}
    }
	public pagereference AddNonProjectRelatedMatter(){
		index +=1;
		NonProjectRelatedMatters.add(new DOARegister__c(IndexNumber__c = index));
		return null;
	}
	
    public PageReference deleteDOARegister(){
        DOARegister__c doaReg = [Select Id From DOARegister__c Where Id =: doaRegisterId];
        try{
            delete doaReg;
            loadDoaMatters();
            loadDOAList();
        	return null;
        }catch(Exception e){
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to delete DOA Register. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
        }
        
    }
    
	public pagereference RemoveNonProjectRelatedMatter(){

		list<DOARegister__c> newlist = new list<DOARegister__c>();

		for(DOARegister__c d: NonProjectRelatedMatters){
			if(d.IndexNumber__c != selectedIndex){
				newlist.add(d);
			}
		}

		NonProjectRelatedMatters = newlist;

		return null;
	}


	private boolean writeAddNonProjectRelatedMatterToField(){
		
		string finalstorage ='';

		for(DOARegister__c d: NonProjectRelatedMatters){

			if(d.EnterpriseDOA__c == null || d.DCSsubDOA__c == null || d.DOATrigger__c == null || d.EnterpriseDOA__c.trim().length() == 0 || d.DCSsubDOA__c.trim().length() == 0 || d.DOATrigger__c.trim().length() == 0){
	            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please complete all fields for Non-Project Matters');
	            ApexPages.addMessage(oMsg);
	            return false;
			}

			finalstorage += PRMDelim + d.EnterpriseDOA__c + PRMItemDelim + d.DCSsubDOA__c + PRMItemDelim + d.DOATrigger__c;
		
		}

		oForm.NonProjectRelatedMatters__c = finalstorage;
		return true;
	}

	public pagereference saveForm(){
		//if(writeAddNonProjectRelatedMatterToField()){
        	try{
                if(oForm.Projid__c == null || oForm.Projid__c == '' ){
                    System.debug('oForm fields   '+oForm.Business_Group__c);
                    update oForm;
                    DOAApprovalRequest__c doa = new DOAApprovalRequest__c();
                    doa = [Select Id, OracleProjectNumber__c, OpportunityNumber__c, ProjectNameSubject__c From DOAApprovalRequest__c Where Id = :oForm.DOAApprovalRequest__c];
                    doa.OracleProjectNumber__c = oForm.OracleProjectNumber__c;
                    doa.OpportunityNumber__c = oForm.OpportunityNumber__c;
                    doa.ProjectNameSubject__c = oForm.ProjectNameSubject__c;
                    
                    update doa;	
                }
                else
                    update oForm;
                return null;
                
			} catch (Exception e) {
	            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to update the form. Please contact your administrator with the following error: ' + e);
	            ApexPages.addMessage(oMsg);
	            return null;
			}
		

	}
    public void init(){
        
        
        totalRecs = 0;
        OffsetSize = 0;
		LimitSize= 20;
        
        
        
        if(oForm.Projid__c == null || oForm.Projid__c == '')
            isNonProjectRelated = true;
        else{
            isNonProjectRelated = false;
            proj = [Select Id, OpportunityID__c, Name, pse__Project_ID__c, OracleProjectnumber__c From pse__Proj__c Where Id = :oForm.Projid__c] ;
            projName = proj.Name;
            opptyId = proj.OpportunityID__c;
            ecosystem = proj.pse__Project_ID__c;
            oracleProjNumber = proj.OracleProjectnumber__c;
        }
        System.debug('isNonProjectRelated   :'+isNonProjectRelated);
        
        newTrigger = new DOARegister__c();
        tQuestions = new TemplateQuestion__c();
        lstDOATriggers = new list<DOA_TriggerWrapper>();
        loadDOAList();
        
    }
	private void loadTriggers(){

        string strSOQL = 'SELECT ';
        for (Schema.FieldSetMember fsmField: SObjectType.DOARegister__c.FieldSets.DOA_TriggerView.getFields()) {
            strSOQL += fsmField.getFieldPath() + ', ';
        }
        
        strSOQL += 'ID, DOAApprovalRequest__c FROM DOARegister__c WHERE Project__c = null order by DOAApprovalRequest__c ASC';
        list<DOARegister__c> lstRiskSearch = (list<DOARegister__c>)Database.query(strSOQL);

        for(DOARegister__c DOAR: lstRiskSearch){
            lstDOATriggers.add(new DOA_TriggerWrapper(DOAR));
        }
    }
    public class DOA_TriggerWrapper {

        public boolean bChecked {get;set;}
        public DOARegister__c oTrigger {get;set;}

        public DOA_TriggerWrapper(DOARegister__c oTrigger){
            this.oTrigger = oTrigger;
            
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
            newTrigger.DOAApprovalRequest__c = oForm.DOAApprovalRequest__c;
            
            insert newTrigger;

            newTrigger = new DOARegister__c();
            
            lstDOATriggers = new list<DOA_TriggerWrapper>();
            loadTriggers();
            loadDoaMatters();
            loadDOAList();
            return null;
            
        } catch (Exception e) {
            ApexPages.Message oMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An Error has occurred while attempting to add a DOA Trigger. Please contact your administrator with the following error: ' + e);
            ApexPages.addMessage(oMsg);
            return null;
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
        //List<TemplateQuestion__c> lstTQ = new List<TemplateQuestion__c>();
        
        for (Schema.FieldSetMember fsmField: SObjectType.TemplateQuestion__c.FieldSets.DOA_Register_Fields.getFields()) {
            strSOQL += fsmField.getFieldPath() + ', ';
        }
        strSOQLsort = strSOQL + 'ID FROM TemplateQuestion__c WHERE IsNonProjectRelated__c = TRUE ORDER BY QuestionnaireTemplate__c ASC';
        if(selectQuestionnaire == null){
            //strSOQL += 'ID FROM TemplateQuestion__c WHERE IsDoATrigger__c = TRUE AND BusinessLinesAvailableTo__c = :selectBusiness AND GeographiesAvailableTo__c = :selectGeography ORDER BY QuestionnaireTemplate__c ASC LIMIT :LimitSize OFFSET :OffsetSize';
            strSOQL += 'ID FROM TemplateQuestion__c WHERE IsNonProjectRelated__c = TRUE AND BusinessLinesAvailableTo__c = :selectBusiness AND GeographiesAvailableTo__c = :selectGeography ORDER BY QuestionnaireTemplate__c ASC LIMIT :LimitSize OFFSET :OffsetSize';
        }
        else
            strSOQL += 'ID FROM TemplateQuestion__c WHERE IsNonProjectRelated__c = TRUE AND BusinessLinesAvailableTo__c = :selectBusiness AND GeographiesAvailableTo__c = :selectGeography AND QuestionnaireTemplate__r.Name = :selectQuestionnaire ORDER BY QuestionnaireTemplate__c ASC LIMIT :LimitSize OFFSET :OffsetSize'; 
    	
        
        setTemplateQuesIds = new Set<Id>();
        lstTemplateQuestions = new List<TemplateQuestion__c>();
        lstTemplateQues = new List<TemplateQuestion__c>();
        lstTemplateQues = (list<TemplateQuestion__c>)Database.query(strSOQL);
        
        for(DOARegister__c doar : DOARegisters){
            setTemplateQuesIds.add(doar.TemplateQuestion__c);
        }
        
        for(TemplateQuestion__c tq: lstTemplateQues){
        	if(!setTemplateQuesIds.contains(tq.Id)){
                lstTemplateQuestions.add(tq);
            }
        }
        System.debug('lstTemplateQuestions size::::'+lstTemplateQuestions.size());
    }
    public List<selectOption> getBusinessLines()
    {
        System.debug('inside getBusinessLines');
        List<selectOption> businessOptions = new List<selectOption>();
        
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
}