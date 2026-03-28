public class emailtest {

    public id recId {get;set;}
    
    public string showid {
        get{
            return recId != null ? recId : 'NA';
        }private set;
    }
}