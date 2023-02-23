<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">

    <style type="text/css">

    .texto {
        font-family : arial;
        font-size: 12px;
    }

    .bordeVerde{
        border-color: green;
    }


    </style>

    <title>Formato de Impresión</title>
</head>

<body>

<div class="span12 btn-group" role="navigation">
    <g:link class="link btn btn-info" controller="inicio" action="parametros">
        <i class="fa fa-arrow-left"></i>
        Parámetros
    </g:link>
</div>

<div id="tabs" style="width: 700px; height: 700px; margin-top: 5px">

    <ul>
        <li><a href="#tab-memorando">Memorando</a></li>
        <li><a href="#tab-textosFijos">Textos Fijos</a></li>
    </ul>

    <div id="tab-memorando" class="tab" style="">
        <div class="texto">
            <fieldset class="borde">
                <legend>Texto</legend>
                <g:form class="memoGrabar" name="frm-memo" controller="auxiliar" action="saveText">
                    <g:hiddenField name="id" value="${"1"}"/>

                    <div class="span6">

                        <div class="span1">Texto</div>

                        <div class="span3"><g:textArea name="memo1" value="${auxiliarFijo?.memo1}" rows="4" cols="4"
                                                       style="width: 600px; height: 55px; resize: none;"
                                                       disabled="true" class="form-control"/></div>
                    </div>


                    <div class="span6">
                        <div class="span1">Pie</div>

                        <div class="span3"><g:textArea name="memo2" value="${auxiliarFijo?.memo2}" rows="4" cols="4"
                                                       style="width: 600px; height: 55px;  resize: none;"
                                                       disabled="true" class="form-control"/></div>

                    </div>
                </g:form>

                <div class="span6" style="margin-top: 10px">
                    <div class="btn-group" style="margin-left: 250px; margin-bottom: 10px">
                        <button class="btn btn-info" id="btnEditarMemo"><i class="fa fa-edit"></i> Editar</button>
                        <button class="btn btn-success" id="btnAceptarMemo"><i class="fa fa-save"></i> Aceptar</button>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>

    <div id="tab-textosFijos" class="tab" style="">
        <div class="cabecera">
            <fieldset class="borde">
                <legend>Cabecera</legend>


                <g:form class="memoGrabar" name="frm-textoFijo" controller="auxiliar" action="saveText">
                    <g:hiddenField name="id" value="${"1"}"/>

                    <div class="span6">
                        <div class="span1">Título</div>

                        <div class="span3"><g:textField name="titulo" value="${auxiliarFijo?.titulo}" style="width: 560px"
                                                        disabled="true" class="form-control"/></div>

                    </div>


                    <div class="span6">
                        <div class="span1">General</div>
                    </div>

                    <div class="span6">
                        <div class="span3"><g:textArea name="general" value="${auxiliarFijo?.general}" rows="4" cols="4"
                                                       style="width: 665px; height: 130px; resize: none;"
                                                       disabled="true" class="form-control"/></div>

                    </div>


                    <div class="span6">
                        <div class="span2">Base de Contratos</div>
                    </div>

                    <div class="span6">
                        <div class="span3"><g:textArea name="baseCont" value="${auxiliarFijo?.baseCont}" rows="4" cols="4"
                                                       style="width: 665px; height: 35px; resize: none;"
                                                       disabled="true" class="form-control"/></div>

                    </div>

                    <div class="span6">
                        <div class="span2">Presupuesto Referencial</div>
                    </div>

                    <div class="span6">
                        <div class="span3"><g:textArea name="presupuestoRef" value="${auxiliarFijo?.presupuestoRef}"
                                                       rows="4" cols="4" style="width: 665px; height: 35px; resize: none;"
                                                       disabled="true" class="form-control"/></div>
                    </div>
                </g:form>


                <div class="span6" style="margin-top: 10px">
                    <div class="btn-group" style="margin-left: 250px; margin-bottom: 10px">
                        <button class="btn btn-info" id="btnEditarTextoF"><i class="fa fa-edit"></i> Editar</button>
                        <button class="btn btn-success" id="btnAceptarTextoF"><i class="fa fa-save"></i> Aceptar</button>

                    </div>
                </div>

            </fieldset>

        </div>

        <div class="cabecera">

            <fieldset class="borde">
                <legend>Pie de Página</legend>

                <g:form class="memoGrabar" name="frm-textoFijoRet" controller="auxiliar" action="saveText">

                    <g:hiddenField name="id" value="${"1"}"/>

                    <div class="span6">
                        <div class="span3">NOTA (15 líneas aproximadamente)</div>
                    </div>

                    <div class="span6">
                        <div class="span3"><g:textArea name="notaAuxiliar" value="${auxiliarFijo?.notaAuxiliar}" rows="4"
                                                       cols="4" style="width: 665px; height: 130px; resize: none;"
                                                       disabled="true" class="form-control"/></div>
                    </div>
                </g:form>

                <div class="span6" style="margin-top: 10px">
                    <div class="btn-group" style="margin-left: 250px; margin-bottom: 10px">
                        <button class="btn btn-info" id="btnEditarTextoRet"><i class="fa fa-edit"></i> Editar</button>
                        <button class="btn btn-success" id="btnAceptarTextoRet"><i class="fa fa-save"></i> Aceptar</button>

                    </div>
                </div>
            </fieldset>
        </div>
    </div>
</div>

<script type="text/javascript">

    var tipoClick;
    var tg = 0;
    var forzarValue;
    var notaValue;
    var firmasId = [];
    var firmasIdMemo = [];
    var firmasIdFormu = [];
    var firmasFijas = [];
    var firmasFijasMemo = [];
    var firmasFijasFormu = [];
    var reajusteMemo = 0;
    var proyeccion;
    var reajusteIva;
    var reajusteMeses;
    var tasaCambio;
    var idObraMoneda;
    var proyeccionMemo;
    var reajusteIvaMemo;
    var reajusteMesesMemo;
    var paraMemo1;

    $("#tabs").tabs();

    $("#btnEditarMemo").click(function () {
        $("#memo1").attr("disabled", false).addClass("bordeVerde");
        $("#memo2").attr("disabled", false).addClass("bordeVerde");
    });

    $("#btnAceptarMemo").click(function () {
        $("#frm-memo").submit();
    });

    $("#btnEditarTextoF").click(function () {
        $("#presupuestoRef").attr("disabled", false).addClass("bordeVerde");
        $("#baseCont").attr("disabled", false).addClass("bordeVerde");
        $("#general").attr("disabled", false).addClass("bordeVerde");
        $("#titulo").attr("disabled", false).addClass("bordeVerde");
    });

    $("#btnAceptarTextoF").click(function () {
        $("#frm-textoFijo").submit();
    });

    $("#btnEditarTextoRet").click(function () {
        $("#retencion").attr("disabled", false).addClass("bordeVerde");
        $("#notaAuxiliar").attr("disabled", false).addClass("bordeVerde");
    });

    $("#btnAceptarTextoRet").click(function () {
        $("#frm-textoFijoRet").submit();
    });

    $("#piePaginaSel").change(function () {
        $("#piePaginaSel").attr("disabled", false).addClass("bordeVerde");
        $("#descripcion").attr("disabled", true);
        $("#texto").attr("disabled", true);
        $("#adicional").attr("disabled", true);
        $("#notaAdicional").attr("disabled", true)
    });

    $(".btnQuitar").click(function () {
        var strid = $(this).attr("id");
        var parts = strid.split("_");
        var tipo = parts[1];
    });

    $("#btnAceptar").click(function () {
        $("#frm-nota").submit();
    });

    $("#btnNuevo").click(function () {
        $("#piePaginaSel").attr("disabled", true);
        $("#descripcion").attr("disabled", false).val("");
        $("#texto").attr("disabled", false).val("");
        $("#notaAdicional").attr("checked", true);
        $("#adicional").attr("disabled", false).val("");
        $("#notaAdicional").attr("disabled", false)
    });

    $("#btnCancelar").click(function () {
        $("#piePaginaSel").attr("disabled", false);
        $("#descripcion").attr("disabled", true);
        $("#texto").attr("disabled", true);
        $("#adicional").attr("disabled", true);
        $("#notaAdicional").attr("disabled", true)
    });

    function desbloquear() {
        $("#piePaginaSel").attr("disabled", false);
        $("#descripcion").attr("disabled", false);
        $("#texto").attr("disabled", false);
        $("#notaAdicional").attr("disabled", false)
    }

    $("#btnEditar").click(function () {
        desbloquear();
    });

    $("#notaAdicional").click(function () {
        if ($("#notaAdicional").attr("checked") === "checked") {
            $("#adicional").attr("disabled", false)
        }else {
            $("#adicional").attr("disabled", true)
        }
    });

</script>

</body>
</html>