trigger ECO_Billing_AllEvents on Billing__c (before insert, before update, after insert, after update, before delete) {
    if(trigger.isbefore && !trigger.isdelete)
    ECO_billingtriggers.updateCustomername(trigger.new);
}