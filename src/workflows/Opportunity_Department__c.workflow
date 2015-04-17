<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Brooke_O_Brien_of_new_opps_using_Department_0750_or_5927</fullName>
        <description>Notify Brooke and Bridget of new opps using Department 0750 or 5927</description>
        <protected>false</protected>
        <recipients>
            <recipient>bridget.williams@aecom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>brooke.o&apos;brien@aecom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Environment/Notify_Brooke_O_Brien_of_new_opps_using_Department_0750_or_5927</template>
    </alerts>
    <alerts>
        <fullName>Notify_Brooke_that_Prog_est_value_has_changed</fullName>
        <description>Notify Brooke that Program Est Value has changed</description>
        <protected>false</protected>
        <recipients>
            <recipient>brooke.o&apos;brien@aecom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Environment/Notify_Brooke_O_Brien_of_change_in_program_value</template>
    </alerts>
    <rules>
        <fullName>Check for use of Department 0750 or 5927</fullName>
        <actions>
            <name>Notify_Brooke_O_Brien_of_new_opps_using_Department_0750_or_5927</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity_Department__c.Department_Name__c</field>
            <operation>startsWith</operation>
            <value>0750,5927</value>
        </criteriaItems>
        <description>checks for new opps using Department 0750 or 5927 so that Brooke O&apos;Brien can be notified.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
