<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Kathy_Coyne_when_project_added_for_a_client_that_should_be_confidential</fullName>
        <ccEmails>projectsystem@aecom.com</ccEmails>
        <description>Notify Kathy Coyne when project added for a client that should be confidential</description>
        <protected>false</protected>
        <recipients>
            <recipient>kathy.coyne@aecom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Projects_Need_to_be_Confidential</template>
    </alerts>
    <alerts>
        <fullName>Projects_with_Apple_as_client_to_be_made_confidential</fullName>
        <ccEmails>projectsystem@aecom.com</ccEmails>
        <description>Projects with Apple as client to be made confidential</description>
        <protected>false</protected>
        <recipients>
            <recipient>kathy.coyne@aecom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Projects_Need_to_be_Confidential</template>
    </alerts>
    <fieldUpdates>
        <fullName>CM_Checkbox</fullName>
        <description>Check when user profile is Content Manager - Americas</description>
        <field>Complete_CM_Review__c</field>
        <literalValue>1</literalValue>
        <name>CM Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ClearAlias</fullName>
        <field>Confidential_Owner_Alias__c</field>
        <name>ClearAlias</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PR_Clear_Alias</fullName>
        <field>Confidential_Owner_Alias__c</field>
        <name>PR Clear Alias</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PR_set_Alias</fullName>
        <field>Confidential_Owner_Alias__c</field>
        <formula>if(Len( Confidential_Owner_Alias__c) = 0,&quot;Confidential Owner&quot;, Confidential_Owner_Alias__c )</formula>
        <name>PR set Alias</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Date_Updated</fullName>
        <description>Set Last Date Updated to current date</description>
        <field>Date_Last_Update__c</field>
        <formula>Today()</formula>
        <name>Set Date Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Apple Projects to be Made Confidential</fullName>
        <actions>
            <name>Projects_with_Apple_as_client_to_be_made_confidential</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Legacy_Owner__c</field>
            <operation>contains</operation>
            <value>apple</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Legacy_Owner__c</field>
            <operation>notContain</operation>
            <value>appleton</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Legacy_Owner__c</field>
            <operation>notContain</operation>
            <value>applewhite</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Legacy_Owner__c</field>
            <operation>notContain</operation>
            <value>applecross</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Legacy_Owner__c</field>
            <operation>notContain</operation>
            <value>applewood</value>
        </criteriaItems>
        <description>Notify Kathy Coyne and projectsystem@aecom.com when an Apple project is created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CM Review Checkbox</fullName>
        <actions>
            <name>CM_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5</booleanFilter>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Content Manager - Americas</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>system administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.CreatedById</field>
            <operation>notContain</operation>
            <value>penrose</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.CreatedById</field>
            <operation>notContain</operation>
            <value>batchelder</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.CreatedById</field>
            <operation>notContain</operation>
            <value>fencl</value>
        </criteriaItems>
        <description>Checks the CM Review checkbox for records created by the NA marketing systems group.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Epa Region</fullName>
        <active>false</active>
        <description>Calculate EPA Region on Project Form</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify When Confidential Client Projects Created</fullName>
        <actions>
            <name>Notify_Kathy_Coyne_when_project_added_for_a_client_that_should_be_confidential</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5</booleanFilter>
        <criteriaItems>
            <field>Project__c.Legacy_Owner__c</field>
            <operation>contains</operation>
            <value>Microsoft</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Legacy_Owner__c</field>
            <operation>contains</operation>
            <value>Google</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Legacy_Owner__c</field>
            <operation>contains</operation>
            <value>Facebook</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Legacy_Owner__c</field>
            <operation>contains</operation>
            <value>Tesla</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Legacy_Owner__c</field>
            <operation>contains</operation>
            <value>amazon</value>
        </criteriaItems>
        <description>Sends an e-mail to Kathy Coyne and projectsystem@aecom.com when a project is created for a client that should be confidential.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PR Clear Client_WF</fullName>
        <actions>
            <name>PR_Clear_Alias</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Project__c.Confidential_Owner__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PR Set Client_WF</fullName>
        <actions>
            <name>PR_set_Alias</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Confidential_Owner__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Project - Epa Region</fullName>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Date Updated</fullName>
        <actions>
            <name>Set_Date_Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5</booleanFilter>
        <criteriaItems>
            <field>Project__c.CreatedById</field>
            <operation>equals</operation>
            <value>Kathy Coyne</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.CreatedById</field>
            <operation>equals</operation>
            <value>Lisa K Elfenbein</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.CreatedById</field>
            <operation>equals</operation>
            <value>Kari L Smith</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.CreatedById</field>
            <operation>equals</operation>
            <value>Karen J Van Keuren</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.CreatedById</field>
            <operation>equals</operation>
            <value>Carol Semeniuk</value>
        </criteriaItems>
        <description>On record creation, set Last Date Updated to current date</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Categories</fullName>
        <active>false</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Project__c.Project_Description__c</field>
            <operation>contains</operation>
            <value>prison</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Project_Description__c</field>
            <operation>contains</operation>
            <value>jail</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Project_Description__c</field>
            <operation>contains</operation>
            <value>correctional</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
