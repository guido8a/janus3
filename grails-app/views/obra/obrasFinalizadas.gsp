<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <meta name="layout" content="main">

    <style type="text/css">

    .formato {
        font-weight : bolder;
    }

    .titulo {
        font-size : 20px;
    }

    .error {
        background : #c17474;
    }

    .mover {

    }

    .editable {
        border-bottom : 1px dashed;
    }

    .error {
        background  : inherit !important;
        border      : solid 2px #C17474;
        font-weight : bold;
        padding     : 10px;
    }
    </style>

    <title>OBRAS FINALIZADAS</title>
</head>

<body>


<div class="span12">
    <a href="#" class="btn btn-primary col-md-1" id="regresar">
        <i class=" fa fa-arrow-left"></i>
        Regresar
    </a>

    <div class="col-md-3">
        <b>Buscar Por:</b>
        <g:select name="buscador" id="buscador" from="${[0: 'Código', 1: 'Nombre', 2: 'Descripción', 3: 'Memo Ingreso', 4: 'Memo Salida', 5: 'Sitio', 6: 'Parroquia', 7: 'Comunidad' , 8 : 'Dirección' , 9: 'Fecha' ]}" optionKey="key" optionValue="value" />
    </div>

    <div class="col-md-4 hide" id="divFecha">
        <b>Fecha: </b>
        <input aria-label="" name="fecha" id='fecha' type='text' class="input-small" value="${params.fecha?.format("dd-MM-yyyy")}" />
    </div>
    <div class="col-md-4" id="divCriterio">
        <b>Criterio: </b>
        <g:textField name="criterio" id="criterio" value="${params.criterio ?: ''}" style="width: 250px;"/>
    </div>

    <div>
        <a href="#" class="btn btn-success" id="buscar">
            <i class="fa fa-search"></i>
            Buscar
        </a>
        <a href="#" class="btn btn-info" id="imprimir" >
            <i class="fa fa-print"></i>
            Imprimir
        </a>
        <a href="#" class="btn btn-success" id="excel" >
            <i class="fa fa-file-excel"></i>
            Excel
        </a>
    </div>
</div>

<div style="margin-top: 15px; min-height: 300px">
    <table class="table table-bordered table-hover table-condensed" style="width: 100%; background-color: #a39e9e">
        <thead>
        <tr>
            <th style="width: 7%;">
                Código
            </th>
            <th style="width: 7%;">
                Nombre
            </th>
            <th style="width: 7%;">
                Dirección
            </th>
            <th style="width: 7%;">
                Fecha Reg.
            </th>
            <th style="width: 18%;">
               Sitio
            </th>
            <th style="width: 7%;">
                Parroquia -  Comunidad
            </th>
            <th style="width: 7%;">
                Fecha Inicio
            </th>
            <th style="width: 7%;">
                Fecha Fin
            </th>
        </tr>
        </thead>
    </table>
    <div id="detalle">
    </div>
</div>

<script  type="text/javascript">

    $("#buscador").change(function () {
        var seleccionado = $(this).val();
        if( seleccionado === '9'){
            $("#divFecha").removeClass("hide");
            $("#divCriterio").addClass("hide");
        }else{
            $("#divCriterio").removeClass("hide");
            $("#divFecha").addClass("hide");
            $("#fecha").val('');
        }
    });

    $('#fecha').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    cargarTabla();

    function cargarTabla() {
        var d = cargarLoader("Cargando...");
        var datos = "&buscador=" + $("#buscador").val() + "&criterio=" + $("#criterio").val() + "&fecha=" + $("#fecha").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'obra',action:'tablaObrasFinalizadas')}",
            data     : datos,
            success  : function (msg) {
                d.modal("hide");
                $("#detalle").html(msg)
            }
        });
    }

    $("#buscar").click(function(){
        cargarTabla();
    })



</script>





%{--<fieldset class="borde" style="position: relative; height: 600px;float: left">--}%
%{--    <g:hiddenField name="id" value="${obra?.id}"/>--}%
%{--    <div class="span12" style="margin-top: 15px" align="center">--}%
%{--    </div>--}%
%{--    <div style="width: 1150px;margin: auto;overflow: auto">--}%
%{--        <bsc:buscador name="obras" value="" accion="buscarObraFin" controlador="obra" campos="${campos}" label="Obra" tipo="lista"/>--}%
%{--    </div>--}%
%{--</fieldset>--}%
</body>
</html>