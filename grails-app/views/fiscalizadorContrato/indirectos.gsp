<%@ page import="janus.Departamento" %>

<div class="container">
    <div class="col-md-12">
        <g:form class="registroContrato" name="frmaIndi" action="guardarIndirectos">
            <g:hiddenField name="cntr" value="${cntr.id}"/>
                <div class="col-md-2 formato">Porcentaje de costos indirectos</div>

                <div class="col-md-2">
                    <g:textField name="indirectos" class="number form-control"
                                 value="${g.formatNumber(number: cntr?.indirectos, maxFractionDigits: 2, minFractionDigits: 2,
                                         format: '##,##0', locale: 'ec')}"/>
                </div>
        </g:form>
    </div>
</div>


