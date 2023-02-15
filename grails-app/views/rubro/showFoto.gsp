<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${titulo} - ${rubro?.nombre}</title>

    <asset:javascript src="/jquery/jquery-2.2.4.js"/>
    <asset:javascript src="/jquery/jquery-ui-1.10.2.custom.js"/>
    <asset:stylesheet src="/bootstrap-3.3.2/dist/css/bootstrap.css"/>
    <asset:stylesheet src="/bootstrap-3.3.2/dist/css/bootstrap-theme.css"/>
    <asset:javascript src="/apli/fontawesome.all.min.js"/>
    <asset:stylesheet src="/apli/font-awesome.min.css"/>
    <asset:javascript src="/apli/functions.js"/>
    <asset:stylesheet src="/jquery/jquery-ui-1.10.3.custom.min.css"/>
    <asset:stylesheet src="/apli/custom.css"/>
    <asset:stylesheet src="/apli/CustomSvt.css"/>

%{--    <link href='${resource(dir: "font/open", file: "stylesheet.css")}' rel='stylesheet' type='text/css'>--}%
%{--    <link href='${resource(dir: "font/tulpen", file: "stylesheet.css")}' rel='stylesheet' type='text/css'>--}%

    <link href="${resource(dir: 'css', file: 'mobile2.css')}" rel="stylesheet">
    <script src="${resource(dir: 'js/jquery/plugins', file: 'jquery.highlight.js')}"></script>

%{--    <link href="${resource(dir: 'css', file: 'customButtons.css')}" rel="stylesheet">--}%
</head>

<body style="padding: 20px;">
<g:if test="${flash.message}">
    <div class="row">
        <div class="span12">
            <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                <a class="close" data-dismiss="alert" href="#">×</a>
                ${flash.message}
            </div>
        </div>
    </div>
</g:if>
<div class="alert alert-info col-md-12">
    Código: ${rubro?.codigo}<br/>
    Especificación: ${rubro?.codigoEspecificacion}<br/>
    Nombre: ${rubro?.nombre}
</div>
<fieldset class="borde_abajo" style="position: relative;width: 670px;padding-left: 50px;">
    <div class="linea" style="height: 98%;"></div>
    <p class="css-vertical-text">Archivo</p>
    <g:uploadForm action="uploadFile" method="post" name="frmUpload" enctype="multipart/form-data">
        <g:hiddenField name="tipo" value="${tipo}"/>
        <g:hiddenField name="rubro" value="${rubro?.id}"/>
        <div class="fieldcontain required">
            <b>Cargar archivo:</b>
            <input type="file" id="file" name="file" class=""/>

            <div class="btn-group" style="margin-top: 20px;">
                <a href="#" id="submit" class="btn btn-success">
                    <i class="fa fa-save"></i> Guardar
                </a>
            </div>

            <div class="btn-group" style="margin-top: 20px;">
                <g:if test="${filePath}">
                    <g:if test="${tipo == 'il'}">
                        <g:link action="downloadFile" id="${rubro.id}" params="[tipo: tipo]" class="btn btn-info">
                            <i class="fa fa-arrow-down"></i> Descargar
                        </g:link>
                    </g:if>
                    <g:if test="${tipo == 'dt'}">
                        <g:link action="downloadFileAres" id="${ares}" params="[tipo: tipo, rubro: rubro.id]" class="btn btn-info">
                            <i class="fa fa-arrow-down"></i> Descargar
                        </g:link>
                    </g:if>
                </g:if>
            </div>
            <div class="btn-group" style="margin-top: 20px;">
                <a href="#" id="salir" class="btn btn-primary">
                    <i class="fa fa-times"></i> Salir
                </a>
            </div>
        </div>

    </g:uploadForm>

    <div class="alert alert-info">
        <g:if test="${!filePath}">
            <p style="color: #800">No se ha cargado ningún archivo para este rubro</p>
        </g:if>
        <g:else>
           Archivo actual: <strong> ${filePath} </strong>
        </g:else>
    </div>

</fieldset>
<g:if test="${ext?.toLowerCase() == 'pdf'}">
    <div class="alert alert-warning">
        <p style="color: #000; font-size: 14px;">  <i class="fa fa-exclamation-triangle text-info fa-2x"></i>El archivo cargado para este rubro es un pdf. Por favor descárguelo para visualizarlo.</p>
    </div>
</g:if>
<g:elseif test="${ext != ''}">
    <fieldset style="width: 650px;min-height: 500px;margin: 10px;position: relative;padding-left: 50px;" class="borde_abajo">
        <p class="css-vertical-text">
            Foto
        </p>

        <div class="linea" style="height: 98%;"></div>
        %{--<img src="${resource(dir: 'rubros', file: filePath)}" alt="" style="margin-bottom: 10px;max-width: 600px"/>--}%
        <img src="${request.contextPath}/rubro/getFoto?ruta=${filePath}"/>
    </fieldset>
</g:elseif>
<script type="text/javascript">
    $("#submit").click(function () {
        $("#frmUpload").submit();
    });
    $("#salir").click(function () {
        window.close()
    });
</script>

</body>
</html>