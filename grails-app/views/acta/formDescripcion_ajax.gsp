
<g:form class="form-horizontal" name="frmEditarDesc" action="saveEditDescripcion_ajax">
    <g:hiddenField name="id" value="${acta?.id}"/>
    <div class="container">
        <div class="col-md-6" >
            <g:textArea name="descripcion" class="form-control" style="height: 150px; resize: none;" value="${acta?.descripcion ?: ''}"/>
        </div>
    </div>
</g:form>

<script type="text/javascript">

    CKEDITOR.replace( 'descripcion', {
        language: 'es',
        uiColor: '#9AB8F3',
        extraPlugins: 'entities',
        toolbar                 : [
            ['FontSize', 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo'],
            ['Bold', 'Italic', 'Underline'] ]
    });


</script>