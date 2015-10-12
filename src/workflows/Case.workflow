<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SS_AP_Case_Resolved</fullName>
        <description>SS-AP Case Resolved</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Shared_Services_AP_Resolution_Emails/SS_AP_Case_Resolved_EN</template>
    </alerts>
    <alerts>
        <fullName>SS_AP_Case_Resolved_EN</fullName>
        <description>SS-AP Case Resolved EN</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>aphelpdesk.out@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Shared_Services_AP_Resolution_Emails/SS_AP_Case_Resolved_EN</template>
    </alerts>
    <alerts>
        <fullName>SS_AP_Case_Resolved_FR</fullName>
        <description>SS-AP Case Resolved FR</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>canssc.aphelpdesk.out@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Shared_Services_AP_Resolution_Emails/SS_AP_Case_Resolved_FR</template>
    </alerts>
    <alerts>
        <fullName>SS_AP_Case_Resolved_New_Email_EN</fullName>
        <description>SS-AP Case Closed New Email EN</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Shared_Services_AP_Response_Emails/SS_AP_Closed_Case_New_Email_Received</template>
    </alerts>
    <alerts>
        <fullName>SS_AP_Case_Resolved_New_Email_FR</fullName>
        <description>SS-AP Case Closed New Email FR</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Shared_Services_AP_Response_Emails/SS_AP_Closed_Case_New_Email_Received_FR</template>
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
        <fullName>SS_AP_SET_Language_Type_EN</fullName>
        <description>The language type will be updated to EN</description>
        <field>Language_Type__c</field>
        <literalValue>EN</literalValue>
        <name>SS AP SET Language Type EN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SS_AP_SET_Language_Type_FR</fullName>
        <description>The language type will be updated to FR</description>
        <field>Language_Type__c</field>
        <literalValue>FR</literalValue>
        <name>SS AP SET Language Type FR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
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
        <booleanFilter>1 AND 2 AND (3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11 OR 12 OR 13 OR 14 OR 15 OR 16 OR 17 OR 18 OR 19 OR 20 OR 21 OR 22 OR 23)</booleanFilter>
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
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>document de support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>document de support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>sauvegardé</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>sauvegardé</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>copie de la facture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>copie de la facture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>copies des factures</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>copies des factures</value>
        </criteriaItems>
        <description>Shared Services AP -  Set the Backup Request Flag</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SS-AP Case Reopened EN</fullName>
        <actions>
            <name>SS_AP_Case_Resolved_New_Email_EN</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Reopened</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Language_Type__c</field>
            <operation>equals</operation>
            <value>EN</value>
        </criteriaItems>
        <description>Shared Services AP - Rule to send an email alert in English when a closed case becomes reopened</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SS-AP Case Reopened FR</fullName>
        <actions>
            <name>SS_AP_Case_Resolved_New_Email_FR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Reopened</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Language_Type__c</field>
            <operation>equals</operation>
            <value>FR</value>
        </criteriaItems>
        <description>Shared Services AP - Rule to send an email alert in French when a closed case becomes reopened</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SS-AP Case Resolved EN</fullName>
        <actions>
            <name>SS_AP_Case_Resolved_EN</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
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
            <field>Case.Language_Type__c</field>
            <operation>equals</operation>
            <value>EN</value>
        </criteriaItems>
        <description>Shared Services AP - Rule to send an email alert in English when a case is closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SS-AP Case Resolved FR</fullName>
        <actions>
            <name>SS_AP_Case_Resolved_FR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
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
            <field>Case.Language_Type__c</field>
            <operation>equals</operation>
            <value>FR</value>
        </criteriaItems>
        <description>Shared Services AP - Rule to send an email alert in French when a case is closed.</description>
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
        <booleanFilter>1 AND 2 AND (3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11 OR 12 OR 13 OR 14 OR 15 OR 16 OR 17 OR 18 OR 19 OR 20 OR 21)</booleanFilter>
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
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>manuel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>manuel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>remboursement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>remboursement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>frais</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>frais</value>
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
            <field>Case.SS_Case_Category__c</field>
            <operation>equals</operation>
            <value>Invoice</value>
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
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>la facture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>la facture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>dû</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>virement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>interrompu</value>
        </criteriaItems>
        <description>Shared Services AP -  Set Invoice Request Flag</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SS-AP Language Type EN</fullName>
        <actions>
            <name>SS_AP_SET_Language_Type_EN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9 AND 10 AND 11 AND 12 AND 13 AND 14 AND 15 AND 16 AND 17 AND 18 AND 19 AND 20 AND 21 AND 22 AND 23 AND 24 AND 25</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Shared Services AP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>facture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notContain</operation>
            <value>facture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>paiement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notContain</operation>
            <value>paiement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>règlement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notContain</operation>
            <value>règlement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>impayé</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notContain</operation>
            <value>impayé</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>rappel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notContain</operation>
            <value>rappel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>rapport</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notContain</operation>
            <value>rapport</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>fournisseur</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notContain</operation>
            <value>fournisseur</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>état de compte</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notContain</operation>
            <value>état de compte</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>relevé</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notContain</operation>
            <value>relevé</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>sous-traitant</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notContain</operation>
            <value>sous-traitant</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>payé</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notContain</operation>
            <value>payé</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>compte</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notContain</operation>
            <value>compte</value>
        </criteriaItems>
        <description>Shared Services AP - Rule for setting English as the default language type. This rule DOES NOT contain French keywords.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SS-AP Language Type FR</fullName>
        <actions>
            <name>SS_AP_SET_Language_Type_FR</name>
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
            <value>facture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>facture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>paiement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>paiement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>règlement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>règlement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>impayé</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>impayé</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>rappel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>rappel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>rapport</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>rapport</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>fournisseur</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>fournisseur</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>état de compte</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>état de compte</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>relevé</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>relevé</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>sous-traitant</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>sous-traitant</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>payé</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>payé</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>compte</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>compte</value>
        </criteriaItems>
        <description>Shared Services AP - Rule for setting French as the default language type.</description>
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
        <booleanFilter>1 AND 2 AND (3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11 OR 12)</booleanFilter>
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
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>un traitement particulier</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>un traitement particulier</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>demande de chèque</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>demande de chèque</value>
        </criteriaItems>
        <description>Shared Services AP - Rule for Special Handling cases</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
