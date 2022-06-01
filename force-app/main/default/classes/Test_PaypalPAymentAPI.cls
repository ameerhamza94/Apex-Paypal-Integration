@isTest
public class Test_PaypalPAymentAPI {
    
    @TestSetup
    static void ConfigureCustomSetting() {
        PaypalCustomSetting__c setting = new PaypalCustomSetting__c();
        setting.Client_ID__c = 'AYPnIh0k0BFVv8ovi8oQtE6m2zAEF6gfDRDpJBs_WHvozOMEuq02jO2l9dLtpk6Enyr1a7OqYKu1ghSA';
        setting.client_Secret__c = 'EAj6bcD1lNGipMYgmtXJAv6E8mcFeVbcXnNKEeh8uwNtpyz_kyA5FS3FzTHvJXVdgf4fd1Dym4GxpSAh';
        setting.URL__c = 'https://www.google.com';
        insert setting;
    }
    
    static testMethod void testCreatePayment() {
        PaypalCustomSetting__c setting = PaypalCustomSetting__c.getOrgDefaults();
        
        PaypalPaymentRequest.Payer payer = new PaypalPaymentRequest.Payer();
        payer.payment_method = setting.Payment_Method__c;
        
        PaypalPaymentRequest.Redirecturls urls = new PaypalPaymentRequest.Redirecturls();
        urls.return_url = 'login.salesforce.com';
        urls.cancel_url = 'google.com';
        
        PaypalPaymentRequest.Details details = new PaypalPaymentRequest.Details();
        details.subtotal = '40.00';
        details.tax = '0.07';
        details.shipping = '0.03';
        details.handling_fee = '1.00';
        details.shipping_discount= '-1.00';
        details.insurance = '0.01';
        
        PaypalPaymentRequest.Amount amt = new PaypalPaymentRequest.Amount();
        amt.total = '40.11';
        amt.currencyAmount = setting.Currency__c;
        amt.details = details;
        
        PaypalPaymentRequest.Paymentoptions payOption = new PaypalPaymentRequest.Paymentoptions();
        payOption.allowed_payment_method = 'INSTANT_FUNDING_SOURCE';
        
        PaypalPaymentRequest.Transactions td = new PaypalPaymentRequest.Transactions();
        td.description = 'Test';
        td.custom  = 'EBAY_EMS_90048630024435';
        td.invoice_number = '487874558we9673';
        td.soft_descriptor = 'ECHI5786786';
        td.amount = amt;
        td.payment_options = payOption;
        
        List<PaypalPaymentRequest.Transactions> tdList = new List<PaypalPaymentRequest.Transactions>();
        tdList.add(td);
        
        PaypalPaymentRequest  request = new PaypalPaymentRequest();
        request.intent = setting.Intent__c;
        request.payer = payer;
        request.transactions = tdList;
        request.note_to_payer = 'Test Transaction';
        request.redirect_urls = urls;
        
        string token = 'SDEFRtvgyuHJKL';
        PaypalPaymentAPI res = new PaypalPaymentAPI();
        Test.startTest();
        res = PaypalPaymentAPI.CreatePayments(token,request);
        Test.stopTest();
    }
    
    static testMethod void testgetPayment() {
        string token = 'SDEFRtvgyuHJKL';
        string paymentId = 'PAY1234567FT';
        PaypalPaymentAPI res = new PaypalPaymentAPI();
        Test.startTest();
        res = PaypalPaymentAPI.GetPayments(token,paymentId);
        Test.stopTest();  
    }
    
    static testMethod void executePayment() {
        string token = 'SDEFRtvgyuHJKL';
        string paymentId = 'PAY1234567FT';
        string payerID = 'PY234YU';
        PaypalPaymentAPI res = new PaypalPaymentAPI();
        Test.startTest();
        res = PaypalPaymentAPI.ExecutePayments(token,paymentId,payerID);
        Test.stopTest();  
    } 
}