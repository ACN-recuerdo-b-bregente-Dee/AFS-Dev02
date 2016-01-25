<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copy_Value_of_Attribute_TCR</fullName>
        <field>Digital_TCR__c</field>
        <formula>Attribute_TCR__c</formula>
        <name>Copy Value of Attribute TCR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy Value of Attribute TCR</fullName>
        <actions>
            <name>Copy_Value_of_Attribute_TCR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Attribute__c.Name</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Accenture Digital%3F to No</fullName>
        <active>true</active>
        <description>Set Accenture Digital? to No</description>
        <formula>NOT(ISPICKVAL(Attribute_Type__c, &quot;Accenture Digital&quot;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Accenture Digital%3F to Yes</fullName>
        <active>true</active>
        <description>Set Accenture Digital? to Yes</description>
        <formula>ISPICKVAL(Attribute_Type__c, &quot;Accenture Digital&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
