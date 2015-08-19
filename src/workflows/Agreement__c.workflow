<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>EcoSetSegementationApprovalApproved</fullName>
        <field>SegApprovalStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>EcoSetSegementationApprovalApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoSetSegementationApprovalSubmitted</fullName>
        <field>SegApprovalStatus__c</field>
        <literalValue>Submitted</literalValue>
        <name>EcoSetSegementationApprovalSubmitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>MSA Project Needs to be Null</fullName>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Agreement__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prime (MSA)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
