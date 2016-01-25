<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_cost_components_N_A_checkbox_to_True</fullName>
        <field>Cost_Components_N_A__c</field>
        <literalValue>1</literalValue>
        <name>Set cost components N/A checkbox to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update</fullName>
        <field>Type__c</field>
        <formula>TEXT(PricebookEntry.Product2.Type__c)</formula>
        <name>Update Product Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_HW_SW_Costs_to_null</fullName>
        <field>HW_SW_Costs__c</field>
        <name>Update HW/SW Costs to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Other_Cost_Components_to_null</fullName>
        <field>Other_Cost_Components__c</field>
        <name>Update Other Cost Components to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Subcontractor_Expenses_to_null</fullName>
        <field>Subcontractor_Expenses__c</field>
        <name>Update Subcontractor Expenses to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Target_OI</fullName>
        <field>Target_OI__c</field>
        <formula>PricebookEntry.Product2.Target_OI__c</formula>
        <name>Update Target OI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Type_of_Work</fullName>
        <description>Update field Type of work in Opportunity Products Object</description>
        <field>Type_of_Work__c</field>
        <formula>TEXT(PricebookEntry.Product2.Type_of_Work__c)</formula>
        <name>Update Type of Work</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set cost components N%2FA checkbox to True</fullName>
        <actions>
            <name>Set_cost_components_N_A_checkbox_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.Type__c</field>
            <operation>equals</operation>
            <value>02 - BPO</value>
        </criteriaItems>
        <description>Set cost components N/A checkbox to True if Service Group = BPO</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Cost Components to null</fullName>
        <actions>
            <name>Update_HW_SW_Costs_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Other_Cost_Components_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Subcontractor_Expenses_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>OpportunityLineItem.HW_SW_Costs__c</field>
            <operation>greaterOrEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Other_Cost_Components__c</field>
            <operation>greaterOrEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Subcontractor_Expenses__c</field>
            <operation>greaterOrEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Type__c</field>
            <operation>equals</operation>
            <value>04 - MC</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
