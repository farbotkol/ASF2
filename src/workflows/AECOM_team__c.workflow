<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification_of_new_PDD_Record_Owner</fullName>
        <description>Notification of new PDD Record Owner</description>
        <protected>false</protected>
        <recipients>
            <recipient>kimberly.cowern@aecom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/PDD_Record_Owner_Change_notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Team_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>salesforce_help@aecom.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Team Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>PDD Record Owner Change</fullName>
        <actions>
            <name>Notification_of_new_PDD_Record_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AECOM_team__c.Role__c</field>
            <operation>equals</operation>
            <value>PDD Record Owner</value>
        </criteriaItems>
        <description>Notification of an addition, deletion, or change in the person associated with the PDD Record Owner role</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Default Owner - Project</fullName>
        <active>false</active>
        <criteriaItems>
            <field>AECOM_team__c.OwnerId</field>
            <operation>equals</operation>
            <value>SalesforceSupport AECOM</value>
        </criteriaItems>
        <description>All records set to SalesforceSupport AECOM as owner</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Default Owner - Team</fullName>
        <actions>
            <name>Set_Team_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AECOM_team__c.OwnerId</field>
            <operation>equals</operation>
            <value>SalesforceSupport AECOM</value>
        </criteriaItems>
        <description>All records set to SalesforceSupport AECOM as owner</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
