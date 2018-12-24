Bahmni.ConceptSet.FormConditions.rules = {
  "TR, Type de visite": function (formName, formFieldValues) {
        var conditions = {
            show: [],
            hide: []
        };
        var TRdateAdmission = "TR, Admission - Informations générales";
        var TRCD4Enfant = "CD4 % (Enfants de moins de 5 ans)(%)"
        var TRCD4test = "CD4(cells/µl)"
        var typeDeVisit = formFieldValues['TR, Type de visite'];
        if (typeDeVisit == "TR, Admission IPD") {
            conditions.show.push(TRdateAdmission);
            conditions.show.push(TRCD4Enfant);
            conditions.show.push(TRCD4test);
        } else {
            conditions.hide.push(TRdateAdmission);
            conditions.hide.push(TRCD4Enfant);
            conditions.hide.push(TRCD4test);
        }
        return conditions;
    },
  "Syndrome d'admission" : function (formName, formFieldValues) {
       var synAdmission = formFieldValues["Syndrome d'admission"];

       if (synAdmission =="Autres(IPDForm)" || synAdmission =="Autres") {
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
    "Vaccination": function(formName, formFieldValues) {
          var questionThatTriggersRule = "Vaccination";
          var selectedResponses = formFieldValues[questionThatTriggersRule];
          var question1AffectedByRule = "Type de vaccination";
          var conditionTrue = selectedResponses.indexOf('Autres') >= 0;
          var ruleActions = {enable: [], disable: []};
          if(conditionTrue) {
              ruleActions.enable.push(question1AffectedByRule);
          } else {
              ruleActions.disable.push(question1AffectedByRule);
          }
          return ruleActions;
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
    },
    "CO, PHQ" : function (formName, formFieldValues) {
       var phqType = formFieldValues["CO, PHQ"];

       if (phqType == "CO, Première" || phqType == "CO, Reévaluation") {
           return {
               show: ["CO, Score"]
           }
       } else {
           return {
               hide: ["CO, Score"]
           }
       }
   },
   "Status prophylaxie" : function (formName, formFieldValues) {
       var statusProphylaxieType = formFieldValues["Status prophylaxie"];

       if (statusProphylaxieType == "prophylaxie arret") {
           return {
               show: ["motif arret prophylaxie"]
           }
       } else {
           return {
               hide: ["motif arret prophylaxie"]
           }
       }
   },
   "CO, Patient initié aux ARV ou changement de molécule?": function (formName, formFieldValues) {
        var conditions = {
            show: [],
            hide: []
        };
        var regimeLine = "RA, ARV Line";
        var regimeStartDate = "Regimen Start date"
        var regimeReason = "Regimen Start reason"
        var regimeQuestion = formFieldValues['CO, Patient initié aux ARV ou changement de molécule?'];
        if (regimeQuestion == "Oui") {
            conditions.show.push(regimeLine);
            conditions.show.push(regimeStartDate);
            conditions.show.push(regimeReason);
        } else {
            conditions.hide.push(regimeLine);
            conditions.hide.push(regimeStartDate);
            conditions.hide.push(regimeReason);
        }
        return conditions;
    },
    "Mode de sortie(Suivi)": function (formName, formFieldValues) {
    var transfertType = formFieldValues["Mode de sortie(Suivi)"];
    var modeOfTransfert = formFieldValues["Mode d'entrée (IPD)"];
    if (transfertType == "Transfert(Suivi)") {
        if (modeOfTransfert == "Hospi de jour(Suivi)") {
            return {
                show: ["Transfert", "Prochain RDV"]
            }
        } else {
            return {
                show: ["Transfert"],
                hide: ["Prochain RDV"]
            }
        }
    } else if (transfertType == "Domicile(Suivi)" || transfertType == "Reféré(Suivi)") {
        return {
            show: ["Prochain RDV"],
            hide: ["Transfert"]

        }
      } else {
          if (modeOfTransfert == "Hospi de jour(Suivi)") {
              return {
                  show: ["Prochain RDV"],
                  hide: ["Transfert"]
              }
          } else {
              return {
                  hide: ["Transfert", "Prochain RDV"]
              }
          }
      }
    },
    "Mode d'entrée (IPD)": function (formName, formFieldValues) {
        var modeOfTransfert = formFieldValues["Mode d'entrée (IPD)"];
        var transfertType = formFieldValues["Mode de sortie(Suivi)"];

        if (modeOfTransfert == "Hospi de jour(Suivi)") {
            return {
                show: ["Prochain RDV"]
            }
        } else {
            if (transfertType == "Domicile(Suivi)" || transfertType == "Reféré(Suivi)") {
                return {
                    show: ["Prochain RDV"]
                }
            } else {
                return {

                    hide: ["Prochain RDV"]
                }
            }
        }
     },
     'IPD Admission, Histoire ARV': function (formName, formFieldValues) {
             var conditions = {
                 show: [],
                 hide: []
             };

             var interrompu = "IPD Admission, Si interrompu";
             var resultInterrompu = formFieldValues['IPD Admission, Histoire ARV'];
             if (resultInterrompu == "ARV intérrompu" || resultInterrompu == "IPD Admission History ARV, ARV intérrompu" ) {
                 conditions.show.push(interrompu);
             } else {
                 conditions.hide.push(interrompu);
             }
             return conditions;
         },
     "IPD Admission, TB en cours de traitement à l'admission" : function (formName, formFieldValues) {
       var modeOfTransfert = formFieldValues["IPD Admission, TB en cours de traitement à l'admission"];

       if (modeOfTransfert == "Oui" ) {
           return {
               show: ["IPD Admission, Elements de diagnostic TB","IPD Admission, Date début anti-TB","IPD Admission, Adhérence aux anti-TB"]
           }
       } else {
           return {
               hide: ["IPD Admission, Elements de diagnostic TB","IPD Admission, Date début anti-TB","IPD Admission, Adhérence aux anti-TB"]
           }
       }
     },
     "CAI, Patient initié aux ARV ou changement de molécule?" : function (formName, formFieldValues) {
       var modeOfTransfert = formFieldValues["CAI, Patient initié aux ARV ou changement de molécule?"];

       if (modeOfTransfert == "Oui" ) {
           return {
               show: ["CAI, ARV Line","CAI, Date début Regime ARV","CAI, Motif début régime"]
           }
       } else {
           return {
               hide: ["CAI, ARV Line","CAI, Date début Regime ARV","CAI, Motif début régime"]
           }
         }
      },
      "CSI, Status prophylaxie" : function (formName, formFieldValues) {
        var statusProphylaxieType = formFieldValues["CSI, Status prophylaxie"];

        if (statusProphylaxieType == "prophylaxie arret") {
            return {
                show: ["CSI, Motif d\'arrêt prophylaxie"]
            }
        } else {
            return {
                hide: ["CSI, Motif d\'arrêt prophylaxie"]
            }
        }
    },
    "CSI, Patient initié aux ARV ou changement de molécule?" : function (formName, formFieldValues) {
        var modeOfTransfert = formFieldValues["CSI, Patient initié aux ARV ou changement de molécule?"];

        if (modeOfTransfert == "Oui" ) {
            return {
                show: ["CSI, ARV Line","CSI, Date début Regime ARV","CSI, Motif début régime"]
            }
        } else {
            return {
                hide: ["CSI, ARV Line","CSI, Date début Regime ARV","CSI, Motif début régime"]
            }
        }
     },
     "CSI, Mode de sortie" : function (formName, formFieldValues) {
    var transfertType = formFieldValues["CSI, Mode de sortie"];
      if (transfertType == "Transfert(Suivi)") {
              return {
                  show: ["CSI, Transfert"],
                  hide: ["CSI, Prochain RDV"]
              }
          }
      else if (transfertType == "Domicile(Suivi)" || transfertType == "Reféré(Suivi)") {
          return {
              show: ["CSI, Prochain RDV"],
              hide: ["CSI, Transfert"]
          }
        }
      else {
          return {
            hide: ["CSI, Transfert", "CSI, Prochain RDV"]
                }
            }
     }

 };
