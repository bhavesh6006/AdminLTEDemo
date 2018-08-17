<%@ page import="grails.util.Holders" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title><g:layoutTitle/></title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/bootstrap/bootstrap.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/select2/select2.min.css" />
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/AdminLTE.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/skins/_all-skins.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/font-awesome/font-awesome.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/iCheck/blue.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/datatables/dataTables.bootstrap.min.css" />
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/jQuery/uploadfile.min.css" />
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/sweetAlert/sweetalert.css" />
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/custom.css" />
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/pNotify/pnotify.custom.min.css" />

    <script src="<%=request.getContextPath()%>/js/jQuery/jquery-3.2.1.min.js"></script>

    <g:layoutHead/>
</head>
<body class="sidebar-mini skin-purple-light fixed">
<div class="wrapper">

    <header class="main-header">
        <!-- Logo -->
        <a href="javaScript:void(0)" class="logo">
            <!-- mini logo for sidebar mini 50x50 pixels -->
            <span class="logo-mini">${Holders.config.system.small.logo.display.name}</span>
            <!-- logo for regular state and mobile devices -->
            <span class="logo-lg">${Holders.config.system.big.logo.display.name}</span>
        </a>
        <!-- Header Navbar: style can be found in header.less -->
        <nav class="navbar navbar-static-top">
            <!-- Sidebar toggle button-->
            <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
                <span class="sr-only">Toggle navigation</span>
            </a>

            <div class="navbar-custom-menu pull-left">
                <ul class="nav navbar-nav">

                    <li><a class="title page-title"><b>${title}</b></a></li>

                </ul>
            </div>
        </nav>
    </header>
    <!-- Left side column. contains the logo and sidebar -->
    <aside class="main-sidebar">
        <!-- sidebar: style can be found in sidebar.less -->
        <section class="sidebar">

            <!-- sidebar menu: : style can be found in sidebar.less -->
            <ul class="sidebar-menu">

                <li id="dashboard"><a href="<%=request.getContextPath()%>/user/home"><i class="fa fa-tachometer" aria-hidden="true"></i> <span>Dashboard</span></a></li>
                <li id="vehicleType"><a href="<%=request.getContextPath()%>/master/vehicleType"><i class="fa fa-tachometer" aria-hidden="true"></i> <span>Vehicle Type</span></a></li>
                <li id="city"><a href="<%=request.getContextPath()%>/master/city"><i class="fa fa-tachometer" aria-hidden="true"></i> <span>City</span></a></li>
                <li id="party"><a href="<%=request.getContextPath()%>/master/party"><i class="fa fa-tachometer" aria-hidden="true"></i> <span>Party</span></a></li>
                <li id="logout"><a href="javaScript:void(0)"><i class="fa fa-sign-out" aria-hidden="true"></i> <span>Sign Out</span></a></li>

            </ul>
        </section>
        <!-- /.sidebar -->
    </aside>

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
        <g:layoutBody/>
    </div>
    <!-- /.content-wrapper -->

    %{--<footer class="main-footer">--}%
        %{--<strong>FOOTER</strong>--}%
    %{--</footer>--}%

</div>
<!-- ./wrapper -->

<script src="<%=request.getContextPath()%>/js/bootstrap/bootstrap.min.js"></script>
<script src="<%=request.getContextPath()%>/js/iCheck/icheck.js"></script>
<script src="<%=request.getContextPath()%>/js/app.min.js"></script>
<script src="<%=request.getContextPath()%>/js/slimScroll/jquery.slimscroll.js"></script>
<script src="<%=request.getContextPath()%>/js/datatables/jquery.dataTables.min.js"></script>
<script src="<%=request.getContextPath()%>/js/datatables/dataTables.bootstrap.min.js"></script>
<script src="<%=request.getContextPath()%>/js/jQuery/jquery.uploadfile.min.js"></script>
<script src="<%=request.getContextPath()%>/js/jQuery/jquery.validate.min.js"></script>
<script src="<%=request.getContextPath()%>/js/jQuery/underscore-min.js"></script>
<script src="<%=request.getContextPath()%>/js/sweetAlert/sweetalert.min.js"></script>
<script src="<%=request.getContextPath()%>/js/custom/common.js"></script>
<script src="<%=request.getContextPath()%>/js/pNotify/pnotify.custom.min.js"></script>
<script src="<%=request.getContextPath()%>/js/jQuery/loadingoverlay.min.js"></script>
<script src="<%=request.getContextPath()%>/js/select2/select2.full.min.js"></script>
<script src="<%=request.getContextPath()%>/js/jQuery/textcounter.min.js"></script>
<script src="<%=request.getContextPath()%>/js/validationConstants.js"></script>

<script>

    /**
     * Function used for set options for loading spinner
     * @type {{image: string, maxSize: string, minSize: string, resizeInterval: number, size: string}}
     */
    var loadingOptions = {
        image           : "<%=request.getContextPath()%>/images/loading.gif",
        maxSize         : "80px",
        minSize         : "20px",
        resizeInterval  : 0,
        size            : "50%"
    };

    /**
     * Function used for start spinner at the time of ajax call send a request to server
     */
    $(document).ajaxSend(function(event, jqxhr, settings){
        $.LoadingOverlay("show", loadingOptions);
    });

    /**
     * Function used for stop spinner at the time of ajax call stop a request
     */
    $(document).ajaxStop(function(event, jqxhr, settings){
        $.LoadingOverlay("hide", loadingOptions);
    });

    /**
     * Function used for set action logic according to status code of ajax call and also stop the spinner on status code ==> 400 & 200
     */
    $.ajaxSetup({
        statusCode: {
            401: function () {
                window.location = "<%=request.getContextPath() %>/" + common.URLs.logoutURL;
            },
            400: function(error) {
                common.helperFunction.showNotification(error.responseJSON.status, error.responseJSON.message);
                $.LoadingOverlay("hide", loadingOptions);
            },
            403: function() {
                $.LoadingOverlay("hide", loadingOptions);
            }
        }
    });

    $(document).ready(function() {

        $( "#logout").on( "click", function() {
            swal({
                title: "Are you sure?",
                text: "You want to exit?",
                type: "warning",
                showCancelButton: true,
                cancelButtonText: "No",
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: "Yes",
                closeOnConfirm: false
            },
            function(){
                window.location = "<%=request.getContextPath()%>/" + common.URLs.logoutURL;
            });
        });
    });
</script>

</body>
</html>