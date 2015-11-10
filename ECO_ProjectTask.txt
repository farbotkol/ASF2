public class ECO_ProjectTask {
    public pse__Project_Task__c oprojectTask {get; set;}
    
    public Id id {
        get{return oprojectTask.Id;}
        private set;
    }
    
    public Id parentTaskId {
        get{return oprojectTask.pse__Parent_Task__c;} 
        private set;
    }
    
    public String name {
        get{return oprojectTask.Name;} 
        private set;
    }
    
    public String taskNumber {
        get{return oprojectTask.ProjectTaskNumber__c;} 
        private set;
    }
    
    public String taskName {
        get{return oprojectTask.Name;} 
        private set;
    }

    public ECO_ProjectTask parent {get; set;}
    public List<ECO_ProjectTask> children {get; set;}
    public Integer indentLevel {get; set;}

    public String parentClasses {get; set;}

    public ECO_ProjectTask() {
        children = new List<ECO_ProjectTask>();
    }

    public ECO_ProjectTask(pse__Project_Task__c projectTask) {
        oprojectTask = projectTask;
        children = new List<ECO_ProjectTask>();
    }

    public void addChild(ECO_ProjectTask child) {
        children.add(child);
        child.parent = this;
    }
}