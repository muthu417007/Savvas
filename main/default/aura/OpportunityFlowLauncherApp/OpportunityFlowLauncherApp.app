<!--
  *********************************************************
  Component Name       : OpportunityFlowLauncherApp
  Created Date         : 8/14/2024
  Author               : Frank Berni - Cognizant
  Description          : Aura App that launches ScreenFlow_NewOpportunity_FromAcct
  README:              : Assign URL without space between dashes to button: https://savvas- -dev3.sandbox.lightning.force.com/c/OpportunityFlowLauncherApp.app
  
  Modifications Log
  <Date>       <Author>            <Modification>
  8/14/2024     Frank Berni        Initial Version
  *********************************************************
-->
<!-- <aura:application access="GLOBAL" extends="ltng:outApp"> -->
  <!-- exnteds force:slds allows us to render the Flow without formatting issues -->
<aura:application extends="force:slds">

    <!-- Setting up lightning:flow - flowData. This will contain the ScreenFlow_NewOpportunity_FromAcct -->
    <lightning:flow aura:id="flowData" />

    <!-- In charge of running the function to start the flow -->
    <aura:handler name="init" value="{!this}" action="{!c.doInit}" />

</aura:application>