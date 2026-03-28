import { LightningElement, api, track } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class sysIntPageFlip extends LightningElement {
    @api imageUrl;
    @api variable1;
    @api variable2;
    @api variable3;
    @api variable4;
    @api navLogic;
    @api fontLarge;
    @api fontSmall;
    @api fontColor;
    @api componentTextLarge;
    @api componentTextSmall;
    @api nLogic;
    @api var1;
    @api var2;
    @api var3;
    @api var4; 
    @api ariaText;
    
		/*
    get imageUrlStyle() {
      return `border: 2px solid black; padding: 10px;background: url(${this.imageUrl}); background-size: 4000px 1000px;`;
    }
*/
    get CardStyle(){
        //return `display: table;text-align: left; height:100px;width: 350px;margin-left: auto;margin-right: auto;background-size: 100%; z-index: -1; border-radius: 3px;`;
        //return `display: table;text-align: left; height:250px;width: 300px;margin-left: auto;margin-right: auto;background-size: 90%; z-index: -1; border-radius: 3px;`;
      return `display: table;text-align: left; height:210px;width: 420px;margin-left: auto;margin-right: auto; background-repeat: no-repeat;background-size: 90%; background-position: Fit;z-index: -1; border-radius: 3px;`;
		}

    get imageUrlStyle() {
        return `display: table;text-align: left; height:210px;width: 450px;margin-left: auto;margin-right: auto; background: url(${this.imageUrl});background-repeat: no-repeat;background-size: 100%; background-position: Fit;z-index: -1; border-radius: 3px;`;
      }
     get imageUrlStyleback() {
        return `display: table; text-align: left; height:190px;width: 420px;margin-left: auto;margin-right: auto;background-size: 100%; z-index: -1; border-radius: 3px;`;
      }
      get fontLargeStyle() {
			  return `display: table-cell;white-space: pre-wrap; vertical-align: middle;font-weight: 600;text-shadow: 0px 0px 0px #000000; font-size: 23px!important; color: white!important;`;
					/*
        if (this.fontColor === undefined) {
          if (this.fontLarge === undefined) {
            return `display: table-cell; vertical-align: middle; font-weight:normal; font-size: 24px!important; color: white!important;`;
          } else {
            return `display: table-cell; vertical-align: middle;font-family:Poppins; font-size: ${this.fontLarge}px!important; color: white!important;`;
          }
        } else if (this.fontLarge === undefined) {
          return `display: table-cell; vertical-align: middle;font-family:Poppins; font-size: 24px!important; color: ${this.fontColor}!important;`;
        } else {
          return `display: table-cell; vertical-align: middle;font-family:Poppins; font-size: ${this.fontLarge}px!important; color: ${this.fontColor}!important;`;
        } 
				*/
      }

      get fontSmallStyle() {
        if (this.fontSmall === undefined) {
          return `display: table-cell; white-space: pre-wrap;vertical-align: middle;font-family:Poppins; font-size: 16px; color:black;`;
        } else {
          return `display: table-cell; vertical-align: middle;font-family:Poppins; font-size: ${this.fontSmall}px; color:black;`;
        }
      }

      @api
      availableActions = [];
  
      @api
      get todos() {
          return this._todos;
      }
  
      set todos(todos = []) {
          this._todos = [...todos];
      }
  
      @track _todos = [];
  
      get todosList() {
          return this._todos.map(todo => {
              return {text: todo, id: Date.now().toString()};
          });
      }
  
      get hasTodos() {
          return this._todos && this._todos.length > 0;
      }
  
      handleUpdatedText(event) {
          this._text = event.detail.value;
      }
  
      handleAddTodo() {
          this._todos.push(this._text);
          // notify the flow of the new todo list
          const attributeChangeEvent = new FlowAttributeChangeEvent('todos', this._todos);
          this.dispatchEvent(attributeChangeEvent);
      }
  
      handleGoNext() {
        
          // check if NEXT is allowed on this screen
          if (this.availableActions.find(action => action === 'NEXT')) {
            this.nLogic = this.navLogic;
            this.var1 = this.variable1;
            this.var2 = this.variable2;
            this.var3 = this.variable3;
            this.var4 = this.variable4;

            // navigate to the next screen
              const navigateNextEvent = new FlowNavigationNextEvent();
              this.dispatchEvent(navigateNextEvent);

              //Send data to GTM
              document.dispatchEvent(new CustomEvent("updateGTMdataLayer", { "detail" : { event: "CustomNext-click", category: "Tech Support Flow", action: "Flow Path", label: this.variable4} }));

            // open window in modal
            //  window.open('http://google.com','popup','width=600,height=600'); return true;
          }
      }
}