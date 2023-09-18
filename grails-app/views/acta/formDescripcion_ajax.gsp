<asset:stylesheet src="/summernote-0.8.18-dist/summernote.min.css"/>
<asset:javascript src="/summernote-0.8.18-dist/summernote.min.js"/>
<g:form class="form-horizontal" name="frmEditarDesc" action="saveEditDescripcion_ajax">
    <g:hiddenField name="id" value="${acta?.id}"/>
    <div class="container">
        <div class="col-md-6" >
            <g:textArea name="descripcion" class="form-control" style="height: 150px; resize: none;" value="${acta?.descripcion ?: ''}"/>
        </div>
    </div>
</g:form>

<script type="text/javascript">

    $(document).ready(function() {
        $('#descripcion').summernote({
            spellCheck: true,
            disableGrammar: true,
            toolbar: [
                ['font', ['bold', 'underline', 'clear']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['view', ['codeview']]
            ]
        });
    });

</script>