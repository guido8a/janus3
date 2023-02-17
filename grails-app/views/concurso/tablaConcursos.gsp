<div id="list-Concurso" role="main">
    ${raw(msg)}

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr style="width: 100%;">
            <th style="width: 15%;">Obra</th>
            <th style="width: 25%;">Pac</th>
            <th style="width: 10%;">Código</th>
            <th style="width: 20%;">Objeto</th>
            <th style="width: 10%;">Costo Bases</th>
            <th style="width: 10%;">Documentos</th>
            <th style="width: 10%">Estado</th>
        </tr>
        </thead>

    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:each in="${data}" status="i" var="cncr">
            <tr style="font-size: 11px" class="item_row" data-id="${cncr.cncr__id}" reg="${cncr.cncretdo}">
                <td style="width: 15%;">${cncr.obranmbr}</td>
                <td style="width: 25%;">${cncr.pacpdscr}</td>
                <td style="width: 10%;">${cncr.cncrcdgo}</td>
                <td style="width: 20%;">${cncr.cncrobjt}</td>
                <td style="text-align: right; width: 10%;">${cncr.cncrbase}</td>
                <td style="text-align: center; width: 10%;">0</td>
                <td style="width: 10%;">
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