<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>EcoDeliverableRevisionNumUpd</fullName>
        <description>Updates the deliverable revision number to the # of revisions +1</description>
        <field>RevisionNum__c</field>
        <formula>Deliverable__r.NumofRevisions__c +1</formula>
        <name>Eco Deliverable Revision Num Upd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Eco New Deliverable Revision</fullName>
        <actions>
            <name>EcoDeliverableRevisionNumUpd</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Deliverable__c.NumofRevisions__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Checks if the deliverable revision is new</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
