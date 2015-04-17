<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Add_Role_Team_Member</fullName>
        <description>Assigns the role Team Member when nothing else is added.</description>
        <field>Project_Role__c</field>
        <literalValue>Team Member</literalValue>
        <name>Add Role Team Member</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UniqueProjEmp</fullName>
        <field>ChkUniqueEmp__c</field>
        <formula>casesafeID(EmployeeUser__c) + ( IF(ISPICKVAL(Status__c,&apos;Archived&apos;), casesafeId(Id), IF((LEN(Project_ID__c) &gt; 0), casesafeID(Project_ID__c), casesafeID(Id)) ) ) + TEXT(Status__c)</formula>
        <name>UniqueProjEmp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Role is Team Member</fullName>
        <actions>
            <name>Add_Role_Team_Member</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PR_Team_Employee__c.Project_Role__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Select Team Member when another value isn&apos;t specified.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UniquePREmployee</fullName>
        <actions>
            <name>UniqueProjEmp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Validate that an employee can only be added once to the team list for a project</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
