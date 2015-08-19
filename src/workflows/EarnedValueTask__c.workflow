<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EcoEarnedValueReportNotifyProjectTaskOwner</fullName>
        <description>EcoEarnedValueReport Notify Project Task Owner</description>
        <protected>false</protected>
        <recipients>
            <field>NotifyUserEmail__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/EcoEarnedValueTaskCompletionRequest</template>
    </alerts>
</Workflow>
