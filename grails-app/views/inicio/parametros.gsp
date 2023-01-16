<html>


<head>
    <meta name="layout" content="main"/>

    <title>Parámetros</title>

    <style type="text/css">

    .tab-content, .left, .right {
        height : 800px;
    }

    .tab-content {
        background  : #EEEEEE;
        border      : solid 1px #DDDDDD;
        padding-top : 10px;
    }
    .descripcion h4 {
        color      : cadetblue;
        text-align : center;
    }

    .left {
        width : 710px;
        /*background : red;*/
    }

    .fa-ul li {
        margin-bottom : 10px;
    }

    </style>

</head>

<body>


<ul class="nav nav-tabs">
    <li class="active"><a href="#generales" data-toggle="tab">Generales</a></li>
    <li><a href="#obras" data-toggle="tab">Obras</a></li>
    <li><a href="#contratacion" data-toggle="tab">Contratación</a></li>
    <li><a href="#ejecucion" data-toggle="tab">Ejecución</a></li>
</ul>
<div class="tab-content ui-corner-bottom">
    <div class="tab-pane active" id="generales">
        <div class="left pull-left">
            <ul class="fa-ul">
                <li>
                    <div class="row">
                        <div class="col-md-12" >

                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <h3 class="panel-title">Parámetros generales del Sistema</h3>
                                </div>

                                <div class="row" style="margin-left: 5px;">
                                    <div class="col-md-12 col-xs-5">
                                        <p>
                                            <g:link class="link btn btn-primary btn-ajax" controller="administracion" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Administración
                                            </g:link>
                                            <strong style="font-size: 14px">del GADPP, autoridad principal</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-primary btn-ajax" controller="canton" action="arbol">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Distribución Geográfica
                                            </g:link>
                                            <strong style="font-size: 14px">Divisi&oacute;n geogr&aacute;fica del Pa&iacute;s en cantones, parroquias y comunidades.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-primary btn-ajax" controller="tipoItem" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Tipo de Item
                                            </g:link>
                                            <strong style="font-size: 14px">Para diferenciar entre ítems y rubros</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-primary btn-ajax" controller="unidad" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Unidades
                                            </g:link>
                                            <strong style="font-size: 14px"> de medida para los materiales, mano de obra y equipos</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-primary btn-ajax" controller="unidad" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Grupos de Rubros
                                            </g:link>
                                            <strong style="font-size: 14px"> para clasificar los distintos análisis de precios</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-primary btn-ajax" controller="unidad" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Transporte
                                            </g:link>
                                            <strong style="font-size: 14px"> para diferenciar los ítems que participan en el transporte</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-primary btn-ajax" controller="direccion" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Direcciones del personal
                                            </g:link>
                                            <strong style="font-size: 14px"> para la organización de los usuarios.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-primary btn-ajax" controller="departamento" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Coordinación del personal
                                            </g:link>
                                            <strong style="font-size: 14px"> para la organización de los usuarios.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-primary btn-ajax" controller="funcion" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Funciones del personal
                                            </g:link>
                                            <strong style="font-size: 14px"> que pueden desempeñar en la construcción de la obra
                                            o en los  distintos momentos de la contratación y ejecución de obras.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-primary btn-ajax" controller="tipoTramite" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Tipo de Trámite
                                            </g:link>
                                            <strong style="font-size: 14px"> para la gestión de procesos y flujo de trabajo. </strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-primary btn-ajax" controller="rolTramite" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Rol de la persona en el Trámite
                                            </g:link>
                                            <strong style="font-size: 14px"> quien envía, quien recibe el documento.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-primary btn-ajax" controller="rolTramite" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Días laborables
                                            </g:link>
                                            <strong style="font-size: 14px"> permite definir los días laborables en un calendario anual.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-primary btn-ajax" controller="rolTramite" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                IVA
                                            </g:link>
                                            <strong style="font-size: 14px"> permite cambiar el valor del IVA.</strong>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </div>
    <div class="tab-pane " id="obras">
        <div class="left pull-left">
            <ul class="fa-ul">
                <li>
                    <div class="row">
                        <div class="col-md-12" >

                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <h3 class="panel-title">Parámetros de obras</h3>
                                </div>

                                <div class="row" style="margin-left: 5px;">
                                    <div class="col-md-12 col-xs-5">
                                        <p>
                                            <g:link class="link btn btn-success btn-ajax" controller="tipoObra" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Tipo de Obras
                                            </g:link>
                                            <strong style="font-size: 14px">a ejecutarse en un proyecto.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-success btn-ajax" controller="claseObra" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Clase de Obra
                                            </g:link>
                                            <strong style="font-size: 14px">para distinguir entre varios clases de obra civiles y viales.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-success btn-ajax" controller="estadoObra" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Estado de la Obra
                                            </g:link>
                                            <strong style="font-size: 14px">que distingue las distintas fases de contratación y ejecución de la obra.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-success btn-ajax" controller="programacion" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Programa
                                            </g:link>
                                            <strong style="font-size: 14px"> del cual forma parte una obra.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-success btn-ajax" controller="auxiliar" action="textosFijos">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Textos fijos
                                            </g:link>
                                            <strong style="font-size: 14px">para la generación de los documentos precontractuales.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-success btn-ajax" controller="tipoFormulaPolinomica" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Tipo de fórmula polinómica
                                            </g:link>
                                            <strong style="font-size: 14px"> de reajuste de precios que puede tener un contrato.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-success btn-ajax" controller="inicio" action="variables">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Valores de costos indirectos y transporte
                                            </g:link>
                                            <strong style="font-size: 14px"> valores por defecto que se usan en las obras.</strong>
                                        </p>

                                        <p>
                                            <g:link class="link btn btn-success btn-ajax" controller="anio" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Ingreso de Años
                                            </g:link>
                                            <strong style="font-size: 14px"> para el registro de periodos de los índices.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-success btn-ajax" controller="valoresAnuales" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Valores Anuales
                                            </g:link>
                                            <strong style="font-size: 14px"> </strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-success btn-ajax" controller="tipoLista" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Tipo de Listas de precios
                                            </g:link>
                                            <strong style="font-size: 14px"></strong>
                                        </p>
                                    </div>
                                </div>


                            </div>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </div>

    <div class="tab-pane " id="contratacion">
        <div class="left pull-left">
            <ul class="fa-ul">
                <li>
                    <div class="row">
                        <div class="col-md-12" >

                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <h3 class="panel-title">Parámetros de contratación</h3>
                                </div>

                                <div class="row" style="margin-left: 5px;">
                                    <div class="col-md-12 col-xs-5">
                                        <p>
                                            <g:link class="link btn btn-warning btn-ajax" controller="tipoContrato" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Tipo de Contrato
                                            </g:link>
                                            <strong style="font-size: 14px">que puede registrarse en el sistema para la ejecución de una Obra.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-warning btn-ajax" controller="tipoGarantia" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Tipo de Garantía
                                            </g:link>
                                            <strong style="font-size: 14px">que se puede recibir en un contrato.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-warning btn-ajax" controller="tipoDocumentoGarantia" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Tipo de documento de garantía
                                            </g:link>
                                            <strong style="font-size: 14px">que se puede recibir para garantizar las distintas estipulaciones de una contrato.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-warning btn-ajax" controller="estadoGarantia" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Estado de la garantía
                                            </g:link>
                                            <strong style="font-size: 14px">  dentro del período contractual.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-warning btn-ajax" controller="tipoAseguradora" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Tipo de aseguradora
                                            </g:link>
                                            <strong style="font-size: 14px"> que emite la garantía.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-warning btn-ajax" controller="aseguradora" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Aseguradora
                                            </g:link>
                                            <strong style="font-size: 14px"> o institución bancaria que emite la garantía.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-warning btn-ajax" controller="inicio" action="variables">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Unidad del Item
                                            </g:link>
                                            <strong style="font-size: 14px"> Unidades que se emplean en el INCOP.</strong>
                                        </p>

                                        <p>
                                            <g:link class="link btn btn-warning btn-ajax" controller="tipoProcedimiento" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Tipo de Procedimiento
                                            </g:link>
                                            <strong style="font-size: 14px"> de contratación, se diferencian según el monto a contratar.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-warning btn-ajax" controller="tipoCompra" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Tipo de Compra
                                            </g:link>
                                            <strong style="font-size: 14px"> Bien, Obra o Servicio a adquirir</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-warning btn-ajax" controller="fuenteFinanciamiento" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Fuente de financiamiento
                                            </g:link>
                                            <strong style="font-size: 14px">Entidad que financia la adquisición o construcción.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-warning btn-ajax" controller="especialidadProveedor" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Especialidad del Proveedor o Contratista
                                            </g:link>
                                            <strong style="font-size: 14px">Experiencia o especialidad en los servicios que presta.</strong>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </div>
    <div class="tab-pane " id="ejecucion">
        <div class="left pull-left">
            <ul class="fa-ul">
                <li>
                    <div class="row">
                        <div class="col-md-12" >

                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <h3 class="panel-title">Parámetros de ejecución</h3>
                                </div>

                                <div class="row" style="margin-left: 5px;">
                                    <div class="col-md-12 col-xs-5">
                                        <p>
                                            <g:link class="link btn btn-danger btn-ajax" controller="tipoMulta" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Tipo de multa de la planilla
                                            </g:link>
                                            <strong style="font-size: 14px">que puede tener dentro del proceso de ejecución de la obra.</strong>
                                        </p>
                                        <p>
                                            <g:link class="link btn btn-danger btn-ajax" controller="tipoPlanilla" action="list">
                                                <i class="fa fa-globe fa-2x"></i>
                                                Tipo de planilla
                                            </g:link>
                                            <strong style="font-size: 14px">que puede tener el proceso de ejecución de la obra: anticipo, liquidación, avance <br/> de obra, reajuste, etc.</strong>
                                        </p>
                                     </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</div>


<script type="text/javascript">

    $("#btnCambiarIva").click(function () {
        $.ajax({
            type: "POST",
            url: "${createLink(controller: "obra", action:'formIva_ajax')}",
            data: {

            },
            success: function (msg) {
                var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                btnSave.click(function () {
                    $(this).replaceWith(spinner);
                    $.ajax({
                        type: "POST",
                        url: "${createLink(controller: 'obra', action:'guardarIva_ajax')}",
                        data: $("#frmIva").serialize(),
                        success: function (msg) {
                            if(msg == 'ok'){
                                alert('Iva cambiado correctamente!');
                                $("#modal-TipoObra").modal("hide");
                            }else{
                                alert("Error al cambiar el Iva")

                            }
                            $("#modal-TipoObra").modal("hide");
                        }
                    });
                    return false;
                });

                $("#modalHeader_tipo").removeClass("btn-edit btn-show btn-delete");
                $("#modalTitle_tipo").html("Cambiar IVA");
                $("#modalBody_tipo").html(msg);
                $("#modalFooter_tipo").html("").append(btnOk).append(btnSave);
                $("#modal-TipoObra").modal("show");
            }
        });
        return false;

    });


    $(function () {
        $(".over").hover(function () {
            var $h4 = $(this).siblings(".descripcion").find("h4");
            var $cont = $(this).siblings(".descripcion").find("p");
            $(".right").removeClass("hidden").find(".panel-title").text($h4.text()).end().find(".panel-body").html($cont.html());
        }, function () {
            $(".right").addClass("hidden");
        });
    });



</script>

</body>
</html>