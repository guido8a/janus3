<asset:javascript src="/jquery/plugins/ckeditor/ckeditor.js"/>

<g:form class="form-horizontal" name="frmEditarSave" action="saveEditParrafo_ajax">
    <g:hiddenField name="idParrafo" value="${parrafo?.id}"/>
    <div class="container">
        <div class="col-md-6" >
            <g:textArea name="contenido" class="form-control" style="height: 150px; resize: none;" value="${parrafo?.contenido ?: ''}"/>
        </div>
    </div>
</g:form>

<script type="text/javascript">

    CKEDITOR.replace( 'contenido', {
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