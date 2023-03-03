<div class="container">
    <div class="col-sm-5">
        <label for="indice" class="col-md-2 control-label text-info">
            Indice
        </label>
        <span class="col-md-8">
            <g:select name="indice" class="form-control" from="${indices}" optionKey="${{it.id}}"
                      optionValue="${{it.codigo + ' - ' + it.descripcion }}" value="${indiceActual?.indice?.id}" style="width:400px;"/>
        </span>
    </div>
    <div class="col-md-8"></div>
    <div class="col-md-5" >
        <label for="valor" class="col-md-2 control-label text-info">
            Valor
        </label>
        <span class="col-md-4">
            <g:textField name="valor" value="${indiceActual?.valor ?: 0}" class="form-control number"/>
        </span>
    </div>
</div>

<script type="text/javascript">

    function validarNum(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 190 || ev.keyCode === 110 ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $(".number").keydown(function (ev) {
        return validarNum(ev);
    });

</script>