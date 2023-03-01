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
                         data-nombre="${dt?.obranmbr}" data-codigo="${dt?.obracdgo}"
                         data-id="${dt?.obra__id}">
                        <button class="btn btn-xs btn-success"><i class="fa fa-check"></i></button>
                    </div></td>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">
    $(".selecciona").click(function () {
        var id = $(this).data("id");
        var codigo = $(this).data("codigo");
        $("#obraId").val(id);
        $("#obraCodigo").val(codigo);
        $("#nombreObra").val($(this).data("nombre"));
        $("#listaObra").dialog("close");
        cargarCombo();
        cargarCanton();
        cargarParroquia();
        cargarClaseObra();
        cargarPorcentajeAnticipo();
    });

</script>