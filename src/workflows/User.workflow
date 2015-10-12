<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Profile_Proxy_Change_Email_Alert</fullName>
        <description>Profile Proxy Change Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Profile_Proxy_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Proxy_Change_Notification</template>
    </alerts>
    <alerts>
        <fullName>Profile_Proxy_Removal_Email_Alert</fullName>
        <description>Profile Proxy Removal Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Proxy_Removal_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Chatter_External_Non_Employee</fullName>
        <description>Sets Non Employee to true if chatter external user</description>
        <field>Non_employee__c</field>
        <literalValue>1</literalValue>
        <name>Chatter External Non Employee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Date_Time_Sent_For_Review</fullName>
        <field>Date_Time_Sent_for_Review__c</field>
        <name>Clear Date Time Sent For Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Notification</fullName>
        <field>Send_Proxy_Notification__c</field>
        <name>Clear Notification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Adds CRM Users to Group</fullName>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>contains</operation>
            <value>Superuser</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>contains</operation>
            <value>Standard User</value>
        </criteriaItems>
        <description>Adds CRM Users to Group called CRM Users</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Clear out Date Time Sent For Review when Approved</fullName>
        <actions>
            <name>Clear_Date_Time_Sent_For_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>When a user&apos;s resume approval status is set to Approved, they should no longer have a value in their date_time_sent_for_review__c field.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>External User</fullName>
        <actions>
            <name>Chatter_External_Non_Employee</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Chatter External User</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sets non employee to true when an external user is created or edited</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Proxy Change Notification</fullName>
        <actions>
            <name>Profile_Proxy_Change_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Clear_Notification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Send_Proxy_Notification__c</field>
            <operation>equals</operation>
            <value>Change</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Proxy Removal Notification</fullName>
        <actions>
            <name>Profile_Proxy_Removal_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Clear_Notification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Send_Proxy_Notification__c</field>
            <operation>equals</operation>
            <value>Removal</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
