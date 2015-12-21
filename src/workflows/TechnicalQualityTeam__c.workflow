<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EcoTQT_Email_Lead_Verifier</fullName>
        <ccEmails>bjacobi@centerstance.com</ccEmails>
        <ccEmails>dandy.rodrigues@aecom.com</ccEmails>
        <description>EcoTQT Email Lead Verifier, Reviewer and Independent Reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>TechnicalQualityTeamMember__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EcoSystem_Templates/EcoTechnicalQualityTeamFYI</template>
    </alerts>
    <fieldUpdates>
        <fullName>EcoTQRRecalledStatusUpd</fullName>
        <description>Updates the technical quality reviewer status to recalled</description>
        <field>Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Eco TQR Recalled Status Upd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoTQRRejectedStatusUpd</fullName>
        <description>Updates the technical quality reviewer status to rejected</description>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Eco TQR Rejected Status Upd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Eco_TQR_Approved_Status_Upd</fullName>
        <description>Updates the technical quality reviewer status to approved</description>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Eco TQR Approved Status Upd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Eco_TQR_Submitted_Status_Upd</fullName>
        <description>Updates the technical quality reviewer status to submitted.</description>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Eco TQR Submitted Status Upd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EcoEmail TQT</fullName>
        <actions>
            <name>EcoTQT_Email_Lead_Verifier</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>send notification to the &quot;Reviewer&quot;, &quot;Lead Verifier&quot; and &quot;Independent Reviewer&quot;</description>
        <formula>AND(ISPICKVAL(Deliverable__r.Project__r.pse__Stage__c, &apos;Approved&apos;),
OR(ISNEW(),
ISCHANGED( TechnicalQualityTeamMember__c)),
OR(ISPICKVAL( Role__c,&apos;Reviewer&apos;),
ISPICKVAL( Role__c,&apos;Lead Verifier&apos;),
ISPICKVAL( Role__c,&apos;Independent Reviewer&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
