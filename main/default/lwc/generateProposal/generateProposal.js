import { LightningElement, api, wire } from 'lwc';
// importing navigationMixin to redirect user to Preview Doc screen
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import generateQuoteDoc from '@salesforce/apex/GenerateQuoteDocument.save';
import getTemplatesAndQuoteInfo from '@salesforce/apex/GenerateQuoteDocument.getTemplatesAndQuoteInfo';
import checkJobStatus from '@salesforce/apex/GenerateQuoteDocument.checkJobStatus';
import { getRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

// Quote Field API Names 
import NAME_FIELD from '@salesforce/schema/SBQQ__Quote__c.Name';
// NEW added Quote_Name__c to list of fields to compare in getRecord
import QUOTE_NAME_FIELD from '@salesforce/schema/SBQQ__Quote__c.Quote_Name__c';
import QUOTE_NAME_OVERRIDE_FIELD from '@salesforce/schema/SBQQ__Quote__c.Quote_Name_Override__c'
import QUOTE_TEMPLATE_FIELD from '@salesforce/schema/SBQQ__Quote__c.SBQQ__QuoteTemplateId__c'
const FIELDS = [NAME_FIELD, QUOTE_NAME_FIELD, QUOTE_NAME_OVERRIDE_FIELD, QUOTE_TEMPLATE_FIELD];

export default class GenerateQuoteDocument extends NavigationMixin(LightningElement) {
    // Quote Id
    @api recordId;
    isLoading = false;
    templateOptions = [];
    // Assigned template to Template combobox 
    selectedTemplateId;
    jobId;
    pollingInterval;
    retryCount = 0;
    maxRetries = 12;
    documentName = '';
    quoteName = '';
    // stored current templateId - updates if getRecord returns a new template Id
    currentTemplateId;
    // NEW stored currentQuoteName - updates if getRecord returns a new QuoteName
    currentQuoteName;

    // store wired data for refresh
    wiredData;
    wiredTemplatesResult;

    // Queries quote fields to ensure most up to date record values
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS }) 
    record({ data, error}) {
        if(data) {
            // Updates template Id if there is a stale Id assigned
            const newTemplateId = data.fields.SBQQ__QuoteTemplateId__c.value;
            // NEW newQuoteName to store latest value of Quote Name Override
            const newQuoteName = data.fields.Quote_Name__c.value;
            let refresh = false;

            if(this.currentTemplateId !== newTemplateId) {
                this.currentTemplateId = newTemplateId;
                refresh = true;
            }
            // NEW add currentQuoteName check to automatically update if different
            if(this.currentQuoteName !== newQuoteName) {
                this.currentQuoteName = newQuoteName;
                // this.documentName = this.currentQuoteName;
                refresh = true;
            }

            // NEW refresh check to run refreshTemplates if either Template Id or Quote Name is different
            if(refresh) {
                this.refreshTemplates();
            }
        } else if (error) {
            console.error('Error fetching record data:', error);
        }
    }

    @wire(getTemplatesAndQuoteInfo, { quoteId: '$recordId' })
    wiredTemplatesAndQuoteInfo(result) {
        this.wiredData = result;
        if (result.data) {
            this.templateOptions = result.data.templates.map(template => ({
                label: template.Name,
                value: template.Id
            }));
            // Sets default selection to first option if no defaultTemplateId is provided
            this.selectedTemplateId = result.data.defaultTemplateId || (this.templateOptions.length > 0 ? this.templateOptions[0].value : null);
            this.quoteName = result.data.quoteName;
            this.documentName = `${this.quoteName}`;
        } else if (result.error) {
            console.error('Error fetching templates and quote info:', result.error);
            this.showToast('Error', 'Failed to load quote templates and info', 'error');
        }
    }

    
    // refreshes the component's data - Default Template will change based on SBQQ__QuoteTemplateId__c change
    refreshTemplates() {
        console.log('Refreshing document name and template data due to recent changes...');

        // utilizing refeshApex to re-query the quote and template 
        refreshApex(this.wiredData)
        .then(() => {
            console.log('Document Name and Template data refreshed successfully');
        })
        .catch((error) => {
            console.log('Error refreshing document name and template data:', error);
            this.showToast('Error', 'Error refreshing document name and template data', 'error');
        });
    }


    handleTemplateChange(event) {
        this.selectedTemplateId = event.detail.value;
    }

    handleDocumentNameChange(event) {
        this.documentName = event.target.value;
    }

    // Tied to Generate Document button
    handleGenerateDocument() {
        console.log('Generate Document clicked. RecordId:', this.recordId, 'TemplateId:', this.selectedTemplateId);

        if (!this.recordId) {
            console.error('Quote ID is not available');
            this.showToast('Error', 'Quote ID is not available', 'error');
            return;
        }

        if (!this.selectedTemplateId) {
            console.error('Template ID is not selected');
            this.showToast('Error', 'Please select a template', 'error');
            return;
        }

        // NEW HC-30 added a character count on documentName, if greater than 80, throw error and return
        if (this.documentName.length > 80) {
            console.error('Document name is too long. Please keep within 80 characters');
            this.showToast('Error', 'Document name is too long. Please keep within 80 characters', 'error');
            return;
        }

        this.isLoading = true;

        const context = {
            name: this.documentName,
            quoteId: this.recordId,
            templateId: this.selectedTemplateId,
            outputFormat: 'PDF',
            language: 'en_US',
            paperSize: 'Default'
        };

        console.log('Sending context to Apex:', JSON.stringify(context));

        generateQuoteDoc({ contextMap: context })
            .then(result => {
                console.log('Document generation job started. Job ID:', result);
                this.jobId = result.replace(/"/g, ''); // Remove quotes
                this.showToast('Success', 'Quote document generation job started. Job ID: ' + this.jobId, 'success');
                setTimeout(() => {
                    this.startPolling();
                }, 2000); // Wait 2 seconds before starting to poll
            })
            .catch(error => {
                console.error('Error generating quote document:', error);
                this.showToast('Error', 'Error generating quote document: ' + error.body.message, 'error');
                this.isLoading = false;
            });
    }

    // Takes user to the SBQQ__PreviewDocument page to further see how document looks like before saving
    handlePreviewDocument() {
        console.log('Preview Document clicked. RecordId:', this.recordId);
        
        // Error handling if recordId is not available
        if(!this.recordId) {
            console.error('Quote Id is not available for preview');
            this.showToast('Error', 'Quote Id is not available', 'error');
            return;
        }

        // Direct user to SBQQ__PreviewDocument page
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: `/apex/SBQQ__PreviewDocument?id=${this.recordId}`
            }
        });
        
    }

    startPolling() {
        // First check immediately
        this.checkJobStatus();
        // Then poll every 5 seconds
        this.pollingInterval = setInterval(() => {
            this.checkJobStatus();
        }, 5000);
    }

    checkJobStatus() {
        console.log('Checking job status for Job ID:', this.jobId);
        // Passing jobId to apex method
        checkJobStatus({ jobId: this.jobId })
            .then(status => {
                console.log('Job status received:', status);
                if (status === 'Completed') {
                    this.showToast('Success', 'Quote document generation completed', 'success');
                    this.stopPolling();
                } else if (status === 'Failed') {
                    this.showToast('Error', 'Quote document generation failed', 'error');
                    this.stopPolling();
                } else if (status === 'Job not found') {
                    console.log('Job not found, will retry. Job ID:', this.jobId);
                    this.retryCount++;
                    if (this.retryCount >= this.maxRetries) {
                        console.log('Max retries reached. Stopping polling.');
                        this.showToast('Error', 'Unable to find job status after multiple attempts', 'error');
                        this.stopPolling();
                    }
                } else {
                    console.log('Job in progress. Status:', status);
                    this.retryCount = 0; // Reset retry count if we get a valid status
                }
            })
            .catch(error => {
                console.error('Error checking job status:', error);
                this.showToast('Error', 'Error checking job status: ' + error.body.message, 'error');
                this.stopPolling();
            });
    }

    stopPolling() {
        clearInterval(this.pollingInterval);
        this.isLoading = false;
        this.retryCount = 0;
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );
    }
}