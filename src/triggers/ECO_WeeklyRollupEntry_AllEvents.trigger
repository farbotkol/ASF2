trigger ECO_WeeklyRollupEntry_AllEvents on WeeklyRollupEntry__c (before insert, before update, after insert, after update, before delete) { 
  if(trigger.isbefore && !trigger.isdelete)
  {
      ECO_WeeklyRollupEntryTriggers.calculateFiscalMonths(trigger.new);
  }
       

}