public without sharing class ECO_ProjectTaskValidator{


	public void validateForInsertAndUpdate(pse__Project_Task__c[] tasks, Boolean isUpdate){

		List<pse__Project_Task__c> childTasks = new List<pse__Project_Task__c>();
        Map<Id, List<pse__Project_Task__c>> mapParentChildTasks = new Map<Id, List<pse__Project_Task__c>>();

        List<Revenue__c> lRevenue = new List<Revenue__c>();
        Map<ID, List<Revenue__c>> mapProjectTaskRevenue = new Map<ID, List<Revenue__c>>();

        List<ExpendItem__c> lExpend = new List<ExpendItem__c>();
        Map<ID, List<ExpendItem__c>> mapProjectTaskExpenditure = new Map<ID, List<ExpendItem__c>>();


      	Set<Id> taskIds = new Set<Id>();
      	for(pse__Project_Task__c task : tasks){
      		taskIds.add(task.Id);
      	}

        Set<Id> tasksWithPOLineItems = getTasksAssociatedWithPurchaseOrders(tasks);

        if(isUpdate){     		

        	childTasks = [SELECT Id, FinancialTask__c, pse__Parent_Task__c, IsChargeable__c
        					FROM pse__Project_Task__c
        					WHERE pse__Parent_Task__c IN :taskIds
        					ORDER BY pse__Parent_Task__c];

        	if(!childTasks.isEmpty()){
	        	for(pse__Project_Task__c childTask : childTasks){
	        		if(!mapParentChildTasks.containsKey(childTask.pse__Parent_Task__c)){
	        			List<pse__Project_Task__c> tempChildTasks = new List<pse__Project_Task__c>();
	        			tempChildTasks.add(childTask);
	        			mapParentChildTasks.put(childTask.pse__Parent_Task__c, tempChildTasks);
	        		}else{
	        			mapParentChildTasks.get(childTask.pse__Parent_Task__c).add(childTask);
	        		}
	        	}	
        	}        					

            lRevenue = [SELECT id, TaskNumber__c, GLDate__c FROM Revenue__c WHERE TaskNumber__c IN :taskIds ORDER BY TaskNumber__c, GLDate__c DESC];

            if(!lRevenue.isEmpty()){
                for(Revenue__c rev : lRevenue){
                    if(!mapProjectTaskRevenue.containsKey(rev.TaskNumber__c)){
                        List<Revenue__c> tempRev = new List<Revenue__c>();
                        tempRev.add(rev);
                        mapProjectTaskRevenue.put(rev.TaskNumber__c, tempRev);
                    }else{
                        mapProjectTaskRevenue.get(rev.TaskNumber__c).add(rev);
                    }
                }   
            }   

            lExpend = [SELECT id, ProjectTask__c, ExpenditureItemDate__c FROM ExpendItem__c WHERE ProjectTask__c IN :taskIds ORDER BY ProjectTask__c, ExpenditureItemDate__c DESC];

            if(!lExpend.isEmpty()){
                for(ExpendItem__c exp : lExpend){
                    if(!mapProjectTaskExpenditure.containsKey(exp.ProjectTask__c)){
                        List<ExpendItem__c> tempExp = new List<ExpendItem__c>();
                        tempExp.add(exp);
                        mapProjectTaskExpenditure.put(exp.ProjectTask__c, tempExp);
                    }else{
                        mapProjectTaskExpenditure.get(exp.ProjectTask__c).add(exp);
                    }
                }   
            }               

        }

        Map<Id, List<pse__Project_Task__c>> mapParentPeerTasks = new Map<Id, List<pse__Project_Task__c>>();
        Set<Id> parentTaskIds = new Set<Id>();
        for(pse__Project_Task__c task : tasks){
        	if(task.pse__Parent_Task__c != null){
        		parentTaskIds.add(task.pse__Parent_Task__c);
        	}        		
        }

        if(!parentTaskIds.isEmpty()){
	       	List<pse__Project_Task__c> peerTasks = [SELECT Id, FinancialTask__c, pse__Parent_Task__c, IsChargeable__c
	       											FROM pse__Project_Task__c
	       											WHERE pse__Parent_Task__c IN :parentTaskIds AND Id NOT IN :taskIds];
	       	if(!peerTasks.isEmpty()){
	        	for(pse__Project_Task__c peerTask : peerTasks){
	        		if(!mapParentPeerTasks.containsKey(peerTask.pse__Parent_Task__c)){
		       				List<pse__Project_Task__c> tempChildTasks = new List<pse__Project_Task__c>();
		       				tempChildTasks.add(peerTask);
		       				mapParentPeerTasks.put(peerTask.pse__Parent_Task__c, tempChildTasks);
		       		}else{
		       				mapParentPeerTasks.get(peerTask.pse__Parent_Task__c).add(peerTask);
		       		}
	        	}
	        }
        }
        	

        Integer pos = 0;
        	
        for(pse__Project_Task__c task : tasks){


        	//rule: All Top Tasks must be Financial
        	if(!task.FinancialTask__c && task.pse__Parent_Task__c == null){
				tasks[pos].addError(injectTaskNameInLabel(String.valueOf(System.Label.ECO_OracleTaskError_TopLevelFinancial), task.Name)); 
        	}

        	if(isUpdate){
        		//rule: All tasks that are parents of financial tasks must be finanicial
        		if(mapParentChildTasks.containsKey(task.Id)){

        			if(!task.FinancialTask__c){
        				for(pse__Project_Task__c childTask : mapParentChildTasks.get(task.Id)){
        					if(childTask.FinancialTask__c){
								tasks[pos].addError(injectTaskNameInLabel(String.valueOf(System.Label.ECO_OracleTaskError_NotFinancialWithChildren), task.Name)); 
                    		}
        				}        					
        			}

                    //rule: Task should be chargeable at the owest level of the task hierarchy only
                    if(task.IsChargeable__c){
                    	tasks[pos].addError(injectTaskNameInLabel(String.valueOf(System.Label.ECO_OracleTaskError_ChargeableAtLowestLevel), task.Name)); 
                    }
        		}
        	}
        		
        	//rule: All peer tasks on the same branch must be the same financial setting
        	if(task.pse__Parent_Task__c != null){
        		if(mapParentPeerTasks.containsKey(task.pse__Parent_Task__c)){
        			Boolean addError3 = false;
        			for(pse__Project_Task__c peerTask : mapParentPeerTasks.get(task.pse__Parent_Task__c)){
        				if(peerTask.FinancialTask__c != task.FinancialTask__c){
        					addError3 = true;
        				}
        			}
        			if(addError3){
        				tasks[pos].addError(injectTaskNameInLabel(String.valueOf(System.Label.ECO_OracleTaskError_PeerFinancial), task.Name)); 
        			}
        		}
        	}
        		

            //rule: If a task is non financial it must also be non-chargeable
            if(!task.FinancialTask__c && task.IsChargeable__c){
                tasks[pos].addError(injectTaskNameInLabel(String.valueOf(System.Label.ECO_OracleTaskError_FinancialNonChargeable), task.Name));                    
            }

            //rule: if task is part of a purchase order it must be financial and chargeable
            if(tasksWithPOLineItems.contains(task.Id) && (!task.FinancialTask__c|| !task.IsChargeable__c)){
                //tasks[pos].addError(injectTaskNameInLabel(String.valueOf(System.Label.ECO_OracleTaskError_TaskIsPartOfPurchaseOrder), task.Name));   
            }

            //rule: updated task date cannot be before the latest revenue date
            if(isUpdate){
                if(mapProjectTaskRevenue.containsKey(task.Id)){
                    if(task.pse__End_Date_Time__c < mapProjectTaskRevenue.get(task.id)[0].GLDate__c){
                        tasks[pos].addError(injectTaskNameInLabel(String.valueOf(System.Label.ECO_Revenue_Validation), task.Name)); 
                    }

                }

            }

            //rule: updated task date cannot be before the latest expenditure date
            if(isUpdate){
                if(mapProjectTaskExpenditure.containsKey(task.Id)){
                    if(task.pse__End_Date_Time__c < mapProjectTaskExpenditure.get(task.id)[0].ExpenditureItemDate__c){
                        tasks[pos].addError(injectTaskNameInLabel(String.valueOf(System.Label.ECO_Expenditure_Validation), task.Name)); 
                    }

                }

            }

           	pos ++;
        }

	}


	public void validateForDelete(pse__Project_Task__c[] tasks){
      
        Set<Id> tasksWithPOLineItems = getTasksAssociatedWithPurchaseOrders(tasks);

		Integer delPos = 0;
       
        for(pse__Project_Task__c task : tasks){
            //rule: Do not allow the deletion of a project task if the project task has been sent to Oracle
            if(task.OracleSyncStatus__c != null){
                if(task.OracleSyncStatus__c == 'T' || task.OracleSyncStatus__c == 'S'){
                    tasks[delPos].addError(injectTaskNameInLabel(String.valueOf(System.Label.ECO_OracleTaskError_Synced), task.Name));                    
                }
                if(tasksWithPOLineItems.contains(task.Id)){
                    // tasks[delPos].addError(injectTaskNameInLabel(String.valueOf(System.Label.ECO_OracleTaskError_TaskIsPartOfPurchaseOrder), task.Name));   
                }
            }  
            delPos ++;
        }   
	}

	@TestVisible
	private String injectTaskNameInLabel(String label, String  taskName){
		String labelStr = label;
		labelStr = labelStr.replaceAll('##TASKNAME##', taskName);
		return labelStr;
	}

    public void setTopTasksFinancial(pse__Project_Task__c[] tasks){
        
        for(pse__Project_Task__c task : tasks){
            if(task.pse__Parent_Task__c == null && !task.FinancialTask__c){
                task.FinancialTask__c = true;
            }
        }
    }

    private Set<Id> getTasksAssociatedWithPurchaseOrders(pse__Project_Task__c[] tasks){
        Set<Id> tasksWithPOLineItems = new Set<Id>();

        Set<Id> taskIds = new Set<Id>();
        for(pse__Project_Task__c task : tasks){
            taskIds.add(task.Id);
        }
        List<POLineItem__c> poLineItems = [SELECT Id, ProjectTask__c FROM POLineItem__c WHERE ProjectTask__c IN :taskIds];
      
        if(!poLineItems.isEmpty()){
            for(POLineItem__c poLineItem : poLineItems){
                tasksWithPOLineItems.add(poLineItem.ProjectTask__c);
            }
        }

        return tasksWithPOLineItems;
    }
   
}