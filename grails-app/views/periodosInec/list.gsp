
<%@ page import="janus.ejecucion.PeriodosInec" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Periodos de Índices
    </title>
</head>
<body>

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

<div class="col-md-12" style="margin-bottom: 10px">
    <div class="btn-group" role="navigation">
        <a href="#" class="btn btn-success btn-new">
            <i class="fa fa-file"></i>
            Crear Período de Índices
        </a>
    </div>
</div>


<div id="list-PeriodosInec" role="main" style="margin-top: 10px;">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th>Descripción</th>
            <th>Fecha Inicio</th>
            <th>Fecha Fin</th>
            <th>Período Cerrado</th>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${periodosInecInstanceList}" status="i" var="periodosInecInstance">
            <tr>
                <td>${fieldValue(bean: periodosInecInstance, field: "descripcion")}</td>
                <td><g:formatDate date="${periodosInecInstance.fechaInicio}" format="dd-MM-yyyy" /></td>
                <td><g:formatDate date="${periodosInecInstance.fechaFin}" format="dd-MM-yyyy"/></td>
                <td style="text-align: center">${periodosInecInstance?.periodoCerrado == 'N' ? 'NO' : 'SI'}</td>
                <td style="text-align: center">
                    <a class="btn btn-xs btn-show btn-info" href="#" rel="tooltip" title="Ver" data-id="${periodosInecInstance.id}">
                        <i class="fa fa-search"></i>
                    </a>
                    <a class="btn btn-xs btn-edit btn-success" href="#" rel="tooltip" title="Editar" data-id="${periodosInecInstance.id}">
                        <i class="fa fa-edit"></i>
                    </a>
                    <a class="btn btn-xs btn-delete btn-danger" href="#" rel="tooltip" title="Eliminar" data-id="${periodosInecInstance.id}">
                        <i class="fa fa-trash"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<elm:pagination total="${periodosInecInstanceTotal}" params="${params}" />

<div class="modal hide fade" id="modal-PeriodosInec">
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
            %{--$.ajax({--}%
            %{--    type    : "POST",--}%
            %{--    url     : "${createLink(action:'form_ajax')}",--}%
            %{--    success : function (msg) {--}%
            %{--        var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');--}%
            %{--        var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');--}%

            %{--        btnSave.click(function () {--}%
            %{--            submitForm(btnSave);--}%
            %{--            return false;--}%
            %{--        });--}%

            %{--        $("#modalHeader").removeClass("btn-edit btn-show btn-delete");--}%
            %{--        $("#modalTitle").html("Crear Periodos de Índices");--}%
            %{--        $("#modalBody").html(msg);--}%
            %{--        $("#modalFooter").html("").append(btnOk).append(btnSave);--}%
            %{--        $("#modal-PeriodosInec").modal("show");--}%
            %{--    }--}%
            %{--});--}%
            // return false;
        }); //click btn new

        $(".btn-edit").click(function () {
            var id = $(this).data("id");
            createEditRow(id);
            %{--$.ajax({--}%
            %{--    type    : "POST",--}%
            %{--    url     : "${createLink(action:'form_ajax')}",--}%
            %{--    data    : {--}%
            %{--        id : id--}%
            %{--    },--}%
            %{--    success : function (msg) {--}%
            %{--        var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');--}%
            %{--        var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');--}%

            %{--        btnSave.click(function () {--}%
            %{--            submitForm(btnSave);--}%
            %{--            return false;--}%
            %{--        });--}%

            %{--        $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-edit");--}%
            %{--        $("#modalTitle").html("Editar Periodos de Índices");--}%
            %{--        $("#modalBody").html(msg);--}%
            %{--        $("#modalFooter").html("").append(btnOk).append(btnSave);--}%
            %{--        $("#modal-PeriodosInec").modal("show");--}%
            %{--    }--}%
            %{--});--}%
            %{--return false;--}%
        }); //click btn edit


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
                        title   : title + " Período",
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
                                    return submitFormPeriodo();
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                } //success
            }); //ajax
        } //createEdit


        function submitFormPeriodo() {
            var $form = $("#frmSave-PeriodosInec");
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
                    $("#modalTitle").html("Ver Periodos de Índices");
                    $("#modalBody").html(msg);
                    $("#modalFooter").html("").append(btnOk);
                    $("#modal-PeriodosInec").modal("show");
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
                $("#frmDelete-PeriodosInec").submit();
                return false;
            });

            $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-delete");
            $("#modalTitle").html("Eliminar Periodos Inec");
            $("#modalBody").html("<p>¿Está seguro de querer eliminar este Periodos Inec?</p>");
            $("#modalFooter").html("").append(btnOk).append(btnDelete);
            $("#modal-PeriodosInec").modal("show");
            return false;
        });

    });

</script>

</body>
</html>
