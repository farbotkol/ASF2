<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>MS_Capture_Status_Red_or_Yellow</fullName>
        <description>MS Capture Status Red or Yellow</description>
        <protected>false</protected>
        <recipients>
            <field>Capture_Manager_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Primary_BD_Lead_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MS_Capture_Status_Red_or_Yellow</template>
    </alerts>
    <alerts>
        <fullName>MS_Foreign_Opportunity</fullName>
        <description>MS Foreign Opportunity</description>
        <protected>false</protected>
        <recipients>
            <recipient>nadege.lecomte@aecom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nancy.franus@urs.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MS_Foreign_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>MS_Last_Update_over_180d</fullName>
        <description>MS Last Update over 180d</description>
        <protected>false</protected>
        <recipients>
            <field>Capture_Manager_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Primary_BD_Lead_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MS_Last_Update_over_180d</template>
    </alerts>
    <alerts>
        <fullName>MS_Proposal_Due_Date_passed</fullName>
        <description>MS Proposal Due Date passed</description>
        <protected>false</protected>
        <recipients>
            <field>Capture_Manager_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Primary_BD_Lead_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MS_Proposal_Due_Date_passed</template>
    </alerts>
    <rules>
        <fullName>Email MS Foreign Opportunity</fullName>
        <actions>
            <name>MS_Foreign_Opportunity</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Program - MS,Project - MS,Task Order - MS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ProjectCountry__c</field>
            <operation>notEqual</operation>
            <value>United States</value>
        </criteriaItems>
        <description>Notify MS Export Control Manager in case of non US opportunities.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MS Capture Status Red or Yellow</fullName>
        <actions>
            <name>MS_Capture_Status_Red_or_Yellow</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>0-1-Qualification,1-2-Solution Development,2-3-Pre-proposal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RFI_Release_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Notify Opportunity BD Lead and Capture Manager if  opportunity RFP Release Date passed or in near future and early stage</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MS Last Update over 180d</fullName>
        <actions>
            <name>MS_Last_Update_over_180d</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Program - MS,Project - MS,Task Order - MS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>6 Contracted/Booked/Won,6A Program Closed/Completed,7 Canceled by Client,8 No-Go,9 Lost</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Opportunity.LastModifiedDate</offsetFromField>
            <timeLength>180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MS Proposal Due Date passed</fullName>
        <actions>
            <name>MS_Proposal_Due_Date_passed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Program - MS,Project - MS,Task Order - MS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>0-0-Planning,0-1-Qualification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Submittal_Date_Proposal__c</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Notify Opportunity BD Lead and Capture Manager of MS opportunities with Proposal Due Dates that have passed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Opportunity.Submittal_Date_Proposal__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update MS Priority to 1</fullName>
        <actions>
            <name>Update_MS_Priority_to_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4) OR (1 AND 2 AND 5 AND 6) OR (2 AND 7 AND 8)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Program - MS,Project - MS,Task Order - MS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.MS_Priority_Override__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>equals</operation>
            <value>Fixed Price,Lump Sum,Lump Sum TurnKey,Target Price/Fixed Price</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 50,000,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>notEqual</operation>
            <value>Fixed Price,Lump Sum,Lump Sum TurnKey,Target Price/Fixed Price</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 250,000,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Program - MS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.AECOM_Role__c</field>
            <operation>equals</operation>
            <value>Prime</value>
        </criteriaItems>
        <description>This workflow rule updates the MS Priority field on Opportunity to 1.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update MS Priority to 2</fullName>
        <actions>
            <name>Update_MS_Priority_to_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4 AND 5) OR (1 AND 2 AND 6 AND 7 AND 8) OR (2 AND 9 AND 10)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Program - MS,Project - MS,Task Order - MS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.MS_Priority_Override__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>equals</operation>
            <value>Fixed Price,Lump Sum,Lump Sum TurnKey,Target Price/Fixed Price</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 10,000,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>lessThan</operation>
            <value>&quot;USD 50,000,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>notEqual</operation>
            <value>Fixed Price,Lump Sum,Lump Sum TurnKey,Target Price/Fixed Price</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>lessThan</operation>
            <value>&quot;USD 250,000,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 40,000,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Program - MS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.AECOM_Role__c</field>
            <operation>equals</operation>
            <value>Sub</value>
        </criteriaItems>
        <description>This workflow rule updates the MS Priority field on Opportunity to 2.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update MS Priority to 3</fullName>
        <actions>
            <name>Update_MS_Priority_to_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4) OR (1 AND 2 AND 5 AND 6)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Program - MS,Project - MS,Task Order - MS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.MS_Priority_Override__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>equals</operation>
            <value>Fixed Price,Lump Sum,Lump Sum TurnKey,Target Price/Fixed Price</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>lessThan</operation>
            <value>&quot;USD 10,000,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>notEqual</operation>
            <value>Fixed Price,Lump Sum,Lump Sum TurnKey,Target Price/Fixed Price</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>lessThan</operation>
            <value>&quot;USD 40,000,000&quot;</value>
        </criteriaItems>
        <description>This workflow rule updates the MS Priority field on Opportunity to 3.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
