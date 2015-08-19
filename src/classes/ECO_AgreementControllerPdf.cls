global class ECO_AgreementControllerPdf extends ECO_AgreementController {

    public ECO_AgreementControllerPdf(ApexPages.standardController sc)
    {
        super(sc);
        // pdf file name format is {project-number}_{form}_{version-description}_{date}
		// TODO: find out what is {version-description}
		Datetime myDatetime = Datetime.now();
		String myDatetimeStr = myDatetime.format('yyyyMMdd');
		// project = ECO_Service_Agreement.getProjectFromId(projectId);
		// String pdfFileName = project.Name + '_Agreement_' + myDatetimeStr + '.pdf';
		agreement = ECO_Service_Agreement.getAgreementFromId(agreement.Id);  
        project = ECO_Service_Agreement.getProjectFromId(agreement.Project__c); 
		String pdfFileName = project.ProjectNumber__c + '_Agreement_' + agreement.Name + '_' + myDatetimeStr + '.pdf';
		Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=' + pdfFileName);		
    }
}