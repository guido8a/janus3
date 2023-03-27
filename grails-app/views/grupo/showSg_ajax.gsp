<%@ page import="janus.SubgrupoItems" %>

<legend>${subgrupoItemsInstance?.descripcion}</legend>

<g:if test="${subgrupoItemsInstance?.codigo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Código
        </div>
        <div class="col-md-9">
            ${subgrupoItemsInstance?.codigo?.toString()?.padLeft(3,'0')}
        </div>
    </div>
</g:if>
