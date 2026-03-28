import { LightningElement, track } from 'lwc';
export default class Input2 extends LightningElement {
      @track selectedDate;
    @track formattedDate;

    handleDateChange(event) {
        this.selectedDate = event.target.value;
        this.formattedDate = this.formatDate(this.selectedDate);
    }

    handleInputChange(event) {
        const dateValue = event.target.value;
        if (this.isValidDate(dateValue)) {
            this.formattedDate = dateValue;
            this.selectedDate = this.parseDate(dateValue);
            this.template.querySelector('lightning-input[type="date"]').value = this.selectedDate;
        }
    }

    formatDate(date) {
        if (!date) return '';
        const dateParts = date.split('-');
        const year = dateParts[0];
        const month = dateParts[1];
        const day = dateParts[2];
        return `${month}/${day}/${year}`;
    }

    parseDate(date) {
        const [month, day, year] = date.split('/');
        return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
    }

    isValidDate(date) {
        const datePattern = /^(0[1-9]|1[0-2])\/(0[1-9]|[12]\d|3[01])\/\d{4}$/;
        return datePattern.test(date);
    }


}