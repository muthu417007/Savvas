/********************************************************************************************* 
* @Component Name  - Scc_privacyLWC
* @description - This component is used to display the privacy policy.
* @Created By  - CTS - Sudharani Pathivada
* @Created On - 09/13/2024 
* ********************************************************************************************/

import { LightningElement } from 'lwc';
export default class Scc_privacyLWC extends LightningElement {

    handleprivacyclose(event){
        event.preventDefault();
        window.close();
    }

}