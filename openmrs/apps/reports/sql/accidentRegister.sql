SELECT DISTINCT
    pi.identifier AS 'Identifier',

    TRIM(CONCAT(
        COALESCE(pn.given_name, ''),
        ' ',
        COALESCE(pn.middle_name, ''),
        ' ',
        COALESCE(pn.family_name, '')
    )) AS 'Patient Name',

    TIMESTAMPDIFF(
        YEAR,
        p.birthdate,
        CURDATE()
    ) AS 'Age',

    p.gender AS 'Gender',

    v.date_started AS 'Visit Start Date',

    v.date_stopped AS 'Visit Stop Date',

    l.name AS 'Location',

    vt.name AS 'Visit Type',

    emp.value AS 'Employee ID',

    cv.concept_full_name AS 'Patient Type',

    va.value_reference AS 'Case Type',
    diagnoses_cv.concept_full_name AS 'Diagnisis'

FROM visit v

INNER JOIN patient pat
    ON pat.patient_id = v.patient_id
    AND pat.voided = 0

INNER JOIN person p
    ON p.person_id = pat.patient_id
    AND p.voided = 0

INNER JOIN patient_identifier pi
    ON pi.patient_id = pat.patient_id
    AND pi.preferred = 1
    AND pi.voided = 0

INNER JOIN person_name pn
    ON pn.person_id = p.person_id
    AND pn.preferred = 1
    AND pn.voided = 0

LEFT JOIN location l
    ON l.location_id = v.location_id

LEFT JOIN visit_type vt
    ON vt.visit_type_id = v.visit_type_id

LEFT JOIN person_attribute emp
    ON emp.person_id = pat.patient_id
    AND emp.person_attribute_type_id = 16
    AND emp.voided = 0

LEFT JOIN person_attribute pt
    ON pt.person_id = pat.patient_id
    AND pt.person_attribute_type_id = 18
    AND pt.voided = 0

LEFT JOIN concept_view cv
    ON cv.concept_id = pt.value

LEFT JOIN visit_attribute va
    ON va.visit_id = v.visit_id
    AND va.attribute_type_id = 3
LEFT JOIN encounter ON v.visit_id = encounter.visit_id AND encounter.encounter_type = 1
LEFT JOIN obs on encounter.encounter_id = obs.encounter_id AND obs.concept_id = 22
LEFT JOIN concept_view diagnoses_cv ON obs.value_coded = diagnoses_cv.concept_id
WHERE
    v.voided = 0
    AND pt.value = 520
    AND va.value_reference = 'Accidental'
    and l.uuid = '#locationUuid#' 
  AND cast(v.date_started AS DATE) BETWEEN '#startDate#' AND '#endDate#'

ORDER BY v.date_started DESC;

