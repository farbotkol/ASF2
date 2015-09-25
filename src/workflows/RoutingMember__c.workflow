<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_the_Routing_Member_Unique</fullName>
        <field>RoutingMemberTextUnique__c</field>
        <formula>UniqueRoutingMemberFormula__c</formula>
        <name>Update the Routing Member Unique</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Insert Routing Member Formula for Uniqueness</fullName>
        <actions>
            <name>Update_the_Routing_Member_Unique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RoutingMember__c.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Insert the Routing Member Formula Field into the Routing Member Unique Text field to check for uniqueness</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
