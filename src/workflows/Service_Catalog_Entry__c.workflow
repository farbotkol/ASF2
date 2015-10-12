<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_Email_Alert</fullName>
        <ccEmails>kristopher.hollen@aecom.com</ccEmails>
        <description>Catalog EntryApproval Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>ryan.dsouza@aecom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Capability_Indicator_approval_reminder</template>
    </alerts>
    <alerts>
        <fullName>Catalog_Entry_Approval_Submission</fullName>
        <description>Catalog Entry Approval Submission</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Secondary_SME__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Tertiary_SME__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Approval_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Catalog_Entry_Approved</fullName>
        <description>Catalog Entry Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>TaaS_Catalog_approval</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Catalog_Entry_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>Catalog_Entry_Published_Notification</fullName>
        <description>Catalog Entry Published Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Catalog_Entry_Publish_Notification</template>
    </alerts>
    <alerts>
        <fullName>Catalog_Entry_Rejected</fullName>
        <description>Catalog Entry Rejected</description>
        <protected>false</protected>
        <recipients>
            <recipient>TaaS_Catalog_approval</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Catalog_Entry_Rejection_Notification</template>
    </alerts>
    <alerts>
        <fullName>Catalog_entry_Rejection_Notice_to_TaaS</fullName>
        <description>Catalog entry Rejection Notice to TaaS</description>
        <protected>false</protected>
        <recipients>
            <recipient>TaaS_Catalog_approval</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Catalog_Entry_TaaS_Rejection_Notice</template>
    </alerts>
    <alerts>
        <fullName>Final_Approval_Re_direct_notification_to_TaaS_Team</fullName>
        <description>Final Approval Re-direct notification to TaaS Team</description>
        <protected>false</protected>
        <recipients>
            <recipient>TaaS_Catalog_approval</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Catalog_Entry_Approval_Re_direct</template>
    </alerts>
    <alerts>
        <fullName>New_Catalog_Entry_Approval</fullName>
        <description>New Catalog Entry Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>TaaS_Catalog_approval</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Service_Catalog_Entry_Approval</template>
    </alerts>
    <alerts>
        <fullName>New_Catalog_Entry_approval_needed</fullName>
        <description>New Catalog Entry approval needed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>TaaS_Catalog_approval</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>Secondary_SME__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Tertiary_SME__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Service_Catalog_Entry_Approval</template>
    </alerts>
    <alerts>
        <fullName>New_Catalog_entry_Notification_to_Ryan_Dsouza</fullName>
        <description>New Catalog entry Notification to Ryan Dsouza</description>
        <protected>false</protected>
        <recipients>
            <recipient>kristopher.hollen@aecom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ryan.dsouza@aecom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Catalog_Entry_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assign_to_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Service_Catalog_Entry_Approval</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Catalog_Entry_Is_Rejected</fullName>
        <description>Updates the Status to Revisions needed.</description>
        <field>Status__c</field>
        <literalValue>Revisions Needed</literalValue>
        <name>Catalog Entry Is Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Is_Approved</fullName>
        <field>Is_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update Is Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Is_Rejected</fullName>
        <field>Is_Rejected__c</field>
        <literalValue>1</literalValue>
        <name>Update &quot;Is Rejected&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Field</fullName>
        <description>Updates the status field to show the approval is in progress.</description>
        <field>Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Update Status Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Field_approved</fullName>
        <description>Update status to show the record was approved.</description>
        <field>Status__c</field>
        <literalValue>Published</literalValue>
        <name>Update Status Field- approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Field_rejected</fullName>
        <description>Shows the status as rejected if not approved.</description>
        <field>Status__c</field>
        <literalValue>Revisions Needed</literalValue>
        <name>Update Status Field- rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Published</fullName>
        <description>Catalog entry field update status field to Publish.</description>
        <field>Status__c</field>
        <literalValue>Published</literalValue>
        <name>Update Status- Published</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Submission_Date</fullName>
        <field>Approval_Submission_date__c</field>
        <formula>TODAY()</formula>
        <name>Update Submission Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_field_In_Review</fullName>
        <field>Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Update status field- In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Catalog Entry approval reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Service_Catalog_Entry__c.Approval_Submission_date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Service_Catalog_Entry__c.Is_Approved__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Service_Catalog_Entry__c.Is_Rejected__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Approval_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Service_Catalog_Entry__c.Approval_Submission_date__c</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
