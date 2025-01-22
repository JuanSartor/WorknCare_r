{include file="turno/pasos_turno.tpl"}
<!--	@PASOS NAV-->

<!--	content-->
<section class="okm-container">
    <div class="okm-row">
        <div class="bst-p3-title">
            <h1>{"¡Su turno ha sido confirmado!"|x_translate}</h1>
        </div>
    </div>
    <div class="okm-row">

        <div class="bst-img-col">
            <img src="{$IMGS}bst-mobile.png" alt="DoctorPlus"/>
        </div>

        <div class="bst-data-col">
            <ul class="bst-p3-user-data">
                <li>
                    <div class="bst-p3-label">
                        <figure><i class="icon-doctorplus-usr-add"></i></figure>
                        <span>{"Profesional"|x_translate}</span>
                    </div>
                    <p>{$medico.titulo_profesional.titulo_profesional} {$medico.nombre} {$medico.apellido}</p>
                </li>
                {if $programa_categoria.programa_categoria!=""}
                    <li>
                        <div class="bst-p3-label">
                            <figure>
                                <img src="{$IMGS}pass_bienetre_icon.png" style="
                                     top: 10px;
                                     left: 16px;
                                     width: 36px;
                                     ">
                            </figure>
                            <span>{"Programas de salud"|x_translate}</span>
                        </div>
                        <p>
                            {if $programa_salud.programa_salud!=""}
                                {$programa_salud.programa_salud}
                            {/if}
                            {if $programa_categoria.programa_categoria!=""}
                                &nbsp;-&nbsp;{$programa_categoria.programa_categoria}
                            {/if}
                        </p>

                    </li>
                {/if}
                <li>
                    <div class="bst-p3-label">
                        <figure><i class="icon-doctorplus-calendar"></i></figure>
                        <span>{"Fecha"|x_translate}</span>
                    </div>
                    <p>{$turno.fechaTurno_format} - <strong>{$turno.horarioTurno_format} {"hs"|x_translate}</strong></p>
                </li>
                <li>
                    <div class="bst-p3-label">
                        <figure><i class="icon-doctorplus-map-plus-rounded"></i></figure>
                        <span>{"Lugar"|x_translate}</span>
                    </div>
                    <p>{$consultorio.direccion|upper} {$consultorio.numero}, {$consultorio.localidad_corta}</p>
                </li>
                <li>
                    <div class="bst-p3-label">
                        <figure><i class="icon-doctorplus-user"></i></figure>
                        <span>{"Paciente"|x_translate}</span>
                    </div>
                    <p>{$paciente.nombre} {$paciente.apellido}</p>
                </li>
            </ul>
            <div class="bst-center-actions">
                <a href="{$url}panel-paciente/#listado-turnos" class="btn btn-secondary">{"Volver"|x_translate}</a>
            </div>
            <div class="okm-row">
                <div class="bst-p2-txt-disclaimer">
                    <h3>{"Número de Turno:"|x_translate} {$turno.idturno}</h3>
                    <p>{"Por favor presente el número en la recepción al concurrir al turno"|x_translate}</p>
                </div>
            </div>
            <div class="clearfix">&nbsp;</div>
        </div>
    </div>
</section>
