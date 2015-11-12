<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Mark_as_Incomplete</fullName>
        <field>Complete__c</field>
        <literalValue>0</literalValue>
        <name>Mark as Incomplete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Answer_To_No</fullName>
        <field>Value__c</field>
        <literalValue>No</literalValue>
        <name>Set Answer To No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Answer_to_Completed</fullName>
        <field>Complete__c</field>
        <literalValue>1</literalValue>
        <name>Set Answer to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_DOA_Flag</fullName>
        <field>DoATrigger__c</field>
        <literalValue>1</literalValue>
        <name>Set DOA Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_DoA_Flag_to_False</fullName>
        <field>DoATrigger__c</field>
        <literalValue>0</literalValue>
        <name>Set DoA Flag to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_IsRisk_to_False</fullName>
        <field>IsRisk__c</field>
        <literalValue>0</literalValue>
        <name>Set IsRisk to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Risk_Flag</fullName>
        <field>IsRisk__c</field>
        <literalValue>1</literalValue>
        <name>Set Risk Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Answer_to_Blank</fullName>
        <field>Value__c</field>
        <name>Update Answer to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Answer %3A Becomes Answered</fullName>
        <actions>
            <name>Set_Answer_to_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Answer__c.Value__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Answer Becomes Unanswered</fullName>
        <actions>
            <name>Mark_as_Incomplete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Answer__c.Value__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Answered %3A DOA Trigger</fullName>
        <actions>
            <name>Set_DOA_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TemplateQuestion__c.IsDoATrigger__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Answer__c.Value__c</field>
            <operation>equals</operation>
            <value>Yes,Unknown</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Answered %3A DOA Trigger %28No%29</fullName>
        <actions>
            <name>Set_Answer_to_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_DoA_Flag_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TemplateQuestion__c.IsDoATrigger__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Answer__c.Value__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Answered %3A Is Risk</fullName>
        <actions>
            <name>Set_Risk_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Answer__c.Value__c</field>
            <operation>equals</operation>
            <value>Yes,Unknown</value>
        </criteriaItems>
        <criteriaItems>
            <field>TemplateQuestion__c.IsDoATrigger__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>TemplateQuestion__c.isDOAmaster__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Answered %3A Is Risk %28False%29</fullName>
        <actions>
            <name>Set_IsRisk_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Answer__c.Value__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>TemplateQuestion__c.IsDoATrigger__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>