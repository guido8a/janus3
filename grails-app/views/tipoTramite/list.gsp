<%@ page import="janus.RolTramite; janus.TipoTramite" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Tipo Trámites
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
        Nuevo Tipo de Trámite
    </a>
</div>

<div id="list-TipoTramite" role="main" style="margin-top: 10px;">

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <g:sortableColumn property="codigo" title="Código"/>
            <g:sortableColumn property="descripcion" title="Descripción"/>
            <th>Padre</th>
            <g:sortableColumn property="tiempo" title="Tiempo"/>
            <g:sortableColumn property="tipo" title="Tipo"/>
            <g:sortableColumn property="requiereRespuesta" title="Requiere Respuesta"/>
            <th>Configurado</th>
            <th style="width: 130px">Acciones</th>
        </tr>
        </thead>
        <tbody class="paginate">
        <g:each in="${tipoTramiteInstanceList}" status="i" var="tipoTramiteInstance">
            <tr>
                <td>${fieldValue(bean: tipoTramiteInstance, field: "codigo")}</td>
                <td>${fieldValue(bean: tipoTramiteInstance, field: "descripcion")}</td>
                <td>${fieldValue(bean: tipoTramiteInstance, field: "padre")}</td>
                <td>${fieldValue(bean: tipoTramiteInstance, field: "tiempo")} días</td>
                <td><g:message code="tipoTramite.tipo.${tipoTramiteInstance.tipo}"/></td>
                <td>${tipoTramiteInstance.requiereRespuesta == 'S' ? 'SI' : 'NO'}</td>

                <td>
                    <g:set var="de" value="${janus.DepartamentoTramite.findAllByTipoTramiteAndRolTramite(tipoTramiteInstance, RolTramite.findByCodigo('DE'))}"/>
                    <g:set var="para" value="${janus.DepartamentoTramite.findAllByTipoTramiteAndRolTramite(tipoTramiteInstance, RolTramite.findByCodigo('PARA'))}"/>
                    ${de.size() > 0 && para.size() > 0 ? 'SI' : 'NO'}
                </td>

                <td>
                    <a class="btn btn-info btn-xs btn-show" href="#"  title="Ver" data-id="${tipoTramiteInstance.id}">
                        <i class="fa fa-clipboard"></i>
                    </a>
                    <a class="btn btn-success btn-xs btn-edit" href="#"  title="Editar" data-id="${tipoTramiteInstance.id}">
                        <i class="fa fa-edit"></i>
                    </a>
                    <a class="btn btn-xs btn-dep btn-info" href="#" title="Departamentos" data-id="${tipoTramiteInstance.id}">
                        <i class="fa fa-building"></i>
                    </a>
                    <a class="btn btn-danger btn-xs btn-delete" href="#" title="Eliminar" data-id="${tipoTramiteInstance.id}">
                        <i class="fa fa-trash"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>

</div>

<elm:pagination total="${tipoTramiteInstanceTotal}" params="${params}" />


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
                    title   : title + " Tipo de Trámite",
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
                                return submitFormTipoTramite();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormTipoTramite() {
        var $form = $("#frmTipoTramite");
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
                    bootbox.dialog({
                        title   : "Tipo de Trámite",
                        message : msg,
                        buttons : {
                            ok : {
                                label     : "Aceptar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            }
                        }
                    });
                }
            });
        }); //click btn show

        $(".btn-dep").click(function () {
            var id = $(this).data("id");
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'departamentos_ajax')}",
                data    : {
                    tramite : id
                },
                success : function (msg) {
                    bootbox.dialog({
                        title   : "Departamentos",
                        message : msg,
                        buttons : {
                            ok : {
                                label     : "Aceptar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            }
                        }
                    });
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
