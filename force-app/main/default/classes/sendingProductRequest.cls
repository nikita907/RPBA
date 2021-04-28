public with sharing class sendingProductRequest {
    public sendingProductRequest() {
 }
    @AuraEnabled(cacheable=true)
    public static void getingCoffeeInfo(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://routineautomation3-dev-ed.lightning.force.com/CoffeeProducts__c');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
          if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> coffees = (List<Object>) results.get('CoffeeProducts');
            System.debug('Received the following coffe:');
            for (Object coffee: coffees) {
                  System.debug(coffee);
                }
        }
        else{
        System.debug('Received the following coffe:');
}   
    }
}