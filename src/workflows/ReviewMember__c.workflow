<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EcoDeliverableReviewReadyEmail</fullName>
        <description>EcoDeliverableReviewReadyEmail</description>
        <protected>false</protected>
        <recipients>
            <field>User_Stamp__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/EcoTechnicalQualityTeamReviewReady</template>
    </alerts>
    <fieldUpdates>
        <fullName>Eco_RM_Approved_Status_Upd</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Eco RM Approved Status Upd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Eco_RM_Rejected_Status_Upd</fullName>
        <description>Updates the technical quality reviewer status to rejected</description>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Eco RM Rejected Status Upd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Eco_Submitted_Status_Update</fullName>
        <description>Updates the technical quality reviewer status to submitted.</description>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Eco Submitted Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RM_Recalled_Status_Upd</fullName>
        <field>Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>RM Recalled Status Upd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EcoDeliverableReadyToReview</fullName>
        <actions>
            <name>EcoDeliverableReviewReadyEmail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ReviewMember__c.ReviewSubmitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
