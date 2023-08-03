
<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr>
        <th style="width: 9%">Año</th>
        <th style="width: 28%">Código</th>
        <th style="width: 53%">Descripción</th>
        <th style="width: 9%">Seleccionar</th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 430px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover">
        <g:each in="${presupuestos}" var="presupuesto" status="i">
            <tr style="width: 100%">
                <td style="width: 10%">${anioSeleccionado}</td>
                <td style="width: 15%">${presupuesto.prspnmro}</td>
                <td style="width: 65%">${presupuesto.prspdscr}</td>
                <td style="width: 10%">
                    <div style="text-align: center" class="selecciona" data-desc="${presupuesto.prspdscr}" data-codigo="${presupuesto.prspnmro}"
                         data-id="${presupuesto.prsp__id}" data-fuente="${ janus.FuenteFinanciamiento.get(presupuesto.fnfn__id)?.descripcion}" data-proy="${presupuesto.prspproy}"
                         data-prog="${presupuesto.prspprgm}" data-sub="${presupuesto.prspsbpr}">
                        <button class="btn btn-xs btn-success"><i class="fa fa-check"></i></button>
                    </div>
                </td>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">
    $(".selecciona").click(function () {
        var idPartida = $(this).data("id");
        var codigo = $(this).data("codigo");
        var nombre = $(this).data("desc");
        var fuente = $(this).data("fuente");
        var proyecto = $(this).data("proy");
        var programa = $(this).data("prog");
        var subprograma = $(this).data("sub");
        $("#item_prsp").val(idPartida);
        $("#item_presupuesto").val(codigo);
        $("#item_desc").val(nombre);
        $("#item_fuente").val(fuente);
        $("#item_prog").val(programa);
        $("#item_spro").val(subprograma);
        $("#item_proy").val(proyecto);
        $("#prsp_editar").removeAttr("disabled");
        cerrarBuscadorPartida();
    });
</script>