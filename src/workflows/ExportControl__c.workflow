<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EcoApproval_Send_Email_to_Submitter</fullName>
        <description>EcoSend Email to Submitter</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/EcoSystem_Export_Controls_Request</template>
    </alerts>
    <alerts>
        <fullName>Ecosystem_Email_Export_Controls_Team</fullName>
        <ccEmails>bjacobi@centerstance.com</ccEmails>
        <description>EcoEmail Export Controls Team</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/EcoSystem_Export_Controls_Request</template>
    </alerts>
    <fieldUpdates>
        <fullName>EcoExportControlSetStatusSubmitted</fullName>
        <field>ApprovalStatus__c</field>
        <literalValue>Submitted</literalValue>
        <name>EcoExportControlSetStatusSubmitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoExportControlSetStatusToApproved</fullName>
        <field>ApprovalStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>EcoExportControlSetStatusToApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoExportControlSetStatusToRejected</fullName>
        <field>ApprovalStatus__c</field>
        <literalValue>Rejected</literalValue>
        <name>EcoExportControlSetStatusToRejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoExportControlStatusToCancelled</fullName>
        <field>ApprovalStatus__c</field>
        <literalValue>Cancelled</literalValue>
        <name>EcoExportControlStatusToCancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EcoExport Controls Completed</fullName>
        <actions>
            <name>Ecosystem_Email_Export_Controls_Team</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ExportControl__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>Notifies the export controls team when a export control form is completed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EcoSendExportControlTaskToPM</fullName>
        <actions>
            <name>ACTION_Complete_Export_Controls_Form</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ExportControl__c.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Assigns an export control task to the owner of the export control.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>ACTION_Complete_Export_Controls_Form</fullName>
        <assignedToType>owner</assignedToType>
        <description>You must complete the export controls document.</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>ACTION: Complete Export Controls Form</subject>
    </tasks>
</Workflow>
