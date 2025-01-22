<style>
    .pul-configuracion-privacidad p {
        margin-bottom: 24px;
    }

    .pul-configuracion-privacidad label{
        text-align: left;
        margin: 0px 24px;
        display: inline-block;
    }
    @media (max-width: 600px){
        .pul-configuracion-privacidad h2 {
            margin-top: 0;
        }
        .pul-configuracion-privacidad p {
            margin-bottom: 14px;

        }
    }
</style>
<section class="container pul-configuracion-privacidad">

    {*
    <figure>
    <i class="icon-doctorplus-unlock"></i>
    </figure>
    *}
    <h2><strong>{"¿Quién puede ver el Perfil de Salud de"|x_translate}&nbsp;{$paciente.nombre} {$paciente.apellido}?</strong></h2>

    <p>{"Tu decides quién puede ver tu Perfil de salud y el de cada miembro de tu grupo familiar. Gracias a los ajustes en la Info de paciente gestionas a qué profesional/es habilitas a visualizarlo."|x_translate}</p>
    <form id="privacidad_form" action="{$url}save_privacidad.do" method="post"  onsubmit="return false;">
        <input type="hidden" name="idpaciente" value="{$paciente.idpaciente}"/>
        <div class="okm-row">
            <label for="priv-1" class="radio"><input type="radio" id="priv-1" value="0" {if $paciente.privacidad_perfil_salud === "0"} checked {/if} name="perfil-privado">{"Nadie"|x_translate}</label>
            <label for="priv-2" class="radio"><input type="radio" id="priv-2" value="1" {if $paciente.privacidad_perfil_salud === "1"} checked {/if} name="perfil-privado">{"Profesionales Frecuentes y Favoritos"|x_translate}</label>
            <label for="priv-3" class="radio"><input type="radio" id="priv-3" value="2" {if $paciente.privacidad_perfil_salud === "2"} checked {/if} name="perfil-privado">{"Todos los profesionales de DoctorPlus"|x_translate}</label>
        </div>
    </form>
    <div class="clearfix">&nbsp;</div>
    <div class="okm-row"> 
        <div class="mul-submit-box">
            <button id="btnSavePrivacidad" class="btn btn-default">{"guardar"|x_translate}</button>
        </div>
    </div>



</section>


{literal}
    <script>
        $(function () {
            $(':radio').radiocheck();

            $("#btnSavePrivacidad").click(function () {
                x_sendForm($('#privacidad_form'), true, function (data) {
                    x_alert(data.msg);
                });
            });
        });
    </script>
{/literal}