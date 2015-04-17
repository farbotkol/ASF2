<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Combine_First_and_Last_Name_in_Name_Fiel</fullName>
        <field>Name</field>
        <formula>First_Name__c  + &quot; &quot; + Last_Name__c</formula>
        <name>Combine First and Last Name in Name Fiel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_HR_DATA_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>salesforce_help@aecom.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set HR DATA Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Default Owner - HR Data</fullName>
        <actions>
            <name>Set_HR_DATA_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AECOM_Employee__c.OwnerId</field>
            <operation>notEqual</operation>
            <value>SalesforceSupport AECOM</value>
        </criteriaItems>
        <description>All records set to SalesforceSupport AECOM as owner</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Employee Record Name with Full Name</fullName>
        <actions>
            <name>Combine_First_and_Last_Name_in_Name_Fiel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule is set up to copy the full name of the employee into the Name field on the Employee object in order to allow searching by full name in the lookup filter.</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
