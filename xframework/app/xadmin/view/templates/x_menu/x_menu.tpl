<div class="xmnu-scroller">
    <ul class="gn-menu">
        {if $account.user.masteradmin==1 || in_array(1,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="1">
                <a href="javascript:;">{"Gestión Contable"|x_translate}</a>
                <ul class="gn-submenu">
                    <li>
                        <a href="javascript:;" onclick="x_goTo('contable', 'solicitud_pago_medico_list', '', 'Main', this);">{"Solicitudes de Pago"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('contable', 'comprobante_pago_cuenta_profesional_list', '', 'Main', this);">{"Suscripciones mensuales"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('contable', 'recaudaciones_list', '', 'Main', this);">{"Recaudaciones"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('contable', 'consultas_list', '', 'Main', this);">{"Listado de consultas"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('contable', 'reembolsos_list', '', 'Main', this);">{"Reembolsos"|x_translate}</a>
                    </li>
                </ul>
            </li>
        {/if}
        {if $account.user.masteradmin==1 || in_array(2,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="2">
                <a href="javascript:;">{"Gestión de Notificaciones"|x_translate}</a>
                <ul class="gn-submenu">
                    <li>
                        <a href="javascript:;" onclick="x_goTo('notificaciones', 'notificaciones_paciente_list', '', 'Main', this);">{"Notificaciones Paciente"|x_translate}</a>
                    </li>

                    <li>
                        <a href="javascript:;" onclick="x_goTo('notificaciones', 'notificaciones_medico_list', '', 'Main', this);">{"Notificaciones Médicos"|x_translate}</a>
                    </li>

                </ul>
            </li>
        {/if}
        {if $account.user.masteradmin==1 || in_array(3,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="3">
                <a href="javascript:;">{"Gestión de Prestadores"|x_translate}</a>
                <ul class="gn-submenu">
                    <li>
                        <a href="javascript:;" onclick="x_goTo('prestadores', 'prestadores_list', '', 'Main', this);">{"Administración de Prestadores"|x_translate}</a>
                    </li>

                </ul>
            </li>
        {/if}

        {if $account.user.masteradmin==1 || in_array(4,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="4">
                <a href="javascript:;">{"Información geográfica"|x_translate}</a>
                <ul class="gn-submenu">

                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_localizacion', 'pais_list', '', 'Main', this);">{"Paises"|x_translate}</a>
                    </li>


                </ul>
            </li>
        {/if}
        {if $account.user.masteradmin==1 || in_array(13,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="13">
                <a href="javascript:;">{"Logs de sistema"|x_translate}</a>
                <ul class="gn-submenu">
                    <li>
                        <a href="javascript:;" onclick="x_goTo('logs', 'log_sms_list', '', 'Main', this);">{"Logs de SMS"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('logs', 'log_mail_list', '', 'Main', this);">{"Logs de Mails"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('logs', 'log_track_list', '', 'Main', this);">{"Tracking de usuarios"|x_translate}</a>
                    </li>
                </ul>
            </li>
        {/if}
        {if $account.user.masteradmin==1 || in_array(13,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="13">
                <a href="javascript:;">{"Textos Auxiliares"|x_translate}</a>
                <ul class="gn-submenu">
                    <li>
                        <a href="javascript:;" onclick="x_goTo('texto_auxiliares', 'texto_auxiliares_list', '', 'Main', this);">{"Textos Auxiliares"|x_translate}</a>
                    </li>
                </ul>
            </li>
        {/if}

        {if $account.user.masteradmin==1 || in_array(5,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="5">
                <a href="javascript:;">{"Maestros Auxiliares"|x_translate}</a>
                <ul class="gn-submenu">
                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_alergias', 'alergia_list', '', 'Main', this);">{"Alergias - Sub tipo Alergias"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_banco', 'banco_list', '', 'Main', this);">{"Bancos"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('cirugia_ocular', 'cirugia_ocular_list', '', 'Main', this);">{"Cirugías Oculares"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_enfermedades', 'enfermedad_list', '', 'Main', this);">{"Enfermedad / Sub tipo Enfermedad"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_especialidades', 'maestros_especialidades_list', '', 'Main', this);">{"Especialidades"|x_translate}</a>
                    </li>

                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_genericos', 'laboratorio_list', '', 'Main', this);">{"Laboratorio"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_genericos', 'medicamento_list', '', 'Main', this);">{"Medicamentos"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_genericos', 'motivo_visita_list', '', 'Main', this);">{"Motivos de Visita Presencial"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_genericos', 'motivo_consultaexpress_list', '', 'Main', this);">{"Motivos de Consulta Express"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_genericos', 'motivo_videoconsulta_list', '', 'Main', this);">{"Motivos de Video Consulta"|x_translate}</a>
                    </li>

                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_genericos', 'motivo_rechazo_list', '', 'Main', this);">{"Motivos de Rechazo"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_os', 'maestros_os_list', '', 'Main', this);">{"Obras Sociales"|x_translate}</a>
                    </li>

                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_genericos', 'patologia_list', '', 'Main', this);">{"Patologías"|x_translate}</a>
                    </li>

                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_genericos', 'sector_list', '', 'Main', this);">{"Sectores"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_genericos', 'servicios_medicos_list', '', 'Main', this);">{"Servicios Médicos"|x_translate}</a>
                    </li>


                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_genericos', 'tipo_familiar_list', '', 'Main', this);">{"Tipo de familiares"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('maestros_genericos', 'banner_promocion_list', '', 'Main', this);">{"Banners de promoción"|x_translate}</a>
                    </li>



                </ul>
            </li>
        {/if}
        {if $account.user.masteradmin==1 || in_array(13,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="13">
                <a href="javascript:;">{"Reporte Prevencion"|x_translate}</a>
                <ul class="gn-submenu">
                    <li>
                        <a href="javascript:;" onclick="x_goTo('riesgo', 'modelos_riesgo_list', '', 'Main', this);">{"Modelos Riesgo"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('riesgo', 'familia_list', '', 'Main', this);">{"Familias de Riesgo"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('riesgo', 'item_list', '', 'Main', this);">{"Items de Riesgo"|x_translate}</a>
                    </li>
                </ul>
            </li>
        {/if}
        {if $account.user.masteradmin==1 || in_array(6,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="6">
                <a href="javascript:;">{"Médicos"|x_translate}</a>
                <ul class="gn-submenu">
                    <li>
                        <a href="javascript:;" onclick="x_goTo('medicos', 'medicos_generica_list', '', 'Main', this);">{"Administración de Médicos"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('medicos', 'preregistro_list', '', 'Main', this);">{"Preregistro de Médicos"|x_translate}</a>
                    </li>
                </ul>
            </li>
        {/if}
        {if $account.user.masteradmin==1 || in_array(7,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="7">
                <a href="javascript:;">{"Pacientes"|x_translate}</a>
                <ul class="gn-submenu">
                    <li>
                        <a href="javascript:;" onclick="x_goTo('pacientes', 'pacientes_generica_list', '', 'Main', this);">{"Administración de Pacientes"|x_translate}</a>
                    </li>

                </ul>
            </li>
        {/if}

        {if $account.user.masteradmin==1 || in_array(15,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="15">
                <a href="javascript:;">WorknCare</a>
                <ul class="gn-submenu">
                    <li>
                        <a href="javascript:;" onclick="x_goTo('usuarios_empresa', 'usuarios_list', '', 'Main', this);">{"Administración de Pases de Salud"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('embajador', 'embajador_list', '', 'Main', this);">{"Embajadores"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('programa_salud', 'cupon_list', '', 'Main', this);">{"Cupones de descuento"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('planes', 'planes_list', '', 'Main', this);">{"Planes"|x_translate}</a>
                    </li>
                </ul>
            </li>
        {/if}

        {if $account.user.masteradmin==1 || in_array(8,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="8">
                <a href="javascript:;">{"Preferencias de utilización"|x_translate}</a>
                <ul class="gn-submenu">

                    <li>
                        <a href="javascript:;" onclick="x_goTo('configuracion', 'parametros_configuracion_form', '', 'Main', this);">{"Preferencias de utilización"|x_translate}</a>
                    </li>


                </ul>
            </li>
        {/if}
        {if $account.user.masteradmin==1 || in_array(14,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="14">
                <a href="javascript:;">{"Programas de salud"|x_translate}</a>
                <ul class="gn-submenu">

                    <li>
                        <a href="javascript:;" onclick="x_goTo('programa_salud', 'programa_salud_list', '', 'Main', this);">{"Programas de salud"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('programa_salud', 'programa_salud_grupo_list', '', 'Main', this);">{"Grupos de programas"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('programa_salud_grupo_empresa', 'programa_salud_grupo_empresa_list', '', 'Main', this);">{"Grupos de programas empresa"|x_translate}</a>
                    </li>
                </ul>
            </li>
        {/if}
        {if $account.user.masteradmin==1 || in_array(14,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="14">
                <a href="javascript:;">{"Modelos"|x_translate}</a>
                <ul class="gn-submenu">

                    <li>
                        <a href="javascript:;" onclick="x_goTo('cuestionarios', 'cuestionario_list', '', 'Main', this);">{"Cuestionarios"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('cuestionarios', 'familia_cuestionario_grupo_list', '', 'Main', this);">{"Familia de cuestionarios"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('capsulas', 'capsula_list', '', 'Main', this);">{"Capsulas"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('capsulas', 'contenedor_capsula_grupo_list', '', 'Main', this);">{"Contenedor de capsulas"|x_translate}</a>
                    </li>
                    <li>
                        <a href="javascript:;" onclick="x_goTo('capsulas', 'familia_capsula_grupo_list', '', 'Main', this);">{"Familia de capsulas"|x_translate}</a>
                    </li>
                </ul>
            </li>
        {/if}
        {if $account.user.masteradmin==1 || in_array(9,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="9">
                <a href="javascript:;">{"Tarifas & reintegros"|x_translate}</a>
                <ul class="gn-submenu">
                    <li>
                        <a href="javascript:;" onclick="x_goTo('reintegro', 'grillas_list', '', 'Main', this);">{"Grillas de tarifas"|x_translate}</a>
                    </li>

                </ul>
            </li>
        {/if}

        {if $account.user.masteradmin==1 || in_array(10,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="10">
                <a href="javascript:;">{"Traducciones"|x_translate}</a>
                <ul class="gn-submenu">
                    <li>
                        <a href="javascript:;" onclick="x_goTo('traduccion', 'traduccion_list', '', 'Main', this);">{"Traducciones"|x_translate}</a>
                    </li>


                </ul>
            </li>
        {/if}
        {if $account.user.masteradmin==1 || in_array(11,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="11">
                <a href="javascript:;">{"Usuarios"|x_translate}</a>

                <ul class="gn-submenu">
                    <li>
                        <a href="javascript:;" onclick="x_goTo('usuarios', 'usuarios_list', '', 'Main', this);">{"Usuarios"|x_translate}</a>
                    </li>

                </ul>
            </li>
        {/if}


        {if $account.user.masteradmin==1 || in_array(12,$listado_usuario_acceso)}
            <li class="gn-open-all" data-id="12">
                <a href="javascript:;">{"Vacunas"|x_translate}</a>
                <ul class="gn-submenu">
                    <li>
                        <a href="javascript:;" onclick="x_goTo('vacunas', 'vacuna_list', '', 'Main', this);">{"Vacunas"|x_translate}</a>
                    </li>

                    <li>
                        <a href="javascript:;" onclick="x_goTo('vacunas', 'vacuna_edad_list', '', 'Main', this);">{"Vacunas por Edad / Grupo"|x_translate}</a>
                    </li>

                </ul>
            </li>
        {/if}





    </ul>
</div>

{literal}
    <script>
        $(document).ready(function () {

            $('ul.gn-menu li').removeClass('gn-open-all');

            $('#start').click(function () {
                $('#xmnu').toggleClass('cbp-spmenu-open');

                if ($('#xmnu').hasClass('cbp-spmenu-open')) {
                    $('#start').addClass("active");
                } else {
                    $('#start').removeClass("active");
                }
            });

            $('ul.gn-menu > li > a').on('click', function () {

                var parent = $(this).parent();

                if (parent.toggleClass('gn-open-all').hasClass('gn-open-all')) {
                    $(this).addClass("active");
                    $('ul.gn-menu > li > a').not($(this)).removeClass("active");
                } else {
                    $(this).removeClass("active");
                }
            });

            $('ul.gn-submenu > li > a').on('click', function () {
                $('#start').click();
                $('#start').removeClass("active");
            });

        });
    </script>
{/literal}