/**
 *   API definition: https://survey.qualtrics.com/WRAPI/ControlPanel/docs.php
 *
 */
public with sharing class CFM_QualtricsSendSurveyToPanelCallout extends CFM_QualtricsBaseCallout {

    public static final Integer EXP_DATE_WEEKS_AHEAD  = 3;

    public static final String PARAM_KEY_SURVEY       = 'SurveyID';
    public static final String PARAM_KEY_SEND_DATE    = 'SendDate';
    public static final String PARAM_KEY_SENT_ADDR    = 'SentFromAddress';
    public static final String PARAM_KEY_FROM_EMAIL   = 'FromEmail';
    public static final String PARAM_KEY_FROM_NAME    = 'FromName';
    public static final String PARAM_KEY_SUBJECT      = 'Subject';
    public static final String PARAM_KEY_MSG_ID       = 'MessageID';
    public static final String PARAM_KEY_MSG_LIB_ID   = 'MessageLibraryID';
    public static final String PARAM_KEY_PANEL_LIB_ID = 'PanelLibraryID';
    public static final String PARAM_KEY_EXP_DATE     = 'ExpirationDate';
    public static final String QUALTRICS_DATE_FORMAT  = 'yyyy-MM-dd hh:mm:ss';

    private String          mPanelId;
    private CFM_SurveyBatch mSurveyBatch;

	public CFM_QualtricsSendSurveyToPanelCallout(CFM_SurveyBatch surveyBatch, String panelId) {
        super();
		mSurveyBatch = surveyBatch;
        mPanelId = panelId;
        setSurveyBatchId(mSurveyBatch.getId());
	}

    public override Map<String, String> getAdditionalHeaders() {
        Map<String, String> headers = new Map<String, String>();
        headers.put(PARAM_KEY_SURVEY,       getSurveyID());
        headers.put(PARAM_KEY_SEND_DATE,    getSendDateFormatted());
        headers.put(PARAM_KEY_SENT_ADDR,    getSentFromEmail());
        headers.put(PARAM_KEY_FROM_EMAIL,   getFromEmail());
        headers.put(PARAM_KEY_FROM_NAME,    getFromName());
        headers.put(PARAM_KEY_SUBJECT,      getSubject());
        headers.put(PARAM_KEY_MSG_ID,       getMessageID());
        headers.put(PARAM_KEY_MSG_LIB_ID,   getMessageLibraryID());
        headers.put(PARAM_KEY_EXP_DATE,     getExpirationDateFormatted());
        headers.put(PARAM_KEY_PANEL_LIB_ID, getPanelLibraryID());
        return headers;
    }

    public override String getHTTPMethod() {
        return 'GET';
    }

    public override String getRequest() {
        return 'sendSurveyToPanel';
    }

    public override String getVersion() {
        return mSettings.Qualtrics_Send_Survey_Version__c;
    }

    public override String getPanelID() {
        return mPanelId;
    }
    public void setPanelID(String panelId) {
        mPanelId = panelId;
    }

    public override String getBodyForPost() {
        //---This is a GET request, no body needed
        return null;
    }

    public String getSurveyID() {
        return mSettings.Qualtrics_Survey_ID__c;
    }

    public Datetime getSendDate() {
        return Datetime.now();
    }

    public String getSendDateFormatted() {
        return getSendDate().format(QUALTRICS_DATE_FORMAT);
    }

    public Datetime getExpirationDate() {
        return getSendDate().addDays(7 * EXP_DATE_WEEKS_AHEAD);
    }

    public String getExpirationDateFormatted() {
        return getExpirationDate().format(QUALTRICS_DATE_FORMAT);
    }

    public String getSentFromEmail() {
        return mSettings.Qualtrics_Sent_From_Email__c;
    }

    public String getFromEmail() {
        return mSettings.Qualtrics_From_Email__c;
    }

    public String getFromName() {
        return mSettings.Qualtrics_From_Name__c;
    }

    public String getSubject() {
        return mSettings.Qualtrics_Subject__c;
    }

    public String getMessageID() {
        return mSettings.Qualtrics_Message_ID__c;
    }

    public String getMessageLibraryID() {
        return mSettings.Qualtrics_Message_Library_ID__c;
    }

    public String getPanelLibraryID() {
        return mSettings.Qualtrics_Panel_Library_ID__c;
    }
}