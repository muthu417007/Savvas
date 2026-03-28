import { LightningElement,wire,api,track } from 'lwc';

export default class Lwc_message_Info extends LightningElement {
    @api generalInformations;
    @track TableMessages;
    @track OppName='';
    @track OppOwner='';
    @track OppLeader='';
    @track OppActOwner='';
    @track OppActType='';
    @track OppActName='';
    @track OppActState='';
    @track OppActEasyBridge='';
    @track OppContactTile='';
    @track OppContactPhone='';
    @track OppContactEmail='';
    @track OppStage='';
    @track OppAmount='';
    @track RUMBA_Org_id='';
    @track PilotStatus='';
    @track ProductName='';

    connectedCallback(){
        this.TableMessages=this.generalInformations.split(",");
        this.OppName=this.TableMessages[0];
        this.OppOwner=this.TableMessages[1];
        this.OppLeader=this.TableMessages[2];
        this.OppActOwner=this.TableMessages[3];
        this.OppActType=this.TableMessages[4];
        this.OppActName=this.TableMessages[5];
        this.OppActState=this.TableMessages[6];
        this.OppActEasyBridge=this.TableMessages[7];
        this.OppContactTile=this.TableMessages[8];
        this.OppContactPhone=this.TableMessages[9];
        this.OppContactEmail=this.TableMessages[10];
        this.OppStage=this.TableMessages[11];
        this.OppAmount=this.TableMessages[12];
        this.RUMBA_Org_id=this.TableMessages[13];
        this.PilotStatus=this.TableMessages[14];
        this.ProductName=this.TableMessages[15];
   }

}