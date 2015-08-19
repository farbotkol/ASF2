<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Notification_of_Enrollment_to_Participants_Fixed_Price</fullName>
        <description>Send Notification of Enrollment to Participants-Fixed Price</description>
        <protected>false</protected>
        <recipients>
            <field>EmployeeName__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Participant_Notification_FP</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_of_Enrollment_to_Participants_TM</fullName>
        <description>Send Notification of Enrollment to Participants-Time and Materials</description>
        <protected>false</protected>
        <recipients>
            <field>EmployeeName__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Participant_Notification_TM</template>
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
    <alerts>
        <fullName>Send_Notification_to_EA_Participants_when_status_is_set_to_On_Hold</fullName>
        <description>Send Notification to EA Participants when status is On Hold</description>
        <protected>false</protected>
        <recipients>
            <field>EmployeeName__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_EA_Participants_of_On_Hold_Status</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_PM_when_EA_Participants_Employee_status_has_changed</fullName>
        <description>Send Notification to PM when EA Participants Employee status has changed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_EA_Participant_Employee_Status_Change</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_PM_when_Participant_Allocation_has_changed</fullName>
        <description>Send Notification to PM when Participant Allocation has changed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_Participant_Allocation_is_Changed</template>
    </alerts>
    <fieldUpdates>
        <fullName>Calculate_Payment_Amount</fullName>
        <description>Multiply the Participant Target % * FinalIncentivePoolAdjusted__c</description>
        <field>PaymentAmount__c</field>
        <formula>TargetIncentivePoolAllocated__c  *  EnrollmentPlan__r.FinalIncentivePoolAdjusted__c</formula>
        <name>Calculate Payment Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
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
    <rules>
        <fullName>Calculate and Save Payment Amount</fullName>
        <actions>
            <name>Calculate_Payment_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentParticipant__c.RecordTypeId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EA Status is changed to %22On Hold%22</fullName>
        <actions>
            <name>Send_Notification_to_EA_Participants_when_status_is_set_to_On_Hold</name>
            <type>Alert</type>
        </actions>
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
        <fullName>Employee Status has Changed</fullName>
        <actions>
            <name>Send_Notification_to_PM_when_EA_Participants_Employee_status_has_changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED (EmployeeStatus__c)</formula>
        <triggerType>onAllChanges</triggerType>
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
        <description>Send notification to Enrollment Participant for Fixed Price Incentive Projects</description>
        <triggerType>onCreateOnly</triggerType>
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
        <description>Send notification to Enrollment Participant for Time and Materials Incentive Projects</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Participant Allocation Change</fullName>
        <actions>
            <name>Send_Notification_to_PM_when_Participant_Allocation_has_changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send e-mail alert when the participant allocation has changed</description>
        <formula>ISCHANGED( TargetIncentivePoolAllocated__c )</formula>
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
