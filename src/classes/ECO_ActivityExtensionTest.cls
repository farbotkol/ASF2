/*
	Purpose: - Test class for the ECO_ActivityExtension class

	Created By: Aaron Pettitt

	Revision Log:  
	 	v1.0 - (AP 12/04/2015) -- created
*/
@isTest
private class ECO_ActivityExtensionTest {
	
	@isTest static void test_method_one() {
		PageReference pg = Page.ECO_ActivityRecordType;
		pg.getParameters().put('sObject', 'Task');
		pg.getParameters().put('recordType', 'ECO Tasks');
		Test.setCurrentPage(pg);
		ECO_ActivityExtension controller = new ECO_ActivityExtension();
		pg = controller.Redirect();
		system.assertEquals('/00T/e?nooverride=1&recordType=012e00000009AigAAE&sObject=Task', pg.getUrl());
		pg = Page.ECO_ActivityRecordType;
		pg.getParameters().put('sObject', 'Task');
		Test.setCurrentPage(pg);
		controller = new ECO_ActivityExtension();
		pg = controller.Redirect();
		system.assertEquals(null, pg);
	}
	
}