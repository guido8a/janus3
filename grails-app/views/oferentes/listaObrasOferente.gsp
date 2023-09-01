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
<div class="row-fluid" style="margin-top:15px">
        <table class="table table-hover table-bordered table-striped">
            <thead>
            <tr>
                <th style="width: 40%;">Obra</th>
                <th style="width: 30%;">Oferente</th>
                <th style="width: 15%;">Concurso</th>
                <th style="width: 10%;">Estado</th>
                <th style="width: 5%;">Obra</th>
            </tr>
            </thead>

        </table>
</div>

<div class="row-fluid"  style="width: 99.7%;height: 500px;overflow-y: auto;float: right; margin-top: -20px">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <tbody>
        <g:each in="${obras}" var="obra" status="i">
            <tr>
                <td style="width: 40%;">${obra?.obra?.descripcion}</td>
                <td style="width: 30%;">${obra?.oferente?.nombre + " " + obra?.oferente?.apellido}</td>
                <td style="width: 15%;">${obra?.concurso?.codigo}</td>
                <td style="width: 10%;">${obra?.estado == 'N' ? 'No copiado' : 'Copiado' }</td>
                <td style="width: 5%; text-align: center"><a href="#" class="btn btn-info btn-xs btnIrObra" title="Ir a la obra" data-id="${obra?.obra?.id}"><i class="fa fa-edit"></i></a> </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(".btnIrObra").click(function () {
        var d = cargarLoader("Cargando...");
        var id = $(this).data("id");
       location.href="${createLink(controller: 'obra', action: 'registroObra')}?obra=" + id
    });

</script>

</body>
</html>