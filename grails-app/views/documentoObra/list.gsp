<%@ page import="janus.pac.DocumentoProceso" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Biblioteca de la Obra
    </title>
</head>

<body>

<div class="tituloTree">
    Documentos de la obra: <strong> <span style="font-weight: bold; font-style: italic;">${obra.descripcion}</span></strong>
</div>

<g:if test="${flash.message}">
    <div class="row">
        <div class="col-md-12">
            <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                <a class="close" data-dismiss="alert" href="#">×</a>
                 <elm:poneHtml textoHtml="${flash.message}"/>
            </div>
        </div>
    </div>
</g:if>

<div class="row">
    <div class="col-md-9 btn-group" role="navigation" style="margin-bottom: 10px">
        <a href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra?.id])}"
           class="btn btn-info" id="atras" title="Regresar a la obra">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
        <a href="#" class="btn btn-success btn-new">
            <i class="fa fa-file"></i>
            Nuevo Documento
        </a>
    </div>

    <div class="col-md-3" id="busca">
    </div>
</div>

<g:form action="delete" name="frmDelete-DocumentoObra">
    <g:hiddenField name="id"/>
    <g:hiddenField name="obra_id"/>
</g:form>

<div id="list-DocumentoObra" role="main">

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <g:sortableColumn property="nombre" title="Nombre"/>
            <g:sortableColumn property="descripcion" title="Descripcion"/>
            <g:sortableColumn property="resumen" title="Resumen"/>
            <g:sortableColumn property="palabrasClave" title="Palabras Clave"/>
            <th>Tipo de archivo</th>
            <th width="150">Acciones</th>
        </tr>
        </thead>
        <tbody class="paginate">
        <g:each in="${documentoObraInstanceList}" status="i" var="documentoObraInstance">
            %{--<g:set var="documentoObraInstance" value="${documentoObraInstance.refresh()}"/>--}%
            <tr>
                <td>
                    ${fieldValue(bean: documentoObraInstance, field: "nombre")}
                    <g:if test="${!documentoObraInstance.path || documentoObraInstance.path.trim()==''}">
                        <div class="alert alert-danger">
                            Por favor vuelva a cargar el archivo
                        </div>
                    </g:if>
                </td>
                <td>${fieldValue(bean: documentoObraInstance, field: "descripcion")}</td>
                <td>${fieldValue(bean: documentoObraInstance, field: "resumen")}</td>
                <td>${fieldValue(bean: documentoObraInstance, field: "palabrasClave")}</td>
                <td>
                    <g:if test="${documentoObraInstance.path}">
                        <g:set var="p" value="${documentoObraInstance.path?.split("\\.")}"/>
                        ${p[p.size() - 1]}
                    </g:if>
                </td>
                <td>
                    <a class="btn btn-xs btn-show btn-ajax" href="#" rel="tooltip" title="Ver" data-id="${documentoObraInstance.id}">
                        <i class="fa fa-search"></i>
                    </a>
                    <a class="btn btn-xs btn-edit btn-ajax" href="#" rel="tooltip" title="Editar" data-id="${documentoObraInstance.id}">
                        <i class="fa fa-edit"></i>
                    </a>
                    <g:link action="downloadFile" class="btn btn-xs btn-docs" rel="tooltip" title="Descargar" id="${documentoObraInstance.id}">
                        <i class="fa fa-download"></i>
                    </g:link>
                    <a class="btn btn-xs btn-delete" href="#" rel="tooltip" title="Eliminar" data-id="${documentoObraInstance.id}">
                        <i class="fa fa-trash"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>

</div>

<div id="modal-DocumentoProceso">
    <div id="modalBody">
    </div>

    <div id="modalFooter" style="margin-top: 20px; text-align: right; width: 340px">
    </div>
</div>

<script type="text/javascript">
    var url = "${resource(dir:'images', file:'spinner_24.gif')}";
    var spinner = $("<img style='margin-left:15px;' src='" + url + "' alt='Cargando...'/>");

    function submitForm(btn) {
        if ($("#frmSave-DocumentoObra").valid()) {
            btn.replaceWith(spinner);
        }
        $("#frmSave-DocumentoObra").submit();
    }

    $(function () {
        $('[rel=tooltip]').tooltip();

        $("#modal-DocumentoProceso").dialog({
            autoOpen: false,
            resizable: false,
            modal: true,
            draggable: false,
            width: 460,
            height: 360,
            position: 'center',
            title: 'Documentos'
        });

        $(".btn-new").click(function () {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'form_ajax')}",
                data    : {
                    obra : ${obra.id}
                },
                success : function (msg) {
                    var btnCancel = $('<a href="#" class="btn btn-info"><i class="fa fa-times"></i> Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success"><i class="fa fa-save"></i> Guardar</a>');

                    btnCancel.click(function () {
                        $("#modal-DocumentoProceso").dialog("close");
                    });
                    btnSave.click(function () {
                        submitForm(btnSave);
                        return false;
                    });

                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete");
                    $("#modalTitle").html("Crear Documento");
                    $("#modalBody").html(msg);
                    $("#modalFooter").html("").append(btnCancel).append(btnSave);
                    $("#modal-DocumentoProceso").dialog("open");
                    $(".ui-dialog-titlebar-close").html("x")
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
                    id       : id,
                    obra : ${obra.id}
                },
                success : function (msg) {
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                    btnSave.click(function () {
                        submitForm(btnSave);
                        return false;
                    });

                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-edit");
                    $("#modalTitle").html("Editar Documento");
                    $("#modalBody").html(msg);
                    $("#modalFooter").html("").append(btnOk).append(btnSave);
                    $("#modal-DocumentoProceso").dialog("open");
                    $(".ui-dialog-titlebar-close").html("x")
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
                    $("#modalTitle").html("Ver Documento");
                    $("#modalBody").html(msg);
                    $("#modalFooter").html("").append(btnOk);
                    $("#modal-DocumentoProceso").dialog("open");
                    $(".ui-dialog-titlebar-close").html("x")
                }
            });
            return false;
        }); //click btn show

        $(".btn-delete").click(function () {
            var id = $(this).data("id");
            var obraId = "${obra?.id}";
            $("#id").val(id);
            $("#obra_id").val(obraId);
            var btnOk = $('<a href="#" data-dismiss="modal" class="btn btn-info"><i class="fa fa-times"></i> Cancelar</a>');
            var btnDelete = $('<a href="#" class="btn btn-danger"><i class="fa fa-trash"></i> Eliminar</a>');

            btnDelete.click(function () {
                btnDelete.replaceWith(spinner);
                $("#frmDelete-DocumentoObra").submit();
                return false;
            });

            $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-delete");
            $("#modalTitle").html("Eliminar Documento Obra");
            $("#modalBody").html("<p>¿Está seguro de querer eliminar este Documento Obra?</p>");
            $("#modalFooter").html("").append(btnOk).append(btnDelete);
            $("#modal-DocumentoProceso").dialog("open");
            $(".ui-dialog-titlebar-close").html("x");
            return false;
        });

    });

</script>

</body>
</html>
