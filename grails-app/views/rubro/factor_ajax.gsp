Factor: <g:textField name="factor" id="factorId" class="form-control" style="width:150px;"/>

<script type="text/javascript">

    function validarNumDec(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#factorId").keydown(function (ev) {
        return validarNumDec(ev)
    });

</script>