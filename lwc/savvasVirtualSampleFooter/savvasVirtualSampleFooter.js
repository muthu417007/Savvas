import { LightningElement, wire } from 'lwc';
import getFooterData from '@salesforce/apex/SavvasVirtualSampleFooterCtrl.getFooterData';
import { loadStyle } from 'lightning/platformResourceLoader';
import fetchCssFileFromAttachment from '@salesforce/apex/SavvasVirtualSampleFooterCtrl.fetchCssFileFromAttachment';
import savvaasstyle from '@salesforce/resourceUrl/SavvasVirtualSampleImages';
import footerCssLabel from '@salesforce/label/c.Savvas_Virtual_Sample_Footer_CSS';


export default class SavvasVirtualSampleFooter extends LightningElement {
    caret = savvaasstyle + '/Images/caret.png';
    topMetadataRecords = [];
    bottomMetadataRecords = [];
    childLinks = [{ key: "", value: "" }];
    label = { footerCssLabel };
    stateprogramsKey;
    copyRightInformationValue;
    stateprogramsValue;
    displayDropDown;
    footerCss;
    isLoading=true;


    //Used to fech CSS files from Apex
    @wire(fetchCssFileFromAttachment, { title: footerCssLabel })
    wiredCssData({ data, error }) {
        if (data) {
            this.footerCss = data;
        }
        else if (error) {
            console.error(error)
        }
    }


    //used to fetch footer details from custom metadata
    @wire(getFooterData) wiredFooterData({ data, error }) {
        if (data) {
            for (const record of data) {
                if (record.Parent_Label__c == null) {
                    if (record.DeveloperName != 'State_Programs' && record.Top_Sequence__c != null){
                        this.topMetadataRecords.push(record);
                    }
                    if (record.DeveloperName != 'State_Programs' && record.Bottom_Sequence__c != null){
                        this.bottomMetadataRecords.push(record);
                    }
                    if (record.DeveloperName === 'Copyrights') {
                        this.copyRightInformationValue = record.Footer_Copyright_Details__c;
                    }
                    if (record.DeveloperName === 'State_Programs') {
                        this.stateprogramsKey = record.Label;
                    }
                    if(!JSON.stringify(data).includes('State_Programs')){
                        this.displayDropDown = false;
                    }
                    this.isLoading=false;
                } 
                else {
                    this.isLoading=false;
                    if (record.Parent_Label__c === 'State_Programs') {
                        this.displayDropDown=true;
                        const option = {
                            key: record.Label,
                            value: record.Footer_Link__c
                        };
                        this.childLinks = [...this.childLinks, option];
                    }
                }

            }
            
        } else if (error) {
            this.isLoading=false;
            console.error(error)
        }
    }

    //used to apply css 
    renderedCallback() {
        if(this.footerCss){
            Promise.all([
                loadStyle(this, this.footerCss)
            ]).then(() => {
            }).catch(error => {
                console.error(error)
            })
        }
    }
}