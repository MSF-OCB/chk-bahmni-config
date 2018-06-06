Bahmni.ConceptSet.FormConditions.rules = {
  "Syndrome d'admission" : function (formName, formFieldValues) {
       var synAdmission = formFieldValues["Syndrome d'admission"];

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
    'Type d\'Echo': function (formName, formFieldValues) {
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
                    },
    'Vaccination': function (formName, formFieldValues) {
        var conditions = {enable: [], disable: []};
        var Vaccination = "Type de vaccination";
        var result = formFieldValues['Vaccination'];
        if (result == "Autres") {
            conditions.enable.push(Vaccination);
        } else {
            conditions.disable.push(Vaccination);
        }
        return conditions;
    },
    "Mère sous ARV pendant la grossesse":function (formName, formFieldValues) {
        var conditions = {enable: [], disable: []};
        var Mois = "Si oui, Nombre de mois";
        var result = formFieldValues['Mère sous ARV pendant la grossesse'];
        if (result == "Oui") {
            conditions.enable.push(Mois);
        } else {
            conditions.disable.push(Mois);
        }
        return conditions;
    },
    'Tests' : function (formName, formFieldValues) {
        var typeAdmission = formFieldValues['Tests'];
        var conditions = {
            enable: [],
            disable: []
        }
        if (typeAdmission =="Hémoglobine (Hemocue)(g/dl)"
            || typeAdmission =="Glycémie(mg/dl)"
            || typeAdmission =="CD4(cells/µl)"
            || typeAdmission =="CD4 % (Enfants de moins de 5 ans)(%)") {
            {
                conditions.disable.push("Résultat(Option)")
                conditions.enable.push("Résultat(Numérique)")
            }
        } else if (typeAdmission =="TB - LAM" || typeAdmission =="TR, TDR - Malaria"){
            conditions.enable.push("Résultat(Option)")
            conditions.disable.push("Résultat(Numérique)")
        } else {
            conditions.disable.push("Résultat(Option)")
            conditions.disable.push("Résultat(Numérique)")
        }

        return conditions;
    },
    'Prématuré': function (formName, formFieldValues) {
        var conditions = {
            show: [],
            hide: []
        };

        var SiPre = "Si prémature, nombre de semaines";
        var result = formFieldValues['Prématuré'];
        if (result == "Oui") {
            conditions.show.push( SiPre);
        } else {
            conditions.hide.push( SiPre);
        }
        return conditions;
    },
    'Type de TB': function (formName, formFieldValues) {
        var conditions = {
            show: [],
            hide: []
        };
        var Typede = "Site TB";
        var conditionConcept = formFieldValues["Type de TB"];
        if (conditionConcept == "Extrapulmonaire"){
            conditions.show.push(Typede);
        } else {
            conditions.hide.push(Typede);
        }
        return conditions;
    },
    "Prophylaxie à l'accouchement": function (formName, formFieldValues) {
        var conditions = {
            show: [],
            hide: []
        };

        var Paccou = "Info Prophylaxie à l'accouchement";
        var result = formFieldValues["Prophylaxie à l'accouchement"];
        if (result == "Oui") {
            conditions.show.push(Paccou);
        } else {
            conditions.hide.push(Paccou);
        }
        return conditions;
    },
    "Prophylaxie après la naissance": function (formName, formFieldValues) {
        var conditions = {
            show: [],
            hide: []
        };

        var Pnai = "Info Prophylaxie après la naissance";
        var result = formFieldValues['Prophylaxie après la naissance'];
        if (result == "Oui") {
            conditions.show.push(Pnai);
        } else {
            conditions.hide.push(Pnai);
        }
        return conditions;
    },
    "Traitement TB Antérieur": function (formName, formFieldValues) {
        var conditions = {
            show: [],
            hide: []
        };

        var HisTB = "Historique TB antérieur(si traité précédemment)";
        var result = formFieldValues['Traitement TB Antérieur'];
        if (result == "Traité précédemment") {
            conditions.show.push(HisTB);
        } else {
            conditions.hide.push(HisTB);
        }
        return conditions;
    }

 };
