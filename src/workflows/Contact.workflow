<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Concatenate_street_lines_into_otherst</fullName>
        <field>Other_Street__c</field>
        <formula>Other_Street_1__c  + BR() +  Other_Street_2__c</formula>
        <name>Concatenate street lines into OtherSt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Default_Contact_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>salesforce_help@aecom.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Default Contact Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Concatenate Contact Street lines</fullName>
        <actions>
            <name>Concatenate_street_lines_into_otherst</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Default Owner - Contact</fullName>
        <actions>
            <name>Set_Default_Contact_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.OwnerId</field>
            <operation>notEqual</operation>
            <value>SalesforceSupport AECOM</value>
        </criteriaItems>
        <description>All records set to SalesforceSupport AECOM as owner</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
