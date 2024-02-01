<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/11/13
  Time: 3:17 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        %{--<script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>--}%
        %{--<script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>--}%
        <title>Subir archivo excel composición</title>
    </head>

    <body>
        <g:if test="${flash.message}">
            <div class="alert alert-error">
                ${flash.message}
            </div>
        </g:if>

        <g:uploadForm action="uploadFile" method="post" name="frmUpload" id="${obra}" style="padding: 10px">
            <g:hiddenField name="id" value="${obra}"/>
            <div id="list-grupo" class="col-md-12" role="main" style="margin: 10px 0 0 0;">
                <div class="" style="margin: 0 0 20px 0;">
                    <div class="col-md-9">
                        El archivo debe contener al menos 5 columnas (los nombres de las columnas no son importantes):
                        <table class="table" style="background-color: #5a7ab2; color: #fff">
                            <tr>
                                <th style="border: 1px solid #ddd; text-align: center">
                                    CODIGO
                                </th>
                                <th style="border: 1px solid #ddd; text-align: center">
                                    ITEM
                                </th>
                                <th style="border: 1px solid #ddd; text-align: center">
                                    UNIDAD
                                </th>
                                <th style="border: 1px solid #ddd; text-align: center">
                                    CANTIDAD
                                </th>
                                <th style="border: 1px solid #ddd; text-align: center">
                                    NUEVA CANTIDAD
                                </th>
                            </tr>
                        </table>

                        El ítem es ubicado por código<br/>
                        La columna que va a ser tomada para modificar la cantidad de cada rubro es la "Nueva cantidad"
                        (la columna que esté en la columna E del archivo Excel)<br/>
                    </div>
                </div>

                    <div class="col-md-6" style="margin-top: 20px">
                        <div class="col-md-2"><b>Archivo:</b></div>
                        <input type="file" class="required" id="file" name="file"/>
                    </div>
           </div>

            %{--<div style="margin-left: 0px; margin-top: 10px">--}%
                <div class="col-md-12" style="margin-top: 20px">
                    <a href="#" class="btn btn-success" id="btnSubmit">Subir</a>
                </div>
            %{--</div>--}%
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