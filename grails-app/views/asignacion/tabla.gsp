<div class="col-md-12" style="margin-bottom: 8px" >
    <h3> <span class="col-md-2 badge badge-info">Asignaciones del año</span></h3>
    <div class="col-md-3">
        <g:select class="form-control" name="anios" id="tabla_anio" from="${janus.pac.Anio.list(sort: 'anio')}" value="${anio?.anio ?: new Date().format("yyyy")}" optionKey="anio" optionValue="anio" style="width: 100px;"/>
    </div>
</div>

<table class="table table-bordered table-striped table-condensed table-hover">
    <thead>
    <tr>
        <th style="width:320px;">Partida</th>
        <th style="width:90px;">Fuente</th>
        <th style="width:180px;">Programa</th>
        <th style="width:180px;">Subprograma</th>
        <th style="width:220px;">Proyecto</th>
        <th style="width:30px;">Año</th>
        <th style="width:80px;">Valor</th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 400px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:if test="${asignaciones.size() > 0}">
            <g:each in="${asignaciones}" var="asg">
                <tr>
                    <td style="width:320px;">${asg?.prespuesto?.descripcion} <strong style="color: #0d7bdc">(${asg.prespuesto.numero})</strong> </td>
                    <td style="width:90px;">${asg.prespuesto.fuente}</td>
                    <td style="width:180px;">${asg.prespuesto.programa}</td>
                    <td style="width:180px;">${asg.prespuesto.subPrograma}</td>
                    <td style="width:220px;">${asg.prespuesto.proyecto}</td>
                    <td style="text-align: center; width:30px">${asg.anio.anio}</td>
                    <td style="text-align: right; width:80px">
                        <g:formatNumber number="${asg.valor}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                    </td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <tr>
                <td class="alert alert-info" colspan="7" style="text-align: center"> <h3><i class="fa fa-exclamation-triangle"></i> No exiten registros</h3> </td>
            </tr>
        </g:else>
        </tbody>
    </table>
</div>


<script type="text/javascript">
    $("#tabla_anio").change(function(){
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'asignacion',action:'tabla')}",
            data     :   "anio="+$("#tabla_anio").val(),
            success  : function (msg) {
                $("#list-Asignacion").html(msg)
            }
        });
    })
</script>