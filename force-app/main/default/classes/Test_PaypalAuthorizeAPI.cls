@isTest
public class Test_PaypalAuthorizeAPI {

     static testMethod void testAccessToken() {

         PaypalCustomSetting__c setting = new PaypalCustomSetting__c();
         setting.Client_ID__c = 'AYPnIh0k0BFVv8ovi8oQtE6m2zAEF6gfDRDpJBs_WHvozOMEuq02jO2l9dLtpk6Enyr1a7OqYKu1ghSA';
         setting.client_Secret__c = 'EAj6bcD1lNGipMYgmtXJAv6E8mcFeVbcXnNKEeh8uwNtpyz_kyA5FS3FzTHvJXVdgf4fd1Dym4GxpSAh';
         setting.URL__c = 'https://www.google.com';
         insert setting;
         
         PaypalAuthorizeAPI res = new PaypalAuthorizeAPI();
         Test.startTest();
         res = PaypalAuthorizeAPI.GetAccessToken();
         Test.stopTest();
         
    }
}