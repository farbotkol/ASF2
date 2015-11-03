trigger ECO_ProjectReview_AllEvents on ProjectReview__c (before insert, before update, after update, after insert) {

    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){
        system.debug( 'ECO_ProjectReview_AllEvents executed' );
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    }  

    // ******* DELEGATION TRIGGER LOGIC
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        ECO_Service_Delegation.insertDelegations(trigger.new);
    }
        
    if(trigger.isBefore && trigger.isInsert){

        ECO_Service_Delegation.evaluateDelegation(trigger.new, null);
    }

    if(trigger.isBefore && trigger.isUpdate){
        ECO_Service_Delegation.evaluateDelegation(trigger.new, trigger.oldMap);
    }
    //******* END OF THE DELEGATION TRIGGER LOGIC

}