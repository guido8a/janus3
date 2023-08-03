<%@ page import="janus.pac.Asignacion" %>
<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Asignaciones
    </title>
    <style type="text/css">
    td {
        font-size: 10px !important;
    }

    th {
        font-size: 11px !important;
    }

    .dato {
        margin-top: 5px !important;
    }
    </style>
</head>

<body>
<div class="span12">
    <g:if test="${flash.message}">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
            <a class="close" data-dismiss="alert" href="#">×</a>
            <elm:poneHtml textoHtml="${flash.message}"/>
        </div>
    </g:if>
</div>

<div class="col-md-12" style="font-size: 18px">
    <h3>Asignación de techos anuales a partidas presupuestarias</h3>
</div>

<div id="list-grupo" class="col-md-12" role="main" style="margin-top: 10px;">

    <div id="create-Asignacion" style="border-bottom: 1px solid black;margin-bottom: 10px">
        <g:form class="form-horizontal frm_asgn" name="frmSave-Asignacion" action="save">
            <g:hiddenField name="id" value="${asignacionInstance?.id}"/>

            <div class="col-md-12 control-group">
                <h3> <span class="col-md-2 badge badge-secondary">Año</span></h3>

                <div class="col-md-3 controls" style="width: 120px;">
                    <g:select id="anio" name="anio.id" from="${janus.pac.Anio.list()}" optionKey="id" optionValue="anio"
                              class="form-control required" value="${actual.id}" style="width: 100px;"/>
                    <p class="help-block ui-helper-hidden"></p>
                </div>
            </div>

            <div class="col-md-12 control-group">

                <h3> <span class="col-md-2 badge badge-secondary">Partida</span></h3>

                <div style="width: 1000px; margin-left: 190px;">

                    <input class="col-md-3 form-control" type="text" style="width: 300px;font-size: 12px" id="item_presupuesto">

                    <input type="hidden" id="item_prsp" name="prespuesto.id">

                    <input class="col-md-4 form-control" type="text" style="width: 400px; font-size: 12px; margin-right: 5px" id="item_desc" disabled>

                    <a href="#" class="btn btn-success" title="Crear nueva partida" id="item_agregar_prsp">
                        <i class="fa fa-file"></i>
                        Nueva partida
                    </a>
                    <a href="#" class="btn btn-warning" title="Crear nueva partida" id="prsp_editar" disabled>
                        <i class="fa fa-edit"></i>
                        Editar
                    </a>
                    <div class="col-md-12"></div>

                    <div class="col-md-1 dato" >Fuente:</div>
                    <input class="form-control col-md-4 dato" type="text" style="width: 510px;font-size: 12px;" id="item_fuente" disabled> <div class="col-md-12"></div>

                    <div class="col-md-1 dato" >Programa:</div>
                    <input class="form-control col-md-4 dato" type="text" style="width: 510px;font-size: 12px;" id="item_prog" disabled> <div class="col-md-12"></div>

                    <div class="col-md-1 dato" >Subprograma:</div>
                    <input class="form-control col-md-4 dato" type="text" style="width: 510px;;font-size: 12px;" id="item_spro" disabled> <div class="col-md-12"></div>

                    <div class="col-md-1 dato" >Proyecto:</div>
                    <input class="form-control col-md-4 dato" type="text" style="width: 510px;;font-size: 12px;" id="item_proy" disabled>  <div class="col-md-12"></div>

                </div>
            </div>


            <div class="col-md-12 control-group">
%{--                <h3> <span class="col-md-2 badge badge-secondary">Año</span></h3>--}%

%{--                <div class="col-md-3 controls" style="width: 120px;">--}%
%{--                    <g:select id="anio" name="anio.id" from="${janus.pac.Anio.list()}" optionKey="id" optionValue="anio"--}%
%{--                              class="form-control required" value="${actual.id}" style="width: 100px;"/>--}%
%{--                    <p class="help-block ui-helper-hidden"></p>--}%
%{--                </div>--}%

                <h3> <span class="col-md-2 badge badge-secondary">Valor</span></h3>

                <div class="col-md-2 controls">
                    <g:textField name="valor" id="valor" class="form-control number required" value="0.00" style="width: 150px;"/>
                    <p class="help-block ui-helper-hidden"></p>
                </div>

                <div class="col-md-2" >
                    <span>
                        <a href="#" id="guardar" class="btn btn-success"><i class="fa fa-save"></i> Guardar</a>
                    </span>
                </div>
            </div>
        </g:form>
    </div>

    <div id="list-Asignacion" class="col-md-12" style="border-top: 1px solid black; margin-top: 15px">

    </div>

</div>

<script type="text/javascript">

    var bcpc;

    $("#item_presupuesto").dblclick(function () {
        var anio = $("#anio").val();
        $.ajax({
            type    : "POST",
            url: "${createLink(action:'buscarPresupuesto')}",
            data    : {
                anio: anio
            },
            success : function (msg) {
                bcpc = bootbox.dialog({
                    id      : "dlgBuscarPR",
                    title   : "Buscar Partida",
                    class: 'modal-lg',
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    });

    function cerrarBuscadorPartida(){
        bcpc.modal("hide")
    }

    $("#valor").keydown(function (ev) {
        return validarNum(ev);
    });

    function validarNum(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39 || ev.keyCode === 190 || ev.keyCode === 110 ) ;
    }

    function cargarTecho() {
        if ($("#item_prsp").val() * 1 > 0) {
            $.ajax({
                type: "POST",
                url: "${g.createLink(controller: 'asignacion',action:'cargarTecho')}",
                data: "id=" + $("#item_prsp").val() + "&anio=" + $("#anio").val(),
                success: function (msg) {
                    $("#valor").val(number_format(msg, 2, ".", ""))
                }
            });
        } else {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Escoja una partida presupuestaria, dando doble click en el campo de texto 'Partida' " + '</strong>');
        }
    }

    $("#prsp_editar").click(function () {
        createEditPresupuesto($("#item_prsp").val());
    });

    $("#guardar").click(function () {
        var msn = "";
        var valor = $("#valor").val();
        if ($("#item_prsp").val() * 1 < 1) {
            msn += "Escoja una partida presupuestaria, dando doble click en el campo de texto 'Partida' "
        }
        if (isNaN(valor)) {
            msn += "El valor debe ser un número positivo"
        } else {
            if (valor * 1 < 0) {
                msn += "El valor debe ser un número positivo"
            }
        }
        if (msn === ""){
            var d = cargarLoader("Guardando...");
            $(".frm_asgn").submit();
        }
        else {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + msn + '</strong>');
        }
    });

    $("#anio").change(cargarTecho);

    $("#item_agregar_prsp").click(function () {
        createEditPresupuesto();
    });

    function createEditPresupuesto(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'presupuesto', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditPR",
                    title : title + " presupuesto",
                    // class : "modal-lg",
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
                                return submitFormPresupuesto();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    } //createEdit

    function submitFormPresupuesto() {
        var $form = $("#frmSave-presupuestoInstance");
        if ($form.valid()) {
            var data = $form.serialize();
            var dd = cargarLoader("Guardando...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : data,
                success : function (msg) {
                    dd.modal('hide');
                    var parts = msg.split("_");
                    if(parts[0] === 'ok'){
                        log(parts[1], "success");
                        $("#item_prsp").val(parts[2]);
                        $("#item_presupuesto").val(parts[3]);
                        $("#item_desc").val(parts[4]);
                        $("#item_fuente").val(parts[5]);
                        $("#item_prog").val(parts[6]);
                        $("#item_spro").val(parts[7]);
                        $("#item_proy").val(parts[8]);
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

    cargarListaAsinacion();

    function cargarListaAsinacion () {
        $.ajax({
            type: "POST",
            url: "${g.createLink(controller: 'asignacion', action:'tabla')}",
            data: "",
            success: function (msg) {
                $("#list-Asignacion").html(msg)
            }
        });
    }


</script>

</body>
</html>

