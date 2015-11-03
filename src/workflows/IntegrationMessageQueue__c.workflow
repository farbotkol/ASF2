<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EcoProjectEnrichServiceRequestFailure</fullName>
        <ccEmails>dandy.rodrigues@aecom.com</ccEmails>
        <ccEmails>bjacobi@centerstance.com</ccEmails>
        <description>EcoProject Enrich Service Request Failure</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/Integration_Message_Queue_Error</template>
    </alerts>
    <alerts>
        <fullName>Send_Alert_to_Message_Queue_Owner</fullName>
        <ccEmails>dandy.rodrigues@aecom.com</ccEmails>
        <ccEmails>bjacobi@centerstance.com</ccEmails>
        <description>EcoSend Alert to Message Queue Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/Integration_Message_Queue_Error</template>
    </alerts>
    <rules>
        <fullName>EcoMessage Queue - Send Alert to Owner If Error</fullName>
        <actions>
            <name>Send_Alert_to_Message_Queue_Owner</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IntegrationMessageQueue__c.ErrorMessage__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sends an alert to the creator of the message when there is an error</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
