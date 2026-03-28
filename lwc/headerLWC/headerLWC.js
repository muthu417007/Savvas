import { LightningElement } from 'lwc';
export default class Header2 extends LightningElement {
   
    homeClass = '';
    OrderStatusClass = '';
    CheckPriceAvailabilityclass='';
    PlaceOrderClass='';
    FileClaimClass='';
    GenerateRequestsClass='';
    RequestDocumentsClass='';
    CheckAccessCodeClass='';
        handleTabClick(event) {
        // Remove 'active' class from all tabs
        this.homeClass = '';
        this.OrderStatusClass='';
        this.CheckPriceAvailabilityClass='';
        this.PlaceOrderClass='';
        this.FileClaimClass='';
        this.GenerateRequestsClass='';
        this.RequestDocumentsClass='';
        this.CheckAccessCodeClass='';

        // Get the tab name from the data-tab attribute
        const tabName = event.target.dataset.tab;
        // Add 'active' class to the clicked tab
        this[`${tabName}Class`] = 'active';
    }


    showDropdownMenu = false;
    showDropdownMenuProf = false;

    showDropdown() {
        this.showDropdownMenu = true;
    }

    hideDropdown() {
        this.showDropdownMenu = false;
    }
    
    showProfDropdown() {
        this.showDropdownMenuProf = true;
    }

    hideProfDropdown() {
        this.showDropdownMenuProf = false;
    }

    profileLink(){
        this.tabName1 = 'owedCoresLink';
    }
}