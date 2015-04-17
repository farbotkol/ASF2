<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Assigned_Of_Issue_Assignment</fullName>
        <description>Notify Assigned Of Issue Assignment</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Issue_Application/AssignedIssue_Closed_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_email_notification_to_issue_creator</fullName>
        <description>Send email notification to issue reported by on close</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Reported_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Issue_Application/Issue_Closed_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Issue_Owner_To_Queue_Name</fullName>
        <field>OwnerId</field>
        <lookupValue>IssueQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Issue Owner To Queue Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Issue Closed Email Notification</fullName>
        <actions>
            <name>Send_email_notification_to_issue_creator</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Issue__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Send an email to issue reported by</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Assigned Of Issue</fullName>
        <actions>
            <name>Notify_Assigned_Of_Issue_Assignment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>PRIORVALUE( OwnerId )  &lt;&gt; OwnerId</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Owner To Queue On Create</fullName>
        <actions>
            <name>Set_Issue_Owner_To_Queue_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
