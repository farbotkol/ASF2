trigger GoNoGoTrigger on Go_No_Go_Conversation__c (after update) {
    Set<ID> oppIds = new Set<ID>();
    List<Opportunity> oppsToUpdate = new List<Opportunity>();
    
    for(Go_No_Go_Conversation__c gos : Trigger.NEW) {
        Go_No_Go_Conversation__c oldGo = Trigger.oldMap.get(gos.Opportunity__c);
        
        oppIds.add(gos.Opportunity__c);
        if(oldGo != null) {
            oppIds.add(oldGo.Opportunity__c);    
        }
    }
    List<Opportunity> affectedOpps = [SELECT ID
                                     , Name
                                     , Go_No_Go_approval_date__c
                                     , Bid_Proposal_Charge__c
                                     , RecordTypeText__c
                                     , (SELECT ID, Opportunity__c, B_P_Charge_Number__c from G_NG_Conversations__r WHERE B_P_Charge_Number__c != null LIMIT 1)
                                     FROM Opportunity
                                     WHERE ID in :oppIds];

    for(Opportunity opp : affectedOpps) {
        if(opp.G_NG_Conversations__r.size() > 0 && !opp.RecordTypeText__c.contains('EMEA')) {
            if(opp.Bid_Proposal_Charge__c != opp.G_NG_Conversations__r[0].B_P_Charge_Number__c  && !opp.RecordTypeText__c.contains('EMEA')) {
                opp.Bid_Proposal_Charge__c = opp.G_NG_Conversations__r[0].B_P_Charge_Number__c;
                oppsToUpdate.add(opp);
            }
            //opp.Bid_Proposal_Charge_Type__c = 'Generic charge number';
        } else {
            if(opp.Bid_Proposal_Charge__c != null && !opp.RecordTypeText__c.contains('EMEA')) {
                opp.Bid_Proposal_Charge__c = null;
                oppsToUpdate.add(opp);
            }   
        }
    }
    if(oppsToUpdate.size() > 0) update oppsToUpdate;
}