
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Subir archivo de Índices</title>
</head>

<body>
<div class="span4" style="margin-left: 200px; margin-top: 20px">
    <fieldset class="col-md-8" style="position: relative; height: 250px; float: left;padding: 10px;border-bottom: 1px solid black; border-top: 1px solid black">

        <g:uploadForm action="uploadFile" method="post" name="frmUpload" enctype="multipart/form-data">
            <div class="col-md-12"  style="margin-top: 10px; margin-bottom: 20px">
                <div class="fieldcontain required">
                    <input type="file" id="file" name="file"/>
                </div>
            </div>
            <div>El valor del índice a a subir al sistema debe estar en la <strong>columna F</strong> de la hoja de cálculo <br/>
            Ipco_indices_de_la_construccion_Nacional
            </div>
            <div>
                <h4>Distribución de columnas del Excel a subir:</h4>
                <table border="1"  style="text-align: center; width: 100%">
                    <tr>
                        <td>Col A:</td>
                        <td>Col B: DENOMINACIÓN</td>
                        <td>Col C: *</td>
                        <td>Col D:<br>MES AÑO ANTERIOR</td>
                        <td>Col E:<br>MES ANTERIOR</td>
                        <td><strong>Col F:<br>MES ACTUAL</strong></td>
                    </tr>
                </table>
            </div>
            <div class="col-md-5" style="margin-top: 30px">
                Seleccione el periodo a subir:
            </div>
            <div class="col-md-5" style="margin-top: 30px">
                <g:select name="periodo" from="${janus.pac.PeriodoValidez.list([sort: 'id', order: 'desc'])}" optionKey="id" optionValue="descripcion" class="form-control"/>
            </div>
       </g:uploadForm>

        <div class="col-md-2 btn-group" role="navigation" style="margin-top: 30px">
            <button class="btn btn-success" id="aceptar"><i class="fa fa-upload"></i> Aceptar</button>
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    $("#aceptar").click(function () {
        $("#frmUpload").submit();
    });
</script>

</body>
</html>