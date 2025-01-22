{include file="consultaexpress/consultaexpress_settings.tpl"}
<input type="hidden" id="idconsultaExpress" value="{$ConsultaExpress.idconsultaExpress}">
<script src="https://js.stripe.com/v3/"></script>
<div id="consulta-express-step-container" class="relative" ></div>

{*seleccionamos que pantalla se va a cargar de acuerdo al paso en el que se encuentra la CE*}
{if $ConsultaExpress && $ConsultaExpress.consulta_step==1 || $ConsultaExpress.consulta_step==3 || $ConsultaExpress.consulta_step==4 ||$ConsultaExpress.consulta_step==5 }
        <script>
            $("body").spin("large");
            x_loadModule('consultaexpress', 'nuevaconsulta_step{$ConsultaExpress.consulta_step}', 'idconsultaExpress={$ConsultaExpress.idconsultaExpress}', 'consulta-express-step-container', BASE_PATH + "paciente_p").then(function () {
                $("body").spin(false);
            });
        </script>
    
{else}
    <script>
        $("body").spin("large");
        x_loadModule('consultaexpress', 'nuevaconsulta_step1', '', 'consulta-express-step-container', BASE_PATH + "paciente_p").then(function () {
            $("body").spin(false);
        });
    </script>
{/if}


{literal}
    <script>
        $(function () {

            //eliminamos la consulta en borrador y recargamos
            $("#consulta-express-step-container").on("click", "#btn-delete-consulta,#btn-cancelar-consulta", function () {

                jConfirm({
                    title: x_translate("Cancelar Consulta Express"),
                    text: x_translate('Está por cancelar la Consulta Express. ¿Desea continuar?'),
                    confirm: function () {
                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'delete_consultaexpress_borrador.do',
                                'idconsultaExpress=' + $("#idconsultaExpress").val(),
                                function (data) {
                                    $("body").spin(false);
                                    if (data.result) {
                                        window.location.href = BASE_PATH + "panel-paciente/consultaexpress/";
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

