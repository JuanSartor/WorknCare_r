{if $paciente}

{if $smarty.request.print==1}
{include file="perfil_salud/header_perfil_salud_imprimir.tpl"}
{else}
{include file="perfil_salud/menu_perfil_salud.tpl"}
 <section class="module-header container-fluid">
        <div class="row ">
            <div class="col-md-12">
                <div class="container">
                    <ol class="breadcrumb">
                        <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                        <li><a href="{$url}panel-medico/mis-pacientes/">{"Mis Pacientes"|x_translate}</a></li>
                        <li><a class="nombre_paciente" href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/">{$paciente.nombre} {$paciente.apellido}</a></li>
                        <li class="active">{"Consultas"|x_translate}</li>
                    </ol>
                </div>
            </div>
        </div>
    </section>
{/if}

<div id="consulta">

    <input type="hidden" id="idpaciente" value="{$paciente.idpaciente}"/>

   

    {*<section class="module-header nueva-consulta-header container-fluid">
        <div class="row">
            <figure class="circle-icon-images"></figure>
            <h1>{"Registro consultas médicas"|x_translate}</h1>
        </div>
    </section>	*}

    <section class="container-fluid">
        <div class="module-subheader nueva-consulta ">
            <div class="row">
                <div class="col-md-12">
                    <h2 class="dp-agenda"><img src="{$IMGS}icons/icon-reload.svg" alt=""> {"Nueva consulta"|x_translate}</h2>
                </div>
            </div>
        </div>
    </section>	

    <section class="container-fluid" id="nueva-consulta">
        <div class="row">
            <div class="col-sm-12 col-md-8 col-md-offset-1">	
                <form  id="consulta_form" action="{$url}save_consulta_form.do" method="post" onsubmit="return false;">	
                    <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}" />
                    <input type="hidden" name="idperfilSaludConsulta" id="idperfilSaludConsulta" value="{$record.idperfilSaludConsulta}" />

                    <div class="form-content" >
                        <div class="date-holder" id="div_date_picker">
                            <input type="text" id="fecha" name="fecha" placeholder='{"Fecha"|x_translate}' value="{$record.fecha|date_format:'%d/%m/%Y'}"/>
                            <img src="{$IMGS}icons/icon-calendar.svg" alt='{"Calendario"|x_translate}'/>
                        </div>	
                        <p>
                            <input type="text" name="evolucion_clinica" id="evolucion_clinica" value="{$record.evolucion_clinica}" placeholder='{"Evolucion clinica"|x_translate}'>
                        </p>
                        <p>
                            <textarea placeholder='{"Laboratorio / Otros Estudios"|x_translate}'  name="laboratorio" id="laboratorio" >{$record.laboratorio}</textarea>
                        </p>
                        <p>
                            <textarea placeholder='{"Anotaciones"|x_translate}' name="anotacion" id="anotacion" >{$record.anotacion}</textarea>
                        </p>

                        <div class="row">
                            <div class="col-sm-12 col-md-6 pull-left ">
                                <h5 class="icon-ojo">{"Campos visibles para el paciente"|x_translate}</h5>
                            </div>
                            <div class="col-sm-12 col-md-6">
                                <button class="btn btn-md btn-inverse pull-right">{"Código Internacional de Enfermedades CIE10"|x_translate}</button>
                            </div>
                        </div>
                        <p>
                            <input type="text" placeholder='{"Diagnostico"|x_translate}' name="diagnostico" id="diagnostico" value="{$record.diagnostico}" class="icon-ojo">
                        </p>
                        <p>
                            <textarea placeholder='{"Tratamiento"|x_translate}' name="tratamiento" id="tratamiento"  class="icon-ojo">{$record.tratamiento}</textarea>
                        </p>						

                        <button class="btn btn-md btn-inverse btn-save" onclick ="submitForm()" id="btnSaveConsulta">{"grabar datos"|x_translate}</button>
                    </div>					
                </form>
            </div>
            <div class="col-sm-12 col-md-2 col-md-offset-0">
                <a class="border-box dp-medicine" data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=perfil_salud&submodulo=prescripcion_form" data-target="#winModal" role="button">{"Agregar medicación"|x_translate}</a>
                {if $record.idperfilSaludConsulta}
                <a class="border-box fui-photo" data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=perfil_salud&submodulo=add_estudios&idpaciente={$paciente.idpaciente}&idperfilSaludConsulta={$record.idperfilSaludConsulta}" data-target="#winModal" role="button">{"Agregar archivo"|x_translate}</a>
                {else}
                <a class="modal-btn border-box fui-photo" data-toggle="modal" href="#" role="button">{"Agregar archivo"|x_translate}</a>
                {/if}
                <a href="#" class="modal-btn border-box dp-profile" data-target="anotaciones" role="button">{"Anotaciones"|x_translate}</a>
                <a href="#" class="border-box border-box-solid dp-print">{"Imprimir"|x_translate}</a>				
            </div>
        </div>
    </section>

    <!-- Modal Anotaciones -->
    <div class="modal fade  modal-type-1" id="anotaciones">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="modal-title">
                        <h5 class="dp-profile">{"Anotaciones"|x_translate}</h5>
                    </div>
                </div>
                <div class="modal-body">
                    <form action="{$url}save_consulta_form.do" method="post"  onsubmit="return false;" id="anotacion_form">
                        <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}" />
                        <input type="hidden" name="idperfilSaludConsulta" value="{$record.idperfilSaludConsulta}" />
                        <div class="form-content">
                            <p><textarea name="anotacion" id="anotacion_win" placeholder='{"Ingrese su anotación"|x_translate}'>{$record.anotacion}</textarea></p>
                        </div>
                        <div class="modal-btns">
                            <button data-dismiss="modal" id="btnCancelAnotacion">{"Cancelar"|x_translate}</button>
                            <button id="btnSaveAnotacion">{"Agregar"|x_translate}</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>	



    <section class="container-fluid estudio-imagenes-grid nueva-consulta-grid">
        <div id="div_archivos_consulta">
            {include file="perfil_salud/archivos_consulta.tpl"}
        </div>
        <div id="div_medicamentos_consulta">
            {include file="perfil_salud/list_medicamentos_consulta.tpl"}
        </div>
    </section>
</div>
{x_load_js}

{/if}