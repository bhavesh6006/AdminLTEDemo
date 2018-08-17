<%@ page import="com.util.CodeConstants" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Party</title>
    <meta name="layout" content="main"/>
</head>

<body>
<section class="content">
    <div class="card default-page">

        <div class="box box-primary">

            <div class="box-header with-border">
                <h3 class="box-title">Search</h3>
            </div>

            <div class="box-body">
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>Party Name</label>
                            <input id="searchByPartyName" name="searchByPartyName" type="text" class="form-control border-input" placeholder="Party Name">
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="visibility-hidden">Party Name</label>
                            <button type="button" id="search-data" class="btn btn-primary"><i class="fa fa-search mar_r_5"></i>Search</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="box box-primary">

            <div class="box-header with-border">
                <button id="add-form-data" class="btn btn-primary"><i class="fa fa-plus mar_r_5"></i>ADD</button>
            </div>

            <div class="box-body">
                <table id="parentDetailsDataTable" width="100%" class="table table-bordered table-hover dataTable dtr-inline">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Party Name</th>
                            <th>Address</th>
                            <th>Contact Number</th>
                            <th>Email</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>

    <div class="card new-page">
        <div class="box box-primary">

            <div class="box-header with-border">
                <button id="back-to-parent-default-page" class="btn btn-primary"><i class="fa fa-backward mar_r_5"></i>Back</button>
            </div>

            <form id="parent-form">
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="control-label">Party Name</label>
                                <input id="name" name="name" type="text" class="form-control border-input" placeholder="Party Name">
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="control-label">Address</label>
                                <textarea id="address" name="address" rows="2" class="form-control border-input" placeholder="Address"></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Contact Number</label>
                                <input id="contactNumber" name="contactNumber" maxlength="10" type="text" class="form-control border-input" placeholder="Contact Number">
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Email</label>
                                <input id="email" name="email" type="text" class="form-control border-input" placeholder="Email">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="box-footer">
                    <div class="col-md-12">
                        <button id="save-form-data" type="button" class="btn btn-primary pull-right"><i class="fa fa-save mar_r_5"></i>Save</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</section>

<script>

    var parentFormValidate;

    /**
     * This code used as global variables for entire page
     */
    var globalConfig = {
        parentDetailsTable  : {},
        CRUD_MODE           : "",
        parentRowData       : []
    };

    var eventHandler = {

        /**
         * Function used for handle all events
         */
        allEventHandler : function() {

            handlers.showData.fetchAllParties();

            $('#search-data').click(function() {
                handlers.showData.fetchAllParties();
            });

            $('#add-form-data').click(function() {
                $('.default-page').hide();
                $('.new-page').show();

                common.helperFunction.resetForm($('#parent-form'), parentFormValidate);
                globalConfig.CRUD_MODE = "ADD";
            });

            $('#back-to-parent-default-page').click(function() {
                $('.new-page').hide();
                $('.default-page').show();
                handlers.showData.fetchAllParties();
            });

            $('#save-form-data').click(function() {
                var form = $('#parent-form');
                handlers.formValidate.validateParentForm(form);
                form.submit();
            });

            $('body')
                    .on('click', '#parentDetailsDataTable tbody tr .partyUpdate', function () {
                        var rowData = globalConfig.parentDetailsTable.row($(this).parents('tr')).data();
                        $('.default-page').hide();
                        $('.new-page').show();
                        globalConfig.CRUD_MODE = "UPDATE";

                        common.helperFunction.resetForm($('#parent-form'), parentFormValidate);
                        handlers.ajaxCalls.fetchPartyDetailsById(rowData.id);
                    })

                    .on('click', '#parentDetailsDataTable tbody tr .partyDelete', function () {

                        var rowData = globalConfig.parentDetailsTable.row($(this).parents('tr')).data();

                        swal({
                                    title: "Are you sure?",
                                    text: "You want to delete?",
                                    type: "warning",
                                    showCancelButton: true,
                                    cancelButtonText: "No",
                                    confirmButtonColor: '#3085d6',
                                    cancelButtonColor: '#d33',
                                    confirmButtonText: "Yes",
                                    closeOnConfirm: true
                                },
                                function(){
                                    globalConfig.CRUD_MODE = "DELETE";
                                    globalConfig.parentRowData.id = rowData.id;
                                    handlers.ajaxCalls.partyCRUD();
                                });
                    });

            $("#contactNumber").keypress(function (e) {
                //if the letter is not digit then display error and don't type anything
                if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                    return false;
                }
            });
        }
    };

    var validateForms = {

        /**
         * Function used for validate parent form
         * @param form - Holds form selector
         */
        validateParentForm : function(form) {

            parentFormValidate = form.validate({

                errorPlacement: function(error, element) {

                    error.addClass("customError");

                    var placement = $(element).data('error');

                    if (placement) {
                        $(placement).append(error)

                    }else if(element.is(".select2")){
                        error.insertAfter(element.next());
                    }
                    else {
                        error.insertAfter(element);
                    }
                },
                rules: {
                    'name': {
                        required    : true
                    },
                    'address': {
                        required    : true
                    },
                    'email': {
                        email       : true
                    }
                },
                messages: {
                    'name': {
                        required    : "Party name is mandatory"
                    },
                    'address': {
                        required    : "Address is mandatory"
                    },
                    'email': {
                        email       : "Please enter valid email address"
                    }
                },
                submitHandler: function (form) {
                    $('#save-form-data').prop("disabled", true);
                    handlers.ajaxCalls.partyCRUD();
                }
            });
        }
    };

    var ajaxCallHandler = {

        /**
         * Function used for CRUD
         */
        partyCRUD : function() {

            var url = "<%=request.getContextPath() %>/" + common.URLs.partyCRUD;

            var formData = common.helperFunction.trimFormData($('#parent-form'));
            formData.CRUD_MODE = globalConfig.CRUD_MODE;

            if (globalConfig.CRUD_MODE == "UPDATE" || globalConfig.CRUD_MODE == "DELETE") {
                formData.id = globalConfig.parentRowData.id;
            }

            $.ajax({
                type        : 'POST',
                url         : url,
                cache       : false,
                data        : formData,
                success     : function (response) {

                    $('#save-form-data').prop("disabled", false);
                    common.helperFunction.showNotification(response.status, response.message);

                    if (response.status) {
                        common.helperFunction.resetForm($('#parent-form'));

                        if (globalConfig.CRUD_MODE == "ADD" || globalConfig.CRUD_MODE == "UPDATE") {
                            $('.new-page').hide();
                            $('.default-page').show();
                        }

                        handlers.showData.fetchAllParties();
                        globalConfig.CRUD_MODE = "";
                        globalConfig.parentRowData = [];
                    }
                },
                error       : function (error) {
                    $('#save-form-data').prop("disabled", false);
                    common.helperFunction.showNotification(false, "Something went wrong");
                }
            });
        },

        /**
         * Function used for fetch Party details by id
         * @id  - Holds database id of Party
         */
        fetchPartyDetailsById : function(id) {

            var url = "<%=request.getContextPath() %>/" + common.URLs.fetchPartyDetailsById;
            var formData = {};
            formData.id = id;

            $.ajax({
                type        : 'POST',
                url         : url,
                cache       : false,
                data        : formData,
                success     : function (response) {
                    globalConfig.parentRowData = response.data;
                    handlers.functionCalls.setFormData();
                },
                error       : function (error) {
                    $('#save-form-data').prop("disabled", false);
                    common.helperFunction.showNotification(false, "Something went wrong");
                }
            });
        }
    };

    var show = {

        /**
         * Function used for fetch All Party
         */
        fetchAllParties : function() {

            globalConfig.parentDetailsTable = $('#parentDetailsDataTable').DataTable();
            globalConfig.parentDetailsTable.destroy();
            globalConfig.parentDetailsTable = $('#parentDetailsDataTable').DataTable({

                "ajax": {
                    "url": "<%=request.getContextPath()%>/" + common.URLs.fetchAllParties,
                    "data": function ( paginationParams ) {

                        var data = {};

                        data.start              = paginationParams.start;
                        data.searchByPartyName  = $('#searchByPartyName').val();

                        /**
                         * This code is used for send column name and sorting order to the server for server side pagination
                         * @paginationParams.order[0].column    - Gives a column number
                         * @paginationParams.order[0].dir       - Gives an order to sort
                         */
                        if (paginationParams.order[0].column && paginationParams.order[0].dir) {

                            switch (paginationParams.order[0].column) {

                                case 1:
                                    data.columnName = "name";
                                    data.order      = paginationParams.order[0].dir;
                                    break;

                                case 2:
                                    data.columnName = "address";
                                    data.order      = paginationParams.order[0].dir;
                                    break;

                                case 3:
                                    data.columnName = "contactNumber";
                                    data.order      = paginationParams.order[0].dir;
                                    break;

                                case 4:
                                    data.columnName = "email";
                                    data.order      = paginationParams.order[0].dir;
                                    break;
                            }
                        }

                        return data;
                    },
                    "type": "POST",
                    "error": function() {}
                },
                "processing": false,
                "serverSide": true,
                "bLengthChange": false,
                "iDisplayLength": ${CodeConstants.NUMBER_OF_RECORDS_PER_PAGE_IN_DATA_TABLE},
                "searching": false,
                "columns": [
                    {
                        "orderable": false,
                        "width" : "50px",
                        render: function (data, type, row, meta) {
                            return meta.row + meta.settings._iDisplayStart + 1;
                        }
                    },
                    {"data": "name", "width": "20%"},
                    {"data": "address", "width": "30%"},
                    {"data": "contactNumber", "width": "15%"},
                    {"data": "email", "width": "20%"},
                    {
                        "targets": -1,
                        "orderable": false,
                        "data": null,
                        "width": "10%",
                        "render": function ( data, type, row ) {
                            var returnedData = "<i  class='fa fa-edit text-info dataTableActionMargin partyUpdate cursorHoverHand update' aria-hidden='true' data-toggle='tooltip' data-container='body' title='Edit'></i>" +
                                    "<i  class='fa fa-trash text-danger dataTableActionMargin partyDelete cursorHoverHand update' aria-hidden='true' data-toggle='tooltip' data-container='body' title='Delete'></i>";

                            return returnedData;
                        }
                    }],
                "order": [1],
                "language": {
                    "emptyTable": "No data available"
                }
            });
        }
    };

    var functionCallHandler = {

        /**
         * Function used to set form data
         */
        setFormData : function() {

            var form = $('#parent-form');
            var formData = $(form).serializeArray();

            /**
             * Code used for iterate all elements in the form and set their value accordingly
             */
            $.each(formData, function(index, data) {
                $('#' + data.name).val(globalConfig.parentRowData[data.name]);
            });
        }
    };

    $(document).ready(function () {

        common.helperFunction.highLightSideBarMenu("", $('#party'));
        handlers.eventHandler.allEventHandler();
    });

    var handlers = {
        eventHandler    : eventHandler,
        formValidate    : validateForms,
        ajaxCalls       : ajaxCallHandler,
        showData        : show,
        functionCalls   : functionCallHandler
    };
</script>

</body>
</html>