
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Subir archivo excel PAC</title>

    <style type="text/css">
    .error {
        color            : darkred !important;
        background-color : #DDC2BE !important;
    }
    </style>

</head>

<body>

<g:if test="${flash.message}">
    <div class="alert alert-error">
        ${flash.message}
    </div>
</g:if>

<g:uploadForm action="uploadFile" method="post" name="frmUpload">
    <div id="list-grupo" class="col-md-12" role="main" style="margin-top: 10px;margin-left: 0px">

        <g:link controller="pac" action="registrarPac" class="btn btn-info">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </g:link>

        <div class="col-md-12 alert alert-info" style="margin-left: 0px; margin-top: 5px">
            <div class="col-md-4">
                <b>Requirente:</b>
                <g:textField class="required form-control" name="requirente" maxlength="100" style="width: 250px; font-size: 12px;"/>
            </div>

            <div class="col-md-3">
                <b>Memorando:</b>
                <g:textField class="allCaps required form-control" name="memo" maxlength="20" style="width: 156px; font-size: 12px;"/>
            </div>

            <div class="col-md-5">
                <b>Coordinación:</b>
                <input type="hidden" id="item_id">
                <g:select name="coordinacion" from="${janus.Departamento.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion" class="form-control" style="font-size: 12px;"/>
            </div>
        </div>

        <div class="col-md-12" style="margin-top: 5px">
            <p><b>Reglas a seguir para el archivo Excel:</b></p>
            <ul>
                <li style="font-size: large; font-style: italic; font-weight: bold">Cada archivo debe ser de una sola coordinación</li>
                <li style="font-size: large">Puede tener varias hojas</li>
                <li style="font-size: large">Los tipos de compra aceptados son <b>obra</b> y <b>consultoria</b> (sin importar mayúsculas y minúsculas)</li>
                <li style="font-size: large">Al terminar de procesar su archivo se mostrará un resumen de las filas procesadas</li>
                <li style="font-size: large">Las columnas deben ser las siguientes (todas las columnas de cantidad y costo deben tener un valor):</li>
            </ul>
        </div>

        <div class="row-fluid" style="margin-left: 1px">
            <div class="span12">
                <div class="span12">
                    <table class="table table-bordered table-condensed">
                        <thead>
                        <tr>
                            <th>A</th>
                            <th>B</th>
                            <th>C</th>
                            <th>D</th>
                            <th>E</th>
                            <th>F</th>
                            <th>G</th>
                            <th>H</th>
                            <th>I</th>
                            <th>J</th>
                            <th>K</th>
                            <th>L</th>
                            <th>M</th>
                            <th>N</th>
                        </tr>
                        </thead>
                        <tbody class="centrado">
                        <tr>
                            <td>AÑO</td>
                            <td>PARTIDA PRESUPUESTARIA / CUENTA CONTABLE</td>
                            <td>CODIGO CATEGORIA CPC A NIVEL 8</td>
                            <td>TIPO COMPRA (Bien, obra, servicio o consultoría)</td>
                            <td>DETALLE DEL PRODUCTO (Descripción de la contratación)</td>
                            <td>CANTIDAD ANUAL</td>
                            <td>UNIDAD (metro, litro etc)</td>
                            <td>COSTO UNITARIO (PORTAL)</td>
                            <td>COSTO UNITARIO (A SUMAR) **No se carga el dato</td>
                            <td>COSTO TOTAL **No se carga el dato</td>
                            <td>CUATRIMESTRE 1
                            (marcar con una S en el cuatrimestre que va a contratar)</td>
                            <td>CUATRIMESTRE 2
                            (marcar con una S en el cuatrimestre que va a contratar)</td>
                            <td>CUATRIMESTRE 3
                            (marcar con una S en el cuatrimestre que va a contratar)</td>
                            <td>OBSERVACIONES **No se usa</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>

    <div class="col-md-12" style="margin-left: 0px">
        <div class="col-md-3">
            <div ><b>Archivo:</b></div>
            <input type="file" class="required" id="file" name="file"/>
        </div>
        <div class="col-md-2">
            <a href="#" class="btn btn-success" id="btnSubmit" title="Cargar archivo de excel"><i class="fa fa-upload"></i> Subir</a>
        </div>
    </div>
</g:uploadForm>

<script type="text/javascript">
    $(function () {
        $("#frmUpload").validate({

        });

        $("#btnSubmit").click(function () {
            if ($("#frmUpload").valid()) {
                $(this).replaceWith(spinner);
                $("#frmUpload").submit();
            }
        });
    });
</script>

</body>
</html>