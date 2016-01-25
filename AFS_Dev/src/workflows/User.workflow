<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Azure_Email_Alert</fullName>
        <description>Azure Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>raymond.s.garcia@accenturefederal.com.smart</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Visualforce_Email_Templates/AzureTestTemplate</template>
    </alerts>
    <rules>
        <fullName>AzureCheck</fullName>
        <actions>
            <name>Azure_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(ISCHANGED(   IsActive   ), ISCHANGED(    Email    ), ISCHANGED( Username )), $User.Alias  = &apos;RGarcia&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
