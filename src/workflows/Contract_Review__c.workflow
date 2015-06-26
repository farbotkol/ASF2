<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Withdraw_Contract_Review</fullName>
        <field>Status_Review__c</field>
        <literalValue>Withdraw and Closed</literalValue>
        <name>Withdraw Contract Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Contract Review Withdraw</fullName>
        <actions>
            <name>Withdraw_Contract_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract_Review__c.Withdraw__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>set status when the contract is Withdrawn</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
