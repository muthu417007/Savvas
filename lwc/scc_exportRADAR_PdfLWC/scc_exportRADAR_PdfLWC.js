/********************************************************************************************* 
* @Component Name  - scc_exportRADAR_PdfLWC
* @description - This component is used to export the RADAR PDF
* @Created By  - CTS - Vaibhav
* @Created On - 08/06/2024 
* ********************************************************************************************/
import { LightningElement } from 'lwc';

const viewAndDownloadPdf = (base64String) => {
    return new Promise((resolve, reject) => {
        try {
            // Convert base64 to binary string
            const binaryString = window.atob(base64String);
            const len = binaryString.length;
            const bytes = new Uint8Array(len);

            for (let i = 0; i < len; i++) {
                bytes[i] = binaryString.charCodeAt(i);
            }

            const blob = new Blob([bytes], { type: 'application/pdf' });

            // Check if Blob is supported
            if (window.URL && window.URL.createObjectURL) {
                const url = window.URL.createObjectURL(blob);

                // Use anchor tag to open the PDF in a new tab
                const anchor = document.createElement('a');
                anchor.href = url;
                anchor.target = '_blank';
                anchor.rel = 'noopener noreferrer'; // For security
                document.body.appendChild(anchor); // Append the anchor to the document
                anchor.click(); // Simulate click to open the tab
                document.body.removeChild(anchor); // Clean up the anchor tag

                // Exit the function after successfully opening the new tab
                resolve();
                return;
            }

            // Fallback to data URL if Blob is not supported
            const dataUrl = `data:application/pdf;base64,${base64String}`;
            window.open(dataUrl, "_blank");
            resolve();

        } catch (error) {
            console.error('Error in viewAndDownloadPdf:', error);
            reject(error);
        }
    });
};

export { viewAndDownloadPdf };

export default class Scc_exportRADAR_PdfLWC extends LightningElement {
    
}