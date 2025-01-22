<?php

  $user_access = array(
      "medico" => array(
          "medico_privado" => array(
              "extranet_medico_home" => array(0),
              "medico_perfil" => array(0),
              "medico_perfil_consultorio" => array(0),
              "medico_perfil_consultorio_form" => array(0),
              "medico_perfil_horarios" => array(0),
              "medico_perfil_horarios_dia" => array(0),
              "medico_perfil_horarios_form" => array(0, 1),
              "medico_perfil_info_personal" => array(0),
              "medico_perfil_info_profesional" => array(0),
              "menu_interno_perfil" => array(0),
              "validar_celular_form" => array(0),
              "menu_privado" => array(0),
              "planes" => array(0),
              "shortcuts" => array(0),
              "soporte_tecnico" => array(0),
              "addIdioma" => array(1),
              "addObraSocial" => array(1),
              "eliminarIdioma" => array(1),
              "eliminarObraSocial" => array(1),
              "eliminar_horario" => array(1),
              "get_coordenadas_consultorios" => array(1),
              "guardarPreferencia" => array(1),
              "medico_info_personal" => array(1),
              "soporte_tecnico" => array(1),
              "registrar_aranceles" => array(1),
              "registrar_consultorio" => array(1),
              "uploader_img" => array(1,0),
              "agenda_medico_home" => array(0),
              "agenda_medico_diaria" => array(0),
              "agenda_medico_semanal" => array(0),
              "agenda_medico_mensual" => array(0),
              "mis_pacientes" => array(0),
              "turno_detalle" => array(0),
              "cambiar_turno" => array(1),
              "medico_perfil_info_comercial_form" => array(1,0),
              "turno_detalle_estado" => array(0),
              "delete_consultorio" => array(1),
              "mapa_consultorio" => array(0),
              "mi_cuenta" => array(0),
              "mi_cuenta_list_paciente" => array(0),
              "mis_pacientes_agregar_paciente" => array(0,1),
              "agregar_paciente_lista_pacientes" => array(1),
              "configuracion_horarios_consultorio" => array(0),
              "mis_pacientes_list_agregar_paciente" => array(0),
              "cron_generar_agenda" => array(1),
              "change_password" => array(1),
              "generate_codigo_celular" => array(1),
              "validate_codigo_celular" => array(1),
              "update_medico" => array(1),
              "solicitar_pago_form" => array(0, 1),
              "obra_social_autosuggest" => array(1),
              "eliminarEspecialidad" => array(1),
              "addEspecialidad" => array(1),
              "addSubEspecialidad" => array(1),
              "eliminarSubEspecialidad" => array(1)
          ),
          "login" => array(
              "logout" => array(1)
          )
      ),

      "public" => array(
          "paciente" => array(
              "footer" => array(0),
              "home_paciente" => array(0),
              "paciente_registracion" => array(0, 1),
              "paciente_registracion_ok" => array(0)
          ),
          "medico" => array(
              "footer" => array(0),
              "home_medico" => array(0),
              "medico_registracion" => array(0, 1),
              "medico_registracion_ok" => array(0)
          ),
          "home" => array(
              "footer" => array(0),
              "menu_noregister" => array(0),
              "iniciar_sesion_form" => array(0),
              "recuperar_contrasenia_form" => array(0),
              "captcha" => array(1),
              "lacalidad_auto" => array(1),
              "login_drop_down" => array(1),
              "localidad_autosuggest" => array(1),
              "reset_pass_drop_down" => array(1),
              "obrasocial_autosuggest" => array(1),
              "especialidad_autosuggest" => array(1)
          ),
          "statics" => array(
              "404" => array(0),
              "registracion" => array(0),
              "activacion" => array(0),
              "recuperacion_contrasenia" => array(0)
          ),
          "google_maps" => array(
              "map_busqueda" => array(0)
          ),
          "institucion" => array(
              "footer" => array(0),
              "menu_noregister" => array(0)
          ),
          "google"=> array(
              "get_coordenadas_map" => array(1)
          ),
          "login" => array(
              "activacion" => array(1),
              "recuperacion_contrasenia" => array(1)
          )
      )
  );
  