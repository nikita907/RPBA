@IsTest

public with sharing class CustomEmailHandlerTest {
    static testMethod void TestinBoundEmail()
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

        System.assertEquals(null,emailHandler.handleInboundEmail(email, env));
    }
}
