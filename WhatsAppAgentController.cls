public with sharing class WhatsAppAgentController {
    
    // Get Access Token from Custom Metadata
    public static Meta_API_Configuration__mdt getAMetaAPIConfig() {
        Meta_API_Configuration__mdt config = [SELECT Access_Token__c, Phone_Number_ID__c, Message_Template__c FROM Meta_API_Configuration__mdt LIMIT 1];
        return config;
    }

    // Filter Contact based on seacrh key and type
    public static List<Wrapper.ContactWrapper> getFilteredContactList(String searchKey) {
        // Initialize the result list
        List<Wrapper.ContactWrapper> contactList = new List<Wrapper.ContactWrapper>();

        try {

            // Analyze the input to determine the type
            String searchType;
            if (searchKey.contains('@') && searchKey.contains('.')) {
                searchType = 'Email'; // Email detection
            } else if (!String.isBlank(searchKey) && isNumeric(searchKey)) {
                searchType = 'Phone'; // Phone detection
            } else {
                searchType = 'Name'; // Default to Name
            }

            // Construct the query based on the search type
            String query = 'SELECT Id, Name, Phone, Email FROM Contact WHERE ';

            if (searchType == 'Name') {
                query += 'Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\'';
            } else if (searchType == 'Phone') {
                query += 'Phone LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\'';
            } else if (searchType == 'Email') {
                query += 'Email LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\'';
            } else {
                // Return an empty list if the search type is invalid
                return contactList;
            }

            // Execute the query
            for (Contact contact : Database.query(query)) {
                contactList.add(new Wrapper.ContactWrapper(contact.Id, contact.Name, contact.Phone, contact.Email));
            }
            system.debug('ContactList:'+ContactList);
        } catch (Exception e) {
            throw new AuraHandledException('Error: ' + e.getMessage());
        }
        return contactList;
    }

    // Send the message to the contact
    public static List<String> sendMessageToContact(String phone) {
        // Initialize the response to send as Invocable Method do not support return type of String
        List<String> responses = new List<String>();

        // Check for Contact Phone
        if (String.isNotBlank(phone)) {
            responses.add(sendWhatsAppTemplateMessage(phone));
        } else {
            responses.add('❌ No phone number found for selected Contact');
        }
        return responses;
    }

    public static String sendWhatsAppTemplateMessage(String recipientNumber) {
        try {
            if (String.isEmpty(recipientNumber)) {
                return '❌ No phone number provided!';
            }

            // Get Info from Custom Metadata
            Meta_API_Configuration__mdt config = getAMetaAPIConfig();
            String phoneNumberId = config.Phone_Number_ID__c; 
            String accessToken = config.Access_Token__c;
            String messageTemplate = config.Message_Template__c;

            system.debug('phoneNumberId: ' + phoneNumberId);
            system.debug('accessToken: ' + accessToken);
            system.debug('messageTemplate: ' + messageTemplate);
            String endpoint = 'https://graph.facebook.com/v22.0/' + phoneNumberId + '/messages';

            // JSON Payload
            Map<String, Object> payload = new Map<String, Object>{
                'messaging_product' => 'whatsapp',
                'to' => recipientNumber,
                'type' => 'template',
                'template' => new Map<String, Object>{
                    'name' => messageTemplate,
                    'language' => new Map<String, String>{ 'code' => 'en_US' }
                }
            };

            // HTTP Request
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            req.setBody(JSON.serialize(payload));

            // Callout Execution
            Http http = new Http();
            HttpResponse res = http.send(req);

            system.debug('Response:'+res);
            if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
            return '✅ Message Sent Successfully!';
        } else {
            return '❌ Failed to send message! Phone Number is not added in Recipient list';
        }
        } catch (Exception e) {
            return '❌ Error sending WhatsApp message: ' + e.getMessage();
        }
    }

    // Check for Numeric
    public static Boolean isNumeric(String input) {
        try {
            // Convert to Integer from String
            Integer.valueOf(input); 
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}