global class CustomEmailHandler implements Messaging.InboundEmailHandler {
 
    global Messaging.InboundEmailResult handleInboundEmail(
        Messaging.inboundEmail email, 
        Messaging.InboundEnvelope env){
   
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        String emailText= '';
        emailText = email.plainTextBody;
        List<String> keyValueList = emailText.split('\n');
        Map<String,String> keys = new Map <String,String>();
        for(String keyValue : keyValueList){
            List<String> keyAndValueList = keyValue.split(':');
            if(keyAndValueList.size()>=1){
                String key = keyAndValueList[0];
                String value = keyAndValueList[1];
                keys.put(key,value);
            }
        }

        if(keys.keySet().size() != 0){
            CustomEmailHandlerHelper.CaseCreation(keys);
        }

        return null;
    }
  }