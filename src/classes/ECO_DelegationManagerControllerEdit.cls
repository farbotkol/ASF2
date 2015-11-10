/*
    Purpose: - Controller for the ECO_DelegateManagerEdit Visualforce Page

    Created By: Aaron Pettitt (NTT Data)

    Revision Log: 
        v1.0 - (AP 11/09/2015) -- created 
*/
public with sharing class ECO_DelegationManagerControllerEdit {

    public Delegate__c delegate{get; set;}
    public RecordType currentRecordType{get; set;}

    private ApexPages.StandardController controller;
    //constructor
    public ECO_DelegationManagerControllerEdit(ApexPages.StandardController standardController) {
        controller = standardController;
        delegate = (Delegate__c)standardController.getRecord();
        delegate = [Select Id, Name, Delegate__r.Name, RecordType.Name, RecordTypeId from Delegate__c where Id =: delegate.Id];
    }
}