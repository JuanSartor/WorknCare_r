<!DOCTYPE html>
<html lang="{$TRADUCCION_IDIOMA}">
    <head>

        {if $url!=="https://www.workncare.io/"}
            <meta name="robots" content="noindex">
            <meta name="googlebot" content="noindex">
        {/if}
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width, height=device-height, target-densitydpi=device-dpi">

        {include file="seo/meta_tags.tpl"}


        <title>WorknCare</title>
        {include file="js_templates/a_run.tpl"}


        <script type="text/javascript">
            var BASE_PATH = "{$url}";
        </script>  
        <script type="text/javascript" src="{$url}xframework/core/libs/libs_js/jquery-1.11.1.min.js"></script>
        {* si no es la home, cargamos libs js primero*}
        {if $submodulo != "index"}
            {x_js_global debug=1} 
        {/if}

        {x_css_global debug=1}  



        <link rel="shortcut icon" href="{$IMGS}icono-url.png" type="image/png" />
        <link href="{$url}xframework/app/themes/dp02/css/pass_esante.css" rel="stylesheet">
        <link href="{$url}xframework/app/frontend_2/view/css/fix.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet">
        <link href="{$url}xframework/app/frontend_2/view/css/fix-buscador-medicos.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet">
        {*JS*}
        {if $submodulo == "busqueda_profesional_resultado" || $submodulo=="detalle_profesionales_frecuentes" || $submodulo=="medicos_programa" }
            <script type="text/javascript"   src="https://maps.google.com/maps/api/js?key={$GOOGLE_MAPS_KEY}&language={$TRADUCCION_IDIOMA}"></script>
        {/if}


    </head>
    <body >
        <div id="third_party_plugin_container">

        </div>

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
            $(document).ready(function (e) {
                $('#winModal').on('hidden.bs.modal', function () {
                    $(this)
                            .removeData('bs.modal')
                            .find(".modal-content").html('');

                });
            });
        </script>  
        <div class="main-content-wrapper"> 
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

        {* 
        <!--WhatsApp DoctorPlus -->

        <div class="floating-wpp" style="z-index:8; bottom: 0px; "></div>
        <style>
        .floating-wpp-button{
        background-color: transparent !important;
        box-shadow: none !important;
        }    
        @media(max-width:600px) {
        .floating-wpp-button{
        width: 60px !important;
        height: 60px !important;
        }
        }

        </style>
      
        <script>
        $(function () {
        $('.floating-wpp').floatingWhatsApp({
        phone: '+33609816934',
        popupMessage: x_translate('Escríbanos'),
        showPopup: true,
        message: '',
        headerTitle: 'DoctorPlus WhatsApp',
        buttonImage: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 55 55" width="48px" height="48px"><path fill="#fff" d="M4.868,43.303l2.694-9.835C5.9,30.59,5.026,27.324,5.027,23.979C5.032,13.514,13.548,5,24.014,5c5.079,0.002,9.845,1.979,13.43,5.566c3.584,3.588,5.558,8.356,5.556,13.428c-0.004,10.465-8.522,18.98-18.986,18.98c-0.001,0,0,0,0,0h-0.008c-3.177-0.001-6.3-0.798-9.073-2.311L4.868,43.303z"/><path fill="#fff" d="M4.868,43.803c-0.132,0-0.26-0.052-0.355-0.148c-0.125-0.127-0.174-0.312-0.127-0.483l2.639-9.636c-1.636-2.906-2.499-6.206-2.497-9.556C4.532,13.238,13.273,4.5,24.014,4.5c5.21,0.002,10.105,2.031,13.784,5.713c3.679,3.683,5.704,8.577,5.702,13.781c-0.004,10.741-8.746,19.48-19.486,19.48c-3.189-0.001-6.344-0.788-9.144-2.277l-9.875,2.589C4.953,43.798,4.911,43.803,4.868,43.803z"/><path fill="#cfd8dc" d="M24.014,5c5.079,0.002,9.845,1.979,13.43,5.566c3.584,3.588,5.558,8.356,5.556,13.428c-0.004,10.465-8.522,18.98-18.986,18.98h-0.008c-3.177-0.001-6.3-0.798-9.073-2.311L4.868,43.303l2.694-9.835C5.9,30.59,5.026,27.324,5.027,23.979C5.032,13.514,13.548,5,24.014,5 M24.014,42.974C24.014,42.974,24.014,42.974,24.014,42.974C24.014,42.974,24.014,42.974,24.014,42.974 M24.014,42.974C24.014,42.974,24.014,42.974,24.014,42.974C24.014,42.974,24.014,42.974,24.014,42.974 M24.014,4C24.014,4,24.014,4,24.014,4C12.998,4,4.032,12.962,4.027,23.979c-0.001,3.367,0.849,6.685,2.461,9.622l-2.585,9.439c-0.094,0.345,0.002,0.713,0.254,0.967c0.19,0.192,0.447,0.297,0.711,0.297c0.085,0,0.17-0.011,0.254-0.033l9.687-2.54c2.828,1.468,5.998,2.243,9.197,2.244c11.024,0,19.99-8.963,19.995-19.98c0.002-5.339-2.075-10.359-5.848-14.135C34.378,6.083,29.357,4.002,24.014,4L24.014,4z"/><path fill="#40c351" d="M35.176,12.832c-2.98-2.982-6.941-4.625-11.157-4.626c-8.704,0-15.783,7.076-15.787,15.774c-0.001,2.981,0.833,5.883,2.413,8.396l0.376,0.597l-1.595,5.821l5.973-1.566l0.577,0.342c2.422,1.438,5.2,2.198,8.032,2.199h0.006c8.698,0,15.777-7.077,15.78-15.776C39.795,19.778,38.156,15.814,35.176,12.832z"/><path fill="#fff" fill-rule="evenodd" d="M19.268,16.045c-0.355-0.79-0.729-0.806-1.068-0.82c-0.277-0.012-0.593-0.011-0.909-0.011c-0.316,0-0.83,0.119-1.265,0.594c-0.435,0.475-1.661,1.622-1.661,3.956c0,2.334,1.7,4.59,1.937,4.906c0.237,0.316,3.282,5.259,8.104,7.161c4.007,1.58,4.823,1.266,5.693,1.187c0.87-0.079,2.807-1.147,3.202-2.255c0.395-1.108,0.395-2.057,0.277-2.255c-0.119-0.198-0.435-0.316-0.909-0.554s-2.807-1.385-3.242-1.543c-0.435-0.158-0.751-0.237-1.068,0.238c-0.316,0.474-1.225,1.543-1.502,1.859c-0.277,0.317-0.554,0.357-1.028,0.119c-0.474-0.238-2.002-0.738-3.815-2.354c-1.41-1.257-2.362-2.81-2.639-3.285c-0.277-0.474-0.03-0.731,0.208-0.968c0.213-0.213,0.474-0.554,0.712-0.831c0.237-0.277,0.316-0.475,0.474-0.791c0.158-0.317,0.079-0.594-0.04-0.831C20.612,19.329,19.69,16.983,19.268,16.045z" clip-rule="evenodd"/></svg>'});
        });
        </script>
        *}



        {* si es Home, cargamos js al final*}
        {if $submodulo == "index"}
            {x_js_global debug=1} 
        {/if}

        {include file="js_templates/z_run.tpl"}
        <script type="text/javascript">
            $(document).ready(function () {

                $(':checkbox').radiocheck();

            });
        </script>

        <div class="visible-xs visible-sm"  id="visible-mobile"></div>
        {if $url=="https://www.workncare.io/"}
            {include file="statics/cookies_msg.tpl"}
        {/if}
    </body>
</html>