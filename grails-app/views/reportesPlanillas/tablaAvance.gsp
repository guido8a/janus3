<elm:poneHtml textoHtml="${html}"/>

<script type="text/javascript">
    $(function () {
        var sep = "^";
        $(".btnSave").click(function () {
            var g = cargarLoader("Guardando...");
            var data = "id=${contrato.id}&plnl=${plnl}";
            $(".texto").each(function () {
                data += "&texto=" + $(this).data("num") + sep + $(this).val();
            });
            $(".clima").each(function () {
                var $tarde = $(this).parents("td").next().children("select");
                data += "&clima=" + $(this).data("fecha") + sep + $(this).val();
                data += sep + $tarde.val();
            });
            $.ajax({
                type    : "POST",
                url     : "${createLink(action: 'saveAvance')}",
                data    : data,
                success : function (msg) {
                    g.modal("hide");
                    if (msg === "OK") {
                        log("Datos guardados correctamente", "success");
                    } else {
                        log(msg, "danger");
                    }
                }
            });
            return false;
        });

        $(".btnPrint").click(function () {
            location.href = "${createLink(action:'reporteAvance', id:contrato.id, params:[plnl:plnl])}";
            return false;
        });

        $(".btnPrintTotal").click(function () {
            location.href = "${createLink(action:'reporteAvanceTotal', id:contrato.id, params:[plnl:plnl])}";
            return false;
        });

    });
</script>