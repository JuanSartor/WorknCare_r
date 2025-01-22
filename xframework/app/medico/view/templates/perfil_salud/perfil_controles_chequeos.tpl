

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
                    <li class="active">{"Controles y chequeos"|x_translate}</li>
                </ol>
            </div>
        </div>
    </div>
</section>
{/if}

{if $listado|@count > 0}
<section class="module-header container">
    <figure class="dpp-chequeos"></figure>
    <h1>{"Controles y chequeos"|x_translate}</h1>
</section>
<!-- /main header -->


<section class="container">
    <div class="row">

        <div class="col-sm-12" >

            <table class="table-responsive historico-consultas-table notificaciones-table">
                <thead>
                    <tr>
                        <td class="col-1">{"Fecha"|x_translate}</td>
                        <td class="">{"Tipo"|x_translate}</td>
                        <td class="col-3">{"Descripción"|x_translate}</td>
                        <td class="col-4"></td>
                    </tr>
                </thead>
                <tbody>
                    
                    {foreach from=$listado item=registro}
                    <tr>
                        <td>{$registro.fechaNotificacion|date_format:"%d/%m/%Y"}</td>
                        <td>{$registro.tipoControlChequeo}</td>
                        <td>{$registro.titulo}</td>
                       
                        <td>
                            <a href="javascript:;" class="" data-status="{$registro.leido}" data-id="{$registro.idnotificacion}">
                                {if $registro.leido == 1}
                                <span class="dpp-flag deactivated"></span>
                                {else}
                                <span class="dpp-flag"></span>
                                {/if}
                            </a>
                        </td>
                    </tr>
                    
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
</section>
{else}
  <div class="cs-nc-section-holder">
        <section class="container cs-nc-p2">
                        <div class="sin-registros">
               <i class="dpp-chequeos"></i>
                <h6>{"¡La sección está vacía!"|x_translate}</h6>
                <p>{"El paciente no tiene registros de otros profesionales"|x_translate}.</p>
                </div>
        </section>
    </div>
{/if}
{/if}



{literal}
<script>
    $("ul.slider-menu li a").removeClass("active");
    $("ul.slider-menu li i.dpp-chequeos").parent().addClass("active");


   
</script>

{/literal}