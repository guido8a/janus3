<div class="contenedorTabla" style="width: 650px">
    <table class="table table-condensed table-bordered table-striped table-hover" id="tblDisponibles">
        <thead>
        <tr>
            <th>Item</th>
            <th>Descripción</th>
            <g:if test="${tipo == 'c'}">
                <th>Precio unitario</th>
            </g:if>
            <th>Aporte</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${rows}" var="r">
            <tr data-item="${r.iid}" data-codigo="${r.codigo}" data-nombre="${r.item}" data-valor="${r.aporte ?: 0}" data-precio="${r.precio ?: 0}" data-grupo="${r.grupo}">
                <td>
                    ${r.codigo}
                </td>
                <td>
                    ${r.item}
                </td>
                <g:if test="${tipo == 'c'}">
                    <td class="numero">
                        <g:formatNumber number="${r.precio ?: 0}" maxFractionDigits="5" minFractionDigits="5" locale='ec'/>
                    </td>
                </g:if>
                <td class="numero">
                    <g:formatNumber number="${r.aporte ?: 0}" maxFractionDigits="5" minFractionDigits="5" locale='ec'/>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    var $tree = $("#tree");
    var $tabla = $("#tblDisponibles");


    function updateCoef($row) {
        var nombreOk = true;
        if ($.trim($row.attr("nombre")) == "") {
            nombreOk = false;
        }
        $("#spanCoef").text($.trim($row.attr("numero")) + ": " + $.trim($row.attr("nombre"))).parent().data("nombreOk", nombreOk);
    }

    function updateTotal(val) {
        $("#spanSuma").text("(" + number_format(val, 6, ".", ",") + ")").data("total", val);
    }


    function updateSumaTotal() {
        var total = 0;

        $("#tree").children("ul").children("li").each(function () {
            var val = $(this).attr("valor");
            val = val.replace(",", ".");
            val = parseFloat(val);
            total += val;
        });
        $("#spanTotal").text(number_format(total, 3, ".", "")).data("valor", total);
    }

    function clickTr($tr) {
        var $sps = $("#spanSuma");
        var total = parseFloat($sps.data("total"));

        if ($tr.hasClass("selected")) {
            $tr.removeClass("selected");
            total -= parseFloat($tr.data("valor"));
        } else {
            $tr.addClass("selected");
            total += parseFloat($tr.data("valor"));
        }
        if ($tabla.children("tbody").children("tr.selected").length > 0) {
            $("#btnRemoveSelection, #btnAgregarItems").removeClass("disabled");
        } else {
            $("#btnRemoveSelection, #btnAgregarItems").addClass("disabled");
        }
        updateTotal(total);
    }

    $(function () {

        $("#btnRemoveSelection").click(function () {
            if (!$(this).hasClass("disabled")) {
                $tabla.children("tbody").children("tr.selected").removeClass("selected");
                $("#btnRemoveSelection").addClass("disabled");
                updateTotal(0);
                $("#btnRemoveSelection, #btnAgregarItems").addClass("disabled");
            }
            return false;
        });


        $tabla.children("tbody").children("tr").click(function () {
            clickTr($(this));
        });

        $(".modal").draggable({
            handle : ".modal-header"
        });

    })
</script>