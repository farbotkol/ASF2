<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Rejection_Notification_Corrective_Action_App1</fullName>
        <description>Rejection Notification, Corrective Action App1</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_1_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_AP1_AP2_that_an_application_rejected_back_for_further_action</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Notification_Corrective_Action_App2</fullName>
        <description>Rejection Notification, Corrective Action App2</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_2_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_AP1_AP2_that_an_application_rejected_back_for_further_action</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Notification_Corrective_Action_App3</fullName>
        <description>Rejection Notification, Corrective Action App3</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_3_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_AP1_AP2_that_an_application_rejected_back_for_further_action</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Notification_Corrective_Action_PM</fullName>
        <description>Rejection Notification, Corrective Action PM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_AP1_AP2_that_an_application_rejected_back_for_further_action</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Notification_Final_Rejection_1</fullName>
        <description>Rejection Notification, Final Rejection 1</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_1_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_Approver_1_or_Approver_2_that_an_application_has_been_rejected</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Notification_Final_Rejection_1_2</fullName>
        <description>Rejection Notification, Final Rejection 1,2</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_1_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Approver_2_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_Approver_1_or_Approver_2_that_an_application_has_been_rejected</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Notification_Final_Rejection_1_2_3</fullName>
        <description>Rejection Notification, Final Rejection 1,2,3</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_1_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Approver_2_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Approver_3_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_Approver_1_or_Approver_2_that_an_application_has_been_rejected</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Notification_back_for_further_action_PM_AP1_2_3</fullName>
        <description>Draft - Rejection Notification, back for further action; PM, AP1, 2, &amp; 3</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_1_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Approver_2_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Approver_3_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_AP1_AP2_that_an_application_rejected_back_for_further_action</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Notification_back_for_further_action_PM_AP_1_2</fullName>
        <description>Draft - Rejection Notification, back for further action; PM, AP 1 &amp; 2</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_1_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Approver_2_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dtwincentiveplan@aecom.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DTW_Project_Incentives/Notify_PM_AP1_AP2_that_an_application_rejected_back_for_further_action</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Application_Type_FP</fullName>
        <field>ApplicationType__c</field>
        <literalValue>FP</literalValue>
        <name>Set Application Type - FP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Application_Type_T_M</fullName>
        <field>ApplicationType__c</field>
        <literalValue>T&amp;M</literalValue>
        <name>Set Application Type - T&amp;M</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Comment_Approver_1_Email</fullName>
        <description>Sets value to the Approver 1 Email.</description>
        <field>Approver_1_Email__c</field>
        <formula>EnrollmentApplication__r.Approver1__r.Email</formula>
        <name>Set Comment Approver 1 Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Comment_Approver_2_Email</fullName>
        <description>Sets value to the Approver 2 Email.</description>
        <field>Approver_2_Email__c</field>
        <formula>EnrollmentApplication__r.Approver2__r.Email</formula>
        <name>Set Comment Approver 2 Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Comment_Approver_3_Email</fullName>
        <description>Sets value to the Approver 3 Email.</description>
        <field>Approver_3_Email__c</field>
        <formula>EnrollmentApplication__r.Approver3__r.Email</formula>
        <name>Set Comment Approver 3 Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Comment_R_T_FP</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Fixed_Plan</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Comment R/T - FP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Comment_R_T_T_M</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Time_and_Material</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Comment R/T - T&amp;M</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EA Final Rejection Notice - App1</fullName>
        <actions>
            <name>Rejection_Notification_Final_Rejection_1</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends Final Rejection Notice to Approver 1 only.</description>
        <formula>and(not(isnew()),
EnrollmentApplication__r.App_1_Processed__c, 
EnrollmentApplication__r.App_2_Processed__c=False,
EnrollmentApplication__r.App_3_Processed__c=False,
Final_Rejection__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EA Final Rejection Notice - App1%262</fullName>
        <actions>
            <name>Rejection_Notification_Final_Rejection_1_2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends Final Rejection Notice to Approver 1 &amp; 2.</description>
        <formula>and(not(isnew()),
EnrollmentApplication__r.App_1_Processed__c, 
EnrollmentApplication__r.App_2_Processed__c,
EnrollmentApplication__r.App_3_Processed__c=False,
Final_Rejection__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EA Final Rejection Notice - App1%2C2%2C%263</fullName>
        <actions>
            <name>Rejection_Notification_Final_Rejection_1_2_3</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends Final Rejection Notice to Approver 1, 2 &amp; 3.</description>
        <formula>and(not(isnew()),
EnrollmentApplication__r.App_1_Processed__c, 
EnrollmentApplication__r.App_2_Processed__c,
EnrollmentApplication__r.App_3_Processed__c,
Final_Rejection__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EA Rejection for Correction App1</fullName>
        <actions>
            <name>Rejection_Notification_Corrective_Action_App1</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends Rejection for Correction notification to Approver 1.</description>
        <formula>and(not(isnew()),

ispickval(EnrollmentApplication__r.EnrollmentStatus__c,&quot;Rejected for Correction&quot;),
LastModifiedById  = EnrollmentApplication__r.Approver2_ID__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EA Rejection for Correction App2</fullName>
        <actions>
            <name>Rejection_Notification_Corrective_Action_App2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends Rejection for Correction notification to Approver 2.</description>
        <formula>and(not(isnew()),

ispickval(EnrollmentApplication__r.EnrollmentStatus__c,&quot;Rejected for Correction&quot;),

or(
LastModifiedById  =  EnrollmentApplication__r.Approver3ID__c,

and(LastModifiedById=EnrollmentApplication__r.DTWAdminID__c, EnrollmentApplication__r.App_3_Processed__c =False)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EA Rejection for Correction App3</fullName>
        <actions>
            <name>Rejection_Notification_Corrective_Action_App3</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends Rejection for Correction notification to Approver 3.</description>
        <formula>and(not(isnew()),

ispickval(EnrollmentApplication__r.EnrollmentStatus__c,&quot;Rejected for Correction&quot;),

LastModifiedById=  EnrollmentApplication__r.DTWAdminID__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EA Rejection for Correction PM</fullName>
        <actions>
            <name>Rejection_Notification_Corrective_Action_PM</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends Rejection for Correction notification to Approver 1.</description>
        <formula>and(not(isnew()),

ispickval(EnrollmentApplication__r.EnrollmentStatus__c,&quot;Rejected for Correction&quot;),
LastModifiedById  =  EnrollmentApplication__r.Approver1ID__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Application Type - FP</fullName>
        <actions>
            <name>Set_Application_Type_FP</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Comment_R_T_FP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.PlanType__c</field>
            <operation>equals</operation>
            <value>Fixed Price</value>
        </criteriaItems>
        <description>Captures the plan type at the time the Comment record is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Application Type - T%26M</fullName>
        <actions>
            <name>Set_Application_Type_T_M</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Comment_R_T_T_M</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EnrollmentPlan__c.PlanType__c</field>
            <operation>equals</operation>
            <value>Time &amp; Material</value>
        </criteriaItems>
        <description>Captures the plan type at the time the Comment record is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Rejection Comment Approver Email Fields</fullName>
        <actions>
            <name>Set_Comment_Approver_1_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Comment_Approver_2_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Comment_Approver_3_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Enrollment_Comments__c.Type__c</field>
            <operation>equals</operation>
            <value>Rejection,Rejection for Corrections,Final Rejection</value>
        </criteriaItems>
        <description>Sets Approver Email 1, 2 &amp; 3 on comment record when a rejection comment is inserted.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
