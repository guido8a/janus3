<%@ page import="janus.pac.Concurso" %>
<%
    def buscadorServ = grailsApplication.classLoader.loadClass('utilitarios.BuscadorService').newInstance()
%>

<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Procesos
    </title>

    <style>
    td {
        line-height : 12px !important;
    }
    </style>
</head>

<body>

<g:if test="${flash.message}">
    <div class="span12">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
            <a class="close" data-dismiss="alert" href="#">×</a>
            <elm:poneHtml textoHtml="${flash.message}"/>
        </div>
    </div>
</g:if>

<div class="row" style="margin-bottom: 10px;">

    <div class="row-fluid">
        <div style="margin-left: 20px;">

            <div class="col-md-8">
                <div class="row-fluid col-md-2">
                    <b>Buscar por: </b>
                </div>
                <div class="row-fluid col-md-2">
                    <elm:select name="buscador" from = "${buscadorServ.parmProcesos()}" value="${params.buscador}"
                                optionKey="campo" optionValue="nombre" optionClass="operador" id="buscador_con"
                                style="margin-left: -50px; width: 130px" class="form-control"/>
                </div>
                <div class="col-md-1">
                    <b style="margin-left: 10px">Criterio: </b>
                </div>
                <div class="col-md-3">
                    <g:textField name="criterio" style="width: 180px" value="${params.criterio}"
                                 id="criterio_con" class="form-control"/>
                </div>

                <div class="col-md-3">

                    <a href="#" name="busqueda" class="btn btn-info" id="btnBusqueda" title="Buscar"
                       style="height: 34px; padding: 9px; width: 46px; margin-left: 10px">
                        <i class="fa fa-search"></i></a>

                    <a href="#" name="limpiarBus" class="btn btn-warning" id="btnLimpiarBusqueda"
                       title="Borrar criterios" style="height: 34px; padding: 9px; width: 34px">
                        <i class="fa fa-eraser"></i></a>
                </div>

            </div>

            <div class="col-md-4 btn-group" role="navigation">
                <a href="#" class="btn btn-success " id="btnPac">
                    <i class="fa fa-file"></i>
                    Nuevo Proceso
                </a>
            </div>

        </div>

    </div>
</div>
<div class="alert alert-info">
    <p> * Haga clic con el botón derecho del ratón sobre el concurso para acceder al menú de acciones.</p>
    <p> * Recuerde que el formato del código del proceso es: MCO-<strong>número</strong>-GADLR-20</p>
</div>

<g:form action="delete" name="frmDelete-Concurso">
    <g:hiddenField name="id"/>
</g:form>

<div id="tabla" role="main">
</div>


<div class="modal hide fade" id="modal-Delete">
    <div class="modal-header" id="modalDeleteHeader">
        <button type="button" class="close darker" data-dismiss="modal">
            <i class="icon-remove-circle"></i>
        </button>

        <h3 id="modalDeleteTitle"></h3>
    </div>

    <div class="modal-body" id="modalDeleteBody">
    </div>

    <div class="modal-footer" id="modalDeleteFooter">
    </div>
</div>

<div class="modal grande2 hide fade" id="modal-Concurso">
    <div class="modal-header" id="modalHeader">
        <button type="button" class="close darker" data-dismiss="modal">
            <i class="icon-remove-circle"></i>
        </button>

        <h3 id="modalTitle"></h3>
    </div>

    <div class="modal-body" id="modalBody">
    </div>

    <div class="modal-footer" id="modalFooter">
    </div>
</div>

<div id="modal-pac" style="overflow: hidden;">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 20px">
            <div class="col-md-3">
                Buscar por
                <g:select name="buscarPor" class="buscarPor col-md-12" from="${listaBuscar}" optionKey="key"
                          optionValue="value"/>
            </div>

            <div class="col-md-3">Criterio
            <g:textField name="buscarCriterio" id="criterioCriterio" style="width: 80%"/>
            </div>

            <div class="col-md-3">Ordenado por
            <g:select name="ordenar" class="ordenar" from="${listaBuscar}" style="width: 100%" optionKey="key"
                      optionValue="value"/>
            </div>
            <div class="col-md-2" style="margin-top: 6px">
                <button class="btn btn-info" id="cnsl-pac"><i class="fa fa-search"></i> Consultar</button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaPac" style="height: 460px; overflow: auto">
        </div>
    </fieldset>
</div>

<script type="text/javascript">
    var url = "${resource(dir:'images', file:'spinner_24.gif')}";
    var spinner = $("<img style='margin-left:15px;' src='" + url + "' alt='Cargando...'/>");

    function submitForm(btn) {
        if ($("#frmSave-Concurso").valid()) {
            btn.replaceWith(spinner);
        }
        $("#frmSave-Concurso").submit();
    }

    // $(function () {

        $("#criterio_con").keydown(function (ev) {
            if (ev.keyCode === 13) {
                ev.preventDefault();
                cargarBusqueda();
                return false;
            }
        });

        $("#modal-pac").dialog({
            autoOpen: false,
            resizable: true,
            modal: true,
            draggable: false,
            width: 800,
            height: 400,
            position: 'center',
            title: 'Seleccionar PAC',
            buttons   : {
                "Cerrar": function () {
                    $("#modal-pac").dialog("close");
                }
            }
        });

        $("#btnPac").click(function () {
            $("#modal-pac").dialog("open");
            $(".ui-dialog-titlebar-close").html("x");
        });

        $(".btn-new").click(function () {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'form_ajax')}",
                success : function (msg) {
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                    btnSave.click(function () {
                        submitForm(btnSave);
                        return false;
                    });

                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete");
                    $("#modalTitle").html("Crear Proceso");
                    $("#modalBody").html(msg);
                    $("#modalFooter").html("").append(btnOk).append(btnSave);
                    $("#modal-Concurso").modal("show");
                }
            });
            return false;
        }); //click btn new

        $(".btn-edit").click(function () {
            var id = $(this).data("id");
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'form_ajax')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                    btnSave.click(function () {
                        submitForm(btnSave);
                        return false;
                    });

                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-edit");
                    $("#modalTitle").html("Editar Proceso");
                    $("#modalBody").html(msg);
                    $("#modalFooter").html("").append(btnOk).append(btnSave);
                    $("#modal-Concurso").modal("show");
                }
            });
            return false;
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
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn btn-primary">Aceptar</a>');
                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-show");
                    $("#modalTitle").html("Ver Proceso");
                    $("#modalBody").html(msg);
                    $("#modalFooter").html("").append(btnOk);
                    $("#modal-Concurso").modal("show");
                }
            });
            return false;
        }); //click btn show

        $(".btn-delete").click(function () {
            var id = $(this).data("id");
            $("#id").val(id);
            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
            var btnDelete = $('<a href="#" class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');

            btnDelete.click(function () {
                btnDelete.replaceWith(spinner);
                $("#frmDelete-Concurso").submit();
                return false;
            });

            $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-delete");
            $("#modalTitle").html("Eliminar Proceso");
            $("#modalBody").html("<p>¿Está seguro de querer eliminar este Proceso?</p>");
            $("#modalFooter").html("").append(btnOk).append(btnDelete);
            $("#modal-Concurso").modal("show");
            return false;
        });

        $(function () {
            $("#limpiaBuscar").click(function () {
                $("#buscar").val('');
                cargarBusqueda();
            });
        });

        cargarBusqueda();

        function cargarBusqueda () {
            $("#bandeja").html("").append($("<div style='width:100%; text-align: center;'/>").append(spinner));
            var desde = $(".fechaD").val();
            var hasta = $(".fechaH").val();
            $.ajax({
                type: "POST",
                url: "${g.createLink(controller: 'concurso', action: 'tablaConcursos')}",
                data: {
                    buscador: $("#buscador_con").val(),
                    criterio: $("#criterio_con").val(),
                    operador: $("#oprd").val(),
                    desde: desde,
                    hasta: hasta,
                    tpps: $("#tipo_proceso").val()
                },
                success: function (msg) {
                    $("#tabla").html(msg);
                },
                error: function (msg) {
                    $("#tabla").html("Ha ocurrido un error");
                }
            });

        }

        $("#btnLimpiarBusqueda").click(function () {
            $(".fechaD, .fechaH, #criterio_con").val('');
        });

        $("#btnBusqueda").click(function () {
            cargarBusqueda();
        });

        $("#cnsl-pac").click(function () {
            var buscarPor = $("#buscarPor").val();
            var criterio = $("#criterioCriterio").val();
            var ordenar = $("#ordenar").val();
            $.ajax({
                type: "POST",
                url: "${createLink(controller: 'concurso', action:'listaPac')}",
                data: {
                    buscarPor: buscarPor,
                    criterio: criterio,
                    ordenar: ordenar
                },
                success: function (msg) {
                    $("#divTablaPac").html(msg);
                }
            });
        });

    // });

    function deleteRow(itemId) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><p style='font-weight: bold'> Está seguro que desea eliminar este concurso? Esta acción no se puede deshacer.</p>",
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
                                    cargarBusqueda();
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