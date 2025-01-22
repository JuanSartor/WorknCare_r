{include file="perfil_salud/profile_settings.tpl"} 

{include file="perfil_salud/menu_perfil_salud.tpl"}
{*<section class="module-header container-fluid">
<div class="row ">
<div class="col-md-12">
<div class="container">
<ol class="breadcrumb">
<li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
<li><a href="{$url}panel-paciente/perfil-salud/">{"Perfil de Salud"|x_translate}</a></li>
<li class="active">{"Registro consultas medicas"|x_translate}</li>
</ol>
</div>
</div>
</div>
</section>*}

<input type="hidden" id="idpaciente" value="{$paciente.idpaciente}" />

<div class="modal fade modal-type-1" id="ver-archivo" data-load="no">
    <div class="modal-dialog">
        <div class="modal-content"></div>
    </div>
</div>

<script>
    $(document).ready(function (e) {
        $('#ver-archivo').on('hidden.bs.modal', function () {
            $(this)
                    .removeData('bs.modal')
                    .find(".modal-content").html('');
        });

    });
</script> 

<section class="module-header nueva-consulta-header container-fluid ajustes-panel-paciente">
    <div class="row">
        <div class="col-md-12">
            <figure class="circle-icon-images"></figure>
            <h1>{"Registro consultas médicas"|x_translate}</h1>
        </div>	
    </div>
</section>	


<div id="div_historico_consultas">

</div>
<!-- /Registros de otros profesionales -->

{literal}
    <script>
        $(function () {
            $("ul.slider-menu li a").removeClass("active");
            $("ul.slider-menu li i.dpp-consulta").parent().addClass("active");
            x_loadModule('perfil_salud', 'registros_historico_consultas', 'do_reset=1&idpaciente=' + $("#idpaciente").val(), 'div_historico_consultas', BASE_PATH + "paciente_p");
            $("#div_historico_consultas").show();
        });
    </script>
{/literal}