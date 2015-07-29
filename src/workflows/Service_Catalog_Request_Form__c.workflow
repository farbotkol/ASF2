<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Request_form_Notification</fullName>
        <description>New Request form Notification</description>
        <protected>false</protected>
        <recipients>
            <field>SME__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Request_Form_Notification</template>
    </alerts>
</Workflow>
