<%@ page import="janus.Departamento" %>

<div class="container">
    <div class="col-md-12">
        <g:form class="registroContrato" name="frmAdicionales" action="guardarAdicionales">
            <g:hiddenField name="cntr" value="${cntr.id}"/>
                <div class="col-md-2" >Memorando número:</div>
                <div class="col-md-3">
                    <g:textField name="adicionales" class="number form-control allCaps" value="${cntr?.adicionales}"/>
                </div>
        </g:form>
    </div>
</div>