
<%@ page import="janus.TipoLista" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Tipos de Listas de Precios
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
        Nuevo Tipo de Lista
    </a>
</div>

<div id="list-TipoLista" role="main" style="margin-top: 10px;">

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr style="width: 100%">
            <th style="width: 15%">Código</th>
            <th style="width: 60%">Descripción</th>
            <th style="width: 15%">Unidad</th>
            <th style="width: 10%">Acciones</th>
        </tr>
        </thead>
        <tbody class="paginate">
        <g:each in="${tipoListaInstanceList}" status="i" var="tipoListaInstance">
            <tr>
                <td>${fieldValue(bean: tipoListaInstance, field: "codigo")}</td>
                <td>${fieldValue(bean: tipoListaInstance, field: "descripcion")}</td>
                <td style="text-align: center">${tipoListaInstance?.unidad == "no" ? ' -- Sin unidad --' : tipoListaInstance?.unidad }</td>
                <td>
                    <a class="btn btn-success btn-xs btn-edit" href="#"  title="Editar" data-id="${tipoListaInstance.id}">
                        <i class="fa fa-edit"></i>
                    </a>
                    <a class="btn btn-danger btn-xs btn-delete" href="#" title="Eliminar" data-id="${tipoListaInstance.id}">
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
                    title   : title + " Tipo de Lista",
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
                                return submitFormTL();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormTL() {
        var $form = $("#frmSave-TipoLista");
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
