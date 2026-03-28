/*********************************************************
  Component Name       : sfccHomeQuickReport
  Created Date         : 06/10/2024  
  Author               : Cognizant (@⁠Ponraj,Jaba Raj )
  Description          : This component used in Home page and functionality related to 
                         display Quick Report.
  
  Modifications Log
  06/10/2024     Zubiya           Initial Version
*********************************************************/


import { LightningElement } from 'lwc';

export default class SfccHomeQuickReport extends LightningElement {

// An array of quick report options for user selection.
    quickReportOptions = [
        { value: 'My New Editions and Other Substitutions List', label: 'My New Editions and Other Substitutions List' },
        { value: 'My Supplements List', label: 'My Supplements List ' },
        { value: 'My Print-on-Demand Products', label: 'My Print-on-Demand Products' },
        { value: 'All Print-on-Demand Products ', label: 'All Print-on-Demand Products ' },
        { value: 'My Out-of-Print List', label: 'My Out-of-Print List' },
        { value: 'Unshipped Orders Report', label: 'Unshipped Orders Report' },
        { value: 'Backorder Report', label: 'Backorder Report' },
        { value: 'My Order Status Report (Summary) ', label: 'My Order Status Report (Summary) ' },
		{ value: 'My Order Status Report (Detail)', label: 'My Order Status Report (Detail)' },
		{ value: ' My Order Status Report (Tracking) ', label: ' My Order Status Report (Tracking) ' },
		{ value: 'Backorder Cancel Dates', label: 'Backorder Cancel Dates' },
      ];
}