{include file="videoconsulta/videoconsulta_settings.tpl"}
<input type="hidden" id="idvideoconsulta" value="{$VideoConsulta.idvideoconsulta}">
<script src="https://js.stripe.com/v3/"></script>
<div id="videoconsulta-step-container" class="relative" ></div>

{*seleccionamos que pantalla se va a cargar de acuerdo al paso en el que se encuentra la CE*}
{if $VideoConsulta && $VideoConsulta.consulta_step==1 ||  $VideoConsulta.consulta_step==3 || $VideoConsulta.consulta_step==4 ||$VideoConsulta.consulta_step==5 }
    <script>
        $("body").spin("large");
        x_loadModule('videoconsulta', 'nuevavideoconsulta_step{$VideoConsulta.consulta_step}', 'idvideoconsulta={$VideoConsulta.idvideoconsulta}', 'videoconsulta-step-container', BASE_PATH + "paciente_p").then(function () {
            $("body").spin(false);
        });
    </script>

{else}
    <script>
        $("body").spin("large");
        x_loadModule('videoconsulta', 'nuevavideoconsulta_step1', '', 'videoconsulta-step-container', BASE_PATH + "paciente_p").then(function () {
            $("body").spin(false);
        });
    </script>
{/if}


{literal}
    <script>
        $(function () {

            //eliminamos la consulta en borrador y recargamos
            $("#videoconsulta-step-container").on("click", "#btn-delete-consulta,#btn-cancelar-consulta", function () {
                jConfirm({
                    title: x_translate("Cancelar Video Consulta"),
                    text: x_translate('Está por cancelar la Video Consulta. ¿Desea continuar?'),
                    confirm: function () {
                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'delete_videoconsulta_borrador.do',
                                'idvideoconsulta=' + $("#idvideoconsulta").val(),
                                function (data) {
                                    $("body").spin(false);
                                    if (data.result) {
                                        window.location.href = BASE_PATH + "panel-paciente/videoconsulta/";
                                    } else {
                                        x_alert(data.msg);
                                    }
                                }
                        );
                    },
                    cancel: function () {

                    },
                    confirmButton: x_translate("Si"),
                    cancelButton: x_translate("No")
                });
            });

        });
    </script>
{/literal}

