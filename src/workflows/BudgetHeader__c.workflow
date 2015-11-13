<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SetACBudgetVersionName</fullName>
        <field>ActiveACBudgetVersion__c</field>
        <formula>BudgetName__c</formula>
        <name>Set AC Budget Version Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Project__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_FC_Budget_Version_Name</fullName>
        <field>ActiveFCBudgetVersion__c</field>
        <formula>BudgetName__c</formula>
        <name>Set FC Budget Version Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Project__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StatusAsOfDate_c</fullName>
        <field>StatusAsOfDate__c</field>
        <formula>Now()</formula>
        <name>StatusAsOfDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_To_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Status To Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_To_Forecast</fullName>
        <field>Status__c</field>
        <literalValue>Forecast</literalValue>
        <name>Update Status To Forecast</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Estimate</fullName>
        <field>Status__c</field>
        <literalValue>Estimate</literalValue>
        <name>Update Status to Estimate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Submitted_for_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Update Status to Submitted for Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Submitted_for_Forecast</fullName>
        <field>Status__c</field>
        <literalValue>Submitted for Forecast</literalValue>
        <name>Update Status to Submitted for Forecast</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Budget - Update Project AC Version</fullName>
        <actions>
            <name>SetACBudgetVersionName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>BudgetHeader__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Budget - Update Project FC Version</fullName>
        <actions>
            <name>Set_FC_Budget_Version_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>BudgetHeader__c.Status__c</field>
            <operation>equals</operation>
            <value>Forecast</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Budget Header Status As Of Date to Now</fullName>
        <actions>
            <name>StatusAsOfDate_c</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>BudgetHeader__c.StatusAsOfDate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>On insert or when Status field changes, update this field to Now()</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
