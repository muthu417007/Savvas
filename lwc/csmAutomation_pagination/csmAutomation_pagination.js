import { LightningElement,api } from 'lwc';

export default class CsmAutomation_pagination extends LightningElement {
    
    @api pageSize ;
    totalrecordscount = 0;
    pageList =[] ;
    startforShift= 8;
    index = 0;
    clickedPage = 1;
    allowedshiftno=[];
    totalpages=0;

    connectedCallback(){
        if(this.totalrecordscount && this.pageSize){
            this.clickedPage = 1;
            this.totalpages = Math.ceil(this.totalrecordscount / this.pageSize);
            let default_list=[];
            if(this.totalpages<=10){
                for(let i=1;i<=this.totalpages;i++){
                    default_list.push(i);
                }
            }
            let pgl_default = this.totalpages >10 ? [1,2,3,4,5,6,7,8,'...',this.totalpages] : default_list;
            this.pageList = pgl_default;
        }
    }

    renderedCallback(){
        this.changeColorOnClick();
    }

    changeColorOnClick(){
        this.template.querySelectorAll('lightning-button').forEach(e=>{
            if(Number(e.label) === this.clickedPage){
                e.classList.add('currentpage');
                e.blur();
            }else{
                e.classList.remove('currentpage');
            }
        });
    }

    @api 
    get totalrecords(){
        return this.totalrecordscount;
    }
    
    set totalrecords(value){
        this.totalrecordscount = value;
        this.connectedCallback();
    }

    get startrange(){
        return (((this.clickedPage-1)*this.pageSize)+1);
    }

    get endrange(){
         if(this.clickedPage === this.totalpages){
             return this.totalrecords
        }
        else
        return ((this.pageSize*this.clickedPage));
    }
    
    get disableleftarrow(){
        return (this.clickedPage === 1)
    }

    get disablerightarrow(){
        return (this.clickedPage === this.totalpages);
    }

    get rightshift(){
        return Number(this.index)===2;
    }

    get leftshift(){
        return (Number(this.index)===7 || Number(this.index)===8);
    }

    get isStartNoClicked(){
        return (this.clickedPage - 1 === 4 || this.clickedPage<8 );
    }

    get isLastNoClcked (){  
        return (this.totalpages - this.clickedPage >=4 &&  this.totalpages - this.clickedPage <8);
    }

    get isLastPageClicked(){
        let last8array = [];
        for(let i=this.totalpages-6;i<=this.totalpages;i++){
            last8array.push(i);
        }
        return (last8array.includes(this.clickedPage));
    }

    getallowedshiftno(){
        if(this.allowedshiftno){
            if(!this.allowedshiftno.includes(8)){
                this.allowedshiftno.push(8);
            }
            if(!this.allowedshiftno.includes(this.totalpages)){
                this.allowedshiftno.push(this.totalpages);
            }
        }
    }

    handlePrevious(event){
        this.clickedPage = this.clickedPage-1;
        this.dispatchPaginationevent();
        this.getallowedshiftno();
        if(this.clickedPage !== '...' && this.totalpages >10) this.displayePages(this.clickedPage);
    }

    handleNext(event){
        this.clickedPage = this.clickedPage+1;
        this.dispatchPaginationevent();
        this.getallowedshiftno();
        if(this.clickedPage !== '...' && this.totalpages >10) this.displayePages(this.clickedPage);
    }

    handleClick(event){
        this.index = event.target.dataset.index;
        this.clickedPage = Number(event.target.label);
        this.getallowedshiftno();
        if(event.target.label !== '...') this.dispatchPaginationevent();
        if(event.target.label !== '...' && this.totalpages >10){
            this.displayePages(this.clickedPage);
        }
    }

    displayePages(clickedPage){
        if(clickedPage === this.startforShift){
            this.pageList[1] = '...';
        }
        
        if(this.allowedshiftno && !this.isStartNoClicked && !this.isLastPageClicked && (this.allowedshiftno.includes(clickedPage) || this.isLastNoClcked)){
            this.pageList[2] = clickedPage-3;
            this.pageList[3] = clickedPage-2;
            this.pageList[4] = clickedPage-1;
            this.pageList[5] = clickedPage;
            this.pageList[6] = clickedPage+1;
            this.pageList[7] = clickedPage+2;
            this.pageList[8] = clickedPage+3;
            if(this.isLastNoClcked){
                this.pageList[9] = this.pageList[9] !== '...' ? this.totalpages : '...';
                if(this.pageList[9] && this.pageList[9] === this.totalpages){
                    this.pageList.pop();
                }
            }
            this.allowedshiftno = [];
            this.allowedshiftno.push(this.pageList[2],this.pageList[8]);
        }
        
        if((!this.isLastNoClcked || this.rightshift) && !this.isLastPageClicked && !this.isStartNoClicked){
            
            this.pageList[9] = '...';
            this.pageList[10] = this.totalpages;
        }
        
        if((this.isStartNoClicked && this.allowedshiftno.includes(this.clickedPage)) || this.clickedPage === 1){
            
            this.pageList = this.totalpages <= 8 ? [1,2,3,4,5,6,7,8] : [1,2,3,4,5,6,7,8,'...',this.totalpages];
        }

        if(this.isLastPageClicked && this.allowedshiftno.includes(this.clickedPage)){
            this.pageList[1] = '...';
            this.pageList[2] = this.totalpages-7;
            this.pageList[3] = this.totalpages-6;
            this.pageList[4] = this.totalpages-5;
            this.pageList[5] = this.totalpages-4;
            this.pageList[6] = this.totalpages-3;
            this.pageList[7] = this.totalpages-2;
            this.pageList[8] = this.totalpages-1;
            this.pageList[9] = this.totalpages;
            if(this.pageList[10]){
                this.pageList.pop();
            }
            this.allowedshiftno = [];
            this.allowedshiftno.push(this.pageList[2]);
        }
        this.pageList = [...this.pageList];

    }

    dispatchPaginationevent(){
        this.dispatchEvent(new CustomEvent('pagination', {
                "detail": this.clickedPage,
                bubbles: true,
                composed: true
            }));
    }
}