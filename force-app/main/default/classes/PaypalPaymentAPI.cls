public class PaypalPaymentAPI {
    /**api response properties */
    public string id;
    public string create_time;
    public string update_time;
    public string state;
    public string intent;
    public Payer payer;
    public string status;
    public List<Tranactions> transactions;
    public List<Links> links;
    
    public class Payer {
        public string payment_method;
    }
    
    public class Tranactions {
        public Amount amount;
        public String description;	
        public String custom;	
        public String invoice_number;
        public ItemList item_list;
    }
    
   public class Amount {
        public String total;	
        public String CurrencyAmount;
        public Details details;
    }
   public class Details {
        public String subtotal;	
        public String tax;	
        public String shipping;	
        public String handling_fee;	
        public String insurance;	
        public String shipping_discount;
    }
   public class ItemList {
        public Items[] items;
        public ShippingAddress shipping_address;
    }
    
   public class Items {
        public String name;	
        public String sku;	
        public String price;	
        public String quantity;	
        public String description;	
        public String tax;
    }
    
   public class ShippingAddress {
        public String recipient_name;
        public String line1;	
        public String line2;	
        public String city;	
        public String state;	
        public String phone;	
        public String postal_code;
        public String country_code;	
    }
    public class Links {
        public String href;	
        public String rel;	
        public String method;
    }  
    /**api response properties end */
     public String errorMessage;
     public Integer responseCode;
     public String getResponseBody;
     public static Integer testCallout = 1;
    
    //Method to create payments
    public static PaypalPaymentAPI CreatePayments (string accessToken, PaypalPaymentRequest request )
    {
        if( accessToken == null && request == null){ 
            return null;
        }
        PaypalCustomSetting__c paypalsetting = PaypalCustomSetting__c.getOrgDefaults();
        PaypalPaymentAPI response = new PaypalPaymentAPI();
        try{
            if(paypalsetting.Client_ID__c != null && paypalSetting.client_Secret__c != null && paypalsetting.URL__c != null){
                
                String papalapi_URL = paypalsetting.URL__c + '/v1/payments/payment';
                
                HttpRequest  Req = new HttpRequest();
                
                Req.setEndPoint(papalapi_URL);
                Req.setMethod('POST');
                Req.setHeader('Authorization', 'Bearer '+accessToken);
                Req.setHeader('Content-Type' , 'application/json');
                
                string body = JSON.serialize(request);
                body = AddStandardKeywords(body);
                
                Req.setBody(body);
                Req.setTimeOut(120000);
                
                HttpResponse Res = new HttpResponse();
                 if (!Test.isRunningTest()){
                	Res = (new Http()).send(Req);
                }
                else{
                    Res.setBody('{ "intent": "sale","payer": { "payment_method": "paypal" }, "transactions": [ { "amount": {  "total": "40.11",  "currency": "USD" }} ], "note_to_payer": "Contact us for any questions on your order.", "redirect_urls": {  "return_url": "https://login.salesforce.com",  "cancel_url": "https://gmail.com" }}');
                    if(testCallout == 1){
                        Res.setStatusCode(201);
                    }  
                }
                
                Integer resCode = Res.getStatusCode();
                String resBody = Res.getBody();
                response.responseCode = resCode;
                response.getResponseBody = resBody;
                
               if(resCode == 201){
					resBody = RemoveStandardKeywords(resBody);
                    response = (PaypalPaymentAPI)JSON.deserialize(resBody, PaypalPaymentAPI.class); 
                   System.debug('createresponse---'+response);
                  
               } 
               else {
                    System.debug(' Error Occured '+resBody);
                       response.errorMessage = 'Unexpected Error while Creating payments on PayPal. '
                     +'Status '+Res.getStatus()+' and Status Code '+ resCode;
                }
            } 
        }
        catch(System.Exception e)
        {
             System.debug('#### Exception Excuted '+e.getMessage());   
             System.debug('#### Exception Excuted 1 '+e.getLineNumber());   
             response.errorMessage = e.getMessage();
        } 
        return response;
        
    }  
    
    //Method to get created payment
    public static PaypalPaymentAPI GetPayments(string accessToken, string paymentID){
         
        if( accessToken == null && paymentID == null){ 
            return null;
        }     
        
        PaypalCustomSetting__c paypalsetting = PaypalCustomSetting__c.getOrgDefaults();
        PaypalPaymentAPI response = new PaypalPaymentAPI();
        
        try{
            if(paypalsetting.Client_ID__c != null && paypalSetting.client_Secret__c != null && paypalsetting.URL__c != null){
                
                String papalapi_URL = paypalsetting.URL__c + '/v1/payments/payment/'+paymentID;
                system.debug('paypalapi_URL'+papalapi_URL);
                
                HttpRequest  Req = new HttpRequest();
                Req.setEndPoint(papalapi_URL);
                Req.setMethod('GET');
                Req.setHeader('Authorization', 'Bearer '+accessToken);
                Req.setHeader('Content-Type' , 'application/json');
 
                Req.setTimeOut(120000);
                
                HttpResponse Res = new HttpResponse();
                if (!Test.isRunningTest()){
                	Res = (new Http()).send(Req);
                }
                else{
                    Res.setBody('{ "intent": "sale","payer": { "payment_method": "paypal" }, "transactions": [ { "amount": {  "total": "40.11",  "currency": "USD" }} ], "note_to_payer": "Contact us for any questions on your order.", "redirect_urls": {  "return_url": "https://login.salesforce.com",  "cancel_url": "https://gmail.com" }}');
                    if(testCallout == 1){
                        Res.setStatusCode(200);
                    } 
                }
                
                Integer resCode = Res.getStatusCode();
                String resBody = Res.getBody();
                response.responseCode = resCode;
                System.debug('GetResponseCode' + resCode);
                response.getResponseBody = resBody;
                
               if(resCode == 200){
					resBody = RemoveStandardKeywords(resBody);
                    response = (PaypalPaymentAPI)JSON.deserialize(resBody, PaypalPaymentAPI.class); 
                   System.debug('getresponse---'+response);
               } 
               else {
                    System.debug(' Error Occured '+resBody);
                       response.errorMessage = 'Unexpected Error while geting payment with PayPal.'
                     +'Status '+Res.getStatus()+' and Status Code '+ resCode;
                }
            } 
        }
        catch(System.Exception e)
        {
             System.debug('#### Exception Excuted '+e.getMessage());   
             System.debug('#### Exception Excuted 1 '+e.getLineNumber());   
             response.errorMessage = e.getMessage();
        } 
        return response;
    }
     //Method to execute payments
    public static PaypalPaymentAPI ExecutePayments (string accessToken, string  paymentId, string PayerId )
    {
        if( accessToken == null && paymentId == null && PayerId == null){ 
            return null;
        }

        PaypalCustomSetting__c paypalsetting = PaypalCustomSetting__c.getOrgDefaults();
        PaypalPaymentAPI response = new PaypalPaymentAPI();
        try{
            if(paypalsetting.Client_ID__c != null && paypalSetting.Client_Secret__c != null && paypalsetting.URL__c != null){
                
                String papalapi_URL = paypalsetting.URL__c + '/v1/payments/payment/'+paymentId+'/execute';
                
                HttpRequest  Req = new HttpRequest();
                
                Req.setEndPoint(papalapi_URL);
                Req.setMethod('POST');
                Req.setHeader('Authorization', 'Bearer '+accessToken);
                Req.setHeader('Content-Type' , 'application/json');
                string body = '{"payer_id":"'+PayerId+'"}';
                Req.setBody(body);
                Req.setTimeOut(120000);
                
                HttpResponse Res = new HttpResponse();
                if (!Test.isRunningTest()){
                	Res = (new Http()).send(Req);
                }
                else{
                    Res.setBody('{ "intent": "sale","payer": { "payment_method": "paypal" }, "transactions": [ { "amount": {  "total": "40.11",  "currency": "USD" }} ], "note_to_payer": "Contact us for any questions on your order.", "redirect_urls": {  "return_url": "https://login.salesforce.com",  "cancel_url": "https://gmail.com" }}');
                    if(testCallout == 1){
                        Res.setStatusCode(200);
                    }  
                }
                
                Integer resCode = Res.getStatusCode();
                String resBody = Res.getBody();
                response.responseCode = resCode;
                response.getResponseBody = resBody;
                
               if(resCode == 200){
					resBody = RemoveStandardKeywords(resBody);
                    response = (PaypalPaymentAPI)JSON.deserialize(resBody, PaypalPaymentAPI.class); 
                    System.debug('executepayments---'+response);
               } 
               else {
                    System.debug(' Error Occured '+resBody);
                       response.errorMessage = 'Unexpected Error while Creating payments on PayPal. '
                     +'Status '+Res.getStatus()+' and Status Code '+ resCode;
                }
            } 
        }
        catch(System.Exception e)
        {
             System.debug('#### Exception Excuted '+e.getMessage());   
             System.debug('#### Exception Excuted 1 '+e.getLineNumber());   
             response.errorMessage = e.getMessage();
        } 
        return response;   
    } 
    
    
    
    //Replacing currency with currencyAmount because currency is a reserve keyword
    //that's why i create property with different name
    //Add standard keyword 
    public static string AddStandardKeywords(string request){
        string temp = request;
        temp = temp.replaceAll('currencyAmount','currency');
        return temp;
    }
    
    //Remove standard keywords before deserialize to store respective values in created properties
    public static string RemoveStandardKeywords(String response) {
        String temp = response;
        temp = temp.replace('currency','currencyAmount');
        return temp;
    }
}