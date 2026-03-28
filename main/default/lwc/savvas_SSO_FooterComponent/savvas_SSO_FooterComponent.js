import { LightningElement } from 'lwc';
import Savvas_SSO_Login_Copyright from '@salesforce/label/c.Savvas_SSO_Login_Copyright';
import Savvas_Terms_Conditions from '@salesforce/label/c.Savvas_Terms_Conditions';
import Savvas_Privacy_Notice from '@salesforce/label/c.Savvas_Privacy_Notice';
export default class Savvas_SSO_FooterComponent extends LightningElement {
    label = {Savvas_Terms_Conditions, Savvas_Privacy_Notice, Savvas_SSO_Login_Copyright}
}