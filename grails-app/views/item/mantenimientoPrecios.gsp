<%@ page contentType="text/html;charset=UTF-8" %>
<html>

<head>
    <meta name="layout" content="main">
    <title>Mantenimiento de Precios</title>

    <asset:javascript src="/apli/tableHandler.js"/>
    <asset:javascript src="/apli/tableHandlerBody.js"/>
    <asset:stylesheet src="/tableHandler.css"/>
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
            <div class="col-md-2" align="center"><label>Ver</label></div>
        </div>

        <div class="row">
            <div class="col-md-4" align="center">
                <g:select class="form-control listPrecio span2" name="listaPrecio"
                          from="${janus.Lugar.list([sort: 'descripcion'])}" optionKey="id"
                          optionValue="${{ it.descripcion }}"
                          noSelection="['-1': 'Seleccione']"
                          disabled="false" style="width: 300px;"/>
            </div>

            <div class="col-md-2" style="align-items: center;" align="center">
                <input aria-label="" name="fecha" id='fecha' type='text' class="fecha form-control" value="${new Date().format("dd-MM-yyyy")}" />
            </div>

            <div class="col-md-2" align="center">
                <g:select name="tipo" from="${janus.Grupo.findAllByIdLessThanEquals(3)}" class="form-control" optionKey="id"
                          optionValue="descripcion" noSelection="['-1': 'Todos']"/>
            </div>

            <div class="btn-group col-md-2" style=" width: 200px;">
                <a href="#" class="btn btn-consultar btn-info"><i class="fa fa-search"></i>Consultar</a>
                <a href="#" class="btn btn-actualizar btn-success"><i class="fa fa-save"></i>Guardar</a>
            </div>
        </div>
    </fieldset>
</div>


<div id="divTabla" class="hidden" style="height: auto; overflow-y:auto; overflow-x: hidden; border-style: groove; border-color: #0d7bdc; margin-top: 5px">

</div>


<script type="text/javascript">

    $('#fecha').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    function consultar() {
        var dialog = cargarLoader("Cargando...");
        var lgar = $("#listaPrecio").val();
        var fcha = $("#fecha").val();

        if (fcha === "") {
            fcha = new Date().toString("dd-MM-yyyy");
        }

        var todos = 2;
        var tipo = $("#tipo").val();
        var reg = "";
        if ($("#reg").hasClass("active")) {
            reg += "R";
            reg += "N";
        }

        if (reg === "") {
            $("#reg").addClass("active");
            $("#nreg").addClass("active");
            reg = "RN";
        }

        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'tabla')}",
            data    : {
                lgar  : lgar,
                fecha : fcha,
                todos : todos,
                tipo  : tipo,
                reg   : reg,
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

    $(function () {

        $(".btn-consultar").click(function () {
            var lgar = $("#listaPrecio").val();
            if (lgar !== '-1') {
                consultar();
            }
            else {
                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione una lista de precios" + '</strong>');
                $("#divTabla").addClass("hidden");
            }
        });

        $(".btn-actualizar").click(function () {
            $("#dlgLoad").dialog("open");
            var data = "";

            var fcha = $("#fecha").val();

            $(".editable").each(function () {
                var id = $(this).attr("id");
                var valor = $(this).data("valor");
                var data1 = $(this).data("original");

                var chk = $(this).siblings(".chk").children("input").is(":checked");

                if (chk || (parseFloat(valor) > 0 && parseFloat(data1) !== parseFloat(valor))) {
                    if (data !== "") {
                        data += "&";
                    }
                    var val = valor ? valor : data1;
                    data += "item=" + id + "_" + val + "_" + fcha;// + "_" + chk;
                }
            });

            $.ajax({
                type    : "POST",
                url     : "${createLink(action: 'actualizar')}",
                data    : data,
                success : function (msg) {
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