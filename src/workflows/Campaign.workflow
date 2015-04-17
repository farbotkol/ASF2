<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Campaign_Inactive</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Set Campaign Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Default_Campaign_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>salesforce_help@aecom.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Default Campaign Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Autoset Active</fullName>
        <actions>
            <name>Set_Campaign_Inactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>Completed,Aborted</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Default Owner - Campaign</fullName>
        <actions>
            <name>Set_Default_Campaign_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Campaign.OwnerId</field>
            <operation>notEqual</operation>
            <value>SalesforceSupport AECOM</value>
        </criteriaItems>
        <description>All records set to SalesforceSupport AECOM as owner</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
