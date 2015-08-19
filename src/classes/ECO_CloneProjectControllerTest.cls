@IsTest (seeAllData = false)
private class ECO_CloneProjectControllerTest{


	private static testMethod void testControllerMethods(){

		final Integer numProjects = 100;
		final Integer numGlobalTemplates = 50;
		final Integer numMyTemplates = 20;

		Account testAccount = new Account();
		testAccount.Name = 'test Account';
		insert testAccount;

		//create project 
		List<pse__Proj__c> testProjects = new List<pse__Proj__c>();

		for(Integer i=0; i<numProjects; i++){
			pse__Proj__c testProject = new pse__Proj__c();
			testProject.Name = 'test ' + i + ' project';
			testProject.pse__Account__c = testAccount.Id;
			testProject.pse__Project_Type__c = 'Customer Project';
			testProject.pse__Billing_Type__c = 'Fixed Price';
			testProject.CurrencyIsoCode = 'USD';
			testProject.pse__Is_Active__c = true;
			testProjects.add(testProject);
		}
		
		for(Integer i=0; i<numGlobalTemplates; i++){
			pse__Proj__c testProject = new pse__Proj__c();
			testProject.Name = 'test ' + i + ' globaltemplate';
			testProject.pse__Account__c = testAccount.Id;
			testProject.pse__Project_Type__c = 'Customer Project';
			testProject.pse__Billing_Type__c = 'Fixed Price';
			testProject.CurrencyIsoCode = 'USD';
			testProject.pse__Is_Active__c = true;
			testProject.clGlobalProjectTemplate__c = true;
			testProjects.add(testProject);
		}

		for(Integer i=0; i<numMyTemplates; i++){
			pse__Proj__c testProject = new pse__Proj__c();
			testProject.Name = 'test ' + i + ' mytemplate';
			testProject.pse__Account__c = testAccount.Id;
			testProject.pse__Project_Type__c = 'Customer Project';
			testProject.pse__Billing_Type__c = 'Fixed Price';
			testProject.CurrencyIsoCode = 'USD';
			testProject.pse__Is_Active__c = true;
			testProject.PersonalProjectTemplate__c = true;
			testProjects.add(testProject);
		}

		insert testProjects;

		ApexPages.StandardSetController setCon = new ApexPages.StandardSetController (new List<pse__Proj__c>());
		ECO_CloneProjectController con = new ECO_CloneProjectController(setCon);

		system.assertEquals(false, con.noSearchResults);
		system.assertEquals(false, con.noGTSearchResults);
		system.assertEquals(false, con.noMTSearchResults);

		//test non-template project paging
		system.assertEquals(false, con.hasPrevProjects);
		system.assertEquals(false, con.hasFirstProject);
		system.assertEquals(true, con.hasLastProject);
		system.assertEquals(true, con.hasNextProjects);
		system.assertEquals(1, con.projectsCurrentPage);
		system.assertEquals(numProjects/con.pagingResultSize, con.projectsTotalPages);
		con.moveNextProjects();
		system.assertEquals(true, con.hasPrevProjects);
		system.assertEquals(2, con.projectsCurrentPage);
		system.assertEquals(true, con.hasPrevProjects);
		system.assertEquals(true, con.hasFirstProject);
		con.movePrevProjects();
		system.assertEquals(false, con.hasPrevProjects);
		system.assertEquals(false, con.hasFirstProject);
		system.assertEquals(1, con.projectsCurrentPage);
		con.moveLastProjects();
		system.assertEquals(numProjects/con.pagingResultSize, con.projectsCurrentPage);
		system.assertEquals(false, con.hasLastProject);
		system.assertEquals(false, con.hasNextProjects);
		con.moveFirstProjects();
		system.assertEquals(false, con.hasPrevProjects);
		system.assertEquals(false, con.hasFirstProject);
		system.assertEquals(true, con.hasLastProject);
		system.assertEquals(true, con.hasNextProjects);
		system.assertEquals(1, con.projectsCurrentPage);

		//test global template paging
		system.assertEquals(false, con.hasPrevGTs);
		system.assertEquals(false, con.hasFirstGT);
		system.assertEquals(true, con.hasLastGT);
		system.assertEquals(true, con.hasNextGTs);
		system.assertEquals(1, con.gtCurrentPage);
		system.assertEquals(numGlobalTemplates/con.pagingResultSize, con.gtTotalPages);
		con.moveNextGTs();
		system.assertEquals(true, con.hasPrevGTs);
		system.assertEquals(2, con.gtCurrentPage);
		system.assertEquals(true, con.hasPrevGTs);
		system.assertEquals(true, con.hasFirstGT);
		con.movePrevGTs();
		system.assertEquals(false, con.hasPrevGTs);
		system.assertEquals(false, con.hasFirstGT);
		system.assertEquals(1, con.gtCurrentPage);
		con.moveLastGTs();
		system.assertEquals(numGlobalTemplates/con.pagingResultSize, con.gtCurrentPage);
		system.assertEquals(false, con.hasLastGT);
		system.assertEquals(false, con.hasNextGTs);
		con.moveFirstGTs();
		system.assertEquals(false, con.hasPrevGTs);
		system.assertEquals(false, con.hasFirstGT);
		system.assertEquals(true, con.hasLastGT);
		system.assertEquals(true, con.hasNextGTs);
		system.assertEquals(1, con.gtCurrentPage);

		//test my template paging
		system.assertEquals(false, con.hasPrevMTs);
		system.assertEquals(false, con.hasFirstMT);
		system.assertEquals(true, con.hasLastMT);
		system.assertEquals(true, con.hasNextMTs);
		system.assertEquals(1, con.mtCurrentPage);
		system.assertEquals(numMyTemplates/con.pagingResultSize, con.mtTotalPages);
		con.moveNextMTs();
		system.assertEquals(true, con.hasPrevMTs);
		system.assertEquals(2, con.mtCurrentPage);
		system.assertEquals(true, con.hasPrevMTs);
		system.assertEquals(true, con.hasFirstMT);
		con.movePrevMTs();
		system.assertEquals(false, con.hasPrevMTs);
		system.assertEquals(false, con.hasFirstMT);
		system.assertEquals(1, con.mtCurrentPage);
		con.moveLastMTs();
		system.assertEquals(numMyTemplates/con.pagingResultSize, con.mtCurrentPage);
		system.assertEquals(false, con.hasLastMT);
		system.assertEquals(false, con.hasNextMTs);
		con.moveFirstMTs();
		system.assertEquals(false, con.hasPrevMTs);
		system.assertEquals(false, con.hasFirstMT);
		system.assertEquals(true, con.hasLastMT);
		system.assertEquals(true, con.hasNextMTs);
		system.assertEquals(1, con.mtCurrentPage);

		//test search filtering
		con.searchProjectName = 'test 0';
		con.SearchProjects();
		system.assertEquals(1, con.projects.size());
		system.assertEquals('test 0 project', con.projects.get(0).Name);
		system.assertEquals(1, con.projects.size());
		system.assertEquals('test 0 globaltemplate', con.globalTemplates.get(0).Name);
		system.assertEquals(1, con.projects.size());
		system.assertEquals('test 0 mytemplate', con.myTemplates.get(0).Name);

		

		con.searchProjectName = 'zzz';
		con.SearchProjects();
		system.assertEquals(true, con.projects.isEmpty());
		system.assertEquals(true, con.globalTemplates.isEmpty());
		system.assertEquals(true, con.myTemplates.isEmpty());


		con.searchProjectName = 'test 0 project';
		con.SearchProjects();
		system.assertEquals(1, con.projects.size());
		system.assertEquals(true, con.globalTemplates.isEmpty());
		system.assertEquals(true, con.myTemplates.isEmpty());

		//test project selection
		con.selectedProjectId = String.valueOf(con.projects.get(0).Id);
		con.setSelectedProject();
		system.assertEquals('test 0 project', con.selectedProjectName);
		con.searchProjectName = 'test 1 project';
		con.SearchProjects();
		con.mergeProjectId = String.valueOf(con.projects.get(0).Id);
		con.setMergeProject();
		system.assertEquals('test 1 project', con.mergeProject.Name);
		con.newProjectName = 'cloned project';
		con.clear();
		system.assertEquals(null, con.project.Id);
		system.assertEquals(null, con.mergeProject.Id);
		system.assertEquals(true, String.isEmpty(con.newProjectName));

		//test cancel
		PageReference pageRef = con.doCancel();
		system.assertNotEquals(null, pageRef);

		//test clone
	
	    //setup custom settings that feeds the cloning process
		List<ECO_Project_Cloning__c> settings = new List<ECO_Project_Cloning__c>();
		ECO_Project_Cloning__c projectSetting = new ECO_Project_Cloning__c();
		projectSetting.Name = 'project settings';
		projectSetting.Fieldset_API_Name__c = 'Clone_Project_Fields';
		projectSetting.Object_API_Name__c = 'pse__Proj__c';
		projectSetting.Parent_Object_API_Name__c = 'Id';
		projectSetting.Processing_Order__c = 1;
		projectSetting.Parent_Processing_Level__c = 0;
		projectSetting.Active__c = true;		
		settings.add(projectSetting);
		insert settings;	

		con.selectedProjectId = String.valueOf(con.projects.get(0).Id);
		con.setSelectedProject();
		con.newProjectName = 'cloned project';
		PageReference cloneResult = con.cloneProject();
		system.assertNotEquals(null, cloneResult);


	}

	private static testMethod void testControllerWithPresetSourceProjectId(){

		Account testAccount = new Account();
		testAccount.Name = 'test Account';
		insert testAccount;

		//create project 
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.Name = 'test project 0';
		testProject.pse__Account__c = testAccount.Id;
		testProject.pse__Project_Type__c = 'Customer Project';
		testProject.pse__Billing_Type__c = 'Fixed Price';
		testProject.CurrencyIsoCode = 'USD';
		testProject.pse__Is_Active__c = true;
		insert testProject;

		PageReference pageRef = new PageReference('apex/ECO_CloneProject');
		pageRef.getParameters().put('sourceProjectId', String.valueOf(testProject.Id));
		Test.setCurrentPage(pageRef);

		ApexPages.StandardSetController setCon = new ApexPages.StandardSetController (new List<pse__Proj__c>());
		ECO_CloneProjectController con = new ECO_CloneProjectController(setCon);
		system.assertEquals(con.project.Id, testProject.Id);
		system.assertEquals(con.selectedProjectId, String.valueOf(testProject.Id));
		system.assertEquals(con.selectedProjectName, testProject.Name);
	}


	private static testMethod void testControllerWithUrlParams(){

		Account testAccount = new Account();
		testAccount.Name = 'test Account';
		insert testAccount;

		//create project 
		pse__Proj__c testProject = new pse__Proj__c();
		testProject.Name = 'test project 0';
		testProject.pse__Account__c = testAccount.Id;
		testProject.pse__Project_Type__c = 'Customer Project';
		testProject.pse__Billing_Type__c = 'Fixed Price';
		testProject.CurrencyIsoCode = 'USD';
		testProject.pse__Is_Active__c = true;
		insert testProject;

		PageReference pageRef = new PageReference('apex/ECO_CloneProject');
		pageRef.getParameters().put('targetProjectId', String.valueOf(testProject.Id));
		pageRef.getParameters().put('cloningAction', 'tasks');
		pageRef.getParameters().put('retUrl', '/apex/test');
		Test.setCurrentPage(pageRef);

		ApexPages.StandardSetController setCon = new ApexPages.StandardSetController (new List<pse__Proj__c>());
		ECO_CloneProjectController con = new ECO_CloneProjectController(setCon);
		system.assertEquals(con.mergeProject.Id, testProject.Id);
		system.assertEquals(con.mergeProjectId, String.valueOf(testProject.Id));
		system.assertEquals(con.retUrl, '/apex/test');
	}
}