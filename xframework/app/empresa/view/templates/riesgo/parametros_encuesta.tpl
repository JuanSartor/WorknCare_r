<style>
    .dim-btns{
        width: 280px;
        margin-top: 15px;
    }
    .btn-sig-etapa{
        background: white;
        color: #3DB4C0;
        border: solid;
    }
    .font-iconos{
        font-size: 20px;
    }
    .btn-agregar-pregunta:hover {
        background: white !important;
        color: #77cbd3 !important;
        border: solid;
    }
    .label-personalizar{
        margin-bottom: 15px;
        font-size: 15px;
        font-weight: 600;
    }
    .input-personalizar{
        margin-bottom: 15px;
        padding-left: 10px;
    }
    .title-preguntas{
        font-size: 18px;
        margin-top: 55px;
    }
    .container-btn{
        margin-top:70px;
    }
    .input-title{
        width: 433px !important;
    }
    .ubicacion-checkbox{
        position: relative;
        top: -35px;
        left: 150px;
    }
    .label-presupuesto{
        position: relative;
        top: -33px;
        left: 120px;
    }
    .fix-asterisco{
        margin-right: 10px;
        color: #3DB4C0;
    }
</style>
<section class="okm-container" id="personalizadsec">
    <!-- primer columna -->
    <input  id="idcuestionario" hidden value='{$idcuestionario}'>
    <input  id="idempresa" hidden value='{$idempresa}'>
    <input  id="cuestionario_enpreparacion" hidden value='{$cuestionario_enpreparacion}'>
    <div class="col-xs-6 programas-incluidos">
        <h2 class="title">
            <button onclick="location.href = 'JavaScript:window.history.back();'"  class="btn btn-transparen go-back-button btn-volver"><i class="fa fa-chevron-left"></i></button>
                {"Parametros"|x_translate}

        </h2>
        <div class="container-inputs" style="margin-top: 50px;">
            <div class="col-xs-12" style="margin-bottom: 10px;">
                <label class="mapc-label label-personalizar ">{"Con prestacion"|x_translate} </label>
                <label class="checkbox ubicacion-checkbox"><input type="checkbox" checked id="conPrestacion" name="conPrestacion" value="1"  data-toggle="checkbox" class="custom-checkbox">
                </label>

            </div>
            <div class="col-xs-12" id="divRecompensa">
                <label  class="mapc-label label-personalizar"> {"Eleccion de recompensa"|x_translate}</label>
                <select name="tipo_recompensa" id="tipo_recompensa" class="form-control select select-primary select-block mbl">
                    {foreach from=$combo_recompensas item=recompensa}
                        <option value="{$recompensa.id}" readonly>{$recompensa.monto}€</option>
                    {/foreach}
                </select>

            </div>

            <div class="col-xs-12" id="divPrestacion30">
                <label  class="mapc-label label-personalizar"> {"Eleccion de prestacion"|x_translate}</label>
                <select name="prestacion30" id="prestacion30"  class="form-control select select-primary select-block mbl">
                    {foreach from=$combo_prestaciones item=prestacion}
                        {if $prestacion.id == 49}
                            <option value="{$prestacion.id}" selected  readonly>{$prestacion.programa_salud}</option>
                        {/if}

                    {/foreach}
                </select>
            </div>
            <div class="col-xs-12" hidden id="divPrestacion">
                <label  class="mapc-label label-personalizar"> {"Eleccion de prestacion"|x_translate}</label>
                <select  name="prestacion" id="prestacion"  class="form-control select select-primary select-block mbl">
                    {foreach from=$combo_prestaciones item=prestacion}
                        {if $prestacion.id != 49}
                            <option value="{$prestacion.id}" readonly>{$prestacion.programa_salud}</option>

                        {/if}
                    {/foreach}
                </select>
            </div>
            <div class="col-xs-12" id="divCantidad" >
                <label  class="mapc-label label-personalizar"> {"Cantidad"|x_translate}</label>
                <input id="input_cantidad"  class="input-personalizar" type="number"/>

            </div>
        </div>


    </div>
    <!-- segunda columna -->
    <div class="col-xs-6 preguntas-incluidas">

        <br> <br> <br> <br> 
        <div class="col-xs-12" style="margin-top: 9px;">
            <label  class="mapc-label label-personalizar"> {"Metodo de atribusion"|x_translate}</label>
            <select name="metodo_atribusion" id="metodo_atribusion" class="form-control select select-primary select-block mbl">
                <option value="1" selected readonly>{"Aleatorio"|x_translate}</option>
                <option value="0" readonly>{"Discrecional"|x_translate}</option>
            </select>
        </div>
        <div class="col-xs-12">
            <label class="mapc-label label-personalizar ">{"Reporte anonimo"|x_translate} </label>
            <label style="width: 50px;" class="checkbox ubicacion-checkbox"><input type="checkbox" checked id="anonimo" name="anonimo" value="1"  data-toggle="checkbox" class="custom-checkbox">
            </label>

        </div>
        <div style="margin-top: 10px;" id="contExplica" hidden class="col-xs-12">
            <label  class="mapc-label label-personalizar"> {"Se agregara la siguiente informacion al cuestionario:"|x_translate}</label>
        </div>
        <div style="margin-top: 10px;" id="contNombre" hidden class="col-xs-12">
            <label  class="mapc-label label-personalizar"><i class="fa fa-info fix-asterisco"></i>{"Nombre"|x_translate}</label>
        </div>
        <div id="contApellido" hidden class="col-xs-12">
            <label  class="mapc-label label-personalizar"> <i class="fa fa-info fix-asterisco"></i>{"Apellido"|x_translate}</label>
        </div>
        <div id="contEmail" hidden class="col-xs-12">
            <label  class="mapc-label label-personalizar"> <i class="fa fa-info fix-asterisco"></i>{"Email"|x_translate}</label>
        </div>
        <div class="col-xs-12" style="margin-top:15px;">
            <div style="width: 225px; background-color: #dbd8d8; height: 22px;">
                <label  class="mapc-label label-personalizar" style="margin-left: 25px; line-height: 1.3;"> {"Presupuesto"|x_translate}:
                </label>
                <label id="labelrdopresupuesto"  class="mapc-label label-personalizar label-presupuesto"> 0 eur
                </label>
            </div>
        </div>
        <br><br><br><br><br>
        <div class="okm-row text-center container-btn">
            <div class="col-xs-12">
                <a id="btnVerResultado"    class="btn btn-xs btn-default  btn-guardar dim-btns btn-agregar-pregunta" >{"Ver el resultado"|x_translate}</a>
            </div>
        </div>
    </div>
    <div class="clearfix">&nbsp;</div>
</section>


{literal}
    <script>
        $(function () {
            var banderaPrestacion = true;
            $("#anonimo").change(function () {
                if ($('#anonimo').is(":checked")) {
                    $('#contNombre').hide();
                    $('#contApellido').hide();
                    $('#contEmail').hide();
                    $('#contExplica').hide();
                    $("#anonimo").val("1");

                } else {
                    $("#anonimo").val("0");
                    $('#contNombre').show();
                    $('#contApellido').show();
                    $('#contEmail').show();
                    $('#contExplica').show();
                }
            });
            $("#conPrestacion").change(function () {
                if ($('#conPrestacion').is(":checked")) {
                    $('#divRecompensa').show();
                    $('#divPrestacion').hide();
                    $('#divCantidad').show();
                    $("#divPrestacion30").show();
                    $("#tipo_recompensa").val("1");
                    $('#tipo_recompensa').change();
                    banderaPrestacion = true;
                } else {
                    $('#divRecompensa').hide();
                    $('#divPrestacion').hide();
                    $('#divCantidad').hide();
                    $("#divPrestacion30").hide();
                    $("#labelrdopresupuesto").text(0 + " eur");
                    banderaPrestacion = false;
                }
            });


            $("#input_cantidad").on("input", function () {
                if ($("#tipo_recompensa").val() == '1') {
                    var rdopres = 30 * $(this).val();
                } else {
                    var rdopres = 65 * $(this).val();
                }
                $("#labelrdopresupuesto").text(rdopres + " eur");
            });

            $("#tipo_recompensa").change(function () {
                //console.log($("#tipo_recompensa").val());
                if ($("#tipo_recompensa").val() == '1') {
                    var rdopres = 30 * $("#input_cantidad").val();
                    $("#divPrestacion").hide();
                    $("#divPrestacion30").show();


                } else {
                    var rdopres = 65 * $("#input_cantidad").val();
                    $("#divPrestacion30").hide();
                    $("#divPrestacion").show();


                }

                $("#labelrdopresupuesto").text(rdopres + " eur");
            });


            $("#btnVerResultado").click(function () {
                if ($("#cuestionario_enpreparacion").val() == '0') {
                    anonimo = $("#anonimo").val();
                    metodo_atribusion = $("#metodo_atribusion").val();


                    if ($("#input_cantidad").val() != '') {
                        input_cantidad = $("#input_cantidad").val();
                    } else {
                        input_cantidad = 0;
                    }

                    tipo_recompensa = $("#tipo_recompensa").val();
                    if (tipo_recompensa == '1') {
                        prestacion = 49;
                    } else {
                        prestacion = $("#prestacion").val();
                    }
                    idcuestionario = $("#idcuestionario").val();
                    nombrenoanonimo = $('#nombre_noanonimo').val();
                    apellidnoanonimo = $('#apellido_noanonimo').val();
                    emailnoanonimo = $('#email_noanonimo').val();
                    idempresa = $('#idempresa').val();


                    if ((banderaPrestacion && input_cantidad != 0) || !banderaPrestacion) {
                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=setear_parametros_encuesta",
                                'idcuestionario=' + idcuestionario + '&anonimo=' + anonimo + '&metodo_atribusion=' + metodo_atribusion
                                + '&cantidad=' + input_cantidad + '&programasalud_idprogramasalud=' + prestacion + '&recompensa=' + tipo_recompensa
                                + '&nombre_no_anonimo=' + nombrenoanonimo + '&apellido_no_anonimo=' + apellidnoanonimo + '&email_no_anonimo=' + emailnoanonimo
                                + '&banderaPrestacion=' + banderaPrestacion,
                                function (data) {
                                    // console.log(data);
                                    $("body").spin(false);
                                    if (data.result) {
                                        if (banderaPrestacion) {
                                            window.location.href = BASE_PATH + "entreprises/questionnaireslist/pay/" + idcuestionario + ".html";
                                        } else {
                                            x_alert(x_translate('Su encuesta ha sido creada correctamente'), function () {
                                                //  console.log(idempresa);
                                                window.location.href = BASE_PATH + "entreprises/questionnairesready/" + data.hash + ".html";
                                            });
                                        }
                                    } else {
                                        x_alert(data.msg);
                                    }
                                }
                        );
                    } else {
                        x_alert(x_translate('Debe completar todos los campos'));
                    }

                } else {
                    x_alert(x_translate('Solo puede tener un cuestionario listo para ser enviado'));
                }
            });

        });
    </script>
{/literal}