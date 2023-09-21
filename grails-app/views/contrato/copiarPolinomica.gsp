<%@ page import="janus.ejecucion.TipoFormulaPolinomica" contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <meta name="layout" content="main">

    <title>Fórmula Polinómica</title>

    <style type="text/css">

    .titulo {
        font-weight : bolder;
        font-size: 16px;
    }
    </style>

</head>

<body>

<div class="col-md-12" style="margin-bottom: 10px;">
    <div class="col-md-8 btn-group" role="navigation">
        <g:link controller="contrato" action="registroContrato" params="[contrato: contrato?.id]"
                class="btn btn-info btn-new" title="Regresar al contrato">
            <i class="fa fa-arrow-left"></i>
            Contrato
        </g:link>
    %{--        <a href="#" class="btn btn-success" id="btnSave"><i class="fa fa-save"></i> Guardar</a>--}%

        <div class="col-md-6">
            <g:select name="listaFormulas" id="existentes" from="${formulas}" optionValue="descripcion" optionKey="id"
                      style="margin-right: 1px" class="form-control"/>
        </div>
%{--        <div class="col-md-3">--}%
%{--            <a href="#" class="btn btn-info" id="btnCopiar"><i class="fa fa-file"></i> Crear fórmula polinómica</a>--}%
%{--        </div>--}%
    </div>
</div>

<div style="min-height: 50px; margin-bottom: 10px">
    Contrato: <span style="font-size: 14px; font-weight: bold"> ${contrato.objeto} </span>
</div>


<div id="divTabla">
</div>

<div id="dialog-confirma" title="Crear Fórmula Polinómica" style="display: none">
    <span class="ui-icon ui-icon-alert"
          style="float:left; margin:0 7px 70px 0;"></span>
    <p>Crear una fórmula polinómica adicional para este contrato.</p>
    <p>Se creará la nueva fórmula en base a una existente.</p>
</div>

<div id="forma-fprj" title="Crear nueva Fórmula Polinómica" style="display: none">
    <p class="validateTips">Todos los campos son obligatorios</p>
    <g:form action="creaFprj">
        <fieldset>
            <label for="name">Name</label>
            <input type="text" name="name" id="name" value="Jane Smith" class="text ui-widget-content ui-corner-all">
            <label for="email">Email</label>
            <input type="text" name="email" id="email" value="jane@smith.com" class="text ui-widget-content ui-corner-all">
            <label for="password">Password</label>
            <input type="password" name="password" id="password" value="xxxxxxx" class="text ui-widget-content ui-corner-all">
        </fieldset>
    </g:form>
</div>

<div id="ajx_frma" style="width:520px;"></div>


<script type="text/javascript">
    decimales = 3;
    tabla = $(".table");

    beforeDoEdit = function (sel, tf) {
        var tipo = sel.data("tipo");
        tf.data("tipo", tipo);
    };

    textFieldBinds = {
        keyup: function () {
            var tipo = $(this).data("tipo");
            var td = $(this).parents("td");
            var val = $(this).val();
            var thTot = $("th." + tipo);
            var tds = $(".editable[data-tipo=" + tipo + "]").not(td);

            var tot = parseFloat(val);
            tds.each(function () {
                tot += parseFloat($(this).data("valor"));
            });
            thTot.text(tot);
        }
    };

    $(".editable").first().addClass("selected");

    %{--$("#btnSave").click(function () {--}%
    %{--    var str = "";--}%
    %{--    $(".editable").each(function () {--}%
    %{--        var td = $(this);--}%
    %{--        var id = td.data("id");--}%
    %{--        var valor = parseFloat(td.data("valor"));--}%
    %{--        var orig = parseFloat(td.data("original"));--}%

    %{--        if (valor !== orig) {--}%
    %{--            if (str !== "") {--}%
    %{--                str += "&";--}%
    %{--            }--}%
    %{--            str += "valor=" + id + "_" + valor;--}%
    %{--        }--}%
    %{--    });--}%
    %{--    if (str !== "") {--}%
    %{--        $.ajax({--}%
    %{--            type: "POST",--}%
    %{--            url: "${createLink(action:'saveCambiosPolinomica')}",--}%
    %{--            data: str,--}%
    %{--            success: function (msg) {--}%
    %{--                var parts = msg.split("_");--}%
    %{--                var ok = parts[0];--}%
    %{--                var no = parts[1];--}%
    %{--                doHighlight({elem: $(ok), clase: "ok"});--}%
    %{--                doHighlight({elem: $(no), clase: "no"});--}%
    %{--            }--}%
    %{--        });--}%
    %{--    }--}%
    %{--    return false;--}%
    %{--});--}%

    $("#tabs").tabs({
        heightStyle: "fill",
        activate: function (event, ui) {
            ui.newPanel.find(".editable").first().addClass("selected");
        }
    });

    //cargar tabla de fórmulas polinómicas

    function cargarTabla(id) {
        $.ajax({
            type: "POST",
            url: "${g.createLink(controller: 'contrato',action:'tablaFormula_ajax')}",
            data: {
                id: id,
                cntr: ${contrato.id}
            },
            success: function (msg) {
                $("#divTabla").html(msg);
            }
        });
    }

    $("#existentes").change(function () {
        var idFormula = $(this).val();
        cargarTabla(idFormula);
    });

    cargarTabla($("#existentes").val());


    function loading(div) {
        y = 0;
        $("#" + div).html("<div class='tituloChevere' id='loading'>Sistema Janus - Cargando, Espere por favor</div>");
        setInterval(function () {
            if (y === 30) {
                $("#detalle").html("<div class='tituloChevere' id='loading'>Cargando, Espere por favor</div>");
                y = 0
            }
            $("#loading").append(".");
            y++
        }, 500);
        return interval
    }


    %{--/*--}%
    %{-- $("#btnCopiar").click(function () {--}%

    %{-- if (confirm("Está seguro de copiar la fórmula polinómica?")) {--}%

    %{-- $.ajax({--}%
    %{-- type : "POST",--}%
    %{-- url : "${g.createLink(controller: 'contrato',action:'copiarFormula')}",--}%
    %{-- data     : {--}%
    %{-- id: $("#lista").val()--}%
    %{-- },--}%
    %{-- success  : function (msg) {--}%
    %{-- var alerta;--}%
    %{-- if(msg == 'si'){--}%
    %{-- alert("Fórmula polinómica copiada correctamente");--}%
    %{-- window.location.reload(true)--}%
    %{-- }else{--}%
    %{-- alert("Error al copiar la fórmula polinómica")--}%
    %{-- }--}%
    %{-- }--}%
    %{-- });--}%
    %{-- }--}%

    %{-- });--}%
    %{-- */--}%

    dlgo = $("#forma-fprj" ).dialog({
        autoOpen: false,
        height: 300,
        width: 350,
        modal: true,
        buttons: {
            "Create an account": function () {
                envia();
            },
            Cancel: function() {
                dlgo.dialog( "close" );
            }
        }
    });

    function envia() {
        var valid = true;
        dlgo.dialog("close");
        dlgo.find("form").submit();
        return valid;
    }

    $("#btnCopiar").click(function () {
        var b = bootbox.dialog({
            id      : "dlgCreateEditCF",
            title   : "Crear Fórmula Polinómica",
            message : "Crear una fórmula polinómica adicional para este contrato?</br>" +
                      "Se creará la nueva fórmula en base a una existente.",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                guardar  : {
                    id        : "btnSave",
                    label     : "<i class='fa fa-check'></i> Crear",
                    className : "btn-success",
                    callback  : function () {

                        $.ajax({
                            type    : "POST",
                            url : "${createLink(action: 'fpReajuste_ajax')}",
                            data    : "&cntr=${contrato.id}",
                            success : function (msg) {
                                $("#ajx_frma").dialog("option","title", "Crear Fórmula").html(msg).show("puff", 100);
                            }
                        });
                        $("#ajx_frma").dialog("open");
                    } //callback
                } //guardar
            } //buttons
        }); //dialog
    });

    $("#ajx_frma").dialog({
        autoOpen  : false,
        resizable : false,
        title     : 'Crear un Perfil',
        modal     : true,
        draggable : false,
        width     : 600,
        position  : 'center',
        open      : function (event, ui) {
            $(".ui-dialog-titlebar-close").hide();
        },
        buttons   : {
            "Grabar"   : function () {
                $(this).dialog("close");
                $.ajax({
                    type    : "POST", url : "${createLink(action: 'grabaFprj')}",
                    data    : "&contrato.id=" + $('#cntr').val() + "&tipoFormulaPolinomica.id=" + $('#tipoFormulaPolinomica').val() +
                        "&descripcion=" + $('#descripcion').val() + "&copiarDe=" + $('#existentes').val(),
                    success : function (msg) {
                        location.reload();
                    }
                });
            },
            "Cancelar" : function () {
                $(this).dialog("close");
            }
        }
    });

</script>

</body>
</html>