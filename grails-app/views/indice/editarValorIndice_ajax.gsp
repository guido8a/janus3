<g:form class="form-horizontal" name="frmSave-ValorIndice" action="saveValorIndice_ajax">
    <g:hiddenField name="id" value="${valorIndice?.id}"/>
    <g:hiddenField name="indice" value="${indice?.id}"/>
    <g:hiddenField name="periodo" value="${periodo?.id}"/>

    <div class="form-group ${hasErrors(bean: valorIndice, field: 'valor', 'error')} ">
        <span class="grupo">
            <div class="col-md-2"></div>
            <label for="valor" class="col-md-2 control-label text-info">
               Valor
            </label>
            <span class="col-md-4">
                <g:textField name="valor" class="form-control number required" value="${valorIndice?.valor ?: 0}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>