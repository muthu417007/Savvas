import { LightningElement, track } from 'lwc';

export default class Input extends LightningElement {
    @track formattedDate;
    @track formattedDate4='';
    @track isLoading = true;
    handlePrint2(){
        window.print();
    }

   handleDateChange(event) {
        // Get the selected date value
        const selectedDate = new Date(event.target.value);
        console.log('selectedDate',selectedDate);

        // Format the date as MM/DD/YYYY
        this.formattedDate = `${selectedDate.getMonth() + 1}/${selectedDate.getDate()}/${selectedDate.getFullYear()}`;
    console.log('formattedDate',this.formattedDate);
        // Set the input value to the formatted date
        event.target.value =this.formattedDate;
    }
    handleDateChange1(event){
        console.log(event.target.vale);
    }
      handleDateChange2(event){
        console.log(event.target.vale);
    }

  handleDateChange3(event){
        console.log(event.target.vale);
    }
handleDateChange4(event){
    this.formattedDate4=event.target.value;
}

}