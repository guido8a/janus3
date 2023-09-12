<asset:stylesheet src="/summernote-0.8.18-dist/summernote.min.css"/>
<asset:javascript src="/summernote-0.8.18-dist/summernote.min.js"/>
<g:form class="form-horizontal" name="frmEditarSave" action="saveEditParrafo_ajax">
    <g:hiddenField name="id" value="${parrafo?.id}"/>
    <div class="container">
        <div class="col-md-6" >
            <g:textArea name="contenido" class="form-control" style="height: 150px; resize: none;" value="${parrafo?.contenido ?: ''}"/>
        </div>
    </div>
</g:form>

<script type="text/javascript">

    $(document).ready(function() {
        $('#contenido').summernote({
            spellCheck: true,
            disableGrammar: true
        });
    });

</script>