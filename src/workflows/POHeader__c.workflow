<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EcoPOApproval</fullName>
        <description>EcoPOApproval</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>ProjectManager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/EcoPurchase_Order_Approval</template>
    </alerts>
    <alerts>
        <fullName>EcoPOApprovalRecalled</fullName>
        <description>EcoPOApprovalRecalled</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>ProjectManager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/EcoPurchase_Order_RequestRecalled</template>
    </alerts>
    <fieldUpdates>
        <fullName>EcoSetPOStatusApproved</fullName>
        <field>Status__c</field>
        <literalValue>APPROVED</literalValue>
        <name>EcoSetPOStatusApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoSetPOStatusCancelled</fullName>
        <field>Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>EcoSetPOStatusCancelledd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoSetPOStatusPending</fullName>
        <description>Sets the PO status to pending</description>
        <field>Status__c</field>
        <literalValue>Pending</literalValue>
        <name>EcoSetPOStatusPending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoSetPOStatusRejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>EcoSetPOStatusRejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
