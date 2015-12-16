<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approver_employment_status_has_changed</fullName>
        <description>2Approver employment status has changed</description>
        <protected>false</protected>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>DTWAdmin__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Approver_employment_status_has_changed</template>
    </alerts>
    <alerts>
        <fullName>Notification_of_Approaching_IP_Scheduled_Finish_Date</fullName>
        <description>Notification of Approaching IP Scheduled Finish Date</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notification_of_Approaching_IP_Scheduled_Finish_Date</template>
    </alerts>
    <alerts>
        <fullName>Notify_AP1_of_budget_change_significantly_impacting_baseline_FP_plan_only</fullName>
        <description>16Notify AP1 of budget change significantly impacting baseline (FP plan only)</description>
        <protected>false</protected>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_Approver_1_of_budget_change_significantly_impacting_baseline</template>
    </alerts>
    <alerts>
        <fullName>Notify_AP1_that_an_application_rejected_back_for_further_action</fullName>
        <description>xxxx13Notify PM &amp; AP1 that an application rejected back for further action</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_AP1_AP2_that_an_application_rejected_back_for_further_action</template>
    </alerts>
    <alerts>
        <fullName>Notify_AP2_that_an_application_rejected_back_for_further_action</fullName>
        <description>xxxxx13Notify AP2 that an application rejected back for further action</description>
        <protected>false</protected>
        <recipients>
            <field>Approver2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_AP1_AP2_that_an_application_rejected_back_for_further_action</template>
    </alerts>
    <alerts>
        <fullName>Notify_Approver_1_of_application_to_review</fullName>
        <description>Notify Approver 1 of application to review</description>
        <protected>false</protected>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/ENR_CCR_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Approver_1_of_change_in_proposed_baseline</fullName>
        <description>6Notify Approver 1 of change in proposed baseline</description>
        <protected>false</protected>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_Approver_1_of_change_in_proposed_baseline</template>
    </alerts>
    <alerts>
        <fullName>Notify_Approver_2_of_payment_form_to_approve</fullName>
        <description>12Notify Approver 2 of payment form to approve:</description>
        <protected>false</protected>
        <recipients>
            <field>Approver2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_Approver_2_of_payment_form_to_approve</template>
    </alerts>
    <alerts>
        <fullName>Notify_Approver_3_of_application_to_review</fullName>
        <description>9Notify Approver 3 of application to review</description>
        <protected>false</protected>
        <recipients>
            <field>Approver3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/ENR_CCR_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Approver_3_of_request_for_payment_requiring_his_her_approval</fullName>
        <description>20Notify Approver 3 of request for payment requiring his/her approval</description>
        <protected>false</protected>
        <recipients>
            <field>Approver3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_Approver_3_of_request_for_payment_requiring_his_her_approval</template>
    </alerts>
    <alerts>
        <fullName>Notify_PM_AP1_AP2_that_an_Application_has_been_rejected_FINAL</fullName>
        <description>xxxxx14Notify PM, AP1, AP2 that an Application has been rejected (FINAL)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_Approver_1_or_Approver_2_that_an_application_has_been_rejected</template>
    </alerts>
    <alerts>
        <fullName>Notify_PM_Approver1_of_change_in_Approver_2_or_3</fullName>
        <description>4Notify PM/approver 1 of change in approver 2 or 3</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_approver_1_of_change_in_approver_2_or_3</template>
    </alerts>
    <alerts>
        <fullName>Notify_PM_and_Approvers_when_Baseline_GM_Variance_Exceeds_Incentive_Plan_Thresho</fullName>
        <description>Notify PM and Approvers when Baseline GM Variance Exceeds Incentive Plan Threshold</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Project_Budget_Exceed_Incentive_Plan_Alert_Threshold</template>
    </alerts>
    <alerts>
        <fullName>Notify_PM_of_CCR_to_review</fullName>
        <description>Notify PM of CCR to review</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_of_CCRProject_to_review</template>
    </alerts>
    <alerts>
        <fullName>Notify_PM_of_project_to_review</fullName>
        <description>3Notify PM of project to review</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_of_Project_to_review</template>
    </alerts>
    <alerts>
        <fullName>Notify_PM_that_an_application_rejected_back_for_further_action</fullName>
        <description>xxxxx13Notify PM that an application rejected back for further action</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_AP1_AP2_that_an_application_rejected_back_for_further_action</template>
    </alerts>
    <alerts>
        <fullName>Notify_of_Interim_Payment_Request</fullName>
        <description>Notify of Interim Payment Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>CORP_DTW_Admin</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_of_Interim_Payment_Requested</template>
    </alerts>
    <alerts>
        <fullName>Participant_Change_Notify_Approver_1</fullName>
        <description>Participant Change  - Notify Approver 1 &amp; PM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/EA_Notification_that_Participants_have_Changed</template>
    </alerts>
    <alerts>
        <fullName>Participant_Change_Notify_Approver_2</fullName>
        <description>Participant Change  - Notify Approver 1, 2, &amp; PM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/EA_Notification_that_Participants_have_Changed</template>
    </alerts>
    <alerts>
        <fullName>Participant_Change_Notify_Approver_3</fullName>
        <description>Participant Change  - Notify Approver 1,2,3 &amp; PM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/EA_Notification_that_Participants_have_Changed</template>
    </alerts>
    <alerts>
        <fullName>Participant_Change_Notify_PM</fullName>
        <description>Participant Change  - Notify PM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/EA_Notification_that_Participants_have_Changed</template>
    </alerts>
    <alerts>
        <fullName>Prepayment_Alert_to_Approver_1_and_PM</fullName>
        <description>Prepayment Alert to Approver 1</description>
        <protected>false</protected>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Prepayment_Alert_to_PM_and_AP1</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_Approver_1_when_assigned_to_EA</fullName>
        <description>Send Notification to Approver 1 when assigned to EA</description>
        <protected>false</protected>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_Enrollment_Application_Approver_1_Assignment</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_DTW_Admin_when_change_of_Approvers</fullName>
        <description>Send Notification to DTW Admin when change of Approvers</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_Enrollment_Application_Changed_of_Approvers</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_EA_Approvers_when_status_equals_Unenrolled</fullName>
        <description>Send Notification to EA Approvers when status equals Unenrolled</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_Enrollment_Application_Unenrollment</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_EA_Approvers_when_status_set_to_On_Hold</fullName>
        <description>Send Notification to EA Approvers when status set to On Hold</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_Enrollment_Application_On_Hold_Status</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_EA_PM_and_AP1_when_GM_and_or_EAC_as_of_Date_has_changed</fullName>
        <description>Send Notification to EA PM and AP1 when GM% and or EAC as of Date has changed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_of_GM_or_EAC_Values_Change</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_EA_PM_of_BL_or_Participant_Edits_if_Approver2_Approved</fullName>
        <description>Send Notification to EA PM of BL or Participant Edits if Approver2 already approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_Submitted_Enrollment_Application_Edits</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_EA_PM_when_EA_Status_is_Enrolled</fullName>
        <description>Send Notification to EA PM when EA Status is Enrolled (by DTW Admin)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_Enrollment_Application_Approval</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_EA_PM_when_EA_Status_is_Rejected_by_DTW_Admin</fullName>
        <description>xxxxSend Notification to EA PM when EA Status is Rejected (by DTW Admin)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_Enrollment_Application_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_PM_and_Approver1_for_EA_Approved_DPE_NSR_and_GM_Budget_Chan</fullName>
        <description>Send Notification to PM and Approver1 for Incentive Project Approved DPE, NSR and GM Budget Changes</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>americasdtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_IP_Baseline_Budgets_Surpass_Threshold</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_PM_and_Approver1_for_Incentive_Project_Approved_DPE_NSR_and</fullName>
        <description>Send Notification to PM and Approver1 for Incentive Project Approved DPE, NSR and GM Budget Changes</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_IP_Baseline_Budgets_Surpass_Threshold</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_PM_and_Approvers_for_Baseline_Shift</fullName>
        <description>Send Notification to PM and Approvers for Baseline Shift</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTW_Project_Incentives/Notify_BL_Shift_Since_Enrollment</template>
    </alerts>
    <alerts>
        <fullName>Target_Change_Notfiy_Approver_1</fullName>
        <description>Target Change - Notfiy Approver 1</description>
        <protected>false</protected>
        <recipients>
            <field>Approver1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_Approvers_When_Targets_Have_Changed</template>
    </alerts>
    <alerts>
        <fullName>Target_Change_Notfiy_Approver_2</fullName>
        <description>Target Change - Notfiy Approver 2</description>
        <protected>false</protected>
        <recipients>
            <field>Approver2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_Approvers_When_Targets_Have_Changed</template>
    </alerts>
    <alerts>
        <fullName>Target_Change_Notfiy_Approver_3</fullName>
        <description>Target Change - Notfiy Approver 3</description>
        <protected>false</protected>
        <recipients>
            <field>Approver3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_Approvers_When_Targets_Have_Changed</template>
    </alerts>
    <alerts>
        <fullName>Target_Change_Notfiy_Corp_Admin</fullName>
        <description>Target Change - Notfiy Corp Admin</description>
        <protected>false</protected>
        <recipients>
            <recipient>CORP_DTW_Admin</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_Approvers_When_Targets_Have_Changed</template>
    </alerts>
    <fieldUpdates>
        <fullName>ApprovalRecentlyProcessed</fullName>
        <field>ApprovalRecentlyProcessed__c</field>
        <literalValue>1</literalValue>
        <name>ApprovalRecentlyProcessed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Baseline_Contingency</fullName>
        <field>ContingencyatSnapshot__c</field>
        <formula>BaselineContingency__c</formula>
        <name>Baseline Contingency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Baseline_DPE_Snapshot</fullName>
        <field>BaselineDPEatSnapshot__c</field>
        <formula>BaselineDPE__c</formula>
        <name>Baseline DPE Snapshot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Baseline_GM_NSR_Snapshot</fullName>
        <field>BaselineGMofNSRatSnapshot__c</field>
        <formula>(IncentiveProject__r.ApprovedGrossMarginBudget__c + GrossMarginAdjustment__c) 
/(IncentiveProject__r.ApprovedNSRBudget__c + NSRAdjustment__c)</formula>
        <name>Baseline GM @ NSR Snapshot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Baseline_Gross_Margin_at_Snapshot</fullName>
        <description>IncentiveProject__r.ApprovedGrossMarginBudget__c
+ (BLANKVALUE(GrossMarginAmountScopeChange__c,0) + BLANKVALUE(GrossMarginAmountAdjustment__c,0))</description>
        <field>BaselineGrossMarginatSnapshot__c</field>
        <formula>IncentiveProject__r.ApprovedGrossMarginBudget__c</formula>
        <name>Baseline Gross Margin at Snapshot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Baseline_Gross_Revenue</fullName>
        <description>Will update BaseLineGrossRevenueatBaseline</description>
        <field>BaselineGrossRevenueSnapshot__c</field>
        <formula>BaselineGrossRevenue__c</formula>
        <name>Baseline Gross Revenue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Baseline_Margin_of_NSR</fullName>
        <field>BaselineMarginofNSRatSnapshot__c</field>
        <formula>CASE(IncentivePlan__r.ContractSubType__c, &quot;Gross Margin&quot;,
(IncentiveProject__r.ApprovedGrossMarginBudget__c + GrossMarginAdjustment__c) 
/(IncentiveProject__r.ApprovedNSRBudget__c + NSRAdjustment__c),
(IncentiveProject__r.ApprovedNetMarginBudget__c 
+ BLANKVALUE(GrossMarginAdjustment__c,0)) 
/(IncentiveProject__r.ApprovedNSRBudget__c + BLANKVALUE(NSRAdjustment__c,0)))</formula>
        <name>Baseline Margin% of NSR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Baseline_NM_NSR_Snapshot</fullName>
        <description>(IncentiveProject__r.ApprovedNetMarginBudget__c
+ GrossMarginAdjustment__c) 
/(IncentiveProject__r.ApprovedNSRBudget__c + NSRAdjustment__c)</description>
        <field>BaselineNMofNSRatSnapshot__c</field>
        <formula>(IncentiveProject__r.ApprovedNetMarginBudget__c
+ BLANKVALUE(GrossMarginAdjustment__c,0)) 
/(IncentiveProject__r.ApprovedNSRBudget__c + BLANKVALUE(NSRAdjustment__c,0))</formula>
        <name>Baseline NM @ NSR Snapshot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Baseline_NSR_Snapshot</fullName>
        <field>BaselineNSRatSnapshot__c</field>
        <formula>BaselineNSR__c</formula>
        <name>Baseline NSR Snapshot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Baseline_Net_Margin_at_Snapshot</fullName>
        <field>BaselineNetMarginatSnapshot__c</field>
        <formula>IncentiveProject__r.ApprovedNetMarginBudget__c 
+ (GrossMarginAmountScopeChange__c + GrossMarginAmountAdjustment__c)</formula>
        <name>Baseline Net Margin at Snapshot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Actual_Contingency_Budget</fullName>
        <description>Capture Actual Contingency Budget at Inception</description>
        <field>ActualContingencyBudgetatSnapshot__c</field>
        <formula>ActualContingencyBudgetITD__c</formula>
        <name>Capture Actual Contingency Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Actual_DPE_Budget</fullName>
        <description>Capture Actual DPE Budget at Inception</description>
        <field>ActualDPEBudgetatSnapshot__c</field>
        <formula>ActualDPEBudgetITD__c</formula>
        <name>Capture Actual DPE Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Actual_Direct_Labor_Budget</fullName>
        <description>Capture Actual Direct Labor Budget at Inception</description>
        <field>ActualDirectLaboratSnapshot__c</field>
        <formula>ActualDirectLaborITD__c</formula>
        <name>Capture Actual Direct Labor Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Actual_Fringe_Budget</fullName>
        <field>ActualFringeBudgetatSnapshot__c</field>
        <formula>ActualFringeBudgetITD__c</formula>
        <name>Capture Actual Fringe Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Actual_GM_Budget</fullName>
        <description>Capture Actual GM at Inception</description>
        <field>ActualGMBudgetatSnapshot__c</field>
        <formula>IncentiveProject__r.ActualGrossMarginITD__c</formula>
        <name>Capture Actual GM Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Actual_GM_of_NSR</fullName>
        <description>Capture Actual Gross Margin of NSR at Inception</description>
        <field>ActualGMofNSRatSnapshot__c</field>
        <formula>AcutalGMofNSRITD__c</formula>
        <name>Capture Actual GM of NSR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Actual_Gross_Revenue_Budget</fullName>
        <description>Capture Actual Gross Revenue Budget at Inception</description>
        <field>ActualGrossRevenueatSnapshot__c</field>
        <formula>IncentiveProject__r.ActualGrossRevenueITD__c</formula>
        <name>Capture Actual Gross Revenue Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Actual_ITD_Overhead</fullName>
        <field>ActualOverheadITDatSnapshot__c</field>
        <formula>IncentiveProject__r.ActualOverheadITD__c</formula>
        <name>Capture Actual ITD Overhead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Actual_NM_of_NSR</fullName>
        <description>Capture Actual Net Margin of NSR at Inception</description>
        <field>ActualNMofNSRatSnapshot__c</field>
        <formula>ActualNMofNSRITD__c</formula>
        <name>Capture Actual NM of NSR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Actual_NSR_Budget</fullName>
        <field>ActualNSRBudgetatSnapshot__c</field>
        <formula>NSRBudget__c</formula>
        <name>Capture Actual NSR Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Actual_Net_Margin_Budget</fullName>
        <description>Capture Actual Net Margin Budget at Inception or Enrollment</description>
        <field>ActualNetMarginatSnapshot__c</field>
        <formula>ActualNetMarginITD__c</formula>
        <name>Capture Actual Net Margin Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Actual_ODC_Budget</fullName>
        <description>Capture Actual ODC Budget at Inception</description>
        <field>ActualODCBudgetatSnapshot__c</field>
        <formula>ActualODCBudgetITD__c</formula>
        <name>Capture Actual ODC Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Actual_Project_Complete</fullName>
        <description>Capture Actual Project Percent Complete at Inception</description>
        <field>ITDCostCompleteatSnapshot__c</field>
        <formula>PercentCompleteCostITD__c</formula>
        <name>Capture Actual Project % Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Actual_Subs_Budget</fullName>
        <description>Capture Actual Subs Budget at Inception</description>
        <field>ActualSubsBudgetatSnapshot__c</field>
        <formula>ActualSubsBudgetITD__c</formula>
        <name>Capture Actual Subs Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Actual_Total_Cost</fullName>
        <description>Capture Actual Total Cost at snapshot</description>
        <field>ActualTotalCostBudgetatSnapshot__c</field>
        <formula>ActualTotalCostITD__c</formula>
        <name>Capture Actual Total Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_Contingency_Budget</fullName>
        <field>ApprovedContingencyBudgetatsnapshot__c</field>
        <formula>ApprovedContingencyBudget__c</formula>
        <name>Capture Approved Contingency Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_Cost_Budget</fullName>
        <description>Capture Approved Cost Budget at Inception</description>
        <field>ApprovedCostBudgetatSnapshot__c</field>
        <formula>ApprovedCostBudget__c</formula>
        <name>Capture Approved Cost Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_DPE</fullName>
        <field>ApprovedDPEBudgetatSnapshot__c</field>
        <formula>IncentiveProject__r.ApprovedDPEBudget__c</formula>
        <name>Capture Approved DPE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_Direct_Labor_Budget</fullName>
        <description>Capture Approved Direct Labor Budget at Inception</description>
        <field>ApprovedDirectLaborBudgetatSnapshot__c</field>
        <formula>IncentiveProject__r.ApprovedDirectLaborBudget__c</formula>
        <name>Capture Approved Direct Labor Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_Direct_Labor_Multiplier</fullName>
        <field>ApprovedDirectLMatSnapshot__c</field>
        <formula>IncentiveProject__r.ApprovedDirectLaborMultiplier__c</formula>
        <name>Capture Approved Direct Labor Multiplier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_Fringe_Budget</fullName>
        <description>Capture Approved Fringe Benefit Budget at Inception</description>
        <field>ApprovedFringeBudgetatSnapshot__c</field>
        <formula>ApprovedFringeBudget__c</formula>
        <name>Capture Approved Fringe Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_GM_Budget</fullName>
        <description>Capture Approved Gross Margin Budget at Inception</description>
        <field>ApprovedGrossMarginBudgetatSnapshot__c</field>
        <formula>IncentiveProject__r.ApprovedGrossMarginBudget__c</formula>
        <name>Capture Approved GM Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_GM_of_NSR</fullName>
        <description>Capture Approved Gross Margin of NSR at Inception</description>
        <field>ApprovedGrossMarginofNSRatSnapshot__c</field>
        <formula>ApprovedGrossMarginofNSR__c</formula>
        <name>Capture Approved GM of NSR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_NM_of_NSR</fullName>
        <description>Capture approved Net Margin of NSR at Inception</description>
        <field>ApprovedNetMarginofNSRatSnapShot__c</field>
        <formula>ApprovedNetMarginofNSR__c</formula>
        <name>Capture Approved NM of NSR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_NSR_Budget</fullName>
        <field>ApprovedNSRBudgetatSnapshot__c</field>
        <formula>ApprovedNSRBudget__c</formula>
        <name>Capture Approved NSR Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_Net_Margin_Budget</fullName>
        <description>Capture Approved Net Margin Budget at Inception</description>
        <field>ApprovedNetMarginBudgetatSnapshot__c</field>
        <formula>ApprovedNetMarginBudget__c</formula>
        <name>Capture Approved Net Margin Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_ODC</fullName>
        <field>ApprovedODCBudgetatSnapshot__c</field>
        <formula>IncentiveProject__r.ApprovedODCBudget__c</formula>
        <name>Capture Approved ODC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_Overhead</fullName>
        <field>ApprovedOverheadBudgetatSnapshot__c</field>
        <formula>IncentiveProject__r.ApprovedOverheadBudget__c</formula>
        <name>Capture Approved Overhead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_RevBudget</fullName>
        <description>Capture Approved Revenue Budget at Inception</description>
        <field>ApprovedRevenueBudgetatSnapshot__c</field>
        <formula>ApprovedRevenueBudget__c</formula>
        <name>Capture Approved RevBudget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_Salary_Cost_Multiplier</fullName>
        <field>ApprovedSalaryCMatSnapshot__c</field>
        <formula>IncentiveProject__r.ApprovedSalaryCostMultiplier__c</formula>
        <name>Capture Approved Salary Cost Multiplier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Approved_Subs</fullName>
        <description>This is actually subs and odc combined in the snap shot per Chris 10/29
Removed the + IncentiveProject__r.ApprovedODCBudget__c</description>
        <field>ApprovedSubsBudgetatSnapshot__c</field>
        <formula>IncentiveProject__r.ApprovedSubsBudget__c</formula>
        <name>Capture Approved Subs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Baseline_Gross_Margin_for_Alert</fullName>
        <description>Capture the formula field Baseline Gross Margin into the currency field Baseline Gross Margin Capture for alert to fire</description>
        <field>BaselineGrossMarginCaptured__c</field>
        <formula>PRIORVALUE( BaselineGrossMargin__c )</formula>
        <name>Capture Baseline Gross Margin for Alert</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_Contingency_Budget</fullName>
        <description>Capture the forecasted contingency budget at inception</description>
        <field>ForecastContingencyBudgetatSnapshot__c</field>
        <formula>ForecastContingencyBudget__c</formula>
        <name>Capture Forecast Contingency Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_Cost_Budget</fullName>
        <description>Capture Forecast Cost Budget at Inception or Enrollment</description>
        <field>ForecastCostBudgetatSnapshot__c</field>
        <formula>ForecastCostBudget__c</formula>
        <name>Capture Forecast Cost Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_Direct_Labor_Budget</fullName>
        <field>ForecastLaborBudgetatSnapshot__c</field>
        <formula>ForecastDirectLaborBudget__c</formula>
        <name>Capture Forecast Direct Labor Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_EAC_DPE</fullName>
        <field>ForecastDPEBudgetatSnapshot__c</field>
        <formula>IncentiveProject__r.ForecastDPEBudget__c</formula>
        <name>Capture Forecast EAC DPE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_EAC_Direct_Labor_Multi</fullName>
        <field>ForecastDirectLMatSnapshot__c</field>
        <formula>IncentiveProject__r.ForecastDirectLaborMultiplier__c</formula>
        <name>Capture Forecast EAC Direct Labor Multi</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_EAC_ODC</fullName>
        <field>ForecastODCBudgetatSnapshot__c</field>
        <formula>IncentiveProject__r.ForecastODCBudget__c</formula>
        <name>Capture Forecast EAC ODC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_EAC_Overhead</fullName>
        <field>ForecastOverheadBudgetatSnapshot__c</field>
        <formula>IncentiveProject__r.ForecastOverheadBudget__c</formula>
        <name>Capture Forecast EAC Overhead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_EAC_Salary_Multiplier</fullName>
        <field>ForecastSalaryCMatSnapshot__c</field>
        <formula>IncentiveProject__r.ForecastSalaryCostMultiplier__c</formula>
        <name>Capture Forecast EAC Salary Multiplier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_EAC_Subs</fullName>
        <field>ForecastSubsBudgetatSnapshot__c</field>
        <formula>IncentiveProject__r.ForecastSubsBudget__c</formula>
        <name>Capture Forecast EAC Subs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_Fringe_Budget</fullName>
        <description>Capture Forecast Fringe Budget at Inception</description>
        <field>ForecastFringeBudgetatSnapshot__c</field>
        <formula>ForecastFringeBudget__c</formula>
        <name>Capture Forecast Fringe Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_GM_Budget</fullName>
        <description>Capture Forecast Gross Margin Budget at Inception</description>
        <field>ForecastGMBudgetatSnapshot__c</field>
        <formula>ForecastGrossMarginBudget__c</formula>
        <name>Capture Forecast GM Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_GM_of_NSR</fullName>
        <description>Capture Forecast Gross Margin of NSR at Inception</description>
        <field>ForecastGMofNSRatSnapshot__c</field>
        <formula>IF( AND( NOT( ISNULL(ForecastGrossMarginofNSR__c) ) , NOT( ISBLANK(ForecastGrossMarginofNSR__c) ) ) , ForecastGrossMarginofNSR__c, 0)</formula>
        <name>Capture Forecast GM of NSR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_NM_Budget</fullName>
        <description>Capture Forecast Net Margin Budget at Inception</description>
        <field>ForecastNMBudgetatSnapshot__c</field>
        <formula>ForecastNetMarginBudget__c</formula>
        <name>Capture Forecast NM Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_NM_of_NSR</fullName>
        <description>Capture Forecast Net Margin of NSR at inception</description>
        <field>ForecastNMofNSRatSnapshot__c</field>
        <formula>IF(NOT(ISNULL(ForecastNetMarginofNSR__c)),ForecastNetMarginofNSR__c,0)</formula>
        <name>Capture Forecast NM of NSR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_NSR_Budget</fullName>
        <description>Capture the forecast NSR Budget at Inception</description>
        <field>ForecastNSRBudgetatSnapshot__c</field>
        <formula>ForecastNSRBudget__c</formula>
        <name>Capture Forecast NSR Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Forecast_Revenue_Budget</fullName>
        <description>Capture Forecasted Revenue Budget at Inception</description>
        <field>ForecastRevenueBudgetatSnapshot__c</field>
        <formula>ForecastRevenueBudget__c</formula>
        <name>Capture Forecast Revenue Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Form_Status_Change_Date</fullName>
        <description>When the Form Status changes, capture the date of the change in the Form Status Date field, so that the form status age can be calculated</description>
        <field>FormStatusDate__c</field>
        <formula>TODAY()</formula>
        <name>Capture Form Status Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_ITD_Direct_Labor_Multiplier</fullName>
        <field>ActualSalaryCostMultiplieratSnapshot__c</field>
        <formula>IncentiveProject__r.ApprovedDirectLaborMultiplier__c</formula>
        <name>Capture ITD Direct Labor Multiplier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_ITD_Labor_Cost_Multiplier</fullName>
        <field>ActualLaborCMatSnapshot__c</field>
        <formula>IncentiveProject__r.ActualLaborCostMultiplier__c</formula>
        <name>Capture ITD Labor Cost Multiplier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_to_Edit_Application_R_T</fullName>
        <field>RecordTypeId</field>
        <lookupValue>EditApplication</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change to Edit Application R/T</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_to_Enrolled_Application_R_T</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Enrolled</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change to Enrolled Application R/T</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_to_Rejected_R_T</fullName>
        <field>RecordTypeId</field>
        <lookupValue>RejectedApplication</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change to Rejected R/T</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_to_Workflow_R_T</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Workflow</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change to Workflow R/T</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cocatenate_Unique_EA_Name</fullName>
        <description>Name Format
ApplicationType + ApplicationVersion + ProjectName
Example
ENR000: [Incentive Project Name]
CCR001: [Incentive Project Name]
CCR002: [Incentive Project Name]

TEXT(ApplicationType__c)&amp;Application_Version__c&amp;(MID(Name,4,80))</description>
        <field>EnrollmentApplicationNameUnique__c</field>
        <formula>Name</formula>
        <name>Cocatenate Unique EA Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contingency_Baseline</fullName>
        <field>ContingencyatSnapshot__c</field>
        <formula>BaselineContingency__c</formula>
        <name>Contingency Baseline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTW_Complete_Snapshot</fullName>
        <field>DTWCompleteSnapshot__c</field>
        <formula>ActualTotalCostBudgetatSnapshot__c / (ForecastCostBudgetatSnapshot__c +(IncentiveProject__r.ApprovedCostBudget__c - ApprovedCostBudgetatSnapshot__c))</formula>
        <name>DTW% Complete @ Snapshot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTW_Ready_to_Submit_App</fullName>
        <description>Flips R/T so the submit button is visible.</description>
        <field>RecordTypeId</field>
        <lookupValue>Workflow</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>DTW Ready to Submit App</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTW_T_M_DPE_Adjustments</fullName>
        <field>DPEAdjustment__c</field>
        <formula>DPEBudgetAdjustment__c+AdminDPEOverride__c</formula>
        <name>DTW T&amp;M DPE Adjustments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTW_T_M_NSR_Adjustments</fullName>
        <field>NSRAdjustment__c</field>
        <formula>TotalNSRManagementAdjustment__c+AdminNSROverride__c</formula>
        <name>DTW T&amp;M NSR Adjustments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EA_Max_Pool_Expression1</fullName>
        <field>EAMaxPExp1__c</field>
        <formula>IF( TEXT(IncentivePlan__r.MaxPoolBaseline__c) = &quot;Forecast NSR&quot;, 
IF(TEXT(IncentivePlan__r.MaxPoolOperator1__c) = &quot;+&quot;, (ForecastNSRBudgetatSnapshot__c + IncentivePlan__r.MaxPoolPercent__c), 
IF(TEXT(IncentivePlan__r.MaxPoolOperator1__c) = &quot;-&quot;, (ForecastNSRBudgetatSnapshot__c - IncentivePlan__r.MaxPoolPercent__c), 
IF(TEXT(IncentivePlan__r.MaxPoolOperator1__c) = &quot;x&quot;, ROUND((ForecastNSRBudgetatSnapshot__c * IncentivePlan__r.MaxPoolPercent__c),1), 
IF(TEXT(IncentivePlan__r.MaxPoolOperator1__c) = &quot;/&quot;, ROUND((ForecastNSRBudgetatSnapshot__c / IncentivePlan__r.MaxPoolPercent__c),1),Null) 
))),Null)</formula>
        <name>EA. Max Pool Expression1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EA_Max_Pool_Expression_2</fullName>
        <field>EAMaxPExp2__c</field>
        <formula>IF( TEXT(IncentivePlan__r.MaxPoolField22__c) = &quot;Adjusted % Complete&quot;, 
IF(TEXT(IncentivePlan__r.MaxPoolOperator2__c) = &quot;+&quot;, (IncentivePlan__r.MaxPoolField2__c + ROUND(AdjustedComplete__c,2)), 
IF(TEXT(IncentivePlan__r.MaxPoolOperator2__c) = &quot;-&quot;, (IncentivePlan__r.MaxPoolField2__c - ROUND(AdjustedComplete__c,2)), 
IF(TEXT(IncentivePlan__r.MaxPoolOperator2__c) = &quot;x&quot;, ROUND((IncentivePlan__r.MaxPoolField2__c * ROUND(AdjustedComplete__c,2)),1), 
IF(TEXT(IncentivePlan__r.MaxPoolOperator2__c) = &quot;/&quot;, ROUND((IncentivePlan__r.MaxPoolField2__c / ROUND(AdjustedComplete__c,2)),1),Null) 
))),NULL)</formula>
        <name>EA.Max Pool Expression 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Exception_R_T_Set</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Exception</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Exception R/T - Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Is_In_Workflow_No</fullName>
        <field>IsInWorkflow__c</field>
        <literalValue>No</literalValue>
        <name>Is In Workflow = No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Is_In_Workflow_Yes</fullName>
        <field>IsInWorkflow__c</field>
        <literalValue>Yes</literalValue>
        <name>Is In Workflow = Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Max_Pool_F11</fullName>
        <field>EAMaxPF1__c</field>
        <formula>TEXT(IncentivePlan__r.MaxPoolBaseline__c)</formula>
        <name>Max Pool F1.1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Max_Pool_F12</fullName>
        <field>EAMaxPF12__c</field>
        <formula>IncentivePlan__r.MaxPoolPercent__c</formula>
        <name>Max Pool F1.2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Max_Pool_F2</fullName>
        <field>EAMaxPF21__c</field>
        <formula>IncentivePlan__r.MaxPoolField2__c</formula>
        <name>Max Pool F2.1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Max_Pool_F2_2</fullName>
        <field>EAMaxPF22__c</field>
        <formula>TEXT(IncentivePlan__r.MaxPoolField22__c)</formula>
        <name>Max Pool F2.2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Max_Pool_Op</fullName>
        <description>Connecting Operator Value</description>
        <field>EAMaxPOp__c</field>
        <formula>TEXT(IncentivePlan__r.MaxPoolOperator__c)</formula>
        <name>Max Pool Op Middle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Max_Pool_Op1</fullName>
        <field>EAMaxPOp1__c</field>
        <formula>TEXT(IncentivePlan__r.MaxPoolOperator1__c)</formula>
        <name>Max Pool Op1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Max_Pool_Op2</fullName>
        <field>EAMaxPOp2__c</field>
        <formula>TEXT(IncentivePlan__r.MaxPoolOperator2__c)</formula>
        <name>Max Pool Op2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection_Date</fullName>
        <field>RejectionDate__c</field>
        <formula>Today()</formula>
        <name>Rejection Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_30_Day_Email_Flag</fullName>
        <field>X30_Day_Email_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Set 30-Day Email Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_60_Day_Email_Flag</fullName>
        <field>X60_Day_Email_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Set 60-Day Email Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_App_1_Processed</fullName>
        <field>App_1_Processed__c</field>
        <literalValue>1</literalValue>
        <name>Set App 1 Processed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_App_2_Processed</fullName>
        <field>App_2_Processed__c</field>
        <literalValue>1</literalValue>
        <name>Set App 2 Processed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_App_3_Processed</fullName>
        <field>App_3_Processed__c</field>
        <literalValue>1</literalValue>
        <name>Set App 3 Processed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_App_Admin_Processed</fullName>
        <field>CorpAdminProcessed__c</field>
        <literalValue>1</literalValue>
        <name>Set App Admin Processed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ApplicationType_to_ENR</fullName>
        <field>ApplicationType__c</field>
        <literalValue>ENR</literalValue>
        <name>Set ApplicationType to ENR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ApplicationType_to_Opt_Out</fullName>
        <field>ApplicationType__c</field>
        <literalValue>OPT</literalValue>
        <name>Set ApplicationType to Opt-Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approver2_Approved_to_Yes</fullName>
        <field>Approver2Approved__c</field>
        <literalValue>Yes</literalValue>
        <name>Set Approver2 Approved to Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Corp_Admin_Processed</fullName>
        <description>Set the Corp Admin Process Checkbox to True.</description>
        <field>CorpAdminProcessed__c</field>
        <literalValue>1</literalValue>
        <name>Set Corp Admin Processed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_EA_Status_Rejected_for_Correction</fullName>
        <field>EnrollmentStatus__c</field>
        <literalValue>Rejected for Correction</literalValue>
        <name>Set EA Status &quot;Rejected for Correction&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_EA_Status_to_Enrolled</fullName>
        <field>EnrollmentStatus__c</field>
        <literalValue>Enrolled</literalValue>
        <name>Set EA Status to &quot;Enrolled&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_EA_Status_to_Opt_Out</fullName>
        <field>EnrollmentStatus__c</field>
        <literalValue>Opt-Out</literalValue>
        <name>Set EA Status to Opt-Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_EA_Status_to_Pending_AP1_Action</fullName>
        <field>EnrollmentStatus__c</field>
        <literalValue>Pending Approver 1 Action</literalValue>
        <name>Set EA Status to &quot;Pending AP1 Action&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_EA_Status_to_Pending_AP2_Action</fullName>
        <field>EnrollmentStatus__c</field>
        <literalValue>Pending Approver 2 Action</literalValue>
        <name>Set EA Status to &quot;Pending AP2 Action&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_EA_Status_to_Pending_AP3_Action</fullName>
        <field>EnrollmentStatus__c</field>
        <literalValue>Pending Approver 3 Action</literalValue>
        <name>Set EA Status to &quot;Pending AP3 Action&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_EA_Status_to_Pending_DTW_Admin</fullName>
        <field>EnrollmentStatus__c</field>
        <literalValue>Pending DTW Admin</literalValue>
        <name>Set EA Status to &quot;Pending DTW Admin&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_EA_Status_to_Pending_PM_Action</fullName>
        <field>EnrollmentStatus__c</field>
        <literalValue>Pending PM Action</literalValue>
        <name>Set EA Status to Pending PM Action</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_EA_Status_to_Rejected</fullName>
        <field>EnrollmentStatus__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set EA Status to &quot;Rejected&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_EPChanged_to_No</fullName>
        <field>EPChanged__c</field>
        <literalValue>No</literalValue>
        <name>Set EPChanged to No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Enrolled_Checkbox</fullName>
        <field>Enrolled__c</field>
        <literalValue>1</literalValue>
        <name>Set Enrolled Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Enrollment_Date</fullName>
        <field>FormEnrollmentDate__c</field>
        <formula>TODAY()</formula>
        <name>Set Enrollment Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Exceptions_Flag_to_NO</fullName>
        <field>ExceptionFlag__c</field>
        <literalValue>No</literalValue>
        <name>Set Exceptions Flag to NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Exceptions_Flag_to_Yes</fullName>
        <description>Set the Enrollment Application Exception(s)? pick list value to YES</description>
        <field>ExceptionFlag__c</field>
        <literalValue>Yes</literalValue>
        <name>Set Exceptions Flag to Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_IsMAChanged_to_Yes</fullName>
        <field>IsMAChanged__c</field>
        <literalValue>Yes</literalValue>
        <name>Set IsMAChanged to Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_MA_Adjustment_to_Yes</fullName>
        <field>MAFlag__c</field>
        <literalValue>Yes</literalValue>
        <name>Set MA Adjustment to Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_MA_Adjustments_to_No</fullName>
        <field>MAFlag__c</field>
        <literalValue>No</literalValue>
        <name>Set MA Adjustments to No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_PM_WizardStatus_to_Step1</fullName>
        <field>WizardStatus__c</field>
        <literalValue>Step 1</literalValue>
        <name>Set PM WizardStatus to Step 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Prepayment_Email_Sent_Flag</fullName>
        <field>PrepaymentEmailSent__c</field>
        <literalValue>1</literalValue>
        <name>Set Prepayment Email Sent Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Scheduled_Finish_Date_Stamp</fullName>
        <description>Sets ScheduledFinishDateStamp__c with the Scheduled Finish Date on the Incentive Project when an EA changed to Enrolled.</description>
        <field>ScheduledFinishDateStamp__c</field>
        <formula>ScheduledFinishDate__c</formula>
        <name>Set Scheduled Finish Date Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Pending_PM_Action</fullName>
        <field>EnrollmentStatus__c</field>
        <literalValue>Pending PM Action</literalValue>
        <name>Set Status to Pending PM Action</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Target_Has_Changed_Flag</fullName>
        <field>TargetChanged__c</field>
        <literalValue>1</literalValue>
        <name>Set Target Has Changed Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WorkflowStep_to_Pending_PM_Action</fullName>
        <field>WorkflowStep__c</field>
        <literalValue>Pending PM Action</literalValue>
        <name>Set WorkflowStep to Pending PM Action</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_to_Pending_Payment</fullName>
        <field>EnrollmentStatus__c</field>
        <literalValue>Pending Payment</literalValue>
        <name>Set to Pending Payment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SubsBaseline</fullName>
        <field>GrossRevenueSubsatSnaptShot__c</field>
        <formula>BaselineSubsODC__c</formula>
        <name>SubsBaseline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ThresholdField1</fullName>
        <field>EAThresholdField1__c</field>
        <formula>CASE( IncentivePlan__r.ThresholdBaseline__c,
 &quot;Gross Margin Dollars&quot;, 0 ,
 &quot;Net Margin Dollars&quot;, 0, 
 &quot;Baseline NM % of NSR&quot;, 0,
 &quot;Baseline GM % of NSR&quot;, BaselineGMofNSR__c,NULL)</formula>
        <name>Threshold Field 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Threshold_Field_2</fullName>
        <field>EAThresholdField2__c</field>
        <formula>IncentivePlan__r.ThresholdPercent__c</formula>
        <name>Threshold Field 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unset_30_Day_Email_Flag</fullName>
        <field>X30_Day_Email_Sent__c</field>
        <literalValue>0</literalValue>
        <name>Unset 30-Day Email Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unset_60_Day_Email_Flag</fullName>
        <field>X60_Day_Email_Sent__c</field>
        <literalValue>0</literalValue>
        <name>Unset 60-Day Email Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unset_Prepayment_Email_Sent_Flag</fullName>
        <field>PrepaymentEmailSent__c</field>
        <literalValue>0</literalValue>
        <name>Unset Prepayment Email Sent Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unset_Target_Has_Changed_Flag</fullName>
        <field>TargetChanged__c</field>
        <literalValue>0</literalValue>
        <name>Unset Target Has Changed Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X60_Days_Closed_set_to_No</fullName>
        <field>X60DaysClosed__c</field>
        <literalValue>No</literalValue>
        <name>60-Days Closed set to No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X60_Days_Closed_set_to_Yes</fullName>
        <field>X60DaysClosed__c</field>
        <literalValue>Yes</literalValue>
        <name>60-Days Closed set to Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>16Notify Approver 1 of budget change significantly impacting baseline</fullName>
        <actions>
            <name>Notify_AP1_of_budget_change_significantly_impacting_baseline_FP_plan_only</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>16Notify Approver 1 of budget change significantly impacting baseline (Fixed Price plan only)</description>
        <formula>AND(PlanType__c = &quot;Fixed Price&quot;,
PRIORVALUE(IncentivePlan__c) &lt;&gt;&quot;&quot;,
ISPICKVAL( EnrollmentStatus__c ,&quot;Enrolled&quot;), 
   ISCHANGED( BaselineGMofNSR__c),
   GM_Change__c &gt; IncentivePlanVarianceAlert__c
    )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>19Notify Participant of change in baseline</fullName>
        <active>false</active>
        <description>Notify Participant of change in baseline</description>
        <formula>ISCHANGED(BaselineGrossMargin__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>2Notify Corp DTW Admin of Approver Change of Employment</fullName>
        <actions>
            <name>Approver_employment_status_has_changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send notification to the Corp DTW Admin Public Group when any of the assigned approvers  has had a Job Title Change or Employment Status Changed to &quot;Terminated/LOA&quot;</description>
        <formula>ISCHANGED( LastInactiveUser__c )&amp;&amp; NOT( ISNULL(LastInactiveUser__c) )  &amp;&amp; LastInactiveUser__c &lt;&gt; &apos;&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>3Notify PM of project to review</fullName>
        <actions>
            <name>Notify_PM_of_project_to_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Pending PM Action</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationType__c</field>
            <operation>equals</operation>
            <value>ENR</value>
        </criteriaItems>
        <description>3Notify PM of project to review, NOT on Payment Type Record ID</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>4Notify PM and Approver1 when AP2 or AP3 Have Changed</fullName>
        <actions>
            <name>Notify_PM_Approver1_of_change_in_Approver_2_or_3</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify PM/Approver1 of a change in Approver 2 or 3</description>
        <formula>AND
   (ISPICKVAL(IsInWorkflow__c , &apos;Yes&apos;), 
    OR(
       ISCHANGED( Approver2__c ),
       ISCHANGED( Approver3__c )
       )
    )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>60-Days Closed set to No</fullName>
        <actions>
            <name>X60_Days_Closed_set_to_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.X60DaysClosed__c</field>
            <operation>notEqual</operation>
            <value>No</value>
        </criteriaItems>
        <description>Sets the 60-Days Closed field to Yes after 60days in the Closed Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>60-Days Closed set to Yes</fullName>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Sets the 60-Days Closed field to Yes after 60days in the Closed Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>X60_Days_Closed_set_to_Yes</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>6Notify Approver 1 of change in proposed Baseline GM%25</fullName>
        <actions>
            <name>Notify_Approver_1_of_change_in_proposed_baseline</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notify Approver 1 of change in proposed baseline (Baseline GM % or DSO Target) since submitted for approval</description>
        <formula>OR(
   LastModifiedBy.Id = Approver2__r.Id,
   LastModifiedBy.Id = Approver3__r.Id ,
AND(
   ISPICKVAL( IsInWorkflow__c , &apos;Yes&apos;),
   BaselineGrossMarginCaptured__c &lt;&gt;  BaselineGrossMargin__c,
   ISPICKVAL(ConfirmBaseline__c , &apos;Yes&apos;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>6Notify Approver 1 of change in proposed baseline %28DSO Target Only%29</fullName>
        <actions>
            <name>Notify_Approver_1_of_change_in_proposed_baseline</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notify Approver 1 of change in proposed baseline (Baseline GM % or DSO Target) since submitted for approval</description>
        <formula>AND(OR( LastModifiedBy.Id =  Approver2__r.Id ,
 LastModifiedBy.Id  =  Approver3__r.Id) ,
AND(ISCHANGED(DSOTarget__c),
    PRIORVALUE(DSOTarget__c )&lt;&gt;0))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Approver 1 Assignment</fullName>
        <actions>
            <name>Send_Notification_to_Approver_1_when_assigned_to_EA</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>When the first level approver been assigned, send e-mail alert notification and update the Enrollment Status</description>
        <formula>AND (
ISCHANGED( Approver1__c ),
NOT(ISNULL( Approver1__c ))
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Baseline GM%25 Exceeds IP Threshold</fullName>
        <actions>
            <name>Notify_PM_and_Approvers_when_Baseline_GM_Variance_Exceeds_Incentive_Plan_Thresho</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>ApprovedRevenueBudgetVariance__c &gt;IncentivePlan__r.VarianceAlert__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Capture ACTUAL %28ITD%29 Financial Metrics %281 of 2%29</fullName>
        <actions>
            <name>Capture_Actual_Contingency_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Actual_DPE_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Actual_Direct_Labor_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Actual_Fringe_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Actual_GM_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Actual_Gross_Revenue_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Actual_NSR_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Actual_ODC_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Actual_Project_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Actual_Subs_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Pending PM Action,Enrolled</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.TM1Migrated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationType__c</field>
            <operation>equals</operation>
            <value>ENR</value>
        </criteriaItems>
        <description>When the Enrollment Application is first created or enrolled, capture the actual financial metrics (ITD) from the Incentive Project (1 of 2 workflows) -currently points to At Inception</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Capture ACTUAL %28ITD%29 Financial Metrics %282 of 2%29</fullName>
        <actions>
            <name>Capture_Actual_GM_of_NSR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Actual_ITD_Overhead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Actual_NM_of_NSR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Actual_Net_Margin_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Actual_Total_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_ITD_Direct_Labor_Multiplier</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_ITD_Labor_Cost_Multiplier</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Pending PM Action,Enrolled</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.TM1Migrated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationType__c</field>
            <operation>equals</operation>
            <value>ENR</value>
        </criteriaItems>
        <description>When the Enrollment Application is first created or enrolled, capture the actual financial metrics (ITD) from the Incentive Project (2 of 2 workflows)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Capture APPROVED Financial Metrics %281 of 2%29</fullName>
        <actions>
            <name>Capture_Approved_Contingency_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Approved_Cost_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Approved_Direct_Labor_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Approved_Fringe_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Approved_GM_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Approved_GM_of_NSR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Approved_NM_of_NSR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Approved_NSR_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Approved_Net_Margin_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Approved_RevBudget</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Pending PM Action,Enrolled</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.TM1Migrated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationType__c</field>
            <operation>equals</operation>
            <value>ENR</value>
        </criteriaItems>
        <description>When the Enrollment Application is first Created, or Enrolled, capture the APPROVED financial metrics from the Incentive Project</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Capture APPROVED Financial Metrics %282 of 2%29</fullName>
        <actions>
            <name>Capture_Approved_DPE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Approved_Direct_Labor_Multiplier</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Approved_ODC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Approved_Overhead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Approved_Salary_Cost_Multiplier</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Approved_Subs</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Pending PM Action,Enrolled</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.TM1Migrated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationType__c</field>
            <operation>equals</operation>
            <value>ENR</value>
        </criteriaItems>
        <description>When the Enrollment Application is first Created, or Enrolled, capture the APPROVED financial metrics from the Incentive Project</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Capture BASELINE Snapshots</fullName>
        <actions>
            <name>Baseline_DPE_Snapshot</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Baseline_GM_NSR_Snapshot</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Baseline_Gross_Margin_at_Snapshot</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Baseline_Gross_Revenue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Baseline_Margin_of_NSR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Baseline_NM_NSR_Snapshot</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Baseline_NSR_Snapshot</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Baseline_Net_Margin_at_Snapshot</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DTW_Complete_Snapshot</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SubsBaseline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Pending PM Action</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.TM1Migrated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.PlanType__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationType__c</field>
            <operation>equals</operation>
            <value>ENR</value>
        </criteriaItems>
        <description>When the Enrollment Application is first Created, capture the Baseline financial metrics from the Incentive Project.  Enrolled snapshot is done in trigger.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Capture BASELINE Snapshots %282%29</fullName>
        <actions>
            <name>Contingency_Baseline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Pending PM Action</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.TM1Migrated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.PlanType__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationType__c</field>
            <operation>equals</operation>
            <value>ENR</value>
        </criteriaItems>
        <description>When the Enrollment Application is first Created capture the Baseline financial metrics from the Incentive Project, enrolled is done in trigger.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Capture BaselineGrossMargin%5F%5Fc</fullName>
        <actions>
            <name>Capture_Baseline_Gross_Margin_for_Alert</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Captures Baseline Gross Margin for comparison purposes, to enable workflow alerts to fire.</description>
        <formula>ISCHANGED( BaselineGrossMargin__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Capture FORECAST %28EAC%29 Financial Metrics %281 of 2%29</fullName>
        <actions>
            <name>Capture_Forecast_Contingency_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Forecast_Cost_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Forecast_Direct_Labor_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Forecast_Fringe_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Forecast_GM_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Forecast_GM_of_NSR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Forecast_NM_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Forecast_NM_of_NSR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Forecast_NSR_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Forecast_Revenue_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Pending PM Action,Enrolled</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.TM1Migrated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationType__c</field>
            <operation>equals</operation>
            <value>ENR</value>
        </criteriaItems>
        <description>When the Enrollment Application is first Created, or Enrolled, capture the FORECAST financial metrics from the Incentive Project</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Capture FORECAST %28EAC%29 Financial Metrics %282 of 2%29</fullName>
        <actions>
            <name>Capture_Forecast_EAC_DPE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Forecast_EAC_Direct_Labor_Multi</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Forecast_EAC_ODC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Forecast_EAC_Overhead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Forecast_EAC_Salary_Multiplier</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Capture_Forecast_EAC_Subs</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Pending PM Action,Enrolled</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.TM1Migrated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationType__c</field>
            <operation>equals</operation>
            <value>ENR</value>
        </criteriaItems>
        <description>When the Enrollment Application is first Created, or Enrolled, capture the FORECAST financial metrics from the Incentive Project</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Capture Form Status Change to Calculate AGE</fullName>
        <actions>
            <name>Capture_Form_Status_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the form Status changes, capture the date of the change, so that the Form Status Age can be calculated</description>
        <formula>ISCHANGED( EnrollmentStatus__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Check for any Exceptions and Set Exceptions Flag</fullName>
        <actions>
            <name>Set_Exceptions_Flag_to_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Know if anything I have submitted is an exception to plan guidelines and will require an exception approval (i.e. set the Exception(s)? flag to YES</description>
        <formula>OR 
(
/*
1) Exception to project size threshold for single project, MIN NSR Budget
*/

ApprovedNSRBudget__c  &lt;  IncentivePlan__r.MinNSRBudget__c,

/*
2) Exception to Enroll a project &gt;85% complete 
*/

PercentCompleteCostITD__c  &gt;  IncentivePlan__r.MaxComplete__c,

/*
3)Total Allocation cannot be greater than 60% at enrollment unless End day &lt; 6mos (Allocate &gt; 60% of pool at enrollment for Scheduled End Date &lt; 6mos)
*/

     (AND 
         (TotalAllocationParticipants__c &gt; 0.60,
          TODAY() - ScheduledFinishDate__c &gt;= -180)
      ),

/*
4)Management adjustment to budgeted GM%/NM% and/or adjustment to baseline operational metrics
*/

ISCHANGED( DPEAdjustment__c ),
ISCHANGED( NSRAdjustment__c  )       
   )

/*Instead of setting the flag to &quot;Yes&quot; or &quot;No&quot;, change the Exceptions Flag to a Text Field instead, and show the reason (s) why there is an exception */</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Cocatenate Unique Enrollment Application Name</fullName>
        <actions>
            <name>Cocatenate_Unique_EA_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>US-01142: create WFR to populate a Name field that will be unique.  This name must also populate the standard name field, Create a counter that increments within an Incentive Project so that an applicaion version number can be included in the Application</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>DTW - 30-Day Notification of Approaching IP Scheduled Finish Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Enrolled</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.X30_Day_Email_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ScheduledFinishDateStamp__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Schedules a notification for 30 days before the scheduled finish date when status = &apos;Enrolled&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notification_of_Approaching_IP_Scheduled_Finish_Date</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Set_30_Day_Email_Flag</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>EnrollmentPlan__c.ScheduledFinishDateStamp__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DTW - 60-Day Notification of Approaching IP Scheduled Finish Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Enrolled</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.X60_Day_Email_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ScheduledFinishDateStamp__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Schedules a notification for 60 days before the scheduled finish date when status = &apos;Enrolled&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notification_of_Approaching_IP_Scheduled_Finish_Date</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Set_60_Day_Email_Flag</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>EnrollmentPlan__c.ScheduledFinishDateStamp__c</offsetFromField>
            <timeLength>-60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DTW Ready to Submit App</fullName>
        <actions>
            <name>DTW_Ready_to_Submit_App</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.AppIicationIssues__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Workflow,Rejected,Exception,Edit Application,Model</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DTW T%26M NSR%2FDPE Adjustments</fullName>
        <actions>
            <name>DTW_T_M_DPE_Adjustments</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DTW_T_M_NSR_Adjustments</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Overwrites the FP NSR and DPE adjustment values to match the T&amp;M value.
AND( TEXT(IncentivePlan__r.ContractType__c) = &quot;Time &amp; Material&quot;, 
OR( NSRAdjustment__c &lt;&gt; (TotalNSRManagementAdjustment__c + TotalNSRScopeChange__c), 
DPEAdjustment__c &lt;&gt; DPEBudget</description>
        <formula>TEXT(IncentivePlan__r.ContractType__c) = &quot;Time &amp; Material&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Enrollment App Profit Sharing Values</fullName>
        <active>false</active>
        <formula>AND(IncentivePlan__c &lt;&gt; &quot;&quot;,  TEXT(EAThresholdField1__c) = &quot;&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Enrollment App Threshold and Max Pool Calc 1</fullName>
        <actions>
            <name>EA_Max_Pool_Expression1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EA_Max_Pool_Expression_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Max_Pool_F12</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Max_Pool_F2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Max_Pool_Op</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Max_Pool_Op1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Max_Pool_Op2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Brings down the Threshold and Max Pool calculations as defined from the Incentive Plan Template  TEXT(EAThresholdField1__c) = &quot;&quot;)</description>
        <formula>OR(ISChanged(IncentivePlan__c), TEXT(EnrollmentStatus__c) = &quot;Enrolled&quot;,  Text(MetricWarningActive__c) = &quot;Yes&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Enrollment App Threshold and Max Pool Calc 2</fullName>
        <actions>
            <name>ThresholdField1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Threshold_Field_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Brings down the Threshold and Max Pool calculations as defined from the Incentive Plan Template  TEXT(EAThresholdField1__c) = &quot;&quot;)</description>
        <formula>ISChanged(IncentivePlan__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Exceptions Flag - Clear</fullName>
        <actions>
            <name>Set_Exceptions_Flag_to_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>EnrollmentPlan__c.Application_Exceptions__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ExceptionFlag__c</field>
            <operation>notEqual</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>notEqual</operation>
            <value>Enrolled,Archived,Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationExceptionsFP__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationExceptionsPAY__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationExceptionsTM__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Exceptions Flag - Set</fullName>
        <actions>
            <name>Set_Exceptions_Flag_to_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4</booleanFilter>
        <criteriaItems>
            <field>EnrollmentPlan__c.Application_Exceptions__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationExceptionsTM__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationExceptionsFP__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationExceptionsPAY__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Approver 1 of Target Change</fullName>
        <actions>
            <name>Target_Change_Notfiy_Approver_1</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Unset_Target_Has_Changed_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Notify Approver 1 if upstream Approver changed Target.</description>
        <formula>and(App_1_Processed__c  , 

ischanged(EnrollmentStatus__c), 
or( 
ispickval(EnrollmentStatus__c,&quot;Enrolled&quot;),contains(text(EnrollmentStatus__c),&quot;Pending&quot;)), 
TargetChanged__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Approver 2 of Target Change</fullName>
        <actions>
            <name>Target_Change_Notfiy_Approver_2</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Unset_Target_Has_Changed_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Notify Approver 2 if Upstream Approver Changes Target.</description>
        <formula>and(App_2_Processed__c , 

ischanged(EnrollmentStatus__c), 
or( 
ispickval(EnrollmentStatus__c,&quot;Enrolled&quot;),contains(text(EnrollmentStatus__c),&quot;Pending&quot;)), 
TargetChanged__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Approver 3 of Target Change</fullName>
        <actions>
            <name>Target_Change_Notfiy_Approver_3</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Unset_Target_Has_Changed_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Notify Approver 3 if Upstream Approver changes Target.</description>
        <formula>and(App_3_Processed__c,
ischanged(EnrollmentStatus__c), 
or( 
ispickval(EnrollmentStatus__c,&quot;Enrolled&quot;),contains(text(EnrollmentStatus__c),&quot;Pending&quot;)), 
TargetChanged__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Approvers and PM of EP being Unenrolled</fullName>
        <actions>
            <name>Send_Notification_to_EA_Approvers_when_status_equals_Unenrolled</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Unenrolled</value>
        </criteriaItems>
        <description>WFR to fire based on the Enrollment Status field being set to Unenrolled</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Corp Admin of Target Change</fullName>
        <actions>
            <name>Target_Change_Notfiy_Corp_Admin</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Unset_Target_Has_Changed_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Notify Corp Admin of Target Change if Corp Admin has approved the record.</description>
        <formula>and(
CorpAdminProcessed__c,ischanged(EnrollmentStatus__c), 
or( 
ispickval(EnrollmentStatus__c,&quot;Enrolled&quot;),contains(text(EnrollmentStatus__c),&quot;Pending&quot;)), 
TargetChanged__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify DTW Admin when Approvers have Changed</fullName>
        <actions>
            <name>Send_Notification_to_DTW_Admin_when_change_of_Approvers</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Used to send notification to the DTW Admin if there are any changes made to any of the three approvers.</description>
        <formula>AND(
    OR( 
       ISCHANGED( Approver1__c ),
       ISCHANGED( Approver2__c ),
       ISCHANGED( Approver3__c )
       ),
      NOT( $User.ProfileId =&apos;00ee0000000HwwZ&apos;)
      )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify PM of CCR to review</fullName>
        <actions>
            <name>Notify_PM_of_CCR_to_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Pending PM Action</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ApplicationType__c</field>
            <operation>equals</operation>
            <value>CCR</value>
        </criteriaItems>
        <description>Notify PM of CCR to review, NOT on Payment Type Record ID</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify PM of any approver edits to BL Metrics or Participants after approver 2 has approved</fullName>
        <actions>
            <name>Send_Notification_to_EA_PM_of_BL_or_Participant_Edits_if_Approver2_Approved</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Alert PM if  the assigned approvers have made any edits the Baseline Metrics and added ore removed Participants, after Approver 2 has approved.</description>
        <formula>AND (
     ISPICKVAL(Approver2Approved__c , &apos;Yes&apos;),  
       OR
        (ISCHANGED( DPEAdjustment__c ),
         ISCHANGED( GrossMarginAdjustment__c  ),
         ISCHANGED( NSRAdjustment__c  ),
         ISCHANGED (NumberofParticipants__c)
         )
     )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify for Baseline Shift Since Enrollment</fullName>
        <actions>
            <name>Send_Notification_to_PM_and_Approvers_for_Baseline_Shift</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Used to send a notification that the baseline metrics (DPE or NSR Adjustment) has shifted since enrollment</description>
        <formula>/*Criteria check to ensure that the EA is in the application process*/

AND( 
      (OR
         (
          (ISPICKVAL( EnrollmentStatus__c ,&quot;Pending Approver 1 Action&quot;)),
          (ISPICKVAL( EnrollmentStatus__c ,&quot;Pending Approver 2 Action&quot;)),
          (ISPICKVAL( EnrollmentStatus__c ,&quot;Pending Approver 3 Action&quot;)), 
          (ISPICKVAL( EnrollmentStatus__c ,&quot;Rejected for Correction&quot;))
          )
       ), 
         
/*Criteria to check for any BaseLine Adjustments changing*/
  
    (OR
       (
         ISCHANGED( NSRAdjustment__c ),
         ISCHANGED( DPEAdjustment__c )
       )
     )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify of Interim Payment Requested</fullName>
        <actions>
            <name>Notify_of_Interim_Payment_Request</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.InterimPaymentRequested__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify of Participant Change - App1</fullName>
        <actions>
            <name>Participant_Change_Notify_Approver_1</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_EPChanged_to_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If participant is added or changed by Approver 2, notifies Approver 1 &amp; PM.</description>
        <formula>and(
LastModifiedById=Approver2_ID__c,
ischanged(EnrollmentStatus__c), 
or(
ispickval(EnrollmentStatus__c,&quot;Enrolled&quot;),
contains(text(EnrollmentStatus__c),&quot;Pending&quot;))
,
ispickval(EPChanged__c,&quot;Yes&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify of Participant Change - App2</fullName>
        <actions>
            <name>Participant_Change_Notify_Approver_2</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_EPChanged_to_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If participant is added or changed by Approver 3, notifies Approver 1, 2 &amp; PM.</description>
        <formula>and(LastModifiedById= Approver3ID__c ,

ischanged(EnrollmentStatus__c), 
or(
ispickval(EnrollmentStatus__c,&quot;Enrolled&quot;),contains(text(EnrollmentStatus__c),&quot;Pending&quot;)),
ispickval(EPChanged__c,&quot;Yes&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify of Participant Change - App3</fullName>
        <actions>
            <name>Participant_Change_Notify_Approver_3</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_EPChanged_to_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If participant is added or changed by DTWAdmin, notifies Approver 1,2,3 &amp; PM.</description>
        <formula>and(LastModifiedById=DTWAdminID__c, 

ischanged(EnrollmentStatus__c), 
or( 
ispickval(EnrollmentStatus__c,&quot;Enrolled&quot;),contains(text(EnrollmentStatus__c),&quot;Pending&quot;)), 
ispickval(EPChanged__c,&quot;Yes&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify of Participant Change - PM</fullName>
        <actions>
            <name>Participant_Change_Notify_PM</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_EPChanged_to_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Notify PM if Participant Count Changes.</description>
        <formula>and(LastModifiedById=Approver1ID__c, 

ischanged(EnrollmentStatus__c), 
or( 
ispickval(EnrollmentStatus__c,&quot;Enrolled&quot;),contains(text(EnrollmentStatus__c),&quot;Pending&quot;)), 
ispickval(EPChanged__c,&quot;Yes&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>On Create Populate PM E-Mail</fullName>
        <active>false</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When the Enrollment Plan is created, copy over the Project Manager E-Mail address.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Prepayment Alert to Approver 1 and PM</fullName>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Enrolled</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.PrepaymentEmailSent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.ScheduledFinishDateStamp__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Send email notification to Approver 1 x days before Scheduled End Date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Prepayment_Alert_to_Approver_1_and_PM</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Set_Prepayment_Email_Sent_Flag</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>EnrollmentPlan__c.ScheduledFinishDateStamp__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Set Enrolled Checkbox to True</fullName>
        <actions>
            <name>Set_Enrolled_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.EnrollmentStatus__c</field>
            <operation>equals</operation>
            <value>Enrolled,Archived</value>
        </criteriaItems>
        <description>Set the enrolled checkbox when status changes to &apos;Enrolled&apos; or &apos;Archived&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Exceptions Flag to NO</fullName>
        <actions>
            <name>Set_Exceptions_Flag_to_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.RecordTypeId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set IsMAChanged to Yes</fullName>
        <actions>
            <name>Set_IsMAChanged_to_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>DELETE</description>
        <formula>AND(TEXT( IsMAChanged__c ) &lt;&gt; &quot;Yes&quot;,

OR(
   AND(NSRAdjustment__c &gt;0, ISCHANGED(NSRAdjustment__c)),
   AND(DPEAdjustment__c &gt; 0, ISCHANGED(DPEAdjustment__c))
  )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set MA Adjustments to No</fullName>
        <actions>
            <name>Set_IsMAChanged_to_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_MA_Adjustments_to_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>DELETE</description>
        <formula>AND(TEXT(NSRAdjustment__c) = &quot;&quot;,
    TEXT(DPEAdjustment__c) = &quot;&quot;,
    TEXT( MAFlag__c ) &lt;&gt; &quot;No&quot;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set MA Adjustments to Yes</fullName>
        <actions>
            <name>Set_MA_Adjustment_to_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>EnrollmentPlan__c.DPEAdjustment__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.NSRAdjustment__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EnrollmentPlan__c.MAFlag__c</field>
            <operation>notEqual</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>DELETE</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Target Has Changed Flag</fullName>
        <actions>
            <name>Set_Target_Has_Changed_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the &apos;Target Has Changed&apos; checkbox if an Adjustment, DSO, or Scope Change field as changed.</description>
        <formula>and(LastModifiedById&lt;&gt;Approver1ID__c, 
or(
ischanged(ContingencyAdjustment__c),

ischanged(DPEAdjustment__c ),

ischanged(GrossRevenueAdjustment__c ),

ischanged(GrossMarginAmountAdjustment__c ),

ischanged(GMofNSRAdjustment__c ),

ischanged(NSRAdjustment__c  ),

ischanged(SubsODCsAdjustment__c ),

ischanged(ContingencyScopeChange__c ),

ischanged(GrossRevenueScopeChange__c ),

ischanged(GrossMarginAmountScopeChange__c),

ischanged(GMofNSRScopeChange__c ),

ischanged(SubsODCsScopeChange__c ),

ischanged(DSOTarget__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Turn off GMEAC Alert after 10 days</fullName>
        <active>false</active>
        <description>If both the CMEACChange is &quot;Yes&quot; and GMEAC Text Field Alert is &apos;YES&apos;, wait 10 days, and then update the GMEACChange to &quot;No&quot;.</description>
        <formula>AND
(
ISPICKVAL(IncentiveProject__r.GMEACChange__c , &apos;Yes&apos;),
CONTAINS( GMEACChangeAlert__c , &quot;YES&quot;)
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>-10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Unset 30 Day Email Flag</fullName>
        <actions>
            <name>Unset_30_Day_Email_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Unset the 30-Day Email Flag if the Project finish date has changed.</description>
        <formula>and( 
ischanged( ScheduledFinishDateStamp__c ), 

ScheduledFinishDateStamp__c-Today()&gt;30 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unset 60 Day Email Flag</fullName>
        <actions>
            <name>Unset_60_Day_Email_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Unset the 60-Day Email Flag if the Project finish date has changed and the new date is more than 60 days out.</description>
        <formula>and( 
ischanged(ScheduledFinishDateStamp__c), 
ScheduledFinishDateStamp__c-Today()&gt;60 

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unset Prepayment Email Sent Flag</fullName>
        <actions>
            <name>Unset_Prepayment_Email_Sent_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>and(
ischanged(ScheduledFinishDateStamp__c),

ScheduledFinishDateStamp__c&gt;PRIORVALUE(ScheduledFinishDateStamp__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
