<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CFM_Survey_Project_PM_Review_Initial_Notification</fullName>
        <description>CFM Survey Project PM Review Initial Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CFM_Survey_E_mails/Notify_PM_Initial_e_mail_to_PMs_for_client_contact_info</template>
    </alerts>
    <alerts>
        <fullName>CFM_Survey_Project_PM_Review_Reminder_Notification</fullName>
        <description>CFM Survey Project PM Review Reminder Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CFM_Survey_E_mails/Notify_PM_Reminder_e_mail_to_PMs_for_client_contact_info</template>
    </alerts>
    <fieldUpdates>
        <fullName>CFM_Update_Survey_Review_Sent_Date</fullName>
        <field>Email_Sent_Date__c</field>
        <formula>Now()</formula>
        <name>CFM Update Survey Review Sent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CFM Survey Review Notification Email</fullName>
        <actions>
            <name>CFM_Survey_Project_PM_Review_Initial_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CFM_Update_Survey_Review_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CFM_Survey_Project_Review__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <description>This rule sends out PM notification emails - both initial and reminder</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CFM_Survey_Project_PM_Review_Reminder_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CFM_Survey_Project_Review__c.Survey_Close_Date__c</offsetFromField>
            <timeLength>-24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
