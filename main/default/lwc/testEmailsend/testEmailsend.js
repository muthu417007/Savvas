import { LightningElement, track, wire,api } from 'lwc';
import testcart from '@salesforce/apex/testcart.getActiveCartItems'
export default class Scc_reviewCartPage extends LightningElement {
 @track quantity = 1;
     @api buttonLabel = 'Click Me'; // Default button label
    @api tooltipText = 'This is a tooltip please note that these are estimated totals'; // Default tooltip text
    @track isTooltipVisible = false; // Tooltip visibility state
    @track show = true;
      @track formattedDate;

    handleDateChange(event) {
        const selectedDate = new Date(event.target.value);
        const month = ('0' + (selectedDate.getMonth() + 1)).slice(-2);
        const day = ('0' + selectedDate.getDate()).slice(-2);
        const year = selectedDate.getFullYear();
        this.formattedDate = `${month}/${day}/${year}`;
    }

 
  @wire(testcart)
	setCartSummary({ data, error }) {
		if (data) {
		
			
            console.log('the active cardid is ',this.activeCartId); 
		} else if (error) {
			console.error(error);
		}
	}  
  handleCartNameChange(event){
       console.log('handleCartNameChange');
    this.cartName= event.target.value;
    console.log('handleCartNameChange',this.cartName);
    
  }
handleDelete(){
    console.log('handle delete clicked');
}
decrementQuantity(){
    if (this.quantity >1){
      this.quantity--;
    }}
incrementQuantity(){
   this.quantity++;
}
 handleReviewCart(){
        testcart()
            .then(result => {
              console.log('im in handle review cart', result);
            this.productDetailsInCart= result;
            this.calculateTotalPrice(result);
             this.isLoading1 = false;
                
            })
            .catch(error => {
                this.cases = undefined;
                this.caseError = error;
            });

 }


 @track isModalOpen = false;
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
        this.handleReviewCart();
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }

 
    showTooltip() {
        this.isTooltipVisible = true;
    }
 
    hideTooltip() {
        this.isTooltipVisible = false;
    }







}