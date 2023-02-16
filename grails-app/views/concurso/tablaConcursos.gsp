<div id="list-Concurso" role="main">
    ${raw(msg)}

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th>Obra</th>
            <th>Pac</th>
            %{--                        <th>Pac</th>--}%
            <th>Código</th>
            <th>Objeto</th>
            <th>Costo Bases</th>
            <th>Documentos</th>
            <th style="width: 80px">Estado</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${data}" status="i" var="cncr">
            <tr style="font-size: 11px" class="item_row" data-id="${cncr.cncr__id}" reg="${cncr.cncretdo}">
                <td>${cncr.obranmbr}</td>
                <td>${cncr.pacpdscr}</td>
                <td>${cncr.cncrcdgo}</td>
                <td>${cncr.cncrobjt}</td>
                <td style="text-align: right">${cncr.cncrbase}</td>
                <td style="text-align: center">0</td>
                <td>
                    <strong style="color: ${cncr.cncretdo == "R" ? '#78b665' : '#c42623'} "> ${(cncr.cncretdo == "R") ? "Registrado" : "No registrado"}</strong>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>

</div>

<script type="text/javascript">
    $(function () {
$("tbody>tr").contextMenu({
    items  : {
        header   : {
            label  : "Acciones",
            header : true
        },
        ver      : {
            label  : "Ver",
            icon   : "fa fa-search",
            action : function ($element) {
                var id = $element.data("id");
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'show_ajax')}",
                                    data    : {
                                        id : id
                                    },
                                    success : function (msg) {
                                        bootbox.dialog({
                                            title   : "Ver Año",
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
                        },
                        editar   : {
                            label  : "Editar",
                            icon   : "fa fa-edit",
                            action : function ($element) {
                                var id = $element.data("id");
                                location.href = "${g.createLink(action: 'form_ajax')}/" + id
                            }
                        },
                        eliminar : {
                            label            : "Eliminar",
                            icon             : "fa fa-trash",
                            separator_before : true,
                            action           : function ($element) {
                                var id = $element.data("id");
                                deleteRow(id);
                            }
                        }
                    },
                    onShow : function ($element) {
                        $element.addClass("success");
                    },
                    onHide : function ($element) {
                        $(".success").removeClass("success");
                    }
                });
    });
</script>