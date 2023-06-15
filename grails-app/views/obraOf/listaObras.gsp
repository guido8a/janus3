
<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr>
        <th style="width: 10%">Código</th>
        <th style="width: 42%">Nombre</th>
        <th style="width: 30%">Dirección</th>
        <th style="width: 8%">Fecha</th>
        <th style="width: 6%">Estado</th>
        <th style="width: 4%">Sel.</th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 420px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <g:each in="${data}" var="dt" status="i">
            <tr>
                <td style="width: 10%">${dt.obracdgo}</td>
                <td style="width: 42%">${dt.obranmbr}</td>
                <td style="width: 30%"> ${dt.dptodscr}
                <td style="width: 8%"> ${dt.obrafcha}
                <td style="width: 6%"> ${dt.obraetdo}
                </td>
                <td style="width: 4%">
                    <div style="text-align: center" class="selecciona" id="reg_${i}"
                         regNmbr="${dt?.obranmbr}" regCdgo="${dt?.obracdgo}"
                         data-id="${dt?.obra__id}">
                        <button class="btn btn-xs btn-success"><i class="fa fa-check"></i></button>
                    </div></td>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">
    $(".selecciona").click(function () {
        var d = cargarLoader("Cargando...");
        var id = $(this).data("id");
        $("#listaObra").dialog("close");
        // $("#spinner").removeClass("hide");
        if(${tipo == 'oferente'}){
            location.href = "${g.createLink(controller: 'obraOf', action: 'registroObra')}" + "?obra=" + id
        }else{
            location.href = "${g.createLink(controller: 'obra', action: 'registroObra')}" + "?obra=" + id
        }
    });
</script>