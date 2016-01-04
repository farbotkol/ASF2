<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EcoApproval_Send_Email_to_Submitter</fullName>
        <ccEmails>dandy.rodrigues@aecom.com</ccEmails>
        <ccEmails>bjacobi@centerstance.com</ccEmails>
        <description>EcoSend Email to Submitted</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/EcoSystem_Export_Controls_Request</template>
    </alerts>
    <alerts>
        <fullName>EcoExportControlsApprovedRejected</fullName>
        <description>EcoExportControlsApprovedRejected</description>
        <protected>false</protected>
        <recipients>
            <recipient>Export_Controls_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/EcoExportControlApprovedRejected</template>
    </alerts>
    <alerts>
        <fullName>Ecosystem_Email_Export_Controls_Team</fullName>
        <ccEmails>bjacobi@centerstance.com</ccEmails>
        <ccEmails>dandy.rodrigues@aecom.com</ccEmails>
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
    <fieldUpdates>
        <fullName>Eco_Assign_to_Export_Controls_Team</fullName>
        <field>OwnerId</field>
        <lookupValue>EcoExportControlsTeam</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Eco Assign to Export Controls Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Eco_Set_Export_Control_Submitted_Date</fullName>
        <field>SubmittedDate__c</field>
        <formula>Today()</formula>
        <name>Eco Set Export Control Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Eco_Set_Owner_to_Export_Control_Team</fullName>
        <field>OwnerId</field>
        <lookupValue>EcoExportControlsTeam</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Eco Set Owner to Export Control Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EcoExport Controls Completed</fullName>
        <actions>
            <name>Ecosystem_Email_Export_Controls_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Eco_Assign_to_Export_Controls_Team</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Eco_Set_Export_Control_Submitted_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ExportControl__c.SubmitforReview__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Should be handled via approval process notification.</description>
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
