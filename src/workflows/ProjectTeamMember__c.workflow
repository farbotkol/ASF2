<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ECO_Request_Task_Manager_Input</fullName>
        <description>ECO Request Task Manager Input</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/Request_Task_Manager_Input</template>
    </alerts>
    <alerts>
        <fullName>EcoSendPMSupervisorInactivityEmail</fullName>
        <ccEmails>bjacobi@centerstance.com</ccEmails>
        <ccEmails>dandy.rodrigues@aecom.com</ccEmails>
        <description>EcoSendPMSupervisorInactivityEmail</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/EcoProjectManagerInactiveSupervisor</template>
    </alerts>
    <alerts>
        <fullName>EcoSendProjectApproverInactivityEmail</fullName>
        <ccEmails>bjacobi@centerstance.com</ccEmails>
        <ccEmails>dandy.rodrigues@aecom.com</ccEmails>
        <description>EcoSendProjectApproverInactivityEmail</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/EcoProjectManagerInactiveProjectApprover</template>
    </alerts>
    <fieldUpdates>
        <fullName>ECO_Request_Task_Manager_Input_Reset</fullName>
        <field>Request_Input__c</field>
        <literalValue>0</literalValue>
        <name>ECO Request Task Manager Input Reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoTestUpdate</fullName>
        <field>TestField__c</field>
        <formula>&quot;IT WORKS!&quot;</formula>
        <name>EcoTestUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Non_Delegated_PTM_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Non Delegated PTM Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Non_Delegated_PTM_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Non Delegated PTM Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ECO Request Task Manager Input</fullName>
        <actions>
            <name>ECO_Request_Task_Manager_Input</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ECO_Request_Task_Manager_Input_Reset</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ProjectTeamMember__c.Request_Input__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Eco Project Manager Inactive</fullName>
        <actions>
            <name>EcoSendPMSupervisorInactivityEmail</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>EcoSendProjectApproverInactivityEmail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Emails the PM supervisor and the Project Approver when the PM becomes inactive.</description>
        <formula>AND(NotifyChange__c = True,
ProjectRole__r.Name = &quot;Project Manager&quot; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
