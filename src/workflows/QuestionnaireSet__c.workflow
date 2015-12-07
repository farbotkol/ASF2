<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EcoSystem_Final_Approval_for_Go_No_Go</fullName>
        <ccEmails>bjacobi@centerstance.com</ccEmails>
        <ccEmails>dandy.rodrigues@aecom.com</ccEmails>
        <description>EcoFinal Approval for Go/No Go</description>
        <protected>false</protected>
        <recipients>
            <recipient>Export_Controls_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>ProjectManager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/Go_No_Go_ApprovalCompleted</template>
    </alerts>
    <alerts>
        <fullName>EcoSystem_Recall_Notification_for_Go_No_Go</fullName>
        <ccEmails>bjacobi@centerstance.com</ccEmails>
        <ccEmails>dandy.rodrigues@aecom.com</ccEmails>
        <description>EcoRecall Notification for Go/No Go</description>
        <protected>false</protected>
        <recipients>
            <field>ProjectManager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/Go_No_Go_Recall</template>
    </alerts>
    <fieldUpdates>
        <fullName>EcoApprovalResetInitiateProcess</fullName>
        <description>Resets the initiate approval process text box to null</description>
        <field>InitiateNextApprovalProcess__c</field>
        <name>EcoApproval - Reset Initiate Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoApproval_Clear_Approval_Status</fullName>
        <field>ApprovalStatus__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>EcoApproval - Clear Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoApproval_Initiate_Process2Step1</fullName>
        <field>InitiateNextApprovalProcess__c</field>
        <formula>&quot;Process2Step1&quot;</formula>
        <name>EcoApproval - Initiate Process2Step1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoApproval_Initiate_Process3Step1</fullName>
        <field>InitiateNextApprovalProcess__c</field>
        <formula>&quot;Process3Step1&quot;</formula>
        <name>EcoApproval - Initiate Process3Step1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoApproval_Set_Rejected_Approval</fullName>
        <field>ApprovalStatus__c</field>
        <literalValue>Rejected</literalValue>
        <name>EcoApproval - Set Rejected Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoApproval_Set_Status_to_Approved</fullName>
        <field>ApprovalStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>EcoApproval - Set Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoApproval_Set_Status_to_Submitted</fullName>
        <field>ApprovalStatus__c</field>
        <literalValue>Submitted</literalValue>
        <name>EcoApproval - Set Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Eco_Set_Go_No_Go_Date</fullName>
        <field>GoNoGoDate__c</field>
        <formula>Today()</formula>
        <name>Eco Set Go/No Go Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
