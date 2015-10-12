public with sharing class CFM_QualtricsAsyncIntegrationHandler implements Queueable, Database.AllowsCallouts {
    
    private CFM_SurveyBatch mSurveyBatch;
    private String          mSurveyBatchProjectCSV;

    private CFM_QualtricsImportPanelCallout       importPanel;
    private CFM_QualtricsSendSurveyToPanelCallout sendSurveyToPanel;
    public CFM_QualtricsAsyncIntegrationHandler(CFM_SurveyBatch surveyBatch, String surveyBatchProjectCSV) {
        mSurveyBatch = surveyBatch;
        mSurveyBatchProjectCSV = surveyBatchProjectCSV;
    }

    public void execute(QueueableContext context) {
        performCallouts();
    }

    public void performCallouts() {

        CFM_QualtricsImportPanelResponse importPanelResponse;
        try {
            importPanelResponse = importPanel();
        }
        catch (CFM_QualtricsBaseCallout.ResponseNotOKException e) {
            addLog(e, importPanel.getRequest());
        }

        if (importPanelResponse != null) {
            try {
                String panelId = importPanelResponse.getPanelId();
                CFM_QualtricsSendSurveyToPanelResponse sendSurveyResponse = sendSurveyToPanel(panelId);
            } 
            catch (CFM_QualtricsBaseCallout.ResponseNotOKException e) {
                addLog(e, sendSurveyToPanel.getRequest());
            }
        }

        //---Null checks in case callouts fail
        if (importPanel != null) {
            importPanel.saveLog();
        }
        if (sendSurveyToPanel != null) {
            sendSurveyToPanel.saveLog();
        }

    }

    private CFM_QualtricsImportPanelResponse importPanel() {
        importPanel = new CFM_QualtricsImportPanelCallout(mSurveyBatch.getId(), mSurveyBatchProjectCSV);
        importPanel.setShouldSaveLog(false);
        HttpResponse res = importPanel.callout();
        CFM_QualtricsImportPanelResponse response = CFM_QualtricsImportPanelResponse.parse(res.getBody());
        if (response.Meta.Status != CFM_QualtricsBaseCallout.STATUS_SUCCESS) {
            String details = '';
            details += CFM_QualtricsImportPanelCallout.PARAM_KEY_LIB_ID + ': ' + importPanel.getLibraryID()   + ',\n ';
            details += CFM_QualtricsImportPanelCallout.PARAM_KEY_EMAIL  + ': ' + importPanel.getEmailColumn() + ',\n ';
            throw new CFM_QualtricsBaseCallout.ResponseNotOKException(
                'Error recieved from callout \nResponse: ' + res.getBody() 
                + '\n-----\nDetails: ' + details 
                + '\n-----\nSent this as CSV: ' + mSurveyBatchProjectCSV
            );
        }

        return response;
    }

    private CFM_QualtricsSendSurveyToPanelResponse sendSurveyToPanel(String panelId) {
        sendSurveyToPanel = new CFM_QualtricsSendSurveyToPanelCallout(mSurveyBatch, panelId);
        sendSurveyToPanel.setShouldSaveLog(false);
        HttpResponse res = sendSurveyToPanel.callout();
        CFM_QualtricsSendSurveyToPanelResponse response = CFM_QualtricsSendSurveyToPanelResponse.parse(res.getBody());
        if (response.Meta.Status != CFM_QualtricsBaseCallout.STATUS_SUCCESS) {
            String details = '';
            details += CFM_QualtricsSendSurveyToPanelCallout.PARAM_KEY_SURVEY       + ': ' + sendSurveyToPanel.getSurveyID()         + ',\n ';
            details += CFM_QualtricsSendSurveyToPanelCallout.PARAM_KEY_SEND_DATE    + ': ' + sendSurveyToPanel.getSendDate()         + ',\n ';
            details += CFM_QualtricsSendSurveyToPanelCallout.PARAM_KEY_SENT_ADDR    + ': ' + sendSurveyToPanel.getSentFromEmail()    + ',\n ';
            details += CFM_QualtricsSendSurveyToPanelCallout.PARAM_KEY_FROM_EMAIL   + ': ' + sendSurveyToPanel.getFromEmail()        + ',\n ';
            details += CFM_QualtricsSendSurveyToPanelCallout.PARAM_KEY_FROM_NAME    + ': ' + sendSurveyToPanel.getFromName()         + ',\n ';
            details += CFM_QualtricsSendSurveyToPanelCallout.PARAM_KEY_SUBJECT      + ': ' + sendSurveyToPanel.getSubject()          + ',\n ';
            details += CFM_QualtricsSendSurveyToPanelCallout.PARAM_KEY_MSG_ID       + ': ' + sendSurveyToPanel.getMessageID()        + ',\n ';
            details += CFM_QualtricsSendSurveyToPanelCallout.PARAM_KEY_MSG_LIB_ID   + ': ' + sendSurveyToPanel.getMessageLibraryID() + ',\n ';
            details += CFM_QualtricsSendSurveyToPanelCallout.PARAM_KEY_PANEL_LIB_ID + ': ' + sendSurveyToPanel.getPanelLibraryID()  ;

            throw new CFM_QualtricsBaseCallout.ResponseNotOKException(
                'Error recieved from callout \nResponse: ' + res.getBody() 
                + '\n-----\nDetails: ' + details);
        }
        return response;
    }

    private void addLog(CFM_QualtricsBaseCallout.ResponseNotOKException e, String method) {

        CFM_IntegrationLog log = new CFM_IntegrationLog(
            new CFM_Integration_Log__c(
                Method_Called__c = method,
                Result__c = 'Successful connection but invalid result',
                Response__c = 'Cause: ' + e.getCause() 
                            + '\n-----\nStack Trace: ' + e.getStackTraceString() 
                            + '\n-----\nMessage: ' + e.getMessage(),
                Status__c = CFM_IntegrationLog.STATUS_PROC_EXCEPTION,
                Survey_Batch__c = mSurveyBatch.getId()
            )
        );
        log.save();
    }

    public String getSurveyBatchProjectCSV() {
        return mSurveyBatchProjectCSV;
    }
    public void setSurveyBatchProjectCSV(String surveyBatchProjectCSV) {
        mSurveyBatchProjectCSV = surveyBatchProjectCSV;
    }
}