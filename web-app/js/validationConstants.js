/**
 * Code used for apply email validation to field or not
 * @type {boolean}
 */
var isApplyEmailValidation = true;

/**
 * Code used for all field validation constants
 */
var validationConstants = {

    firstName : {
        minLength   : 2,
        maxLength   : 30
    },

    lastName : {
        minLength   : 2,
        maxLength   : 30
    },

    userName : {
        minLength   : 5,
        maxLength   : 30
    },

    email : {
        minLength   : 5,
        maxLength   : 30,
        regex       : "^[a-zA-Z]+[a-zA-Z0-9._]+@[a-zA-Z]+\.[a-zA-Z.]{2,5}$"
    },

    mobileNumber : {
        minLength   : 10,
        maxLength   : 10
    },

    jobName : {
        minLength   : 5,
        maxLength   : 100
    },

    content : {
        minLength   : 10,
        maxLength   : 20000
    },

    password : {
        minLength   : 6,
        maxLength   : 15
    }
};

$.validator.addMethod("emailValidate", function (value, element) {

    if (isApplyEmailValidation) {
        var regex = new RegExp(validationConstants.email.regex);

        if (!regex.test(value)) {
            return false;
        } else {
            return true;
        }
    } else {
        return true;
    }

}, "Invalid email address");