<link rel="stylesheet" type="text/css" href="{$url}xframework/app/paciente_p/view/css/fix-home.css?v={$smarty.now|date_format:"%j"}" />
<input type="hidden" id="idpaciente" name="idpaciente" value="{$paciente.idpaciente}"/>  
{if $miembro_seleccionado!=1}
    {include file="home/home_select_usuario.tpl"}
{else}
    {if $cant_recompensas_ganadas >0 && $cant_recompensas_ganadas!=''}
        <div class="header-prestaciones"> <img class="exclamacion" src="{$url}xframework/app/themes/dp02/img/sig-exclamacion.png">  {"Posee [[{$cant_recompensas_ganadas}]] prestaciones ganadas en encuestas!"|x_translate}</div>
        {/if}
        {if $paciente.titular==1 && $paciente.pais_idpais==1  && $paciente.beneficios_reintegro==1  && $paciente.cobertura_facturacion_step!=4}
            {include file="home/cobertura_facturacion.tpl"}
        {else}
            {if $empresa_beneficiario!='' && $prestaciones_disponibles >0 }
            <div class="header-prestaciones"> <img class="exclamacion" src="{$url}xframework/app/themes/dp02/img/sig-exclamacion.png">  {"Le restan [[{$prestaciones_disponibles}]] prestaciones a utilizar !"|x_translate}</div>
            {/if}
        <!-- <section class="pul-perfil-incompleto">
             <div class="container consulta-express-submenu home homepaciente">
                 <div class="row">
                     <div class="col-sm-12">
                         <h1 class="margin-bottom-h1">{"Consulte a su profesional de la salud por video o mensaje de texto"|x_translate}</h1>
                     </div>
                 </div>
             </div>
         </section> -->
        <!-- modal que se ejecuta para el primer inicio de sesion de beneficiarios -->
        <div class="okm-row text-center section-title ">
            <h2 class="pc-visible" style="background: none; -webkit-text-fill-color: initial;"> <span style="color:#F5C370;">Que </span> <span style="color:#EF9C73;">peut-on</span> <span style="color:#ED799E;">faire </span><span style="color:#3DB4C0;"> pour vous? </span></h2>
            <h2 class="mobile-visible"><span>Que peut-on faire</span><span>pour vous?</span></h2>
        </div>
        {if $empresa_beneficiario!='Particulier' && $empresa_beneficiario!='' && $paciente_logueado.wizard_primer_inicio_sesion==0 }
            {include file="home/modal_inicio_sesion.tpl"}
        {/if} 
        <!-- slider programas pass -->
        {if $empresa_beneficiario!='Particulier' && $empresa_beneficiario!=''}
            {include file="home/slider_programas_socios.tpl"}
        {/if}
        {include file="home/slider_programas_pass.tpl"}

        <!-- Medicos frecuentes-->
        {include file="home/home_new_medicos_frecuentes_nueva.tpl"}

        {* {include file="home/home_iconos.tpl"}  *}

        <!-- inicio Contenido especifico Para los pacientes que no agregaron sus datos + foto tarjeta cuando se abrieron la cuenta -->
        {if ($paciente.is_paciente_empresa=="0" && $paciente.titular==1 && ($paciente.pais_idpais == "" || $paciente.pais_idpais_trabajo == "")) && ($paciente_notificacion.notificacion_completardatos =='0') }
            <div class="okm-container" style="    background-color: #f2f2f2; padding-top:10px; padding-bottom:10px !important;">
                <div class="vc-interrumpidas-header">	
                    <i class="icon-doctorplus-alert-round"></i>
                    <h1>{"Su Video Consulta es reembolsable por la Seguridad Social"|x_translate}</h1>
                </div>
                <p class="vc-interrumpidas-aviso-importante paciente">
                    {"¡Complete esto porque potencialmente puede beneficiarse de un reembolso por sus consultas!"|x_translate}
                </p>
                <p class="text-center">
                    <a href="{$url}panel-paciente/informacion-paciente/?completer=1#titular_datos" class="btn btn-blue"> {"completar"|x_translate}</a>
                    <a id='btnMasTarde' class="btn btn-mastarde"> {"Mas Tarde"|x_translate}</a>
                </p>

            </div>
            <!-- fin Contenido especifico Para los pacientes que no agregaron sus datos + foto tarjeta cuando se abrieron la cuenta -->
        {else}
            <!-- Paciente titular frances declara medico de cabecera pero no lo ingresó-->
            {if $empresa_beneficiario=='Particulier' && $paciente.is_paciente_empresa=="0" && $paciente.titular==1 && $paciente.pais_idpais == 1 && $paciente.medico_cabeza==1 && $posee_medico_cabecera!=1}
                <div class="okm-container" style="    background-color: #f2f2f2; padding-top:10px; padding-bottom:10px !important;margin-bottom:20px;">
                    <div class="vc-interrumpidas-header">	
                        <i class="icon-doctorplus-alert-round"></i>
                        <h1>{"Si has declarado un médico tratante debe seleccionarlo"|x_translate}</h1>
                    </div>
                    <p class="vc-interrumpidas-aviso-importante paciente">
                        {"¡Complete esto porque potencialmente puede beneficiarse de un reembolso por sus consultas!"|x_translate}
                    </p>
                    <p class="text-center">
                        <a href="{$url}panel-paciente/informacion-paciente/?completer=1#titular_datos" class="btn btn-blue"> {"completar"|x_translate}</a>
                    </p>

                </div>
            {/if}
            <div id="perfil-incompleto-data-extra" >
                <div class="okm-container">
                    <div class="contenedor-agenda-consulta">
                        <div class="container-tercio {if $empresa_beneficiario=='Particulier' ||  $empresa_beneficiario==''}container-mitad margin-left-btn-particulier{/if}">
                            <!-- Visitas acordadas por paciente-->
                            {include file="home/home_new_turnos.tpl"}  
                        </div>
                        <div class="container-tercio {if $empresa_beneficiario=='Particulier' ||  $empresa_beneficiario==''}container-mitad margin-left-btn-particulier{/if}">
                            <!-- Consultas -->
                            {include file="home/home_new_consultas.tpl"} 
                        </div>
                        <div class="container-tercio">
                            <!-- Reintegro para beneficiarios -->
                            {if $empresa_beneficiario!='Particulier' && $empresa_beneficiario!=''}
                                {include file="home/home_new_reembolso_beneficiarios.tpl"} 
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- slider programas publicidad -->
        {include file="home/slider_programas.tpl"}

        {include file="home/home_new_cuestionario.tpl"} 

    {/if}
    <!-- lista medicos -->
    {* {include file="home/home_new_medicos_sugeridos_list.tpl"} *}

    {include file="home/modal_consulta_borrador.tpl"}

    {literal}
        <script type="text/javascript">
            /*verificamos si hay un medico seleccionado para sacar una consulta en el forntend*/
            var verificar_consultas_frontend = function () {


                var tipo_reserva = sessionStorage.getItem('tipo_reserva');
                var reserva_publica = sessionStorage.getItem('reserva_publica');
                console.log("tipo_reserva", tipo_reserva);

                //verificamos si hay una reserva seteada en la home publica
                if (reserva_publica) {

                    //--turno
                    if (tipo_reserva == "turno") {

                        $("body").spin("large");
                        console.log("sacar turno frontend");
                        idturno_frontend = sessionStorage.getItem('idreserva');
                        idprograma_categoria_seleccionado = sessionStorage.getItem('idprograma_categoria_seleccionado');
                        var url = BASE_PATH + "panel-paciente/busqueda-profesional/reservar-turno.html?turno=" + idturno_frontend + "&idprograma_categoria=" + idprograma_categoria_seleccionado;
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + "verificar_turno_disponible.do",
                                "idturno=" + idturno_frontend,
                                function (data) {
                                    if (data.result) {
                                        window.location.href = url;
                                    } else {
                                        $("body").spin(false);
                                        x_alert(data.msg);
                                    }
                                }


                        );
                    } else if (tipo_reserva == "turno_vc") {

                        $("body").spin("large");
                        console.log("sacar turno VC frontend");
                        idturno_frontend = sessionStorage.getItem('idreserva');
                        idprograma_categoria_seleccionado = sessionStorage.getItem('idprograma_categoria_seleccionado');
                        var url = BASE_PATH + "panel-paciente/busqueda-profesional/reservar-turno-video-llamada-" + idturno_frontend + ".html?idprograma_categoria=" + idprograma_categoria_seleccionado;
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + "verificar_turno_disponible.do",
                                "idturno=" + idturno_frontend,
                                function (data) {
                                    if (data.result) {
                                        window.location.href = url;
                                    } else {
                                        $("body").spin(false);
                                        x_alert(data.msg);
                                    }
                                }


                        );
                    } else if (tipo_reserva == "videoconsulta") {
                        //VC
                        var idmedico = sessionStorage.getItem('idreserva');
                        var idprograma_categoria_seleccionado = sessionStorage.getItem('idprograma_categoria_seleccionado');
                        console.log("idmedico", idmedico);
                        if (idmedico) {
                            console.log("sacar VC frontend");
                            if (parseInt(idmedico) > 0) {

                                $("body").spin("large");
                                x_doAjaxCall(
                                        'POST',
                                        BASE_PATH + 'set_medico_videoconsulta.do',
                                        'medico_idmedico=' + idmedico + '&idprograma_categoria=' + idprograma_categoria_seleccionado,
                                        function (data) {

                                            if (data.result) {
                                                window.location.href = BASE_PATH + "panel-paciente/videoconsulta/nuevavideoconsulta-front.html";
                                            } else {
                                                $("body").spin(false);
                                                x_alert(data.msg);
                                            }

                                        }

                                );
                            }
                        }

                    } else if (tipo_reserva == "consultaexpress") {
                        //CE
                        var idmedico = sessionStorage.getItem('idreserva');
                        var idprograma_categoria_seleccionado = sessionStorage.getItem('idprograma_categoria_seleccionado');
                        console.log("idmedico", idmedico);
                        if (idmedico) {
                            console.log("sacar CE frontend");
                            if (parseInt(idmedico) > 0) {

                                $("body").spin("large");
                                x_doAjaxCall(
                                        'POST',
                                        BASE_PATH + 'set_medico_consultaexpress.do',
                                        'medico_idmedico=' + idmedico + '&idprograma_categoria=' + idprograma_categoria_seleccionado,
                                        function (data) {

                                            if (data.result) {
                                                window.location.href = BASE_PATH + "panel-paciente/consultaexpress/nuevaconsulta.html?continue=true";
                                            } else {
                                                $("body").spin(false);
                                                x_alert(data.msg);
                                            }

                                        }

                                );
                            }
                        }

                    }
                }
                console.log("limpiamos session storage");
                sessionStorage.removeItem("tipo_reserva");
                sessionStorage.removeItem("idreserva");
                sessionStorage.removeItem("reserva_publica");
                sessionStorage.removeItem("idprograma_categoria_seleccionado");
            };

            $(document).ready(function () {
                /*verificamos si hay un medico seleccionado para sacar una consulta en el forntend*/
                verificar_consultas_frontend();

            });

            $("#btnMasTarde").click(function () {
                idpaciente = $("#idpaciente").val();
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "paciente_p.php?action=1&modulo=home&submodulo=actualizar_notificacion_completar_datos",
                        'idpaciente=' + idpaciente,
                        function (data) {
                            if (data.result) {
                                window.location.href = BASE_PATH + "panel-paciente/";

                            }
                        }

                );

            });


        </script>
    {/literal}
{/if}
{/if}
<div id="modal-primer-inicio-sesion" data-keyboard="false" data-backdrop="static" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion"  tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" onclick="cambiarPw(0);" class="close" data-dismiss="modal"  aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">{"¡Bienvenido a DoctorPlus!"|x_translate}</h4>
            </div>
            <div class="modal-body">
                <p>
                    {"Su contraseña ha sido generada automaticamente. A continuacion usted podra crear una nueva"|x_translate}
                </p>
            </div>


            <button id="btnCancelarCambioPw" onclick="cambiarPw(0);" data-dismiss="modal"  class="btn btn-alert btn-cancelar-cambio-pw">{"Cancelar"|x_translate}</button>

            <button id="btnaceptarCambioPw" onclick="cambiarPw(1);" class="btn btn-default btn-aceptar-cambio-pw">{"Cambiar contraseña"|x_translate}</button>


        </div>
    </div>
</div>
{if $estado_password==1}
    <script type="text/javascript">
        $('#modal-primer-inicio-sesion').modal("show");
        function cambiarPw(bandera) {

            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'paciente_p.php?action=1&modulo=home&submodulo=cambiar_pw_primer_inicio',
                    function () {
                    }
            );
            if (bandera == '1') {
                window.location.href = BASE_PATH + "panel-paciente/datos-administrador/#section-pw";
            }
        }
    </script>
{/if}
