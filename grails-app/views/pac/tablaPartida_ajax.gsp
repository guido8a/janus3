
<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr style="width: 100%">
        <th style="width: 45%">Código</th>
        <th style="width: 45%">Descripción</th>
        <th style="width: 10%">Seleccionar</th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 430px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <g:each in="${data}" var="dt" status="i">
            <tr style="width: 100%">
                <td style="width: 40%">${dt.prspnmro}</td>
                <td style="width: 48%">${dt.prspdscr}</td>
                <td style="width: 12%">
                    <div style="text-align: center" class="selecciona" id="reg_${i}" data-desc="${dt?.prspdscr}" data-codigo="${dt?.prspnmro}" data-id="${dt?.prsp__id}">
                        <button class="btn btn-xs btn-success"><i class="fa fa-check"></i></button>
                    </div></td>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">
    $(".selecciona").click(function () {
        var idPP= $(this).data("id");
        var codigo = $(this).data("codigo");
        var nombre = $(this).data("desc");

        $("#item_prsp").val(idPP);
        $("#item_presupuesto").val(codigo).attr("title", nombre);
        cargarTecho();
        cerrarBuscadorPP();
    });
</script>