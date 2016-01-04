<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>FP_Participant_Change_Notification</fullName>
        <description>Fixed Price Participant Change Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Enrollment_Change_Letter_FP</template>
    </alerts>
    <alerts>
        <fullName>FP_Participant_Notification</fullName>
        <description>Fixed Price Participant Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Enrollment_Letter_FP</template>
    </alerts>
    <alerts>
        <fullName>Notify_Participant_that_Baseline_Has_Changed</fullName>
        <description>Notify Participant that Baseline Has Changed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_Participants_when_Baseline_has_Changed</template>
    </alerts>
    <alerts>
        <fullName>Participant_declines_participation_in_plan</fullName>
        <description>1Participant declines participation in plan</description>
        <protected>false</protected>
        <recipients>
            <field>Approver1Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>ProjectManagerEmail__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Participant_Declines_Participation_In_Plan</template>
    </alerts>
    <alerts>
        <fullName>TM_Participant_Change_Notification</fullName>
        <description>Time and Materials Participant Change Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Enrollment_Change_Letter_TM</template>
    </alerts>
    <alerts>
        <fullName>TM_Participant_Notification</fullName>
        <description>Time and Materials Participant Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Enrollment_Letter_TM</template>
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
        <fullName>DTW_Clear_Decline_Reason</fullName>
        <field>Declined_Reason__c</field>
        <name>DTW Clear Decline Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTW_Clear_Decline_Reason_Other</fullName>
        <field>DeclinedReasonOther__c</field>
        <name>DTW Clear Decline Reason Other</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTW_Set_Received_R_T</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Received</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>DTW Set Received R/T</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTW_Set_Response_Date</fullName>
        <field>ResponseDate__c</field>
        <formula>TODAY()</formula>
        <name>DTW Set Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>INC_Add_Geography_to_Participant_Acknowl</fullName>
        <field>Geography__c</field>
        <formula>ParticipantID__r.EnrollmentPlan__r.IncentiveProject__r.GeographyDescription__c</formula>
        <name>INC_Add Geography to Participant Acknowl</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Acknowledgement_Status_Accepted</fullName>
        <field>Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>Set Acknowledgement Status = Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Acknowledgement_Status_Declined</fullName>
        <field>Status__c</field>
        <literalValue>Declined</literalValue>
        <name>Set Acknowledgement Status = Declined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_PA_Message_with_Last_Edited</fullName>
        <description>Stamps the date the record was last edited when a PA record is modified.
Message__c</description>
        <field>Message__c</field>
        <formula>&quot;Your response was saved on: &quot;&amp;Text(Today())</formula>
        <name>Set PA Message with Last Edited</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>1Participant Declines</fullName>
        <actions>
            <name>Participant_declines_participation_in_plan</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>DTW_Set_Received_R_T</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DTW_Set_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.Acknowledged__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.Declined_Reason__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Send Notification when Participant Declines</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Capture Particpant Acknowledgment Metrics</fullName>
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
            <field>ParticipantAcknowledgement__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Copy the cross object formula fields to snapshot fields to ensure that participants can view data</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>DTW - Update PA Comments Field</fullName>
        <actions>
            <name>Set_PA_Message_with_Last_Edited</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the PA Comments field when a PA record has changed.</description>
        <formula>and(not(isnew()),
ischanged(Acknowledged__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Declines sets PA Status</fullName>
        <actions>
            <name>Set_Acknowledgement_Status_Declined</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.Acknowledged__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <description>When the participant declines acknowledgement (&quot;No&quot;), set the status to Declined</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FP Participant Change Notification</fullName>
        <actions>
            <name>FP_Participant_Change_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.PlanType__c</field>
            <operation>equals</operation>
            <value>Fixed Price</value>
        </criteriaItems>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.NotificationFlag__c</field>
            <operation>equals</operation>
            <value>Change</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>FP Participant Notification</fullName>
        <actions>
            <name>FP_Participant_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.PlanType__c</field>
            <operation>equals</operation>
            <value>Fixed Price</value>
        </criteriaItems>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.NotificationFlag__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>INC_Add Geography to Participant Acknowledgement</fullName>
        <actions>
            <name>INC_Add_Geography_to_Participant_Acknowl</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Geography__c &lt;&gt;  ParticipantID__r.EnrollmentPlan__r.IncentiveProject__r.GeographyDescription__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Participant that Baseline Has Changed</fullName>
        <actions>
            <name>Notify_Participant_that_Baseline_Has_Changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email to Participant on CCR if Project Baseline has changed, the Participant is not new, and Participant&apos;s target has not changed.</description>
        <formula>and(
ischanged(ParticipantID__c),

ParticipantID__r.EnrollmentPlan__r.Target_Changed_Notify_Parts__c,

ispickval(NotificationFlag__c,&quot;None&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Participant Accepts</fullName>
        <actions>
            <name>DTW_Clear_Decline_Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DTW_Clear_Decline_Reason_Other</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DTW_Set_Received_R_T</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DTW_Set_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Acknowledgement_Status_Accepted</name>
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
        <fullName>TM Participant Change Notification</fullName>
        <actions>
            <name>TM_Participant_Change_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.PlanType__c</field>
            <operation>equals</operation>
            <value>Time &amp; Material</value>
        </criteriaItems>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.NotificationFlag__c</field>
            <operation>equals</operation>
            <value>Change</value>
        </criteriaItems>
        <description>Sends notification to the Enrollment Participant owner when the Enrollment Participant has been created by the trigger.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TM Participant Notification</fullName>
        <actions>
            <name>TM_Participant_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.PlanType__c</field>
            <operation>equals</operation>
            <value>Time &amp; Material</value>
        </criteriaItems>
        <criteriaItems>
            <field>ParticipantAcknowledgement__c.NotificationFlag__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Sends notification to the Enrollment Participant owner when the Enrollment Participant has been created by the trigger.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
