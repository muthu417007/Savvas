import { LightningElement,api,track } from 'lwc';
import fetchISBNdetails from '@salesforce/apex/HomeSchoolGradeISBNClass.fetchISBNdetails';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class HomeschoolDynamicGradeISBN extends LightningElement {
    gradeValue = [];
    @api gradeISBNValue = [];
    eachISBN = [];
    selectedGradeList = [];
    selectedGradeISBNMap = [];
    @api gradeKGList = [];
    @api grade1List = [];
    @api grade2List = [];
    @api grade3List = [];
    @api grade4List = [];
    @api grade5List = [];
    @api grade6List = [];
    @api grade7List = [];
    @api grade8List = [];
    @api grade9List = [];
    @api grade10List = [];
    @api grade11List = [];
    @api grade12List = [];
    @api gradeISBNData= [];
    @api gradeISBNDataStr;
    @api selectedGrades = [];  
    @api selectedGradesStr;   
    @api gradeISBNValues;
    @api gradeAllIsbnList = [];
    @api validSelection;



    get gradeOptions() {
        return [
            { label: 'Kindergarten', value: '0' },
            { label: '1st Grade', value: '1' },
            { label: '2nd Grade', value: '2' },
            { label: '3rd Grade', value: '3' },
            { label: '4th Grade', value: '4' },
            { label: '5th Grade', value: '5' },
            { label: '6th Grade', value: '6' },
            { label: '7th Grade', value: '7' },
            { label: '8th Grade', value: '8' },
            { label: '9th Grade', value: '9' },
            { label: '10th Grade', value: '10' },
            { label: '11th Grade', value: '11' },
            { label: '12th Grade', value: '12' },
        ];
    }
    get gradeOptions2() {
        return [
            { label: 'Mathematics 2010 Course Algebra Readiness - 9780133197532', value: '0' },
            { label: 'myPerspectives Grade 12 - 9781418283759', value: '1' },
            { label: 'myWorld Geography (7th or 8th grade) - 9780133203271', value: '2' },
            { label: 'myWorld History (7th or 8th grade) - 9780133203288', value: '3' },
            { label: 'High School Math Geometry - 9780133322460', value: '4' },
            { label: 'High School Math Algebra 2 - 9780133322484', value: '5' },
            { label: 'myView Grade K - 9781428455764', value: '6' },
            { label: 'myView Grade 1 - 9781428455771', value: '7' },
            { label: 'myView Grade 2 - 9781428455771', value: '8' },
        ];
    }

    constructor(){
        super(); 
        console.log('Constructor called');
    }
    connectedCallback(){
        var inputISBN = JSON.parse(JSON.stringify(this.gradeAllIsbnList));
        console.log('Connected Callback inputISBN: ',inputISBN);
        console.log('validSelection: ',this.validSelection);
        this.reassignAllGradesISBN(inputISBN);
        //if(this.validSelection === 'Yes'){            
            this.reassignSelectedISBN();
        //}
    }
    renderedCallback(){
        console.log('Rendered Callback called',this.selectedGradesStr);
     }
    
    handleGradeChange(event){
        this.gradeValue = event.detail.value;
        this.selectedGrades = this.gradeValue;
        this.selectedGradesStr = JSON.stringify(this.selectedGrades);
        console.log('selectedGrades: ',this.selectedGrades);
        console.log('selectedGrades length: ',this.selectedGrades.length);
        fetchISBNdetails({inputGrades:this.selectedGrades})
        .then(result => {
            var conts = result;
            this.gradeISBNData = [];
            this.gradeISBNTitle = [];
            this.gradeAllIsbnList = [];
            console.log('conts: ',conts);
            if(conts){                
                for(var key in conts){
                    var gradeTitle = '';
                    if(key === '1'){
                        gradeTitle = key+'st Grade Product(s) Purchased';
                    }
                    else if(key === '2'){
                        gradeTitle = key+'nd Grade Product(s) Purchased';
                    }
                    else if(key === '3'){
                        gradeTitle = key+'rd Grade Product(s) Purchased';
                    }
                    else if(key === '0'){
                        gradeTitle = 'Kindergarten Product(s) Purchased';
                    }
                    else{
                        gradeTitle = key+'th Grade Product(s) Purchased';
                    }
                    this.eachISBN = [];
                    var prodList =  conts[key];                    
                    prodList.forEach((element)=> {
                        var prodLabel = element;
                        var prodVal = element+'@Grade '+key+'@';
                        this.eachISBN.push({ label: prodLabel, value: prodVal});
                        this.gradeAllIsbnList.push(prodVal);
                      });
                    this.gradeISBNData.push({ key: key, value1: this.eachISBN,value2: gradeTitle});
                    this.gradeISBNDataStr = JSON.stringify(this.gradeISBNData);
                }
            }            
            console.log('gradeISBNData: ',JSON.stringify(this.gradeISBNData));
            console.log('gradeAllIsbnList: ',this.gradeAllIsbnList);
            console.log('gradeISBNData2: ',JSON.stringify(Array.from( this.gradeISBNData.entries())));
        })
        .catch(error => {
            console.log('error:',error);
        });
    }

    handleISBNChange(event){        
        this.selectedGradeList = event.detail.value;
        var isbnGrade = event.target.label;
        console.log('Dataset key3: ',event.target);
        console.log('clicked value: ',event);
        console.log('length: ',this.selectedGradeList.length);    
        this.selectedGradeList.forEach((element)=> {
            console.log('went1: ',element);
            var selectedPdt = element;  
            if(selectedPdt.includes("@Grade 1@")){
                this.grade1List = this.selectedGradeList;
            }
            else if(selectedPdt.includes("@Grade 2@")){
                this.grade2List = this.selectedGradeList;
            }
            else if(selectedPdt.includes("@Grade 3@")){
                this.grade3List = this.selectedGradeList;
            }
            else if(selectedPdt.includes("@Grade 4@")){
                this.grade4List = this.selectedGradeList;
            }
            else if(selectedPdt.includes("@Grade 5@")){
                this.grade5List = this.selectedGradeList;
            }          
            else if(selectedPdt.includes("@Grade 6@")){
                this.grade6List = this.selectedGradeList;
            }
            else if(selectedPdt.includes("@Grade 7@")){
                this.grade7List = this.selectedGradeList;
            }
            else if(selectedPdt.includes("@Grade 8@")){
                this.grade8List = this.selectedGradeList;
            }
            else if(selectedPdt.includes("@Grade 9@")){
                this.grade9List = this.selectedGradeList;
            }
            else if(selectedPdt.includes("@Grade 10@")){
               this.grade10List = this.selectedGradeList;
            }
            else if(selectedPdt.includes("@Grade 11@")){
                this.grade11List = this.selectedGradeList;
            } 
            else if(selectedPdt.includes("@Grade 12@")){
                this.grade12List = this.selectedGradeList;
            } 
            else if(selectedPdt.includes("@Grade 0@")){
                this.gradeKGList = this.selectedGradeList;
            }              
        });
        if(this.selectedGradeList.length===0){
            this.emptyGradeList(isbnGrade);
        }
      // this.gradeISBNValue=this.selectedGradeList;;
        /*this.gradeISBNValue.push(this.grade2List);
        this.gradeISBNValue.push(this.grade3List);
        this.gradeISBNValue.push(this.grade4List);
        this.gradeISBNValue.push(this.grade5List);
        this.gradeISBNValue.push(this.grade6List);
        this.gradeISBNValue.push(this.grade7List);
        this.gradeISBNValue.push(this.grade8List);
        this.gradeISBNValue.push(this.grade9List);
        this.gradeISBNValue.push(this.grade10List); 
        this.gradeISBNValue.push(this.grade11List);
        this.gradeISBNValue.push(this.grade12List);
        this.gradeISBNValue.push(this.gradeKGList);*/
         console.log('gradeKGList: ',JSON.stringify(this.gradeKGList)); 
         console.log('grade10List: ',JSON.stringify(this.grade10List));  
         console.log('grade11List: ',JSON.stringify(this.grade11List));           
         console.log('gradeISBNValue first: ',JSON.stringify(this.gradeISBNValue));    
    }

    emptyGradeList(isbnGrade){
        if(isbnGrade.includes("Kindergarten")){
            this.gradeKGList = [];
        }
        else if(isbnGrade.includes("1st")){
            this.grade1List = [];
        }
        else if(isbnGrade.includes("2nd")){
            this.grade2List = [];
        }
        else if(isbnGrade.includes("3rd")){
            this.grade3List = [];
        }
        else if(isbnGrade.includes("4th")){
            this.grade4List = [];
        }
        else if(isbnGrade.includes("5th")){
            this.grade5List = [];
        }
        else if(isbnGrade.includes("6th")){
            this.grade6List = [];
        }
        else if(isbnGrade.includes("7th")){
            this.grade7List = [];
        }
        else if(isbnGrade.includes("8th")){
            this.grade8List = [];
        }
        else if(isbnGrade.includes("9th")){
            this.grade9List = [];
        }
        else if(isbnGrade.includes("10th")){
            this.grade10List = [];
        }
        else if(isbnGrade.includes("11th")){
            this.grade11List = [];
        }
        else if(isbnGrade.includes("12th")){
            this.grade12List = [];
        }
    }

 reassignAllGradesISBN(inputISBN){
    var GradeISBN_KG = [];
    var GradeISBN_1 = [];
    var GradeISBN_2 = [];
    var GradeISBN_3 = [];
    var GradeISBN_4 = [];
    var GradeISBN_5 = [];
    var GradeISBN_6 = [];
    var GradeISBN_7 = [];
    var GradeISBN_8 = [];
    var GradeISBN_9 = [];
    var GradeISBN_10 = [];
    var GradeISBN_11 = [];
    var GradeISBN_12 = [];
    if(this.gradeAllIsbnList.length !== 0){
        inputISBN.forEach((element)=> {
            var isbnVal = element;
            var isbnLabel = isbnVal.substring(0, isbnVal.indexOf("@Grade"));
            if(element.includes("@Grade 0@")){
                GradeISBN_KG.push({ label: isbnLabel, value: isbnVal});
            }
            else if(element.includes("@Grade 1@")){
                GradeISBN_1.push({ label: isbnLabel, value: isbnVal});
            }
            else if(element.includes("@Grade 2@")){
                GradeISBN_2.push({ label: isbnLabel, value: isbnVal});
            }
            else if(element.includes("@Grade 3@")){
                GradeISBN_3.push({ label: isbnLabel, value: isbnVal});
            }
            else if(element.includes("@Grade 4@")){
                GradeISBN_4.push({ label: isbnLabel, value: isbnVal});
            }
            else if(element.includes("@Grade 5@")){
                GradeISBN_5.push({ label: isbnLabel, value: isbnVal});
            }
            else if(element.includes("@Grade 6@")){
                GradeISBN_6.push({ label: isbnLabel, value: isbnVal});
            }
            else if(element.includes("@Grade 7@")){
                GradeISBN_7.push({ label: isbnLabel, value: isbnVal});
            }
            else if(element.includes("@Grade 8@")){
                GradeISBN_8.push({ label: isbnLabel, value: isbnVal});
            }
            else if(element.includes("@Grade 9@")){
                GradeISBN_9.push({ label: isbnLabel, value: isbnVal});

            } else if(element.includes("@Grade 10@")){
                GradeISBN_10.push({ label: isbnLabel, value: isbnVal});
            }
            else if(element.includes("@Grade 11@")){
                GradeISBN_11.push({ label: isbnLabel, value: isbnVal});
            }
            else if(element.includes("@Grade 12@")){
                GradeISBN_12.push({ label: isbnLabel, value: isbnVal});
            }
        });
    }
    if(GradeISBN_KG.length > 0){
        this.gradeISBNData.push({ key: "0", value1: GradeISBN_KG,value2: "Kindergarten Product(s) Purchased"});
    }
    if(GradeISBN_1.length >0){
        this.gradeISBNData.push({ key: "1", value1: GradeISBN_1,value2: "1st Grade Product(s) Purchased"});
    }        
    if(GradeISBN_2.length >0){
        this.gradeISBNData.push({ key: "2", value1: GradeISBN_2,value2: "2nd Grade Product(s) Purchased"});
    }        
    if(GradeISBN_3.length >0){
        this.gradeISBNData.push({ key: "3", value1: GradeISBN_3,value2: "3rd Grade Product(s) Purchased"});
    }        
    if(GradeISBN_4.length >0){
        this.gradeISBNData.push({ key: "4", value1: GradeISBN_4,value2: "4th Grade Product(s) Purchased"});
    }        
    if(GradeISBN_5.length >0){
        this.gradeISBNData.push({ key: "5", value1: GradeISBN_5,value2: "5th Grade Product(s) Purchased"});
    }        
    if(GradeISBN_6.length >0){
        this.gradeISBNData.push({ key: "6", value1: GradeISBN_6,value2: "6th Grade Product(s) Purchased"});
    }
    if(GradeISBN_7.length >0){
        this.gradeISBNData.push({ key: "7", value1: GradeISBN_7,value2: "7th Grade Product(s) Purchased"});
    }        
    if(GradeISBN_8.length >0){
        this.gradeISBNData.push({ key: "8", value1: GradeISBN_8,value2: "8th Grade Product(s) Purchased"});
    }        
    if(GradeISBN_9.length >0){
        this.gradeISBNData.push({ key: "9", value1: GradeISBN_9,value2: "9th Grade Product(s) Purchased"});
    }        
    if(GradeISBN_10.length >0){
        this.gradeISBNData.push({ key: "10", value1: GradeISBN_10,value2: "10th Grade Product(s) Purchased"});
    }
    if(GradeISBN_11.length >0){
        this.gradeISBNData.push({ key: "11", value1: GradeISBN_11,value2: "11th Grade Product(s) Purchased"});
    }
    if(GradeISBN_12.length >0){
        this.gradeISBNData.push({ key: "12", value1: GradeISBN_12,value2: "12th Grade Product(s) Purchased"});
    }
    console.log('Connected Callback gradeISBNData: ',this.gradeISBNData);
}
reassignSelectedISBN(){
    console.log('went reassignSelectedISBN');
    var inpSelectedGrades = JSON.parse(JSON.stringify(this.selectedGrades));
    var ISBN_KG = JSON.parse(JSON.stringify(this.gradeKGList));
    var ISBN_1 = JSON.parse(JSON.stringify(this.grade1List));
    var ISBN_2 = JSON.parse(JSON.stringify(this.grade2List));
    var ISBN_3 = JSON.parse(JSON.stringify(this.grade3List));
    var ISBN_4 = JSON.parse(JSON.stringify(this.grade4List));
    var ISBN_5 = JSON.parse(JSON.stringify(this.grade5List));
    var ISBN_6 = JSON.parse(JSON.stringify(this.grade6List));
    var ISBN_7 = JSON.parse(JSON.stringify(this.grade7List));
    var ISBN_8 = JSON.parse(JSON.stringify(this.grade8List));
    var ISBN_9 = JSON.parse(JSON.stringify(this.grade9List));    
    var ISBN_10 = JSON.parse(JSON.stringify(this.grade10List));
    var ISBN_11 = JSON.parse(JSON.stringify(this.grade11List));
    var ISBN_12 = JSON.parse(JSON.stringify(this.grade12List));
    if(this.selectedGrades.length !== 0){
        inpSelectedGrades.forEach((element)=> {
            if(element === '0' && ISBN_KG.length >0 ){  
                ISBN_KG.forEach((isbn)=> {                    
                    this.gradeISBNValue.push(isbn);
                });
            }
            if(element === '1' && ISBN_1.length >0 ){
                ISBN_1.forEach((isbn)=> {                    
                    this.gradeISBNValue.push(isbn);
                });
            }
            if(element === '2' && ISBN_2.length >0 ){
                ISBN_2.forEach((isbn)=> {                    
                    this.gradeISBNValue.push(isbn);
                });
            }
            if(element === '3' && ISBN_3.length >0 ){
                ISBN_3.forEach((isbn)=> {                    
                    this.gradeISBNValue.push(isbn);
                });
            }
            if(element === '4' && ISBN_4.length >0 ){
                ISBN_4.forEach((isbn)=> {                    
                    this.gradeISBNValue.push(isbn);
                });
            }
            if(element === '5' && ISBN_5.length >0 ){
                ISBN_5.forEach((isbn)=> {                    
                    this.gradeISBNValue.push(isbn);
                });
            }
            if(element === '6' && ISBN_6.length >0 ){
                ISBN_6.forEach((isbn)=> {                    
                    this.gradeISBNValue.push(isbn);
                });
            }
            if(element === '7' && ISBN_7.length >0 ){
                ISBN_7.forEach((isbn)=> {                    
                    this.gradeISBNValue.push(isbn);
                });
            }
            if(element === '8' && ISBN_8.length >0 ){
                ISBN_8.forEach((isbn)=> {                    
                    this.gradeISBNValue.push(isbn);
                });
            } 
            if(element === '9' && ISBN_9.length >0 ){
                ISBN_9.forEach((isbn)=> {                    
                    this.gradeISBNValue.push(isbn);
                });
            }
            if(element === '10' && ISBN_10.length >0 ){
                ISBN_10.forEach((isbn)=> {                    
                    this.gradeISBNValue.push(isbn);
                });
            }
            if(element === '11' && ISBN_11.length >0 ){
                ISBN_11.forEach((isbn)=> {                    
                    this.gradeISBNValue.push(isbn);
                });
            }
            if(element === '12' && ISBN_12.length >0 ){
                ISBN_12.forEach((isbn)=> {                    
                    this.gradeISBNValue.push(isbn);
                });
            }
        });
        console.log('Connected Callback gradeISBNValue: ',this.gradeISBNValue);
    }
}
    
  @api
    validate() {
        console.log('went validate method:');
        this.validSelection = '';
        if(this.selectedGrades.length === 0) { 
            sessionStorage.setItem("showError", true);
            this.validSelection = 'Yes';
            console.log('Error1');
            return {
                isValid: false,
                errorMessage: 'This field is required. Please enter a value.'
                }; 
        } 
        else if(this.selectedGrades.length !== 0){
            var notValid = false;
            this.selectedGrades.forEach((grade)=> {
                if((grade === '0' && this.gradeKGList.length ===0) ||
                (grade === '1' && this.grade1List.length ===0) ||
                (grade === '2' && this.grade2List.length ===0) ||
                (grade === '3' && this.grade3List.length ===0) ||
                (grade === '4' && this.grade4List.length ===0) ||
                (grade === '5' && this.grade5List.length ===0) ||
                (grade === '6' && this.grade6List.length ===0) ||
                (grade === '7' && this.grade7List.length ===0) ||
                (grade === '8' && this.grade8List.length ===0) ||
                (grade === '9' && this.grade9List.length ===0) ||
                (grade === '10' && this.grade10List.length ===0) ||
                (grade === '11' && this.grade11List.length ===0) ||
                (grade === '12' && this.grade12List.length ===0)){                    
                    notValid = true;                    
                }
            });
            if(notValid){         
                console.log('error2');       
                sessionStorage.setItem("showError", true); 
                this.validSelection = 'No';
                return {
                    isValid: false,
                    errorMessage: 'This field is required. Please enter a value.'
                };
            }
            else{
                sessionStorage.setItem("showError", false);
                console.log('valid1');
                this.validSelection = 'Yes';
                return {isValid: true};
            }
        }
        else{             
            sessionStorage.setItem("showError", false);
            this.validSelection = 'Yes';
            console.log('valid2');
            return {isValid: true}; 
        }
    }
}