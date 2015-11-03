<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Credit_Control_Department</fullName>
        <ccEmails>bjacobi@centerstance.com</ccEmails>
        <ccEmails>dandy.rodrigues@aecom.com</ccEmails>
        <description>Email Credit Control Department</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/Severe_Credit_Rating</template>
    </alerts>
    <alerts>
        <fullName>Send_Key_Client_Notification_to_Account_Manager</fullName>
        <ccEmails>bjacobi@centerstance.com</ccEmails>
        <ccEmails>dandy.rodrigues@aecom.com</ccEmails>
        <description>Send Key Client Notification to Account Manager</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/Key_Client_Added_to_Project</template>
    </alerts>
    <rules>
        <fullName>EcoClient Credit Risk Severe Notification</fullName>
        <actions>
            <name>Email_Credit_Control_Department</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project_Site__c.CreditRiskRating__c</field>
            <operation>lessOrEqual</operation>
            <value>1298</value>
        </criteriaItems>
        <description>Sends the Credit Control Department an email when the client risk is severe</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EcoKey Client - Notification to Account Manager</fullName>
        <actions>
            <name>Send_Key_Client_Notification_to_Account_Manager</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notified the account manager when a key client is associated with a projecct</description>
        <formula>ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
