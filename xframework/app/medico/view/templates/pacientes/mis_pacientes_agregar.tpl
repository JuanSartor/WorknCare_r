<section class="container agregar-paciente" id="agregar-paciente">
    <div class="row">
        <div class="col-md-10 col-md-offset-1">
            <div class="form-content form-content-variante">
                <h4 class="text-center dp-add-user">{"Agregar paciente"|x_translate}</h4>
                <p class="text-center">{"Contenido explicativo agregar paciente"|x_translate}</p>
                <br>

                <div id="div_invitaciones_pacientes" >
                    <script>
                        x_loadModule('pacientes', 'invitaciones_pacientes_list', '', 'div_invitaciones_pacientes');
                    </script>  
                </div>
                <div id="datos-nuevo-paciente" class="{*datos-nuevo-paciente*}">{**clase comentada para que se vea directamente el banner*}
                    <h4 class="dp-pacientes text-center">{"Datos del Paciente"|x_translate}</h4>
                    <div class="row">

                        <div class="col-md-6 col-md-offset-3">
                            <form  id="invitacion_form" action="{$url}invitar-paciente.do" method="post" onsubmit="return false;">	


                                <p class="input-aux-container">
                                    <input type="text" id="invitar_apellido" name="apellido" data-title='{"Ingrese apellido"|x_translate}' placeholder='{"Apellido"|x_translate}'><span class="input-required">*</span>
                                </p>

                                <p class="input-aux-container">
                                    <input type="text" id="invitar_email" name="email" data-title='{"Ingrese un email válido"|x_translate}' placeholder='{"Email"|x_translate}'>
                                </p>
                                <p>
                                    <input type="tel" id="invitar_celular" name="celular" data-title='{"Ingrese un número de celular válido"|x_translate}' placeholder='{"Celular"|x_translate}'>
                                </p>
                                {if $account.medico.tipo_especialidad=="1" && $account.medico.tipo_identificacion=="0"}
                                    <p class="text-center">
                                        <label class="checkbox medico-paciente-list-check">
                                            <input type="checkbox" value="1" id="medico_cabecera" name="medico_cabecera" >
                                            {"Soy el médico de cabecera"|x_translate}
                                        </label> 
                                    </p>
                                {/if}

                            </form>
                        </div>
                    </div>
                    <br>
                    <!--<a href="javascript:;" data-modal="yes" id="modal-400" class="btn-primary btn btn-submit role-button" role="button">Enviar invitación<i class="dpp-send"  ></i></a>-->


                    <a href="javascript:;" data-modal="yes" id="btnEnviarInvitacion" class="btn-primary btn btn-submit" role="button">{"Enviar invitación"|x_translate}<i class="dpp-send"  ></i></a>

                </div>

            </div>
        </div>
    </div>
</section>
<!-- /agregar pacientes -->		