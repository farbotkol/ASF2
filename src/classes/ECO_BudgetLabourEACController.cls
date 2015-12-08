public with sharing class ECO_BudgetLabourEACController {
    public Id budgetHeaderId {get;set;}
    
    public ECO_DTO_BudgetLabourWrapper budgetLabourWrapper{get; set;}

    public  ECO_DTO_BudgetTask totalRow {get; set;}

    public Map<String, Integer> baHashes;

    public ApexPages.StandardSetController brSsc { 
      get;
      set; 
    }

    public Integer totalPages {get; set;}

    public ECO_BudgetLabourEACController(ApexPages.StandardController con) {
        String strPageNum = System.currentPageReference().getParameters().get('pagenum');
      
        budgetHeaderId = con.getId();

        brSsc = new ApexPages.StandardSetController(ECO_DTO_BudgetLabourWrapper.budgetResourceSelector(budgetHeaderId, 'Labor/Person'));
        brSsc.setPageSize(5);

        if (strPageNum != null) {
          brSsc.setPageNumber(Integer.valueOf(strPageNum));
        }
        System.debug('budgetHeaderId: ' + budgetHeaderId);
        System.debug('con: ' + con);
        
        budgetLabourWrapper = new ECO_DTO_BudgetLabourWrapper(brSsc, budgetHeaderId);

        recalcHashes();


        //totalRow = ECO_BudgetTaskService.getTotalRow(budgetLabourWrapper.dtoBudgetTasks);        
    }
    
    public void recalcHashes() {
       Decimal dtotalPages;
     

        dtotalPages = (brSsc.getResultSize() / brSsc.getPageSize());
        dtotalPages = Math.floor(dtotalPages) + ((Math.mod(brSsc.getResultSize(), brSsc.getPageSize())>0) ? 1 : 0);
        totalPages = Integer.valueOf(dtotalPages);
        
      baHashes = new Map<String, Integer>();
      for(ECO_DTO_BudgetLabourDetail dtoBudgetDetail : budgetLabourWrapper.dtoBudgetLabourDetails) {
       
          for (BudgetAssignment__c ba : dtoBudgetDetail.mAssignmentMap.values()) {
            baHashes.put('' + ba.BudgetTask__c + ba.BudgetResource__c, System.hashCode(ba));
          }
        }
        system.debug(LoggingLevel.INFO, baHashes.size());
    }
    public void reset() {
      budgetLabourWrapper.reset(brSsc.getRecords());
       

      recalcHashes();
    }

    public PageReference pageLast() {

      return saveEACRecords( totalPages);
     }
    public PageReference pageNext() {
      return saveEACRecords( brSsc.getPageNumber() + 1);
     }

    public PageReference pagePrevious() {
     return saveEACRecords(brSsc.getPageNumber() - 1);

   }
    public PageReference pageFirst() {
     return saveEACRecords(1);

    }

    public PageReference saveEACRecords(Integer pageNum) {
      System.debug('Begin saveEACRecords');
       
     //   List<BudgetResource__c> budgetResourceToUpdate = new List<BudgetResource__c>();
        List<BudgetAssignment__c> budgetAssignmentsToUpdate = new List<BudgetAssignment__c>();
        
        system.debug(LoggingLevel.ERROR, 'budgetLabourWrapper.dtoBudgetLabourDetails size: ' + budgetLabourWrapper.dtoBudgetLabourDetails.size());
        for(ECO_DTO_BudgetLabourDetail dtoBudgetDetail : budgetLabourWrapper.dtoBudgetLabourDetails) {
          for(BudgetAssignment__c ba : dtoBudgetDetail.mAssignmentMap.values()) {
            //system.debug(LoggingLevel.ERROR, 'Quantity: ' + ba.Quantity__c + ' hash: ' + System.hashCode(ba));
            Integer hashComp = System.hashCode(ba);
            if(baHashes.get('' + ba.BudgetTask__c + ba.BudgetResource__c) != System.hashCode(ba)) {
            
              budgetAssignmentsToUpdate.add(ba);
            }
          }
        
        }
        
       // system.debug('Resource: ' + budgetAssignmentsToUpdate[0].BudgetResource__c);
       // system.debug('Task: ' + budgetAssignmentsToUpdate[0].BudgetTask__c);
       // upsert budgetResourceToUpdate;
    
        upsert budgetAssignmentsToUpdate;

         PageReference pr = ApexPages.currentPage();
        pr.getParameters().put('Id', budgetHeaderId );
        pr.getParameters().put('pagenum', String.valueOf(pageNum) );
        pr.setRedirect(True);
        
      return pr;

    }

    public PageReference saveEAC() {
        
        return saveEACRecords(brSsc.getPageNumber());

    }
}