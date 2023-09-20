<asset:javascript src="/jquery/plugins/ckeditor/ckeditor.js"/>

<g:form class="form-horizontal" name="frmEditarSeccionSave" action="saveEditSeccion_ajax">
    <g:hiddenField name="idSeccion" value="${seccion?.id}"/>
    <div class="container">
        <div class="col-md-6" >
            <g:textArea name="titulo" class="form-control" style="height: 150px; resize: none;" value="${seccion?.titulo ?: ''}"/>
        </div>
    </div>
</g:form>

<script type="text/javascript">

    CKEDITOR.replace( 'titulo', {
        language: 'es',
        uiColor: '#9AB8F3'
    });

    CKEDITOR.config.toolbar_parrafo = [
        ['Undo', 'Redo'],
        ['Bold', 'Italic', 'Underline'],
        ['NumberedList', 'BulletedList'],
        ['Outdent', 'Indent']
    ];


</script>