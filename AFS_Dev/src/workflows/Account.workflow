<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populated_Standard_Account_Number_Field</fullName>
        <field>AccountNumber</field>
        <formula>Account_Number__c</formula>
        <name>Populated Standard Account Number Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CopyAuto Account Number to Standard Account Number Field</fullName>
        <actions>
            <name>Populated_Standard_Account_Number_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Source__c</field>
            <operation>equals</operation>
            <value>Salesforce</value>
        </criteriaItems>
        <description>This workflow will copy the auto account number to standard account number field</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
