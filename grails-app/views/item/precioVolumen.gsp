<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Mant. de Precios por volumen</title>

    <asset:javascript src="/apli/tableHandlerBody.js"/>
    <asset:stylesheet src="/tableHandler.css"/>

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
        background-color : #C3DBC3 !important;
    }

    .old {
        color : #21337f;
    }
    </style>

</head>

<body>

<div class="btn-toolbar" style="margin-top: 5px; margin-bottom: 10px;">
    <div class="btn-group">
        <a href="${g.createLink(controller: 'mantenimientoItems', action: 'precios')}" class="btn btn-info" title="Regresar">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
    </div>
</div>

<div style="border-style: groove; border-color: #0d7bdc">
    <fieldset style="margin-bottom: 10px">
        <div class="row">
            <div class="col-md-4" align="center"><label>Lista de Precios</label></div>
            <div class="col-md-2" align="center"><label>Fecha</label></div>
        </div>

        <div class="row">
            <div class="col-md-4" align="center">
                <g:select class="form-control listPrecio span2" name="listaPrecio"
                          from="${janus.TipoLista.findAllByIdInList([3L, 4L, 5L], [sort: 'descripcion'])}" optionKey="id"
                          optionValue="${{ it.descripcion + ' (' + it.codigo + ')' }}"
                          noSelection="['-1': 'Todos']"
                          disabled="false" style="margin-left: 20px; width: 300px; margin-right: 50px"/>
            </div>

            <div class="col-md-2" style="align-items: center;" align="center">
                <input aria-label="" name="fecha" id='fecha' type='text' class="fecha form-control" value="${new Date().format("dd-MM-yyyy")}" />
            </div>

            <div class="btn-group col-md-2" style=" width: 200px;">
                <a href="#" class="btn btn-consultar btn-info"><i class="fa fa-search"></i>Ver</a>
                <a href="#" class="btn btn-actualizar btn-success"><i class="fa fa-save"></i>Guardar</a>
            </div>
        </div>
    </fieldset>
</div>

<div id="divTabla" class="hidden" style=" overflow-y:auto; overflow-x: auto; border-style: groove; border-color: #0d7bdc; margin-top: 5px">

</div>

<script type="text/javascript">

    $('#fecha').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    $(function () {

        function consultar() {
            var dialog = cargarLoader("Cargando...");
            $("#divTabla").html("");
            var $fecha = $("#fecha");

            var lgar = $("#listaPrecio").val();
            var fcha = $fecha.val();

            if (fcha === '') {
                fcha = new Date().toString("dd-MM-yyyy")
            }
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'tablaVolumen')}",
                data    : {
                    lgar  : lgar,
                    fecha : fcha,
                    max   : 100,
                    pag   : 1
                },
                success : function (msg) {
                    dialog.modal("hide");
                    $("#divTabla").html(msg).removeClass("hidden");
                    $("#dlgLoad").dialog("close");
                }
            });
        }

        $(".btn-consultar").click(function () {
            var lgar = $("#listaPrecio").val();
            $("#error").hide();
            $("#dlgLoad").dialog("open");
            consultar();
            $("#divTabla").show();
        });

        $(".btn-actualizar").click(function () {
            var d = cargarLoader("Guardando...");
            $("#dlgLoad").dialog("open");
            var data = "";

            var fcha = $("#fecha").val();

            $(".editable").each(function () {
                var id = $(this).data("id");
                var lugar = $(this).data("lugar");
                var item = $(this).data("item");
                var valor = $(this).data("valor");
                var data1 = $(this).data("original");

                if ((parseFloat(valor) > 0 && parseFloat(data1) !== parseFloat(valor))) {
                    if (data !== "") {
                        data += "&";
                    }
                    var val = valor ? valor : data1;
                    data += "item=" + id + "_" + item + "_" + lugar + "_" + valor + "_" + fcha;
                }
            });

            $.ajax({
                type    : "POST",
                url     : "${createLink(action: 'actualizarVol')}",
                data    : data,
                success : function (msg) {
                    d.modal("hide");
                    $("#dlgLoad").dialog("close");
                    var parts = msg.split("_");
                    var ok = parts[0];
                    var no = parts[1];

                    $(ok).each(function () {
                        var fec = $(this).siblings(".fecha");
                        fec.text($("#fecha").val());
                        var $tdChk = $(this).siblings(".chk");
                        var chk = $tdChk.children("input").is(":checked");
                        if (chk) {
                            $tdChk.html('<i class="fa fa-check"></i>');
                        }
                    });
                    doHighlight({elem : $(ok), clase : "ok"});
                    doHighlight({elem : $(no), clase : "no"});
                }
            });
        });
    });
</script>

</body>
</html>