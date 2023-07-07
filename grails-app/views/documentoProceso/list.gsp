<%@ page import="janus.pac.DocumentoProceso" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Documentos
    </title>
</head>

<body>

<div class="tituloTree">
    <g:if test="${contrato}">
        Documentos del contrato de la obra: <span style="font-weight: bold;">${contrato.obra.descripcion?.toUpperCase()}</span>
    </g:if>
    <g:else>
        Documentos de: <span style="font-weight: bold; font-style: italic; font-size: 12px">${concurso.objeto}</span>
    </g:else>
</div>

<g:if test="${flash.message}">
    <div class="row">
        <div class="span12">
            <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                <a class="close" data-dismiss="alert" href="#">×</a>
                ${flash.message}
            </div>
        </div>
    </div>
</g:if>

<div class="row" style="margin-bottom: 10px">
    <div class="span9 btn-group" role="navigation">
        <g:if test="${contrato}">
            <g:if test="${params.show == '1'}">
                <g:link controller="contrato" action="registroContrato" class="btn btn-info" params="[contrato: contrato.id]">
                    <i class="fa fa-arrow-left"></i>
                    Regresar
                </g:link>
            </g:if>
            <g:else>
                <g:link controller="contrato" action="verContrato" class="btn btn-info" params="[contrato: contrato?.id]">
                    <i class="fa fa-arrow-left"></i>
                    Regresar
                </g:link>
            </g:else>
        </g:if>
        <g:else>
            <g:link controller="concurso" action="list" class="btn btn-info">
                <i class="fa fa-arrow-left"></i>
                Regresar
            </g:link>
        </g:else>
        <a href="#" class="btn btn-success btn-new">
            <i class="fa fa-file"></i>
            Nuevo Documento
        </a>
        <a href="#" class="btn btn-success btn-copy">
            <i class="fa fa-copy"></i>
            Copiar documentos de la obra
        </a>

        <a href="#" class="btn btn-ajax btn-info" id="docRespaldo">
            <i class="fa fa-file"></i>
            Respaldo para Obras Adicionales
        </a> <a href="#" class="btn btn-ajax btn-info" id="docCmasS">
        <i class="fa fa-file-archive"></i>
        Respaldo para Costo + %
    </a>
    </div>

    <div class="span3" id="busca">
    </div>
</div>

%{--<g:form action="delete" name="frmDelete-DocumentoProceso">--}%
%{--    <g:hiddenField name="id"/>--}%
%{--    <g:hiddenField name="contrato" value="${contrato?.id}"/>--}%
%{--    <g:hiddenField name="show" value="${params.show}"/>--}%
%{--</g:form>--}%

<div id="list-DocumentoProceso" role="main">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr style="width: 100%">
            <th style="width: 10%">Etapa</th>
            <th style="width: 25%">Nombre</th>
            <th style="width: 20%">Descripción</th>
            <th style="width: 15%">Resumen</th>
            <th style="width: 10%">Archivo</th>
            <th style="width: 10%">Tipo de archivo</th>
            <th style="width:10%">Acciones</th>
        </tr>
        </thead>
        <tbody >
        <g:each in="${documentoProcesoInstanceList}" status="i" var="documentoProcesoInstance">
            <tr style="width: 100%">
                <td style="width: 10%">${documentoProcesoInstance?.etapa?.descripcion}</td>
                <td style="width: 25%">${fieldValue(bean: documentoProcesoInstance, field: "nombre")}</td>
                <td style="width: 20%">${fieldValue(bean: documentoProcesoInstance, field: "descripcion")}</td>
                <td style="width: 15%">${fieldValue(bean: documentoProcesoInstance, field: "resumen")}</td>
                <td style="width: 10%">${fieldValue(bean: documentoProcesoInstance, field: "path")}</td>
                <td style="width: 10%">
                    <g:set var="p" value="${documentoProcesoInstance.path.split("\\.")}"/>
                    ${p[p.size() - 1]}
                </td>
                <td style="width:10%">
                    <a class="btn btn-success btn-xs btn-edit btn-ajax" href="#" rel="tooltip" title="Editar" data-id="${documentoProcesoInstance.id}">
                        <i class="fa fa-edit"></i>
                    </a>
                    <g:link action="downloadFile" class="btn btn-info btn-xs btn-docs" rel="tooltip" title="Descargar" id="${documentoProcesoInstance.id}">
                        <i class="fa fa-download"></i>
                    </g:link>
                    <a class="btn btn-danger btn-xs btn-delete" href="#" rel="tooltip" title="Eliminar" data-id="${documentoProcesoInstance.id}">
                        <i class="fa fa-trash"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<div class="modal hide fade" id="modal-DocumentoProceso">
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

<script type="text/javascript">

    $(function () {

        $(".btn-new").click(function () {
            createEditRow();
        }); //click btn new

        $("#docRespaldo").click(function () {
            createEditRow(null, 'R');
        }); //click btn new

        $("#docCmasS").click(function () {
            createEditRow(null, 'C');
        }); //click btn new

        $(".btn-edit").click(function () {
            var id = $(this).data("id");
            createEditRow(id);
        }); //click btn edit

        %{--$(".btn-show").click(function () {--}%
        %{--    var id = $(this).data("id");--}%
        %{--    $.ajax({--}%
        %{--        type    : "POST",--}%
        %{--        url     : "${createLink(action:'show_ajax')}",--}%
        %{--        data    : {--}%
        %{--            id : id--}%
        %{--        },--}%
        %{--        success : function (msg) {--}%
        %{--            var btnOk = $('<a href="#" data-dismiss="modal" class="btn btn-primary">Aceptar</a>');--}%
        %{--            $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-show");--}%
        %{--            $("#modalTitle").html("Ver Documento");--}%
        %{--            $("#modalBody").html(msg);--}%
        %{--            $("#modalFooter").html("").append(btnOk);--}%
        %{--            $("#modal-DocumentoProceso").modal("show");--}%
        %{--        }--}%
        %{--    });--}%
        %{--    return false;--}%
        %{--}); //click btn show--}%

        $(".btn-copy").click(function () {
            $(this).replaceWith(spinner);
            var id = $(this).data("id");
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'copiarDocumentos')}",
                data    : {
                    id : "${concurso.id}",
                    contrato : "${contrato?.id}"
                },
                success : function (msg) {
                    location.reload();
                }
            });
            return false;
        }); //click btn show

        $(".btn-delete").click(function () {
            var id = $(this).data("id");
            deleteRow(id)
            // $("#id").val(id);
            // var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
            // var btnDelete = $('<a href="#" class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');
            //
            // btnDelete.click(function () {
            //     btnDelete.replaceWith(spinner);
            //     $("#frmDelete-DocumentoProceso").submit();
            //     return false;
            // });
            //
            // $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-delete");
            // $("#modalTitle").html("Eliminar Documento de la Biblioteca");
            // $("#modalBody").html("<p>¿Está seguro de querer eliminar este Documento Proceso?</p>");
            // $("#modalFooter").html("").append(btnOk).append(btnDelete);
            // $("#modal-DocumentoProceso").modal("show");
            // return false;
        });

    });

    function createEditRow(id, respaldo) {
        var title = id ? "Editar " : "Crear ";
         var data = {
            concurso : "${concurso.id}",
            contrato : "${contrato?.id}",
            show     : "${params.show}",
            id: id,
            docuResp: respaldo
        };

        $.ajax({
            type    : "POST",
            url: "${createLink(action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Documento",
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
                                var $form = $("#frmSave-DocumentoProceso");
                                if ($form.valid()) {
                                    $form.submit()
                                }else{
                                    return false;
                                }
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

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

</script>

</body>
</html>
