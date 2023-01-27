<%@ page import="janus.SubgrupoItems" %>

<fieldset class="borde">
    <legend>${subgrupoItemsInstance.descripcion}</legend>

    <g:if test="${subgrupoItemsInstance?.codigo}">
        <div class="row">
            <div class="col-md-3 text-info">
                Código
            </div>
            <div class="col-md-6">
                ${subgrupoItemsInstance?.codigo?.toString()?.padLeft(3,'0')}
            </div>
        </div>
    </g:if>
</fieldset>