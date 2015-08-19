<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Notification_of_Previously_Ineligible_IP_become_Eligible_to_DTW_Admin</fullName>
        <description>Send Notification of Previously Ineligible IP become Eligible to DTW Admin</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_Ineligible_become_Eligible</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_DTW_Admin_of_new_ELIGIBLE_Incentive_Project</fullName>
        <description>Send Notification to DTW Admin of new ELIGIBLE Incentive Project</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_of_Newly_Created_Eligible_Project</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_Enrollment_Plan_PM_when_GM_EAC_Date_has_changed</fullName>
        <description>Send Notification to the Enrollment Plan&apos;s PM and Approver 1 when GM% and or EAC as of Date has changed</description>
        <protected>false</protected>
        <recipients>
            <field>EnrollmentApprover1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ProjectManager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_of_GM_or_EAC_Values_Change</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_PM_and_Approver1_for_Incentive_Project_Approved_DPE_NSR_and</fullName>
        <description>Send Notification to PM and Approver1 for Incentive Project Approved DPE, NSR and GM Budget Changes</description>
        <protected>false</protected>
        <recipients>
            <field>EnrollmentApprover1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ProjectManager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_IP_Baseline_Budgets_Surpass_Threshold</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_the_Assigned_PM_of_newly_created_Incentive_Project</fullName>
        <description>Send Notification to the Assigned PM of newly created Incentive Project</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>aherman@aecom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_PM_of_Eligible_Project_Assignment</template>
    </alerts>
    <alerts>
        <fullName>Send_notification_to_DTW_Admin_of_new_Ineligible_Incentive_Project</fullName>
        <description>Send notification to DTW Admin of new INELIGIBLE Incentive Project</description>
        <protected>false</protected>
        <recipients>
            <field>DTWAdmin__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_of_Newly_Created_In_Eligible_Project</template>
    </alerts>
    <alerts>
        <fullName>Send_notification_to_PM_when_IP_Scheduled_End_Date_is_30_Days</fullName>
        <description>Send notification to PM when IP Scheduled End Date is 30 Days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/X30_Day_Notification_from_IP_Scheduled_Finish_Date</template>
    </alerts>
    <alerts>
        <fullName>Send_notification_to_PM_when_IP_Scheduled_End_Date_is_60_Days</fullName>
        <description>Send notification to PM when IP Scheduled End Date is 60 Days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/X60_Day_Notification_from_IP_Scheduled_Finish_Date</template>
    </alerts>
    <fieldUpdates>
        <fullName>Capture_IP_Name_to_Text_Field</fullName>
        <field>ProjectNameText__c</field>
        <formula>Name</formula>
        <name>Capture Project Name to Text Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reassign_Ownership_to_Midwest_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Midwest_DTW_Admin</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Reassign Ownership to Midwest Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_GMEACChange_to_YES</fullName>
        <field>GMEACChange__c</field>
        <literalValue>Yes</literalValue>
        <name>Set GMEACChange to YES</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>30 Day Scheduled Finish Date Alert</fullName>
        <actions>
            <name>Send_notification_to_PM_when_IP_Scheduled_End_Date_is_30_Days</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send an alert to the Program Manager 30 days before the Incentive Project&apos;s scheduled finish date.</description>
        <formula>TODAY() - ScheduledFinishDate__c = -30</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>60 Day Scheduled Finish Date Alert</fullName>
        <actions>
            <name>Send_notification_to_PM_when_IP_Scheduled_End_Date_is_60_Days</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send an alert to the Program Manager 60 days before the Incentive project&apos;s scheduled finish date.</description>
        <formula>TODAY() - ScheduledFinishDate__c = -60</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Approved DPE NSR or GM Budget Change Exceeds Plan Threshold</fullName>
        <actions>
            <name>Send_Notification_to_PM_and_Approver1_for_Incentive_Project_Approved_DPE_NSR_and</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Add WFR Alert to notify PM and Approver 1 if Baseline changes by assigned Incentive Plan threshold.
If the Incentive Project Budget (BaseLine) changes by more than the default value of 3%, send the WFR.</description>
        <formula>OR(

(ApprovedDPEBudget__c-
PRIORVALUE( ApprovedDPEBudget__c ))/
PRIORVALUE( ApprovedDPEBudget__c )&gt;
EnrollmentPlan__r.IncentivePlan__r.DefaultBaselineThreshold__c,

(ApprovedNSRBudget__c-
PRIORVALUE(ApprovedNSRBudget__c   ))/
PRIORVALUE(ApprovedNSRBudget__c  )&gt;
EnrollmentPlan__r.IncentivePlan__r.DefaultBaselineThreshold__c, 

(ApprovedGrossMarginBudget__c -
PRIORVALUE(ApprovedGrossMarginBudget__c   ))/
PRIORVALUE(ApprovedGrossMarginBudget__c  )&gt;
EnrollmentPlan__r.IncentivePlan__r.DefaultBaselineThreshold__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Assign to Midwest Queue</fullName>
        <actions>
            <name>Reassign_Ownership_to_Midwest_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IncentiveProject__c.GeographyDescription__c</field>
            <operation>equals</operation>
            <value>Midwest</value>
        </criteriaItems>
        <criteriaItems>
            <field>IncentiveProject__c.RegionDescription__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>IncentiveProject__c.DistrictDescription__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>IncentiveProject__c.BusinessLineDescription__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If the only value for Geography=&quot;Midwest&quot;, assign to Midwest Queue as Owner</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>InEligible becomes Eligible</fullName>
        <actions>
            <name>Send_Notification_of_Previously_Ineligible_IP_become_Eligible_to_DTW_Admin</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Alert sent to the DTW Admin, when a previously ineligible Incentive Plan has now become eligible.</description>
        <formula>OR
(
AND
(
ISPICKVAL(FPPOverallEligibility__c , &apos;Yes&apos;),
ISPICKVAL(PRIORVALUE(FPPOverallEligibility__c),&apos;No&apos;)
),
AND
(
ISPICKVAL(TMPlanOverallEligibility__c  , &apos;Yes&apos;),
ISPICKVAL(PRIORVALUE(TMPlanOverallEligibility__c),&apos;No&apos;)
)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify DTW Admin of New INELIGIBLE Projects</fullName>
        <actions>
            <name>Send_notification_to_DTW_Admin_of_new_Ineligible_Incentive_Project</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>IncentiveProject__c.TMPlanOverallEligibility__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>IncentiveProject__c.FPPOverallEligibility__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <description>Notify the appropriate DTW Admin of newly created INELIGIBLE Incentive Projects</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify DTW Admin of New Incentive Projects</fullName>
        <actions>
            <name>Send_Notification_to_DTW_Admin_of_new_ELIGIBLE_Incentive_Project</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IncentiveProject__c.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>IncentiveProject__c.CountEnrollmentPlan__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>IncentiveProject__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Pending DTW Action</value>
        </criteriaItems>
        <description>Notify the appropriate DTW Admin of newly created incentive projects</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify assigned Project Manager of New Incentive Projects</fullName>
        <actions>
            <name>Send_Notification_to_the_Assigned_PM_of_newly_created_Incentive_Project</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IncentiveProject__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Pending PM Action</value>
        </criteriaItems>
        <criteriaItems>
            <field>IncentiveProject__c.CountEnrollmentPlan__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Notify the assigned Project Manager of newly created incentive projects</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify on change of GM%25 and or EAC</fullName>
        <actions>
            <name>Send_Notification_to_Enrollment_Plan_PM_when_GM_EAC_Date_has_changed</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_GMEACChange_to_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Alerts the EA PM and Approver 1 if the Incentive Project&apos;s GM% or EAC as of Date has changed after an EA is in the approval process, but before it has been enrolled.</description>
        <formula>AND
  (
   OR
     (
      ISCHANGED(EACasofDate__c),
      ISCHANGED( ApprovedGrossMarginBudget__c )
      ),
    CountEnrollmentPlan__c &gt; 0,
    TEXT(EnrollmentPlan__r.IsInWorkflow__c)=&quot;Yes&quot;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Incentive Project Name Text Field</fullName>
        <actions>
            <name>Capture_IP_Name_to_Text_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IncentiveProject__c.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates the Incentive Project Text field, which is set to be unique, in order to ensure there are no duplicate Incentive Project Names</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
