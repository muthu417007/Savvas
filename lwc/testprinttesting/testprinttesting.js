import { LightningElement } from 'lwc';
import scc_brand_logo_mobile from "@salesforce/resourceUrl/scc_brand_logo_mobile";
export default class Testprinttesting extends LightningElement {
   showPrit = false;
    labels = {
        scc_brand_logo_mobile
    }
    handlePrint() {
        // Extract the content to be printed
         this.showPrit = true;
        const printContent = this.template.querySelector('.print-only').innerHTML;

        // Create a new window
        const printWindow = window.open('', '_blank', 'width=800,height=600');

        // Set the content of the new window
        printWindow.document.write(`
            <html>
                <head>
                    <title>Printttttttttt</title>
                    <style>
                        /* Add any styles you need for the print content */
                    </style>
                 
                      
                </head>
                <body>
              
                
                   
                     ${printContent}
                </body>
            </html>
        `);

        // Close the document to finish writing and enable printing
        printWindow.document.close();

        // Print the content
        printWindow.print();

        // Close the print window after printing
        printWindow.onafterprint = function () {
            
            printWindow.close();

        };
    }





    handlePrint2(){
            this.printcontent = true;
        window.print();
            this.printcontent2 = true;
    }



      handlePrin() {
        // Select the print-only content
        const printContent = this.template.querySelector('.print-only').innerHTML;


        // Create a new window for printing
        const printWindow = window.open('', '', 'height=600,width=800');


        // Write the content to the new window
        printWindow.document.write('<html><head><title>Print Content</title>');


        // Copy the current document's styles to the new window
        const styleSheets = Array.from(document.styleSheets).map(sheet => {
            try {
                return sheet.href ? `<link rel="stylesheet" href="${sheet.href}">` : `<style>${Array.from(sheet.cssRules).map(rule => rule.cssText).join('')}</style>`;
            } catch (e) {
                return '';
            }
        }).join('');


        printWindow.document.write(styleSheets);
        printWindow.document.write('</head><body>');
        printWindow.document.write(printContent);
        printWindow.document.write('</body></html>');


        // Close the document to complete the writing process
        printWindow.document.close();


        // Wait for the new window's content to load before printing
        printWindow.onload = function() {
            printWindow.focus();
            printWindow.print();
            printWindow.close();
        };
    }



}