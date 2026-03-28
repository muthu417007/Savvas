/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Visualforce Controller for live agent button routing
*
* Controller that provide the different live agent skills/product family we support
* Based on the product choice, the apex class returns the correct chat button ID and Image
* Button and Image ID's are kept on the Chat Button Setting Custom setting 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Romer Pasag   	<Romer.Pasag@pearson.com>
* @modifiedBy     Romer Pasag   	<Romer.Pasag@pearson.com>
* @maintainedBy   Romer Pasag   	<Romer.Pasag@pearson.com>
* @version        1.0
* @created        2018-01-02
* @modified       
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0        	  Romer.Pasag@pearson.com
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public class StartAChatController {
    
    //To store the picklist value which we have selected on VF page i.e (gradPoint,Successmaker)
    public String product {get; set;}
    //To store the button ID to return to visualforce Page
    public string buttonId {get;set;}
    //To store the live agent button Online image URL
    public String OnlineIconURL{get;set;}
    //To store the live agent button Offline image URL
    public String OfflineIconURL{get;set;}
    Map<string,string> buttonSettingMap=new map<String,String>();
    list<String> productList=new list<String>();
    
    //To display list of picklist values on VF page
    public List<selectOption> getPicklistvalues() {
        List<selectOption> options = new List<selectOption>();       
        options.add(new selectOption('Default','None'));
        String name;
        productList.sort();
        for(String p:productList){
            name=p;
            options.add(new selectOption(name,name.replace('_',' ')));
        }
        return options;
    }   

       
    //Set's the button ID based on the product picklist value
    public void setButtonId(String b) {
        this.buttonId = buttonSettingMap.get(b);
    }
    
    //Set's the online image url based on the product picklist value
    public void setOnlineIconURL(String i){
        this.OnlineIconURL=buttonSettingMap.get(i);
    }
    
    //Set's the offline image url based on the product picklist value
    public void setOfflineIconURL(String o){
        this.OfflineIconURL=buttonSettingMap.get(o);
    }
 
    //Constructor, After loading the page to display icon and default button ID
    public StartAChatController () {
        // Queries the custom setting to get the button and Image ID's.  
        Map<String,Chat_Button_Settings__c> btnCS = Chat_Button_Settings__c.getAll();
        
        for(Chat_Button_Settings__c btnValue:btnCS.values()){
            buttonSettingMap.put(btnValue.Name,btnValue.RecordIdOrURL__c);
            if(btnValue.Button__c==TRUE){
                productList.add(btnValue.Name);
            }
        }
        buttonId=buttonSettingMap.get('Default');
        OnlineIconURL=buttonSettingMap.get('Default Icon');
        OfflineIconURL=buttonSettingMap.get('Default Icon');
    }
    
    //After changing picklist value based on the selection to display the product
    //Through actionfunction or actionsupport this method will be called to VF page
    public PageReference selectProduct() {
        if(product!='Default'){
            setButtonId(product);
            setOnlineIconURL('Online');
            setOfflineIconURL('Offline');
        }else{
            setButtonId('Default');
            setOnlineIconURL('Default Icon');
            setOfflineIconURL('Default Icon');
        }
        return null;
    }
}