<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
</Workflow>
