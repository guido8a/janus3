<%@ page import="janus.ejecucion.ValorIndice" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Valores de Índices</title>
</head>

<body>
<div class="btn-toolbar " style="margin-bottom: 10px">
    <div class="btn-group col-md-12">
        <div class="col-md-2">
            <a href="${g.createLink(action: 'editarIndices')}" class="btn btn-info" title="Regresar">
                <i class="fa fa-arrow-left"></i>
                Editar Valores
            </a>
        </div>

        <g:form name="forma" action="valorIndice">
            <div class="col-md-2">
                <g:select id="id" name="anio" from="${janus.pac.Anio.list([sort: 'anio'])}" optionKey="id" optionValue="anio" class="form-control"  value="${anio}" />
            </div>
            <div class="col-md-2">
                <a id="consultar" href="#" class="btn btn-success" title="Consultar" >
                    <i class="fa fa-search"></i>Consultar
                </a>
            </div>
        </g:form>
    </div>
</div>

<div>
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th>Índice</th>
            <th>Enero</th>
            <th>Febrero</th>
            <th>Marzo</th>
            <th>Abril</th>
            <th>Mayo</th>
            <th>Junio</th>
            <th>Julio</th>
            <th>Agosto</th>
            <th>Septiembre</th>
            <th>Octubre</th>
            <th>Noviembre</th>
            <th>Diciembre</th>
        </thead>

    </table>

    <div class="row-fluid"  style="width: 99.7%;height: 500px;overflow-y: auto;float: right; margin-top: -20px">
        <table class="table table-bordered table-striped table-condensed table-hover">
            <tbody>
            <g:each in="${datos}" var="val" status="j">
                <tr class="item_row">
                    <td style="width: 300px;">${val.indcdscr}</td>
                    <td style="width: 50px;text-align: right">${val.enero ?: ''}</td>
                    <td style="width: 50px;text-align: right">${val.febrero ?: ''}</td>
                    <td style="width: 50px;text-align: right">${val.marzo ?: ''}</td>
                    <td style="width: 50px;text-align: right">${val.abril ?: ''}</td>
                    <td style="width: 50px;text-align: right">${val.mayo ?: ''}</td>
                    <td style="width: 50px;text-align: right">${val.junio ?: ''}</td>
                    <td style="width: 50px;text-align: right">${val.julio ?: ''}</td>
                    <td style="width: 50px;text-align: right">${val.agosto ?: ''}</td>
                    <td style="width: 50px;text-align: right">${val.septiembre ?: ''}</td>
                    <td style="width: 50px;text-align: right">${val.octubre ?: ''}</td>
                    <td style="width: 50px;text-align: right">${val.noviembre ?: ''}</td>
                    <td style="width: 50px;text-align: right">${val.diciembre ?: ''}</td>
                </tr>
            </g:each>
            </tbody>

        </table>
    </div>


</div>
%{--${params.valorIndices}--}%
<div class="modal hide fade" id="modal-Indice">
    <div class="modal-header" id="modalHeader">
        <button type="button" class="close darker" data-dismiss="modal">
            <i class="icon-remove-circle"></i>
        </button>

        <h3 id="modalTitle"></h3>
    </div>

    <div class="modal-body" id="modalBody">
    </div>

    <div class="modal-footer" id="modalFooter">
    </div>
</div>
<script type="text/javascript">
    $(function() {
        $("#consultar").click(function () {
            forma.submit();
        });
    });
</script>
</body>
</html>