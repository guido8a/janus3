
<%@ page import="janus.pac.TipoProcedimiento" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Tipos de Procedimientos
    </title>
</head>
<body>

<div class="span12 btn-group" role="navigation">
    <g:link class="link btn btn-info" controller="inicio" action="parametros">
        <i class="fa fa-arrow-left"></i>
        Parámetros
    </g:link>
    <a href="#" class="btn btn-success btn-new">
        <i class="fa fa-file"></i>
        Nueva Tipo
    </a>
</div>

<div id="list-TipoProcedimiento" role="main" style="margin-top: 10px;">

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th>Descripción</th>
            <th>Sigla</th>
            <th>Costo de Bases</th>
            <th>Desde</th>
            <th>Techo</th>
            <th>Preparatorio (d)</th>
            <th>Precontractual (d)</th>
            <th>Contractual (d)</th>
            <th style="width: 130px">Acciones</th>
        </tr>
        </thead>
        <tbody >
        <g:each in="${tipoProcedimientoInstanceList}" status="i" var="tipoProcedimientoInstance">
            <tr>
                <td>${fieldValue(bean: tipoProcedimientoInstance, field: "descripcion")}</td>
                <td>${fieldValue(bean: tipoProcedimientoInstance, field: "sigla")}</td>
                <td>${fieldValue(bean: tipoProcedimientoInstance, field: "bases")}</td>
                <td style="text-align: right" > <g:formatNumber number="${tipoProcedimientoInstance?.minimo}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
                <td style="text-align: right" > <g:formatNumber number="${tipoProcedimientoInstance?.techo}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
                <td>${fieldValue(bean: tipoProcedimientoInstance, field: "preparatorio")}</td>
                <td>${fieldValue(bean: tipoProcedimientoInstance, field: "precontractual")}</td>
                <td>${fieldValue(bean: tipoProcedimientoInstance, field: "contractual")}</td>
                <td>
                    <a class="btn btn-info btn-xs btn-show" href="#"  title="Ver" data-id="${tipoProcedimientoInstance.id}">
                        <i class="fa fa-clipboard"></i>
                    </a>
                    <a class="btn btn-success btn-xs btn-edit" href="#"  title="Editar" data-id="${tipoProcedimientoInstance.id}">
                        <i class="fa fa-edit"></i>
                    </a>
                    <a class="btn btn-danger btn-xs btn-delete" href="#" title="Eliminar" data-id="${tipoProcedimientoInstance.id}">
                        <i class="fa fa-trash"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>


<script type="text/javascript">
    function createEditRow(id) {
        var title = id ? "Editar " : "Crear ";
        var data = id ? {id : id} : {};

        $.ajax({
            type    : "POST",
            url: "${createLink(action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Tipo de procedimiento",
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
                                return submitFormTP();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormTP() {
        var $form = $("#frmSave-TipoProcedimiento");
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
                        setTimeout(function () {
                            location.reload();
                        }, 800);
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

    $(function () {

        $(".btn-new").click(function () {
            createEditRow();
        }); //click btn new

        $(".btn-edit").click(function () {
            var id = $(this).data("id");
            createEditRow(id);
        }); //click btn edit

        $(".btn-delete").click(function () {
            var id = $(this).data("id");
            deleteRow(id);
        });

        $(".btn-show").click(function () {
            var id = $(this).data("id");
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'show_ajax')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    bootbox.dialog({
                        title   : "Tipo de Procedimiento",
                        message : msg,
                        buttons : {
                            ok : {
                                label     : "Aceptar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            }
                        }
                    });
                }
            });
        }); //click btn show

        function deleteRow(itemId) {
            bootbox.dialog({
                title   : "Alerta",
                message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><p style='font-weight: bold'> Está seguro que desea eliminar este registro? Esta acción no se puede deshacer.</p>",
                buttons : {
                    cancelar : {
                        label     : "Cancelar",
                        className : "btn-primary",
                        callback  : function () {
                        }
                    },
                    eliminar : {
                        label     : "<i class='fa fa-trash'></i> Eliminar",
                        className : "btn-danger",
                        callback  : function () {
                            var v = cargarLoader("Eliminando...");
                            $.ajax({
                                type    : "POST",
                                url     : '${createLink(action:'delete')}',
                                data    : {
                                    id : itemId
                                },
                                success : function (msg) {
                                    v.modal("hide");
                                    var parts = msg.split("_");
                                    if(parts[0] === 'ok'){
                                        log(parts[1],"success");
                                        setTimeout(function () {
                                            location.reload()
                                        }, 800);
                                    }else{
                                        log(parts[1],"error")
                                    }
                                }
                            });
                        }
                    }
                }
            });
        }
    });
</script>

</body>
</html>
