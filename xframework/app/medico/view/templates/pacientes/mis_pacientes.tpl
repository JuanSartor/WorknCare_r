<style>
    .customer-box .data {
        cursor:default;
    }
    .customer-box .data p {
        font-size: 14px;
        margin-bottom:10px;
    }
    @media (max-width: 600px){
        .okm-user-options ul>li:not(:last-child) {
            width: 50%!important;
            padding-bottom: 0px!important;
            height: 70px;
            border: solid 1px #ccc;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .okm-user-options ul>li:last-child {
            min-height: auto;
        }
        .okm-user-options ul>li.full-width{
            width: 100%!important;
        }
    }
</style>
<link href="{$url}xframework/core/libs/libs_js/intl-tel-input/build/css/intlTelInput.css" rel="stylesheet" >
<!-- Modal enviar mensaje paciente-->
{include file="pacientes/enviar_mensaje_paciente.tpl"}

<!-- Modal Pacientes Relacionados -->
<div class="modal fade modal-type-2" data-load="no" id="pacientes-relacionados">
    <div class="modal-dialog">
        <div class="modal-content">

        </div>
    </div>
</div>	

<!-- Modal Profesionales frecuentes -->
<div class="modal fade modal-type-2" data-load="no" id="profesionales-frecuentes">
    <div class="modal-dialog">
        <div class="modal-content">

        </div>
    </div>
</div>	

<div class="modal fade modal-type-2" data-load="no" id="envio_profesionales">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="edit-data text-center enviar-invitacion">
                <p id="text_msg">{"Se le ha enviado una invitación a"|x_translate}</p>
                <p><i class="dp-email"></i>
                    <span id="span_send_email"></span>
                </p>
                <p style="display:none;">
                    <i class="dp-smartphone"></i> <span id="span_send_cel"></span>
                </p>
            </div>
            <a href="javascript:;" data-dismiss="modal" class="btn btn-inverse btn-block">{"cerrar"|x_translate}</a>
        </div>
    </div>
</div>	

<script>
    $(document).ready(function (e) {
        $('#pacientes-relacionados, #profesionales-frecuentes').on('hidden.bs.modal', function () {
            $(this)
                    .removeData('bs.modal')
                    .find(".modal-content").html('');
        });
    });
</script> 

<section class="filter-table-header patients">
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-3 col-sm-4 ">
                <h1 class="section-header">{"Pacientes"|x_translate}</h1>
            </div>
            <div class="col-md-5 col-sm-8 icon-btns">
                <a href="#" data-target="agregar-paciente" class="btn-slider dp-add-user">{"Agregar Paciente"|x_translate}</a>
                {if $account.medico.planProfesional==1}
                    <a href="#" data-target="lista-pacientes-sincargo" class="btn-slider dp-user-like">{"Pacientes sin cargo"|x_translate}</a>
                {else}
                    <a href="javascript:;"  class="btn-slider dp-user-like"  data-toggle="tooltip" title="Vous devez souscrire à l'abonnement pour pouvoir personnaliser l'utilisation de votre compte">{"Pacientes sin cargo"|x_translate}</a>
                {/if}
                <a href="#" data-target="lista-pacientes" class="btn-slider dp-user">{"Mis Pacientes"|x_translate}</a>
            </div>
            <div class="col-md-4 col-sm-12">
                <div class="search-combo">
                    <input type="text" class="form-control flat" id="buscar_paciente_input" placeholder='{"Buscar paciente por nombre o DNI"|x_translate}' />
                    <button id="btnSearchPaciente">f</button>
                </div>
            </div>
        </div>
    </div>
</section>


<div class="modal fade  modal-inside">
    <div class="modal-dialog">
        <div class="modal-content">
            <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>
            <div class="modal-body"></div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div>
<div id="div_listado_pacientes">

    <div id="div_container_informacion" class="relative">

        {include file="pacientes/mis_pacientes_agregar.tpl"}

        <!-- listado mis pacientes -->
        <section  id="lista-pacientes" class="container-wide lista-pacientes relative">

        </section>
        <!-- listado pacientes sin cargo -->
        <section id="lista-pacientes-sincargo" class="container-wide lista-pacientes">

        </section>

    </div>


    <div id="div_container_busqueda">
        <input type="hidden" id="cantidad_resultados_input" value="0"/> 
        <section class="container-wide lista-pacientes " id="lista-pacientes-busqueda"></section>
        <!-- /listado mis pacientes -->

        <!-- pacientes en DoctorPlus -->
        <section class="container-wide lista-pacientes-full lista-pacientes" id="lista-pacientes-full"></section>
        <!-- /pacientes en DoctorPlus-->
        <div class="sin-registros" id="div_sin_registros" style="display: none">
            <i class="dp-pacientes dp-icon"></i>
            <h6>{"¡La sección está vacía!"|x_translate}</h6>
            <p>{"Ud no tiene Pacientes para esa búsqueda."|x_translate}</p>
        </div>	
    </div>
</div>
<script src="{$url_js_libs}/intl-tel-input/build/js/intlTelInput.js"></script>
<script src="{$url_js_libs}/intl-tel-input/build/js/utils.js"></script>


{x_load_js}