<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>EcoSetEndDateBeforeChange</fullName>
        <field>EndDateBeforeChange__c</field>
        <formula>PRIORVALUE(  pse__End_Date__c )</formula>
        <name>EcoSetEndDateBeforeChange</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoSetForecastEndDate</fullName>
        <field>ForecastEndDate__c</field>
        <formula>pse__End_Date__c</formula>
        <name>EcoSetForecastEndDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoSetForecastEndDatePlanning</fullName>
        <field>ForecastEndDate__c</field>
        <formula>pse__End_Date__c</formula>
        <name>EcoSetForecastEndDatePlanning</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoSetForecastStartDate</fullName>
        <field>ForecastStartDate__c</field>
        <formula>pse__Start_Date__c</formula>
        <name>EcoSetForecastStartDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoSetForecastStartDatePlanning</fullName>
        <field>ForecastStartDate__c</field>
        <formula>pse__Start_Date__c</formula>
        <name>EcoSetForecastStartDatePlanning</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoSetProjectTaskSyncRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Synced</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>EcoSetProjectTaskSyncRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoSetStartDateBeforeChange</fullName>
        <field>StartDateBeforeChange__c</field>
        <formula>PRIORVALUE( pse__Start_Date__c )</formula>
        <name>EcoSetStartDateBeforeChange</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EcoSet_Billable_to_True</fullName>
        <field>IsBillable__c</field>
        <literalValue>1</literalValue>
        <name>EcoSet Billable to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ecosystem_Unset_Chargeable</fullName>
        <description>Unsets the chargeable flag if the task is a parent</description>
        <field>IsChargeable__c</field>
        <literalValue>0</literalValue>
        <name>Ecosystem - Unset Chargeable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>External_Id_Update</fullName>
        <field>External_ID__c</field>
        <formula>CASESAFEID(Id)+ ProjectTaskNumber__c</formula>
        <name>External Id Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>External_Task_ID</fullName>
        <field>pse__External_Task_ID__c</field>
        <formula>ProjectNumber__c+ &quot; - &quot; +ProjectTaskNumber__c</formula>
        <name>External Task ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_PT_Set_Blocked</fullName>
        <description>Check Blocked</description>
        <field>pse__Blocked__c</field>
        <literalValue>1</literalValue>
        <name>PSA PT-Set Blocked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_PT_Set_Completed</fullName>
        <description>Check Completed</description>
        <field>pse__Completed__c</field>
        <literalValue>1</literalValue>
        <name>PSA PT-Set Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_PT_Set_Points_Baseline</fullName>
        <description>Set Points Baseline</description>
        <field>pse__Points_Baseline__c</field>
        <formula>pse__Estimated_Hours__c</formula>
        <name>PSA PT-Set Points Baseline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_PT_Set_Points_Complete_from_Actual</fullName>
        <description>Set Points Complete based on Actual Hours</description>
        <field>pse__Points_Complete__c</field>
        <formula>pse__Actual_Hours__c</formula>
        <name>PSA PT-Set Points Complete from Actual</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_PT_Set_Points_from_Actual</fullName>
        <description>Set Points from Actual Hours</description>
        <field>pse__Points__c</field>
        <formula>pse__Actual_Hours__c</formula>
        <name>PSA PT-Set Points from Actual</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_PT_Set_Points_from_Estimated_Hours</fullName>
        <description>Set Points from Estimated Hours</description>
        <field>pse__Points__c</field>
        <formula>pse__Estimated_Hours__c</formula>
        <name>PSA PT-Set Points from Estimated Hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_PT_Set_Started</fullName>
        <description>Check Started</description>
        <field>pse__Started__c</field>
        <literalValue>1</literalValue>
        <name>PSA PT-Set Started</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_PT_Set_Status_to_Blocked</fullName>
        <description>Set Status to Blocked</description>
        <field>pse__Status__c</field>
        <literalValue>Blocked</literalValue>
        <name>PSA PT-Set Status to Blocked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_PT_Set_Status_to_Complete</fullName>
        <description>Set Status to Complete</description>
        <field>pse__Status__c</field>
        <literalValue>Complete</literalValue>
        <name>PSA PT-Set Status to Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_PT_Set_Status_to_Started</fullName>
        <description>Set Status to Started</description>
        <field>pse__Status__c</field>
        <literalValue>Started</literalValue>
        <name>PSA PT-Set Status to Started</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Oracle_Project_Task_Unique_Name</fullName>
        <description>Sets the oracle project task unique name.  Project Number + Task Name</description>
        <field>OracleProjectTaskUniqueName__c</field>
        <formula>pse__Task_Number__c  + Name</formula>
        <name>EcoSet Oracle Project Task Unique Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Forecast_End_Date</fullName>
        <field>ForecastEndDate__c</field>
        <formula>IF(ISNULL( pse__Parent_Task__c ),Datevalue(pse__End_Date_Time__c), pse__Parent_Task__r.ForecastEndDate__c )</formula>
        <name>Update Forecast End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Forecast_Start_Date</fullName>
        <field>ForecastStartDate__c</field>
        <formula>IF(ISNULL( pse__Parent_Task__c ),Datevalue(pse__Start_Date_Time__c), pse__Parent_Task__r.ForecastStartDate__c )</formula>
        <name>Update Forecast Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EcoDefaultForecastEndDate</fullName>
        <actions>
            <name>EcoSetForecastEndDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISBLANK(ForecastEndDate__c)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EcoDefaultForecastStartDate</fullName>
        <actions>
            <name>EcoSetForecastStartDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISBLANK(ForecastStartDate__c)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EcoSet Billable to True</fullName>
        <actions>
            <name>EcoSet_Billable_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the IsBillable flag to true if a task is marked as Financial or Chargeable.</description>
        <formula>OR(IsChargeable__c=True, FinancialTask__c= True)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EcoSet Oracle Project Task Unique Name</fullName>
        <actions>
            <name>Set_Oracle_Project_Task_Unique_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Sets the oracle project task unique name</description>
        <formula>OR(ISNEW(),ISCHANGED(Name))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EcoSetForecastEndDatePlanning</fullName>
        <actions>
            <name>EcoSetForecastEndDatePlanning</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(NOT(ISCHANGED(ForecastEndDate__c)),
ISCHANGED(pse__End_Date__c),
IsTopLevelTask__c = False, 
OR(
ISPICKVAL(pse__Project__r.pse__Stage__c,&quot;Planning&quot;),
ISPICKVAL(pse__Project__r.pse__Stage__c,&quot;Pending Go/No Go&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EcoSetForecastStartDatePlanning</fullName>
        <actions>
            <name>EcoSetForecastStartDatePlanning</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(NOT(ISCHANGED(ForecastStartDate__c)),
ISCHANGED(pse__Start_Date__c),
IsTopLevelTask__c = False, 
OR(
ISPICKVAL(pse__Project__r.pse__Stage__c,&quot;Planning&quot;),
ISPICKVAL(pse__Project__r.pse__Stage__c,&quot;Pending Go/No Go&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EcoSetProjectTaskSyncRecordType</fullName>
        <actions>
            <name>EcoSetProjectTaskSyncRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>pse__Project_Task__c.OracleSyncStatus__c</field>
            <operation>equals</operation>
            <value>S,T</value>
        </criteriaItems>
        <description>Sets the project task record type to synced.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PSA PT-Check Blocked when Status is set to %22Blocked%22 and Blocked is not checked</fullName>
        <actions>
            <name>PSA_PT_Set_Blocked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Status__c</field>
            <operation>equals</operation>
            <value>Blocked</value>
        </criteriaItems>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Blocked__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Summary__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Check Blocked when Status is set to &quot;Blocked&quot; and Blocked is not checked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PSA PT-Check Completed when Status is set to %22Completed%22 and Completed is not checked</fullName>
        <actions>
            <name>PSA_PT_Set_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Status__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Completed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Summary__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Check Completed when Status is set to &quot;Completed&quot; and Completed is not checked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PSA PT-Check Started when Status is set to %22Started%22 and Started is not checked Object Project Task</fullName>
        <actions>
            <name>PSA_PT_Set_Started</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Status__c</field>
            <operation>equals</operation>
            <value>Started</value>
        </criteriaItems>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Started__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Summary__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Check Started when Status is set to &quot;Started&quot; and Started is not checked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PSA PT-Set Points Baseline from Estimated Hours</fullName>
        <actions>
            <name>PSA_PT_Set_Points_Baseline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Set Points Baseline from Estimated Hours if Points Baseline is 0.</description>
        <formula>IF( pse__Summary__c = false, OR( ISNEW(),     AND( ISCHANGED( pse__Estimated_Hours__c ),          OR( pse__Points_Baseline__c = 0,              ISBLANK( pse__Points_Baseline__c )          )     ) ) , false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PSA PT-Set Points Complete and Update Points when Actual Hours %3E Estimated Hours</fullName>
        <actions>
            <name>PSA_PT_Set_Points_Complete_from_Actual</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSA_PT_Set_Points_from_Actual</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Points Complete and update Points when (1) Actual Hours is greater than Estimated Hours OR (2) Project Task is complete</description>
        <formula>IF( pse__Summary__c = false,   AND(   OR( pse__Actual_Hours__c &gt; pse__Estimated_Hours__c,      AND(OR( pse__Completed__c = true,             AND(ISCHANGED(pse__Percent_Complete_Points__c ),                 pse__Percent_Complete_Points__c = 1             )         ),         pse__Actual_Hours__c &lt;&gt;  pse__Points_Complete__c      )          )  ) , false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PSA PT-Set Points Complete when Actual Hours %3C Estimated Hours</fullName>
        <actions>
            <name>PSA_PT_Set_Points_Complete_from_Actual</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Points Complete when Actual Hours is less than Estimated Hours</description>
        <formula>IF( pse__Summary__c = false,      pse__Actual_Hours__c &lt; pse__Estimated_Hours__c,      false  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PSA PT-Set Points when Estimated Hours %3E Points</fullName>
        <actions>
            <name>PSA_PT_Set_Points_from_Estimated_Hours</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Points when Estimated Hours is greater than Points or Actual Hours is 0.</description>
        <formula>IF( pse__Summary__c = false,       OR( pse__Estimated_Hours__c &gt; pse__Points__c ,          pse__Actual_Hours__c = 0      )  , false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PSA PT-Update Status to Blocked when Blocked is checked and status is not %22Blocked%22</fullName>
        <actions>
            <name>PSA_PT_Set_Status_to_Blocked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Blocked__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Status__c</field>
            <operation>notEqual</operation>
            <value>Blocked</value>
        </criteriaItems>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Summary__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Update Status when Completed is checked and status is not &quot;Blocked&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PSA PT-Update Status to Complete when Completed is checked and status is not %22Complete%22</fullName>
        <actions>
            <name>PSA_PT_Set_Status_to_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Status__c</field>
            <operation>notEqual</operation>
            <value>Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Summary__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Update Status when Completed is checked and status is not &quot;Complete&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PSA PT-Update Status to Started when Started is checked and status is %22Draft%22 or %22Planned%22</fullName>
        <actions>
            <name>PSA_PT_Set_Status_to_Started</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Started__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Status__c</field>
            <operation>equals</operation>
            <value>Draft,Planned</value>
        </criteriaItems>
        <criteriaItems>
            <field>pse__Project_Task__c.pse__Summary__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Update Status when Started is checked and status is &quot;Draft&quot; or &quot;Planned&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update External Field</fullName>
        <actions>
            <name>External_Id_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>pse__Project_Task__c.OracleSyncStatus__c</field>
            <operation>equals</operation>
            <value>S</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Forecast Date</fullName>
        <actions>
            <name>Update_Forecast_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Forecast_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>pse__Project_Task__c.ForecastStartDate__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>pse__Project_Task__c.ForecastEndDate__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Project Ext Task Id</fullName>
        <actions>
            <name>External_Task_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(ISBLANK(pse__External_Task_ID__c),
NOT(ISBLANK(ProjectNumber__c)),
NOT(ISBLANK(ProjectTaskNumber__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
