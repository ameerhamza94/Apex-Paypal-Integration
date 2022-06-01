public class PaypalAuthorizeAPI {
    /**api response properties */
    public String scope;
    public String access_token;
    public String token_type;
    public String app_id;
    public Integer expires_in;
    public String nonce;
    public DateTime experiesInTime;
    /**api response properties End*/
    
    public Integer responseCode;
    public String getResponseBody;
    public String errorMessage;
    
    public static PaypalAuthorizeAPI GetAccessToken(){
        PaypalAuthorizeAPI response = new PaypalAuthorizeAPI();
        try {
            PaypalCustomSetting__c paypalsetting = PaypalCustomSetting__c.getOrgDefaults();
            if(paypalsetting.Client_ID__c != null && paypalSetting.client_Secret__c != null && paypalsetting.URL__c != null){
                
                String papalapi_URL = paypalsetting.URL__c + '/v1/oauth2/token';
                
                String dataToEncode = paypalsetting.Client_ID__c+':'+paypalsetting.client_Secret__c;
                Blob blobValue = Blob.valueOf(dataToEncode);
                String encodedData = 'Basic ' + EncodingUtil.base64Encode(blobValue);  
                String body = 'grant_type=client_credentials';
                
                HttpRequest  Req = new HttpRequest();
       
                Req.setMethod('POST');
                Req.setHeader('Authorization', encodedData);
                Req.setHeader('Content-Type' , 'x-www-form-urlencode');
                Req.setBody(body);
                Req.setTimeOut(120000);
                Req.setEndPoint(papalapi_URL); 
                
                HttpResponse Res = new HttpResponse();
                if (!Test.isRunningTest()) {
                	Res = (new Http()).send(Req);
                }
                else{
                   res.setBody('{"scope": "https://uri.paypal.com/services/invoicing https://uri.paypal.com/services/disputes/read-buyer https://uri.paypal.com/services/payments/realtimepayment https://uri.paypal.com/services/disputes/update-seller https://uri.paypal.com/services/payments/payment/authcapture openid https://uri.paypal.com/services/disputes/read-seller https://uri.paypal.com/services/payments/refund https://api-m.paypal.com/v1/vault/credit-card https://api-m.paypal.com/v1/payments/.* https://uri.paypal.com/payments/payouts https://api-m.paypal.com/v1/vault/credit-card/.* https://uri.paypal.com/services/subscriptions https://uri.paypal.com/services/applications/webhooks","access_token": "A21AAFEpH4PsADK7qSS7pSRsgzfENtu-Q1ysgEDVDESseMHBYXVJYE8ovjj68elIDy8nF26AwPhfXTIeWAZHSLIsQkSYz9ifg","token_type": "Bearer","app_id": "APP-80W284485P519543T","expires_in": 31668, "nonce": "2020-04-03T15:35:36ZaYZlGvEkV4yVSz8g6bAKFoGSEzuy3CQcz3ljhibkOHg"}');
				}
                
                Integer resCode = Res.getStatusCode();
                String resBody = Res.getBody(); 
                response.responseCode = resCode;
                response.getResponseBody = resBody;
                
                if(resCode == 200) {
                    response = (PaypalAuthorizeAPI)JSON.deserialize(resBody, PaypalAuthorizeAPI.class);   
                    system.Debug('response'+ response.access_token);
                }
                else {
                    System.debug(' Error Occured '+resBody);
                    response.errorMessage = 'Unexpected Error while communicating with PayPal API. '
                     +'Status '+Res.getStatus()+' and Status Code '+ resCode;
                }
            }
            
        }
        catch(System.Exception e){
            System.debug('#### Exception Excuted '+e.getMessage());   
            System.debug('#### Exception Excuted 1 '+e.getLineNumber());   
            response.errorMessage = e.getMessage();
        }      
        return response;
    }  
}