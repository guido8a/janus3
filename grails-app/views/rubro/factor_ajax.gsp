<div class="container">
    <div class="col-md-12">
        <div class="col-md-1 bold">
            <label>
                Factor:
            </label>
        </div>
        <div class="col-md-1">
            <g:textField name="factor" id="factorId" class="form-control"/>
        </div>
    </div>
</div>


<script type="text/javascript">

    function validarNumDec(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 190 || ev.keyCode === 110 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#factorId").keydown(function (ev) {
        return validarNumDec(ev)
    });

</script>