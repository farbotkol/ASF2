public with sharing class ECO_RMAQuestionnaireController extends ECO_PageControllerBase 
{

	public Questionnaire__c oQuestionnaire {get; set;}
	public list<Questionnaire__c> lQuestionnaires {get; set;}
	public ApexPages.StandardController oStandardController {get; set;}
	public Boolean showDOASection {get; set;}
    public Boolean showDOASubSection {get; set;}
    public Answer__c DOA_SectionAnswer {get;set;}

	private integer iIndex {get; set;}

	public class EcoControllerException extends Exception {}

	public map<string, list<Answer__c>> mDoAAnswers {get; set;}
	public map<string, list<Answer__c>> mNotDoAAnswers {get; set;}
	public list<Answer__c> lAnswers {get; set;}
	public Map<Id, Risk__c> questionToRiskMap { get; set; }  // Key is TemplateQuestion__c id
    public Map<Id, DOARegister__c> questionToDOAMap { get; set; }  // Key is TemplateQuestion__c id
    public list<TemplateQuestion__c> lTemplateQuestion {get; set;}
    public list<SelectOption> lAnswerValues {get; set;}
    public list<SelectOption> lAnswerValuesBoolean {get; set;}
    public list<Answer__c> deleteAnswer {get;set;}
    public Id selectedQuestionId {get; set;}
    public Id navTargetQuestionnaireId {get;set;}

    public ECO_RMAQuestionnaireController(ApexPages.StandardController oStandardController) {
    	showDOASection = false;
    	showDOASubSection = false;
        list<string> lFields = new list<string>();
        lFields.add('QuestionnaireSet__c');
        lFields.add('QuestionnaireSet__r.Project__c');
        lFields.add('QuestionnaireTemplate__c');
        oStandardController.addFields(lFields);

        DOA_SectionAnswer = null;


        lAnswerValues = new list<SelectOption>{
            new SelectOption('Yes', 'Yes'),
            new SelectOption('No', 'No'),
            new SelectOption('Unknown', 'Unknown')
        };
        
        lAnswerValuesBoolean = new list<SelectOption>{
            new SelectOption('True', 'True'),
            new SelectOption('False', 'False')
        };

        this.oQuestionnaire = (Questionnaire__c)oStandardController.getRecord();
        this.oStandardController = oStandardController;

        if(ECO_Utils_String.NullCheck(oQuestionnaire.QuestionnaireSet__c) == ''){
			ApexPages.Message oPageMessage = new ApexPages.Message(ApexPages.Severity.WARNING,'You have reached this page improperly, please access it from the Project screen.');
            ApexPages.addMessage(oPageMessage);

            return;
		}
		//lTemplateQuestion = new list<TemplateQuestion__c>([Select id From TemplateQuestion__c where Question__c = 'Does this project trigger any DoA Items?']);
        refreshData();
    }
    
    public PageReference goToSpecificQuestionnaire () {
    	
    	doSaveAction();
    	
    	refreshData();
    	
    	PageReference oPageReference = Page.ECO_RMAQuestionnaire;

    	oPageReference.getParameters().put('Id', navTargetQuestionnaireId);
    	oPageReference.setRedirect(true);
    	
    	return oPageReference;
    }
    
    public PageReference doShowDOASection () {
    	showDOASection = true;
        showDOASubSection = true;
    	return null;
    }
    
    public PageReference doHideDOASection () {
    	showDOASection = false;
        showDOASubSection = false;
    	return null;
    }
	
    public void refreshData(){
        
    	lQuestionnaires = ECO_Utils_Questionnaire.GetQuestionnaires(oQuestionnaire.QuestionnaireSet__c);
        iIndex = ECO_Utils_Questionnaire.FindQuestionnaireIndex(lQuestionnaires, oQuestionnaire);

        lAnswers = ECO_Utils_Questionnaire.GetAnswers(oQuestionnaire.Id);

        mDoAAnswers = new map<string, list<Answer__c>>();
        mNotDoAAnswers = new map<string, list<Answer__c>>();
        questionToRiskMap = new Map<Id, Risk__c>();
        questionToDOAMap = new Map<Id, DOARegister__c>();

        for(Answer__c oAnswer : lAnswers)
        {
        	if(oAnswer.TemplateQuestion__r.IsDoATrigger__c)
            {
        		if(!mDoAAnswers.containsKey(oAnswer.TemplateQuestion__r.QuestionSet__c))
                {
                    mDoAAnswers.put(oAnswer.TemplateQuestion__r.QuestionSet__c, new list<Answer__c>());
                }

                mDoAAnswers.get(oAnswer.TemplateQuestion__r.QuestionSet__c).add(oAnswer);
                
                // Show the answers section if the section header is 'yes'
                if(oAnswer.TemplateQuestion__r.isDOAmaster__c && 'Yes'.equalsIgnoreCase(oAnswer.Value__c)) 
                {
                	doShowDOASection();
                }
				
                //Preload the DOA map
                DOARegister__c newDOA = new DOARegister__c();
                newDOA.Questionnaire__c = oQuestionnaire.Id;
                newDOA.DCSsubDOA__c = oAnswer.TemplateQuestion__r.DCSSubDOA__c;
                newDOA.EnterpriseDOA__c = oAnswer.TemplateQuestion__r.EnterpriseDOA__c;
                newDOA.DOATrigger__c = oAnswer.TemplateQuestion__r.Question__c;
                newDOA.RiskTitle__c = oAnswer.TemplateQuestion__r.RiskTitle__c;
                newDOA.TemplateQuestion__c = oAnswer.TemplateQuestion__c;
                
                //newDOA.MitigationStrategy__c = '';
                
                questionToDOAMap.put(oAnswer.TemplateQuestion__c, newDOA);
    		}
            else
            {
                if(!oAnswer.TemplateQuestion__r.isDOAmaster__c){
                    if(!mNotDoAAnswers.containsKey(oAnswer.TemplateQuestion__r.QuestionSet__c))
                    {
                        mNotDoAAnswers.put(oAnswer.TemplateQuestion__r.QuestionSet__c, new list<Answer__c>());
                    }

                    mNotDoAAnswers.get(oAnswer.TemplateQuestion__r.QuestionSet__c).add(oAnswer);
                } else {
                    DOA_SectionAnswer = oAnswer;
                    /*if(DOA_SectionAnswer.Value__c == 'True' || DOA_SectionAnswer.Value__c == 'Unknown' || DOA_SectionAnswer.Value__c == 'Yes'){
                        showDOASection = true;
                    }*/
                    DOA_SectionAnswer.Value__c = 'True';
                    
                    showDOASection = true;
                    System.debug('setting showDOASection:   '+showDOASection);
                    System.debug('oAnswer:   '+oAnswer);
                }
    		}
            // Preload the risk map
            questionToRiskMap.put(oAnswer.TemplateQuestion__c, new Risk__c());
        }
        if(mDoAAnswers.size()>0)
            showDOASubSection = true;
        System.debug('mDoAAnswers.size:   '+mDoAAnswers.size());
        System.debug('mNotDoAAnswers.size:  '+ mNotDoAAnswers.size());
        System.debug('showDOASection:   '+showDOASection);
        System.debug('showDOASubSection:   '+showDOASubSection);
        for (Risk__c r : ECO_Service_Risks.getRisksForAnswers(lAnswers)) {
        	questionToRiskMap.put(r.Answer__r.TemplateQuestion__c, r);
        }

        for (DOARegister__c d : ECO_Service_Risks.getDOAForAnswers(lAnswers)) {
            questionToDOAMap.put(d.TemplateQuestion__c, d);
        }
		
  		return;
    }
    
    public PageReference addRiskToAnswer () {
    	Risk__c newRisk = new Risk__c();
    	newRisk.Questionnaire__c = oQuestionnaire.Id;
    	newRisk.Project__c = oQuestionnaire.QuestionnaireSet__r.Project__c;
    	newRisk.PlanElement__c = oQuestionnaire.Name;
    	questionToRiskMap.put(selectedQuestionId, newRisk);
    	
    	return null;
    }
    
    public PageReference removeRiskFromAnswer () {
    	questionToRiskMap.put(selectedQuestionId, new Risk__c());
    	
    	return null;
    }

    public PageReference addDOARiskToAnswer () 
    {
        if(questionToDOAMap.containsKey(selectedQuestionId))
        {
            System.debug('addDOARiskToAnswer');
            DOARegister__c doa = questionToDOAMap.get(selectedQuestionId);
            doa.Project__c = oQuestionnaire.QuestionnaireSet__r.Project__c;
            questionToDOAMap.put(selectedQuestionId, doa);

            //add a risk for each DOA as well
            Risk__c newRisk = new Risk__c();
            newRisk.Questionnaire__c = oQuestionnaire.Id;
            newRisk.Project__c = oQuestionnaire.QuestionnaireSet__r.Project__c;
            newRisk.PlanElement__c = oQuestionnaire.Name;
            newRisk.DoATrigger__c = true;
            questionToRiskMap.put(selectedQuestionId, newRisk);

        }
        
        return null;
    }
    
    public PageReference removeDOARiskFromAnswer () 
    {
        /*
        if(questionToDOAMap.containsKey(selectedQuestionId))
        {
            DOARegister__c doa = questionToDOAMap.get(selectedQuestionId);
            doa.Project__c = '';
            
        }
        */
        questionToDOAMap.put(selectedQuestionId, new DOARegister__c());

        //remove risk for DOA as well
        questionToRiskMap.put(selectedQuestionId, new Risk__c());
        
        return null;
    }
    
    private void doSaveAction () 
    {
    	try
        {
    		markDOAAnswersAsNoIfParentIsNo();
    		
    		//oStandardController.save();
    		upsert lAnswers;
    		
    		// Create our map so we can set the answer field properly on the risks
    		Map<Id, Id> questionTemplateToAnswerMap = new Map<Id, Id>();
            Boolean ExportControlExists = ECO_Utils_Questionnaire.ExportControlExists(oQuestionnaire.QuestionnaireSet__c);
    		for (Answer__c a : lAnswers) 
            {
    			questionTemplateToAnswerMap.put(a.TemplateQuestion__c, a.Id);

                if(a.TemplateQuestion__r.RiskTitle__c == 'Export Controls' && !ExportControlExists && (a.Value__c == 'Yes' || a.Value__c == 'Unknown'))
                {
                    //create Export Control record
                    ExportControl__c oEC = new ExportControl__c(Status__c='Open', QuestionnaireSet__c=oQuestionnaire.QuestionnaireSet__c, Project__c = oQuestionnaire.QuestionnaireSet__r.Project__c);
                    insert oEC;
                    ExportControlExists = true;
                }
    		}
    		
    		cleanEmptyRisks();
    		
    		for (Id i : questionToRiskMap.keySet()) {
    			questionToRiskMap.get(i).Answer__c = questionTemplateToAnswerMap.get(i);
    		}

            for (Id i : questionToDOAMap.keySet()) {
                questionToDOAMap.get(i).Answer__c = questionTemplateToAnswerMap.get(i);
            }
            System.debug('questionToDOAMap size: ' + questionToDOAMap.size());
    		
    		upsert questionToRiskMap.values();
            upsert questionToDOAMap.values();
    	} 
        catch (Exception e) 
        {
            System.debug('doSaveAction error: ' + e.getMessage());
    		ApexPages.addMessages(e);  // TODO:  Make this pretty
    	}
    }
    
    private void markDOAAnswersAsNoIfParentIsNo () {
    	Boolean isSectionHeaderNo = false;
    	for (Answer__c a : lAnswers) 
        {
    		// Check if this is the header question for the DOA section, and if it's 'No'
    		//if (a.TemplateQuestion__r.IsDoATrigger__c 
    		if(a.TemplateQuestion__r.isDOAmaster__c
    			&& 'No'.equalsIgnoreCase(a.Value__c)) {
    				isSectionHeaderNo = true;
    				break;
    		}
    	}
    	
    	// If it is equal to 'no', our boolean is true, so let's loop over them again and set the kids to no
    	if (isSectionHeaderNo) {
    		for (Answer__c a : lAnswers) {
    			// Only set to 'no' if the type matches DOA trigger
	    	if (questionToDOAMAP.containsKey(a.TemplateQuestion__c)) {
    			a.Value__c = 'No';
    			}
    		}
    	}
    }
    
    private void cleanEmptyRisks () {
    	for (Id questionId : questionToRiskMap.keySet()) {
    		Risk__c thisRisk = questionToRiskMap.get(questionId);
    		Boolean keepThisRisk = false;
    		
    		keepThisRisk = (thisRisk.Project__c != null) ? true : false;
    		
    		if (!keepThisRisk) {
                System.debug('questionId:   '+questionId);
    			questionToRiskMap.remove(questionId);
    		}
    	}

        for (Id questionId : questionToDOAMap.keySet()) {
            DOARegister__c thisDOA = questionToDOAMap.get(questionId);
            Boolean keepThisDOA = false;
            
            keepThisDOA = (thisDOA.Project__c != null) ? true : false;
            
            if (!keepThisDOA) {
                questionToDOAMap.remove(questionId);
            }
        }
    }

    private boolean checkMitigation(){
        for(string RMKey: questionToRiskMap.keySet()){

            Risk__c risk = questionToRiskMap.get(RMKey);

            if(risk.Project__c != null && risk.DoATrigger__c==false){
                if(risk.RiskMitigation__c == '' || risk.RiskMitigation__c == null){
                    return true;
                }
            }

        }  

        return false;
    }

    public PageReference SaveNext(){


        if(checkMitigation()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Mitigation Strategy: Validation Error: Value is required.'));
            return null;
        }

    	if(iIndex + 1 < 0){
    		throw new EcoControllerException('Error Cannot Go Next');
    	}
    	
    	iIndex++;
    	
    	system.debug('lQuestionnaires.size():  '+lQuestionnaires.size());
		
		if (lQuestionnaires.size() <= iIndex) {
			
			List<MarketAssessment__c> lMarketAssessment = [SELECT Id 
															FROM MarketAssessment__c 
															WHERE QuestionnaireSet__c = :oQuestionnaire.QuestionnaireSet__c];
			system.debug('lMarketAssessment:  '+lMarketAssessment);
			if (!lMarketAssessment.isEmpty()) {

                doSaveAction();
                refreshData();
				return new PageReference('/'+lMarketAssessment[0].Id);
			} else {
				PageReference oPageReference = Page.ECO_RMASummary;

		    	oPageReference.getParameters().put('Id', oQuestionnaire.QuestionnaireSet__c);
		    	oPageReference.setRedirect(true);
		    	
                doSaveAction();
                refreshData();
		    	return oPageReference;
			}
			
		}
    	
    	Questionnaire__c oPreviousQuestionnaire = lQuestionnaires.get(iIndex);

    	doSaveAction();

    	PageReference oPageReference = Page.ECO_RMAQuestionnaire;

    	oPageReference.getParameters().put('Id', oPreviousQuestionnaire.Id);
    	oPageReference.setRedirect(true);

    	refreshData();

    	return oPageReference;
    }

    public PageReference SavePrevious(){

        if(checkMitigation()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Mitigation Strategy: Validation Error: Value is required.'));
            return null;
        }

    	if(iIndex - 1 < 0){
    		throw new EcoControllerException('Error Cannot Go Previous');
    	}

    	Questionnaire__c oPreviousQuestionnaire = lQuestionnaires.get(iIndex - 1);

    	doSaveAction();

    	PageReference oPageReference = Page.ECO_RMAQuestionnaire;

    	oPageReference.getParameters().put('Id', oPreviousQuestionnaire.Id);
    	oPageReference.setRedirect(true);

    	refreshData();

    	return oPageReference;
    }

    public PageReference SaveRecord(){

        if(checkMitigation()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Mitigation Strategy: Validation Error: Value is required.'));
            return null;
        }

    	doSaveAction();

    	refreshData();

    	return null;
    }

    public PageReference ReturnToSummary(){
    	PageReference oPageReference = Page.ECO_RMASummary;

    	oPageReference.getParameters().put('Id', oQuestionnaire.QuestionnaireSet__c);
    	oPageReference.setRedirect(true);

    	refreshData();

    	return oPageReference;
    }
    public PageReference SetDefaultNo(){
        for(Answer__c oAnswer : lAnswers){
            
            if(oAnswer.TemplateQuestion__r.IsDoATrigger__c == true && (oAnswer.Value__c == '' || oAnswer.Value__c == null)){
                oAnswer.Value__c = 'No';
            }
        }
        return null;
    }
    
    
    
}