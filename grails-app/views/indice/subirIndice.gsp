
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Subir archivo de Índices</title>
</head>

<body>
<div class="span4" style="margin-left: 200px; margin-top: 20px">
    <fieldset class="col-md-6" style="position: relative; height: 120px; float: left;padding: 10px;border-bottom: 1px solid black; border-top: 1px solid black">

        <g:uploadForm action="uploadFile" method="post" name="frmUpload" enctype="multipart/form-data">
            <div class="col-md-12"  style="margin-top: 10px; margin-bottom: 20px">
                <div class="fieldcontain required">
                    <input type="file" id="file" name="file"/>
                </div>
            </div>
            <div class="col-md-5">
                Seleccione el periodo a subir:
            </div>
            <div class="col-md-5">
                <g:select name="periodo" from="${janus.pac.PeriodoValidez.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion" class="form-control"/>
            </div>
       </g:uploadForm>

        <div class="col-md-2 btn-group" role="navigation">
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