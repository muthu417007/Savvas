import { LightningElement, wire, track, api } from 'lwc';
import searchProducts from '@salesforce/apex/scc_productCriteriaSearch.searchProducts';
import errormessage from '@salesforce/label/c.scc_productcriteriaerrormessage';
import LightningAlert from 'lightning/alert';
import { RefreshEvent } from 'lightning/refresh';

export default class TestPA_CSlwc extends LightningElement {

}