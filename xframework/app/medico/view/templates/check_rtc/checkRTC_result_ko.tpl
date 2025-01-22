<div class="col-md-8 col-md-offset-2 text-center">

    <h3 id="KO_message">{"No puede realizar una videoconsulta en este dispositivo"|x_translate}</h3>

    <hr>
    <ul>

        <li id="isWebRTCSupported_error" class="errorDetail" style="display:none">
            {"Su explorador está desactualizado o no es compatible con la tecnología WebRTC requerida para inicial la consulta. Recomentamos que utilice Chrome, Firefox, Opera o Safari en sus últimas versiones. Si está utilizando MAC asegúrese de tener el sistema operativo actualizado"|x_translate}
        </li>
        <li id="isChromeIOS_error" class="errorDetail" style="display:none">
            {"Su explorador está desactualizado o no es compatible con la tecnología WebRTC requerida para iniciar la consulta. Recomentamos que utilice Safari en sus últimas versiones."|x_translate}
            <div class="text-center"> 
                <img src="{$IMGS}safari_logo.png"  style="width: 80px; margin: auto; padding: 5px;">
            </div>
        </li>

        <li id="isWebsitePermissions_error" class="errorDetail" style="display:none">
            {"No hemos podido acceder a la cámara/micrófono. Asegúrese de tener una cámara correctamente configurada en su explorador."|x_translate}
            {"Debe otorgrar permisos a DoctorPlus para acceder a la cámara y micrófono. Por favor asegurese de tener habilitado dichos permisos."|x_translate}
        </li>

        <li id="isConnectionquality_error" class="errorDetail" style="display:none">
            {"La velocidad de su conexión a internet no es suficiente para llevar a cabo una videoconsutla en forma fluida."|x_translate}
        </li>
        <li id="timeout_error" class="errorDetail" style="display:none">
            {"No se pudo iniciar el test. Por favor recargue la página e intente nuevamente. Asegurese  otorgrar permisos a DoctorPlus para acceder a la cámara y micrófono"|x_translate}
        </li> 
    </ul>
    {* botones pop up*}
    {if $smarty.request.fromajax=="1"}
        <div class="text-center" >
            <div class="button-container">
                <a id="btnNuevoTestKO" href="javascript:;" class="btn-default btn-inverse">
                    {"Ejecutar otra vez"|x_translate}
                </a>
                <a href="javascript:;" id="btnContinuarKO" class="btn-default">
                    {"Salir"|x_translate}
                </a>
            </div>
        </div>
    {else}
        <div class="text-center" >
            <div class="button-container">
                <a  href="" class="btn-default btn-inverse">
                    {"Ejecutar otra vez"|x_translate}
                </a>
                <a href="{$url}panel-medico/videoconsulta/" class="btn-default">
                    {"Salir"|x_translate}
                </a>
            </div>
        </div>

    {/if}
</div>
{literal}
    <script>
        $(function () {
            $("#btnContinuarKO").click(function () {
                $("#run-checkrtc").modal("hide");
            });
            $("#btnNuevoTestKO").click(function () {
                $("#checkRTC_container").spin("large");
                localStorage.setItem('reload_checkrtc', 1);
                window.location.href = "";


                /*x_loadModule('check_rtc', 'checkRTC', '', 'checkRTC_container').then(function () {
                 $("#checkRTC_container").spin(false);
                 });*/
            });

        });
    </script>
{/literal}

