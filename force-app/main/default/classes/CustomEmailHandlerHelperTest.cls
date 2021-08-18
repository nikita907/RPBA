@IsTest

public with sharing class CustomEmailHandlerHelperTest {
    static testMethod void TestCaseCreationNegative()
    {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        email.subject = 'Test Email Subject';
        env.fromAddress = 'sbrady@digitalhands.com';
        email.plainTextBody = 'ARTIKELNAME:ProductTest '+  '\n' +
        'SNKCOO:545454545'+ '\n' +
        'KN_RECHNUNG:2212122323'+ '\n' +
        'AUFTRAG:878787878'+ '\n' +
        'WARENAUSGANG:qwerty'+ '\n' +
        'WARENAUSGANG.TERMIN:zxcvb'+ '\n' +
        'KN_RUECKSENDUNG:1eewe34'+ '\n' +
        'KN_GEWAEHRLEISTUNGBIS:'+ Date.newInstance(2016, 12, 9)+'\n' +
        'PERSONAL:TestOwner'+ '\n' +
        'KN_SERVICEFALL:Maintenance';

        CustomEmailHandler emailHandler = new CustomEmailHandler();

        emailHandler.handleInboundEmail(email, env);

        List <Case> createdCase = new List <Case>();

        createdCase = [
            SELECT Id
            FROM Case
            WHERE InvoiceNo__c = '2212122323'
            AND OrderNo__c = '878787878'
        ];

        System.assertEquals(0,createdCase.size());
    }

    static testMethod void TestCaseCreationPositive()
    {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();


        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Type = 'Competitor';

        insert acc;

        Contact cont = new Contact();
        cont.LastName =  'Tester';
        cont.AccountId = acc.Id;

        insert cont;

        Product2 product = new Product2();
        product.Name = 'Test product';
        product.ProductCode = '565656';

        insert product;

        Asset asset = new Asset();
        asset.Product2Id = product.Id;
        asset.Name = 'Test Asset';
        asset.AccountId = acc.Id;
        asset.ContactId = cont.Id;

        insert asset;

        System.debug('ContactId is --------------------' + cont.Id);

        email.subject = 'Test Email Subject';
        env.fromAddress = 'sbrady@digitalhands.com';
        email.plainTextBody = 'KN_ARTIKEL:'+product.ProductCode + '\n' +
        'FIRMA2:'+acc.Id +  '\n' +
        'FIRMA1:'+cont.Id +  '\n' +
        'SNKCOO:'+asset.Id+'\n' +
        'KN_RECHNUNG:2212122323'+ '\n' +
        'AUFTRAG:878787878'+ '\n' +
        'WARENAUSGANG:qwerty'+ '\n' +
        'WARENAUSGANG.TERMIN:zxcvb'+ '\n' +
        'KN_RUECKSENDUNG:1eewe34'+ '\n' +
        'KN_GEWAEHRLEISTUNGBIS:'+ Date.newInstance(2016, 12, 9)+'\n' +
        'PERSONAL:TestOwner'+ '\n' +
        'KN_SERVICEFALL:Maintenance';

        CustomEmailHandler emailHandler = new CustomEmailHandler();

        emailHandler.handleInboundEmail(email, env);

        List <Case> createdCase = new List <Case>();

        createdCase = [
            SELECT Id
            FROM Case
            WHERE InvoiceNo__c = '2212122323'
            AND OrderNo__c = '878787878'
        ];

        System.assertEquals(1,createdCase.size());
    }
}
