<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UniqueProjContact</fullName>
        <description>Build Unique Key by combining  Project ID + Contact ID</description>
        <field>ChkUniqueContact__c</field>
        <formula>Contact_Project__c +   Contact__c</formula>
        <name>UniqueProjContact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>UniqueProjContact</fullName>
        <actions>
            <name>UniqueProjContact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Used to validate the Field Update</description>
        <formula>(TRUE)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
