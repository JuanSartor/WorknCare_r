{include file="perfil_salud/profile_settings.tpl"}

{include file="perfil_salud/menu_perfil_salud.tpl"}

<section class="module-header container-fluid">
    <div class="row ">
        <div class="col-md-12">
            <div class="container">
                <ol class="breadcrumb">
                    <li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
                    <li class="active"><a href="#">{"Perfil de Salud"|x_translate}</a></li>
                </ol>
            </div>
        </div>
    </div>
</section>

<div class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body"></div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div>


<input type="hidden" id="idpaciente" value="{$paciente.idpaciente}" />
<section class="profile patient-overview">
    <div class="container">

        <div class="row" id="notificaciones">
            <div class="col-sm-12" >

                <div class="module-subheader">
                    <div class="row">
                        <h2 class="dp-flag">{"Notificaciones"|x_translate}</h2>
                    </div>
                </div>
                <table class="table-responsive historico-consultas-table notificaciones-table">
                    <thead>
                        <tr>
                            <td class="col-1">{"Fecha"|x_translate}</td>
                            <td class="">{"Tipo"|x_translate}</td>
                            <td class="col-3">{"Diagnóstico"|x_translate}</td>
                            <td class="col-4">{"Desactivar todas"|x_translate}</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>05/11/2014</td>
                            <td>{"Vacuna"|x_translate}</td>
                            <td>{"Refuerzo antitetánica"|x_translate}</td>
                            <td><span class="dp-flag"></span></td>
                        </tr>
                        <tr>
                            <td>05/11/2014</td>
                            <td>{"Vacuna"|x_translate}</td>
                            <td>{"Refuerzo antitetánica"|x_translate}</td>
                            <td><span class="dp-flag deactivated"></span></td>
                        </tr>
                        <tr>
                            <td>05/11/2014</td>
                            <td>{"Vacuna"|x_translate}</td>
                            <td>{"Refuerzo antitetánica"|x_translate}</td>
                            <td><span class="dp-flag"></span></td>
                        </tr>
                        <tr>
                            <td>05/11/2014</td>
                            <td>{"Vacuna"|x_translate}</td>
                            <td>{"Refuerzo antitetánica"|x_translate}</td>
                            <td><span class="dp-flag"></span></td>
                        </tr>																								
                    </tbody>
                </table>
            </div>
        </div>	
        <!-- /notificaciones -->
        <div id="div_cards_datos_biometricos">

        </div>
        {if $paciente.edad_anio > 15}
        {literal}
        <script>
            x_loadModule('tablero', "datos_biometricos_adultos", 'idpaciente=' + $("#idpaciente").val(), "div_cards_datos_biometricos", BASE_PATH + "paciente_p");
        </script>
        {/literal}
        {else}
        {literal}
        <script>
            x_loadModule('tablero', "datos_biometricos_pediatricos", 'idpaciente=' + $("#idpaciente").val(), "div_cards_datos_biometricos", BASE_PATH + "paciente_p");
        </script>
        {/literal}
        {/if}

        <!-- /colesterol top -->
        <div class="clearfix"></div>
        <hr>
    </div>
</section>


<div class="container">
    <div class="row">
        <div id="div_consultas_medicas">
            
        </div>
        {literal}
        <script>
            x_loadModule('tablero', "consultas_medicas", 'idpaciente=' + $("#idpaciente").val(), "div_consultas_medicas", BASE_PATH + "paciente_p");
        </script>
        {/literal}
        <!-- /consultas médicas -->

        <article class="col-md-4">
            <a data-toggle="modal" href="{$url}paciente_p.php?fromajax=1&modulo=tablero&submodulo=tablero_configurar" class="border-box dp-plus" data-target="#configurar-tablero"  style="padding:89px 10px;" role="button"><span>{"Sumar más atajos al tablero"|x_translate}</span></a>
        </article>

    </div>
</div>

<section class="data-form health-profile pediatrico-tablero">
    <div class="container">
        <div class="patient-file cards">
            <div class="row">

                {foreach from=$tablero_list item=tablero}

                {if $tablero.submodulo != "nan" }
                <div id="div_{$tablero.submodulo}">

                </div>
                <script>
                    x_loadModule('tablero', "{$tablero.submodulo}", 'idpaciente=' + $("#idpaciente").val(), "div_{$tablero.submodulo}", BASE_PATH + "paciente_p");
                </script>
                
                {/if}

                {/foreach}

            </div>
        </div>
    </div>
</section>

{literal}
<script type="text/javascript">
    $(document).ready(function() {


        $(':radio, :checkbox').radiocheck();
        $('.slider-for').slick({
            slidesToShow: 1,
            slidesToScroll: 1,
            arrows: false,
            dots: true,
            centerMode: false,
            fade: true
        });
        $('.switch-checkbox').bootstrapSwitch();
    });

</script>
{/literal}