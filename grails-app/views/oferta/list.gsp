<%@ page import="janus.pac.Oferta" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Lista de Ofertas
        </title>
    </head>

    <body>

        <div class="alert alert-info">
            Ofertas de <span style="font-weight: bold; font-style: italic;">${concurso.objeto}</span>
        </div>

        <div class="row">
            <div class="span9 btn-group" role="navigation">
                <g:link controller="concurso" action="list" class="btn btn-primary">
                    <i class="fa fa-arrow-left"></i>
                    Regresar
                </g:link>
                <a href="#" class="btn btn-success btn-new">
                    <i class="fa fa-file"></i>
                    Crear  Oferta
                </a>
                <g:link controller="proveedor" action="list" class="btn btn-info">
                    <i class="fa fa-users"></i>
                    Proveedores
                </g:link>
            </div>

            <div class="span3" id="busca">
            </div>
        </div>

        <g:form action="delete" name="frmDelete-Oferta">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-Oferta" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                        <th>Proveedor</th>
                        <th>Descripcion</th>
                        <th>Monto</th>
                        <th>Fecha Entrega</th>
                        <th>Plazo</th>
                        <th width="120">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${ofertaInstanceList}" status="i" var="ofertaInstance">
                        <tr>
                            <td>${ofertaInstance?.proveedor?.nombre}</td>
                            <td>${fieldValue(bean: ofertaInstance, field: "descripcion")}</td>
                            <td>${fieldValue(bean: ofertaInstance, field: "monto")}</td>
                            <td><g:formatDate date="${ofertaInstance.fechaEntrega}" format="dd-MM-yyyy"/></td>
                            <td>${fieldValue(bean: ofertaInstance, field: "plazo")}</td>
                            <td>
                                <a class="btn btn-xs btn-show btn-info" href="#" rel="tooltip" title="Ver" data-id="${ofertaInstance.id}">
                                    <i class="fa fa-search"></i>
                                </a>
                                <a class="btn btn-xs btn-edit btn-success" href="#" rel="tooltip" title="Editar" data-id="${ofertaInstance.id}">
                                    <i class="fa fa-edit"></i>
                                </a>
                                <a class="btn btn-xs btn-delete btn-danger" href="#" rel="tooltip" title="Eliminar" data-id="${ofertaInstance.id}">
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
                var data = id ? {id : id, concurso: ${concurso?.id} }: {concurso: ${concurso?.id}};

                $.ajax({
                    type    : "POST",
                    url: "${createLink(action:'form_ajax')}",
                    data    : data,
                    success : function (msg) {
                        var b = bootbox.dialog({
                            id      : "dlgCreateEdit",
                            title   : title + " Oferta",
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
                                        return submitFormTipoOferta();
                                    } //callback
                                } //guardar
                            } //buttons
                        }); //dialog
                    } //success
                }); //ajax
            } //createEdit

            function submitFormTipoOferta() {
                var $form = $("#frmSave-Oferta");
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
                    message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><p style='font-weight: bold'> Está seguro que desea eliminar esta oferta? Esta acción no se puede deshacer.</p>",
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
                                title   : "Ver Oferta",
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
