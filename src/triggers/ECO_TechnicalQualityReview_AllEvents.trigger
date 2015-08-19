trigger ECO_TechnicalQualityReview_AllEvents on TechnicalQualityReview__c (after insert) {

	boolean isTriggerEnabled = ECO_TriggerSettings.getIsTriggerEnabled('ECO_TechnicalQualityReview_AllEvents');
    boolean bisRunning = false;
    ECO_TechnicalQualityReviewTriggers handler = new ECO_TechnicalQualityReviewTriggers();

     if (trigger.isAfter && isTriggerEnabled && trigger.isInsert) {
     	System.Debug(logginglevel.error,'ECO---> Starting QTQR Trigger after Insert ');
    	handler.approveTQTMembers(trigger.new);
     }
}