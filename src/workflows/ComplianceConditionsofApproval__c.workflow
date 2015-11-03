<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>EcoSetComplianceConditionsCompleteDate</fullName>
        <field>ConditionsCompletedDate__c</field>
        <formula>Today()</formula>
        <name>EcoSetComplianceConditionsCompleteDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EcoDateStampComplianceCompletedDate</fullName>
        <actions>
            <name>EcoSetComplianceConditionsCompleteDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ComplianceConditionsofApproval__c.ConditionsCompleted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
