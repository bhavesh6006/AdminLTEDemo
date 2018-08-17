<%@ page import="grails.util.Holders" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Log in</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/bootstrap/bootstrap.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/font-awesome/font-awesome.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/iCheck/blue.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/AdminLTE.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/custom.css">

    <style>
        html, body {
             height: auto !important;
        }
    </style>

</head>
<body class="hold-transition login-page">
<div class="login-box">
    <div class="login-logo">
        <h2>${Holders.config.system.login.page.logo}</h2>
    </div>
    <!-- /.login-logo -->
    <div class="login-box-body">
        <p class="login-box-msg">Sign in to start your session</p>

        <form action='${postUrl}' method='POST' id='loginForm' class='cssform' autocomplete='off'>
            <div class="row">
                <div class="form-group col-md-12">
                    <g:if test='${flash.message}'>
                        <span class='login_message' style="color: red">${flash.message}</span>
                    </g:if>
                </div>
            </div>

            <div class="form-group has-feedback">
                <input type="text" class="form-control" id="username" name="j_username" placeholder="User Name">
                <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <input type="password" class="form-control" id="password" name="j_password"  placeholder="Password">
                <span class="glyphicon glyphicon-lock form-control-feedback"></span>
            </div>

            <div class="row">
                <div class="col-xs-4 pull-right">
                    <button type="submit" class="btn btn-primary btn-block btn-flat pull-right" id="buttonSubmit"><i class="fa fa-sign-in mar_r_5"></i>Login</button>
                </div><!-- /.col -->
            </div>
        </form>

    </div>
    <!-- /.login-box-body -->
</div>
<!-- /.login-box -->

<script src="<%=request.getContextPath()%>/js/jQuery/jquery-3.2.1.min.js"></script>
<script src="<%=request.getContextPath()%>/js/bootstrap/bootstrap.min.js"></script>
<script src="<%=request.getContextPath()%>/js/iCheck/icheck.js"></script>
<script src="<%=request.getContextPath()%>/js/jQuery/jquery.validate.min.js"></script>
<script src="<%=request.getContextPath()%>/js/validationConstants.js"></script>

<script>

    var functionCallHandler = {

        /**
         * Function used for validate login form
         */
        validateLoginForm : function() {

            var form = $("#loginForm");

            form.validate({

                errorElement : 'span',
                errorPlacement : function(error, element) {
                    error.addClass("customError");
                    var placement = $(element).data('error');
                    if (placement) {
                        $(placement).append(error)
                    } else {
                        error.insertAfter(element);
                    }
                },

                rules: {
                    j_username: {
                        required    : true,
                        minlength   : validationConstants.userName.minLength,
                        maxlength   : validationConstants.userName.maxLength
                    },
                    j_password: {
                        required    : true,
                        minlength   : validationConstants.password.minLength,
                        maxlength   : validationConstants.password.maxLength
                    }
                },

                messages: {
                    j_username: {
                        required    : "Username is mandatory",
                        minlength   : "Please enter at least 5 characters",
                        maxlength   : "Please enter no more than 30 characters"
                    },
                    j_password: {
                        required    : "Password is mandatory",
                        minlength   : "Please enter at least 6 characters",
                        maxlength   : "Please enter no more than 15 characters"
                    }
                }
            });
        }
    };

    $(document).ready(function () {
        //call for form validation
        functionCallHandler.validateLoginForm();
    });
</script>
</body>
</html>