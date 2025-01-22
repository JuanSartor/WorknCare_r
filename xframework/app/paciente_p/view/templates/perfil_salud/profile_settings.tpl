<style>
    @media (max-width: 650px){
        .section-header .user-select.pull-left {
            float: left !important;
        }
        .section-header .settings.pull-right{
            float: right !important;  
        }
    }
    .sin-registros{
        margin: 0px;
    }
    .color-perfil-salud{
        background-color: #ffffff !important;
    }
    .sacar-margen{
        margin-bottom: 0px !important;
    }
</style>
<nav class="section-header {if $paciente.edad < 18}pediatric{else}patient{/if} profile settings color-perfil-salud">
    <div class="container">
        <div class="okm-container container-header sacar-margen">
            <div class="container-a">
                <a href="javascript:;" onclick="window.history.back();" class="btn-volver-home-sante btn-volver-reembolso a-personalizado container-btn-a-volver container-btn-a-volver-top"><i class="fa fa-chevron-left" style="font-size:18px;" aria-hidden="true"></i>{"Volver"|x_translate}</a>
            </div>
            <h1 class="h1-personalizado">{"Perfil de Salud"|x_translate}</h1>
        </div>
        {if $paciente.animal!=1}
            <div class="settings pull-right alinear-confidencial">
                <ul>
                    {* <li><a data-toggle="modal" data-target="#configurar-tablero" href="{$url}paciente_p.php?fromajax=1&modulo=tablero&submodulo=tablero_configurar" role="button"><i class="dpp-grid"></i>{"Configurar Tablero"|x_translate}</a></li>*}

                    <li><a href="javascript:;" class="modal-btn" data-target="privacidad" role="button"><i class="dpp-lock btn-lock"></i>{"Privacidad"|x_translate}</a></li>
                </ul>
            </div>
        {/if}
    </div>
</nav>

<!-- Modal Privacidad -->
<div class="modal fade modal-type-2 modal-type-size-small" data-load="no" id="privacidad" >
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title"><h5>{"PRIVACIDAD DEL PERFIL DE SALUD"|x_translate}</h5></div>
                <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>
            </div>
            <form id="privacidad_form" action="{$url}save_privacidad.do" method="post"  onsubmit="return false;">
                <div class="form-content">
                    <h4>{"¿Quién puede ver el Perfil de Salud de"|x_translate} <br> <span>{$paciente.nombre} {$paciente.apellido}</span>?</h4>

                    <ul class="lista-checks">
                        <li><label for="priv-1" class="checkbox"><input type="radio" id="priv-1" value="0" {if $paciente.privacidad_perfil_salud === "0"} checked {/if} name="perfil-privado"> {"Nadie"|x_translate}</label></li>
                        <li><label for="priv-2" class="checkbox"><input type="radio" id="priv-2" value="1" {if $paciente.privacidad_perfil_salud === "1"} checked {/if} name="perfil-privado"> {"Profesionales Frecuentes y Favoritos"|x_translate}</label></li>
                        <li><label for="priv-3" class="checkbox"><input type="radio" id="priv-3" value="2" {if $paciente.privacidad_perfil_salud === "2"} checked {/if} name="perfil-privado"> {"Todos los profesionales de DoctorPlus"|x_translate}</label></li>
                    </ul>

                </div>
                <div class="modal-btns">
                    <button id="btnSavePrivacidad">{"guardar"|x_translate}</button>
                </div>
            </form>
        </div>
    </div>
</div>	
{literal}

    <script>
        x_runJS();

        $("#btnSavePrivacidad").click(function () {
            x_sendForm($('#privacidad_form'), true, function (data) {
                x_alert(data.msg);
                $("#privacidad").modal("hide");
            });
        });
    </script>

{/literal}
