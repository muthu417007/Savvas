import { LightningElement, api } from 'lwc';
import getSitecoreAsset from '@salesforce/apex/SavvasSampleResourcesLandingController.getSitecoreAsset';
import authenticateDam from '@salesforce/apex/SavvasSampleResourcesLandingController.authenticateDam';
import generateAccessToken from '@salesforce/apex/SavvasSampleResourcesLandingController.generateAccessToken';
import updateAssetDescription from '@salesforce/apex/SavvasSampleResourcesLandingController.updateAssetDescription';
import Contact_Rep from '@salesforce/contentAssetUrl/unknown_content_asset';
import Savvas_Desktop from '@salesforce/contentAssetUrl/unknown_content_asset';
import { NavigationMixin } from 'lightning/navigation';
import invokeAssetTrackingFlow from '@salesforce/apex/SavvasVirtualSampleAssetTrackingCtrl.invokeAssetTrackingFlow';
import contactURL from '@salesforce/label/c.Savvas_Virtual_Samples_Side_banner_contact_URL';
import savvasRealizeURL from '@salesforce/label/c.Savvas_Realize_URL';
import savvasSignupURL from '@salesforce/label/c.Savvas_Sitecore_Signup_Url';
import savvasFindMyRep from '@salesforce/label/c.Savvas_Find_My_Rep_Url';

export default class SavvasSampleResourcesLandingPage extends NavigationMixin(LightningElement) {
    @api collectionName;
    Contact_Rep = Contact_Rep;
    Savvas_Desktop = Savvas_Desktop;
    loaded = true;
    hasAccess = false;
    isLoading = false;
    isFirstTime = false;
    productData = [];
    acitveSection = [];
    setActiveSections = [];
    urlToOpen;
    contentAccessData;
    label={
        contactURL,
        savvasRealizeURL,
        savvasFindMyRep,
        savvasSignupURL
    }
    link;
    
    //gets called on load of the component
    connectedCallback() {
        try {
            this.isLoading = false;
            this.isFirstTime = true;
            this.loaded = false;
            //calling this method to get latest description from API and update Collection_Access__c and SitecoreAssets
            updateAssetDescription({ collectionName: this.collectionName })
                .then(result => {
                    //calling this method to feth the updated Collection_Access__c and Sitecore_Assets__c records.
                    getSitecoreAsset({ collectionName: this.collectionName })
                        .then(result => {
                            if (result) {
                                this.contentAccessData = Object.entries(result).map(([key, value]) => ({
                                    key,
                                    value: Object.entries(value).map(([index, item]) => ({ index, item })),
                                }));
                                this.loaded = true;
                                if (this.contentAccessData) {
                                    this.hasAccess = true;
                                }
                                for (let value of this.contentAccessData) {
                                    this.acitveSection.push(value.key);
                                }
                                this.setActiveSections = this.acitveSection;
                                this.isLoading = true;
                            }
                            else {
                                this.isLoading = true;
                                this.hasAccess = true;
                            }
                        })
                        .catch(error => {
                            this.isLoading = true;
                            this.loaded = true
                        })
                })
                .catch(error => {
                    this.isLoading = true;
                    this.loaded = true;
                })
        }
        catch (error) {
            console.error('error---> ', error);
        }
    }

    //this method is fired on click of any asset. It is used to launch NCA/DAM assets in new tab
    handleOnClick(event) {
        try {
            this.isLoading = true;
            let asset_itemId = event.currentTarget.dataset.id;
            let data = '';
            for (const contentData of this.contentAccessData) {
                data = contentData.value.find((element) => element.item.asset_itemId === asset_itemId);
                if (data) {
                    break;
                }
            }
            let entityId = data?.item.entityId;
            if (!entityId) {
                let url = data.item.assetURL;
                // get encrypted access token and append with assetURL
                generateAccessToken({ sitecoreId: asset_itemId })
                    .then(result => {
                        if (result) {
                            try {
                                url = url + '&authToken=' + result + '&sitecoreId=' + asset_itemId;
                                this.isLoading = true;
                                window.open(url, '_blank');
                            }
                            catch (Ex) {
                            }
                        }
                    })
                    .catch(error => {
                        this.isLoading = true;
                    })
                //End - NCA-14 & NCA-16
                this.isLoading = false;
            } else {
                authenticateDam({ entityId: entityId })
                    .then(result => {
                        let url = JSON.parse(JSON.stringify(JSON.parse(result))).renditions.preview[0].href;
                        this.isLoading = true;
                        window.open(url, '_blank');
                    })
                    .catch(error => {
                        console.error(error)
                        this.isLoading = true;
                    })
            }
            let wrapperMap = {
                sampleAssetName: data.item.assetName,
                sampleAssetSitecoreId: data.item.asset_itemId,
                virtualsampleProgramName: null
            }
            //flow is invoked to create asset tracking records
            invokeAssetTrackingFlow({ flowDetails: wrapperMap });
        }
        catch (error) {
            console.error('error---> ', error);
        }
    }
}