
<%@ page import="janus.pac.Proveedor" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Proveedores
    </title>
</head>
<body>

<div class="row">
    <div class="span9 btn-group" role="navigation">
        <g:link controller="concurso" action="list" class="btn btn-primary">
            <i class="fa fa-arrow-left"></i>
            Ir a Concurso
        </g:link>
        <a href="#" class="btn btn-success btn-new">
            <i class="fa fa-file"></i>
            Nuevo  Proveedor
        </a>
    </div>
</div>

<div id="list-Proveedor" role="main" style="margin-top: 10px;">

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 10%">Especialidad</th>
            <th style="width: 10%">Tipo</th>
            <th style="width: 10%">Ruc</th>
            <th style="width: 25%">Nombre</th>
            <th style="width: 35%">Contacto</th>
            <th style="width: 10%">Acciones</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-striped table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:each in="${proveedorInstanceList}" status="i" var="proveedorInstance">
            <tr>
                <td style="width: 10%">${proveedorInstance?.especialidad?.descripcion}</td>
                <td style="width: 10%">${(proveedorInstance.tipo=="N")?"Natural": (proveedorInstance.tipo=="J")? "Jurídica":"Empresa Pública"}</td>
                <td style="width: 10%">${fieldValue(bean: proveedorInstance, field: "ruc")}</td>
                <td style="width: 25%">${fieldValue(bean: proveedorInstance, field: "nombre")}</td>
                <td style="width: 35%">${proveedorInstance?.nombreContacto + " " + proveedorInstance?.apellidoContacto}</td>
                <td style="width: 10%">
                    <a class="btn btn-xs btn-show btn-info" href="#" rel="tooltip" title="Ver" data-id="${proveedorInstance.id}">
                        <i class="fa fa-search"></i>
                    </a>
                    <a class="btn btn-xs btn-edit btn-success" href="#" rel="tooltip" title="Editar" data-id="${proveedorInstance.id}">
                        <i class="fa fa-edit"></i>
                    </a>

                    <a class="btn btn-xs btn-delete btn-danger" href="#" rel="tooltip" title="Eliminar" data-id="${proveedorInstance.id}">
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
        var data = id ? {id : id}: {};

        $.ajax({
            type    : "POST",
            url: "${createLink(action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Proveedor",
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
                                return submitFormProveedor();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormProveedor() {
        var $form = $("#frmSave-Proveedor");
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

    function deleteRow(itemId) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><p style='font-weight: bold'> Está seguro que desea eliminar este proveedor? Esta acción no se puede deshacer.</p>",
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


    $(function () {

        $(".btn-new").click(function () {
            createEditRow();
        }); //click btn new

        $(".btn-edit").click(function () {
            var id = $(this).data("id");
            createEditRow(id);
        }); //click btn edit

        $(".btn-show").click(function () {
            var id = $(this).data("id");
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'show_ajax')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    var b = bootbox.dialog({
                        id      : "dlgShow",
                        title   : "Ver Proveedor",
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
                }
            });
        }); //click btn show

        $(".btn-delete").click(function () {
            var id = $(this).data("id");
            deleteRow(id);
        });

    });

</script>

</body>
</html>
