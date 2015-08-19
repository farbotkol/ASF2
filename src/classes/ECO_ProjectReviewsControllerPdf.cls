public with sharing class ECO_ProjectReviewsControllerPdf extends ECO_ProjectReviewsController {
	
	//public String projectSnapshotRecord {get; set;}
	
	public ECO_ProjectReviewsControllerPdf(ApexPages.StandardController oStandardController) {
		super(oStandardController);
		// pdf file name format is {project-number}_{form}_{version-description}_{date}
		// TODO: find out what is {version-description}
		Datetime myDatetime = Datetime.now();
		String myDatetimeStr = myDatetime.format('yyyyMMdd');
		
		String pdfFileName = theProject.ProjectNumber__c + '_ProjectReview_' + oProjectReview.Name + '_' +  myDatetimeStr + '.pdf';
		Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=' + pdfFileName);		
	}
	
	public String getProjectSnapshotRecord()
	{
		list<ProjectSnapshot__c> projectSnapshotRecords = [select Id from ProjectSnapshot__c where ProjectReview__c = :oProjectReview.Id order by Id desc];
		
		if(projectSnapshotRecords.size() > 0)
			return(new PageReference('/apex/ECO_ProjectSnapshot?Id='+ projectSnapshotRecords[0].Id).getContent().toString());
		return '';
	}
}