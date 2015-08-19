<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>EcoDeliverableStatusReviewComplete</fullName>
        <description>Updates deliverable status to complete</description>
        <field>Status__c</field>
        <literalValue>Review Complete</literalValue>
        <name>Eco Deliverable Status Review Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoDeliverableStatusReviewPendingUpd</fullName>
        <description>Updates the deliverable status to Review Pending</description>
        <field>Status__c</field>
        <literalValue>Review Pending</literalValue>
        <name>Eco Deliverable Status Review PendingUpd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoDeliverableSubmittedDateUpd</fullName>
        <description>Updates the deliverable submitted date to the current date</description>
        <field>DateSubmitted__c</field>
        <formula>TODAY()</formula>
        <name>Eco Deliverable Submitted Date Upd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
