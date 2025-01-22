<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width, height=device-height, target-densitydpi=device-dpi">
        <title>WorknCare | Patient</title>
        {if $submodulo == "busqueda_profesional_resultado" || $submodulo=="detalle_profesionales_frecuentes" || $submodulo=="sacar_turno_step_1" || $submodulo=="medicos_programa"}
            <script type="text/javascript"   src="https://maps.google.com/maps/api/js?key={$GOOGLE_MAPS_KEY}&language=fr"></script>
        {/if}


        <script src="{$url}xframework/core/libs/libs_js/socket-io/socket.io-1.7.3.min.js"></script>

        <script type="text/javascript">
            var BASE_PATH = "{$url}";
            var PATH_IMGS = "{$IMGS}";
            var VIDEOCONSULTA_DURACION = {$VIDEOCONSULTA_DURACION};
            var account ={ldelim}"idusuarioweb":{$account.id}, "idpaciente":{$account.paciente.idpaciente}{rdelim};

        </script>  
        <script src="{$url}xframework/core/libs/libs_js/jquery-1.11.1.min.js"></script>

        {include file="js_templates/a_run.tpl"}

        {x_js_global debug=1} 
        {x_css_global debug=1}  



        <link rel="shortcut icon" href="{$IMGS}icono-url.png" type="image/png" />
        <link href="{$url}xframework/app/themes/dp02/css/pass_esante.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="{$url}xframework/app/paciente_p/view/css/notify-metro.css?v={$smarty.now|date_format:"%j"}" />
        <link rel="stylesheet" type="text/css" href="{$url}xframework/app/paciente_p/view/css/fix.css?v={$smarty.now|date_format:"%j"}" />
        <link rel="stylesheet" type="text/css" href="{$url}xframework/app/paciente_p/view/css/fix-enviar-consulta.css?v={$smarty.now|date_format:"%j"}" />
        <link rel="stylesheet" type="text/css" href="{$url}xframework/app/paciente_p/view/css/fix-buscador-medicos.css?v={$smarty.now|date_format:"%j"}" />
        <link rel="stylesheet" type="text/css" href="{$url}xframework/app/paciente_p/view/css/fix-consultas.css?v={$smarty.now|date_format:"%j"}" />
        <link rel="stylesheet" type="text/css" href="{$url}xframework/app/paciente_p/view/css/fix-header-menu.css?v={$smarty.now|date_format:"%j"}" />
        <link href="{$url}xframework/app/themes/dp02/css/_paciente-reembolso.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet" type="text/css" />
        <script src="https://kit.fontawesome.com/9430201514.js" crossorigin="anonymous"></script>
    </head>
    <body>

        <div class="modal modal-type-2 modal-type-size-small" data-load="no" id="configurar-tablero" data-keyboard="false" data-backdrop="true" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content"></div>
            </div>
        </div>

        <div class="modal" id="winModal" data-load="no" data-keyboard="false" data-backdrop="true" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">	
                </div>
            </div>
        </div>
        {* 
        <div class="modal " id="winModalLg" data-keyboard="false" data-backdrop="true" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog  modal-lg">
        <div class="modal-content">	
        </div>
        </div>
        </div>*}
        <script>
                Dropzone.autoDiscover = false;
        </script>
        <script>
            $(document).ready(function (e) {
                $('#winModal').on('hidden.bs.modal', function () {
                    $(this).removeData('bs.modal')
                            .find(".modal-content").html('');

                });
                $('#configurar-tablero').on('hidden.bs.modal', function () {
                    $(this)
                            .removeData('bs.modal')
                            .find(".modal-content").html('');

                });
            });
        </script>  
        <div class="main-content-wrapper"> 

            {include file="home/header.tpl"}

            <div class="" id="Main">        
                {include file="$content"}
            </div>


        </div>
        {include file="home/footer.tpl"}
        <!--Modal sugerencia usabilidad horizontal-->
        <div class="" id="check_window_orientation"></div>


        <div class="modal fade modal-type-2 modal-type-size-small" data-load="no" id="usabilidad-modal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>
                    <div class="form-content">
                        <h5>{"Sugerencia de usabilidad"|x_translate}</h5>
                        <p><img src="{$IMGS}usabilidad.png" height="67" width="241" alt=""></p>
                        <p>{"Navegar esta sección con la pantalla en sentido horizontal"|x_translate}</p>
                    </div>
                </div>
            </div>
        </div>	

        <!--	Modal iOS Usabilidad	-->
        <div class="modal fade bs-example-modal-lg modal-chrome" id="modal-usabilidad-ios" data-load="no" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    </div>
                    <div class="modal-body">
                        <div class="chrome-modal-holder">
                            <h2>{"Sugerencia de usabilidad"|x_translate}</h2>
                            <img class="img-responsive" src="{$IMGS}safari_logo.png" alt="Sugerencia de usabilidad iOS"/>
                            <p>{"Algunas funcionalidades solo están disponibles para el navegador Safari de su dispositivo por el momento"|x_translate}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!--	ALERTAS -  actualizar listado	-->
        <div id="modal-notificar_conclusion_vc_pendiente" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" data-load="no" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"  aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">{"¡El profesional aún no ha escrito su informe!"|x_translate}</h4>
                    </div>
                    <div class="modal-body">
                        <p>
                            {"Se le notificará cuando esté listo"|x_translate}
                        </p>
                    </div>
                </div>
            </div>
        </div>


        <script>
            //modales
            $(function () {
                $("#usabilidad-modal .close-btn").click(function () {
                    if (window.sessionStorage) {
                        sessionStorage.setItem("mostrar_modal_usabilidad", "0");
                    }

                });
                actualizar_notificaciones();
                //mostramos modal notificar_conclusion_vc_pendiente
                var notificar_conclusion_vc_pendiente = sessionStorage.getItem('notificar_conclusion_vc_pendiente');
                if (notificar_conclusion_vc_pendiente === '1') {
                    $("#modal-notificar_conclusion_vc_pendiente").modal("show");
                }
                $("#modal-notificar_conclusion_vc_pendiente").on('hidden.bs.modal', function () {
                    sessionStorage.setItem('notificar_conclusion_vc_pendiente', '0');
                });




            });
        </script>


        {include file="js_templates/node_run.tpl"}
        {include file="js_templates/z_run.tpl"}
        <script type="text/javascript">
            $(document).ready(function () {

                $(':checkbox').radiocheck();



            });
        </script>

        <div class="visible-xs visible-sm"  id="visible-mobile"></div>

    </body>
</html>