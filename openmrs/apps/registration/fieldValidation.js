Bahmni.Registration.customValidator = {
    "Date depistage": {
        method: function (name,value,personAttributeDetails) {
             return value <= new Date();
        },
     errorMessage: "REGISTRATION_HIV_DATE_ERROR_KEY"
    },
    "DateDeNaissanceDépendant1": {
        method: function (name,value,personAttributeDetails) {
             return value <= new Date();
        },
     errorMessage: "REGISTRATION_HIV_DATE_ERROR_KEY"
     },
     "DateDeNaissanceDépendant2": {
        method: function (name,value,personAttributeDetails) {
             return value <= new Date();
        },
     errorMessage: "REGISTRATION_HIV_DATE_ERROR_KEY"
     },
     "DateDeNaissanceDépendant3": {
        method: function (name,value,personAttributeDetails) {
             return value <= new Date();
        },
     errorMessage: "REGISTRATION_HIV_DATE_ERROR_KEY"
     },
     "DateDeNaissanceDépendant4": {
        method: function (name,value,personAttributeDetails) {
             return value <= new Date();
        },
     errorMessage: "REGISTRATION_HIV_DATE_ERROR_KEY"
     },
     "DateDeNaissanceDépendant5": {
        method: function (name,value,personAttributeDetails) {
             return value <= new Date();
        },
     errorMessage: "REGISTRATION_HIV_DATE_ERROR_KEY"
     },
     "DateDeNaissanceDépendant6": {
        method: function (name,value,personAttributeDetails) {
             return value <= new Date();
        },
     errorMessage: "REGISTRATION_HIV_DATE_ERROR_KEY"
     },
   "Date de conversion": {
        method:function (name,value,personAttributeDetails) {
              return value <= new Date();
        },
      errorMessage: "REGISTRATION_DATE_OF_CONVERSION_CP_ERROR_KEY"
    }
};
