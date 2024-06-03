<%@ page import="seguridad.Persona" %>
<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr>
        <th style="width: 5%">Estado</th>
        <th style="width: 8%">Usuario</th>
        <th style="width: 20%">Nombre</th>
        <th style="width: 20%">Apellido</th>
        <th style="width: 27%">Departamento</th>
        <th style="width: 20%">Perfiles</th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 530px; overflow-y: auto;float: right;">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <g:each in="${data}" var="dt" status="i">
            <g:set var="usuario" value="${dt.prsn__id}"/>
            <tr data-id="${dt.prsn__id}" class="${dt.prsnactv == 0 ? 'inactivo' : 'activo'}">
                <td style="width: 5%; text-align: center">
                    <g:if test="${dt.prsnactv == 1}">
                        <i class="fa fa-user text-success"></i>
                    </g:if>
                    <g:if test="${dt.prsnactv == 0}">
                        <i class="fa fa-user text-muted"></i>
                    </g:if>
                <td style="width: 8%">${dt.prsnlogn}</td>
                <td style="width: 20%">${dt.prsnnmbr}</td>
                <td style="width: 20%">${dt.prsnapll}</td>
                <td style="width: 27%">${janus.Departamento.get(dt.dpto__id).descripcion}</td>
                <td style="width: 19%">
                <ul>
                    <g:each in="${seguridad.Sesn.findAllByUsuarioAndFechaFinIsNull(seguridad.Persona.get(dt.prsn__id))}" var="perfiles">
                            <li>${perfiles?.perfil?.nombre ?: ''}</li>
                    </g:each>
                </ul>
                </td>
                <td style="width: 1%"></td>
            </tr>
        </g:each>
    </table>
</div>


<script type="text/javascript">

    function createContextMenu(node) {
        var $tr = $(node);

        var items = {
            header : {
                label  : "Acciones",
                header : true
            }
        };

        var id = $tr.data("id");

        var estaActivo = $tr.hasClass("activo");
        var estaInactivo = $tr.hasClass("inactivo");
        var puedeEliminar = $tr.hasClass("eliminar");

        puedeEliminar = true;

        var ver = {
            label  : 'Ver',
            icon   : "fa fa-search",
            action : function () {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'persona', action:'show_ajax')}",
                    data    : {
                        id : id
                    },
                    success : function (msg) {
                        bootbox.dialog({
                            title   : "Ver Persona",
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
            }
        };

        var editar = {
            label           : 'Editar',
            icon            : "fa fa-pen text-success",
            separator_after : true,
            action          : function (e) {
                createEditRow(id, "persona");
            }
        };

        var config = {
            label           : 'Perfiles',
            icon            : "fa fa-address-card text-info",
            separator_after : true,
            url             : "${createLink(controller: 'persona', action: 'config')}/" + id
        };

        var eliminar = {
            label            : 'Eliminar Usuario',
            icon             : "fa fa-times-circle text-danger",
            action           : function (e) {
                deleteRow(id);
            }
        };

        items.ver = ver;
        items.editar = editar;
        if (estaActivo) {
            items.config = config;
        }

        if (puedeEliminar) {
            items.eliminar = eliminar;
        }

        return items;
    }

    $(function () {

        %{--$("#perfil").change(function () {--}%
        %{--    openLoader();--}%
        %{--    var params = "${params}";--}%
        %{--    var id = $(this).val();--}%
        %{--    var strParams = "";--}%
        %{--    params = str_replace('[', '', params);--}%
        %{--    params = str_replace(']', '', params);--}%
        %{--    params = str_replace(':', '=', params);--}%
        %{--    params = params.split(",");--}%
        %{--    for (var i = 0; i < params.length; i++) {--}%
        %{--        params[i] = $.trim(params[i]);--}%
        %{--        if (params[i].startsWith("perfil")) {--}%
        %{--            params[i] = "perfil=" + id;--}%
        %{--        }--}%
        %{--        if (!params[i].startsWith("action") && !params[i].startsWith("controller") && !params[i].startsWith("format") && !params[i].startsWith("offset")) {--}%
        %{--            strParams += params[i] + "&"--}%
        %{--        }--}%
        %{--    }--}%
        %{--    location.href = "${createLink(action: 'list')}?" + strParams--}%
        %{--});--}%

        %{--$(".a").click(function () {--}%
        %{--    var tipo = $(this).data("tipo");--}%
        %{--    openLoader();--}%
        %{--    var params = "${params}";--}%
        %{--    var strParams = "";--}%
        %{--    params = str_replace('[', '', params);--}%
        %{--    params = str_replace(']', '', params);--}%
        %{--    params = str_replace(':', '=', params);--}%
        %{--    params = params.split(",");--}%
        %{--    for (var i = 0; i < params.length; i++) {--}%
        %{--        params[i] = $.trim(params[i]);--}%
        %{--        if (params[i].startsWith("estado")) {--}%
        %{--            params[i] = "estado=" + tipo;--}%
        %{--        }--}%
        %{--        if (!params[i].startsWith("action") && !params[i].startsWith("controller") && !params[i].startsWith("format") && !params[i].startsWith("offset")) {--}%
        %{--            strParams += params[i] + "&"--}%
        %{--        }--}%
        %{--    }--}%
        %{--    location.href = "${createLink(action: 'list')}?" + strParams--}%
        %{--});--}%

        // $(".btnCrear").click(function () {
        //     createEditRow(null, "persona");
        //     return false;
        // });

        $("tr").contextMenu({
            items  : createContextMenu,
            onShow : function ($element) {
                $element.addClass("trHighlight");
            },
            onHide : function ($element) {
                $(".trHighlight").removeClass("trHighlight");
            }
        });

    });
</script>
