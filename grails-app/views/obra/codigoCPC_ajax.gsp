<html>

<body>
<div class="alert alert-info">* Máxima cantidad de registros en pantalla 40, use las opciones de búsqueda</div>
<table class="table table-bordered table-striped table-hover table-condensed" id="tabla" style="margin-top: -20px">
    <thead>
    <tr>
        <th>Código</th>
        <th>Descripción</th>
        <th>Seleccionar</th>
    </tr>
    </thead>

    <tbody>

    <g:each in="${codigos}" var="codigo" status="i">
        <tr style="width: 100%;">
            <td style="width: 15%;">${codigo.cpacnmro}</td>
            <td style="width: 75%;">${codigo.cpacdscr}</td>
            <td style="width: 10%; text-align: center">
                <a href="#" class="btn btn-xs btn-success btnSelCPC" title="Seleccionar Código CPC" data-id="${codigo.cpac__id}" data-nombre="${codigo.cpacdscr}" data-numero="${codigo.cpacnmro}">
                    <i class="fa fa-check"></i>
                </a>
            </td>
        </tr>
    </g:each>
    </tbody>
</table>

<script type="text/javascript">

    $(".btnSelCPC").click(function () {
        var id = $(this).data("id");
        var codigo = $(this).data("numero");
        var nombre = $(this).data("nombre");

        $("#codigoComprasPublicas").val(id);
        $("#item_codigo").val(codigo);

        $("#busqueda_CPC").dialog("close");
        return false;
    });

</script>

</body>
</html>