
<%@ page import="janus.ejecucion.PeriodosInec" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Períodos de Índices
    </title>
</head>
<body>

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

<script type="text/javascript">

    $(function () {

        $(".btn-new").click(function () {
            createEditRow();
        }); //click btn new

        $(".btn-edit").click(function () {
            var id = $(this).data("id");
            createEditRow(id);
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
                    var s = bootbox.dialog({
                        id      : "dlgShow",
                        title   : "Datos de Período",
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
            return false;
        }); //click btn show

        $(".btn-delete").click(function () {
            var id = $(this).data("id");
            deleteRow(id);
          });

        function deleteRow(id) {
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
                                    id : id
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
