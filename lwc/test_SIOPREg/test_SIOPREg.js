import { LightningElement } from 'lwc';
export default class Test_SIOPREg extends LightningElement {
handleabort(event){
    console.log('im in aborrt',event.target.value);
}
hanldemousedoen(event){
       console.log('im in mousedown',event.target.value);
}
handlemouseout(event){
        console.log('im in mouseout',event.target.value);
}
}