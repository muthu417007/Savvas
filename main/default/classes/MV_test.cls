@isTest
private class MV_test{
    @isTest
    private static void dotest(){
        MVLogin sso = new MVLogin();
        sso.retrieve();
        string result = sso.getSSO();
        string restult2 = sso.getResult();
        //sso.InitializeServiceHeader();
        //sso.MarketViewLogin();
        //string hash = sso.CreateHash('laksjd@asdklj.com', '127.0.0.1', '14/14/9999 11:11:11 GMT');
        //CalculateMD5Hash('1219jjw9d0j123ha9dh23oi');
        
        directconnectauthServicecontracts service = new directconnectauthServicecontracts();
        
        
        directconnectauthServicecontracts.MarketViewAuthenticationResponse mvar = new directconnectauthServicecontracts.MarketViewAuthenticationResponse();
        
        directconnectauthServicecontracts.MarketViewAuthenticationRequest mvareq = new directconnectauthServicecontracts.MarketViewAuthenticationRequest();
        
        directconnectauthServicecontracts.SeatInfo si = new directconnectauthServicecontracts.SeatInfo();
        
        directconnectauthServicecontracts.MarketViewSeatValidateResponse SeatValidation;
        
        directconnectauthServicecontracts.UserAuthenticationService asd = new directconnectauthServicecontracts.UserAuthenticationService();

        directconnectauthServicecontracts.AccessMarketViewAuthenticationRequest amvar = new directconnectauthServicecontracts.AccessMarketViewAuthenticationRequest(); 

        directconnectauthServicecontracts ws = new directconnectauthServicecontracts();
        directconnectauthServicecontracts.AuthHeader ah = new directconnectauthServicecontracts.AuthHeader();
        directconnectauthServicecontracts.AuthSignOn aso = new directconnectauthServicecontracts.AuthSignOn();
        directconnectauthServicecontracts.MarketViewAutoLoginRequest mvalr = new directconnectauthServicecontracts.MarketViewAutoLoginRequest(); 
        //asd.SeatValidation(si);
       directconnectauthServicecontracts.MarketViewSeatValidateRequest mvsvr = new directconnectauthServicecontracts.MarketViewSeatValidateRequest(); 
        directconnectauthServicecontracts.UserAuthSignOn uaso = new directconnectauthServicecontracts.UserAuthSignOn();
        //asd.AccessMarketViewAuthentication(uaso);
        
//        asd.UserAuthentication(uaso);

    }
}