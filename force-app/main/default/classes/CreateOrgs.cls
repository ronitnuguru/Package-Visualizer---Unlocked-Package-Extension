@JsonAccess(serializable='always' deserializable='always')
global with sharing class CreateOrgs {
    
    @InvocableMethod(label='Create Orgs' description='Show a custom list of orgs available for ISVs to spin up')
    global static List<CreateOrgsResponse> findOrgs(List<CreateOrgsRequest> req){

        String className = 'GenAiPromptTemplateController';
        String methodName = 'singleFreeText';
        String promptTemplateName = 'ISV_Agent_Create_Orgs';
        String objectInput = 'Org_Request';
        String result;

        // Send to Prompt Template
        try { 
            String namespacedClass = 'pkgviz.'+className; 
            Callable callableInstance = (Callable) Type.forName(className).newInstance(); 
            Map<String, Object> payload = new Map<String, Object> { 
                'recordId' => req[0].orgRequest, 
                'objectInput' => objectInput, 
                'promptTemplateName' => promptTemplateName  
            }; 
            result = (String) callableInstance.call(methodName, payload); 
            List<Org> orgsList = (List<Org>) JSON.deserialize(result, List<Org>.class);

            List<CreateOrgsResponse> orgsResponseList = new List<CreateOrgsResponse>();
            CreateOrgsResponse orgsResponse = new CreateOrgsResponse(orgsList);
            orgsResponseList.add(orgsResponse);

            return orgsResponseList;
        } catch (Exception e) { 
            throw new AuraHandledException(e.getMessage()); 
        }
    }

    @JsonAccess(serializable='always' deserializable='always')
    global class CreateOrgsRequest {
        @InvocableVariable(label='Org Request'description='Type of org being requested' required=true)
        global String orgRequest;
    }

    @JsonAccess(serializable='always' deserializable='always')
    global class CreateOrgsResponse {
        @InvocableVariable
        global List<Org> orgs;

        global CreateOrgsResponse(List<Org> orgs){
            this.orgs = orgs;
        }
    }

    @JsonAccess(serializable='always' deserializable='always')
    global class Org {
        @InvocableVariable
        global String name;

        @InvocableVariable
        global String description;

        @InvocableVariable
        global String purpose;

        @InvocableVariable
        global String trialTemplateId;

        @InvocableVariable
        global String edition;

        @InvocableVariable
        global String icon;

        global Org(String orgName, String description, String orgPurpose, String trialTemplateId, String edition, String icon){
            this.name = orgName;
            this.description = description;
            this.purpose = orgPurpose;
            this.trialTemplateId = trialTemplateId;
            this.edition = edition;
            this.icon = icon;
        }

    }
}