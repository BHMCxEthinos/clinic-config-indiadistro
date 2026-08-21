SELECT
    visit.date_started AS 'Visit Date',
    visit_attribute.value_reference AS 'Case Type',
    patient_identifier.identifier AS 'Identifier',

    TRIM(CONCAT(
        COALESCE(person_name.given_name, ''),
        ' ',
        COALESCE(person_name.middle_name, ''),
        ' ',
        COALESCE(person_name.family_name, '')
    )) AS 'Patient Name',

    TIMESTAMPDIFF(
        YEAR,
        person.birthdate,
        CURDATE()
    ) AS 'Age',

    person.gender AS 'Gender',

    location.name AS 'Location',
    visit_type.name AS 'Visit Type'

FROM visit

LEFT JOIN visit_attribute
    ON visit_attribute.visit_id = visit.visit_id
    AND visit_attribute.attribute_type_id = 3

INNER JOIN visit_type
    ON visit_type.visit_type_id = visit.visit_type_id

INNER JOIN patient
    ON patient.patient_id = visit.patient_id
    AND patient.voided = 0

INNER JOIN person
    ON person.person_id = patient.patient_id
    AND person.voided = 0

INNER JOIN patient_identifier
    ON patient_identifier.patient_id = patient.patient_id
    AND patient_identifier.preferred = 1
    AND patient_identifier.voided = 0

INNER JOIN person_name
    ON person_name.person_id = person.person_id
    AND person_name.preferred = 1
    AND person_name.voided = 0

LEFT JOIN location
    ON location.location_id = visit.location_id

WHERE visit.voided = 0 and visit.visit_type_id =4
        and location.uuid = '#locationUuid#' 
  AND cast(visit.date_started AS DATE) BETWEEN '#startDate#' AND '#endDate#'

ORDER BY visit.date_started ASC;