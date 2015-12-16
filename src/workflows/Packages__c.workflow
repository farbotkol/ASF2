<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>EcoSetBimHealthyStartEmail</fullName>
        <description>Sets the BIM healthy start email field</description>
        <field>BIMHealthyStartEmail__c</field>
        <formula>IF(ISPICKVAL( Scope_Owner__r.Project__r.Owner:User.Geography_Allocation__c , &quot;Americas&quot;),&quot;NA-BIMHealthyStart@aecom.com.test&quot;, 
IF(ISPICKVAL(Scope_Owner__r.Project__r.Owner:User.Geography_Allocation__c,&quot;Asia&quot;),&quot;APAC-BIMHealthyStart@aecom.com.test&quot;, 
IF(OR(ISPICKVAL(Scope_Owner__r.Project__r.Owner:User.Geography_Allocation__c,&quot;Europe&quot;),ISPICKVAL(Scope_Owner__r.Project__r.Owner:User.Geography_Allocation__c,&quot;Middle East&quot;)),&quot;EMEA-BIMHealthyStart@aecom.com.test&quot;,null)))</formula>
        <name>EcoSet Bim Healthy Start Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateName</fullName>
        <field>Name</field>
        <formula>PackageTitle__c</formula>
        <name>UpdateName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_isChanged</fullName>
        <field>ChangeManagerIsChanged__c</field>
        <literalValue>1</literalValue>
        <name>Update isChanged</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EcoSet Bim Healthy Start Email</fullName>
        <actions>
            <name>EcoSetBimHealthyStartEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the BIM healthy start email field</description>
        <formula>OR(ISNEW(),ISCHANGED( OwnerId ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IsChanged</fullName>
        <actions>
            <name>Update_isChanged</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( PRIORVALUE( Scope_Approach__c ) &lt;&gt; Scope_Approach__c  || 
PRIORVALUE( Scope_Details__c ) &lt;&gt; Scope_Details__c ||
TEXT(PRIORVALUE(  Status__c  )) &lt;&gt; TEXT(Status__c)
, true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Name</fullName>
        <actions>
            <name>UpdateName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>if(Name  &lt;&gt;  PackageTitle__c, true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
