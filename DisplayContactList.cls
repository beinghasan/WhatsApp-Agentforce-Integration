public with sharing class DisplayContactList {
    @InvocableMethod(
        label='Get Contact List by Search Key' 
        description='Fetches a list of contacts based on Name, Phone, or Email search key.'
    )
    
    public static List<Wrapper.ContactWrapper> getContactList(List<Wrapper.SearchInput> searchInputs){
        // Initialize the wrapper
        List<Wrapper.ContactWrapper> contactList = new List<Wrapper.ContactWrapper>();
        String searchKey;

        // Get the first input from the provided list
        if (searchInputs != null && !searchInputs.isEmpty()) {
            Wrapper.SearchInput input = searchInputs[0];
            searchKey = input.searchKey;
        }

        contactList = WhatsAppAgentController.getFilteredContactList(searchKey);
        return contactList;
    }
}