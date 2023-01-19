<%@ page contentType="text/html;charset=UTF-8" %>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta name="layout" content="main">
    <title>Días laborables</title>

    <style type="text/css">
    div.mes {
        float  : left;
        margin : 0 0 10px 10px;
        height : 185px;
    }

    table.mes {
        border-collapse : collapse;
    }

    .dia {
        width      : 38px;
        text-align : center;
        cursor     : pointer;
    }

    .vacio {
        background-color : #AAAAAA;
    }

    .vacacion {
        background-color : #5CAACE;
    }

    h1 {
        text-align : center;
    }

    .demo {
        width      : 20px;
        height     : 20px;
        text-align : center;
        display    : inline-block;
    }

    .nombreMes {
        font-size : 18px;
    }
    </style>
</head>

<body>

<h1>
    <g:link class="link btn btn-info" controller="inicio" action="parametros" style="float: left">
        <i class="fa fa-arrow-left"></i>
        Parámetros
    </g:link>
    Año <g:select style="font-size:large;" name="anio" class="input-small" from="${anio - 5..anio + 5}" value="${params.anio}"/>
    <a href="#" class="btn btn-primary" id="btnCambiar"><i class="fa fa-exclamation"></i> Cambiar</a>
    <a href="#" class="btn btn-success" id="btnGuardar"><i class="fa fa-save"></i> Guardar</a>
</h1>

<div class="well">
    Los días marcados con <div class="demo vacacion">1</div> son no laborables. <br/>
    Para cambiar el estado de un día haga cilck sobre el mismo.<br/>
    Los cambios se guardarán únicamente haciendo click en el botón "Guardar".
</div>

<g:set var="mesAct" value="${null}"/>
<g:each in="${dias}" var="dia" status="i">
    <g:set var="mes" value="${meses[dia.fecha.format('MM').toInteger()]}"/>
    <g:set var="dia" value="${meses[dia.fecha.format('MM').toInteger()]}"/>
    <g:if test="${mes != mesAct}">
        <g:if test="${mesAct}">
            </table>
            </div>
        </g:if>
        <g:set var="mesAct" value="${mes}"/>
        <g:set var="num" value="${1}"/>
        <div class="mes">
        <table class="mes" border="1">
        <thead>
        <tr>
        <th class="nombreMes" colspan="7">${mesAct}</th>
                </tr>
        <tr>
            <th>Lun</th>
            <th>Mar</th>
            <th>Mié</th>
            <th>Jue</th>
            <th>Vie</th>
            <th>Sáb</th>
            <th>Dom</th>
        </tr>
        </thead>
    </g:if>
    <g:if test="${num % 7 == 1}">
        <tr>
    </g:if>
    <g:if test="${dia.fecha.format("dd").toInteger() == 1}">
        <g:if test="${dia.dia.toInteger() != 1}">%{--No empieza en lunes: hay q dibujar celdas vacias en los dias necesarios--}%
            <g:each in="${1..(dia.dia.toInteger() - 1 + (dia.dia.toInteger() > 0 ? 0 : 7))}" var="extra">
                <td class="vacio"></td>
                <g:set var="num" value="${num + 1}"/>
            </g:each>
        </g:if>
    </g:if>
    <td class="dia ${dia.ordinal == 0 ? 'vacacion' : ''}" data-fecha="${dia.fecha.format('dd-MM-yyyy')}" data-id="${dia.id}" title="${dia.fecha.format('dd-MM-yyyy')}">
        ${dia.fecha.format("dd")}
    </td>

    <g:set var="num" value="${num + 1}"/>

    <g:if test="${i == dias.size() - 1 || (i < dias.size() - 1) && (meses[dias[i + 1].fecha.format('MM').toInteger()] != mesAct)}">
        <g:if test="${dia.dia.toInteger() != 0}">
            <g:each in="${1..7 - (num % 7 > 0 ? num % 7 : 7) + 1}" var="extra">
                <td class="vacio"></td>
            </g:each>
        </g:if>
    </g:if>
</g:each>
</table>

<script type="application/javascript">
    $(function () {
        $(".dia").click(function () {
            $(this).toggleClass("vacacion");
        });
        $("#anio").val("${params.anio}");
        $("#btnCambiar").click(function () {
            var anio = $("#anio").val();
            if ("" + anio !== "${params.anio}") {
                var v = cargarLoader("Guardando...");
                location.href = "${createLink(action: 'calendario')}?anio=" + anio;
            }
            return false;
        });
        $("#btnGuardar").click(function () {
            var g = cargarLoader("Guardando...");
            var cont = 1;
            var data = "";
            $(".dia").each(function () {
                var $dia = $(this);
                var fecha = $dia.data("fecha");
                var id = $dia.data("id");
                var laborable = !$dia.hasClass("vacacion");
                if (data !== "") {
                    data += "&";
                }
                data += "dia=" + id + ":" + fecha + ":";
                if (laborable) {
                    data += cont;
                    cont++;
                } else {
                    data += "0";
                }
            });
            $.ajax({
                type    : "POST",
                url     : "${createLink(action: 'saveCalendario')}",
                data    : data,
                success : function (msg) {
                    if (msg === "OK") {
                        var h = cargarLoader("Cargando...");
                        location.reload();
                    } else {
                        var e = bootbox.alert({
                            message: 'Error al guardar guardar el calendario',
                            callback: function () {
                                var dialog2 = cargarLoader("Cargando...");
                                location.reload();
                            }
                        });
                    }
                }
            });
            return false;
        });
    });
</script>
</body>
</html>