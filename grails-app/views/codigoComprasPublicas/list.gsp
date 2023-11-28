
<%@ page import="janus.pac.CodigoComprasPublicas" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Lista de Codigo Compras Publicass
        </title>
    </head>
    <body>

        <div class="span12 btn-group" role="navigation">
            <a href="#" class="btn btn-success btn-new">
                <i class="fa fa-file"></i>
                Nuevo Código Compras Publicas
            </a>
        </div>


    <div id="listaRbro" style="overflow: hidden; margin-top: 10px">
        <fieldset class="borde" style="border-radius: 4px">
            <div class="row-fluid" style="margin-left: 10px">
                <span class="grupo">
                    <label class="col-md-1 control-label text-info">
                        Buscar Por
                    </label>
                    <span class="col-md-2">
                        <g:select name="buscarPor" class="buscarPor col-md-12 form-control" from="${[1: 'Descripción', 2: 'Código']}" optionKey="key"
                                  optionValue="value"/>
                    </span>
                    <label class="col-md-1 control-label text-info">
                        Criterio
                    </label>
                    <span class="col-md-4">
                        <g:textField name="buscarCriterio" id="criterioCriterio" class="form-control"/>
                    </span>
                </span>
                <div class="col-md-1" style="margin-top: 1px">
                    <button class="btn btn-info" id="btnBuscarCPC"><i class="fa fa-search"></i></button>
                </div>
            </div>
        </fieldset>

        <fieldset class="borde" style="border-radius: 4px">
            <div id="divTablaCPC" style="height: 460px; overflow: auto; margin-top: 5px">
            </div>
        </fieldset>
    </div>

        <script type="text/javascript">
            buscarCPC();

            $("#btnBuscarCPC").click(function () {
                buscarCPC();
            });

            function buscarCPC() {
                var buscarPor = $("#buscarPor option:selected").val();
                var criterio = $("#criterioCriterio").val();
                $.ajax({
                    type: "POST",
                    url: "${createLink(controller: 'codigoComprasPublicas', action:'tablaCPC_ajax')}",
                    data: {
                        buscarPor: buscarPor,
                        criterio: criterio,
                        tipo: '${tipo}'
                    },
                    success: function (msg) {
                        $("#divTablaCPC").html(msg);
                    }
                });
            }

            $("#criterioCriterio").keydown(function (ev) {
                if (ev.keyCode === 13) {
                    ev.preventDefault();
                    buscarCPC();
                    return false;
                }
            });

            function createEditRowCPC(id) {
                var title = id ? "Editar " : "Crear ";
                var data = id ? {id : id} : {};

                $.ajax({
                    type    : "POST",
                    url: "${createLink(action:'form_ajax')}",
                    data    : data,
                    success : function (msg) {
                        var b = bootbox.dialog({
                            id      : "dlgCreateEdit",
                            title   : title + " CPC",
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
                                        return submitFormCPC();
                                    } //callback
                                } //guardar
                            } //buttons
                        }); //dialog
                    } //success
                }); //ajax
            } //createEdit

            function submitFormCPC() {
                var $form = $("#frmSave-CodigoComprasPublicas");
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
                                buscarCPC();
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

            $(".btn-new").click(function () {
                createEditRowCPC();
            }); //click btn new

            function deleteRowCPC(itemId) {
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
                                            buscarCPC();
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

        </script>

    </body>
</html>
