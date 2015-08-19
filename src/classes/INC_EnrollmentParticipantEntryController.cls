public with sharing class INC_EnrollmentParticipantEntryController {

	public EnrollmentPlan__c oEnrollmentPlan {get;set;}
    public list<EnrollmentParticipant__c> listParticipant {get;set;}
    public String partComments {get;set;}
    public Boolean editParticipants {get;set;}
    public Boolean bChangeRequest{get;set;}

    public INC_EnrollmentParticipantEntryController(ApexPages.StandardController stdController) {
        System.Debug(logginglevel.error,'Start Controller ' + System.Now());
        editParticipants = true;
        oEnrollmentPlan = (EnrollmentPlan__c)stdController.getRecord();
        oEnrollmentPlan = INC_Service_EnrollmentPlan.getEnrollmentPlan(new set<id>{oEnrollmentPlan.id})[0];
        if(oEnrollmentPlan.EnrollmentStatus__c == 'Enrolled' ||
           oEnrollmentPlan.EnrollmentStatus__c == 'Archived'){
            editParticipants = false;
        }
        if(oEnrollmentPlan.Name.StartsWith('CCR')){
            bChangeRequest = true;
        }else{
            bChangeRequest = false;
        }
        System.Debug(logginglevel.error,'Start loadExistingParticipants ' + System.Now());
        loadExistingParticipants();
        System.Debug(logginglevel.error,'Start addblankRows ' + System.Now());
        addblankRows();
        System.Debug(logginglevel.error,'End Controller ' + System.Now());
    }

    private void addblankRows(){
    	Integer iSize = 0;
        if(oEnrollmentPlan.EnrollmentStatus__c != 'Enrolled'){
            if(listParticipant != null && listParticipant.size() > 0){
                iSize = listParticipant.size();
            }else{
                listParticipant = new list<EnrollmentParticipant__c>();
            }
        	if(iSize > = 5){
        		listParticipant.add(new EnrollmentParticipant__c(EnrollmentPlan__c = oEnrollmentPlan.ID));
        	}else{
        		for(Integer i = iSize; i<5; i++){
        			listParticipant.add(new EnrollmentParticipant__c(EnrollmentPlan__c = oEnrollmentPlan.ID));
        		}
        	}
        }
    }

    private void loadExistingParticipants(){
        map<id,List<EnrollmentParticipant__c>> mapEnrollmentParticipants = INC_Service_EnrollmentPlan.getPlanParticipants(new set<id>{oEnrollmentPlan.id});

        listParticipant = mapEnrollmentParticipants.get(oEnrollmentPlan.Id);
    }

    public void addBlankRow(){
        System.Debug(logginglevel.error,'listParticipant.size '+ listParticipant.size());
        if(listParticipant[listParticipant.size()-1].EmployeeName__c != null){
         listParticipant.add(new EnrollmentParticipant__c(EnrollmentPlan__c = oEnrollmentPlan.ID));
        }
        System.Debug(logginglevel.error,'listParticipant.size after'+ listParticipant.size());
    }

    public void addParticipant(){
        listParticipant.add(new EnrollmentParticipant__c(EnrollmentPlan__c = oEnrollmentPlan.ID));
    }

    public pageReference Cancel(){
        return getReturnPage();
    }

    public pageReference SaveAndContinue(){
        save();
        if(partComments != null && partComments.length() > 0){
                createEnrollmentComments();
        }
          
        return getReturnPage();
    }
    public void save(){
        list<EnrollmentParticipant__c> lSave = prepareForSave();
        System.savePoint sp = Database.setSavePoint();
        try{
            upsert lSave;
            loadExistingParticipants();
            addblankRows();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Save Successful.'));
        }catch(Exception e){
            system.debug('Handling Exception:  '+e.getMessage());
            Database.rollBack(sp);
            ApexPages.addMessages(e);
        }
    }

    private void createEnrollmentComments(){
       Enrollment_Comments__c comment = new Enrollment_Comments__c(EnrollmentApplication__c = oEnrollmentPlan.ID);
       comment.comments__c = partComments;
       comment.Type__c = 'Participant';
        System.savePoint sp = Database.setSavePoint();
        try{
            insert comment;
        }catch(Exception e){
            system.debug('Handling Exception:  '+e.getMessage());
            Database.rollBack(sp);
            ApexPages.addMessages(e);
        }
    }

    private String validateCode(list<EnrollmentParticipant__c>lSave){

        String sReturnMessage = '';
        boolean binValidPercent = False;
        boolean bMissingPercent = False;
        Double iPercent = 0;
        for(EnrollmentParticipant__c oEnrollmentParticipant: lSave){
            if(oEnrollmentParticipant.TargetIncentivePoolAllocated__c == null || oEnrollmentParticipant.TargetIncentivePoolAllocated__c == 0){
                bMissingPercent = true;
            }else{
                if(!bMissingPercent){
                    iPercent += oEnrollmentParticipant.TargetIncentivePoolAllocated__c;
                }
            } 
        }
        if(!bMissingPercent){
            if(iPercent > 100){
                binValidPercent = true;
            }
        }

        if(!bMissingPercent){
            sReturnMessage = 'One or more lines is missing Target %.';
        }else{
            if(binValidPercent){
                sReturnMessage = 'Total Target % is greater than 100.';
            }
        }

        return sReturnMessage;
    }

    private pageReference getReturnPage(){
        PageReference Enroll = new pageReference('/apex/INC_EnrollmentApp?id=' + oEnrollmentPlan.id);
        Enroll.setRedirect(true);
        return Enroll;
    }

    private list<EnrollmentParticipant__c> prepareForSave(){
        list<EnrollmentParticipant__c> lReturn = new list<EnrollmentParticipant__c>();
        for(EnrollmentParticipant__c oPart: listParticipant){
            System.Debug(logginglevel.error,'Enrollment plan: ' + oPart.EnrollmentPlan__c);
            System.Debug(logginglevel.error,'EmployeeName__c: ' + oPart.EmployeeName__c);
            if(oPart.EmployeeName__c != null){
                lReturn.add(oPart);
            }
        }

        return lReturn;
    } 
    
}