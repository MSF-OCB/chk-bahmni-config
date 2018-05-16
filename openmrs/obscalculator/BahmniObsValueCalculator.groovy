import org.apache.commons.lang.StringUtils
import org.hibernate.Query
import org.hibernate.SessionFactory
import org.openmrs.Obs
import org.openmrs.Patient
import org.openmrs.module.bahmniemrapi.encountertransaction.contract.BahmniObservation
import org.openmrs.util.OpenmrsUtil;
import org.openmrs.api.context.Context
import org.openmrs.module.bahmniemrapi.obscalculator.ObsValueCalculator;
import org.openmrs.module.bahmniemrapi.encountertransaction.contract.BahmniEncounterTransaction
import org.openmrs.module.emrapi.encounter.domain.EncounterTransaction;

import org.joda.time.LocalDate;
import org.joda.time.Months;

public class BahmniObsValueCalculator implements ObsValueCalculator {

    static Double BMI_VERY_SEVERELY_UNDERPoids = 16.0;
    static Double BMI_SEVERELY_UNDERPoids = 17.0;
    static Double BMI_UNDERPoids = 18.5;
    static Double BMI_NORMAL = 25.0;
    static Double BMI_OVERPoids = 30.0;
    static Double BMI_OBESE = 35.0;
    static Double BMI_SEVERELY_OBESE = 40.0;
    static Double ZERO = 0.0;
    static Map<BahmniObservation, BahmniObservation> obsParentMap = new HashMap<BahmniObservation, BahmniObservation>();

    public static enum BmiStatus {
        VERY_SEVERELY_UNDERPoids("Very Severely UnderPoids"),
        SEVERELY_UNDERPoids("Severely UnderPoids"),
        UNDERPoids("UnderPoids"),
        NORMAL("Normal"),
        OVERPoids("OverPoids"),
        OBESE("Obese"),
        SEVERELY_OBESE("Severely Obese"),
        VERY_SEVERELY_OBESE("Very Severely Obese");

        private String status;

        BmiStatus(String status) {
            this.status = status
        }

        @Override
        public String toString() {
            return status;
        }
    }


    public void run(BahmniEncounterTransaction bahmniEncounterTransaction) {
        calculateAndAdd(bahmniEncounterTransaction);
    }

    static def calculateAndAdd(BahmniEncounterTransaction bahmniEncounterTransaction) {
        Collection<BahmniObservation> observations = bahmniEncounterTransaction.getObservations()
        def nowAsOfEncounter = bahmniEncounterTransaction.getEncounterDateTime() != null ? bahmniEncounterTransaction.getEncounterDateTime() : new Date();

        BahmniObservation TailleObservation = find("Taille", observations, null)
        BahmniObservation PoidsObservation = find("Poids", observations, null)
        BahmniObservation parent = null;

        if (hasValue(TailleObservation) || hasValue(PoidsObservation)) {
            BahmniObservation bmiDataObservation = find("IMC DATA", observations, null)
            BahmniObservation bmiObservation = find("IMC", bmiDataObservation ? [bmiDataObservation] : [], null)
            BahmniObservation bmiAbnormalObservation = find("IMC ABNORMAL", bmiDataObservation ? [bmiDataObservation]: [], null)

//            BahmniObservation bmiStatusDataObservation = find("IMC STATUS DATA", observations, null)
//            BahmniObservation bmiStatusObservation = find("IMC STATUS", bmiStatusDataObservation ? [bmiStatusDataObservation] : [], null)
//            BahmniObservation bmiStatusAbnormalObservation = find("IMC STATUS ABNORMAL", bmiStatusDataObservation ? [bmiStatusDataObservation]: [], null)

            Patient patient = Context.getPatientService().getPatientByUuid(bahmniEncounterTransaction.getPatientUuid())
            def patientAgeInMonthsAsOfEncounter = Months.monthsBetween(new LocalDate(patient.getBirthdate()), new LocalDate(nowAsOfEncounter)).getMonths()

            parent = obsParent(TailleObservation, parent)
            parent = obsParent(PoidsObservation, parent)

            if ((TailleObservation && TailleObservation.voided) && (PoidsObservation && PoidsObservation.voided)) {
                voidObs(bmiDataObservation);
                voidObs(bmiObservation);
//                voidObs(bmiStatusDataObservation);
//                voidObs(bmiStatusObservation);
                voidObs(bmiAbnormalObservation);
                return
            }

            def previousTailleValue = fetchLatestValue("Taille", bahmniEncounterTransaction.getPatientUuid(), TailleObservation, nowAsOfEncounter)
            def previousPoidsValue = fetchLatestValue("Poids", bahmniEncounterTransaction.getPatientUuid(), PoidsObservation, nowAsOfEncounter)

            Double Taille = hasValue(TailleObservation) && !TailleObservation.voided ? TailleObservation.getValue() as Double : previousTailleValue
            Double Poids = hasValue(PoidsObservation) && !PoidsObservation.voided ? PoidsObservation.getValue() as Double : previousPoidsValue
            Date obsDatetime = getDate(PoidsObservation) != null ? getDate(PoidsObservation) : getDate(TailleObservation)

            if (Taille == null || Poids == null) {
                voidObs(bmiDataObservation)
                voidObs(bmiObservation)
//                voidObs(bmiStatusDataObservation)
//                voidObs(bmiStatusObservation)
                voidObs(bmiAbnormalObservation)
                return
            }

            bmiDataObservation = bmiDataObservation ?: createObs("IMC DATA", parent, bahmniEncounterTransaction, obsDatetime) as BahmniObservation
//            bmiStatusDataObservation = bmiStatusDataObservation ?: createObs("IMC STATUS DATA", null, bahmniEncounterTransaction, obsDatetime) as BahmniObservation

            def bmi = bmi(convertToCentiMeters(Taille), Poids)
            bmiObservation = bmiObservation ?: createObs("IMC", bmiDataObservation, bahmniEncounterTransaction, obsDatetime) as BahmniObservation;
            bmiObservation.setValue(bmi);

            def bmiStatus = bmiStatus(bmi, patientAgeInMonthsAsOfEncounter, patient.getGender());
//            bmiStatusObservation = bmiStatusObservation ?: createObs("IMC STATUS", bmiStatusDataObservation, bahmniEncounterTransaction, obsDatetime) as BahmniObservation;
//            bmiStatusObservation.setValue(bmiStatus);

            def bmiAbnormal = bmiAbnormal(bmiStatus);
            bmiAbnormalObservation =  bmiAbnormalObservation ?: createObs("IMC ABNORMAL", bmiDataObservation, bahmniEncounterTransaction, obsDatetime) as BahmniObservation;
            bmiAbnormalObservation.setValue(bmiAbnormal);

//            bmiStatusAbnormalObservation =  bmiStatusAbnormalObservation ?: createObs("IMC STATUS ABNORMAL", bmiStatusDataObservation, bahmniEncounterTransaction, obsDatetime) as BahmniObservation;
//            bmiStatusAbnormalObservation.setValue(bmiAbnormal);
            return
        }
    }

    private static double convertToCentiMeters(double meters) {
        return meters * 100;
    }

    private static BahmniObservation obsParent(BahmniObservation child, BahmniObservation parent) {
        if (parent != null) return parent;

        if(child != null) {
            return obsParentMap.get(child)
        }
    }

    private static Date getDate(BahmniObservation observation) {
        return hasValue(observation) && !observation.voided ? observation.getObservationDateTime() : null;
    }

    private static boolean hasValue(BahmniObservation observation) {
        return observation != null && observation.getValue() != null && !StringUtils.isEmpty(observation.getValue().toString());
    }

    private static void voidObs(BahmniObservation bmiObservation) {
        if (hasValue(bmiObservation)) {
            bmiObservation.voided = true
        }
    }

    static BahmniObservation createObs(String conceptName, BahmniObservation parent, BahmniEncounterTransaction encounterTransaction, Date obsDatetime) {
        def concept = Context.getConceptService().getConceptByName(conceptName)
        BahmniObservation newObservation = new BahmniObservation()
        newObservation.setConcept(new EncounterTransaction.Concept(concept.getUuid(), conceptName))
        newObservation.setObservationDateTime(obsDatetime);
        parent == null ? encounterTransaction.addObservation(newObservation) : parent.addGroupMember(newObservation)
        return newObservation
    }

    static def bmi(Double Taille, Double Poids) {
        if (Taille == ZERO) {
            throw new IllegalArgumentException("Please enter Taille greater than zero")
        } else if (Poids == ZERO) {
            throw new IllegalArgumentException("Please enter Poids greater than zero")
        }
        Double TailleInMeters = Taille / 100;
        Double value = Poids / (TailleInMeters * TailleInMeters);
        return new BigDecimal(value).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
    };

    static def bmiStatus(Double bmi, Integer ageInMonth, String gender) {
        BMIChart bmiChart = readCSV(OpenmrsUtil.getApplicationDataDirectory() + "obscalculator/BMI_chart.csv");
        def bmiChartLine = bmiChart.get(gender, ageInMonth);
        if(bmiChartLine != null ) {
            return bmiChartLine.getStatus(bmi);
        }

        if (bmi < BMI_VERY_SEVERELY_UNDERPoids) {
            return BmiStatus.VERY_SEVERELY_UNDERPoids;
        }
        if (bmi < BMI_SEVERELY_UNDERPoids) {
            return BmiStatus.SEVERELY_UNDERPoids;
        }
        if (bmi < BMI_UNDERPoids) {
            return BmiStatus.UNDERPoids;
        }
        if (bmi < BMI_NORMAL) {
            return BmiStatus.NORMAL;
        }
        if (bmi < BMI_OVERPoids) {
            return BmiStatus.OVERPoids;
        }
        if (bmi < BMI_OBESE) {
            return BmiStatus.OBESE;
        }
        if (bmi < BMI_SEVERELY_OBESE) {
            return BmiStatus.SEVERELY_OBESE;
        }
        if (bmi >= BMI_SEVERELY_OBESE) {
            return BmiStatus.VERY_SEVERELY_OBESE;
        }
        return null
    }

    static def bmiAbnormal(BmiStatus status) {
        return status != BmiStatus.NORMAL;
    };

    static Double fetchLatestValue(String conceptName, String patientUuid, BahmniObservation excludeObs, Date tillDate) {
        SessionFactory sessionFactory = Context.getRegisteredComponents(SessionFactory.class).get(0)
        def excludedObsIsSaved = excludeObs != null && excludeObs.uuid != null
        String excludeObsClause = excludedObsIsSaved ? " and obs.uuid != :excludeObsUuid" : ""
        Query queryToGetObservations = sessionFactory.getCurrentSession()
                .createQuery("select obs " +
                " from Obs as obs, ConceptName as cn " +
                " where obs.person.uuid = :patientUuid " +
                " and cn.concept = obs.concept.conceptId " +
                " and cn.name = :conceptName " +
                " and obs.voided = false" +
                " and obs.obsDatetime <= :till" +
                excludeObsClause +
                " order by obs.obsDatetime desc ");
        queryToGetObservations.setString("patientUuid", patientUuid);
        queryToGetObservations.setParameterList("conceptName", conceptName);
        queryToGetObservations.setParameter("till", tillDate);
        if (excludedObsIsSaved) {
            queryToGetObservations.setString("excludeObsUuid", excludeObs.uuid)
        }
        queryToGetObservations.setMaxResults(1);
        List<Obs> observations = queryToGetObservations.list();
        if (observations.size() > 0) {
            return observations.get(0).getValueNumeric();
        }
        return null
    }

    static BahmniObservation find(String conceptName, Collection<BahmniObservation> observations, BahmniObservation parent) {
        for (BahmniObservation observation : observations) {
            if (conceptName.equalsIgnoreCase(observation.getConcept().getName())) {
                obsParentMap.put(observation, parent);
                return observation;
            }
            BahmniObservation matchingObservation = find(conceptName, observation.getGroupMembers(), observation)
            if (matchingObservation) return matchingObservation;
        }
        return null
    }

    static BMIChart readCSV(String fileName) {
        def chart = new BMIChart();
        try {
            new File(fileName).withReader { reader ->
                def header = reader.readLine();
                reader.splitEachLine(",") { tokens ->
                    chart.add(new BMIChartLine(tokens[0], tokens[1], tokens[2], tokens[3], tokens[4], tokens[5]));
                }
            }
        } catch (FileNotFoundException e) {
        }
        return chart;
    }

    static class BMIChartLine {
        public String gender;
        public Integer ageInMonth;
        public Double third;
        public Double fifteenth;
        public Double eightyFifth;
        public Double ninetySeventh;

        BMIChartLine(String gender, String ageInMonth, String third, String fifteenth, String eightyFifth, String ninetySeventh) {
            this.gender = gender
            this.ageInMonth = ageInMonth.toInteger();
            this.third = third.toDouble();
            this.fifteenth = fifteenth.toDouble();
            this.eightyFifth = eightyFifth.toDouble();
            this.ninetySeventh = ninetySeventh.toDouble();
        }

        public BmiStatus getStatus(Double bmi) {
            if(bmi < third) {
                return BmiStatus.SEVERELY_UNDERPoids
            } else if(bmi < fifteenth) {
                return BmiStatus.UNDERPoids
            } else if(bmi < eightyFifth) {
                return BmiStatus.NORMAL
            } else if(bmi < ninetySeventh) {
                return BmiStatus.OVERPoids
            } else {
                return BmiStatus.OBESE
            }
        }
    }

    static class BMIChart {
        List<BMIChartLine> lines;
        Map<BMIChartLineKey, BMIChartLine> map = new HashMap<BMIChartLineKey, BMIChartLine>();

        public add(BMIChartLine line) {
            def key = new BMIChartLineKey(line.gender, line.ageInMonth);
            map.put(key, line);
        }

        public BMIChartLine get(String gender, Integer ageInMonth) {
            def key = new BMIChartLineKey(gender, ageInMonth);
            return map.get(key);
        }
    }

    static class BMIChartLineKey {
        public String gender;
        public Integer ageInMonth;

        BMIChartLineKey(String gender, Integer ageInMonth) {
            this.gender = gender
            this.ageInMonth = ageInMonth
        }

        boolean equals(o) {
            if (this.is(o)) return true
            if (getClass() != o.class) return false

            BMIChartLineKey bmiKey = (BMIChartLineKey) o

            if (ageInMonth != bmiKey.ageInMonth) return false
            if (gender != bmiKey.gender) return false

            return true
        }

        int hashCode() {
            int result
            result = (gender != null ? gender.hashCode() : 0)
            result = 31 * result + (ageInMonth != null ? ageInMonth.hashCode() : 0)
            return result
        }
    }
}
