trigger ECO_TechnicalQualityTeam_AllEvents on TechnicalQualityTeam__c (after update, after insert) {
        
    ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );

}