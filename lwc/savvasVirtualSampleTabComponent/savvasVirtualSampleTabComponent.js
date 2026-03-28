import { LightningElement, api, track } from 'lwc';
import savvaasstyle from '@salesforce/resourceUrl/SavvasVirtualSampleImages';
import savvasVirtualSampleTabMobileComponent from './savvasVirtualSampleTabMobileComponent.html';
import savvasVirtualSampleTabWebComponent from './savvasVirtualSampleTabWebComponent.html';
export default class SavvasVirtualSampleTabComponent extends LightningElement {
   @api assetDetails;
   @api gradeDetails;
   tabs = this.template.querySelectorAll('.tab');
   moreTabs = this.template.querySelectorAll('.more-tab');
   dropdown = this.template.querySelectorAll('.dropdown');
   dropdownContent = this.template.querySelectorAll('.dropdown-content');
   content = this.template.querySelectorAll('.content');
   tabsSection = this.template.querySelectorAll('.tabs');
   activeTab = this.tabs[0];
   dropdownclass = 'dropdown';
   tab_class = 'tab';
   more_tab = 'more-tab';
   displayAssets = false;
   maxVisibleTabs = 8;
   value = 'new';
   gradeLabels = [];
   mobileTabs = [];
   tabSelected;

   get visibleTabs() {
      if (this.gradeLabels.length <= 8) {
         return this.gradeLabels.slice(0, this.maxVisibleTabs);
      }
      else {
         return this.gradeLabels.slice(0, this.maxVisibleTabs - 1);
      }
   }

   get hiddenTabs() {
      return this.gradeLabels.slice(this.maxVisibleTabs - 1);
   }

   get showMoreButton() {
      return this.gradeLabels.length > this.maxVisibleTabs;
   }

   render() {
      try {
         return window.screen.width < 900 ? savvasVirtualSampleTabMobileComponent : savvasVirtualSampleTabWebComponent;
      }
      catch (error) {
         console.error(error)
      }
   }

   connectedCallback() {
      try {
         this.gradeLabels = [];
         let sortedData = [];
         this.gradeDetails = JSON.parse(JSON.stringify(this.gradeDetails))
         this.gradeDetails.forEach(element => {
            for (let key in element) {
               sortedData.push({ name: key, value: element[key] })
            }
         });
         sortedData.sort((a, b) => a.value - b.value);
         sortedData.forEach(element => {
            for (let key in element) {
               if (key == 'name') {
                  this.mobileTabs.push({ label: element[key], value: element[key] })
                  this.gradeLabels.push(element[key]);
               }
            }
         });
         if (this.gradeLabels.length <= 8) {
            this.more_tab = 'more-tab displaynone'
         }
         this.tabSelected = this.gradeLabels[0];
         this.value = this.tabSelected
         this.displayAssets = true;
      }
      catch (error) {
         console.error(error)
      }
   }

   renderedCallback() {
      try {
         this.moreTabs.addEventListner('click', () => {
            this.dropdown.classList.toggle('active');
         })
         this.tabs.forEach(tab => {
            this.tabs.addEventListner('click', () => {
               this.activeTab.classList.remove('active');
               this.tab.classList.add('active');
               this.activeTab = tab;
               this.content.textContent = 'Content of $(tab.textContent)';
            })
         });

         dropdownTabs = document.querySelectorAll('.dropdown .tab');
         this.dropdownTabs.forEach(dropdownTab => {
            this.dropdownTab.addEventListner('click', () => {
               this.activeTab.classList.remove('active');
               this.dropdownTab.classList.add('active');
               this.activeTab = this.dropdownTab;
               this.content.textContent = 'Content of $(dropdownTab.textContent)';
               this.dropdownContent.appendChild(activeTab);
               const clonedTab = dropdownTab.cloneNode(true);
               this.tabsSection.replaceChild(clonedTab, tabs[0]);
               this.dropdown.classList.remove('active');
            })
         })

         this.selectedTabValue = this.gradeLabels[0].value;

         Promise.all([
            loadStyle(this, savvaasstyle + '/css/style.css') //specified filename
         ]).then(() => {
         })
            .catch(error => {
               console.error(error);
            });
      }
      catch (error) {
         console.error(error)
      }
   }

   toggleDropdown() {
      this.isDropdownOpen = !this.isDropdownOpen;
   }

   moreBtnDropdown(event) {
      if (this.dropdownclass === 'dropdown') {
         this.dropdownclass = 'dropdown active';
      }
      else {
         this.dropdownclass = 'dropdown';
      }

   }

   handleEnter(event){
      if (event.keyCode === 13) {
         this.handleClick(event);
         if (this.dropdownclass === 'dropdown active') {
            this.dropdownclass = 'dropdown';
         }
      }
   }

   handleClick(event) {
      try{
      this.displayAssets = false;
      this.tabSelected = event.target.dataset.id;
      const buttons = this.template.querySelectorAll('.tab');
      buttons.forEach(button => {
         button.classList.remove('active');
         button.setAttribute('aria-selected','false');

      });
      event.target.setAttribute('aria-selected','true');
      if (this.dropdownclass === 'dropdown active') {
         this.dropdownclass = 'dropdown';
      }
      if (this.visibleTabs.includes(this.tabSelected)) {
         event.target.classList.add('tab', 'active');
      }
      if (this.hiddenTabs.includes(this.tabSelected)) {
         event.target.classList.add('tab', 'active');
      }
      let assetCmp = this.template.querySelector('c-savvas-virtual-sample-asset-display');
      assetCmp.handleAssetData(this.tabSelected);
      this.displayAssets = true;
   }
   catch(error){
      console.error(error);
   }
   }

   handleChange(event) {
      try{
      this.displayAssets = false;
      this.value = event.target.value;
      this.tabSelected = this.value;
      let assetCmp = this.template.querySelector('c-savvas-virtual-sample-asset-display');
      assetCmp.handleAssetData(this.tabSelected);
      this.displayAssets = true;
      }
      catch(error){
         console.error(error);
      }
   }

   handleToggleSection(event) {
      try {
         this.displayAssets = false;
         this.tabSelected = event.detail.openSections;
         let assetCmp = this.template.querySelector('c-savvas-virtual-sample-asset-display');
         assetCmp.handleAssetData(this.tabSelected);
         this.displayAssets = true;
      }
      catch (error) {
         console.error(error)
      }
   }
   
}