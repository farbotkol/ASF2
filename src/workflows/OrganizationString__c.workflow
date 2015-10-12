<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Ecosystem_Set_Org_to_Inactive</fullName>
        <description>Sets the Org to inactive once an inactive date is set</description>
        <field>isActive__c</field>
        <literalValue>0</literalValue>
        <name>Ecosystem - Set Org to Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EcoSet Org to Inactive</fullName>
        <actions>
            <name>Ecosystem_Set_Org_to_Inactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OrganizationString__c.InactiveDate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sets the org to inactive if an inactive date is set</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
