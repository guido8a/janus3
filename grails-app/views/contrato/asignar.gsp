<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <meta name="layout" content="main">

    %{--    <script src="${resource(dir: 'js/jquery/plugins/', file: 'jquery.livequery.js')}"></script>--}%

    %{--    <link rel="stylesheet" href="${resource(dir: 'css', file: 'tableHandler.css')}">--}%

    <style type="text/css">

    .formato {
        font-weight : bolder;
        font-size: large;
    }

    .warning {
        color: #169;
    }

    </style>


    <title>Asignar F. Polinómica</title>
</head>

<body>

<div class="row" style="margin-bottom: 10px;">
    <div class="span9 btn-group" role="navigation">
        <g:link controller="contrato" action="registroContrato" params="[contrato: contrato?.id]" class="btn btn-info btn-new" title="Regresar al contrato">
            <i class="fa fa-arrow-left"></i>
            Contrato
        </g:link>
        <a href="#" class="btn btn-success" id="btnGuardar"><i class="fa fa-save"></i> Guardar</a>

    </div>
</div>

<div id="divTabla">

    <h3 style="text-align: center">Asignación de las Fórmulas Polinómicas</h3>
    <div style="min-height: 40px; font-size: 16px; text-align: center;"> <span>Contrato:</span> <span class="titulo" style="display: inline-block; width: 90%; vertical-align:top; margin-bottom: 20px; "> ${contrato?.objeto}</span>
    </div>
    <div class="span12" style="margin-top: 10px" id="dirSalida">

        <div class="borde_abajo" style="position: relative;float: left;width: 95%;">

            <div class="col-md-12 formato text-info" style="margin-bottom: 5px;">
                <div class="col-md-6">Subpresupuestos de la Obra</div>
                <div class="col-md-6">Fórmula Polinómica a utilizar</div>
            </div>

            <g:if test="${fpsp}">
                <g:each in="${fpsp}" var="fp" status="i">
                    <div class="col-md-12" style="margin-bottom: 10px">
                        <div class="col-md-6 formato">
                            <g:textField name="sub_${fp}" class="subi form-control" value="${fp?.subPresupuesto?.descripcion}"
                                         data-id="${fp?.id}" readonly="true" title="${fp?.subPresupuesto?.descripcion}"/>
                        </div>

                        <div class="col-md-6 formato">
                            <g:select name="pol_${fp.reajuste.id}" from="${formulas}" optionKey="id" id="${formulas.id}"
                                      original="${fp?.reajuste?.id}" data-id="${fp?.id}"
                                      sbpr="${fp.id}" optionValue="descripcion" class="formula form-control" value="${fp.reajuste.id}"
                                      title="Fórmulas Polinómicas"/>

                        </div>
                    </div>
                </g:each>
            </g:if>
            <g:else>
                <div class="col-md-12 alert alert-info" style="text-align: center" >No existen registros</div>
            </g:else>
        </div>
    </div>
</div>

<script type="text/javascript">

    $("#btnGuardar").click(function () {
        var data = {};
        $(".cambiado").each(function () {
            var $input = $(this);
            data["id_" + $input.data("id")] = $input.val();
        });
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'saveAsignarFormula')}",
            data    : data,
            success : function (msg) {
                if(msg === 'si'){
                    alert("Fórmulas polinómicas asignadas correctamente");
                    window.location.reload(true)
                }else{
                    alert("Error al asignar las fórmulas polinómicas")
                }
            }
        });
    });

    $(".formula").change(function(){
        var $fp = $(this);
        var valOrig = $fp.attr("original");
        var val = $.trim($fp.val());
        if (valOrig !== val) {
            $fp.addClass("warning");
            $fp.addClass("cambiado");
        } else {
            $fp.removeClass("warning");
            $fp.removeClass("cambiado");
        }
    });

</script>

</body>
</html>