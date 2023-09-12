<asset:stylesheet src="/summernote-0.8.18-dist/summernote.min.css"/>
<asset:javascript src="/summernote-0.8.18-dist/summernote.min.js"/>

<g:form class="form-horizontal" name="frmEditarSeccionSave" action="saveEditSeccion_ajax">
    <g:hiddenField name="id" value="${seccion?.id}"/>
    <div class="container">
        <div class="col-md-6" >
            <g:textArea name="titulo" class="form-control" style="height: 150px; resize: none;" value="${seccion?.titulo ?: ''}"/>
        </div>
    </div>
</g:form>

<script type="text/javascript">

    $(document).ready(function() {
        $('#titulo').summernote({
            spellCheck: true,
            disableGrammar: true,
            toolbar: [
                ['style', ['style']],
                ['font', ['bold', 'underline', 'clear']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['table', ['table']],
                ['insert', ['link', 'picture', 'video']]
            ]
        });
    });

</script>