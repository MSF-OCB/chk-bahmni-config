Bahmni.Registration.customValidator = {
    "Date depistage": {
        method: function (name,value,personAttributeDetails) {
             return value <= new Date();
        },
     errorMessage: "REGISTRATION_HIV_DATE_ERROR_KEY"
    },
    "Date de naissance_Dep(Age c'est plus simple)": {
        method: function (name,value,personAttributeDetails) {
             return value <= new Date();
        },
     errorMessage: "REGISTRATION_HIV_DATE_ERROR_KEY"
    }
};
