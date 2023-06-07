<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Ha ocurrido un error</title>
    </head>

    <body>
        <div class="alert alert-error alert-block">
            <elm:poneHtml textoHtml="${flash.message}" />
            <br/><br/> <elm:poneHtml textoHtml="${params.link ?: ""}" />
        </div>
    </body>
</html>