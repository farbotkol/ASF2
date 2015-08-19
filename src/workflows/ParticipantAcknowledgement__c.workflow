<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification_of_Participant_Declining_Participation</fullName>
        <description>Notification of Participant Declining Participation</description>
        <protected>false</protected>
        <recipients>
            <field>Approver1Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>CORP_DTW_Admin</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_Participant_Declining_Participation</template>
    </alerts>
    <alerts>
        <fullName>Participant_Notification_on_Participant_Enrollment_Create</fullName>
        <description>Participant Notification on Participant Enrollment Create</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Participant_Acknowledgement</template>
    </alerts>
    <fieldUpdates>
        <fullName>Capture_Approver1_Email_Address</fullName>
        <field>Approver1Email__c</field>
        <formula>Approver1__c</formula>
        <name>Capture Approver1 Email Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_End_Date_on_Project</fullName>
        <field>ParticipantProjectEndDateSnapshot__c</field>
        <formula>ParticipantID__r.EndDateonProject__c</formula>
        <name>Capture End Date on Project</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Enrollment_App_Name</fullName>
        <field>EnrollmentAppNameatSnapshot__c</field>
        <formula>EnrollmentAppName__c</formula>
        <name>Capture Enrollment App Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Participant_Estimated_Payout</fullName>
        <description>Capture Participant Estimated Payout Formula to Potential Payout</description>
        <field>PotentialPayoutatSnapshot__c</field>
        <formula>PotentialPayout__c</formula>
        <name>Capture Participant Estimated Payout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Project_End_Date</fullName>
        <description>Capture Project End Date Formula to Project End Date</description>
        <field>ProjectEndDateatSnapshot__c</field>
        <formula>ProjectEndDate__c</formula>
        <name>Capture Project End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Project_Manager_E_Mail_Address</fullName>
        <field>ProjectManagerEmail__c</field>
        <formula>ProjectManager__c</formula>
        <name>Capture Project Manager E-Mail Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Project_Name</fullName>
        <field>ProjectNameSnapshot__c</field>
        <formula>ProjectName__c</formula>
        <name>Capture Project Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Project_Start_Date</fullName>
        <description>Copy Project Start Date Formula to Project Start Date</description>
        <field>ProjectStartDateatSnapshot__c</field>
        <formula>ProjectStartDate__c</formula>
        <name>Capture Project Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Start_Date_On_Project</fullName>
        <field>ParticipantProjectStartDateSnapshot__c</field>
        <formula>ParticipantID__r.StartDateonProject__c</formula>
        <name>Capture Start Date On Project</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Target</fullName>
        <description>Capture the Participant Target % formula to Target %</description>
        <field>TargetAtSnapshot__c</field>
        <formula>Target__c</formula>
        <name>Capture Target %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTW_Set_Acknowledgement_Date</fullName>
        <field>AcknowledgmentDate__c</field>
        <formula>TODAY()</formula>
        <name>DTW Set Acknowledgement Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTW_Set_Acknowledgement_R_T</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Received</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>DTW Set Acknowledgement R/T</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTW_Set_Acknowledgement_Status</fullName>
        <field>Status__c</field>
        <literalValue>Acknowledged</literalValue>
        <name>DTW Set Acknowledgement Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Capture Participant Enrollment Metrics and Send Notification</fullName>
        <actions>
            <name>Participant_Notification_on_Participant_Enrollment_Create</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Capture_Approver1_Email_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_End_Date_on_Project</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Enrollment_App_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Participant_Estimated_Payout</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Project_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Project_Manager_E_Mail_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Project_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Project_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Start_Date_On_Project</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Target</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Copy the cross object formula fields to snapshot fields to ensure that participants can view data and send participant notification to Owner and Manager</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Participant Acknowledges</fullName>
        <actions>
            <name>DTW_Set_Acknowledgement_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DTW_Set_Acknowledgement_R_T</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DTW_Set_Acknowledgement_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.Acknowledged__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification when Participant Declines</fullName>
        <actions>
            <name>Notification_of_Participant_Declining_Participation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
