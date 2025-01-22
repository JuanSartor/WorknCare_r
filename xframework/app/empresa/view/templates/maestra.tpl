<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width, height=device-height, target-densitydpi=device-dpi">
        <title>WorknCare | Entreprises</title>


        <script src="{$url}xframework/core/libs/libs_js/socket-io/socket.io-1.7.3.min.js"></script>

        <script type="text/javascript">
            var BASE_PATH = "{$url}";
            var PATH_IMGS = "{$IMGS}";


        </script>  
        <script src="{$url}xframework/core/libs/libs_js/jquery-1.11.1.min.js"></script>

        {include file="js_templates/a_run.tpl"}

        {x_js_global debug=1} 
        {x_css_global debug=1}  



        <link rel="shortcut icon" href="{$IMGS}icono-url.png" type="image/png" />
        <link rel="stylesheet" type="text/css" href="{$url}xframework/app/paciente_p/view/css/notify-metro.css?v={$smarty.now|date_format:"%j"}" />
        <link rel="stylesheet" type="text/css" href="{$url}xframework/app/paciente_p/view/css/fix-header-menu.css?v={$smarty.now|date_format:"%j"}" />
        <link rel="stylesheet" type="text/css" href="{$url}xframework/app/themes/dp02/css/main_empresa.css?v={$smarty.now|date_format:"%j"}" />
        <link rel="stylesheet" type="text/css" href="{$url}xframework/app/themes/dp02/css/pass_esante_registro.css?v={$smarty.now|date_format:"%j"}" >
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
                {if $userempre.tipo_usuario == '1'}
                    {if $smarty.request.submodulo !='cuestionario_listo' && $smarty.request.submodulo !='capsula_lista'}
                        <nav class="section-header ce-ca-top profile">
                            <div class="container">
                                <div class="okm-row">
                                    <div class="user-select pull-left user-select-sonsulta-express-rsp">
                                        <a href="javascript:;"  data-toggle="modal" data-target="#modal-plan-contratado">
                                            <h1 class="section-name">
                                                <strong> {$plan_contratado.nombre} <i class="fa fa-chevron-right"></i></strong>
                                            </h1>
                                        </a>
                                    </div>
                                    <div class="top-nav-icons-select-combo">
                                        <div class="okm-row">

                                            <div class="consulta-express-pull-right">

                                            </div>
                                        </div>
                                    </div>
                                </div> 
                            </div>
                        </nav>
                    {/if}
                {/if}
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

        {include file="js_templates/z_run.tpl"}
        <script type="text/javascript">
            $(document).ready(function () {

                $(':checkbox').radiocheck();

            });
        </script>

        <div class="visible-xs visible-sm"  id="visible-mobile"></div>

    </body>
</html>