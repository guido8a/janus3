
<%@ page import="janus.ejecucion.PeriodosInec" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Períodos de Índices
    </title>
</head>
<body>

<div class="col-md-12" style="margin-bottom: 10px">
    <div class="btn-group" role="navigation">
        <a href="#" class="btn btn-success btn-new">
            <i class="fa fa-file"></i>
            Crear Período de Índices
        </a>
    </div>
</div>

<div id="list-PeriodosInec" role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 20%;">Descripción</th>
            <th style="width: 20%;">Fecha Inicio</th>
            <th style="width: 20%;">Fecha Fin</th>
            <th style="width: 20%;">Período Cerrado</th>
            <th style="width: 20%;">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div id="tablaPeriodosIndices"></div>


<script type="text/javascript">

    cargarTablaPeriodos();

    function cargarTablaPeriodos () {
        var v = cargarLoader("Cargando...");
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'periodosInec', action: 'tablaPeriodosIndices_ajax')}",
            data:{
            },
            success: function (msg){
                v.modal("hide");
                $("#tablaPeriodosIndices").html(msg)
            }
        })
    }


        $(".btn-new").click(function () {
            createEditRowPI();
        }); //click btn new


        function createEditRowPI(id) {
            var title = id ? "Editar " : "Crear ";
            var data = id ? {id : id} : {};

            $.ajax({
                type    : "POST",
                url: "${createLink(action:'form_ajax')}",
                data    : data,
                success : function (msg) {
                    var b = bootbox.dialog({
                        id      : "dlgCreateEdit",
                        title   : title + " Período",
                        message : msg,
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            },
                            guardar  : {
                                id        : "btnSave",
                                label     : "<i class='fa fa-save'></i> Guardar",
                                className : "btn-success",
                                callback  : function () {
                                    return submitFormPeriodo();
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                } //success
            }); //ajax
        } //createEdit


        function submitFormPeriodo() {
            var $form = $("#frmSave-PeriodosInec");
            if ($form.valid()) {
                var data = $form.serialize();
                var dialog = cargarLoader("Guardando...");
                $.ajax({
                    type    : "POST",
                    url     : $form.attr("action"),
                    data    : data,
                    success : function (msg) {
                        dialog.modal('hide');
                        var parts = msg.split("_");
                        if(parts[0] === 'ok'){
                            log(parts[1], "success");
                            cargarTablaPeriodos();
                        }else{
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                            return false;
                        }
                    }
                });
            } else {
                return false;
            }
        }


        %{--$(".btn-show").click(function () {--}%
        %{--    var id = $(this).data("id");--}%
        %{--    $.ajax({--}%
        %{--        type    : "POST",--}%
        %{--        url     : "${createLink(action:'show_ajax')}",--}%
        %{--        data    : {--}%
        %{--            id : id--}%
        %{--        },--}%
        %{--        success : function (msg) {--}%
        %{--            var s = bootbox.dialog({--}%
        %{--                id      : "dlgShow",--}%
        %{--                title   : "Datos de Período",--}%
        %{--                message : msg,--}%
        %{--                buttons : {--}%
        %{--                    cancelar : {--}%
        %{--                        label     : "Cancelar",--}%
        %{--                        className : "btn-primary",--}%
        %{--                        callback  : function () {--}%
        %{--                        }--}%
        %{--                    }--}%
        %{--                } //buttons--}%
        %{--            }); //dialog--}%
        %{--        }--}%
        %{--    });--}%
        %{--    return false;--}%
        %{--}); //click btn show--}%

    // });

</script>

</body>
</html>
