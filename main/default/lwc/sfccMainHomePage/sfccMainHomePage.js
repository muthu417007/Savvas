import { LightningElement,track } from 'lwc';
import No_Recent_Order from '@salesforce/resourceUrl/NoRecentOrder'
export default class DataTable extends LightningElement {
   orders = []; // Initialize orders as an empty array
   noRecentOrderImage = No_Recent_Order;
   connectedCallback() {
       // Simulate loading orders data asynchronously (replace this with your actual logic)
           this.orders = [
           { 
                id: 1, 
                Column1: 'PO-000999999999999', 
                Column2: '0000999999', 
                Column3: 'Lisa Joern',
                Column4: '99/99/99',
                Column5: 'Open' 
            },
            { 
                id: 2, 
                Column1: 'PO-000999999999999', 
                Column2: '0000999999', 
                Column3: 'Lisa Joern',
                Column4: '99/99/99',
                Column5: 'Open' 
             },
             { 
                id: 3, 
                Column1: 'PO-000999999999999', 
                Column2: '0000999999', 
                Column3: 'Ridge Ranch Elementary School For longer names wrap text',
                Column4: '99/99/99',
                Column5: 'Open' 
            },
            {
                id: 4, 
                Column1: 'PO-000999999999999', 
                Column2: '0000999999', 
                Column3: 'Lisa Joern',
                Column4: '99/99/99',
                Column5: 'Open' 
            },
            {
                id: 5, 
                Column1: 'PO-000999999999999', 
                Column2: '0000999999', 
                Column3: 'Lisa Joern',
                Column4: '99/99/99',
                Column5: 'Open' 
            },
            {
                id: 6, 
                Column1: 'PO-000999999999999', 
                Column2: '0000999999', 
                Column3: 'Lisa Joern',
                Column4: '99/99/99',
                Column5: 'Open' 
            },
            {
                id: 7, 
                Column1: 'PO-000999999999999', 
                Column2: '0000999999', 
                Column3: 'Lisa Joern',
                Column4: '99/99/99',
                Column5: 'Open' 
            }

           ]; // Assign empty array to orders to trigger the false path
        // Simulate a delay of 2 seconds
   }
   get hasRecentOrder()
   {
    return this.orders.length > 0;
   }
   get getRecentOrderCount()
   {
    return this.orders.length;
   }
}