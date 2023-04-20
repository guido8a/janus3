<g:form class="form-horizontal" name="frmSave-ValorIndice" action="saveValorIndice_ajax">
    <g:hiddenField name="item" value="${item?.id}"/>
    <g:hiddenField name="obra" value="${obra?.id}"/>

    <div class="alert alert-info">Ingrese el nuevo valor del VAE(%)</div>

    <div class="form-group  ">
        <span class="grupo">
            <span class="col-md-2"></span>
            <label for="valor" class="col-md-2 control-label text-info">
                Valor
            </label>
            <span class="col-md-4">
                <g:textField name="valor" class="form-control number required" value="${0}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>