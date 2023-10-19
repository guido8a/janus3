<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <asset:javascript src="/apli/tableHandler.js"/>
    <title>Mantenimiento de Indices</title>

    <style type="text/css">
    th {
        vertical-align : middle !important;
        font-size      : 12px;
    }

    td {
        padding : 3px;
    }

    .number {
        text-align : right !important;
        width      : 100px;
    }

    .unidad {
        text-align : center !important;
    }

    .editable {
        padding-right : 18px !important;
    }

    .changed {
        background-color : #C3DBC3 !important;
    }
    </style>
</head>

<body>
<div class="btn-toolbar" style="margin-top: 5px; margin-bottom: 10px">
    <div class="btn-group col-md-12">
        <div class="col-md-2">
            <a href="${g.createLink(action: 'valorIndice')}" class="btn btn-info" title="Regresar">
                <i class="fa fa-arrow-left"></i>
                Ver valores de Indices
            </a>
        </div>
        <div class="col-md-2">
            <g:select class="form-control" name="periodoIndices"
                      from="${janus.ejecucion.PeriodosInec.findAllByPeriodoCerrado("N", [sort: 'fechaInicio', order: 'desc'])}" optionKey="id" optionValue="${{ it.descripcion }}"
                      disabled="false" />
        </div>
        <div class=" btn-group col-md-3">
            <a href="#" class="btn btn-consultar btn-info"><i class="fa fa-search"></i> Ver</a>
        </div>
    </div>
</div>

<div id="divTabla" style="height: 760px; overflow-y:auto; overflow-x: hidden;">

</div>

<script type="text/javascript">

    function consultar() {
        var v = cargarLoader("Cargando...");
        $("#divTabla").html("");
        var prin = $("#periodoIndices").val();
        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'tablaValores')}",
            data    : {
                prin: prin,
                max: 100,
                pag: 1
            },
            success : function (msg) {
                v.modal("hide");
                $("#divTabla").html(msg);
            }
        });
    }

    $(function () {
        $(".btn-consultar").click(function () {
            $("#error").hide();
            $("#dlgLoad").dialog("open");
            consultar();
            $("#divTabla").show();
        });

        %{--$(".btn-actualizar").click(function () {--}%
        %{--    var data = "";--}%

        %{--    $(".editable").each(function () {--}%
        %{--        var id = $(this).data("id");--}%
        %{--        var prin = $(this).data("prin");--}%
        %{--        var indc = $(this).data("indc");--}%
        %{--        var valor = $(this).data("valor");--}%
        %{--        var data1 = $(this).data("original");--}%

        %{--        if ((parseFloat(data1) !== parseFloat(valor))) {--}%
        %{--            if (data !== "") {--}%
        %{--                data += "&";--}%
        %{--            }--}%
        %{--            var val = valor ? valor : data1;--}%
        %{--            data += "item=" + id + "_" + prin + "_" + indc + "_" + valor;--}%
        %{--        }--}%
        %{--    });--}%

        %{--    $.ajax({--}%
        %{--        type    : "POST",--}%
        %{--        url     : "${createLink(action: 'actualizaVlin')}",--}%
        %{--        data    : data,--}%
        %{--        success : function (msg) {--}%
        %{--            var parts = msg.split("_");--}%
        %{--            var ok = parts[0];--}%
        %{--            var no = parts[1];--}%

        %{--            $(ok).each(function () {--}%
        %{--                var $tdChk = $(this).siblings(".chk");--}%
        %{--                var chk = $tdChk.children("input").is(":checked");--}%
        %{--                if (chk) {--}%
        %{--                    $tdChk.html('<i class="fa fa-check></i>');--}%
        %{--                }--}%
        %{--            });--}%
        %{--            // doHighlight({elem : $(ok), clase : "ok"});--}%
        %{--            // doHighlight({elem : $(no), clase : "no"});--}%
        %{--        }--}%
        %{--    });--}%
        %{--});--}%

    });
</script>

</body>
</html>