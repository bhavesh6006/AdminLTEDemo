
var countdowns = 0;
var fileUploadObject = {
    fd              : new FormData(),
    uploadedFiles   : [],
    fileName        : "",
    dataUploadObj   : ""

};

var helperFunction = {

    /**
     * Function used for trim all the fields in the form
     *
     * @param form : form selector
     *
     * @returns : Map of trimmed form elements
     */
    trimFormData: function(form) {

        var formData = $(form).serializeArray();

        // Create object from name and value using underscore.js
        formData = _.object(_.pluck(formData, 'name'), _.pluck(formData, 'value'));

        // Create map from object with trimmed data values
        formData = _.mapObject(formData, function(val, key) {
            return val.trim();
        });

        return formData
    },

    /**
     * Function used to show notification for any action event
     *
     * @param status    : Boolean value true / false
     * @param message   : Message to be shown
     */
    showNotification: function(status, message){

        var type = "";

        if (status) {
            type = "success";
        } else {
            type = "error";
        }

        var opts = {
            title: "",
            text: "",
            delay: 2000
        };

        switch (type) {
            case 'error':
                opts.title  = "Error!";
                opts.text   = message;
                opts.type   = "error";
                break;
            case 'info':
                opts.title  = "Information";
                opts.text   = message;
                opts.type   = "info";
                break;
            case 'success':
                opts.title  = "Success!";
                opts.text   =  message;
                opts.type   = 'info';
                opts.icon   = 'brighttheme-icon-success';
                break;
        }

        new PNotify(opts);

        var element = $('.ui-pnotify');
        element.trigger('mouseover');
        element.trigger('mouseout');
    },

    /**
     *  function for uploading the files
     * @param fileUploadId      : Holds the id for file upload
     * @param acceptFileType    : Holds the file type
     */
    uploadFilesHandler: function (fileUploadId, acceptFileType) {

        fileUploadObject.dataUploadObj = (fileUploadId).uploadFile({
            multiple        : false,
            dragDrop        : true,
            autoSubmit      : false,
            acceptFiles     : acceptFileType,
            maxFileSize     : 5242880,
            maxFileCount    : 1,
            showProgress    : true,
            showFileCounter : false,
            showPreview     : true,
            previewHeight   : "100px",
            previewWidth    : "100px",
            onSelect: function (files) {
                var acceptedFileTypeList = acceptFileType.split(",");

                _.each(files, function(file){

                    var extension = file.name.replace(/^.*\./, '').toLowerCase();

                    var isValidExtension = _.contains(acceptedFileTypeList, "." + extension);

                    if (isValidExtension) {
                        if (file.size <= 5242880) {
                            if (fileUploadObject.uploadedFiles.length == 0) {
                                fileUploadObject.uploadedFiles.push(file);
                            }
                        } else {
                            $(".ajax-upload-dragdrop").next().html("<b>" + file.name + "</b> is not allowed. File size should be less than 5.2 MB").show();
                        }
                    } else {
                        $(".ajax-upload-dragdrop").next().html("<b>" + file.name + "</b> is not allowed. Allowed extensions: " + acceptFileType.split(",")).show();
                    }
                });

                if(fileUploadObject.uploadedFiles.length > 0) {
                    _.each(fileUploadObject.uploadedFiles, function (file) {

                        var convertedBase64ImageData;
                        common.helperFunction.baseSixtyFourConverter(file,function(Base64Data){
                            convertedBase64ImageData = Base64Data;
                        });
                    });

                    return true; //to allow file submission.
                } else{
                    return false;
                }
            },
            onCancel: function (files, pd) {
                _.each(files, function (file) {
                    fileUploadObject.uploadedFiles = _.without(fileUploadObject.uploadedFiles, _.findWhere(fileUploadObject.uploadedFiles, {name: file}));
                })
            }
        });
    },

    /**
     * Function used for convert image to base 64 data
     * @param url       : image data
     * @param callback  : return converted image to function call
     *
     */
    baseSixtyFourConverter : function(url, callback) {

        if (url) {

            var FR= new FileReader();

            FR.addEventListener("load", function(e) {
                callback(e.target.result);
            });

            FR.readAsDataURL( url );
        }
    },

    /**
     * Function used to upload file to server
     *
     * @param url                           : server url to upload file
     * @param fileName                      : image file name
     * @param baseSixtyFourEncodedFileData  : converted image to base 64
     * @param userRole                      : holds user's role
     *
     */
    uploadFileToServer : function(formSelector, url, fileName, baseSixtyFourEncodedFileData, userRole, pageName) {

        formSelector.ajaxSubmit({
            type        : 'POST',
            url         : url,
            cache       : false,
            beforeSubmit: function(formData, jqForm, options) {
                formData.push({name : 'fileContents', value : baseSixtyFourEncodedFileData});
                formData.push({name : 'fileName', value : fileName});

                if (pageName != "Profile") {
                    formData.push({name : 'role', value : userRole});
                }
            },
            success     : function (response) {

                var title = (pageName == "Profile") ? "Image is uploaded successfully." : "File is uploaded successfully.";

                formSelector.find('#SYNCHRONIZER_TOKEN').val(response.SYNCHRONIZER_TOKEN);

                swal({
                    title: title,
                    text: response.message,
                    type: "success",
                    showCancelButton: false,
                    confirmButtonColor: "#DD6B55",
                    confirmButtonText: "Ok",
                    closeOnConfirm: true
                },
                function(){
                    window.location.reload();
                });
            },
            error       : function (error) {

                //console.log("Error: ", error);
            }
        });
    },

    /**
     * Function used for remove image from server
     * @param url   : server url
     *
     */
    removeFileFromServer : function(url) {

        $.ajax({
            type        : 'POST',
            url         : url,
            cache       : false,
            success     : function (response) {

                common.helperFunction.showNotification(response.status, response.message);
                window.location.reload();
            },
            error       : function (error) {

                //console.log("Error: ", error);
            }
        });
    },

    /**
     * function for clearing variables used for file upload
     */
    clearFileUploadedVariables : function(){
        //variable for uploading file
        fileUploadObject.fd             = new FormData();
        fileUploadObject.uploadedFiles  = [];
        fileUploadObject.fileName       = "";

        if (fileUploadObject.dataUploadObj) {
            fileUploadObject.dataUploadObj.reset();
        }
    },

    /**
     * Function used for show redirection seconds count.
     * @param seconds
     * @param redirectionPath
     * @param pageName
     */
    countDown: function(seconds, redirectionPath, pageName) {

        var count = seconds;

        countdowns = setInterval(function () {

            $(".countdown").html("You will be redirected after " + count + ' seconds to ' + pageName + ' page');

            if (count == 0) {
                clearInterval(countdowns);
                common.helperFunction.redirect(redirectionPath);
            }
            count--;
        }, 1000);
    },

    /**
     * Function used for redirection to redirection path.
     * @param redirectionPath
     */
    redirect: function(redirectionPath) {
        window.location = redirectionPath;
    },

    /**
     * Function used for reset form
     * @param form
     * @param formValidate
     */
    resetForm : function(form, formValidate) {

        form[0].reset();

        if (formValidate) {
            formValidate.resetForm();
        }
    },

    /**
     * Function used for high light side bar menu
     * @param parentElement
     * @param childElement
     */
    highLightSideBarMenu : function(parentElement, childElement) {
        $('.sidebar-menu li').removeClass("active");

        if (parentElement) {
            parentElement.addClass("active");
            parentElement.find("ul").css({"display" : "block"});
        }

        childElement.addClass("active");
    }
};

/**
 * Handle all server urls used in application
 */
var ajaxURLs = {
    loginURL                                    : "login/auth",
    logoutURL                                   : "logout",
    homeURL                                     : "user/index",

    fetchAllVehicleTypes                        : "master/fetchAllVehicleTypes",
    vehicleTypeCRUD                             : "master/vehicleTypeCRUD",
    fetchVehicleTypeDetailsById                 : "master/fetchVehicleTypeDetailsById",

    fetchAllCities                              : "master/fetchAllCities",
    cityCRUD                                    : "master/cityCRUD",
    fetchCityDetailsById                        : "master/fetchCityDetailsById",

    fetchAllParties                             : "master/fetchAllParties",
    partyCRUD                                   : "master/partyCRUD",
    fetchPartyDetailsById                       : "master/fetchPartyDetailsById"
};

var codeConstant = {

    /**
     * Function for display logged in user's role
     * @param role
     * @returns modifiedRole
     *
     */
    roleModifier: function(role) {

        var modifiedRole = "";

        switch (role) {
            case "ROLE_SUPER_ADMIN":
                modifiedRole = "Super Admin";
                break;

            case "ROLE_ADMIN":
                modifiedRole = "Admin";
                break;
        }

        return modifiedRole;
    }
};

var common = {
    fileUploadObject    : fileUploadObject,
    helperFunction      : helperFunction,
    constant            : codeConstant,
    URLs                : ajaxURLs
};