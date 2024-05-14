<div id="list-Concurso" role="main">
    ${raw(msg)}

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr style="width: 100%;">
            <th style="width: 19%;">Obra</th>
            <th style="width: 25%;">Pac</th>
            <th style="width: 10%;">Código</th>
            <th style="width: 20%;">Objeto</th>
            <th style="width: 10%;">Costo Bases</th>
            <th style="width: 8%;">Documentos</th>
            <th style="width: 8%">Estado</th>
        </tr>
        </thead>

    </table>
</div>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:each in="${data}" status="i" var="cncr">
            <tr style="font-size: 11px" class="item_row" data-id="${cncr.cncr__id}" data-reg="${cncr.cncretdo}">
                <td style="width: 19%;">${cncr.obranmbr}</td>
                <td style="width: 25%;">${cncr.pacpdscr}</td>
                <td style="width: 10%;">${cncr.cncrcdgo}</td>
                <td style="width: 20%;">${cncr.cncrobjt}</td>
                <td style="text-align: right; width: 10%;">${cncr.cncrbase}</td>
                <td style="text-align: center; width: 8%;">${cncr.cuenta}</td>
                <td style="width: 8%;">
                    <strong style="color: ${cncr.cncretdo == "R" ? '#78b665' : '#c42623'} "> ${(cncr.cncretdo == "R") ? "Registrado" : "No registrado"}</strong>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>


<script type="text/javascript">

    $(function () {
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



    function createContextMenu (node){
        var $tr = $(node);
        var id = $tr.data("id");
        var estado = $tr.data("reg");

        var items = {
            header : {
                label : "Sin Acciones",
                header: true
            }
        };

        var ver = {
            label   : 'Ver',
            icon   : "fa fa-search",
            action : function (e) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'show_ajax')}",
                    data    : {
                        id : id
                    },
                    success : function (msg) {
                        bootbox.dialog({
                            title   : "Ver Concurso",
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
            label   : 'Editar',
            icon   : "fa fa-edit",
            action : function (e) {
                location.href = "${g.createLink(action: 'form_ajax')}/" + id
            }
        };

        var documentos = {
            label   : 'Documentos',
            icon   : "fa fa-file",
            action : function (e) {
                location.href = "${g.createLink(controller: 'documentoProceso',action: 'list')}/" + id
            }
        };

        var oferta = {
            label   : 'Ofertas',
            icon   : "fa fa-book",
            action : function (e) {
                location.href = "${g.createLink(controller: 'oferta',action: 'list')}/" + id
            }
        };

        var eliminar = {
            label   : 'Eliminar',
            icon   : "fa fa-trash",
            action : function (e) {
                deleteRow(id);
            }
        };

        items.header.label = "Acciones";
        items.ver = ver;
        items.editar = editar;
        items.documentos = documentos;
        if(estado === 'R'){
            items.oferta = oferta;
        }
        items.eliminar = eliminar;
        return items
    }



</script>