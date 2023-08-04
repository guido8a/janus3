%{--garantias: ${garantias ? garantias.size() : 0}--}%
%{--${garantias ? garantias[-1] : ''}--}%

<g:if test="${garantias}">
    <div id="show-garantia" class="span5" role="main">
        <form class="form-horizontal">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-3 control-label text-info">
                        Contrato
                    </label>
                    <span class="col-md-3">
                        ${contrato?.codigo}
                    </span>
                </span>
            </div>
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-3 control-label text-info">
                        Número de garantía
                    </label>
                    <span class="col-md-8">
                        ${garantias[-1]?.numeroGarantia}
                    </span>
                </span>
            </div>
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-3 control-label text-info">
                        Concepto de garantía
                    </label>
                    <span class="col-md-8">
                        ${garantias[-1]?.conceptoGarantia}
                    </span>
                </span>
            </div>
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-3 control-label text-info">
                       Monto
                    </label>
                    <span class="col-md-8">
                        ${garantias[-1]?.monto}
                    </span>
                </span>
            </div>
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-3 control-label text-info">
                        Emisor
                    </label>
                    <span class="col-md-8">
                        ${garantias[-1]?.emisor}
                    </span>
                </span>
            </div>
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-3 control-label text-info">
                        Tipo de Garantía
                    </label>
                    <span class="col-md-8">
                        ${garantias[-1]?.tipoGarantia}
                    </span>
                </span>
            </div>
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-3 control-label text-info">
                        Estado
                    </label>
                    <span class="col-md-8">
                        ${garantias[-1]?.estado}
                    </span>
                </span>
            </div>
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-3 control-label text-info">
                        Fecha de la Garantía
                    </label>
                    <span class="col-md-8">
                        ${garantias[-1]?.fechaGarantia}
                    </span>
                </span>
            </div>
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-3 control-label text-info">
                        Fecha desde
                    </label>
                    <span class="col-md-8">
                        ${garantias[-1]?.desde}
                    </span>
                </span>
            </div>
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-3 control-label text-info">
                        Fecha hasta
                    </label>
                    <span class="col-md-8">
                        ${garantias[-1]?.hasta}
                    </span>
                </span>
            </div>
        </form>
    </div>
</g:if>
<g:else>
    <div id="show-garantia" class="span5" role="main">
        <form class="form-horizontal">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-12 control-label text-info">
                       No se encontró ninguna garantía para el contrato
                    </label>
                </span>
            </div>
        </form>
    </div>
</g:else>


