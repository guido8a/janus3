<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
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
        background    : url(${resource(dir:'images', file:'edit.gif')}) right no-repeat;
        padding-right : 18px !important;
    }

    .changed {
        background-color : #e5c78e !important;
    }
    .grabado {
        background-color : #C3DBC3 !important;
    }
    </style>
</head>

<body>
<div class="btn-toolbar" style="margin-top: 5px;">
    <div class="btn-group">
        <a href="${g.createLink(controller: 'contrato', action: 'registroContrato')}?contrato=${cntr}" class="btn btn-info" title="Regresar">
            <i class="fa fa-arrow-left"></i>
            Contrato
        </a>
    </div>
</div>
<fieldset class="borde" >
    <div class="col-md-12" style="margin-top: 10px; margin-bottom: 10px">
        <div class="col-md-4">
            <div class="col-md-3" style="font-weight: bold; margin-top: 5px">Subpresupuesto:</div>
            <div class="col-md-2">
                <g:select class="form-control" name="subpresupuesto" from="${subpresupuestos}" optionKey="${{it.id}}"
                          optionValue="${{ it.descripcion }}" noSelection="[0: 'Todos los Subpresupuestos']"
                          disabled="false" style="width: 270px; margin-right: 10px"/>
            </div>
        </div>

        <div class="btn-group col-md-3" style="margin-left: 10px;">
            <a href="#" class="btn btn-info btn-consultar"><i class="fa fa-search"></i> Ver</a>
            <a href="#" class="btn btn-info btn-verificar btn-info"><i class="fa fa-check"></i> Verificar</a>
            <a href="#" class="btn btn-success btn-grabar btn-success"><i class="fa fa-save"></i> Guardar</a>
        </div>

        <div class="col-md-4">
            <g:link controller="cronogramaContrato" action="cantidadObra" class="btn btn-print btnExcel"
                    id="${cntr}"
                    title="Exportar a excel para definir las cantidades reales de Materiales, M.O. y Equipos"
                    style="margin-left: 1px;">
                <i class="fa fa-file-excel"></i> Generar Archivo Excel
            </g:link>
            <g:link controller="cronogramaContrato" action="subirExcel" class="btn btn-print btnExcel"
                    id="${cntr}"
                    title="Exportar a excel para definir las cantidades reales de Materiales, M.O. y Equipos"
                    style="">
                <i class="fa fa-arrow-up"></i> Cargar desde Excel
            </g:link>
        </div>
    </div>
</fieldset>

<fieldset class="borde" >
    <div id="divTabla" style="height: 760px; overflow-y:auto; overflow-x: hidden;">

    </div>
</fieldset>

<script type="text/javascript">

    function consultar() {
        $("#divTabla").html("");

        var sbpr = $("#subpresupuesto").val();
        var cntr = "${cntr}";

        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'tablaValores')}",
            data    : { sbpr: sbpr, cntr: cntr, max: 100, pag: 1 },
            success : function (msg) {
                $("#divTabla").html(msg);
                $("#dlgLoad").dialog("close");
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

        $(".btn-grabar").click(function () {
            $("#dlgLoad").dialog("open");
            var data = "";

            $(".editable").each(function () {
                var id = $(this).data("id");
                var cmpo = $(this).data("cmpo");
                var valor = $(this).data("valor");
                var data1 = $(this).data("original");

                if ((parseFloat(data1) !== parseFloat(valor))) {
                    if (data !== "") {
                        data += "&";
                    }
                    var val = valor ? valor : data1;
                    data += "item=" + id + "_" + cmpo + "_" + valor;
                    $(this).addClass("grabado")
                }
            });

            $.ajax({
                type    : "POST",
                url     : "${createLink(action: 'actualizaVlin')}",
                data    : data,
                success : function (msg) {
                    $("#dlgLoad").dialog("close");
                    var parts = msg.split("_");
                    var ok = parts[0];
                    var no = parts[1];
                    location.reload();
                    $(ok).each(function () {
                        var $tdChk = $(this).siblings(".chk");
                        var chk = $tdChk.children("input").is(":checked");
                        if (chk) {
                            $tdChk.html('<i class="icon-ok"></i>');
                        }
                    });

                    doHighlight({elem : $(ok), clase : "ok"});
                    doHighlight({elem : $(no), clase : "no"});
                }
            });
        });

    });

    $(".btn-verificar").click(function () {
        var data = "";

        $(".editable").each(function () {
            var id = $(this).data("id");
            var cmpo = $(this).data("cmpo");
            var valor = $(this).data("valor");
            var data1 = $(this).data("original");

            if ((parseFloat(data1) !== parseFloat(valor))) {
                if (data !== "") {
                    data += "&";
                }
                var val = valor ? valor : data1;
                data += "item=" + id + "_" + cmpo + "_" + valor;
                var parcial = $(this).siblings("td").last();
                var cantidad = parcial.prev().data("valor");
                var precio   = parcial.prev().prev().data("valor");
                var subtotal = Math.round(cantidad * precio * 100);
                parcial.text(number_format(subtotal/100, 2, ".", ","));
                $(this).siblings("td").addClass("changed")
            }
        });
    });

</script>

</body>
</html>