<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Change_Management_Email_Notification</fullName>
        <description>Change Management Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>IssueTrackers</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Issue_Application/Change_Notification</template>
    </alerts>
    <rules>
        <fullName>New Change Management Implemented</fullName>
        <actions>
            <name>Change_Management_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Change_Management__c.Implemented__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Change_Management__c.CreatedById</field>
            <operation>notContain</operation>
            <value>coyne</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
