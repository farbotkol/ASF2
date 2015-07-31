<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Contract_Review_Request_Confirmation_ENG</fullName>
        <description>Contract Review Request Confirmation (ENG)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Preferred_Contract_Reviewer__c</field>
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
        <senderType>CurrentUser</senderType>
        <template>Contract_Reviewed/Contract_Review_Request_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Contract_Review_Request_Update_Eng</fullName>
        <description>Contract Review Request Update (Eng)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Project_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Contract_Reviewed/Contract_Review_Request_Update</template>
    </alerts>
    <alerts>
        <fullName>Reasignment_of_Contract_Review_Eng</fullName>
        <description>Reasignment of Contract Review  (Eng)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Contract_Reviewed/Reasignment_of_Contract_Review</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Legal_Time_Reviewed</fullName>
        <description>This set the time that the status was changed to Review Complete</description>
        <field>Time_Reviewed__c</field>
        <formula>NOW()</formula>
        <name>Set Legal Time Reviewed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Legal_Time_Submitted</fullName>
        <description>This sets the date time that the contract was submitted for review.  Is to be used for calculating how long it takes for a contract to get reviewed</description>
        <field>Time_Submitted__c</field>
        <formula>NOW()</formula>
        <name>Set Legal Time Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Outstanding_Review</fullName>
        <field>Status_Review__c</field>
        <literalValue>Outstanding Review</literalValue>
        <name>Set Status to Outstanding Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Contract Review Submitted</fullName>
        <actions>
            <name>Set_Legal_Time_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_to_Outstanding_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract_Review__c.Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>set status and date submitted when the contract is submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Reviewed</fullName>
        <actions>
            <name>Set_Legal_Time_Reviewed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract_Review__c.Status_Review__c</field>
            <operation>equals</operation>
            <value>Review Complete - Subject to Negotiation or DOA Approval</value>
        </criteriaItems>
        <description>Fired when the status is set to</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Reasignment of Contract Review</fullName>
        <actions>
            <name>Reasignment_of_Contract_Review_Eng</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send Reasignment of Contract Review email if the assignee(owner) is not the assigner and owner is not a legal team queue.</description>
        <formula>ISCHANGED( OwnerId ) &amp;&amp; OwnerId  &lt;&gt;  LastModifiedById &amp;&amp; LEFT( OwnerId , 3) &lt;&gt; &quot;00G&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Status or Owner Changed</fullName>
        <actions>
            <name>Contract_Review_Request_Update_Eng</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Determine of the Status review or Owner has Changed</description>
        <formula>(ISCHANGED(Status_Review__c) &amp;&amp; TEXT(Status_Review__c) &lt;&gt; &quot;Pending Submit&quot; &amp;&amp; TEXT(Status_Review__c) &lt;&gt; &quot;Outstanding Review&quot;) || (ISCHANGED( OwnerId ) &amp;&amp; TEXT(Status_Review__c) &lt;&gt; &quot;Pending Submit&quot; &amp;&amp; ( NOW() -  Time_Submitted__c ) &gt; 0.002)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>New_Task_Added_to_you_Queue</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Contract_Review__c.Date_Required__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Task Added to you Queue</subject>
    </tasks>
</Workflow>
