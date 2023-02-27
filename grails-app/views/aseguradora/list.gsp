<%@ page import="janus.pac.Aseguradora" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Aseguradoras
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
        Nueva aseguradora
    </a>
    <a href="#" class="btn btn-primary" id="print" >
        <i class="fa fa-print"></i>
        Imprimir
    </a>
</div>

<div id="list-Aseguradora" role="main" style="margin-top: 10px;">

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th>Nombre</th>
            <th>Fax</th>
            <th>Teléfonos</th>
            <th>Mail</th>
            <th>Responsable</th>
            <th>Fecha contacto</th>
            <th style="width: 120px">Acciones</th>
        </tr>
        </thead>
        <tbody class="paginate">
        <g:each in="${aseguradoraInstanceList}" status="i" var="aseguradoraInstance">
            <tr>
                <td>${fieldValue(bean: aseguradoraInstance, field: "nombre")}</td>
                <td>${fieldValue(bean: aseguradoraInstance, field: "fax")}</td>
                <td>${fieldValue(bean: aseguradoraInstance, field: "telefonos")}</td>
                <td>${fieldValue(bean: aseguradoraInstance, field: "mail")}</td>
                <td>${fieldValue(bean: aseguradoraInstance, field: "responsable")}</td>
                <td><g:formatDate date="${aseguradoraInstance.fechaContacto}" format="dd-MM-yyyy"/></td>
                <td>
                    <a class="btn btn-info btn-xs btn-show" href="#"  title="Ver" data-id="${aseguradoraInstance.id}">
                        <i class="fa fa-clipboard"></i>
                    </a>
                    <a class="btn btn-success btn-xs btn-edit" href="#"  title="Editar" data-id="${aseguradoraInstance.id}">
                        <i class="fa fa-edit"></i>
                    </a>
                    <a class="btn btn-danger btn-xs btn-delete" href="#" title="Eliminar" data-id="${aseguradoraInstance.id}">
                        <i class="fa fa-trash"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<elm:pagination total="${aseguradoraTotal}" params="${params}" />


<script type="text/javascript">

    $("#print").click(function(){
        location.href="${createLink(controller: 'reportes', action: '_aseguradoras')}"
    });

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
                    title   : title + " Aseguradora",
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
                                return submitFormAseguradora();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormAseguradora() {
        var $form = $("#frmSave-Aseguradora");
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
                        title   : "Aseguradoras",
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
