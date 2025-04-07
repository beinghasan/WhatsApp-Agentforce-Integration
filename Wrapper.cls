public with sharing class Wrapper {

    // Wrapper class to hold the Contact data
    public class ContactWrapper {
        @InvocableVariable(label='Contact ID' description='Unique Identifier of Contact. List down even if multiple contact records are fetched. Format data in tabular such as rows & columns.' required=true)
        public String contactId;

        @InvocableVariable(label='Name' description='Name of the Contact. List down even if multiple contact records are fetched. Format data in tabular such as rows & columns.' required=true)
        public String name;

        @InvocableVariable(label='Phone' description='Phone Number of the Contact. List down even if multiple contact records are fetched. Format data in tabular such as rows & columns.')
        public String phone;

        @InvocableVariable(label='Email' description='Email Address of the Contact. List down even if multiple contact records are fetched. Format data in tabular such as rows & columns.')
        public String email;

        // No-argument constructor (required for serialization)
        public ContactWrapper() {
            // No initialization required
        }

        // Constructor
        public ContactWrapper(String contactId, String name, String phone, String email) {
            this.contactId = contactId;
            this.name = name;
            this.phone = phone;
            this.email = email;
        }
    }

    // Wrapper class to accept search input
    public class SearchInput {
        @InvocableVariable(label='Search Key' description='Input value to search contacts by Name, Phone, or Email. If Multiple contacts are found with the input, list down all on the UI.' required=true)
        public String searchKey;
    }
}