/*
*********************************************************
Class Name       : quoteLineExport
Created Date     : 08/22/2024  
Author           : Frank Berni - Cognizant
Description      : Lightning web component tied to Export Quote Lines button, headless quick action to download csv file of related quote lines
README           : HTML contains additional information on meta.XML setup 


History:
<Date>          <Authors Name>              <Brief Description of Change>
08/22/2024      Frank Berni                  Ticket W-015737: Initial creation - LWC version of Exporting Quote Lines
**********************************************************/
import { LightningElement, api } from 'lwc';
// importing the generateQuoteLineCsv method from Apex
import generateQuoteLineCsv from '@salesforce/apex/QuoteLineExportController.generateQuoteLineCsv';

export default class QuoteLineExport extends LightningElement {
    // Since the recordId is not immediately called during a headless quick action, getters and setters are used 
    // to grab the recordId for the Apex method
    _recordId;

    @api
    get recordId() {
        return this._recordId;
    }

    set recordId(value) {
        this._recordId = value;
    }

    // invoke is exposed here in order to run our handleExport function
    @api
    invoke() {
        this.handleExport();
    }

    // This function calls the generateQuoteLineCsv, grabs the csvContent made in the controoler and uses the downloadCsv function to download
    // The quick action is then closed via closeQuickAction
    handleExport() {
        if (!this._recordId) {
            console.error('Record ID is undefined.');
            return;
        }

        generateQuoteLineCsv({ quoteId: this._recordId })
            .then(result => {
                const csvContent = result.csvContent;
                const quoteName = result.quoteName;
                // We want the fileName to reflect the Quote's Name
                const filename = `Export Quote Lines - ${quoteName}.csv`;

                this.downloadCsv(csvContent, filename);
                this.closeQuickAction();
            })
            .catch(error => {
                // error handling, prints to console
                console.error('Error generating CSV:', error);
                this.closeQuickAction();
            });
    }

    // Takes in the csvContent and fileName set up in generateQuoteLinesCsv
    downloadCsv(dataUrl, filename) {
        // create a temporary anchor element (<a>) in the document
        const link = document.createElement('a');
        // href is set to the csvContent
        link.href = dataUrl;
        // download is set to the fileName
        link.download = filename;
        // append the link to the body of the document
        document.body.appendChild(link);
        // programmatically click the link to trigger the download
        link.click();
        // Remove the link from the document after the download is triggered
        document.body.removeChild(link);
    }

    // This function immediately closes the window without an action from user
    closeQuickAction() {
        this.dispatchEvent(new CustomEvent('close'));
    }
}