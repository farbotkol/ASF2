<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Bid_Manager_of_Project_Task_Numbers</fullName>
        <description>Notify Bid Manager of Project/Task Numbers</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>CMC_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>F_A_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Legal_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Forms_Approval_Templates/MEF0205_Project_Task_Number_Has_Been_Assigned</template>
    </alerts>
    <alerts>
        <fullName>Notify_Document_Control_of_new_Project_Task_Numbers_Needed</fullName>
        <ccEmails>pauldes@kpdsys.com</ccEmails>
        <description>Notify Document Control of new Project/Task Numbers Needed</description>
        <protected>false</protected>
        <recipients>
            <field>Notification_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Forms_Approval_Templates/MEF0205_Project_Task_Number_Assignment</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Form_CMC_Email</fullName>
        <description>sets email address for person selected in the CMC field in the Forms object.</description>
        <field>CMC_Email__c</field>
        <formula>IF (ISPICKVAL (CMC__c, &quot;Maggie Walsh&quot;), &quot;maggie.walsh@aecom.com&quot;,
IF (ISPICKVAL (CMC__c, &quot;Lucy Casey&quot;), &quot;lucy.casey@aecom.com&quot;,
IF (ISPICKVAL (CMC__c, &quot;Samantha Rowles&quot;), &quot;samantha.rowles@aecom.com&quot;,

 null)))</formula>
        <name>Set Form: CMC Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Form_F_A_Email</fullName>
        <description>sets email address for person selected in the F&amp;A field in the Forms object.</description>
        <field>F_A_Email__c</field>
        <formula>IF (ISPICKVAL (CMC__c, &quot;Cliff Fernandes&quot;), &quot;Clifford.Fernandes@aecom.com&quot;, 
IF (ISPICKVAL (CMC__c, &quot;Sean Hamer&quot;), &quot;Sean.Hamer@aecom.com&quot;, 
IF (ISPICKVAL (CMC__c, &quot;Sue Higham&quot;), &quot;souad.higham@aecom.com&quot;, 
IF (ISPICKVAL (CMC__c, &quot;James O&apos;connor&quot;), &quot;James.O&apos;connor2@aecom.com&quot;, 
IF (ISPICKVAL (CMC__c, &quot;Rodrigo Zinampan&quot;), &quot;Rodrigo.Zinampan@aecom.com&quot;, 
null)))))</formula>
        <name>Set Form: F&amp;A Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Form_Legal_Email</fullName>
        <description>sets email address for person selected in the Legal field in the Forms object.</description>
        <field>Legal_Email__c</field>
        <formula>IF (ISPICKVAL (CMC__c, &quot;Malcolm Haack&quot;), &quot;malcolm.haack@aecom.com&quot;, 


null)</formula>
        <name>Set Form: Legal Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Form_Record_Status_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set Form Record Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Form_Record_Status_In_Review</fullName>
        <field>Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Set Form Record Status In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Form_Record_Status_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Set Form Record Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Notification_Email_Field</fullName>
        <field>Notification_Email__c</field>
        <formula>TEXT(MEFO205_Notification_Recipient__c)</formula>
        <name>Set Notification Email Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Notify Bid Manager of Project%2FTask Number</fullName>
        <actions>
            <name>Notify_Bid_Manager_of_Project_Task_Numbers</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Forms__c.Project_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Task_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Notification Email for MEFO205</fullName>
        <actions>
            <name>Set_Notification_Email_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Forms__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>MEFO205 PreQualification</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
