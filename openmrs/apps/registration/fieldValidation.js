Bahmni.Registration.customValidator = {
    "age.days": {
        method: function (name, value) {
            return value >= 0;
        },
        errorMessage: "REGISTRATION_AGE_ERROR_KEY"
    },
    "age.years": {
        method: function (name, value) {

            var patientTypeElement = document.getElementById("Patient Type");

            if (!patientTypeElement) {
                return true;
            }

            var selectedOption =
                patientTypeElement.options[patientTypeElement.selectedIndex];

            var patientType = selectedOption
                ? selectedOption.text.trim()
                : "";

            if (patientType === "Self") {

                if (value !== undefined &&
                    value !== null &&
                    value !== "" &&
                    parseInt(value, 10) < 18) {

                    return false;
                }
            }

            return true;
        },

        errorMessage: "Age should not be below 18"
    },
    "Telephone Number": {
        method: function (name, value, personAttributeDetails) {
            return value && value.length> 6;
        },
        errorMessage: "REGISTRATION_TELEPHONE_NUMBER_ERROR_KEY"
    },
    "caste": {
        method: function (name, value, personAttributeDetails) {
            return value.match(/^\w+$/);
        },
        errorMessage: "REGISTRATION_CASTE_TEXT_ERROR_KEY"
    }
};
