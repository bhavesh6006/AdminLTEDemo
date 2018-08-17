<%@ page import="com.util.CodeConstants" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Vehicle Type</title>
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
                            <label>Type</label>
                            <input id="searchByVehicleType" name="searchByVehicleType" type="text" class="form-control border-input" placeholder="Type">
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="visibility-hidden">Type</label>
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
                            <th>Vehicle Type</th>
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
                                <label class="control-label">Type</label>
                                <input id="type" name="type" type="text" class="form-control border-input" placeholder="Type">
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

            handlers.showData.fetchAllVehicleTypes();

            $('#search-data').click(function() {
                handlers.showData.fetchAllVehicleTypes();
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
                handlers.showData.fetchAllVehicleTypes();
            });

            $('#save-form-data').click(function() {
                var form = $('#parent-form');
                handlers.formValidate.validateParentForm(form);
                form.submit();
            });

            $('body')
                    .on('click', '#parentDetailsDataTable tbody tr .vehicleTypeUpdate', function () {
                        var rowData = globalConfig.parentDetailsTable.row($(this).parents('tr')).data();
                        $('.default-page').hide();
                        $('.new-page').show();
                        globalConfig.CRUD_MODE = "UPDATE";

                        common.helperFunction.resetForm($('#parent-form'), parentFormValidate);
                        handlers.ajaxCalls.fetchVehicleTypeDetailsById(rowData.id);
                    })

                    .on('click', '#parentDetailsDataTable tbody tr .vehicleTypeDelete', function () {

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
                            handlers.ajaxCalls.vehicleTypeCRUD();
                        });
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
                    'type': {
                        required    : true
                    }
                },
                messages: {
                    'type': {
                        required    : "Type is mandatory"
                    }
                },
                submitHandler: function (form) {
                    $('#save-form-data').prop("disabled", true);
                    handlers.ajaxCalls.vehicleTypeCRUD();
                }
            });
        }
    };

    var ajaxCallHandler = {

        /**
         * Function used for CRUD
         */
        vehicleTypeCRUD : function() {

            var url = "<%=request.getContextPath() %>/" + common.URLs.vehicleTypeCRUD;

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

                        handlers.showData.fetchAllVehicleTypes();
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
         * Function used for fetch vehicle type details by id
         * @id  - Holds database id of Vehicle Type
         */
        fetchVehicleTypeDetailsById : function(id) {

            var url = "<%=request.getContextPath() %>/" + common.URLs.fetchVehicleTypeDetailsById;
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
         * Function used for fetch All Vehicle Types
         */
        fetchAllVehicleTypes : function() {

            globalConfig.parentDetailsTable = $('#parentDetailsDataTable').DataTable();
            globalConfig.parentDetailsTable.destroy();
            globalConfig.parentDetailsTable = $('#parentDetailsDataTable').DataTable({

                "ajax": {
                    "url": "<%=request.getContextPath()%>/" + common.URLs.fetchAllVehicleTypes,
                    "data": function ( paginationParams ) {

                        var data = {};

                        data.start                = paginationParams.start;
                        data.searchByVehicleType  = $('#searchByVehicleType').val();

                        /**
                         * This code is used for send column name and sorting order to the server for server side pagination
                         * @paginationParams.order[0].column    - Gives a column number
                         * @paginationParams.order[0].dir       - Gives an order to sort
                         */
                        if (paginationParams.order[0].column && paginationParams.order[0].dir) {

                            switch (paginationParams.order[0].column) {

                                case 1:
                                    data.columnName = "type";
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
                    {"data": "type", "width": "85%"},
                    {
                        "targets": -1,
                        "orderable": false,
                        "data": null,
                        "width": "10%",
                        "render": function ( data, type, row ) {
                            var returnedData = "<i  class='fa fa-edit text-info dataTableActionMargin vehicleTypeUpdate cursorHoverHand update' aria-hidden='true' data-toggle='tooltip' data-container='body' title='Edit'></i>" +
                                    "<i  class='fa fa-trash text-danger dataTableActionMargin vehicleTypeDelete cursorHoverHand update' aria-hidden='true' data-toggle='tooltip' data-container='body' title='Delete'></i>";

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

        common.helperFunction.highLightSideBarMenu("", $('#vehicleType'));
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