<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>WorknCare - Cabinet virtuel </title>
        <script src="{$url}xframework/core/libs/libs_js/jquery-1.11.1.min.js"></script>
        <script src="{$url}xframework/core/libs/libs_js/socket-io/socket.io-1.7.3.min.js"></script>



        <script type="text/javascript">
            var BASE_PATH = "{$url}";
            var VIDEOCONSULTA_DURACION = {$VIDEOCONSULTA_DURACION};
            var VIDEOCONSULTA_VENCIMIENTO_SALA ={$VIDEOCONSULTA_VENCIMIENTO_SALA};
            var VIDEOCONSULTA_NOTIFICAR_MEDICO_DEMORADO ={$VIDEOCONSULTA_NOTIFICAR_MEDICO_DEMORADO};

            var SERVER_EASYRTC_PORT ={$SERVER_EASYRTC_PORT};
            var account ={ldelim}"idusuarioweb":{$account.id}, "idpaciente":{$account.paciente.idpaciente}{rdelim};
        </script>  
        {include file="js_templates/a_run.tpl"}
        {x_js_global debug=1} 
        {x_css_global debug=0}  

        <!-- Assumes global locations for socket.io.js and easyrtc.js -->

        {*<script type="text/javascript" src="{$url_js_libs}/easyrtc/api/easyrtc.js"></script>*}
        {*<script type="text/javascript" src="{$url_js_libs}/easyrtc/api/easyrtc_ft.js"></script>*}
        <script src="https://webrtc.github.io/adapter/adapter-latest.js"></script>
        <script src="https://static.opentok.com/v2/js/opentok.min.js"></script>

        <!-- menu emergende de mi perfil -->
        <link rel="stylesheet" type="text/css" href="{$url}xframework/app/paciente_p/view/css/fix.css?v={$smarty.now|date_format:"%j"}" />
        <link rel="stylesheet" type="text/css" href="{$url}xframework/app/paciente_p/view/css/consultorio-virtual.css?v={$smarty.now|date_format:"%j"}" />

        <link rel="shortcut icon" href="{$IMGS}icono-url.png" type="image/png" />

    </head>

    {*include file="home/header_videoconsulta.html"*}
    {include file="$content"}

    {include file="js_templates/z_run.tpl"}


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
                        <img class="img-responsive" src="{$IMGS}safari_logo.png"/>
                        <p>{"Algunas funcionalidades solo están disponibles para el navegador Safari de su dispositivo por el momento"|x_translate}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
                //configuracion de url de conexion al servidor de videoconsultas
                // easyrtc.setSocketUrl(BASE_PATH.slice(0,-1)+":"+SERVER_EASYRTC_PORT);
    </script>
</html>