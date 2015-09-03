public class CFM_SurveyBatchReview extends CFM_BaseModel {
	public static Finder find = new Finder('CFM_Survey_Project_Review__c');

	public CFM_Survey_Project_Review__c obj { get { return (CFM_Survey_Project_Review__c)mObj; } }

 	public CFM_SurveyBatchReview(CFM_Survey_Project_Review__c review) {
		super(review);
	}


	public class Finder extends CFM_BaseFinder {
		public Finder(String sObjectName) {
			super(sObjectName);
		}

		public CFM_SurveyBatchReview findById(Id projectReviewId) {
			CFM_Survey_Project_Review__c review = (CFM_Survey_Project_Review__c)byId(projectReviewId);
			return new CFM_SurveyBatchReview(review);
		}
	}
}