public with sharing class ECO_CreateWeeklyRollupEntriesController {
	public ApexPages.StandardController stdController {get; set;}

	public ECO_CreateWeeklyRollupEntriesController(ApexPages.StandardController stdController) {
		this.stdController = stdController;
	}

	public void recalculate() {
		Set<Id> projectIds = new Set<Id>();
		projectIds.add(stdController.getId());

		ECO_ProjectTaskTriggers.recalculateProjects(projectIds, true);
	}
}