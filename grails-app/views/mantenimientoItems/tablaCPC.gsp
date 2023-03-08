
<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr>
        <th style="width: 15%">Código</th>
        <th style="width: 70%">Descripción</th>
        <th style="width: 9%">Seleccionar</th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 430px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <g:each in="${data}" var="dt" status="i">
            <tr>
                <td style="width: 10%">${dt.cpacnmro}</td>
                <td style="width: 68%">${dt.cpacdscr}</td>
                <td style="width: 13%">
                    <div style="text-align: center" class="selecciona" id="reg_${i}" data-desc="${dt?.cpacdscr}" data-codigo="${dt?.cpacnmro}" data-id="${dt?.cpac__id}">
                        <button class="btn btn-xs btn-success"><i class="fa fa-check"></i></button>
                    </div></td>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">
    $(".selecciona").click(function () {
        var idCPC = $(this).data("id");
        var codigo = $(this).data("codigo");
        var nombre = $(this).data("desc");
        $("#codigoComprasPublicas").val(idCPC);
        $("#item_codigo").val(codigo);
        <g:if test="${tipo == '1'}">
        $("#item_cpac").val(idCPC);
        </g:if>
        <g:else>
        $("#item_desc").val(nombre);
        </g:else>
        cerrarBuscadorCPC();
    });
</script>