<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>State_and_Country_Set_Name</fullName>
        <field>Name</field>
        <formula>BLANKVALUE ( State__c , Country__c )</formula>
        <name>State and Country Set Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>State and Country Set Name</fullName>
        <actions>
            <name>State_and_Country_Set_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ISNEW() , ISCHANGED( State__c ) , ISCHANGED(  Country__c  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
