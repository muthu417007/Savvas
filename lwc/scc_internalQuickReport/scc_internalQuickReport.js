/***************************************************************************************
* @Class Name: Scc_internalQuickReport 
* @Description:  this component used for Scc_internalQuickReport
* @Created By: Sudha Rani Pathivada
* @Created On: 09/07/2024
* **************************************************************************************
* Modification Log:
* -------------------------------------------------------------------------------------
* Developer        Date            Description
* -------------------------------------------------------------------------------------
*/

import { LightningElement } from 'lwc';
export default class Scc_internalQuickReport extends LightningElement {
 navigateToReport() {
        // Get the current Salesforce org base URL
        const baseUrl = window.location.origin;
        // Define the relative path you want to navigate to
        const reportUrl = '/lightning/o/Report/home?queryScope=mru';
        // Construct the full URL
        const fullUrl = `${baseUrl}${reportUrl}`;
        // Navigate to the full URL
        window.location.href = fullUrl;
    }
}