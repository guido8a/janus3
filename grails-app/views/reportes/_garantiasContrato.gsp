
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Garantías contrato</title>
        <style type="text/css">
        @page {
            size   : 21cm 29.7cm;  /*width height */
            margin : 2cm;
        }

        .hoja {
            height      : 24.7cm; /*29.7-(1.5*2)*/
            font-family : arial;
            font-size   : 10px;
            width       : 16cm;
        }

        .tituloPdf {
            height        : 100px;
            font-size     : 11px;
            text-align    : center;
            margin-bottom : 5px;
            width         : 95%;
        }

        h1 {
            font-size : 11px;
        }

        .bold {
            font-weight : bold;
        }

        .num {
            text-align : right;
        }

        thead tr {
            margin : 0px
        }

        th, td {
            font-size : 10px !important;
        }

        td {
            margin : 0px !important;
        }

        .even {
            background : #DDD;
        }

        .borde {
            border-collapse : collapse;
        }
        </style>
    </head>

    <body>

        <div class="hoja">

            <div class="tituloPdf">
                <p>
                    <b style="font-size: 18px">${auxiliar?.titulo ?: ''}</b>
                </p>
                <p style="font-size: 14px;margin-top: -14px">
                    COORDINACIÓN DE COMPRAS PÚBLICAS
                </p>
                <p style="font-size: 14px;margin-top: -14px">
                    GARANTÍAS DE CONTRATO
                </p>
            </div>

            <table>
                <tr>
                    <th colspan="4">Contrato</th>
                </tr>
                <tr>
                    <td class="bold">N.</td>
                    <td>${contrato?.codigo}</td>
                    <td class="bold">Memo de distribución</td>
                    <td>${contrato?.memo}</td>
                </tr>
                <tr>
                    <td class="bold">Tipo</td>
                    <td>${contrato?.tipoContrato?.descripcion}</td>
                    <td class="bold">Fecha de suscripción</td>
                    <td>${contrato?.fechaSubscripcion?.format("dd-MM-yyyy")}</td>
                </tr>
                <tr>
                    <td class="bold">Objeto</td>
                    <td colspan="3">${contrato?.objeto}</td>
                </tr>
                <tr>
                    <td class="bold">Multa por retraso<br/>de obra</td>
                    <td>${contrato?.multaRetraso} x 1000</td>
                    <td class="bold">Multa por no <br/>presentación de planilla</td>
                    <td>${contrato?.multaPlanilla} x 1000</td>
                </tr>
                <tr>
                    <td class="bold">Monto</td>
                    <td>$ ${contrato?.monto}"</td>
                    <td class="bold">Plazo</td>
                    <td>${contrato?.plazo} días</td>
                </tr>
                <tr>
                    <td class="bold">Anticipo</td>
                    <td>${contrato?.porcentajeAnticipo} %</td>
                    <td class="bold">Valor anticipo</td>
                    <td>"$" ${contrato?.anticipo} </td>
                </tr>
                <tr>
                    <td class="bold">Índices de la oferta</td>
                    <td>${contrato?.periodoInec?.descripcion}</td>
                    <td class="bold">Financiamiento</td>
                    <td>${contrato?.financiamiento}</td>
                </tr>
                <tr>
                    <th colspan="4"><br/>Obra</th>
                </tr>
                <tr>
                    <td class="bold">Obra</td>
                    <td>${contrato?.oferta?.concurso?.obra?.codigo}</td>
                    <td class="bold">Nombre</td>
                    <td>${contrato?.oferta?.concurso?.obra?.nombre}</td>
                </tr>
                <tr>
                    <td class="bold">Parroquia</td>
                    <td>${contrato?.oferta?.concurso?.obra?.parroquia?.nombre}</td>
                    <td class="bold">Cantón</td>
                    <td>${contrato?.oferta?.concurso?.obra?.parroquia?.canton?.nombre}</td>
                </tr>
                <tr>
                    <td class="bold">Clase obra</td>
                    <td>${contrato?.oferta?.concurso?.obra?.claseObra?.descripcion}</td>
                </tr>
                <tr>
                    <td class="bold">Contratista</td>
                    <td>${contrato?.oferta?.proveedor?.nombre?.replaceAll(/&/, /&amp;/)}</td>
                </tr>
            </table>

            <h1>Garantías</h1>

            <table border="1" class="borde">
                <thead>
                    <tr>
                        <th style="width: 150px">Tipo</th>
                        <th style="width: 120px">N. Garantía</th>
                        <th style="width: 300px">Aseguradora</th>
                        <th style="width: 70px">Documento</th>
                        <th style="width: 60px">Estado</th>
                        <th style="width: 70px">Emisión</th>
                        <th style="width: 70px">Vencimiento</th>
                        <th style="width: 280px">Monto</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${garantias}" var="gar" status="i">
                        <tr class="${i % 2 == 0 ? 'even' : 'odd'}">
                            <td>${gar.tipoGarantia?.descripcion}</td>
                            <td>${gar.codigo}</td>
                            <td>${gar.aseguradora?.nombre}</td>
                            <td>${gar.tipoDocumentoGarantia?.descripcion}</td>
                            <td>${gar.estado?.descripcion}</td>
                            <td>${gar.fechaInicio.format("dd-MM-yyyy")}</td>
                            <td>${gar.fechaFinalizacion.format("dd-MM-yyyy")}</td>
                            <td class="num">${gar.monto}${gar?.moneda?.codigo}</td>
                        </tr>
                    </g:each>
                </tbody>
            </table>
        </div>
    </body>
</html>