<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_on_D_B_check</fullName>
        <description>Notify on D&amp;B check</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/D_B_Rating_Added_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_on_new_client</fullName>
        <description>Notify on new client</description>
        <protected>false</protected>
        <recipients>
            <recipient>kathy.coyne@aecom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ContactFollowUpSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Warns_SFHelp_of_Private_Account</fullName>
        <description>Warns SFHelp of Private Account</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforce_help@aecom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CMC_North_America/Check_this_new_Account</template>
    </alerts>
    <fieldUpdates>
        <fullName>Concatenate_street_lines_into_Street</fullName>
        <description>Concatenate the street lines into the Street Text Area</description>
        <field>Street__c</field>
        <formula>Street_1__c  +  BR() + Street_2__c</formula>
        <name>Concatenate street lines into Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_Owner_To_AECOM_Support</fullName>
        <field>OwnerId</field>
        <lookupValue>salesforce_help@aecom.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Account Owner To AECOM Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Key_Account_Oracle_Task</fullName>
        <description>Sets the default Oracle Task &quot;number&quot; (really text) for use in generic &quot;below threshold&quot; B&amp;P numbers related to key accounts only.</description>
        <field>Oracle_Task__c</field>
        <formula>IF( 
ISBLANK(ParentId),  Oracle_Name_Key_Accounts__c , 
IF( 
ISBLANK(Parent.ParentId), 
Parent.Oracle_Name_Key_Accounts__c, 
IF( 
ISBLANK(Parent.Parent.ParentId), 
Parent.Parent.Oracle_Name_Key_Accounts__c, 
IF( 
ISBLANK(Parent.Parent.Parent.ParentId), 
Parent.Parent.Parent.Oracle_Name_Key_Accounts__c, 
IF( 
ISBLANK(Parent.Parent.Parent.Parent.ParentId), 
Parent.Parent.Parent.Parent.Oracle_Name_Key_Accounts__c, 

Parent.Parent.Parent.Parent.Parent.Oracle_Name_Key_Accounts__c
) 
) 
) 
) 
)</formula>
        <name>Set Key Account Oracle Task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Concatenate Account Street lines</fullName>
        <actions>
            <name>Concatenate_street_lines_into_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This will be used to concatenate the separate street lines that come in during migration. After data migration, this rule should not be Active.</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>D%26B Notification</fullName>
        <actions>
            <name>Notify_on_D_B_check</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.D_B_Rating__c</field>
            <operation>equals</operation>
            <value>Good,Limited,High,Fair</value>
        </criteriaItems>
        <description>Notify the account creator when a D&amp;B report and rating have been added to an account record</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Private Account Created</fullName>
        <actions>
            <name>Warns_SFHelp_of_Private_Account</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2) OR 3</booleanFilter>
        <criteriaItems>
            <field>Account.Client_Group__c</field>
            <operation>equals</operation>
            <value>Private</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Client_Subgroup__c</field>
            <operation>equals</operation>
            <value>Individual</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>contains</operation>
            <value>AECOM</value>
        </criteriaItems>
        <description>Checks for new accounts created with &quot;Private Individual&quot; coding so that they can be corrected quickly, before the opportunities are miscoded for end-sector client</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Default Owner - Account</fullName>
        <actions>
            <name>Set_Account_Owner_To_AECOM_Support</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>notEqual</operation>
            <value>SalesforceSupport AECOM</value>
        </criteriaItems>
        <description>All records set to SalesforceSupport AECOM as owner</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Oracle Task</fullName>
        <actions>
            <name>Set_Key_Account_Oracle_Task</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.FY14_Key_Client__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Oracle_Task__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Sets default Oracle Task for Key Accounts</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
