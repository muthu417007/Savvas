import { LightningElement, api } from 'lwc';

export default class Searchbox extends LightningElement {
    @api searchValue = '';

    handleSearchValue(event) {
        this.searchValue = event.target.value;
    }

    gotoSearchResults(event) {
        event.preventDefault();
        if(this.searchValue){
            let redirectURL = '/support/s/global-search/' + this.searchValue;
            window.open(redirectURL, '_self');
        } else {
            return;
        }
    }
}