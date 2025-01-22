{include file="perfil_salud/profile_settings.tpl"}

{include file="perfil_salud/menu_perfil_salud.tpl"}
{*<section class="module-header container-fluid">
<div class="row ">
<div class="col-md-12">
<div class="container">
<ol class="breadcrumb">
<li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
<li><a href="{$url}panel-paciente/perfil-salud/">{"Perfil de Salud"|x_translate}</a></li>
<li class="active">{"Datos biométricos"|x_translate}</li>
</ol>
</div>
</div>
</div>
</section>*}
<div class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body"></div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div>

<input type="hidden" id="paciente_idpaciente" value="{$paciente.idpaciente}" />
<input type="hidden" id="idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />

<section class="data-form health-profile ajustes-panel-paciente">
    <div class="container">
        <h1 class="section-header text-center icon-svg circle bio">{"Datos Biométricos"|x_translate}</h1>
        <div class="patient-file cards">
            <div class="row">

                <!-- INICIO DIV de la masa corporal -->
                <div id="div_masa_corporal">

                </div>
                <!-- FIN DIV de la masa corporal -->
                <!-- INICIO DIV de la Glucemia -->
                <div id="div_miscelaneas">

                </div>
                <!-- FIN DIV de la Glucemia -->

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




            </div>
        </div>
    </div>
</section>

{x_load_js}