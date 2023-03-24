<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Configuración</title>

    <style type="text/css">
    .auth {
        width : 155px !important;
    }
    </style>

</head>

<body>

%{--//password--}%

<div class="panel panel-info">
    <div class="panel-heading" role="tab" id="headerPass">
        <h4 class="panel-title">
            <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="true" aria-controls="collapseTwo">
                Cambiar clave de ingreso al sistema
            </a>
        </h4>
    </div>

    <div id="collapseTwo" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headerPass">
        <div class="panel-body">
            <g:form class="form-inline" name="frmPass" action="savePass_ajax">
                <g:hiddenField name="id" value="${usuario?.id}"/>
                <div class="form-group">
                    <label for="input2">Clave actual</label>

                    <div class="input-group">
                        <g:passwordField name="input2" class="form-control auth" />
                        <span class="input-group-addon"><i class="fa fa-unlock"></i></span>
                    </div>
                </div>

                <div class="form-group" style="margin-left: 40px;">
                    <label for="nuevoPass">Nueva clave</label>

                    <div class="input-group">
                        <g:passwordField name="nuevoPass" class="form-control required auth"/>
                        <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                    </div>
                </div>

                <div class="form-group" style="margin-left: 40px;">
                    <label for="passConfirm">Confirme la clave nueva</label>

                    <div class="input-group">
                        <g:passwordField name="passConfirm" class="form-control required auth"/>
                        <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                    </div>
                </div>
                <a href="#" id="btnSavePass" class="btn btn-success" style="margin-left: 40px;">
                    <i class="fa fa-save"></i> Guardar
                </a>
            </g:form>
        </div>
    </div>
</div>



<script type="text/javascript">
    $(function () {
        var $frmPass = $("#frmPass");

        $("#btnSavePass").click(function () {

            if ($frmPass.valid()) {
                $.ajax({
                    type    : "POST",
                    url     : $frmPass.attr("action"),
                    data    : $frmPass.serialize(),
                    success : function (msg) {
                        console.log("-->" + msg)
                        var parts = msg.split("*");
                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                        setTimeout(function () {
                            if (parts[0] == "SUCCESS") {
                                location.href = "${createLink(controller: "login", action: "logout" )}"
                            } else {
                            }
                        }, 1000);
                        closeLoader();
                    }
                });
            }
            return false;
        });

    });
</script>

</body>
</html>