<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CFM_Set_Closed_Date</fullName>
        <field>Date_Time_Closed__c</field>
        <formula>now()</formula>
        <name>Set Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CFM Survey Case Update Close Date</fullName>
        <actions>
            <name>CFM_Set_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CFM_Survey_Case__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>This rule updates the closed date/time when the status of the case is set to &apos;Closed&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
