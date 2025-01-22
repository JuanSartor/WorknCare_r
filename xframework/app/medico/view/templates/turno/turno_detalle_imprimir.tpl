
{if $detalle_turno.idturno!=""}

    <input type="hidden" id="fecha_turno" value="{$detalle_turno.fecha|date_format:'%m/%d/%Y'}"/>


    <div class="okm-row td-slide-holder">
        <div class="td-slide-box">

            <div class="td-slide-item">
                <h2 class="td-slide-title-consultorio">
                    {if $detalle_turno.is_virtual=="1"}
                        {"Consultorio Virtual"|x_translate}
                    {else}
                        {"Consultorio Físico"|x_translate}
                    {/if}
                    <span>/</span> {"Turno Nº"|x_translate}{$detalle_turno.nroturno}
                </h2>
                {if $detalle_turno.estado == 1}
                    <h3 class="td-slide-title confirmado">{"Turno confirmado"|x_translate} <i class="icon-doctorplus-check-thin"></i></h3>
                    {else if $detalle_turno.estado === "0"}
                    <h3 class="td-slide-title confirmacion">{"Turno pendiente de confirmación"|x_translate} <i class="icon-doctorplus-contrast-circle"></i></h3>
                    {else if $detalle_turno.estado == 2}
                    <h3 class="td-slide-title cancelado">{"Turno cancelado"|x_translate} <i class="icon-doctorplus-cruz"></i></h3>
                    {else if $detalle_turno.estado == 3}
                    <h3 class="td-slide-title declinado">{"Turno declinado"|x_translate} <i class="icon-doctorplus-minus"></i></h3>
                    {else if $detalle_turno.estado == 5}
                    <h3 class="td-slide-title ausente">{"Paciente ausente"|x_translate} <i class="icon-doctorplus-alert"></i></h3>
                    {/if}

                <div class="okm-row">

                    <div class="td-slide-paciente-row">
                        <figure>

                            {if $detalle_turno.paciente_imagen.list != ""}
                                <img src="{$detalle_turno.paciente_imagen.list}" alt="{$detalle_turno.nombre} {$detalle_turno.apellido}"/>
                            {else}
                                <img  src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$detalle_turno.nombre} {$detalle_turno.apellido}">
                            {/if}
                        </figure>

                        <h4>{$detalle_turno.nombre} {$detalle_turno.apellido}</h4>
                        <span class="td-slide-paciente-fn"><i class="icon-doctorplus-fem-symbol"></i> DN {$detalle_turno.fechaNacimiento|date_format:"%d/%m/%Y"}</span>

                    </div>

                    <div class="td-slide-turno-row">
                        <figure>
                            <i class="icon-doctorplus-calendar"></i>
                        </figure>
                        <span class="td-slide-turno-fecha">{$nombre_dia} {$detalle_turno.fecha|date_format:"%d"} {$nombre_mes}</span>
                        <span class="td-slide-turno-hora">{$detalle_turno.horarioInicio|date_format:"%H:%M"} hs</span>
                    </div>




                </div>

                <div class="okm-row td-turno-datos-paciente-box">
                    <a href="javascript:;" class="td-turno-datos-paciente-trg">
                        <h4><i class="icon-doctorplus-user"></i> {"Datos del paciente"|x_translate} <span class="arrow rotate"></span></h4>
                    </a>

                    <div class="td-turno-datos-paciente-collapse" style="display:block">
                        <div class="okm-row">
                            <div class="td-turno-datos-paciente-collapse-col-1">
                                <label><span class="td-label">{"Email"|x_translate}</span><span class="td-icon"><i class="icon-doctorplus-envelope"></i></span></label>
                                <p>
                                    {$detalle_turno.email}
                                </p>
                            </div>
                            <div class="td-turno-datos-paciente-collapse-col-2">
                                <label><span class="td-label">{"Celular"|x_translate}</span><span class="td-icon"><i class="icon-doctorplus-cel"></i></span></label>
                                <p>
                                    {if $detalle_turno.numeroCelular!=""}{$detalle_turno.caracteristicaCelular} {$detalle_turno.numeroCelular}{else} - {/if}
                                </p>
                            </div>
                        </div>



                    </div>

                    <div class="td-turno-datos-paciente">
                        <div class="okm-row">
                            <div class="td-turno-datos-paciente-motivo">
                                <label><strong>{"Motivo de la consulta:"|x_translate}</strong></label>
                                <p>
                            {if $detalle_turno.idservicio_medico=="3"}{$detalle_turno.motivoVisita}{else}{$detalle_turno.motivoVideoConsulta}{/if}
                        </p>
                    </div>
                </div>
                 {if $detalle_turno.mensaje_turno.mensaje!=""}
                <div class="okm-row">
                    <div class="td-turno-datos-paciente-comentarios">
                        <label><strong>{"Comentarios del paciente:"|x_translate}</strong></label>
                        <p>

                            {$detalle_turno.mensaje_turno.mensaje|escape}
                        </p>
                      
                    </div>
                {/if}
            </div>
        </div>

    </div>

</div>


</div>

</div>
{literal}
    <script>
        $(function () {

            window.print();
        });
    </script>
{/literal}

{else}
    <div class="okm-row td-slide-holder">
        <div class="clearofix"><p>&nbsp;</p></div>
        <div class="clearofix"><p>&nbsp;</p></div>

        <h4 align="center">{"No se pudo recuperar el Turno solicitado"|x_translate}</h3>

    </div>
    <div class="clearofix"><p>&nbsp;</p></div>
    <div class="clearofix"><p>&nbsp;</p></div>
{/if}