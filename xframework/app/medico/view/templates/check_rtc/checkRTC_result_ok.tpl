<div class="text-center">
    <h3>{"Usted puede realizar una video consulta"|x_translate}</h3>
    {* botones pop up*}
    {if $smarty.request.fromajax=="1"}
        <div class="button-container">
            <a id="btnNuevoTestOK" href="javascript:;" class="btn-default btn-inverse">
                {"Ejecutar otra vez"|x_translate}
            </a>
            <a href="javascript:;" id="btnContinuarOK" class="btn-default">
                {"Continuar"|x_translate}
            </a>
        </div>
    {else}
        <div class="button-container">
            <a href="" class="btn-default btn-inverse">
                {"Ejecutar otra vez"|x_translate}
            </a>
            <a href="{$url}panel-medico/videoconsulta/" class="btn-default">
                {"Continuar"|x_translate}
            </a>
        </div>
    {/if}
</div>
{literal}
    <script>
        $(function () {
            $("#btnContinuarOK").click(function () {
                localStorage.setItem('hide_checkrtc_modal', 1);
                $("#run-checkrtc").modal("hide");
                $("#checkRTC_container").empty();
            });
            $("#btnNuevoTestOK").click(function () {
                $("#checkRTC_container").spin("large");
                x_loadModule('check_rtc', 'checkRTC', '', 'checkRTC_container').then(function () {
                    $("#checkRTC_container").spin(false);
                });
            });
        });
    </script>
{/literal}
