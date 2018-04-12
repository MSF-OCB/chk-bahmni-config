Bahmni.ConceptSet.FormConditions.rules = {
  'Syndrome d\'admission' : function (formName, formFieldValues) {
       var synAdmission = formFieldValues['Syndrome d\'admission'];

       if (synAdmission =="Autres") {
           return {
               enable: ["Si autre, preciser"]
           }
       } else {
           return {
               disable: ["Si autre, preciser"]
           }
       }
   },
   'Type' : function (formName, formFieldValues) {
        var typeAdmission = formFieldValues['Type'];
        var conditions = {
          enable: [],
          disable: []
        }
        if (typeAdmission =="Créatine (µmol/l)") {
            {
              conditions.disable.push("Resultat")
              conditions.enable.push("Resultat(Creatine)")
            }
        } else if (typeAdmission && typeAdmission !="Créatine (µmol/l)") /*Concept should have value && value should not be Creatine*/{
          conditions.disable.push("Resultat(Creatine)")
          conditions.enable.push("Resultat")

        }
        else
        {
          conditions.disable.push("Resultat(Creatine)","Resultat")
        }
        return conditions;
    },
    'Mis sous ARV en hospitalization': function (formName, formFieldValues) {
            var conditions = {
                show: [],
                hide: []
            };

            var MisSous = "Date initiation";
            var result = formFieldValues['Mis sous ARV en hospitalization'];
            if (result == "Oui") {
                conditions.show.push( MisSous);
            } else {
                conditions.hide.push( MisSous);
            }
            return conditions;
        },
    'Traitemtent TB commencé?': function (formName, formFieldValues) {
                    var conditions = {
                        show: [],
                        hide: []
                    };

                    var Traitemtent = "Date début";
                    var result = formFieldValues['Traitemtent TB commencé?'];
                    if (result == "Oui") {
                        conditions.show.push( Traitemtent);
                    } else {
                        conditions.hide.push( Traitemtent);
                    }
                    return conditions;
                },
'Type d\'Echo' : function (formName, formFieldValues) {
                    var form_variable = formFieldValues['Type d\'Echo'];
             
                    if (form_variable == "Autre") {
                        return {
                            enable: ["Autre Type d\’Echo"]
                        }
                    } else {
                        return {
                            disable: ["Autre Type d\’Echo"]
                        }
                    }
                }
 };
