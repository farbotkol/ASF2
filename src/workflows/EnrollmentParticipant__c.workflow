<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_PM_and_approver_1_of_change_in_proposed_participant_allocation</fullName>
        <description>5Notify PM (and approver 1) of change in proposed participant allocation</description>
        <protected>false</protected>
        <recipients>
            <field>Approver1EMail__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_and_approver_1_of_change_in_proposed_participant_allocation</template>
    </alerts>
    <alerts>
        <fullName>Notify_Participant_of_change_in_baseline</fullName>
        <description>19Notify Participant of change in baseline</description>
        <protected>false</protected>
        <recipients>
            <field>EmployeeName__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_Participant_of_change_in_baseline</template>
    </alerts>
    <alerts>
        <fullName>Notify_Participant_that_an_enrolled_project_has_closed_and_no_award_earned</fullName>
        <description>15Notify Participant that an enrolled project has closed and no award earned</description>
        <protected>false</protected>
        <recipients>
            <field>UserEMailStored__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_Participant_that_an_enrolled_project_has_closed_and_no_award_earned</template>
    </alerts>
    <alerts>
        <fullName>Notify_Participant_that_his_her_incentive_target_has_changed</fullName>
        <description>17Notify Participant that his/her incentive target has changed</description>
        <protected>false</protected>
        <recipients>
            <field>UserEMailStored__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_Participant_that_his_her_incentive_target_has_changed</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_of_Enrollment_to_Participants_Fixed_Price</fullName>
        <description>xxxxSend Notification of Enrollment to Participants-Fixed Price</description>
        <protected>false</protected>
        <recipients>
            <field>EmployeeName__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Fixed_Price_Participant_Enrollment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_of_Enrollment_to_Participants_TM</fullName>
        <description>xxxxSend Notification of Enrollment to Participants-Time and Materials</description>
        <protected>false</protected>
        <recipients>
            <field>EmployeeName__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Time_and_Materials_Particpant_Enrollment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_EA_Participants_when_EA_status_is_Unenrolled</fullName>
        <description>Send Notification to EA Participants when EA status is Unenrolled</description>
        <protected>false</protected>
        <recipients>
            <field>EmployeeName__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_EA_Participants_of_Unenrollment</template>
    </alerts>
    <fieldUpdates>
        <fullName>Calculate_Payment_Amount</fullName>
        <description>(Multiply the Participant Target % * FinalIncentivePoolAdjusted__c)</description>
        <field>PaymentAmount__c</field>
        <formula>BLANKVALUE(CalculatedIncentive__c,0) + BLANKVALUE(PaymentAdjustments__c,0)</formula>
        <name>Calculate Payment Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approver1_Email_Address</fullName>
        <field>Approver1EMail__c</field>
        <formula>EnrollmentPlan__r.Approver1__r.Email</formula>
        <name>Capture Approver1 Email Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Participant_SF_User_Email_Addres</fullName>
        <field>UserEMailStored__c</field>
        <formula>UserEmail__c</formula>
        <name>Capture Participant SF User Email Addres</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChangeParticipantAllocationSent_c_No</fullName>
        <description>ChangeParticipantAllocationSent__c=No</description>
        <field>ChangeParticipantAllocationSent__c</field>
        <literalValue>No</literalValue>
        <name>ChangeParticipantAllocationSent__c=No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>EnrollmentPlan__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChangeParticipantAllocationSent_c_Yes</fullName>
        <description>ChangeParticipantAllocationSent__c=Yes</description>
        <field>ChangeParticipantAllocationSent__c</field>
        <literalValue>Yes</literalValue>
        <name>ChangeParticipantAllocationSent__c=Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>EnrollmentPlan__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_Flag</fullName>
        <field>StatusFlag__c</field>
        <formula>EmployeeStatusNo__c</formula>
        <name>Set Status Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X15_Set_Close_No_Reward_Flag</fullName>
        <description>Sets Close_No_Award field to false.</description>
        <field>Closed_No_Award__c</field>
        <literalValue>0</literalValue>
        <name>15)Set Close No Reward Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X19_Set</fullName>
        <description>Updates Baseline Margin Change field to false.</description>
        <field>Baseline_Margin_Change__c</field>
        <literalValue>0</literalValue>
        <name>19)Update Baseline Margin Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>15Notify Participant that an enrolled project has closed and no award earned</fullName>
        <actions>
            <name>Notify_Participant_that_an_enrolled_project_has_closed_and_no_award_earned</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>X15_Set_Close_No_Reward_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentParticipant__c.Closed_No_Award__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentParticipant__c.TargetIncentivePoolAllocated__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>15Notify Participant that an enrolled project has closed and no award earned</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>17Notify Participant that his%2Fher incentive target has changed</fullName>
        <actions>
            <name>Notify_Participant_that_his_her_incentive_target_has_changed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notify Participant that his/her incentive target has changed</description>
        <formula>AND (
     ISCHANGED( TargetIncentivePoolAllocated__c ),
     TargetIncentivePoolAllocated__c &lt;&gt; 0.00,
     EmployeeName__r.pse__Salesforce_User__r.IsActive    
     )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>19%29Notify Participant of change in baseline</fullName>
        <actions>
            <name>Notify_Participant_of_change_in_baseline</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>X19_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>EnrollmentParticipant__c.Baseline_Margin_Change__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Enrolled</value>
        </criteriaItems>
        <description>DELETE</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>5Notify PM %28and approver 1%29 of change in proposed participant allocation</fullName>
        <actions>
            <name>Notify_PM_and_approver_1_of_change_in_proposed_participant_allocation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ChangeParticipantAllocationSent_c_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Notify PM (and approver 1) of change in proposed participant allocation</description>
        <formula>AND (
     ISPICKVAL(EnrollmentPlan__r.IsInWorkflow__c ,&quot;Yes&quot;),  
     ISCHANGED(TargetIncentivePoolAllocated__c ),
     ISPICKVAL(EnrollmentPlan__r.ConfirmBaseline__c ,&quot;Yes&quot;),
     ISPICKVAL( EnrollmentPlan__r.ChangeParticipantAllocationSent__c ,&quot;No&quot;)  
    )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate and Save Payment Amount</fullName>
        <actions>
            <name>Calculate_Payment_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Capture Enrollment Participant Metrics</fullName>
        <actions>
            <name>Capture_Approver1_Email_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Participant_SF_User_Email_Addres</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentParticipant__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>On Create, capture necessary enrollment participant information</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EA Status is changed to %22On Hold%22</fullName>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentParticipant__c.EAStatusUpdate__c</field>
            <operation>equals</operation>
            <value>On Hold</value>
        </criteriaItems>
        <description>Used by the Process Builder to trigger an alert to send to the Enrollment Participants when the Enrollment Application Status changed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EA Status is changed to %22Unenrolled%22</fullName>
        <actions>
            <name>Send_Notification_to_EA_Participants_when_EA_status_is_Unenrolled</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentParticipant__c.EAStatusUpdate__c</field>
            <operation>equals</operation>
            <value>Unenrolled</value>
        </criteriaItems>
        <description>Used by the Process Builder to trigger an alert to send to the Enrollment Participants when the Enrollment Application Status changed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enrollment Notification for Fixed Price Incentive Projects</fullName>
        <actions>
            <name>Send_Notification_of_Enrollment_to_Participants_Fixed_Price</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.PlanType__c</field>
            <operation>equals</operation>
            <value>Fixed Price</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Enrolled</value>
        </criteriaItems>
        <description>Send notification to Enrollment Participant for Fixed Price Incentive Projects</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enrollment Notification for Time and Materials Incentive Projects</fullName>
        <actions>
            <name>Send_Notification_of_Enrollment_to_Participants_TM</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.PlanType__c</field>
            <operation>equals</operation>
            <value>Time &amp; Material</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Enrolled</value>
        </criteriaItems>
        <description>Send notification to Enrollment Participant for Time and Materials Incentive Projects</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Payment Amount Calc</fullName>
        <active>true</active>
        <formula>1+1 =2</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Participant Status Flag</fullName>
        <actions>
            <name>Set_Status_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( EmployeeStatusNo__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
