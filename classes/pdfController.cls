public class pdfController {
    		public String pdfBase64 { get; private set; }
        public pdfController()
    {

                String token = 'e20PhTkEsuvI56ahr1qtmYELHEXv_HQXfnd26-itvI_miVYgPUZR-IwNMRMbhZ19CcXqbmb0E6w3O5SwGjyvAUiRxXB-cWO4cO4nKuyRXlig9xR9S3eWzXbTSLwKDh7nD9TcJvZ2PHI19rdSE7u_zj2fIlpanTM0oAWMAva6w1NCHq_Nu9xWTi8yxOkFgGIwk_eAF-obBpq0QJA-EQdndd1H6V7a_DOBXGjWfeO8BG27HH9Zu_3IsFEYeULlexQZQdUIUUpz2rgjSKlziz1qpZ13lEBm_1kWBgVZR6zB4rA';
                HttpResponse response ;
                Http http1 = new Http();    
                HttpRequest request = new HttpRequest();
                request.setMethod('POST');
                request.setHeader('Content-Type','application/json');
                request.setHeader('Authorization', 'Bearer '+token);
                request.setTimeout(120000);
                request.setEndpoint('https://radar-docsqa.savvas.com/api/RADAR/GetDoc');
                String requestString ='{"DocumentNumber":"4027015275","DocType":"02","EmailID":"","Combined":"N","IncludePOD":"N","AccountNumber":null,"Month":null,"Year":null}';
                request.setBody(requestString);
                response = http1.send(request);
				String jsonResponseData = response.getBody();
				system.debug('data we got is'+jsonResponseData);
				pdfBase64 = EncodingUtil.base64Encode(response.getBodyAsBlob());
				system.debug('data is'+pdfBase64);
    }
}