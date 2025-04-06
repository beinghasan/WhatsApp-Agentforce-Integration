public with sharing class SendWhatsAppMessage {
    @InvocableMethod(
        label='Process Selected Contact' 
        description='Processes the selected contact from DisplayContactList response.'
    )
    public static List<String> processSelectedContact(List<Wrapper.ContactWrapper> selectedContacts) {
        Wrapper.ContactWrapper selectedContact;

        // Check if the list is not empty
        if (selectedContacts != null && !selectedContacts.isEmpty()) {
            selectedContact = selectedContacts[0]; // Assuming single selection for simplicity
        }
        return WhatsAppAgentController.sendMessageToContact(selectedContact.phone);
    }
}