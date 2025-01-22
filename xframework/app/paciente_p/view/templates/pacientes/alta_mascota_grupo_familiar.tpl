<style>
    #Main {
        min-height: 100%;
        background: #f7f7f7;
    }
    .modal-body.cropper-body img {
        max-width: 100%;
    }
    .mapc-select{
        margin-top: 0px;
    }
    /*header titulo*/
    .top-verde-centrado {
        min-height: 60px;

    }
    .top-verde-centrado h1 {
        font-size: 18px;
        line-height: 60px;
    }

    .top-verde-centrado h1>i {
        font-size: 24px;
        margin-right: 12px;
        top: 2px;
    }
    /*archivos identificacion*/
    .cont-imagen{
        width:165px;
        height: 80px;
    }
    .cont-imagen.pdf{
        width:80px;
        height: 80px;
    }
    .upload-filename label{
        display:inline
    }
    .upload-filename .btn-delete-file {
        color: #f33243;
    }
</style>
<div class="top-verde-centrado">
    <h1><i class="fas fa-dog"></i> {"Crear nueva mascota"|x_translate}</h1>
</div>

<section class="pul-datos-paciente">
    <form id="frmRegistro" role="form" method="post" action="{$url}alta-miembro-grupo-familiar.do" onsubmit="return false;">
        <input type="hidden" name="animal" value="1"/>
        <div class="mapc-registro-box pul-nuevo-paciente-accordion">

            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="headingOne">
                        <h4 class="panel-title">
                            <a role="button" {*data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne"*}>
                                {"Datos de la mascota"|x_translate}
                            </a>
                        </h4>
                    </div>

                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                        <div class="panel-body">

                            <div class="okm-row">
                                <div class="pul-col-x2">
                                    <div class="mapc-input-line">
                                        <label class="mapc-label">{"Nombre del animal"|x_translate}</label>
                                        <input type="text" id="nombre_animal_input" name="nombre" maxlength="15"  data-title='{"Ingrese nombre del animal"|x_translate}' />
                                    </div>
                                </div>
                                <div class="pul-col-x2">
                                    <div class="mapc-input-line">
                                        <label class="mapc-label">{"Tipo de animal"|x_translate}</label>
                                        <input type="text" name="tipo_animal" id="tipo_animal_input" maxlength="20" data-title='{"Ingrese tipo de animal"|x_translate}' />
                                    </div>
                                </div>
                            </div>

                            <div class="okm-row">
                                <div class="pul-col-x2">
                                    <label class="mapc-label">{"Fecha de nacimiento"|x_translate}</label>
                                    <div class="mapc-input-line">
                                        <input type="text" id="fecha_nacimiento"  name="fechaNacimiento" placeholder='{"Fecha de nacimiento"|x_translate}'  data-title='{"Ingrese fecha de nacimiento"|x_translate}' data-date-format="DD/MM/YYYY" />
                                        <i class="icon-doctorplus-calendar"></i>
                                    </div>
                                </div>

                            </div>

                            <div class="okm-row">
                                <div class="mapc-registro-form-row center">
                                    <a href="javascript:;" id="btnCrearMascota" class="btn-alert">{"Crear mascota"|x_translate}</a>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>

        </div>


    </form>
</section>

{x_load_js}
