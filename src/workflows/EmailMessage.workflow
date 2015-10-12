<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SS_AP_Case_Reopened_Field_Update</fullName>
        <description>Changes status to &apos;Reopened&apos;</description>
        <field>Status</field>
        <literalValue>Reopened</literalValue>
        <name>SS-AP Case Reopened Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>SS-AP Case Resolved New Email</fullName>
        <actions>
            <name>SS_AP_Case_Reopened_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Shared Services AP - Rule to reopen cases when a closed case receives a new email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
