<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EcoPortalMessageGeneralEmail</fullName>
        <ccEmails>brian.jacobi@nttdata.com</ccEmails>
        <ccEmails>dandy.rodrigues@aecom.com</ccEmails>
        <description>EcoPortalMessageGeneralEmail</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/EcoPortalAlertGeneral</template>
    </alerts>
    <rules>
        <fullName>Eco Portal Alert General</fullName>
        <actions>
            <name>EcoPortalMessageGeneralEmail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Emails a general email to the owner of the portal message record when the email flag is set.</description>
        <formula>OR(AND(ISNEW()= True,IsEmailAlert__c = True),
AND(ISCHANGED(IsEmailAlert__c),IsEmailAlert__c = True))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
