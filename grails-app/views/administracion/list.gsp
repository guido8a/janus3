<%@ page import="janus.Administracion" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Administraciones
    </title>
</head>
<body>

<div class="span12 btn-group" role="navigation">
    <a href="#" class="btn btn-info btn-ajax btn-new">
        <i class="fa fa-file"></i>
        Nueva Administración
    </a>
</div>

<g:form action="delete" name="frmDelete-administracionInstance">
    <g:hiddenField name="id"/>
</g:form>

<div id="list-administracion" class="span12" role="main" style="margin-top: 10px;">

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th>Nombre Prefecto</th>
            <th>Descripción</th>
            <th>Fecha Inicio</th>
            <th>Fecha Fin</th>
            <th style="width: 100px">Acciones</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${administracionInstanceList}" status="i" var="administracionInstance">
            <tr>
                <td>${administracionInstance?.nombrePrefecto}</td>
                <td>${administracionInstance?.descripcion}</td>
                <td><g:formatDate date="${administracionInstance.fechaInicio}" format="dd-MM-yyyy"/></td>
                <td><g:formatDate date="${administracionInstance.fechaFin}" format="dd-MM-yyyy"/></td>
                <td>
                    <a class="btn btn-info btn-xs btn-show" href="#"  title="Ver" data-id="${administracionInstance.id}">
                        <i class="fa fa-clipboard"></i>
                    </a>
                    <a class="btn btn-success btn-xs btn-edit" href="#"  title="Editar" data-id="${administracionInstance.id}">
                        <i class="fa fa-edit"></i>
                    </a>

                    <a class="btn btn-danger btn-xs btn-delete" href="#" title="Eliminar" data-id="${administracionInstance.id}">
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
                    title   : title + " Prefecto",
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
                                return submitFormAdministracion();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").not(".datepicker").first().focus()
                }, 500);
            } //success
        }); //ajax
    } //createEdit

    function submitFormAdministracion() {
        var $form = $("#frmAdministracion");
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

        $(".btn-show").click(function () {
            var id = $(this).data("id");
            %{--$.ajax({--}%
            %{--    type    : "POST",--}%
            %{--    url     : "${createLink(action:'show_ajax')}",--}%
            %{--    data    : {--}%
            %{--        id : id--}%
            %{--    },--}%
            %{--    success : function (msg) {--}%
            %{--        var btnOk = $('<a href="#" data-dismiss="modal" class="btn btn-primary">Aceptar</a>');--}%
            %{--        $("#modalTitle").html("Ver Administración");--}%
            %{--        $("#modalBody").html(msg);--}%
            %{--        $("#modalFooter").html("").append(btnOk);--}%
            %{--        $("#modal-administracion").modal("show");--}%
            %{--    }--}%
            %{--});--}%
            %{--return false;--}%
        }); //click btn show

        $(".btn-delete").click(function () {
            var id = $(this).data("id");
            // $("#id").val(id);
            // var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
            // var btnDelete = $('<a href="#" class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');
            //
            // btnDelete.click(function () {
            //     // btnDelete.replaceWith(spinner);
            //     $("#frmDelete-administracionInstance").submit();
            //     return false;
            // });
            //
            // $("#modalTitle").html("Eliminar Administración");
            // $("#modalBody").html("<p>¿Está seguro de querer eliminar este administración?</p>");
            // $("#modalFooter").html("").append(btnOk).append(btnDelete);
            // $("#modal-administracion").modal("show");
            // return false;
        });

    });

</script>

</body>
</html>