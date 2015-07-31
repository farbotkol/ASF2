public with sharing class rsProjectViewModel implements Comparable {

	public static String SortField {get; set;}
	public static String SortOrder {get; set;}
	private rsProjectGroup project;

	public rsProjectViewModel(rsProjectGroup project) {
		this.project = project;
		if(SortOrder == null) SortOrder = 'asc';
	}

	public void setObj(rsProjectGroup project){
		this.project = project;
	}

	public rsProjectGroup getObj(){
		return this.project;
	}

	public Integer compareTo(Object compareTo) {
	    rsProjectViewModel compareItem = (rsProjectViewModel)compareTo;

	    if(project.order != null && compareItem.project.order != null) {
	    	if(project.order == compareItem.getObj().order) { 
	    		if(Integer.valueOf(project.groupProjects.get(0).getObj().get('Project_Sequence__c')) > Integer.valueOf(compareItem.getObj().groupProjects.get(0).getObj().get('Project_Sequence__c'))) {
	    			return 1;
	    		} else {
	    			return -1;
	    		}
	    	} else if(project.order > compareItem.getObj().order) {
	    		return 1;
	    	} else {
	    		return -1;
	    	}
	    } else {
	    	String val1 = project.projectGroup;
	    	String val2 = compareItem.getObj().projectGroup;
	    	if(val1 == null || val2 == null) {
	    		return 1;
	    	}
	    	return val1.compareTo(val2);
	    }

    }
}