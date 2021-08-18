public with sharing class CustomEmailHandlerHelper {
    
    public static void CaseCreation(Map <String,String> emailText) {

        Case caseToCreate = new Case();


        String productSKU = emailText.get('KN_ARTIKEL');
        String productName = emailText.get('ARTIKELNAME');
        String assetSerialNumber = emailText.get('SNKCOO');
        String accountName = emailText.get('FIRMA2');
        String contactName = emailText.get('FIRMA1');

        String userId = emailText.get('PERSONAL');
        String invoiceNumber = emailText.get('KN_RECHNUNG');
        String orderNumber = emailText.get('AUFTRAG');
        String deliveryNote = emailText.get('WARENAUSGANG');
        String deliveryNoteDate = emailText.get('WARENAUSGANG.TERMIN');
        String returnShipment = emailText.get('KN_RUECKSENDUNG');
        String warrantyUntil = emailText.get('KN_GEWAEHRLEISTUNGBIS');
        String RecordTypeName = emailText.get('KN_SERVICEFALL');

        AddProducts(productSKU,caseToCreate);
        AddAssets(assetSerialNumber,caseToCreate);
        AddAccount(accountName,caseToCreate);
        AddContact(contactName,caseToCreate);
        AssignCaseOwner(userId,caseToCreate);
        AddInvoiceNumber(invoiceNumber,caseToCreate);
        AddOrderNumber(orderNumber,caseToCreate);
        AddDeliveryNotes(deliveryNote,caseToCreate);
        //UpdateDeliveryNoteDate(deliveryNote,DeliveryNoteDate,caseToCreate); //? 
        AddReturnShipment(returnShipment,caseToCreate);
        AddWarrantyUntilDate(warrantyUntil,caseToCreate);
        DefineRecordType(recordTypename,caseToCreate);


        if( caseToCreate.AccountId == null || caseToCreate.ContactId == null || caseToCreate.Product__c==null) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String subject = 'Case was not created';
            String emailbody = 'Case was not created because one of the required field contains invalid data or empty value : ' +
            'AccountId , ContactId, AssetId And ProductId. Please, ensure that this values have correct data and try again.';
            email.setSubject( subject );
            List<EmailsToReply__mdt> emailsToReply = EmailsToReply__mdt.getAll().values();
            String emailAddressToSend = String.valueof(emailsToReply.get(0).MainEmailToReply__c);
            List <String> emailsToSend = new List<String>();
            emailsToSend.add(emailAddressToSend);
            email.setToAddresses( emailsToSend);
            email.setPlainTextBody( emailbody );
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});  
        }
        else {
            insert caseToCreate;
        }
    }
 
    //Done

    public static void AddProducts(String productSKU, Case caseToCreate){

        if(productSKU != null){
            List <Product2> productFromEmail = new List <Product2>();
            productFromEmail = [
                SELECT Id 
                FROM Product2 
                WHERE ProductCode =: productSKU
            ];

            if(productFromEmail.size() != 0){
                caseToCreate.Product__c = productFromEmail.get(0).Id;
            }
            else{
                caseToCreate.ProductSerialNumber__c = productSKU;
            }
        }
    }


    //Done

    public static void AddAssets(String assetSerialNumber, Case caseToCreate){

        if(assetSerialNumber != null){
            List <Asset> assetFromEmail = new List <Asset>();
            assetFromEmail = [
                SELECT Id 
                FROM Asset 
                WHERE ProductCode =: assetSerialNumber
            ];

            if(assetFromEmail.size() != 0){
                caseToCreate.AssetId = assetFromEmail.get(0).Id;
                if(caseToCreate.Product__c == null){
                    caseToCreate.Product__c = assetFromEmail.get(0).Product2Id;
                }
            }
            else {
                caseToCreate.AssetSerialNo__c = assetSerialNumber;
            }
        }
    }


    public static void AddAccount(String accountName,Case caseToCreate){
        if(accountName !=null){
            List <Account> accountToPopulate = new List <Account>();
            accountToPopulate = [
                SELECT Id
                FROM Account
                WHERE Id =: accountName
            ];
        if(accountToPopulate.size() != 0){
                caseToCreate.AccountId = accountToPopulate.get(0).Id;
            }
        }
    }

    public static void AddContact (String contactName, Case caseToCreate){
        if(contactName != null){
            List <Contact> contactToPopulate = new List <Contact>();
            contactToPopulate = [
                SELECT Id
                FROM Contact
                WHERE Id =: contactName
            ];
        if(contactToPopulate.size() != 0){
                caseToCreate.ContactId = contactToPopulate.get(0).Id;
            }
        }
    }


    //done

    public static void AssignCaseOwner(String userId,Case caseToCreate){

        List <User> relatedToUserList = new List <User>();

        relatedToUserList = [
            SELECT Id, IsActive
            FROM User
            WHERE Id =: userId
        ];

        if(relatedToUserList.size() != 0){
            User relatedToUser = relatedToUserList.get(0);
            if(relatedToUser.IsActive == true){
                caseToCreate.OwnerId = userId;
            }
        }
    }


    //Done 

   public static void AddInvoiceNumber(String InvoiceNumber, Case caseToCreate){

        if(InvoiceNumber != null) {
            List <Invoice__c> invoicesList = new List <	Invoice__c>();
            invoicesList = [
                SELECT Id
                FROM 	Invoice__c
                WHERE Name =: InvoiceNumber
            ];

            if(invoicesList.size()!=0){
                caseToCreate.Invoice__c = invoicesList.get(0).Id;
            }
            else{
                caseToCreate.InvoiceNo__c = InvoiceNumber;
            }
        }
    }




    //done
    public static void AddOrderNumber(String OrderNumber, Case caseToCreate){
         if(OrderNumber != null) {
            List <Order__c> ordersList = new List <Order__c>();
            ordersList = [
                SELECT Id
                FROM Order__c
                WHERE Name =: OrderNumber
            ];

            if(ordersList.size()!=0){
                caseToCreate.Order__c = ordersList.get(0).Id;
            }
            else{
                caseToCreate.OrderNo__c = OrderNumber;
            }
        }
    }



    //done 

    public static void AddDeliveryNotes(String deliveryNote, Case caseToCreate){

        if(deliveryNote != null){
            List <Delivery_Note__c> relatedDeliveryNotePos = new List <Delivery_Note__c>();
            relatedDeliveryNotePos = [
                SELECT Id 
                FROM Delivery_Note__c
                WHERE  	Name =: deliveryNote
            ];

            if(relatedDeliveryNotePos.size() != 0){
                caseToCreate.DeliveryNote__c = relatedDeliveryNotePos.get(0).Id;
            }

            else{
                caseToCreate.DeliveryNoteText__c = deliveryNote;
            }
        }
    }


    // done 

    /*public static void UpdateDeliveryNoteDate(String deliveryNote, String deliveryDate, Case caseToCreate){

        List <Delivery_Note__c> relatedDeliveryNote = new List <Delivery_Note__c>();
            relatedDeliveryNote = [
                SELECT Id,DATUM__c
                FROM Delivery_Note__c
                WHERE Id =: deliveryNote
            ];

            if(relatedDeliveryNote.size() != 0){
                relatedDeliveryNote.get(0).DATUM__c = date.valueOf(deliveryDate);
                update relatedDeliveryNote.get(0);
            }

    }*/

    //Done - fixed 
    public static void AddReturnShipment(String returnShipment, Case caseToCreate){

        if(returnShipment != null){
            List <Return_Shipment__c> relatedReturnShipmentList = new List <Return_Shipment__c>();
            relatedReturnShipmentList = [
                SELECT Id 
                FROM Return_Shipment__c
                WHERE  	Name =: returnShipment
            ];

            if(relatedReturnShipmentList.size() != 0){
                caseToCreate.ReturnShipment__c = relatedReturnShipmentList.get(0).Id;
            }
            else{
                caseToCreate.ReturnReferenceNo__c = returnShipment;
            }
        }
    }


    //Done 
    public static void AddWarrantyUntilDate(String warrantyUntil, Case caseToCreate){
        if(warrantyUntil != null){
            caseToCreate.WarrantyUntil__c = date.valueOf(warrantyUntil);
        }
    }


    //Done

    public static void DefineRecordType(String recordTypeName, Case caseToCreate){
        if(recordTypeName != null){
            Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
            if( recordTypeId != null) {
                caseToCreate.RecordTypeId = recordTypeId;
            }
        }
    }

}