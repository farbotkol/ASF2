<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Service Catalog TPG%E2%80%99s</fullName>
        <active>false</active>
        <formula>AND(ISPICKVAL(TPG__c,&quot;Acoustics&quot;), RecordTypeId=&quot;012M00000000kA&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
