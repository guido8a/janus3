
<%@ page import="janus.ValoresAnuales" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Valores Anuales
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
        Nuevos Valores Anuales
    </a>
</div>

<div id="list-ValoresAnuales" role="main" style="margin-top: 10px;">

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th>Año</th>
            <th>Costo Diesel</th>
            <th>Costo Grasa</th>
            <th>Costo Lubricante</th>
            <th>Factor Costo Repuestos Reparaciones</th>
            <th>Sueldo Básico Unificado</th>
            <th>Tasa de Interés Anual</th>
            <th>Seguro</th>
            <th>Inflación</th>
            <th style="width: 130px">Acciones</th>
        </tr>
        </thead>
        <tbody >
        <g:each in="${valoresAnualesInstanceList}" status="i" var="valoresAnualesInstance">
            <tr>
                <td>${valoresAnualesInstance?.anioNuevo?.anio}</td>
                %{--<td>${valoresAnualesInstance.anio}</td>--}%
                <td>${fieldValue(bean: valoresAnualesInstance, field: "costoDiesel")}</td>
                <td>${fieldValue(bean: valoresAnualesInstance, field: "costoGrasa")}</td>
                <td>${fieldValue(bean: valoresAnualesInstance, field: "costoLubricante")}</td>
                <td>${fieldValue(bean: valoresAnualesInstance, field: "factorCostoRepuestosReparaciones")}</td>
                <td>${fieldValue(bean: valoresAnualesInstance, field: "sueldoBasicoUnificado")}</td>
                <td>${fieldValue(bean: valoresAnualesInstance, field: "tasaInteresAnual")}</td>
                <td>${fieldValue(bean: valoresAnualesInstance, field: "seguro")}</td>
                <td>${fieldValue(bean: valoresAnualesInstance, field: "inflacion")}</td>
                <td>
                    <a class="btn btn-info btn-xs btn-show" href="#"  title="Ver" data-id="${valoresAnualesInstance.id}">
                        <i class="fa fa-clipboard"></i>
                    </a>
                    <a class="btn btn-success btn-xs btn-edit" href="#"  title="Editar" data-id="${valoresAnualesInstance.id}">
                        <i class="fa fa-edit"></i>
                    </a>
                    <a class="btn btn-danger btn-xs btn-delete" href="#" title="Eliminar" data-id="${valoresAnualesInstance.id}">
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
                    title   : title + " Clase de Obra",
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
                                return submitFormVA();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormVA() {
        var $form = $("#frmSave-ValoresAnuales");
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
                        title   : "Tipo de Obra",
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
