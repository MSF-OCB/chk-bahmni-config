

Bahmni.Registration.AttributesConditions.rules = {
    'Dépendant 1': function(patient) {
        var returnValues = {
            show: [],
            hide: []
        };
        if (patient["Dépendant 1"]) {
            returnValues.show.push("patientNewDependentSectionFirst");
            
            
        } else {
            returnValues.hide.push("patientNewDependentSectionFirst");
        }
        return returnValues

    },
    'Dépendant 2': function(patient) {
        var returnValues = {
            show: [],
            hide: []
        };
        if (patient["Dépendant 2"]) {
            returnValues.show.push("patientNewDependentSectionSecond");
            
            
        } else {
            returnValues.hide.push("patientNewDependentSectionSecond");
        }
        return returnValues

    },
    'Dépendant 3': function(patient) {
        var returnValues = {
            show: [],
            hide: []
        };
        if (patient["Dépendant 3"]) {
            returnValues.show.push("patientNewDependentSectionThird");
            
            
        } else {
            returnValues.hide.push("patientNewDependentSectionThird");
        }
        return returnValues

    },
    'Dépendant 4': function(patient) {
        var returnValues = {
            show: [],
            hide: []
        };
        if (patient["Dépendant 4"]) {
            returnValues.show.push("patientNewDependentSectionFourth");
            
            
        } else {
            returnValues.hide.push("patientNewDependentSectionFourth");
        }
        return returnValues

    },
    'Dépendant 5': function(patient) {
        var returnValues = {
            show: [],
            hide: []
        };
        if (patient["Dépendant 5"]) {
            returnValues.show.push("patientNewDependentSectionFifth");
            
            
        } else {
            returnValues.hide.push("patientNewDependentSectionFifth");
        }
        return returnValues

    },
    'Dépendant 6': function(patient) {
        var returnValues = {
            show: [],
            hide: []
        };
        if (patient["Dépendant 6"]) {
            returnValues.show.push("patientNewDependentSectionSixth");
            
            
        } else {
            returnValues.hide.push("patientNewDependentSectionSixth");
        }
        return returnValues

    }
    
    
};


