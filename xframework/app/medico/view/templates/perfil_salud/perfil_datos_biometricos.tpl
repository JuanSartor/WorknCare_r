

{if $paciente}
{if $smarty.request.print==1}
{include file="perfil_salud/header_perfil_salud_imprimir.tpl"}
{else}
{include file="perfil_salud/menu_perfil_salud.tpl"}

<section class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <div class="container">
                <ol class="breadcrumb">
                    <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                    <li><a href="{$url}panel-medico/mis-pacientes/">{"Mis Pacientes"|x_translate}</a></li>
                    <li><a  class="nombre_paciente" href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/">{$paciente.nombre} {$paciente.apellido}</a></li>
                    <li class="active">{"Datos biométricos"|x_translate}</li>
                </ol>
            </div>
        </div>
    </div>
</section>
{/if}

<input type="hidden" id="print" value="{$smarty.request.print}"/>
<input type="hidden" id="paciente_idpaciente" value="{$paciente.idpaciente}" />
<input type="hidden" id="idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />

<section class="data-form health-profile">
    <div class="container">
        {*<h1 class="section-header text-center icon-svg circle bio">{"Datos Biométricos"|x_translate}</h1>*}
        <div class="patient-file cards">
            <div class="row">
                
                <!-- INICIO DIV de la masa corporal -->
                <div id="div_masa_corporal">

                </div>
                <!-- FIN DIV de la masa corporal -->

                <!-- INICIO DIV de la presión arterial -->
                <div id="div_presion_arterial">

                </div>
                <!-- FIN DIV de la presión arterial -->

                <!-- INICIO DIV de la colesterol -->
                <div id="div_colesterol">

                </div>
                <!-- FIN DIV de la colesterol -->

                <!-- INICIO DIV de la Glucemia -->
                <div id="div_glucemia">

                </div>
                <!-- FIN DIV de la Glucemia -->

                <!-- INICIO DIV de la Glucemia -->
                <div id="div_miscelaneas">

                </div>
                <!-- FIN DIV de la Glucemia -->

                
            </div>
        </div>
    </div>
</section>
{x_load_js}
{/if}