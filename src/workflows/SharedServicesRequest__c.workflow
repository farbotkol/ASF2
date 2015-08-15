<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>EcoSet_Account_Name_to_Caps</fullName>
        <field>CustomerName__c</field>
        <formula>Upper( CustomerName__c )</formula>
        <name>EcoSet Account Name to Caps</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoSet_Shared_Services_AmericasQueue</fullName>
        <field>OwnerId</field>
        <lookupValue>AmericasSharedServicesQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>EcoSet Shared Services Queue Americas</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoSet_Shared_Services_Queue_APAC</fullName>
        <field>OwnerId</field>
        <lookupValue>ApacSharedServicesQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>EcoSet Shared Services Queue APAC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoSet_Shared_Services_Queue_EMEA</fullName>
        <field>OwnerId</field>
        <lookupValue>EMEASharedServicesQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>EcoSet Shared Services Queue EMEA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoUnsetAssignToSharedServices</fullName>
        <field>AssigntoSharedServices__c</field>
        <literalValue>0</literalValue>
        <name>EcoUnsetAssignToSharedServices</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Generate_Objects</fullName>
        <field>GenerateObjects__c</field>
        <literalValue>1</literalValue>
        <name>EcoGenerate Objects</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Turn_Off_Validation</fullName>
        <field>SkipValidation__c</field>
        <literalValue>1</literalValue>
        <name>EcoTurn Off Validation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EcoAssignToSharedServicesAPAC</fullName>
        <actions>
            <name>EcoSet_Shared_Services_Queue_APAC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(AssigntoSharedServices__c),AssigntoSharedServices__c = True, ISPICKVAL(Geography__c,&quot;APAC&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EcoAssignToSharedServicesAmericas</fullName>
        <actions>
            <name>EcoSet_Shared_Services_AmericasQueue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(AssigntoSharedServices__c),AssigntoSharedServices__c = True, ISPICKVAL(Geography__c,&quot;Americas&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EcoAssignToSharedServicesEMEA</fullName>
        <actions>
            <name>EcoSet_Shared_Services_Queue_EMEA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(AssigntoSharedServices__c),AssigntoSharedServices__c = True, ISPICKVAL(Geography__c,&quot;EMEA&amp;I&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EcoGenerate Objects</fullName>
        <actions>
            <name>Generate_Objects</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Turn_Off_Validation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SharedServicesRequest__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EcoUnsetAssignedtoSharedServices</fullName>
        <actions>
            <name>EcoUnsetAssignToSharedServices</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISBLANK(Owner:Queue.Id)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
