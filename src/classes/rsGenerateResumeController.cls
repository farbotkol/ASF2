public with sharing class rsGenerateResumeController {
	
    private String mTemplateName;
    private String mDownloadLink;
    private Boolean mShowDownloadLink;
    public List<String> UserIds {get; set;}

	public rsGenerateResumeController() {		
		mShowDownloadLink = false;
	}

    public PageReference clearDownload() {
        mShowDownloadLink = false;
        return null;
    }

	public PageReference generateResume() {
        rsGenerationClient client = new rsGenerationClient();
        try{
            mDownloadLink = client.generate(rsResumeGenerationUtil.generateResumeJson(UserIds), mTemplateName);
            if(mDownloadLink == null) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Generate_Resume_Error + ':' + client.getError()));
                return null;
            }

        }catch(System.CalloutException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Generate_Resume_Timeout));
            return null;
        }
        mShowDownloadLink = true;
        return null;
	}

    public void setShowDownloadLink(Boolean val) {
    	mShowDownloadLink = true;
    }

    public Boolean getShowDownloadLink() {
    	return mShowDownloadLink;
    }

    public void setTemplateName(String value) {
    	mTemplateName = value;
    }

    public String getTemplateName() {
    	return mTemplateName;
    }

    public String getDownloadLink() {
    	return mDownloadLink;
    }
}