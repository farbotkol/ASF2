public class ECO_TaskDetailController
{
    pse__Proj__c theProject;
    public List<ECO_ProjectTask> tasks {get; set;}
    public integer intRowNo{get;set;}
    public boolean boolShowNewBtn{get;set;}
    public list<TaskDetailWrapper> lstTaskDetailWrapper{get;set;}
    list<pse__Project_Task__c> lstProjTaskToDelete;
    public map<string,string> mapPicklistLabelToValue = new map<string,string>();
    
    public Map<Id, Integer> taskHashes;

    //Class Constructor
    public ECO_TaskDetailController(ApexPages.StandardController con) 
    {
        lstProjTaskToDelete = new list<pse__Project_Task__c>();
        theProject = ECO_Service_Projects.getProjectById(con.getId());
        intRowNo = 0;
        boolShowNewBtn = false;
        
        Schema.DescribeFieldResult fieldResult = pse__Project_Task__c.WorkTypeName__c.getDescribe();
        
        for( Schema.PicklistEntry f : fieldResult.getPicklistValues())
        {
            mapPicklistLabelToValue.put(f.getLabel(), f.getValue());
        }    
        reload();
    }

    
    public void mySave()
    {
        try
        {    
            list<pse__Project_Task__c> lstProjTaskToUpsert = new list<pse__Project_Task__c>();
            Id idParentTask;
            Id idTopParentTask;

            integer intCount = 0;
            boolean isShowErrorMsg = false;
            boolean NotFinancial = false;

            for(TaskDetailWrapper objTDW : lstTaskDetailWrapper)
            {
                if (System.hashCode(objTDW.objEPT.oprojectTask) == taskHashes.get(objTDW.objEPT.oprojectTask.Id)) continue;
                objTDW.objEPT.oprojectTask.WorkTypeName__c = objTDW.strSelectedWorkTypeName;
                if(!objTDW.objEPT.oprojectTask.FinancialTask__c)
                {
                    if(objTDW.strSub_PeerTask == 'Peer Task' || objTDW.objEPT.indentLevel == 0)
                    {
                        isShowErrorMsg = true;
                        objTDW.strErrorMsg = 'All parent task must be Financial.';
                        objTDW.isErrorRow = true;
                    }
                }
                
                if(!isShowErrorMsg)
                {
                    if(objTDW .objEPT.oprojectTask.FinancialTask__c == false && objTDW.objEPT.oprojectTask.IsChargeable__c == true)
                    {
                        NotFinancial = true;
                        objTDW.strErrorMsg = 'Only Financial task can be chargeable.';
                        objTDW.isErrorRow = true;
                    }
                }
                
                objTDW.objEPT.oprojectTask.pse__order__c = intCount;
                if(objTDW.strSub_PeerTask == '')
                {
                    system.debug('Exp '+objTDW.strSelectedAction);
                    if(objTDW.strSelectedAction != null && objTDW.strSelectedAction.EqualsIgnoreCase('AddSubTask'))
                    {
                        //Add logic here to filter the Records and assign the Project Id in Subtask's
                        idParentTask = objTDW.objEPT.oprojectTask.Id;
                        idTopParentTask = objTDW.objEPT.oprojectTask.pse__Top_level_Parent_Task__c;

                        if (idTopParentTask == null) {
                            idTopParentTask = idParentTask;
                        }
                    
                    }
                     
                    lstProjTaskToUpsert.add(objTDW.objEPT.oprojectTask);
                }
                else
                {
                    pse__Project_Task__c obj = objTDW.objEPT.oprojectTask;
                    if(objTDW.strSub_PeerTask == 'Sub Task') {
                        system.debug('ParentTask: ' + idParentTask);
                      //  obj.pse__Parent_Task__c = idParentTask;

                       // obj.pse__Top_level_Parent_Task__c = idTopParentTask;
                    }
                        
                    obj.pse__Project__c = theProject.Id;

                    system.debug('New project task: ' + obj);
                    lstProjTaskToUpsert.add(obj);
                }
                
                intCount++;
            }
            
            if(!isShowErrorMsg)
            {
                if(!NotFinancial)
                {
                    boolean isDMLErrorFound = false;
                    //Upserting the Project Task
                    if(lstProjTaskToUpsert.size() > 0)
                    {
                        //upsert lstProjTaskToUpsert;
                        list<pse__Project_Task__c> lstProjTaskToInsert = new list<pse__Project_Task__c>();
                        list<pse__Project_Task__c> lstProjTaskToUpdate = new list<pse__Project_Task__c>();
                        
                        for(pse__Project_Task__c objPT : lstProjTaskToUpsert)
                        {
                            if(objPT.id != null)
                                lstProjTaskToUpdate.add(objPT);
                            else
                                lstProjTaskToInsert.add(objPT);
                        }
                        
                        Database.SaveResult[] srListUpdate = Database.update(lstProjTaskToUpdate, false);
                        integer j=0;
                        for(Database.SaveResult srru : srListUpdate )
                        {
                            if(!srru.isSuccess())
                            {
                                lstTaskDetailWrapper[j].isErrorRow = true;
                                isDMLErrorFound = true;
                                for(Database.Error objerru : srru.getErrors())
                                {
                                    lstTaskDetailWrapper[j].strErrorMsg = objerru.getMessage();
                                }
                            }
                        }
                        
                        Database.SaveResult[] srListInsert = Database.insert(lstProjTaskToInsert, false);
                        integer i=0;
                        for(Database.SaveResult srr : srListInsert)
                        {
                            if(!srr.isSuccess())
                            {
                                lstTaskDetailWrapper[i].isErrorRow = true;
                                isDMLErrorFound = true;
                                for(Database.Error objerr : srr.getErrors())
                                {
                                    lstTaskDetailWrapper[i].strErrorMsg = objerr.getMessage();
                                }
                            }
                        }
                        
                    }
                    //Deleting the Project Task  
                    system.debug('lstProjTaskToDelete!!!!'+lstProjTaskToDelete); 
                    if(lstProjTaskToDelete.size() > 0)
                        delete lstProjTaskToDelete;
                    
                    if(!isDMLErrorFound)
                        reload();
                }
                else{}
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Only Financial task can be chargeable.'));
            }
            else{}
                //ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'All parent task must be Financial'));
        }
        catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,ex.getMessage()));
            system.debug('Exp '+ex.getMessage());
        }
    } 
    
    public void reload() 
    {
        taskHashes = new Map<Id, Integer>();  
        tasks = ECO_ProjectTaskService.getProjectTaskList(theProject.Id);
        
        lstTaskDetailWrapper = new list<TaskDetailWrapper>();
        
        list<SelectOption> lstWorkTypeName = new list<SelectOption>();
        lstWorkTypeName.add(new SelectOption('','--None--'));
        for(string strLbl : mapPicklistLabelToValue.keySet())
        {
            lstWorkTypeName.add(new SelectOption(strLbl,mapPicklistLabelToValue.get(strLbl)));
        }
            
        for(ECO_ProjectTask obj : tasks)
        {
            taskHashes.put(obj.Id, System.hashCode(obj.oprojectTask));

            TaskDetailWrapper objTD = new TaskDetailWrapper(obj,lstWorkTypeName);
            objTD.strSelectedWorkTypeName = obj.oprojectTask.WorkTypeName__c;
            if(obj.oprojectTask.ForecastStartDate__c == null && obj.oprojectTask.pse__Start_Date_Time__c != null)
            {
                obj.oprojectTask.ForecastStartDate__c = obj.oprojectTask.pse__Start_Date_Time__c.date();
            }
            if(obj.oprojectTask.ForecastEndDate__c == null && obj.oprojectTask.pse__End_Date_Time__c != null)
            {
                obj.oprojectTask.ForecastEndDate__c = obj.oprojectTask.pse__End_Date_Time__c.date();
            }
            lstTaskDetailWrapper.add(objTD);    
        }
        if(lstTaskDetailWrapper.size() == 0)
        {
            boolShowNewBtn = true;
        }
    }
    
    public class TaskDetailWrapper
    {
        public ECO_ProjectTask objEPT{get;set;}
        public list<SelectOption> lstAction{get;set;}
        public list<SelectOption> lstWorkTypeName{get;set;}
        public string strSelectedAction{get;set;}
        public string strSelectedWorkTypeName{get;set;}
        public boolean boolShowInput{get;set;}
        public string strSub_PeerTask{get;set;}
        public string strErrorMsg{get;set;}
        public boolean isErrorRow{get;set;}
        
        public TaskDetailWrapper(ECO_ProjectTask obj,list<SelectOption> lstWTN)
        {
            strErrorMsg = '';
            isErrorRow = false;
            objEPT = obj;
            strSelectedAction = '';
            strSub_PeerTask = '';
            boolShowInput = false;
            lstAction = new list<SelectOption>();
            lstWorkTypeName= new list<SelectOption>();
            strSelectedWorkTypeName = 'Home Office';
            lstWorkTypeName = lstWTN;
            
            lstAction.add(new SelectOption('','Select Action'));
            lstAction.add(new SelectOption('AddPeerTask','Add Peer Task'));
            
            //if(objEPT.oprojectTask.OracleSyncStatus__c == 'P' || objEPT.oprojectTask.OracleSyncStatus__c == 'E')
            //{
                lstAction.add(new SelectOption('AddSubTask','Add Sub Task'));
                
            //}
            lstAction.add(new SelectOption('DeleteTask','Delete Task'));
            
        }
    }
    
    public pagereference manageRows()
    {
        try
        {
            TaskDetailWrapper objTDW = lstTaskDetailWrapper[intRowNo];
            //lstProjTaskToDelete.clear();
            if(objTDW != null)
            {
                if(objTDW.strSelectedAction.EqualsIgnoreCase('AddPeerTask') || objTDW.strSelectedAction.EqualsIgnoreCase('AddSubTask'))
                {
                    ECO_ProjectTask objECO = new ECO_ProjectTask();
                    pse__Project_Task__c objPT = objTDW.objEPT.oprojectTask.clone(false, false, false, false); 
                    
                    if(objTDW.strSelectedAction.EqualsIgnoreCase('AddSubTask'))
                    {
                        objTDW.objEPT.oprojectTask.IsChargeable__c = false;
                        objPT.pse__Parent_Task__c = objTDW.objEPT.oprojectTask.Id;
                    }
                    objPT.Name = '';
                    objPT.ProjectTaskNumber__c = null;
                    objPT.IsChargeable__c = true;
                    objECO.oprojectTask = objPT;
                    
                    list<SelectOption> lstWorkTypeName = new list<SelectOption>();
                    lstWorkTypeName.add(new SelectOption('','--None--'));
                    for(string strLbl : mapPicklistLabelToValue.keySet())
                    {
                        lstWorkTypeName.add(new SelectOption(strLbl,mapPicklistLabelToValue.get(strLbl)));
                    }
                
                    TaskDetailWrapper obj = new TaskDetailWrapper(objECO,lstWorkTypeName);
                    
                    if(objTDW.strSelectedAction.EqualsIgnoreCase('AddPeerTask'))
                        obj.strSub_PeerTask = 'Peer Task';
                    else if(objTDW.strSelectedAction.EqualsIgnoreCase('AddSubTask'))
                        obj.strSub_PeerTask = 'Sub Task';
                        
                    obj.boolShowInput = true;
                    if(intRowNo+1 == lstTaskDetailWrapper.size())
                        lstTaskDetailWrapper.add(obj);
                    else
                        lstTaskDetailWrapper.add(intRowNo+1,obj);
                }
                else if(objTDW.strSelectedAction.EqualsIgnoreCase('DeleteTask'))
                {
                    lstProjTaskToDelete.add(lstTaskDetailWrapper[intRowNo].objEPT.oprojectTask);
                    
                    lstTaskDetailWrapper.Remove(intRowNo);
                }
            }
        }
        catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,ex.getMessage()));
        }
        
        return null;
    }
    
    public pagereference addNewRowTask()
    {
        try
        {
            if(lstTaskDetailWrapper.size() == 0)
            {
                ECO_ProjectTask objECO = new ECO_ProjectTask();
                pse__Project_Task__c objPT = new pse__Project_Task__c();
                
                objPT.Name = '';
                objPT.ProjectTaskNumber__c = null;
                objPT.pse__Project__c = theProject.id;
                objPT.pse__Start_Date_Time__c = datetime.newInstance(theProject.EstimatedStartDate__c.year(), theProject.EstimatedStartDate__c.month(),theProject.EstimatedStartDate__c.day());
                Date endDate = theProject.EstimatedEndDate__c == Null ? theProject.EstimatedStartDate__c : theProject.EstimatedEndDate__c;
                objPT.pse__End_Date_Time__c = datetime.newInstance(endDate.year(), endDate.month(),endDate.day());
                objPT.ForecastStartDate__c = theProject.EstimatedStartDate__c;
                objPT.ForecastEndDate__c = theProject.EstimatedEndDate__c == Null ? theProject.EstimatedStartDate__c : theProject.EstimatedEndDate__c;
                objPT.EarnedValueCurve__c = 'Even';            
                list<SelectOption> lstWorkTypeName = new list<SelectOption>();
                lstWorkTypeName.add(new SelectOption('','--None--'));
                for(string strLbl : mapPicklistLabelToValue.keySet())
                {
                    lstWorkTypeName.add(new SelectOption(strLbl,mapPicklistLabelToValue.get(strLbl)));
                }
                
                TaskDetailWrapper obj = new TaskDetailWrapper(objECO,lstWorkTypeName);
                
                objECO.oprojectTask = objPT;
                
                obj.strSub_PeerTask = '';
                
                obj.boolShowInput = true;
                
                
                lstTaskDetailWrapper.add(obj);
                
                boolShowNewBtn = false;
            }
        }
        catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,ex.getMessage()));
        }
        
        return null;
    }
}