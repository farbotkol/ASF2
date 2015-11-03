<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Project_Country_Risk_Notification</fullName>
        <ccEmails>bjacobi@centerstance.com</ccEmails>
        <ccEmails>dandy.rodrigues@aecom.com</ccEmails>
        <description>EcoProject Country Risk Notification</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/Project_Country_Risk_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Ecosystem_Set_Safety_Rating</fullName>
        <field>SafetyRatingForRollup__c</field>
        <formula>CountryRisk__r.SafetyRating__c</formula>
        <name>Ecosystem - Set Safety Rating</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stamp_Ris</fullName>
        <field>Last_Country_Risk__c</field>
        <formula>Safety_Rating__c</formula>
        <name>Update Stamp Ris</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EcoProject Country Risk Notification</fullName>
        <actions>
            <name>Project_Country_Risk_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ProjectCountry_Risk__c.Safety_Rating__c</field>
            <operation>greaterThan</operation>
            <value>2.9</value>
        </criteriaItems>
        <description>Sends the group security email box an informative message when the risk rating is &gt; 2.9</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EcoSet Safety Rating</fullName>
        <actions>
            <name>Ecosystem_Set_Safety_Rating</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the safety rating for the country. This is needed to calculate the overall risk rating on the project.</description>
        <formula>NOT(ISNULL(CountryName__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Stamp Risk</fullName>
        <actions>
            <name>Update_Stamp_Ris</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ProjectCountry_Risk__c.Last_Country_Risk__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
