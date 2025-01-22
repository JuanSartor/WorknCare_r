<style>
    #section_btns{
        margin-bottom: 36px;
    }
</style>

<section class="container-fluid">
    <br>
    <div class="row ">
        <a onclick="window.history.back();" href="javascript:;" class="btn-volver-panel-paciente"><i class="fa fa-chevron-left" aria-hidden="true"></i>{"Volver"|x_translate}</a>
        <div class="col-md-12">
            <div class="container">
                <ol class="breadcrumb">
                    <li><a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/">{$paciente.nombre} {$paciente.apellido}</a></li>
                    <li class="active">{"Registro consultas médicas"|x_translate}</li>
                </ol>
            </div>
        </div>
    </div>
</section>

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

<div id="div_mis_registros_paciente">

</div>





{x_load_js}
