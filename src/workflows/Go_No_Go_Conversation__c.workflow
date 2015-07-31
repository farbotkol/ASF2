<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ANZ_Proposal_Review_Approval_Notification_in_English</fullName>
        <description>ANZ Proposal Review Approval Notification in English</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Bid_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Bid_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>KAM_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Sponsor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ANZ/ANZ_Proposal_Review_Approval_Notification_English</template>
    </alerts>
    <alerts>
        <fullName>ANZ_Proposal_Review_Rejection_Notification_English</fullName>
        <description>ANZ Proposal Review Rejection Notification - English</description>
        <protected>false</protected>
        <recipients>
            <field>Bid_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Bid_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>KAM_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Sponsor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ANZ/ANZ_Proposal_Review_Rejection_Notification_English_only</template>
    </alerts>
    <alerts>
        <fullName>ANZ_Why_Go_Approval_Notification_in_English</fullName>
        <description>ANZ Why Go Approval Notification in English</description>
        <protected>false</protected>
        <recipients>
            <field>Bid_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Bid_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>KAM_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Sponsor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ANZ/ANZ_Why_Go_Approval_Notification_English</template>
    </alerts>
    <alerts>
        <fullName>ANZ_Why_Go_Rejection_Notification_English</fullName>
        <description>ANZ Why Go Rejection Notification - English</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>ANZ_Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Bid_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Bid_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>KAM_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Sponsor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ANZ/ANZ_Why_Go_Rejection_Notification_English_only</template>
    </alerts>
    <alerts>
        <fullName>Denise_Laferte_alert</fullName>
        <description>Denise Laferte alert for new US Federal GNG</description>
        <protected>false</protected>
        <recipients>
            <recipient>denise.laferte@aecom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Misc_Americas/MSL_GNG_alert</template>
    </alerts>
    <alerts>
        <fullName>GNG_ANZ_Created_Email_Alert</fullName>
        <description>GNG ANZ Created Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Bid_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ANZ/ANZ_GNG_Created_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>GNG_Approval_Capture_Manager_Notification</fullName>
        <ccEmails>salesforce_b&amp;p.europe@aecom.com</ccEmails>
        <description>GNG Approval Capture Manager Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Bid_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Approval_Templates/GNG_EMEA_Approved</template>
    </alerts>
    <alerts>
        <fullName>GNG_Approval_Notification_in_English_and_French</fullName>
        <description>GNG Approval Notification in English and French</description>
        <protected>false</protected>
        <recipients>
            <field>Marketing_Proposal_Lead_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CMC_North_America/GNG_Approval_Notification_English_French</template>
    </alerts>
    <alerts>
        <fullName>GNG_EMEA_Approval_Submission</fullName>
        <description>GNG EMEA Approval Submission</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Approval_Templates/GNG_EMEA_Submission</template>
    </alerts>
    <alerts>
        <fullName>GNG_NoGo_Approval_Notification</fullName>
        <description>GNG No-Go Approval Notification in English</description>
        <protected>false</protected>
        <recipients>
            <field>Marketing_Proposal_Lead_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Bid_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CMC_North_America/GNG_Approval_Notification_NoGo_Approved</template>
    </alerts>
    <alerts>
        <fullName>GNG_NoGo_Approval_Notification_English_only</fullName>
        <description>GNG Approval Notification in English</description>
        <protected>false</protected>
        <recipients>
            <field>Marketing_Proposal_Lead_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Bid_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CMC_North_America/GNG_Approval_Notification_English_French</template>
    </alerts>
    <alerts>
        <fullName>GNG_Rejection_Notification_English</fullName>
        <description>GNG Rejection Notification - English</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CMC_North_America/GNG_Rejection_Notification_English_only</template>
    </alerts>
    <alerts>
        <fullName>GNG_Rejection_Notification_English_and_French</fullName>
        <description>GNG Rejection Notification - English and French</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CMC_North_America/GNG_Rejection_Notification_English_only</template>
    </alerts>
    <alerts>
        <fullName>Notifies_GNG_user_that_Finance_has_assigned_a_discrete_English</fullName>
        <description>Notifies GNG user that a B&amp;P # has been assigned (English)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Marketing_Proposal_Lead_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Bid_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>CMC_North_America/B_P_Communication</template>
    </alerts>
    <alerts>
        <fullName>Notifies_GNG_user_that_a_B_P_has_been_assigned_English_and_French</fullName>
        <description>Notifies GNG user that a B&amp;P # has been assigned (English and French)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Marketing_Proposal_Lead_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Bid_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>CMC_North_America/B_P_Communication_F_and_E</template>
    </alerts>
    <alerts>
        <fullName>Request_to_Finance_to_open_a_B_P_for_Canada</fullName>
        <description>Request to Finance to open a B&amp;P # for Canada</description>
        <protected>false</protected>
        <recipients>
            <field>Accounting_email_address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CMC_North_America/B_P_Number_Request_French_English</template>
    </alerts>
    <alerts>
        <fullName>Request_to_Finance_to_open_a_B_P_for_US</fullName>
        <description>Request to Finance to open a B&amp;P # for US</description>
        <protected>false</protected>
        <recipients>
            <field>Accounting_email_address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CMC_North_America/B_P_Number_Request_English</template>
    </alerts>
    <fieldUpdates>
        <fullName>GNG_Approval_Status_Approved</fullName>
        <description>Sets GNG Approval Status to Approved</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>GNG Approval Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GNG_Approval_Status_Not_Submitted</fullName>
        <description>Sets GNG Approval Status to Not Submitted</description>
        <field>Approval_Status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>GNG Approval Status - Not Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GNG_Approval_Status_Rejected</fullName>
        <description>Sets GNG Approval Status to Rejected</description>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>GNG Approval Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GNG_Approval_Status_Submitted</fullName>
        <description>Sets GNG Approval Status to Submitted</description>
        <field>Approval_Status__c</field>
        <literalValue>Submitted for Approval - Pending</literalValue>
        <name>GNG Approval Status - Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GNG_Decision_Date</fullName>
        <description>Sets Decision date when Decision is made</description>
        <field>Decision_Date__c</field>
        <formula>TODAY()</formula>
        <name>GNG Decision Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GNG_Decision_Go</fullName>
        <description>GNG Decision field update when GNG has been approved</description>
        <field>Decision__c</field>
        <literalValue>Go</literalValue>
        <name>GNG Decision - Go</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GNG_Decision_No_Go</fullName>
        <description>GNG field update for rejection</description>
        <field>Decision__c</field>
        <literalValue>No-Go</literalValue>
        <name>GNG Decision - No-Go</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GNG_Decision_Pending</fullName>
        <description>Field update for GNG record when it has been submitted for approval</description>
        <field>Decision__c</field>
        <literalValue>Pending</literalValue>
        <name>GNG Decision - Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GNG_Discrete_B_P_required</fullName>
        <description>If Gross AECOM fee &gt; $1M or cost to pursue &gt; $50K, a discrete B&amp;P charge number will be opened in Oracle.</description>
        <field>Open_a_discrete_B_P_Number__c</field>
        <literalValue>Yes</literalValue>
        <name>GNG - Discrete B&amp;P # required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GNG_Set_Marketing</fullName>
        <description>Sets email so B&amp;P charge # can be sent to marketing staff</description>
        <field>Marketing_Proposal_Lead_email__c</field>
        <formula>Opportunity__r.Marketing_Lead_User__r.Email</formula>
        <name>GNG: Set Marketing Proposal Lead email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Status_to_Approved</fullName>
        <description>Sets GNG Approval Status to Approved, used for reporting</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set Approval Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Status_to_Not_Submitted</fullName>
        <description>Sets GNG Approval Status field to Not Submitted when user recalls an approval request.</description>
        <field>Approval_Status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>Set Approval Status to Not Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Status_to_Rejected</fullName>
        <description>Sets GNG Approval Status to Rejected. Used for reporting</description>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set Approval Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Status_to_Submitted</fullName>
        <description>Sets GNG Approval Status field to Submitted for Approval - Pending as first step of approval process</description>
        <field>Approval_Status__c</field>
        <literalValue>Submitted for Approval - Pending</literalValue>
        <name>Set Approval Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_B_P_Charge_Code</fullName>
        <description>Sets B&amp;P Charge Code on GNG form</description>
        <field>B_P_Charge_Number__c</field>
        <formula>IF (ISPICKVAL(Open_a_discrete_B_P_Number__c, &quot;Yes&quot;) &amp;&amp; BEGINS (Opportunity_Lead_Region__c , &quot;CAN&quot;), &quot;Pending from Finance/En attente du service Finances&quot;, 

IF (ISPICKVAL(Open_a_discrete_B_P_Number__c, &quot;Yes&quot;) &amp;&amp;  NOT (BEGINS (Opportunity_Lead_Region__c , &quot;CAN&quot;)), &quot;Pending from Finance&quot;, 

IF (Key_Account__c = &quot;No&quot; &amp;&amp; 
ISPICKVAL(Open_a_discrete_B_P_Number__c, &quot;No&quot;), &quot;Proj: &quot; +  Opportunity__r.AECOM_Primary_Dept_Lookup__r.Oracle_BD_Sector_No__c  + &quot; Task: &quot; + Opportunity__r.B_P_Task_under_threshold__c + &quot; B&amp;P Below&quot;,
IF( BEGINS (
Key_Account__c, &quot;Yes&quot; ) &amp;&amp; 
ISPICKVAL(Open_a_discrete_B_P_Number__c, &quot;No&quot;), &quot;Proj: &quot; +   Opportunity__r.AECOM_Primary_Dept_Lookup__r.Oracle_BD_Key_Client_No__c  + &quot; Task: &quot; +   Opportunity__r.Account.Oracle_Task__c + &quot; B&amp;P Below&quot;, 
 
 null))))</formula>
        <name>Set B&amp;P Charge Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Sales_Manager_email</fullName>
        <description>Looks up email address from HR data object and populates in GNG form so that email alerts can be sent</description>
        <field>Sales_Manager_Email__c</field>
        <formula>Opportunity__r.Capture_Manager_User__r.Email</formula>
        <name>Set Sales Manager email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_accounting_email_address</fullName>
        <description>Inserts the shared email box address for use in the B&amp;P number setup request. Based on region of the related opportunity.</description>
        <field>Accounting_email_address__c</field>
        <formula>IF ( BEGINS (Opportunity_Lead_Region__c , &quot;Can&quot;), &quot;PursuitChargecode_Canada@aecom.com&quot;,
IF ( BEGINS (Opportunity_Lead_Region__c , &quot;US - North&quot;), &quot;PursuitChargecode_north@aecom.com&quot;,
IF ( BEGINS (Opportunity_Lead_Region__c , &quot;US - South&quot;), &quot;PursuitChargecode_south@aecom.com&quot;,
IF (Opportunity_Lead_Region__c = &quot;US - West&quot;, &quot;PursuitChargecode_west@aecom.com&quot;,
&quot;PursuitChargecode_mgmt@aecom.com&quot;))))</formula>
        <name>Set accounting email address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_GNG_Score</fullName>
        <field>GNG_Score__c</field>
        <formula>Commercial_Analysis_Score__c +  Market_Position_Total_Score__c + 
Risk_Analysis_Q1_Score__c + 
Risk_Analysis_Q4_Score__c + 
Risk_Analysis_Q6_Score__c + 
Risk_Analysis_Q7_Score__c + 
Risk_Analysis_Q8_Score__c</formula>
        <name>Update GNG Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Risk_Score</fullName>
        <field>Risk_Score__c</field>
        <formula>RATotScore__c +  Commercial_Analysis_Score__c + +Market_Position_Q1_Score__c + Market_Position_Q2_Score__c +  Market_Position_Q7_Score__c + Market_Position_Q10_Score__c</formula>
        <name>Update Risk Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ANZ GNG Created Alert Rule</fullName>
        <actions>
            <name>GNG_ANZ_Created_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ANZ Why Go</value>
        </criteriaItems>
        <description>Send an email the GNG Capture Manager when a ANZ GNG is created. This is used to help Capture/Bid Managers find the GNG.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GNG - Set Discrete B%26P %22Yes%22</fullName>
        <actions>
            <name>GNG_Discrete_B_P_required</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2 or 3</booleanFilter>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.Pursuit_Cost_Total__c</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 50,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.Program_Ceiling__c</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 1,000,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.Project_TO_Contract_Rev__c</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 1,000,000&quot;</value>
        </criteriaItems>
        <description>Sets the Discrete B&amp;P answer to &quot;Yes&quot; if value or cost is over threshold</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GNG%3A Set Marketing Proposal Lead email</fullName>
        <actions>
            <name>GNG_Set_Marketing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.Decision__c</field>
            <operation>notEqual</operation>
            <value>Pending</value>
        </criteriaItems>
        <description>Used to set Marketing Proposal Lead for GNG notificaton</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New US Federal GNG</fullName>
        <actions>
            <name>Denise_Laferte_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 or 3)</booleanFilter>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.End_Client_Sector__c</field>
            <operation>equals</operation>
            <value>US Federal Government</value>
        </criteriaItems>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.Program_Ceiling__c</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 1,000,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.Project_TO_Contract_Rev__c</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 1,000,000&quot;</value>
        </criteriaItems>
        <description>Informs Denise that a new GNG has been created for a US Federal Government opportunity with value &gt;= $1 million.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notifies GNG user of discrete B%26P %23 - Canada</fullName>
        <actions>
            <name>Notifies_GNG_user_that_a_B_P_has_been_assigned_English_and_French</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.B_P_Charge_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.B_P_Charge_Number__c</field>
            <operation>notContain</operation>
            <value>Pending from Finance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.Opportunity_Lead_Region__c</field>
            <operation>contains</operation>
            <value>Canada</value>
        </criteriaItems>
        <description>Sends email to the Capture (Sales) manager and GNG record creator when Finance enters the B&amp;P number. French and English version.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notifies US GNG user of discrete B%26P %23</fullName>
        <actions>
            <name>Notifies_GNG_user_that_Finance_has_assigned_a_discrete_English</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.B_P_Charge_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.B_P_Charge_Number__c</field>
            <operation>notContain</operation>
            <value>Pending from Finance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.Opportunity_Lead_Region__c</field>
            <operation>notContain</operation>
            <value>Canada</value>
        </criteriaItems>
        <description>Sends email to the Capture (Sales) manager and GNG record creator when Finance enters the B&amp;P number. English-only version.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Request Marketing %23 %28PDD US%29</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.Decision__c</field>
            <operation>equals</operation>
            <value>Go</value>
        </criteriaItems>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.Primary_Department_from_Opportunity__c</field>
            <operation>contains</operation>
            <value>B+P,PCC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.Primary_Department_from_Opportunity__c</field>
            <operation>contains</operation>
            <value>- 41.</value>
        </criteriaItems>
        <description>Deactivated when FY14 BD ROI went into effect.
Sends email to Holly Penrose when a Go decision is made.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Accounting Email address</fullName>
        <actions>
            <name>Set_accounting_email_address</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.Decision__c</field>
            <operation>equals</operation>
            <value>GNG FastPass,Go</value>
        </criteriaItems>
        <description>Sets accounting email address on GNG form, determined by lead region</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Sales Manager Email address</fullName>
        <actions>
            <name>Set_Sales_Manager_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.Decision__c</field>
            <operation>equals</operation>
            <value>GNG FastPass,Go</value>
        </criteriaItems>
        <description>Sets Sales (Capture) Manager email address on GNG form. Looked up in HR data</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update ANZ Scores</fullName>
        <actions>
            <name>Update_GNG_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Risk_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Go_No_Go_Conversation__c.RecordTypeId</field>
            <operation>contains</operation>
            <value>ANZ</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
