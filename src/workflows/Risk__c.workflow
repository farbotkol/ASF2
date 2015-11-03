<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SetRiskNumber</fullName>
        <field>RiskNumber__c</field>
        <formula>Project__r.RiskCount__c + 1</formula>
        <name>Set Risk Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetRiskTitle</fullName>
        <field>Name</field>
        <formula>BLANKVALUE(Answer__r.TemplateQuestion__r.RiskTitle__c,  Answer__r.TemplateQuestion__r.QuestionnaireTemplate__r.Name )</formula>
        <name>Set Risk Title</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Risk_Description_w_Question_Text</fullName>
        <field>RiskDescription__c</field>
        <formula>Answer__r.TemplateQuestion__r.Question__c</formula>
        <name>Update Risk Description w/ Question Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EcoSet Risk Number</fullName>
        <actions>
            <name>SetRiskNumber</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Risk__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sets the Risk #</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Risk Description</fullName>
        <actions>
            <name>SetRiskTitle</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Risk_Description_w_Question_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISBLANK(Answer__c )),  ISBLANK(RiskDescription__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
