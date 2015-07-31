<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Request_for_Contact</fullName>
        <description>Request for Contact</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Request_for_Contact_Close_Loop</template>
    </alerts>
    <alerts>
        <fullName>SS_AP_Case_Resolved</fullName>
        <description>SS-AP Case Resolved</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Shared_Services_AP_Resolution_Emails/SS_AP_Case_Resolved</template>
    </alerts>
    <alerts>
        <fullName>SS_AP_Special_Handling_Agent_Notification</fullName>
        <description>SS-AP Special Handling Agent Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SS_Accounts_Payable_Escalation</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Shared_Services_AP_Escalation_Emails/SS_AP_Special_Handling_Agent_Notification</template>
    </alerts>
    <alerts>
        <fullName>SS_AP_Special_Handling_Case_Submitted</fullName>
        <ccEmails>kjohnson@ethos.com</ccEmails>
        <description>SS-AP Special Handling Case Submitted</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Shared_Services_AP_Escalation_Emails/SS_AP_Special_Handling_Agent_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>SS_AP_Set_Backup_Request</fullName>
        <description>Set the is Backup Request flag</description>
        <field>SS_Is_Backup_Request__c</field>
        <literalValue>1</literalValue>
        <name>SS-AP Set Backup Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SS_AP_Set_Expense_Report</fullName>
        <description>Set the Expense Report flag</description>
        <field>SS_Is_Expense_Report__c</field>
        <literalValue>1</literalValue>
        <name>SS-AP Set Expense Report</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SS_AP_Set_Invoice_Request</fullName>
        <description>Set the is Invoice Request flag</description>
        <field>SS_Is_Invoice_Request__c</field>
        <literalValue>1</literalValue>
        <name>SS-AP Set Invoice Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SS_AP_Set_Priority_High</fullName>
        <description>Set the Priority to High</description>
        <field>Priority</field>
        <literalValue>High</literalValue>
        <name>SS-AP Set Priority High</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SS_AP_Set_Priority_Lower</fullName>
        <description>Lower the Priority Level</description>
        <field>Priority</field>
        <literalValue>Low</literalValue>
        <name>SS-AP Set Priority Lower</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>NextValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SS_AP_Set_Priority_Medium</fullName>
        <description>Set the Priority to Medium</description>
        <field>Priority</field>
        <literalValue>Medium</literalValue>
        <name>SS-AP Set Priority Medium</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SS_AP_Set_Priority_Special_Handling</fullName>
        <field>Priority</field>
        <literalValue>High</literalValue>
        <name>SS-AP Set Priority Special  DEL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SS_AP_Set_Special_Handling</fullName>
        <description>Set the Special Handling flag</description>
        <field>SS_Is_Special_Handling__c</field>
        <literalValue>1</literalValue>
        <name>SS-AP Set Special Handling</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Subject_with_Description</fullName>
        <description>Update the Subject field with the first100 characters of the Description field.</description>
        <field>Subject</field>
        <formula>LEFT( Description , 100)</formula>
        <name>Update Subject with Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SS-AP Backup Request</fullName>
        <actions>
            <name>SS_AP_Set_Backup_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SS_AP_Set_Priority_High</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11 OR 12 OR 13 OR 14 OR 15)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Shared Services AP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Is_Employee__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>backup</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>backup</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>back-up</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>back-up</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>back up</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>back up</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>invoice copy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>invoice copy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>invoice copies</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>invoice copies</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>backed up</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>backed up</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Case_Category__c</field>
            <operation>equals</operation>
            <value>Backup Request</value>
        </criteriaItems>
        <description>Shared Services AP -  Set the Backup Request Flag</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SS-AP Case Closed</fullName>
        <actions>
            <name>SS_AP_Case_Resolved</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Shared Services AP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Is_Backup_Request__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Is_Expense_Report__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Is_Invoice_Request__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Is_Special_Handling__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Shared Services AP - Notify when a general issue is Closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SS-AP Executive Escallation</fullName>
        <actions>
            <name>SS_AP_Set_Priority_High</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Shared Services AP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Is_Executive__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Shared Services AP - Raise to High if an Executive</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SS-AP Expense Report</fullName>
        <actions>
            <name>SS_AP_Set_Expense_Report</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11 OR 12 OR 13 OR 14 OR 15)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Shared Services AP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Is_Employee__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>AMEX</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>AMEX</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>expense</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>expense</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>FEMA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>FEMA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>American Express</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>American Express</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>manual</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>manual</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>reimbursement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>reimbursement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Case_Category__c</field>
            <operation>equals</operation>
            <value>Expense Report</value>
        </criteriaItems>
        <description>Shared Services AP - Set the Expense Report Flag</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SS-AP High Priority</fullName>
        <actions>
            <name>SS_AP_Set_Priority_High</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>4 AND (1 OR 2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.SS_Is_Executive__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Is_Backup_Request__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Is_Special_Handling__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Shared Services AP</value>
        </criteriaItems>
        <description>Execute for any Categories that need a High priority</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SS-AP Invoice Request</fullName>
        <actions>
            <name>SS_AP_Set_Invoice_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11 OR 12 OR 13 OR 14 OR 15 OR 16 OR 17 OR 18 OR 19 OR 20 OR 21 OR 22 OR 23 OR 24 OR 25)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Shared Services AP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>xxxxxxEXTRA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>xxxxxxEXTRA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>xxxxxxEXTRA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>xxxxxxEXTRA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>disconnect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>disconnect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>1099</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>1099</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>invoice</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>invoice</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>due</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>due</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>compliance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>compliance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>rush</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>rush</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Case_Category__c</field>
            <operation>equals</operation>
            <value>Invoice</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>xxxxxxEXTRA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>suspen</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>suspen</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>vendor maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>vendor maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>wire</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>wire</value>
        </criteriaItems>
        <description>Shared Services AP -  Set Invoice Request Flag</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SS-AP Lower Priority</fullName>
        <actions>
            <name>SS_AP_Set_Priority_Lower</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Shared Services AP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Is_Employee__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Is_Invoice_Request__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Is_Executive__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Is_Backup_Request__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Is_Special_Handling__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.On_Behalf_of_Vendor__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Executes for any categories that will lower the priority. Does not execute if the case is for a backup request, special handling, or if the submitter is an executive as these always have the highest priority.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SS-AP Special Handling</fullName>
        <actions>
            <name>SS_AP_Set_Priority_High</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SS_AP_Set_Special_Handling</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4 OR 5 OR 6 OR 7 OR 8)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Shared Services AP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SS_Is_Employee__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Special Handling</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>Special Handling</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>check request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>check request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>ACH Payment Conversion</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>ACH Payment Conversion</value>
        </criteriaItems>
        <description>Shared Services AP - Rule for Special Handling cases</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
