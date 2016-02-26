<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Notification_for_ATS_Approval_for_Status_Stage_Requested_to_2B</fullName>
        <description>Email Notification for ATS Approval for Status/Stage Requested to 2B</description>
        <protected>false</protected>
        <recipients>
            <recipient>lhea@accenturefederal.com.smart</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visualforce_Email_Templates/APPROVAL_TO_SUBMIT</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_for_ATS_Approval_for_Status_Stage_Requested_to_2B_ASM</fullName>
        <description>Email Notification for ATS Approval for Status/Stage Requested to 2B for ASM</description>
        <protected>false</protected>
        <recipients>
            <recipient>kenneth.a.morris@accenturefederal.com.smart</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lhea@accenturefederal.com.smart</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visualforce_Email_Templates/APPROVAL_TO_SUBMIT</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_OSP_Generate_Approval_Email</fullName>
        <description>Send Email to OSP - Generate Approval Email</description>
        <protected>false</protected>
        <recipients>
            <field>Generate_User_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visualforce_Email_Templates/Approval_Email_template</template>
    </alerts>
    <alerts>
        <fullName>Send_Trade_Compliance_Guidance_Letter_to_Opp_Sales_Lead</fullName>
        <description>Send Trade Compliance Guidance Letter to Opp Sales Lead</description>
        <protected>false</protected>
        <recipients>
            <recipient>farzaam.esmaeilian@accenturefederal.com.smart</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Trade_Compliance_Team_Guidance_Letter_Test_Official</template>
    </alerts>
    <alerts>
        <fullName>Send_notification_to_Legal</fullName>
        <description>Send notification to Legal</description>
        <protected>false</protected>
        <recipients>
            <recipient>barbara.j.overall@accenturefederal.com.smart</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lhea@accenturefederal.com.smart</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Export_Compliance_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Copy_Opportunity_Auto_Number_to_Opp_ID</fullName>
        <field>Opportunity_ID__c</field>
        <formula>Opportunity_Auto_Id__c</formula>
        <name>Copy Opportunity Auto Number to Opp ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Duplicate_Opportunity_Field_Update</fullName>
        <field>TEC_Opportunity_Name__c</field>
        <formula>Name</formula>
        <name>Check if Opp Name value is duplicate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Stage_to_0</fullName>
        <field>StageName</field>
        <literalValue>0</literalValue>
        <name>Opp Stage to 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Stage_to_1A</fullName>
        <field>StageName</field>
        <literalValue>1A</literalValue>
        <name>Opp Stage to 1A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Stage_to_1B</fullName>
        <field>StageName</field>
        <literalValue>1B</literalValue>
        <name>Opp Stage to 1B</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Stage_to_2A</fullName>
        <field>StageName</field>
        <literalValue>2A</literalValue>
        <name>Opp Stage to 2A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Stage_to_2B</fullName>
        <field>StageName</field>
        <literalValue>2B</literalValue>
        <name>Opp Stage to 2B</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Stage_to_3</fullName>
        <field>StageName</field>
        <literalValue>3</literalValue>
        <name>Opp Stage to 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Opp_Account_Plan_OI_Field</fullName>
        <field>Account_Plan_OI__c</field>
        <formula>Account.Account_Plan_OI__c</formula>
        <name>Populate Opp Account Plan OI Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Project_ID_Created_Date</fullName>
        <field>Project_IDs_Creation_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Project ID Creation Date to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reporting_Status_to_AFS_Withdrew</fullName>
        <field>Reporting_Status__c</field>
        <literalValue>AFS Withdrew</literalValue>
        <name>Reporting Status to AFS Withdrew</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reporting_Status_to_Client_Withdrew</fullName>
        <field>Reporting_Status__c</field>
        <literalValue>Client Withdrew</literalValue>
        <name>Reporting Status to Client Withdrew</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reporting_Status_to_Closed</fullName>
        <field>Reporting_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Reporting Status to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reporting_Status_to_Lost</fullName>
        <field>Reporting_Status__c</field>
        <literalValue>Lost</literalValue>
        <name>Reporting Status to Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reporting_Status_to_Pipeline</fullName>
        <field>Reporting_Status__c</field>
        <literalValue>Qualified</literalValue>
        <name>Reporting Status to Pipeline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reporting_Status_to_Unqualified</fullName>
        <field>Reporting_Status__c</field>
        <literalValue>Unqualified</literalValue>
        <name>Reporting Status to Unqualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reporting_Status_to_Won</fullName>
        <field>Reporting_Status__c</field>
        <literalValue>Won</literalValue>
        <name>Reporting Status to Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_1A_Entry_Date_Today</fullName>
        <field>Stage_1A_Entry_Date__c</field>
        <formula>Today()</formula>
        <name>Stage 1A Entry Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_1B_Entry_Date_Today</fullName>
        <field>Stage_1B_Entry_Date__c</field>
        <formula>Today()</formula>
        <name>Stage 1B Entry Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_2A_Entry_Date_Today</fullName>
        <field>Stage_2A_Entry_Date__c</field>
        <formula>Today()</formula>
        <name>Stage 2A Entry Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_2B_Entry_Date_Today</fullName>
        <field>Stage_2B_Entry_Date__c</field>
        <formula>Today()</formula>
        <name>Stage 2B Entry Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_3_Entry_Date_Today</fullName>
        <field>Stage_3_Entry_Date__c</field>
        <formula>Today()</formula>
        <name>Stage 3 Entry Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Since_to_Today</fullName>
        <field>Reporting_Status_Since__c</field>
        <formula>Today()</formula>
        <name>Set Reporting Status Since to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_AFS_High_Priority_Deal_to_null</fullName>
        <description>Update AFS High Priority Deal to null</description>
        <field>AFS_High_Priority_Deal__c</field>
        <literalValue>0</literalValue>
        <name>Update AFS High Priority Deal to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approved_Stage_to_0</fullName>
        <description>Used for cloned/New opportunities</description>
        <field>Approved_Status_Stage__c</field>
        <literalValue>0</literalValue>
        <name>Update Approved Stage to 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Capture_Status_to_null</fullName>
        <description>Update Capture Status to null</description>
        <field>Capture_Status__c</field>
        <name>Update Capture Status to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_OSP_Notes_to_null</fullName>
        <field>OSP_Notes__c</field>
        <name>Update OSP Notes to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Probability</fullName>
        <description>Update Probability and Win Probability when Approved Stage = Won</description>
        <field>Probability</field>
        <formula>1.0</formula>
        <name>Update Probability</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rep_Stat_to_Unqualified</fullName>
        <field>Reporting_Status__c</field>
        <literalValue>Unqualified</literalValue>
        <name>Update Rep Stat to Unqualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ReportingStatus_Date_field</fullName>
        <description>Auto-populate the Reporting Status Date field.</description>
        <field>Reporting_Status_Since__c</field>
        <formula>Today()</formula>
        <name>Update ReportingStatus Date field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Send_Email_To_OSP_to_False</fullName>
        <field>Send_Email_to_OSP__c</field>
        <literalValue>0</literalValue>
        <name>Update Send Email To OSP to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Source_to_Salesforce</fullName>
        <field>Source__c</field>
        <literalValue>Salesforce</literalValue>
        <name>Update Source to Salesforce</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_1A_Entry_Date_to_null</fullName>
        <description>Update Stage 1A Entry Date to null</description>
        <field>Stage_1A_Entry_Date__c</field>
        <name>Update Stage 1A Entry Date to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_1B_Entry_Date_to_null</fullName>
        <description>Update Stage 1B Entry Date to null</description>
        <field>Stage_1B_Entry_Date__c</field>
        <name>Update Stage 1B Entry Date to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_2A_Entry_Date_to_null</fullName>
        <description>Update Stage 2A Entry Date to null</description>
        <field>Stage_2A_Entry_Date__c</field>
        <name>Update Stage 2A Entry Date to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_2B_Entry_Date_to_null</fullName>
        <description>Update Stage 2B Entry Date to null</description>
        <field>Stage_2B_Entry_Date__c</field>
        <name>Update Stage 2B Entry Date to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_3_Entry_Date</fullName>
        <description>Update Stage 3 Entry Date to null</description>
        <field>Stage_3_Entry_Date__c</field>
        <name>Update Stage 3 Entry Date to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_Status_Request_to_0</fullName>
        <description>This will update the status stage to 0</description>
        <field>Status_Stage_Requested__c</field>
        <literalValue>0</literalValue>
        <name>Update Stage Status Request to 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_Status_Request_to_1A</fullName>
        <field>Status_Stage_Requested__c</field>
        <literalValue>1A</literalValue>
        <name>Update Stage Status Request to 1A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_Status_Request_to_1B</fullName>
        <field>Status_Stage_Requested__c</field>
        <literalValue>1B</literalValue>
        <name>Update Stage Status Request to 1B</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_Status_Request_to_2A</fullName>
        <field>Status_Stage_Requested__c</field>
        <literalValue>2A</literalValue>
        <name>Update Stage Status Request to 2A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_Status_Request_to_2B</fullName>
        <field>Status_Stage_Requested__c</field>
        <literalValue>2B</literalValue>
        <name>Update Stage Status Request to 2B</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_Status_Request_to_3</fullName>
        <field>Status_Stage_Requested__c</field>
        <literalValue>3</literalValue>
        <name>Update Stage Status Request to 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Std_Probability_Field</fullName>
        <field>Probability</field>
        <formula>CASE(
VALUE(TEXT(Win_Probability__c)),
10,0.1,
35,0.35,
50,0.5,
70,0.7,
90,0.9,
100,1.0,
NULL
)</formula>
        <name>Update Std Probability Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ToT_Category_to_null</fullName>
        <description>Update ToT Category to null</description>
        <field>ToT_Category__c</field>
        <name>Update ToT Category to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Top_Opportunity_to_null</fullName>
        <description>Update Top Opportunity to null</description>
        <field>Top_Opportunity__c</field>
        <name>Update Top Opportunity to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_stage_to_stage_0</fullName>
        <field>StageName</field>
        <literalValue>0</literalValue>
        <name>Update stage to stage 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Win_probability_update_to_100</fullName>
        <description>Update win probability to 100% when approved status stage is equal to &quot;won&quot;</description>
        <field>Win_Probability__c</field>
        <literalValue>100</literalValue>
        <name>Win probability update to 100</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ATS Approval on Stage Requested to 2B</fullName>
        <actions>
            <name>Email_Notification_for_ATS_Approval_for_Status_Stage_Requested_to_2B</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>If Approved Stage = 2B, send ATS approval notification</description>
        <formula>AND( ISCHANGED( Status_Stage_Requested__c ),  ISPICKVAL( Status_Stage_Requested__c , &apos;2B&apos;), Portfolio__c &lt;&gt; &apos;Defense - ASM&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ATS Approval on Stage Requested to 2B for ASM</fullName>
        <actions>
            <name>Email_Notification_for_ATS_Approval_for_Status_Stage_Requested_to_2B_ASM</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>If Approved Stage = 2B and Portfolio = &quot;Defense - ASM&quot;, send ATS approval notification</description>
        <formula>AND( ISCHANGED( Status_Stage_Requested__c ),  ISPICKVAL( Status_Stage_Requested__c , &apos;2B&apos;), Portfolio__c = &apos;Defense - ASM&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Approved Stage %3D 0</fullName>
        <actions>
            <name>Opp_Stage_to_0</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Stage_Status_Request_to_0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Approved_Status_Stage__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>If Approved Status/Stage = 0, update reporting status to unqualified and current stage to 0.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Approved Stage %3D 1A</fullName>
        <actions>
            <name>Opp_Stage_to_1A</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Stage_Status_Request_to_1A</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Approved_Status_Stage__c</field>
            <operation>equals</operation>
            <value>1A</value>
        </criteriaItems>
        <description>If Approved Stage = 1A, update reporting status to pipeline and current stage to 1A.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Approved Stage %3D 1B</fullName>
        <actions>
            <name>Opp_Stage_to_1B</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Stage_Status_Request_to_1B</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Approved_Status_Stage__c</field>
            <operation>equals</operation>
            <value>1B</value>
        </criteriaItems>
        <description>If Approved Stage = 1B, update reporting status to pipeline and current stage to 1B.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Approved Stage %3D 2A</fullName>
        <actions>
            <name>Opp_Stage_to_2A</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Stage_Status_Request_to_2A</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Approved_Status_Stage__c</field>
            <operation>equals</operation>
            <value>2A</value>
        </criteriaItems>
        <description>If Approved Stage = 2A, update reporting status to pipeline and current stage to 2A.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Approved Stage %3D 2B</fullName>
        <actions>
            <name>Opp_Stage_to_2B</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Stage_Status_Request_to_2B</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Approved_Status_Stage__c</field>
            <operation>equals</operation>
            <value>2B</value>
        </criteriaItems>
        <description>If Approved Stage = 2B, update reporting status to pipeline and current stage to 2B.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Approved Stage %3D 3</fullName>
        <actions>
            <name>Opp_Stage_to_3</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Stage_Status_Request_to_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Approved_Status_Stage__c</field>
            <operation>equals</operation>
            <value>3</value>
        </criteriaItems>
        <description>If Approved Stage = 3, update reporting status to pipeline and current stage to 3.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Check if Opp Name value is duplicate</fullName>
        <actions>
            <name>Duplicate_Opportunity_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Check if Opp Name value is duplicate</description>
        <formula>OR ( ISBLANK(TEC_Opportunity_Name__c), ISCHANGED( Name ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Probability%27s value</fullName>
        <actions>
            <name>Update_Std_Probability_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <description>Update Probability Field when Opportunity Name is not null</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Account Plan OI%25</fullName>
        <actions>
            <name>Populate_Opp_Account_Plan_OI_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <description>This workflow will populate the Account Plan OI% in Opportunity with the value of Account Plan OI% in Account.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Email to OSP - Generate Approval Email</fullName>
        <actions>
            <name>Send_Email_to_OSP_Generate_Approval_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Send_Email_To_OSP_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Send_Email_to_OSP__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send email to Legal - Trade compliance</fullName>
        <actions>
            <name>Send_notification_to_Legal</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends a notification email to Legal, based on answers to any of the trade compliance questions in the Legal section of the Opportunity object such as a response of Yes or I am not sure.</description>
        <formula>OR(  	 	AND(  		ISCHANGED(Subject_countries_client_operates__c),  		INCLUDES(Subject_countries_client_operates__c , &apos;I am not sure, please contact me&apos;) 	), 	AND(  		ISCHANGED(Client_Industry_Area_of_Service__c),  		INCLUDES(Client_Industry_Area_of_Service__c , &apos;Aerospace &amp; Defense&apos;) 	), 	AND(  		ISCHANGED(Client_Industry_Area_of_Service__c),  		INCLUDES( Client_Industry_Area_of_Service__c , &apos;I am not sure, please contact me&apos;)  	),  	AND(  		ISCHANGED(Export_Transfer_of_Products_Software__c),  		OR(ISPICKVAL(Export_Transfer_of_Products_Software__c , &apos;I am not sure, please contact me&apos;),ISPICKVAL(Export_Transfer_of_Products_Software__c , &apos;Yes&apos;)  )	),  	AND(  		ISCHANGED(The_Opportunity_involves_activities_now__c),  		OR(ISPICKVAL(The_Opportunity_involves_activities_now__c , &apos;I am not sure, please contact me&apos;),ISPICKVAL(The_Opportunity_involves_activities_now__c , &apos;Yes&apos;)  	)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Project ID Creation Date to Today</fullName>
        <actions>
            <name>Project_ID_Created_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Project_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Date Project IDs Were Created</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Reporting Status Since to Today</fullName>
        <actions>
            <name>Status_Since_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If approved stage is changed, update Reporting Status Date to Today&apos;s Date.</description>
        <formula>(ISCHANGED(Approved_Status_Stage__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Id for Source SFDC</fullName>
        <actions>
            <name>Copy_Opportunity_Auto_Number_to_Opp_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Source__c</field>
            <operation>equals</operation>
            <value>Salesforce</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Sales Ops Section</fullName>
        <actions>
            <name>Update_AFS_High_Priority_Deal_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Capture_Status_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_OSP_Notes_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Stage_1A_Entry_Date_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Stage_1B_Entry_Date_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Stage_2A_Entry_Date_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Stage_2B_Entry_Date_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Stage_3_Entry_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_ToT_Category_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Top_Opportunity_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Source__c</field>
            <operation>equals</operation>
            <value>Salesforce</value>
        </criteriaItems>
        <description>Update Sales Ops Section</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Source to Salesforce</fullName>
        <actions>
            <name>Copy_Opportunity_Auto_Number_to_Opp_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Source_to_Salesforce</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <description>Source field will be updated to Salesforce everytime an opportunity is cloned</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update cloned opportunity</fullName>
        <actions>
            <name>Update_Approved_Stage_to_0</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Rep_Stat_to_Unqualified</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_stage_to_stage_0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Source__c</field>
            <operation>equals</operation>
            <value>Salesforce</value>
        </criteriaItems>
        <description>If new opportunity record is created/cloned, update current stage to 0, reporting status to unqualified, and status/stage requested to 0.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Won_Opp_to_full_win_percentage</fullName>
        <actions>
            <name>Update_Probability</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Win_probability_update_to_100</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Approved_Status_Stage__c</field>
            <operation>equals</operation>
            <value>Won</value>
        </criteriaItems>
        <description>Workflow to make percent win percentage 100% when the opportunity is won.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Task_to_CAL</fullName>
        <assignedTo>Client Account Lead</assignedTo>
        <assignedToType>accountTeam</assignedToType>
        <description>This is a comment</description>
        <dueDateOffset>-10</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Task to CAL</subject>
    </tasks>
    <tasks>
        <fullName>Task_to_OSP</fullName>
        <assignedTo>OSP</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>This is a comment.</description>
        <dueDateOffset>-5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Task to OSP</subject>
    </tasks>
</Workflow>
