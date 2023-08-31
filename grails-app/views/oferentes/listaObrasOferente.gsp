<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de obras de oferentes</title>
</head>
<body>
<div class="row">
    <div class="col-md-12">
        <h1>
            Obras de oferentes
        </h1>
    </div>
</div>
<div class="row" style="margin-top:15px">
    <div class="col-md-12">
        <table class="table table-hover table-bordered table-striped">
            <thead>
            <tr>
                <th style="width: 45%;">Obra</th>
                <th style="width: 30%;">Oferente</th>
                <th style="width: 15%;">Concurso</th>
                <th style="width: 10%;">Estado</th>
            </tr>
            </thead>

        </table>
    </div>
</div>

<div class="row-fluid"  style="width: 99.7%;height: 500px;overflow-y: auto;float: right; margin-top: -20px">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <tbody>
        <g:each in="${obras}" var="obra" status="i">
            <tr>
                <td style="width: 45%;">${obra?.obra?.descripcion}</td>
                <td style="width: 30%;">${obra?.oferente?.nombre + " " + obra?.oferente?.apellido}</td>
                <td style="width: 15%;">${obra?.concurso?.codigo}</td>
                <td style="width: 10%;">${obra?.estado}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>


</body>
</html>