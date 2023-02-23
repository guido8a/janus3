<g:if test="${tipoFormulaPolinomicaInstance?.codigo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Código
        </div>
        <div class="col-md-6">
            ${tipoFormulaPolinomicaInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${tipoFormulaPolinomicaInstance?.descripcion}">
    <div class="row">
        <div class="col-md-2 text-info">
            Descripción
        </div>
        <div class="col-md-8">
            ${tipoFormulaPolinomicaInstance?.descripcion}
        </div>
    </div>
</g:if>