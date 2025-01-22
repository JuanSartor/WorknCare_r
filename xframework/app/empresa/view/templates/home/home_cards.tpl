
<section class="okm-container cards-home" id="cards-home">
    <input id="idempresa" value='{$empresa.idempresa}' hidden/>
    <input id="validacion_automatica" value='{$empresa.validacion_automatica}' hidden/>
    {include file="home/banners_alertas.tpl"}
    {**  {if $account.user.email=='test0804@gmail.com'}
    <a class="btn btn-xs btn-default btn-inverse btnExportarBeneficiarios" href="{$url}empresa.php?action=1&modulo=home&submodulo=mail_prueba"><i class="fa fa-file-excel-o"></i>{"Exportar"|x_translate}</a>

    {/if} **}
    <div class="row-cards">
        {if $account.user.tipo_usuario|in_array:['1','5']} 
            <div class="okm-row  card-wrapper">

                <div class="card-container {if $account.user.tipo_usuario|in_array:['5']}col-md-6 col-sm-6 {else}col-md-12 col-sm-12 {/if}" >
                    <div class="okm-row">
                        <h4 class="title text-center title-cuestionario">{"Enviar cuestionario o challenge"|x_translate}</h4>
                    </div>
                    <div class="card row card-cuestionario">
                        <img class="icono-regalo" src="{$url}xframework/app/themes/dp02/imgs/illust_regalo.png" alt="WorknCare">

                        <div class="okm-row text-center">
                            <a style="width: 350px;" href="{$url}entreprises/questionnaires.html" class="btn btn-default btn-cuestionario">{"Comenzar"|x_translate}</a>
                        </div>
                    </div>

                </div>

            </div>
        {/if}      
        {if $account.user.tipo_usuario|in_array:['1','3','4']} 
            <div class="okm-row  card-wrapper">
                <div class="card-container col-md-12 col-sm-12" >
                    <div class="okm-row">
                        <h4 style="font-size: 18px; color: #02b8c1;" class="title text-center">{"Enviar un Pass"|x_translate}</h4>
                    </div>
                    <div style="background-color: #02b8c1;" class="card row">
                        <div class="okm-row">
                            <span>{"Beneficiarios inscriptos"|x_translate}:</span>
                            <span class="number pull-right">{$info_beneficiarios.beneficiarios_inscriptos}/{if $empresa.cant_empleados!=""}{$empresa.cant_empleados}{else}0{/if}</span>
                        </div>

                        <div class="okm-row">
                            <span>{"Tasa de inscripción estimada"|x_translate}:</span>
                            <span class="number pull-right">

                                {if $info_beneficiarios.tasa_inscripcion!=""}
                                    {$info_beneficiarios.tasa_inscripcion}%
                                {else}
                                    0%
                                {/if}

                            </span>
                        </div>
                        <div class="okm-row text-center" style="position: relative; top: 5px;">
                            <a style="position: relative; top: 8px; background-color: #0299a1; width: 350px;" id="btnEnviarInvitación" data-idempresa='{$empresa.plan_idplan}' class="btn btn-default">{"Enviar invitación"|x_translate}</a>
                        </div>
                    </div>
                    {if $info_beneficiarios.tasa_inscripcion <100}
                        <div class="text-center">
                            <label class="red alert">
                                <i class="fa fa-exclamation-circle"></i> 
                                {"Le recomendamos que envíe una nueva invitación."|x_translate}&nbsp;
                            </label>
                        </div>
                    {/if}
                </div>

            </div>
        {/if}
    </div>

    <!-- arranca la segunda fila -->
    {if $account.user.tipo_usuario|in_array:['1','5']} 

        <div class="row-cards" style="margin-top: 0px;">
            <input type="hidden" id="idcuestionario" value="{$cuestionario_listo.idcuestionario}">
            <div class="okm-row  card-wrapper">

                <div class="card-container col-md-12 col-sm-12" >
                    <div class="okm-row">
                        <h4 style="font-size: 18px; font-weight: 600; color:  #F29100;" class="title text-center">{"Enviar la capsula"|x_translate}</h4>
                    </div>
                    <div class="card row" style="background-color: #F29100; color: black; box-shadow: 2px 2px 10px 0 #eda466; {if $cant_cuestionario_preparado.cantidad <=0} padding: 0px; {/if}">

                        <div class="col-xs-12"  style="padding: 0px; text-align: center;" >
                            <img style='width: 200px; height: 140px; background: #F29100;' src="{$IMGS}capsula.png" />
                        </div>
                        <div style="position: relative; top: 15px;" class="okm-row text-center">
                            <a href="{$url}entreprises/capsule.html"  style="background:  #fdb477 !important; color: #ffffff !important; width: 350px;"  class="btn btn-default ">{"Comenzar"|x_translate}</a>
                        </div>

                    </div>

                </div>

            </div>


            <div class="okm-row  card-wrapper">

                <div class="card-container col-md-12 col-sm-12" >

                    <div class="okm-row">
                        <h4 style="font-size: 18px; font-weight: 600; color:  #4582B4;" class="title text-center">{"Créer un DUERP"|x_translate}</h4>
                    </div>
                    <div class="card row" >           
                        <div class="col-xs-12"  style="padding: 0px;"  >
                            <div class="col-xs-12"  style="padding: 0px; text-align: center;" >
                                <img style='width: 130px; height: 160px; background: #4582B4;' src="{$IMGS}futura_funcion.png" />
                            </div>
                            <div style="position: relative; top: 20px;" class="okm-row text-center">
                              <!--  <a id="funcionFuturo" href="{$url}entreprises/risque.html"   style="background: #1A3661  !important; color: #ffffff !important; width: 350px;"  class="btn btn-default ">{"Comenzar"|x_translate}</a>   
                                -->                       <a id="funcionFuturo"   style="background: #1A3661  !important; color: #ffffff !important; width: 350px;"  class="btn btn-default ">{"Comenzar"|x_translate}</a>   

                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </div>

    {/if}
    <!-- termina la segunda fila -->




    <!-- arranca la tercera fila -->
    {if $account.user.tipo_usuario|in_array:['1','5'] && ($cant_capsulaLista >0 || $cant_capsulaFinalizadas >0)} 

        <div class="row" style="text-align: center; margin-bottom: 30px;">
            <apan style="font-weight: 600;">
                {"Capsula en espera"|x_translate}
            </apan>
        </div>

        <div class="row-cards" style="margin-top: 0px;">
            <input type="hidden" id="idcuestionario" value="{$cuestionario_listo.idcuestionario}">
            <div class="okm-row  card-wrapper">

                <div class="card-container col-md-12 col-sm-12" >
                    <div class="okm-row">
                        <h4 style="font-size: 18px; font-weight: 600; color:  #000000;" class="title text-center">{"Tu capsula esta lista puedes compartirla !"|x_translate}</h4>
                    </div>
                    <div class="card row" style="background-color: white; color: black; box-shadow: 2px 2px 10px 0 #eda466; {if $cant_capsulaLista <=0} padding: 0px; {/if}">
                        {if $cant_capsulaLista >0}
                            <input type="hidden" id="idcapsula" value="{$capsula_lista.idcapsula}">
                            <div class="container-inputs" style="margin-top: 20px; text-align: center;">
                                <div class="col-xs-12" >
                                    <label style="font-size: 16px; font-weight: 600;"  class="mapc-label label-personalizar"> {"Generar codigo QR"|x_translate}</label>
                                </div>
                                <div style="top: -45px;" class="div-circulo">
                                    <span style="position: relative;  bottom: 25px;">{$cant_capsulaLista}
                                    </span>
                                </div>
                                <div class="col-xs-12">
                                    <div style="background-color: #ebebeb;  height: 30px; margin-top: 10px;">
                                        <label style="line-height: 1.8"  class="mapc-label label-personalizar"> {if $capsula_lista.tipo_capsula =='1'}{"File"|x_translate}: &nbsp{$capsula_lista.titulo}{else if $capsula_lista.tipo_capsula =='2'}{"Link"|x_translate}: &nbsp {$capsula_lista.titulo}{else if $capsula_lista.tipo_capsula =='3'}{"Video"|x_translate}: &nbsp  {$capsula_lista.titulo}{else}{"Vidéo"}: &nbsp  {$capsula_lista.titulo}{/if}</label>
                                    </div>
                                </div>

                            </div>
                            <div class="okm-row text-center" style="top: 27px;">
                                <a id="btnEviarCapsula"    class="btn btn-default btn-listo">{"Ver"|x_translate}</a>
                            </div>
                        {else}
                            <div class="col-xs-12" {if $cant_capsulaLista <=0} style="padding: 0px;" {/if} >
                                <img class="noResultados" src="{$IMGS}noexistencuestionarios.jpg" />
                            </div>
                        {/if}
                    </div>

                </div>

            </div>


            <div class="okm-row  card-wrapper">

                <div class="card-container col-md-12 col-sm-12" >

                    <div class="okm-row">
                        <h4 style="font-size: 18px; font-weight: 600; color:  #000000;" class="title text-center">{"Capsula en curso..."|x_translate}</h4>
                    </div>
                    <div class="card row" style="background-color: #F29100; color: white; {if $cant_capsulaFinalizadas <=0} padding: 0px; {/if}" >
                        {if $cant_capsulaFinalizadas >0 }

                            <div class="okm-row">
                                <span>{"Finalizados"|x_translate}:</span>
                                <span class="number pull-right">{$cant_capsulaFinalizadas}</span>
                            </div>
                            <div class="okm-row">
                                <span>{"Visualizaciones totales"|x_translate}:</span>
                                <span class="number pull-right">{$cant_visitasCapsulaTotales}</span>
                            </div>

                            <div class="okm-row text-center" style="position: relative; top: 23px;">
                                <a style="background:  #fdb477 !important; color:#ffffff !important"  href="{$url}entreprises/capsulelistacheve.html" class="btn btn-default btn-cuestionario">{"Ver"|x_translate}</a>
                            </div>
                        {else}
                            <div class="col-xs-12" {if $cant_capsulaFinalizadas <=0} style="padding: 0px;" {/if} >
                                <img class="noResultados" src="{$IMGS}noexistenresultados.jpg" />
                            </div>
                        {/if}
                    </div>

                </div>

            </div>
        </div>

    {/if}
    <!-- termina la tercera fila -->

    {if $account.user.tipo_usuario|in_array:['1','5']} 
        {if $cant_cuestionario_preparado.cantidad >0 || $cant_cuestionario_finalizado.cantidad >0 }
            <div class="row" style="text-align: center; margin-bottom: 30px;">
                <apan style="font-weight: 600;">
                    {"Cuestionario en espera"|x_translate}
                </apan>
            </div>
            <!-- cuarta fila de cards -->

            <div class="row-cards" style="margin-top: 0px;">
                <input type="hidden" id="idcuestionario" value="{$cuestionario_listo.idcuestionario}">
                <div class="okm-row  card-wrapper">

                    <div class="card-container col-md-12 col-sm-12" >
                        <div class="okm-row">
                            <h4 style="font-size: 18px; font-weight: 600; color:  #000000;" class="title text-center">{"Tu juego esta listo puedes enviarlo !"|x_translate}</h4>
                        </div>
                        <div class="card row" style="background-color: white; color: black; box-shadow: 2px 2px 10px 0 #979797; {if $cant_cuestionario_preparado.cantidad <=0} padding: 0px; {/if}">
                            {if $cant_cuestionario_preparado.cantidad >0}
                                <div class="container-inputs" style="margin-top: 20px; text-align: center;">
                                    <div class="col-xs-12" >
                                        <label style="font-size: 16px; font-weight: 600; color: #1A3661;"  class="mapc-label label-personalizar"> {"Generar codigo QR"|x_translate}</label>
                                    </div>
                                    <div class="div-circulo">
                                        <span style="position: relative;  bottom: 25px;">{$cant_cuestionario_preparado.cantidad}
                                        </span>
                                    </div>
                                    <div class="col-xs-12">
                                        <div style="background-color: #ebebeb;  height: 30px; margin-top: 10px;">
                                            <label style="line-height: 1.8"  class="mapc-label label-personalizar"> {if $cuestionario_listo.cantidad >0}{$cuestionario_listo.cantidad} {/if}  {"Preguntas"|x_translate}</label>
                                        </div>
                                    </div>
                                    <div class="col-xs-12" style="display: flex;    margin-top: 20px;">
                                        <label style="line-height: 2;"  class="mapc-label label-personalizar"> {"Fin:"|x_translate}</label>
                                        <input style="width: 120px; height: 30px; margin-left: 204px; margin-right: 0px; padding: 0px; font-size: 18px; text-align: center;"  disabled value="{$cuestionario_listo.fecha_fin|date_format:"%d/%m/%y"}"  class="input-personalizar" />
                                    </div>
                                    <div class="col-xs-12" style="margin-top: 10px; text-align: left;">
                                        <label style="color: #ED799E; font-size: 13px;"  class="mapc-label label-personalizar">{$cuestionario_listo.cantidad}  {"Sesiones para ganar, por sorteo"|x_translate}</label>
                                    </div>

                                </div>
                                <div class="okm-row text-center">
                                    <a id="btnEviarCuestionario" style="background: #ED799E  !important;"    class="btn btn-default">{"Ver"|x_translate}</a>
                                </div>
                            {else}
                                <div class="col-xs-12" {if $cant_cuestionario_preparado.cantidad <=0} style="padding: 0px;" {/if} >
                                    <img class="noResultados" src="{$IMGS}noexistencuestionarios.jpg" />
                                </div>
                            {/if}
                        </div>

                    </div>

                </div>


                <div class="okm-row  card-wrapper">

                    <div class="card-container col-md-12 col-sm-12" >

                        <div class="okm-row">
                            <h4 style="font-size: 18px; font-weight: 600; color:  #000000;" class="title text-center">{"Juego en curso..."|x_translate}</h4>
                        </div>
                        <div class="card row" style="background-color: #ED799E !important; color: white; {if $cant_cuestionario_finalizado.cantidad <=0} padding: 0px; {/if}" >
                            {if $cant_cuestionario_finalizado.cantidad >0 }
                                <div class="okm-row">
                                    <span>{"Fin"|x_translate}:</span>
                                    <span class="number pull-right">{$ultimo_cuestionario_finalizado.fecha_fin|date_format:"%d/%m/%y"}</span>
                                </div>
                                <div class="okm-row">
                                    <span>{"En curso"|x_translate}:</span>
                                    <span class="number pull-right">{if $cantReaspuestas!=""}{$cantReaspuestas}{else}0{/if}/{if $ultimo_cuestionario_finalizado.estimacion_cuestionarios_totales!=""}{$ultimo_cuestionario_finalizado.estimacion_cuestionarios_totales}{else}0{/if}</span>
                                </div>

                                <div class="okm-row">
                                    <span>{"Tasa de respuesta estimada"|x_translate}:</span>
                                    <span class="number pull-right">

                                        {if $tasa_de_respuesta!=""}
                                            {$tasa_de_respuesta}%
                                        {else}
                                            0%
                                        {/if}

                                    </span> 
                                </div>

                                <div class="okm-row text-center" style="position: relative; top: 10px;">
                                    <a style="background: #eba2b9 !important"  href="{$url}entreprises/questionnairelistacheve.html" class="btn btn-default">{"Ver"|x_translate}</a>
                                </div>
                            {else}
                                <div class="col-xs-12" {if $cant_cuestionario_finalizado.cantidad <=0} style="padding: 0px;" {/if} >
                                    <img class="noResultados" src="{$IMGS}noexistenresultados.jpg" />
                                </div>
                            {/if}
                        </div>

                    </div>

                </div>


            </div>
        {/if}
    {/if}
    <!-- termina la cuarta fila de card aca --> 

    {if $account.user.tipo_usuario|in_array:['1','3','4'] } 
        {if $empresa.obra_social!="1" && $empresa.plan_idplan!='21' && $empresa.plan_idplan!='22'}
            <div class="okm-row  card-wrapper ">
                <div class="card-container col-md-8 col-sm-12" >

                    <div class="card card-presupuesto-maximo row">
                        <div class="okm-row title-container">
                            <h4>{"Credito disponible"|x_translate}:
                                <span class="number pull-right">
                                    {if $info_beneficiarios.credito_disponible}
                                        &euro;&nbsp;{$info_beneficiarios.credito_disponible}
                                    {else}
                                        &euro;&nbsp;0
                                    {/if}
                                </span>
                            </h4>
                        </div>

                        <div class="row">
                            <div class="col-md-6 ">
                                <span>{"Saldo inicial"|x_translate}:</span>
                                <span class="number pull-right">

                                    {if $empresa.presupuesto_maximo!=""}
                                        &euro;&nbsp;{$empresa.presupuesto_maximo}
                                    {else}
                                        &euro;&nbsp;0
                                    {/if}

                                </span>
                            </div>
                            <div class="col-md-6">
                                <span>{"Consumo mensual"|x_translate}:</span>
                                <span class="number pull-right">

                                    {if $info_beneficiarios.consumo_beneficiarios!=""}
                                        &euro;&nbsp;{$info_beneficiarios.consumo_beneficiarios}
                                    {else}
                                        &euro;&nbsp;0
                                    {/if}

                                </span>
                            </div>
                        </div>

                        <div class="okm-row text-center">
                            <a style="background-color: #1E93B4 !important;" id="btnModificarPreferencias" class="btn btn-default">{"Modificar"|x_translate}</a>
                        </div>

                    </div>

                </div>

            </div>
        {/if}
    {/if}

    <div class="okm-row card-wrapper">
        {if $account.user.tipo_usuario|in_array:['1','3','4'] } 
            <div class="card-container col-md-6 col-sm-12">
                <div  class="card  card-white  row">
                    <div class="okm-row">
                        <h4 style="color: #1A3661;" class="title text-center">{"Gestión de beneficiarios"|x_translate}</h4>
                    </div>
                    <div class="okm-row">
                        <span style="color: #1A3661;">{"Beneficiarios verificados"|x_translate}:</span>
                        <span style="color: #1A3661;" class="number pull-right">
                            {$info_beneficiarios.beneficiarios_verificados}{if $info_beneficiarios.beneficiarios_inscriptos>0}/{$info_beneficiarios.beneficiarios_inscriptos}{/if}
                        </span>
                    </div>

                    <div class="okm-row">
                        <span style="color: #1A3661;">{"Tasa de verificación"|x_translate}:</span>
                        <span style="color: #1A3661;" class="number pull-right">
                            {if $info_beneficiarios.tasa_verificacion!=""}
                                {$info_beneficiarios.tasa_verificacion}%
                            {else}
                                0%
                            {/if}
                        </span>
                    </div>
                    <div class="okm-row text-center">
                        <div class="col-md-6">
                            <a id="btnGestionarBeneficiarios" style="background: #1E93B4 !important;" href="{$url}entreprises/beneficiaires.html" class="btn btn-default">{"Ver"|x_translate}</a>
                        </div>
                        <div class="col-md-6">
                            <span style="color: #1A3661;" class="txt-validacion-automatica">  {"Validacion automatica"|x_translate}</span> 
                            <label class="checkbox check-validacion">
                                <input id='validacionAutomatica' type="checkbox" class="select-todos-beneficiarios" value=""  data-toggle="checkbox" class="custom-checkbox">
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        {/if}
        {if $account.user.tipo_usuario|in_array:['1','2','4'] } 
            <div class="card-container col-md-6 col-sm-12" >
                <div style="background-color: white;" class="card row">
                    <div class="okm-row">
                        <h4 style="color: #4582B4;" class="title text-center">{"Facturas"|x_translate}</h4>
                    </div>


                    <div class="okm-row text-center">
                        <a style="background: #4582B4 !important;" id="btnFacturacion" href="{$url}entreprises/factures.html" class="btn btn-default btn-enviar-pass">{"Acceder"|x_translate}</a>
                    </div>
                </div>
                {if $completar_info_facturacion=="1"}
                    <div class="text-center">
                        <label class="red alert">
                            <i class="fa fa-exclamation-circle"></i> {"Debe completar su información de facturación"|x_translate}
                        </label>
                    </div>
                {/if}
            </div>
        {/if}

    </div>
</section>   

<!--	MODAL - Generar nueva invitación	-->


<div id="modal-generar-nueva-invitacion" class="modal fade bs-example-modal-lg vc-modal-interrupcion vc-refund-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><i class="fa fa-times"></i></span></button>
            </div>
            <div class="modal-body">
                <figure class="modal-icon"><i class="fa fa-envelope-o"></i></figure>
                <h3 class="modal-sub-title">{"Generar una nueva invitación"|x_translate}</h3>
                <h4 class="modal-title">{"Al generar una nueva invitación para sus beneficiarios la actual ya no se encontrará disponible y deberán usar la nueva para registrarse."|x_translate}</h3>
            </div>
            <div class="modal-footer">
                <div class="modal-action-row">
                    <a href="javascript:;" class="btn-default" id="confirmarEnviarInvitación" >{"continuar"|x_translate}</a>
                </div>
            </div>
        </div>
    </div>
</div>
{literal}
    <script>
        $(function () {
            $(document).ready(function (e) {

                if ($('#validacion_automatica').val() == '1') {
                    $('#validacionAutomatica').prop("checked", true);
                } else {
                    $('#validacionAutomatica').prop("checked", false);
                }

            });

            $(function () {
                //metodo para reenviar la invitación a los beneficiarios
                /*$("#btnEnviarInvitación").click(function () {
                 $("#modal-generar-nueva-invitacion").modal("show");
                 });*/
                //metodo para reenviar la invitación a los beneficiarios
                $("#btnEnviarInvitación").click(function () {
                    //$("#modal-generar-nueva-invitacion").modal("hide");
                    idempresa = $(this).data("idempresa");
                    if (idempresa == '21' || idempresa == '22' || idempresa == '23') {
                        x_alert(x_translate("Funcionabilidad no habilitada para su tipo de usuario"));
                    } else {
                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + "empresa.php?action=1&modulo=home&submodulo=generar_hash_invitacion",
                                "",
                                function (data) {

                                    if (data.result) {
                                        x_loadModule('home', 'enviar_invitacion', 'id=' + data.hash, 'Main').then(function () {
                                            $("body").spin(false);
                                        });
                                    } else {
                                        $("body").spin(false);
                                        x_alert(data.msg);
                                    }
                                });
                    }

                }
                );
                //metodo para desplegar el form de preferencias de los beneficiarios y modificarlas
                $("#btnModificarPreferencias").click(function () {
                    $("#modal-info-beneficiarios").modal("show");
                });
                $("#btnEviarCuestionario").click(function () {
                    idcuestionario = $("#idcuestionario").val();
                    $("body").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=generar_hash_cuestionario",
                            "idcuestionario=" + idcuestionario,
                            function (data) {

                                if (data.result) {
                                    // console.log(data.hash);
                                    x_loadModule('gestion', 'cuestionario_listo', 'id=' + data.hash, 'Main').then(function () {
                                        $("body").spin(false);
                                    });
                                } else {
                                    $("body").spin(false);
                                    x_alert(data.msg);
                                }
                            });
                });

                $("#btnEviarCapsula").click(function () {
                    idcapsula = $("#idcapsula").val();
                    $("body").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "empresa.php?action=1&modulo=capsula&submodulo=generar_hash_capsula",
                            "idcapsula=" + idcapsula,
                            function (data) {

                                if (data.result) {
                                    // console.log(data.hash);
                                    x_loadModule('capsula', 'capsula_lista', 'id=' + data.hash, 'Main').then(function () {
                                        $("body").spin(false);
                                    });
                                } else {
                                    $("body").spin(false);
                                    x_alert(data.msg);
                                }
                            });
                });


            });
            $('#validacionAutomatica').on('change', function () {
                idempresa = $('#idempresa').val();
                if ($(this).is(':checked')) {

                    jConfirm({
                        title: x_translate("Aceptar validacion automatica"),
                        text: x_translate('Sus beneficiarios seran aceptados automaticamente. ¿Desea aceptar?'),
                        confirm: function () {
                            $("body").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + "empresa.php?action=1&modulo=home&submodulo=actualizar_validacion_automatica",
                                    "idempresa=" + idempresa + '&validacion_automatica=1',
                                    function (data) {

                                        if (data.result) {
                                            window.location.href = BASE_PATH + "entreprises/";

                                        } else {
                                            $("body").spin(false);
                                            x_alert(data.msg);
                                        }
                                    });
                        },
                        cancel: function () {

                        },
                        confirmButton: x_translate("Si"),
                        cancelButton: x_translate("No")
                    });
                } else {
                    jConfirm({
                        title: x_translate("Cancelar validacion automatica"),
                        text: x_translate('Sus beneficiarios deberan ser aceptados manualmente. ¿Desea aceptar?'),
                        confirm: function () {
                            $("body").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + "empresa.php?action=1&modulo=home&submodulo=actualizar_validacion_automatica",
                                    "idempresa=" + idempresa + '&validacion_automatica=0',
                                    function (data) {

                                        if (data.result) {
                                            window.location.href = BASE_PATH + "entreprises/";
                                        } else {
                                            $("body").spin(false);
                                            x_alert(data.msg);
                                        }
                                    });
                        },
                        cancel: function () {

                        },
                        confirmButton: x_translate("Si"),
                        cancelButton: x_translate("No")
                    });
                }

            });


            $("#funcionFuturo").click(function () {
                x_alert(x_translate("prochainement disponible"));
            });



        });
    </script>
{/literal}