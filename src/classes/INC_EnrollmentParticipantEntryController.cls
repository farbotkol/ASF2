public with sharing class INC_EnrollmentParticipantEntryController {

	public EnrollmentPlan__c oEnrollmentPlan {get;set;}
    public ID enrollID {get;set;}
    public list<EnrollmentParticipant__c> listParticipant {get;set;}
    public list<EnrollmentParticipant__c> listParticipantDelete {get;set;}
    public String partComments {get;set;}
    public Boolean editParticipants {get;set;}
    public Boolean bChangeRequest{get;set;}
    public String fromWizard{get;set;}
    public Boolean bPaidAndEnrolled{get;set;}
    public Boolean bPaid{get;set;}
    public Boolean bTMorFixed{get;set;}
    public Boolean bFixed{get;set;}
    public Boolean bTM{get;set;}
    public Boolean bEnableCCR{get;set;}

    public integer rowNumber {get;set;}

    public INC_EnrollmentParticipantEntryController(){

        bFixed = false;
        bTM = false;

        enrollID = ApexPages.CurrentPage().getParameters().get('id');
        oEnrollmentPlan = INC_Service_EnrollmentPlan.getEnrollmentPlan(new set<id>{enrollID})[0];
        setUpPage();

        bEnableCCR = false;
        if(oEnrollmentPlan.ApplicationType__c == 'CCR'){
            bEnableCCR = true;
        }

        if(oEnrollmentPlan.ContractType__c == 'AMPS - Fixed Price'  || 
            oEnrollmentPlan.ContractType__c == 'CPFF - Hard Bid' || 
            oEnrollmentPlan.ContractType__c == 'CPFF - Negotiated' || 
            oEnrollmentPlan.ContractType__c == 'Unassigned'
            ){
            bTMorFixed = false;
        } else {
            bTMorFixed = true;

            if(oEnrollmentPlan.IncentivePlan__r.ContractType__c == 'Fixed Price'){
                bFixed = true;
            } else if (oEnrollmentPlan.IncentivePlan__r.ContractType__c == 'Time & Material'){
                bTM = true;
            }            
        }

        
    }

    public INC_EnrollmentParticipantEntryController(ApexPages.StandardController stdController) {
        System.Debug(logginglevel.error,'Start Controller ' + System.Now());
        oEnrollmentPlan = (EnrollmentPlan__c)stdController.getRecord();
        oEnrollmentPlan = INC_Service_EnrollmentPlan.getEnrollmentPlan(new set<id>{oEnrollmentPlan.id})[0];
        setUpPage();
    }

    private void setUpPage(){
        editParticipants = true;
        if(oEnrollmentPlan.EnrollmentStatus__c == 'Enrolled' ||
           oEnrollmentPlan.EnrollmentStatus__c == 'Archived'){
            editParticipants = false;
        }
        if(oEnrollmentPlan.Name.StartsWith('CCR')){
            bChangeRequest = true;
           // editParticipants = false;
        }else{
            bChangeRequest = false;
        }
        System.Debug(logginglevel.error,'Start loadExistingParticipants ' + System.Now());
        loadExistingParticipants();
        System.Debug(logginglevel.error,'Start addblankRows ' + System.Now());
        addblankRows();
        System.Debug(logginglevel.error,'End Controller ' + System.Now());

        if(oEnrollmentPlan.ApplicationType__c == 'PAY'){
            bPaid = true;
            if(oEnrollmentPlan.EnrollmentStatus__c == 'Enrolled'){
                bPaidAndEnrolled = true;
            } else {
                bPaidAndEnrolled = false;
            }
        } else {
            bPaid = false;
        }

        listParticipantDelete = new list<EnrollmentParticipant__c>();
    }

    private void addblankRows(){
    	Integer iSize = 0;

        if(oEnrollmentPlan.ApplicationType__c == 'PAY'){
            if(listParticipant != null && listParticipant.size() > 0){
                iSize = listParticipant.size();
            }else{
                listParticipant = new list<EnrollmentParticipant__c>();
            }

            //listParticipant.add(new EnrollmentParticipant__c(EnrollmentPlan__c = oEnrollmentPlan.ID, ParticipantType__c = 'Discretionary'));
            /*if(iSize > = 5){
                listParticipant.add(new EnrollmentParticipant__c(EnrollmentPlan__c = oEnrollmentPlan.ID, ParticipantType__c = 'Discretionary'));
            }else{
                for(Integer i = iSize; i<5; i++){
                    listParticipant.add(new EnrollmentParticipant__c(EnrollmentPlan__c = oEnrollmentPlan.ID, ParticipantType__c = 'Discretionary'));
                }
            }         */   
        }

        else if (oEnrollmentPlan.EnrollmentStatus__c != 'Enrolled'){
            if(listParticipant != null && listParticipant.size() > 0){
                iSize = listParticipant.size();
            }else{
                listParticipant = new list<EnrollmentParticipant__c>();
            }
        	if(iSize > = 5){
                if(oEnrollmentPlan.ApplicationType__c != 'CCR'){
        		  listParticipant.add(new EnrollmentParticipant__c(EnrollmentPlan__c = oEnrollmentPlan.ID));
                }else{
                    listParticipant.add(new EnrollmentParticipant__c(EnrollmentPlan__c = oEnrollmentPlan.ID,ExistedAtEnrollment__c = 'No'));
                }
        	}else{
        		for(Integer i = iSize; i<5; i++){
        			if(oEnrollmentPlan.ApplicationType__c != 'CCR'){
                        listParticipant.add(new EnrollmentParticipant__c(EnrollmentPlan__c = oEnrollmentPlan.ID));
                    }else{
                        listParticipant.add(new EnrollmentParticipant__c(EnrollmentPlan__c = oEnrollmentPlan.ID,ExistedAtEnrollment__c = 'No'));
                    }
        		}
        	}
        } 
    }

    private void loadExistingParticipants(){
        System.Debug(logginglevel.error,'Particpants load: ' + oEnrollmentPlan.ID);
        map<id,List<EnrollmentParticipant__c>> mapEnrollmentParticipants = INC_Service_EnrollmentPlan.getPlanParticipants(new set<id>{oEnrollmentPlan.id});
        System.Debug(logginglevel.error,'parts: ' + mapEnrollmentParticipants);
        listParticipant = mapEnrollmentParticipants.get(oEnrollmentPlan.Id);
    }

    public void addBlankRow(){
        System.Debug(logginglevel.error,'listParticipant.size '+ listParticipant.size());
        //if(listParticipant[listParticipant.size()-1].EmployeeName__c != null){
         if(oEnrollmentPlan.ApplicationType__c == 'PAY'){
            listParticipant.add(new EnrollmentParticipant__c(EnrollmentPlan__c = oEnrollmentPlan.ID, ParticipantType__c = 'Discretionary',ExistedAtEnrollment__c='No'));
         }
         else if(oEnrollmentPlan.ApplicationType__c == 'CCR'){
              listParticipant.add(new EnrollmentParticipant__c(EnrollmentPlan__c = oEnrollmentPlan.ID, ExistedAtEnrollment__c='No'));
            } else if (oEnrollmentPlan.EnrollmentStatus__c != 'Enrolled'){
            listParticipant.add(new EnrollmentParticipant__c(EnrollmentPlan__c = oEnrollmentPlan.ID));
         }
         
        //}
        System.Debug(logginglevel.error,'listParticipant.size after'+ listParticipant.size());
    }

    public void addParticipant(){
        listParticipant.add(new EnrollmentParticipant__c(EnrollmentPlan__c = oEnrollmentPlan.ID));
    }

    public pageReference Cancel(){
        return getReturnPage();
    }

    public pageReference SaveAndContinue(){


        if(!save()){
            return null;
        }
        

        if(partComments != null && partComments.length() > 0){
                createEnrollmentComments();
        }
          
        return getReturnPage();
    }

    public pageReference SaveandRecalc(){

        save();

        return null;
    }

    public boolean save(){
        list<EnrollmentParticipant__c> lSave = prepareForSave();

        if(!validate(lSave)){
            return false;
        }

        System.savePoint sp = Database.setSavePoint();
        try{
            upsert lSave;

            if(listParticipantDelete.size() > 0){
                delete listParticipantDelete;
                listParticipantDelete = new list<EnrollmentParticipant__c>();
            }


            loadExistingParticipants();
            addblankRows();
            oEnrollmentPlan = INC_Service_EnrollmentPlan.getEnrollmentPlan(new set<id>{enrollID})[0];
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Save Successful.'));
        }catch(Exception e){
            system.debug('Handling Exception:  '+e.getMessage());
            Database.rollBack(sp);
            ApexPages.addMessages(e);
            return false;
        }

        return true;
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

    private boolean validate(list<EnrollmentParticipant__c>lSave){

        decimal pool = null;
        if(bTM){
            pool = oEnrollmentPlan.EstimatedPoolBaseline10__c;
        }
        if(bFixed){
            pool = oEnrollmentPlan.EstimatedPoolBaseline__c;
        }


        for(EnrollmentParticipant__c oEnrollmentParticipant: lSave){
            if(oEnrollmentParticipant.ParticipantCategory__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'All Participants must have a defined role.'));
                return false;
            }
            if((oEnrollmentParticipant.TargetIncentivePoolAllocated__c == null || oEnrollmentParticipant.TargetIncentivePoolAllocated__c <= 0) && (oEnrollmentParticipant.ParticipantType__c != 'Discretionary' && oEnrollmentPlan.ApplicationType__c == 'ENR')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'All Participants must have an allocation greater than 0'));
                return false;
            }

            if(bTM || bFixed){
                if(oEnrollmentPlan.ApplicationType__c != 'Pay'){
                    if((((oEnrollmentParticipant.TargetIncentivePoolAllocated__c * pool/100) < oEnrollmentPlan.MinParticipantPayout__c)) && oEnrollmentPlan.ApplicationType__c == 'ENR'){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'All Participants estimated payout must be >= $' + oEnrollmentPlan.MinParticipantPayout__c + ', Currently: $' + oEnrollmentParticipant.TargetIncentivePoolAllocated__c * pool/100));
                        return false;
                    }
                }
            }

            if(oEnrollmentParticipant.EmployeeName__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'All Participants must have an employee name'));
                return false;
            }

        }

        return true;
    }

    /*private String validateCode(list<EnrollmentParticipant__c>lSave){

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
    }*/

    public PageReference RemoveEP(){
        EnrollmentParticipant__c ep = listParticipant[rowNumber-1];

        if(ep.id != null){
            listParticipantDelete.add(ep);
        }

        listParticipant.remove(rowNumber-1);

        return null;

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
                oPart.CurrencyIsoCode = oEnrollmentPlan.CurrencyIsoCode;
                lReturn.add(oPart);
            }
        }

        return lReturn;
    } 
    
}