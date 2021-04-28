@RestResource(urlMapping='/CoffeeProducts')
global with sharing class QuantityOfCoffee {
    @HttpGet
        global static String getProductQuantity() {
            RestRequest request = RestContext.request;
              List<CoffeeProducts__c> results =  [SELECT Quantity__c,Name
                            FROM CoffeeProducts__c];
            return JSON.serialize(results);
        }
    public QuantityOfCoffee() {
    }
}