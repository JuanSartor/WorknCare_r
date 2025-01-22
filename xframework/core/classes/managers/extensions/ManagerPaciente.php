<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los pacientes
 *
 */
class ManagerPaciente extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "paciente", "idpaciente");

        $this->flag = "active";
        $this->setImgContainer("pacientes");
        $this->addImgType("jpg");
        $this->setFilters("img_pdf");
        $this->addThumbConfig(50, 50, "_perfil");
        $this->addThumbConfig(150, 150, "_usuario");
        $this->addThumbConfig(110, 110, "_list");
    }

    public function process($request) {


        return parent::process($request);
    }

    /*
     *   @author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function update($request) {

        if (($request["nombre"] == "" || $request["apellido"] == "" || $request["numeroCelular"] == "" || $request["fechaNacimiento"] == "" || $request["pais_idpais"] == "" || ($request["pais_idpais_trabajo"] == "" && $request["trabaja_otro_pais"] == 1 ) ) && $request["fromadmin"] != "1") {
            $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
            return false;
        }

        $request["fechaNacimiento"] = $this->sqlDate($request["fechaNacimiento"]);

        if ((int) $request["usuarioweb_idusuarioweb"] > 0) {
            $calendar = new Calendar();
            $edad = $calendar->calculaEdad($request["fechaNacimiento"]);
            if ($edad < 18) {
                $this->setMsg(["msg" => "Error. El paciente titular debe ser mayor de edad", "result" => false]);
                return false;
            }
        }


        $paciente = $this->getPacienteTitular($request["idpaciente"]);
        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");
        $idusuarioweb = $managerUsuarioWeb->update($request, $paciente["usuarioweb_idusuarioweb"]);

        //Si hubo un problema al momento de crear un usuario
        if (!$idusuarioweb) {
            //Seteo el mensaje por el problema que ocurrió en el ManagerUsuarioWeb
            $this->setMsg($managerUsuarioWeb->getMsg());
            return false;
        }

        $request["usuarioweb_idusuarioweb"] = $idusuarioweb;
        //Si el número de celular es modificado, se setea celular válido como 0
        $request["numeroCelular"] = str_replace(" ", "", $request["numeroCelular"]);
        $request["numeroCelular"] = str_replace("-", "", $request["numeroCelular"]);
        $is_cambio_celular = 0;
        if (isset($request["numeroCelular"]) && $request["numeroCelular"] != "" && $paciente["numeroCelular"] != $request["numeroCelular"] && $request["fromadmin"] != "1") {
            $fields["celularValido"] = 0;
            $fields["codigoValidacionCelular"] = "";
            $fields["numeroCelular"] = $request["numeroCelular"];


            $sms = $this->sendSMSValidacion($request["idpaciente"]);
            if (!$sms) {
                $this->setMsg(["msg" => "Error. No se pudo enviar el código de validación", "result" => false]);
                return false;
                $this->db->FailTrans();
                $this->db->CompleteTrans();
            } else {
                $is_cambio_celular = 1;
            }
        }

        /**
         *  1-Francia
         *  2-Luxemburgo
         *  3-Bélgica
         *  4-Otro país
         * */
        $request["beneficios_reintegro"] = $request["beneficios_reintegro"] == "" ? 0 : 1;
        if ($request["beneficios_reintegro"] == 1) {

            switch ($request["pais_idpais"]) {
                case 1://Francia
                    if ($request["tarjeta_vitale"] == "") {
                        $this->setMsg(["msg" => "Error. Ingrese su número de tarjeta Vitale", "result" => false]);
                        return false;
                    }

                    if (!$this->validarTarjeta_Vitale($request["idpaciente"], $request["tarjeta_vitale"])) {
                        $this->setMsg(["msg" => "Error. Número de tarjeta Vitale no válido", "result" => false]);
                        return false;
                    }
                    if ($request["pais_idpais_trabajo"] == "") {
                        $this->setMsg(["msg" => "Error. Seleccione si trabaja en otro país", "result" => false]);
                        return false;
                    }

                    if ($request["pais_idpais_trabajo"] == 2 && $request["tarjeta_cns"] == "") {
                        $this->setMsg(["msg" => "Error. Ingrese su número de tarjeta CNS", "result" => false]);
                        return false;
                    }
                    if ($request["tarjeta_cns"] != "") {
                        if (!$this->validarTarjeta_CNS($request["idpaciente"], $request["tarjeta_cns"])) {
                            $this->setMsg(["msg" => "Error. Número de tarjeta CNS no válido", "result" => false]);
                            return false;
                        }
                    }
                    if ($request["beneficia_ald"] == "" || $request["beneficia_exempcion"] == "" || $request["medico_cabeza"] == "" || $request["posee_cobertura"] == "") {
                        $this->setMsg(["msg" => "Error. Verifique todos los campos obligatorios", "result" => false]);
                        return false;
                    } else {
                        $request["cobertura_facturacion_step"] = 4;
                    }


                    break;
                case 2:
                    //Luxemburgo
                    if ($request["tarjeta_cns"] == "") {
                        $this->setMsg(["msg" => "Error. Ingrese su número de tarjeta CNS", "result" => false]);
                        return false;
                    }
                    if ($request["pais_idpais_trabajo"] == "") {
                        $this->setMsg(["msg" => "Error. Seleccione si trabaja en otro país", "result" => false]);
                        return false;
                    }


                    if (!$this->validarTarjeta_CNS($request["idpaciente"], $request["tarjeta_cns"])) {
                        $this->setMsg(["msg" => "Error. Número de tarjeta CNS no válido", "result" => false]);
                        return false;
                    }



                    break;

                case 3://Begica
                    if ($request["tarjeta_eID"] == "") {
                        $this->setMsg(["msg" => "Error. Ingrese su número de tarjeta e-ID", "result" => false]);
                        return false;
                    }

                    if (!$this->validarTarjeta_eID($request["idpaciente"], $request["tarjeta_eID"])) {
                        $this->setMsg(["msg" => "Error. Número de tarjeta eID no válido", "result" => false]);
                        return false;
                    }
                    if ($request["pais_idpais_trabajo"] == "") {
                        $this->setMsg(["msg" => "Error. Seleccione si trabaja en otro país", "result" => false]);
                        return false;
                    }

                    if ($request["pais_idpais_trabajo"] == 2 && $request["tarjeta_cns"] == "") {
                        $this->setMsg(["msg" => "Error. Ingrese su número de tarjeta CNS", "result" => false]);
                        return false;
                    }





                    break;
                case 4://Otro pais
                    if ($request["tarjeta_pasaporte"] == "") {
                        $this->setMsg(["msg" => "Error. Ingrese su número de Pasaporte", "result" => false]);
                        return false;
                    }

                    if ($request["pais_idpais_trabajo"] == "") {
                        $this->setMsg(["msg" => "Error. Seleccione si trabaja en otro país", "result" => false]);
                        return false;
                    }

                    if ($request["pais_idpais_trabajo"] == 2 && $request["tarjeta_cns"] == "") {
                        $this->setMsg(["msg" => "Error. Ingrese su número de tarjeta CNS", "result" => false]);
                        return false;
                    }

                    break;
                default:
                    $this->setMsg(["msg" => "No se ha podido actualizar la informacion del paciente", "result" => false]);


                    return false;
            }
        }


        $id = parent::update($request, $request["idpaciente"]);

        $this->actualizarEdadPaciente($request["idpaciente"]);
        //obra social
        if ($request["posee_cobertura"] == 1) {
            if (isset($request["idobraSocial"]) && $request["idobraSocial"] != "") {
                //Creo la obra social asociada al paciente del grupo
                $managerObraSocialPaciente = $this->getManager("ManagerObraSocialPaciente");
                $update_obra_social = array(
                    "paciente_idpaciente" => $paciente["idpaciente"],
                    "obraSocial_idobraSocial" => $request["idobraSocial"],
                );

                $obra_social_paciente = $managerObraSocialPaciente->get($paciente["idpaciente"]);

                if ($obra_social_paciente) {
                    $idobraSocial = $managerObraSocialPaciente->update($update_obra_social, $obra_social_paciente["idobraSocialPaciente"]);
                } else {
                    $idobraSocial = $managerObraSocialPaciente->insert($update_obra_social);
                }
                if (!$idobraSocial) {
                    //Falla la transacción
                    $this->setMsg(["result" => false, "msg" => "Se produjo un error con los datos de la  cobertura médica. Verifique los datos cargados."]);
                    return false;
                }
            } else {

                $this->setMsg(["result" => false, "msg" => "Error. No ingresó los datos de la cobertura médica"]);
                return false;
            }
        } else {//Debo limpiar si tiene obra social
            $managerObraSocialPaciente = $this->getManager("ManagerObraSocialPaciente");
            $obra_social_paciente = $managerObraSocialPaciente->get($request["idpaciente"]);
            if ($obra_social_paciente) {
                $delete = $managerObraSocialPaciente->delete($obra_social_paciente["idobraSocialPaciente"]);
            }
        }
        //Afeccion
        if ($request["beneficia_ald"] == 1 && $request["pais_idpais"] == 1) {


            if (isset($request["afeccion_idafeccion"]) && $request["afeccion_idafeccion"] != "") {
                //Creo la obra social asociada al paciente del grupo
                $managerAfeccionPaciente = $this->getManager("ManagerAfeccionPaciente");
                $datos_afeccion = array(
                    "paciente_idpaciente" => $paciente["idpaciente"],
                    "afeccion_idafeccion" => $request["afeccion_idafeccion"]
                );

                $afeccion_paciente = $managerAfeccionPaciente->getByField("paciente_idpaciente", $paciente["idpaciente"]);

                if ($afeccion_paciente) {
                    $afeccion = $managerAfeccionPaciente->update($datos_afeccion, $afeccion_paciente["idafeccion_paciente"]);
                } else {
                    $afeccion = $managerAfeccionPaciente->insert($datos_afeccion);
                }
                if (!$afeccion) {
                    //Falla la transacción
                    $this->setMsg(["result" => false, "msg" => "Se produjo un error con los datos de la afección."]);
                    return false;
                }
            } else {
                $this->setMsg(["result" => false, "msg" => "Error. Seleccione la afección de largo plazo que posee"]);
                return false;
            }
        } else {//Debo limpiar si tiene obra social
            $managerAfeccionPaciente = $this->getManager("ManagerAfeccionPaciente");
            $afeccion_paciente = $managerAfeccionPaciente->getByField("paciente_idpaciente", $request["idpaciente"]);
            if ($afeccion_paciente) {
                $delete = $managerAfeccionPaciente->delete($afeccion_paciente["idafeccion_paciente"]);
            }
        }

        //verificamos que se haya cargado la imagen de identificacion
        //creamos el directorio si no existe
        if (!file_exists(path_entity_files($this->imgContainer . "/{$request["idpaciente"]}"))) {
            $dir = new Dir(path_entity_files($this->imgContainer . "/{$request["idpaciente"]}"));
            $dir->chmod(0777);
        }
        foreach ($request["hash"] as $hash) {
            $imagenes_tarjetas = $this->getImagenesIdentificacion($request["idpaciente"]);

            if ($_SESSION[$hash]["name"] == "pasaporte" && $_SESSION[$hash]["realName"] != "") {
                $pasaporte_ext = $_SESSION[$hash]["ext"];
                $pasaporte_path_temp = path_files("temp/" . $hash . "." . $pasaporte_ext);
                $pasaporte_path_file = path_entity_files("$this->imgContainer/{$request["idpaciente"]}/pasaporte.{$pasaporte_ext}");
                $pasaporte_exist = file_exists($pasaporte_path_temp);
                $pasaporte_is_file = is_file($pasaporte_path_temp);

                if ($pasaporte_exist && $pasaporte_is_file) {
                    //borramos el archivo anterior
                    unlink($imagenes_tarjetas["pasaporte"]["file"]);
                    //copiamos el archivo a su ubicacion final
                    copy($pasaporte_path_temp, $pasaporte_path_file);
                    //comprobamos que se hayan movido
                    if (!file_exists($pasaporte_path_file) || !is_file($pasaporte_path_file)) {
                        $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                        return false;
                    }
                }
            }

            if ($_SESSION[$hash]["name"] == "eID" && $_SESSION[$hash]["realName"] != "") {
                $eID_ext = $_SESSION[$hash]["ext"];
                $eID_path_temp = path_files("temp/" . $hash . "." . $eID_ext);
                $eID_path_file = path_entity_files("$this->imgContainer/{$request["idpaciente"]}/eID.{$eID_ext}");
                $eID_exist = file_exists($eID_path_temp);
                $eID_is_file = is_file($eID_path_temp);

                if ($eID_exist && $eID_is_file) {
                    //borramos el archivo anterior
                    unlink($imagenes_tarjetas["eID"]["file"]);
                    //copiamos el archivo a su ubicacion final
                    copy($eID_path_temp, $eID_path_file);
                    //comprobamos que se hayan movido
                    if (!file_exists($eID_path_file) || !is_file($eID_path_file)) {
                        $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                        return false;
                    }
                }
            }

            if ($_SESSION[$hash]["name"] == "cns" && $_SESSION[$hash]["realName"] != "") {
                $cns_ext = $_SESSION[$hash]["ext"];
                $cns_path_temp = path_files("temp/" . $hash . "." . $cns_ext);
                $cns_path_file = path_entity_files("$this->imgContainer/{$request["idpaciente"]}/cns.{$cns_ext}");
                $cns_exist = file_exists($cns_path_temp);
                $cns_is_file = is_file($cns_path_temp);

                if ($cns_exist && $cns_is_file) {
                    //borramos el archivo anterior
                    unlink($imagenes_tarjetas["cns"]["file"]);
                    //copiamos el archivo a su ubicacion final
                    copy($cns_path_temp, $cns_path_file);
                    //comprobamos que se hayan movido
                    if (!file_exists($cns_path_file) || !is_file($cns_path_file)) {
                        $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                        return false;
                    }
                }
            }
            if ($_SESSION[$hash]["name"] == "vitale" && $_SESSION[$hash]["realName"] != "") {
                $vitale_ext = $_SESSION[$hash]["ext"];
                $vitale_path_temp = path_files("temp/" . $hash . "." . $vitale_ext);
                $vitale_path_file = path_entity_files("$this->imgContainer/{$request["idpaciente"]}/vitale.{$vitale_ext}");
                $vitale_exist = file_exists($vitale_path_temp);
                $vitale_is_file = is_file($vitale_path_temp);

                if ($vitale_exist && $vitale_is_file) {
                    //borramos el archivo anterior
                    unlink($imagenes_tarjetas["vitale"]["file"]);
                    //copiamos el archivo a su ubicacion final
                    copy($vitale_path_temp, $vitale_path_file);
                    //comprobamos que se hayan movido
                    if (!file_exists($vitale_path_file) || !is_file($vitale_path_file)) {
                        $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                        return false;
                    }
                }
            }
        }

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {

            if ((int) $request["usuarioweb_idusuarioweb"] > 0) {
                $managerUsuarioWeb->actualiceSessionPaciente($request["usuarioweb_idusuarioweb"]);
            }

            // <-- LOG
            $log["data"] = "Social security or Passport number + picture, ALD category, CMU-C, Medecin traitant, Mutual company name)";
            $log["page"] = "Personal information";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "Update Personal information";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // 
            //verificamos si se completan los datos minimos obligatorios:
            $showModal = false;
            if ($paciente["pais_idpais"] == "" || $paciente["pais_idpais_trabajo"] == "") {
                $showModal = true;
            }

            $this->setMsg(["msg" => "Se modificaron los datos del paciente", "result" => true, "is_cambio_celular" => $is_cambio_celular, "showModal" => $showModal]);
        }
        //eliminamos los archivos temporales subidos
        foreach ($request["hash"] as $hash) {
            unlink(path_files("temp/" . $hash . "." . $_SESSION[$hash]["ext"]));
            unset($_SESSION[$hash]);
        }

        // <-- LOG
        $log["data"] = "Celular, surname, family name, birthday, gender, country of residence, country of work. User choice : health information accessibility for Professionals";
        $log["page"] = "Personal information";
        $log["action"] = "val"; //"val" "vis" "del"
        $log["purpose"] = "Update Personal information";

        // Fix para cuando se ve un miembro de grupo familiar. Ingreso con un ID pero estoy visualizando otro usuario
        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);
        // <--

        return $id;
    }

    /**
     * Método que realiza el update del perfil del paciente.. Contiene solamente los campos [celular, email]
     * @param type $request
     */
    public function updateFromPerfilPacienteCelEmail($request) {
        //Si el paciente posee el celular válido
        $paciente = $this->getPacienteTitular($request["idpaciente"]);
        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");
        $idusuarioweb = $managerUsuarioWeb->update($request, $paciente["usuarioweb_idusuarioweb"]);

        //Si hubo un problema al momento de crear un usuario
        if (!$idusuarioweb) {
            //Seteo el mensaje por el problema que ocurrió en el ManagerUsuarioWeb
            $this->setMsg($managerUsuarioWeb->getMsg());
            return false;
        }

        $is_cambio_celular = false;
        if ($paciente["numeroCelular"] != $request["numeroCelular"]) {
            $is_cambio_celular = true;
            $request["codigoValidacionCelular"] = "";
            $request["celularValido"] = 0;
        }

        $id = parent::update($request, $request["idpaciente"]);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {

            $this->setMsg(["msg" => "Se modificaron los datos del paciente", "result" => true, "is_cambio_celular" => $is_cambio_celular]);
        }
        return $id;
    }

    /**
     * OBtiene el paciente titular
     * @param type $idpaciente
     * @return string
     */
    public function getPacienteTitular($idpaciente) {
        //ME fijo si no es el paciente titular 

        $paciente_request = $this->get($idpaciente);



        $query = new AbstractSql();
        $query->setSelect("p.*, u.*,IF(pe.idpaciente_empresa IS NOT NULL,1,0) as is_paciente_empresa,pe.empresa_idempresa");

        if ($paciente_request["email"] == "") {
            $query->setFrom("paciente p
                            INNER JOIN pacientegrupofamiliar pgf ON (pgf.pacienteTitular = p.idpaciente)
                            INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb and u.registrado=1) 
                            LEFT JOIN paciente_empresa pe ON (pe.paciente_idpaciente = p.idpaciente)
                            ");
            $query->setWhere("pgf.pacienteGrupo = $idpaciente");
        } else {
            $query->setFrom("paciente p
                            INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb and u.registrado=1) 
                            LEFT JOIN paciente_empresa pe ON (pe.paciente_idpaciente = p.idpaciente)
                            ");
            $query->setWhere("p.idpaciente = $idpaciente");
        }

        $query->addAnd("p.active = 1");

        $paciente = $this
                ->db
                ->GetRow($query->getSql());


        $paciente["image"] = $this->getImagenPaciente($idpaciente);

        //verificamos que la suscripcion de la empresa este activa
        if ($paciente["is_paciente_empresa"] == "1") {
            $empresa = $this->getManager("ManagerEmpresa")->get($paciente["empresa_idempresa"]);
            //suscripcion cancelada
            if ($empresa["cancelar_suscripcion"] == "2") {
                //marcamos el paciete como regular, sin beneficio empresa
                $paciente["is_paciente_empresa"] = 0;
            }
        }

        return $paciente;
    }

    /**
     *
     *  Obtiene un paciente, con datos adicionales como por ejemplo los usuarios web
     *
     * */
    public function get($idpaciente, $active = 1) {

        $query = new AbstractSql();
        $query->setSelect("pacientes.*");
        $query->setFrom("(( SELECT u.nombre, u.apellido,p.fechaNacimiento,DATE_FORMAT(p.fechaNacimiento,'%d/%m/%Y') as fechaNacimiento_format, u.estado, u.active, p.numeroCelular, u.sexo, p.idpaciente, u.email,p.DNI,p.tarjeta_vitale,p.tarjeta_cns,p.tarjeta_eID,p.tarjeta_pasaporte,p.trabaja_otro_pais,p.pais_idpais,p.pais_idpais_trabajo,p.beneficios_reintegro, p.codigoValidacionCelular, p.celularValido,p.cambioEmail,p.codigoValidacionEmail, p.usuarioweb_idusuarioweb, p.edad, p.edad_anio, p.edad_mes, p.edad_dia, p.privacidad_perfil_salud, '' as relacionGrupo_idrelacionGrupo,osp.nroAfiliadoObraSocial,os.nombre as nombre_os,  u.tipoDNI_idtipoDNI, u.cantidad_intentos_fallidos,p.beneficia_ald,p.posee_cobertura,p.medico_cabeza,p.beneficia_exempcion,p.cobertura_facturacion_step,p.teaser_home_paciente, 1 as titular, IF(pe.idpaciente_empresa IS NOT NULL,1,0) as is_paciente_empresa,pe.empresa_idempresa,0 as animal, '' as tipo_animal
              FROM paciente p
				INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb and u.registrado=1)
                                LEFT JOIN obrasocialpaciente osp ON (p.idpaciente = osp.paciente_idpaciente)
                                LEFT JOIN obrasocial os ON (os.idobraSocial = osp.obraSocial_idobraSocial)
                                LEFT JOIN paciente_empresa pe ON (pe.paciente_idpaciente = p.idpaciente)
                                    
		) 
		UNION 
		( SELECT pf.nombre, pf.apellido, p.fechaNacimiento,DATE_FORMAT(p.fechaNacimiento,'%d/%m/%Y') as fechaNacimiento_format, 1 as estado, p.active,IFNULL(p.numeroCelular,p_tit.numeroCelular) as numeroCelular, pf.sexo, p.idpaciente, '' as email, pf.DNI,p_tit.tarjeta_vitale,IF (p_tit.pais_idpais=2 OR p_tit.pais_idpais_trabajo=2,p.tarjeta_cns,p_tit.tarjeta_cns) as tarjeta_cns,p_tit.tarjeta_eID,p_tit.tarjeta_pasaporte,p_tit.trabaja_otro_pais,p_tit.pais_idpais,p_tit.pais_idpais_trabajo,p_tit.beneficios_reintegro, p.codigoValidacionCelular, p.celularValido,'' as cambioEmail,'' as codigoValidacionEmail, '' as usuarioweb_idusuarioweb, p.edad, p.edad_anio, p.edad_mes, p.edad_dia, p.privacidad_perfil_salud, pf.relacionGrupo_idrelacionGrupo,osp.nroAfiliadoObraSocial,os.nombre as nombre_os,  pf.tipoDNI_idtipoDNI,0 as cantidad_intentos_fallidos,p.beneficia_ald,p.posee_cobertura,p.medico_cabeza,p.beneficia_exempcion,p.cobertura_facturacion_step,p.teaser_home_paciente,  0 as titular, IF(pe.idpaciente_empresa IS NOT NULL,1,0) as is_paciente_empresa,pe.empresa_idempresa,pf.animal,pf.tipo_animal
			FROM paciente p 
				INNER JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo) 
				INNER JOIN paciente p_tit ON (p_tit.idpaciente = pf.pacienteTitular) 
                                LEFT JOIN obrasocialpaciente osp ON (p.idpaciente = osp.paciente_idpaciente)
                                LEFT JOIN obrasocial os ON (os.idobraSocial = osp.obraSocial_idobraSocial)
                                LEFT JOIN paciente_empresa pe ON (pe.paciente_idpaciente = p_tit.idpaciente)
		)) as pacientes");
        $query->setWhere("pacientes.idpaciente = " . (int) $idpaciente);

        //filtramos el listado solo de activo o todos
        if ($active == 1) {
            $query->addAnd("pacientes.active = $active");
        }

        $execute = $this
                ->db
                ->Execute($query->getSql());
        $paciente = $execute->FetchRow();

        if ($paciente) {




            $name_image = "{$idpaciente}_perfil.jpg";

            $DestinationDirectory = path_entity_files("pacientes/$idpaciente/");
            if (is_file($DestinationDirectory . $name_image)) {
                $paciente["image"] = array(
                    "perfil" => URL_ROOT . "xframework/files/entities/pacientes/$idpaciente/{$idpaciente}_perfil.jpg",
                    "list" => URL_ROOT . "xframework/files/entities/pacientes/$idpaciente/{$idpaciente}_list.jpg",
                    "usuario" => URL_ROOT . "xframework/files/entities/pacientes/$idpaciente/{$idpaciente}_usuario.jpg",
                    "comun" => URL_ROOT . "xframework/files/entities/pacientes/$idpaciente/{$idpaciente}.jpg"
                );
            }

            //verificamos que la suscripcion de la empresa este activa
            if ($paciente["is_paciente_empresa"] == "1") {
                $empresa = $this->getManager("ManagerEmpresa")->get($paciente["empresa_idempresa"]);
                //suscripcion cancelada
                if ($empresa["cancelar_suscripcion"] == "2") {
                    //marcamos el paciete como regular, sin beneficio empresa
                    $paciente["is_paciente_empresa"] = 0;
                }
            }

            $paciente["nombre_corto"] = $this->get_nombre_corto($paciente);

            //Quitamos la verificacion de Perfil Salud obligatorio
            $is_permitido = 1;
            /**
              $Status = $this->getManager("ManagerPerfilSaludStatus")->getByField("paciente_idpaciente", $idpaciente);
              //verificamos si tiene permitido las CE y VC
              $is_permitido = 1;
              $obligatorios = ["datosbiometricos", "enfermedades", "patologias", "antecedentes_pediatricos", "antecedentes_familiares", "alergias_intolerancias", "ginecologico_embarazo", "ginecologico_controles", "ginecologico_antecedentes"];

              foreach ($obligatorios as $key) {

              //si es varon no aplica la evaluacion de perfil ginecologico
              if ($paciente["sexo"] == "1" && ($key == "ginecologico_antecedentes" || $key == "ginecologico_controles" || $key == "ginecologico_embarazo")) {

              } else {
              if ($Status[$key] == "0") {
              $is_permitido = 0;
              }
              }
              } */
            return $paciente;
        } else {

            return false;
        }
    }

    /**
     * Método que devuelve las iniciales del nombre del paciente
     * @param type $paciente
     * @return type
     */
    public function get_nombre_corto($paciente) {
        if ($paciente["animal"] == 1) {
            //Pongo las primeras letras del nombre
            $nombre_corto = "";
            if ($paciente["nombre"] != "") {
                $array_nombre = explode(" ", $paciente["nombre"]);
                if ($array_nombre[0] != "") {
                    $nombre_corto .= substr($array_nombre[0], 0, 2);
                }
            }
        } else {
            //Pongo las primeras letras del nombre
            $nombre_corto = "";
            if ($paciente["nombre"] != "") {
                $array_nombre = explode(" ", $paciente["nombre"]);
                if ($array_nombre[0] != "") {
                    $nombre_corto .= substr($array_nombre[0], 0, 1);
                }
            }

            if ($paciente["apellido"] != "") {
                $array_apellido = explode(" ", $paciente["apellido"]);
                if ($array_apellido[0] != "") {
                    $nombre_corto .= substr($array_apellido[0], 0, 1);
                }
                if ($array_nombre[1] != "") {
                    $nombre_corto .= substr($array_apellido[1], 0, 1);
                }
            }
        }


        return strtoupper($nombre_corto);
    }

    /**
     * MEtodo que devuelve las imagenes de identificacion del paciente
     * @param type $idpaciente
     */
    public function getImagenesIdentificacion($idpaciente) {
        $paciente = parent::get($idpaciente);


        if ($paciente["usuarioweb_idusuarioweb"] == "") {
            $paciente_titular = $this->getPacienteTitular($idpaciente);
        }

        $listado_imagenes = [];

        $id = $idpaciente;
        //para los pacientes miembros, usamos la identificacion de seguridad social del padre, expeto en LUX que el miembro tiene una propia
        if ($paciente_titular && $paciente_titular["pais_idpais"] != 2 && $paciente_titular["pais_idpais_trabajo"] != 2) {
            $id = $paciente_titular["idpaciente"];
        }
        $path_dir = path_entity_files("pacientes/$id/");

        if (file_exists($path_dir)) {
            $archivos = scandir($path_dir);

            foreach ($archivos as $i => $archivo) {
                $tarjeta = [];
                if ($archivo == "." || $archivo == "..") {
                    unset($archivos[$i]);
                    continue;
                }
                //verificamos el nombre original del archivo encontrado -  no thumb
                if (strrpos($archivo, "vitale.") !== false) {
                    $tarjeta["nombre"] = "vitale";
                } else if (strrpos($archivo, "eID.") !== false) {
                    $tarjeta["nombre"] = "eID";
                } else if (strrpos($archivo, "cns.") !== false) {
                    $tarjeta["nombre"] = "cns";
                } else if (strrpos($archivo, "pasaporte.") !== false) {
                    $tarjeta["nombre"] = "pasaporte";
                } else {
                    unset($archivos[$i]);
                    continue;
                }
                $tarjeta["path"] = URL_ROOT . "xframework/files/entities/pacientes/$id/{$archivo}?t=" . mktime();
                $tarjeta["file"] = path_entity_files("pacientes/$id/{$archivo}");
                //obtenemos formato
                $tarjeta["ext"] = str_replace($tarjeta["nombre"], "", $archivo);
                $listado_imagenes[$tarjeta["nombre"]] = $tarjeta;
            }
        }


        return $listado_imagenes;
    }

    /*     * Metodo que devuelve un registro de paciente instancindo al get de la superclase
     * 
     */

    public function get_basic($idpaciente) {
        return parent::get($idpaciente);
    }

    /**
     * Mpétodo que para guardar la imagen solamente
     * @param type $request
     * @return boolean
     */
    public function guardar_imagen($request) {
        if (isset($request["hash"]) && $request["hash"] != "") {
            $id = parent::update($request, $request[$this->id]);
            if (is_file(path_entity_files("pacientes/$id/$id.png"))) {
                $this->processImagePNG($id);
            }
            $msg = $this->getMsg();
            $msg["imgs"] = $this->getImagenPaciente($request["idpaciente"]);
            $this->setMsg($msg);
            $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["mi_logo"] = true;
            return $id;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo registrar la imagen."]);
            return false;
        }
    }

    /**
     *  Método que procesa las imagenes de perfil en formato PNG y las convierte a JPG 
     */
    public function processImagePNG($id) {
        //obtenemos todos los thumbs que se generaron
        $files[] = "{$id}";
        foreach ($this->thumbs_config as $thumb) {
            $files[] = "{$id}{$thumb["suffix"]}";
        }

        //converttimos todos los archivos y thumbs
        foreach ($files as $filename) {
            if (is_file(path_entity_files("pacientes/$id/$filename.png"))) {
                $filenamePNG = path_entity_files("pacientes/$id/$filename.png");
                $filenameJPG = path_entity_files("pacientes/$id/$filename.jpg");
                $image = imagecreatefrompng($filenamePNG);
                $bg = imagecreatetruecolor(imagesx($image), imagesy($image));
                imagefill($bg, 0, 0, imagecolorallocate($bg, 255, 255, 255));
                imagealphablending($bg, TRUE);
                imagecopy($bg, $image, 0, 0, 0, 0, imagesx($image), imagesy($image));
                imagedestroy($image);
                $quality = 70;
                imagejpeg($bg, $filenameJPG, $quality);

                //borramos el png original
                imagedestroy($bg);
                unlink($filenamePNG);
            }
        }
    }

    /**
     * Método que elimina los thumb si es que hay 
     */
    private function delete_thumb() {
        $DestinationDirectory = path_entity_files("medicos/" . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] . "/");
        if (count($this->thumbs_config) > 0) {
            foreach ($this->thumbs_config as $key => $config) {
                $file_name = $DestinationDirectory . $config["suffix"] . ".jpg";
                if (is_file($file_name)) {
                    unlink($file_name);
                }
            }
        }
    }

    /**
     * Le asigna la imagen a un listado de pacientes si es que la tienen
     * @param type $list_pacientes
     * @return arrayList()
     */
    public function getPathImagesList($list_pacientes, $nombre_id = "idpaciente") {

        foreach ($list_pacientes as $key => $paciente) {
            $idpaciente = $paciente[$nombre_id];
            $DestinationDirectory = path_entity_files("pacientes/$idpaciente/");
            $name_image = "{$idpaciente}_perfil.jpg";


            if (is_file($DestinationDirectory . $name_image)) {
                $list_pacientes[$key]["image"] = array(
                    "perfil" => URL_ROOT . "xframework/files/entities/pacientes/$idpaciente/{$idpaciente}_perfil.jpg?t=" . mktime(),
                    "list" => URL_ROOT . "xframework/files/entities/pacientes/$idpaciente/{$idpaciente}_list.jpg?t=" . mktime(),
                    "usuario" => URL_ROOT . "xframework/files/entities/pacientes/$idpaciente/{$idpaciente}_usuario.jpg?t=" . mktime(),
                    "comun" => URL_ROOT . "xframework/files/entities/pacientes/$idpaciente/{$idpaciente}.jpg?t=" . mktime()
                );
            }
        }
        return $list_pacientes;
    }

    /**
     * Retorna true si tiene permitido ejecutar una consulta express
     * @param type $idpaciente
     * @return boolean
     */
    public function isPermitidoConsultaExpress($idpaciente) {
        //$quitamos la restriccion de Perfil Salud obligatorio
        $Status = $this->getManager("ManagerPerfilSaludStatus")->getByField("paciente_idpaciente", $idpaciente);
        if (!$Status) {
            $this->getManager("ManagerPerfilSaludStatus")->insert(["paciente_idpaciente" => $idpaciente]);
        }

        /*
          $Status = $this->getManager("ManagerPerfilSaludStatus")->getByField("paciente_idpaciente", $idpaciente);
          $paciente = $this->get($idpaciente);
          $obligatorios = ["datosbiometricos", "enfermedades", "patologias", "antecedentes_pediatricos", "antecedentes_familiares", "alergias_intolerancias", "ginecologico_embarazo", "ginecologico_controles", "ginecologico_antecedentes"];

          foreach ($obligatorios as $key) {

          //si es varon no aplica la evaluacion de perfil ginecologico
          if ($paciente["sexo"] == "1" && ($key == "ginecologico_antecedentes" || $key == "ginecologico_controles" || $key == "ginecologico_embarazo")) {

          } else {
          if ($Status[$key] == "0") {
          return 0;
          }
          }
          } */
        return 1;

        /*
          $ManagerPerfilSaludBiometrico = $this->getManager("ManagerPerfilSaludBiometrico");
          $perfil_salud_biometrico = $ManagerPerfilSaludBiometrico->getByField("paciente_idpaciente", $idpaciente);
          if (!$perfil_salud_biometrico) {
          return false;
          }

          $ManagerMasaCorporal = $this->getManager("ManagerMasaCorporal");
          $last_information = $ManagerMasaCorporal->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
          if (!$last_information || $last_information["altura"] == "" || $last_information["peso"] == "") {
          return false;
          }

          $ManagerAntecedentesPersonales = $this->getManager("ManagerAntecedentesPersonales");
          $antecendente = $ManagerAntecedentesPersonales->getByField("paciente_idpaciente", $idpaciente);
          if (!$antecendente) {
          return false;
          }

          $ManagerEnfermedadesActuales = $this->getManager("ManagerEnfermedadesActuales");
          $enfermedades_actuales = $ManagerEnfermedadesActuales->getByField("paciente_idpaciente", $idpaciente);
          if (!$enfermedades_actuales) {
          return false;
          }

          $ManagerPatologiasActuales = $this->getManager("ManagerPatologiasActuales");
          $patologia = $ManagerPatologiasActuales->getByField("paciente_idpaciente", $idpaciente);
          if (!$patologia) {
          return false;
          }
          return true; */
    }

    /**
     * Retorna true si tiene permitido ejecutar una video consulta
     * @param type $idpaciente
     * @return boolean
     */
    public function isPermitidoVideoConsulta($idpaciente) {
        //$quitamos la restriccion de Perfil Salud obligatorio
        /*
          $Status = $this->getManager("ManagerPerfilSaludStatus")->getByField("paciente_idpaciente", $idpaciente);
          $paciente = $this->get($idpaciente);

          $obligatorios = ["datosbiometricos", "enfermedades", "patologias", "antecedentes_pediatricos", "antecedentes_familiares", "alergias_intolerancias", "ginecologico_embarazo", "ginecologico_controles", "ginecologico_antecedentes"];
          foreach ($obligatorios as $key) {

          //si es varon no aplica la evaluacion de perfil ginecologico
          if ($paciente["sexo"] == "1" && ($key == "ginecologico_antecedentes" || $key == "ginecologico_controles" || $key == "ginecologico_embarazo")) {

          } else {
          if ($Status[$key] == "0") {
          return 0;
          }
          }
          } */

        return 1;
    }

    /**
     * Retorno El médico desde el id del usuario web
     * @param type $idusuarioweb
     * @return type
     */
    public function getFromUsuarioWeb($idusuarioweb) {
        return $this->getByField("usuarioweb_idusuarioweb", $idusuarioweb);
    }

    /**
     * Método que retorna la imagen del paciente
     * @param type $idpaciente
     * @return boolean
     */
    public function getImagenPaciente($idpaciente = null) {
        if (is_null($idpaciente)) {
            $idpaciente = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];
        }


        if (strpos(URL_ROOT, "extranet") != "") {

            $URL_ROOT = str_replace("extranet/", "", URL_ROOT);
            $path_file = path_entity_files_main("pacientes/$idpaciente/$idpaciente.jpg");
        } else {

            $path_file = path_entity_files("pacientes/$idpaciente/$idpaciente.jpg");
            $URL_ROOT = URL_ROOT;
        }

        if (is_file($path_file)) {

            $paciente = array(
                "original" => $URL_ROOT . "xframework/files/entities/pacientes/$idpaciente/{$idpaciente}.jpg?" . mktime(),
                "perfil" => $URL_ROOT . "xframework/files/entities/pacientes/$idpaciente/{$idpaciente}_perfil.jpg?" . mktime(),
                "list" => $URL_ROOT . "xframework/files/entities/pacientes/$idpaciente/{$idpaciente}_list.jpg?" . mktime(),
                "usuario" => $URL_ROOT . "xframework/files/entities/pacientes/$idpaciente/{$idpaciente}_usuario.jpg?" . mktime(),
            );

            /*
             * Por si edita a un paciente que es miembro, no tiene que actualizar lafoto del perfil
             */
            if ((int) $idpaciente == (int) $_SESSION[$URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]) {
                $paciente["change"] = true;
            }
            return $paciente;
        } else {

            return false;
        }
    }

    /*
     * Realización de la registración web del beneficiario particular
     * @param type $request
     * @return boolean
     */

    public function registracionBeneficiarioParticular($request) {

        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");

        if ($request["email"] == "" || $request["password"] == "" || $request["numeroCelular"] == "") {
            $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
            return false;
        }

        //valido  Email registro pendiente
        $usuarioWeb = $managerUsuarioWeb->getByFieldArray(["email", "registrado"], [$request["email"], 1]);

        if ($usuarioWeb) {
            $managerUsuarioWeb->delete($usuarioWeb["idusuarioweb"], true);
        }

        //Apertura Transaccion
        $this->db->StartTrans();

        //Registración de usuario 

        $request["tipousuario"] = "paciente";

        $request["numeroCelular"] = str_replace(' ', '', $request["numeroCelular"]);

        $request["registrado"] = 1;
        $idusuarioweb = $managerUsuarioWeb->registracion_web($request);

        //Si hubo un problema al momento de crear un usuario
        if (!$idusuarioweb) {
            //Seteo el mensaje por el problema que ocurrió en el ManagerUsuarioWeb
            $this->db->FailTrans();
            $this->setMsg($managerUsuarioWeb->getMsg());

            $this->db->CompleteTrans();
            return false;
        }

        $request["usuarioweb_idusuarioweb"] = $idusuarioweb;

        $calendar = new Calendar();
        $edad = $calendar->calculaEdad($request["fechaNacimiento"]);
        if ($edad < 18) {
            $this->setMsg(["msg" => "Para crear una cuenta en DoctorPlus el paciente titular debe ser mayor de edad.", "result" => false]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }
        $request["fechaNacimiento"] = $this->sqlDate($request["fechaNacimiento"]);

        $idpaciente = parent::insert($request);
        if (!$idpaciente) {

            $this->setMsg(["msg" => "No se ha podido dar de alta el paciente", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }




        //creamos la relacion del paciente con la empresa contratante
        $record_empresa["paciente_idpaciente"] = $idpaciente;
        $record_empresa["empresa_idempresa"] = $request["empresa_idempresa"];
        $record_empresa["plan_idplan"] = $request["plan_idplan"];
        $record_empresa["estado"] = 1;
        $record_empresa["facturar"] = 1;
        $record_empresa["fecha_activacion"] = date("Y-m-d");
        $idpaciente_empresa = $this->getManager("ManagerPacienteEmpresa")->insert($record_empresa);
        if (!$idpaciente_empresa) {

            $this->setMsg(["msg" => "No se ha podido dar de alta el paciente", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        $rdo_msg = $this->sendSMSValidacion($idpaciente);
        if (!$rdo_msg) {

            $this->setMsg(["msg" => "No se ha podido enviar el código de verifiación a su celular", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }



        $this->setMsg(["msg" => "Ha sido dado de alta en el sistema", "result" => true, "idpaciente" => $idpaciente]);
        $this->db->CompleteTrans();
        return $idpaciente;
    }

    /*
     * Realización de la registración web del paciente. Carga los pasos desagregados
     * @param type $request
     * @return boolean
     */

    public function registracion_beneficiario($request) {
        if ($request["step"] == "") {
            $this->setMsg(["msg" => "Error.", "result" => false]);

            return false;
        }
        switch ($request["step"]) {
            case 1:
                return $this->registracion_beneficiario_step1($request);
            case 2:
                return $this->checkValidacionCelular($request);
            case 3:
                return $this->registracion_beneficiario_step3($request);
            default:
                $this->setMsg(["msg" => "Error.", "result" => false]);

                return false;
        }
    }

    /**
     * Realización de la registración web del paciente.
     * @param type $request
     * @return boolean
     */
    public function registracion_beneficiario_step1($request) {

        if ($request["banderaBeneficiarioExistente"] != '1') {

            $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");

            if ($request["email"] == "" || $request["password"] == "" || $request["numeroCelular"] == "" || $request["codigo_pass"] == "") {
                $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
                return false;
            }
            if ($request["terminos_condiciones"] == "") {

                $this->setMsg(["msg" => "Debe aceptar los Términos y condiciones de uso del sistema.", "result" => false]);
                return false;
            }

            $captcha = $managerUsuarioWeb->validateGReCaptcha($request);

            if (!$captcha && $_SERVER["HTTP_HOST"] != "localhost") {
                $this->setMsg(["msg" => "Error, verificación captcha incorrecta", "result" => false]);
                return false;
            }

            $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->getByUserHash($request["pass_esante"]);
            if (!$plan_contratado) {
                $this->setMsg(["msg" => "No se ha podido dar de alta el paciente", "result" => false]);
            }


            if ($plan_contratado["codigo_pass"] != $request["codigo_pass"]) {
                $this->setMsg(["msg" => "El codigo del Pase de Salud ingresado no es correcto", "result" => false]);
                return false;
            }

            $calendar = new Calendar();
            $fecha_adhesion_antes = $calendar->isMayor(date("Y-m-d"), $plan_contratado["fecha_adhesion"]);
            if ($fecha_adhesion_antes == -1) {
                $this->setMsg(["msg" => "La fecha de registro de los beneficiarios del Pase de Salud de su empresa o establecimiento es a partir del [[{$plan_contratado["fecha_adhesion_format"]}]]", "result" => false]);
                return false;
            }

            //valido  Email registro pendiente
            $usuarioWeb = $managerUsuarioWeb->getByFieldArray(["email", "registrado"], [$request["email"], 0]);

            if ($usuarioWeb) {
                $managerUsuarioWeb->delete($usuarioWeb["idusuarioweb"], true);
            }

            //Apertura Transaccion
            $this->db->StartTrans();

            //Registración de usuario 

            $request["tipousuario"] = "paciente";

            $request["numeroCelular"] = str_replace(' ', '', $request["numeroCelular"]);


            $idusuarioweb = $managerUsuarioWeb->registracion_web($request);

            //Si hubo un problema al momento de crear un usuario
            if (!$idusuarioweb) {
                //Seteo el mensaje por el problema que ocurrió en el ManagerUsuarioWeb
                $this->db->FailTrans();
                $this->setMsg($managerUsuarioWeb->getMsg());

                $this->db->CompleteTrans();
                return false;
            }

            $request["usuarioweb_idusuarioweb"] = $idusuarioweb;

            //Valido que no haya otro paciente con un email.

            $idpaciente = parent::insert($request);
            if (!$idpaciente) {

                $this->setMsg(["msg" => "No se ha podido dar de alta el paciente", "result" => false]);

                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        } else {
            // este else es porque necesito datos para completar el proceso
            $usWeb = $this->getManager("ManagerUsuarioWeb")->getByField("email", $request["email"]);
            $paciente = $this->getByField("usuarioweb_idusuarioweb", $usWeb["idusuarioweb"]);
            $idpaciente = $paciente["idpaciente"];

            $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->getByUserHash($request["pass_esante"]);
        }

        $empresa = $this->getManager("ManagerEmpresa")->getByField("hash", $request["pass_esante"]);
//verificamos si la suscripcion está cancelada, no se pueden cambiar
        if ($empresa["cancelar_suscripcion"] == 2) {
            $this->setMsg(["msg" => "Error. Su suscripción ha sido cancelada", "result" => false]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        //verirficamos que no se registren con el mail empresa
        $es_email_empresa = strrpos($request["email"], $empresa["dominio_email"]);

        if ($es_email_empresa !== false) {
            $this->setMsg(["msg" => "Error. Utilice su correo electrónico personal. No debe utilizar el correo electrónico de su empresa", "result" => false]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        //verififcamos que la empresa tenga saldo maximo disponible para agregar otro beneficiario, (si lo establecio)
        if ($empresa["presupuesto_maximo"] != "") {

            $info_beneficiarios = $this->getManager("ManagerPacienteEmpresa")->getInfoBeneficiariosInscriptos($empresa["idempresa"]);
            $plan = $this->getManager("ManagerProgramaSaludPlan")->get($empresa["plan_idplan"]);

            if ((int) $empresa["presupuesto_maximo"] > 0) {
                //sumamos un beneficiacios y vemos excede el presupuesto mensual
                $info_beneficiarios["consumo_beneficiarios"] = ($info_beneficiarios["beneficiarios_verificados"] + 1) * $plan["precio"];
                $info_beneficiarios["credito_disponible"] = $empresa["presupuesto_maximo"] - $info_beneficiarios["consumo_beneficiarios"];

                if ((int) $info_beneficiarios["credito_disponible"] < 0) {
                    $this->setMsg(["msg" => "Se ha excedido el máximo de beneficiarios admitidos por su empresa. Hemos notificado esta situación a su empresa para que usted pueda registrarse.", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    //enviamos mail a la empresa
                    $this->getManager("ManagerEmpresa")->enviar_mail_maximo_beneficiarios($empresa["idempresa"]);

                    return false;
                }
            }
        }

        //creamos la relacion del paciente con la empresa contratante
        $record_empresa["paciente_idpaciente"] = $idpaciente;
        $record_empresa["empresa_idempresa"] = $empresa["idempresa"];
        $record_empresa["plan_idplan"] = $plan_contratado["idprograma_salud_plan"];
        $idpaciente_empresa = $this->getManager("ManagerPacienteEmpresa")->insert($record_empresa);
        if (!$idpaciente_empresa) {

            $this->setMsg(["msg" => "No se ha podido dar de alta el paciente", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        $rdo_msg = $this->sendSMSValidacion($idpaciente);
        if (!$rdo_msg) {

            $this->setMsg(["msg" => "No se ha podido enviar el código de verifiación a su celular", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }



        $this->setMsg(["msg" => "Ha sido dado de alta en el sistema", "result" => true, "idpaciente" => $idpaciente]);
        $this->db->CompleteTrans();
        return true;
    }

    /**
      /**
     * Realización de la registración del los datos del paciente.
     * @param type $request
     * @return boolean
     */
    public function registracion_beneficiario_step3($request) {

        if ($request["banderaBeneficiarioExistente"] != '1') {
            if ($request["nombre"] == "" || $request["apellido"] == "" || $request["fechaNacimiento"] == "") {
                $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
                return false;
            }

            $request["nombre"] = ucwords(strtolower($request["nombre"]));
            $request["apellido"] = ucwords(strtolower($request["apellido"]));

            //Apertura Transaccion
            $this->db->StartTrans();

            if ((int) $request["idpaciente"] > 0) {
                $calendar = new Calendar();
                $edad = $calendar->calculaEdad($request["fechaNacimiento"]);
                if ($edad < 18) {
                    $this->setMsg(["msg" => "Para crear una cuenta en DoctorPlus el paciente titular debe ser mayor de edad.", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            } else {
                $this->setMsg(["msg" => "Error. No se pudo recuperar el paciente", "result" => false]);
                return false;
            }
            $record["nombre"] = $request["nombre"];
            $record["apellido"] = $request["apellido"];
            $record["fechaNacimiento"] = $this->sqlDate($request["fechaNacimiento"]);
            $record["sexo"] = $request["sexo"] == 1 ? 1 : 0;

            $idpaciente = parent::update($record, $request["idpaciente"]);


            $paciente = parent::get($idpaciente);
            $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");
            $idusuarioWeb = $managerUsuarioWeb->basic_update($record, $paciente["usuarioweb_idusuarioweb"]);
            if (!$idpaciente || !$idusuarioWeb) {

                $this->setMsg(["msg" => "No se ha podido actualizar la informacion del paciente", "result" => false]);

                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }




            // Actualizo la edad del paciente
            $this->actualizarEdadPaciente($idpaciente);


            //Inserto un regisgtro en el perfil de salud status
            $this->getManager("ManagerPerfilSaludStatus")->insert(["paciente_idpaciente" => $idpaciente]);

            if ($this->db->hasFailedTrans()) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error al registrar el paciente", "result" => false]);
                return false;
            }
        } else {
            // este else agregue porque necesito setear algunos datos
            $idpaciente = $request["idpaciente"];
        }

        $request["registro_beneficiario"] = 1;
        $confirmar = $this->registracion_paciente_confirmar($request);
        if (!$confirmar) {

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error al registrar el paciente", "result" => false]);
            return false;
        }

        $mail_empresa = $this->getManager("ManagerPacienteEmpresa")->sendEmailNuevoBeneficiarioEmpresa($idpaciente);
        if (!$mail_empresa) {

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error al registrar el paciente", "result" => false]);
            return false;
        }

        if ($this->db->hasFailedTrans()) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error al registrar el paciente", "result" => false]);
            return false;
        }

        $this->setMsg(["msg" => "Ha sido dado de alta en el sistema", "result" => true, "idpaciente" => $idpaciente]);
        $this->db->CompleteTrans();

        return true;
    }

    /*
     * Realización de la registración web del paciente. Carga los pasos desagregados
     * @param type $request
     * @return boolean
     */

    public function registracion_paciente($request, $alta_from_medico = 0) {



        if ($alta_from_medico) {
            return $this->registracion_paciente_from_medico($request);
        } else {
            if ($request["step"] == "") {
                $this->setMsg(["msg" => "Error.", "result" => false]);

                return false;
            }
            switch ($request["step"]) {
                case 1:
                    return $this->registracion_paciente_step1($request, $alta_from_medico);
                case 2:
                    return $this->checkValidacionCelular($request);
                case 3:
                    return $this->registracion_paciente_step3($request, $alta_from_medico);
                case 4:
                    return $this->registracion_paciente_step4($request, $alta_from_medico);
                case 5:
                    return $this->registracion_paciente_step5($request, $alta_from_medico);
                case 6:
                    return $this->registracion_paciente_step6($request, $alta_from_medico);
                default:
                    $this->setMsg(["msg" => "Error.", "result" => false]);

                    return false;
            }
        }
    }

    /**
     * Realización de la registración web del paciente.
     * @param type $request
     * @return boolean
     */
    public function registracion_paciente_step1($request, $alta_from_medico = 0) {

        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");

        if ($request["email"] == "" || $request["password"] == "" || $request["numeroCelular"] == "") {
            $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
            return false;
        }
        if ($request["terminos_condiciones"] == "") {

            $this->setMsg(["msg" => "Debe aceptar los Términos y condiciones de uso del sistema.", "result" => false]);
            return false;
        }

        $captcha = $managerUsuarioWeb->validateGReCaptcha($request);

        if (!$captcha && $_SERVER["HTTP_HOST"] != "localhost") {
            $this->setMsg(["msg" => "Error, verificación captcha incorrecta", "result" => false]);
            return false;
        }

        //valido  Email registro pendiente
        $usuarioWeb = $managerUsuarioWeb->getByFieldArray(["email", "registrado"], [$request["email"], 0]);

        if ($usuarioWeb) {
            $managerUsuarioWeb->delete($usuarioWeb["idusuarioweb"], true);
        }

        //Apertura Transaccion
        $this->db->StartTrans();

        //Registración de usuario 

        $request["tipousuario"] = "paciente";

        $request["numeroCelular"] = str_replace(' ', '', $request["numeroCelular"]);


        $idusuarioweb = $managerUsuarioWeb->registracion_web($request);

        //Si hubo un problema al momento de crear un usuario
        if (!$idusuarioweb) {
            //Seteo el mensaje por el problema que ocurrió en el ManagerUsuarioWeb
            $this->db->FailTrans();
            $this->setMsg($managerUsuarioWeb->getMsg());

            $this->db->CompleteTrans();
            return false;
        }

        $request["usuarioweb_idusuarioweb"] = $idusuarioweb;

        //Valido que no haya otro paciente con un email.

        $idpaciente = parent::insert($request);
        if (!$idpaciente) {

            $this->setMsg(["msg" => "No se ha podido dar de alta el paciente", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        $rdo_msg = $this->sendSMSValidacion($idpaciente);
        if (!$rdo_msg) {

            $this->setMsg(["msg" => "No se ha podido enviar el código de verifiación a su celular", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }



        $this->setMsg(["msg" => "Ha sido dado de alta en el sistema", "result" => true, "idpaciente" => $idpaciente]);
        $this->db->CompleteTrans();
        return true;
    }

    /**
      /**
     * Realización de la registración del los datos del paciente.
     * @param type $request
     * @return boolean
     */
    public function registracion_paciente_step3($request) {


        if ($request["nombre"] == "" || $request["apellido"] == "" || $request["fechaNacimiento"] == "") {
            $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
            return false;
        }

        $request["nombre"] = ucwords(strtolower($request["nombre"]));
        $request["apellido"] = ucwords(strtolower($request["apellido"]));

        //Apertura Transaccion
        $this->db->StartTrans();

        if ((int) $request["idpaciente"] > 0) {
            $calendar = new Calendar();
            $edad = $calendar->calculaEdad($request["fechaNacimiento"]);
            if ($edad < 18) {
                $this->setMsg(["msg" => "Para crear una cuenta en DoctorPlus el paciente titular debe ser mayor de edad.", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        } else {
            $this->setMsg(["msg" => "Error. No se pudo recuperar el paciente", "result" => false]);
            return false;
        }
        $record["nombre"] = $request["nombre"];
        $record["apellido"] = $request["apellido"];
        $record["fechaNacimiento"] = $this->sqlDate($request["fechaNacimiento"]);
        $record["sexo"] = $request["sexo"] == 1 ? 1 : 0;


        $idpaciente = parent::update($record, $request["idpaciente"]);


        $paciente = parent::get($idpaciente);
        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");
        $idusuarioWeb = $managerUsuarioWeb->basic_update($record, $paciente["usuarioweb_idusuarioweb"]);
        if (!$idpaciente || !$idusuarioWeb) {

            $this->setMsg(["msg" => "No se ha podido actualizar la informacion del paciente", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }




        // Actualizo la edad del paciente
        $this->actualizarEdadPaciente($idpaciente);


        //Inserto un regisgtro en el perfil de salud status
        $this->getManager("ManagerPerfilSaludStatus")->insert(["paciente_idpaciente" => $idpaciente]);

        if ($this->db->hasFailedTrans()) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error al registrar el paciente", "result" => false]);
            return false;
        }

        $this->setMsg(["msg" => "Ha sido dado de alta en el sistema", "result" => true, "idpaciente" => $idpaciente]);

        $this->db->CompleteTrans();

        return true;
    }

    /**
      /**
     * Realización de la registración del los datos del paciente.
     * Registracion del pais
     * @param type $request
     * @return boolean
     */
    public function registracion_paciente_step4($request) {

        if ($request["beneficios_reintegro"] == "") {
            $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
            return false;
        }
        if ($request["idpaciente"] == "") {

            $this->setMsg(["msg" => "Error. No se pudo recuperar el paciente", "result" => false]);
            return false;
        }

        //Apertura Transaccion
        $this->db->StartTrans();



        $record["beneficios_reintegro"] = $request["beneficios_reintegro"];

        $idpaciente = parent::update($record, $request["idpaciente"]);
        if (!$idpaciente) {

            $this->setMsg(["msg" => "No se ha podido actualizar la informacion del paciente", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }
        if ($record["beneficios_reintegro"] == "0") {
            $confirmar = $this->registracion_paciente_confirmar($request);
            if (!$confirmar) {

                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }

        $this->setMsg(["msg" => "Ha sido dado de alta en el sistema", "result" => true, "idpaciente" => $idpaciente]);

        $this->db->CompleteTrans();

        return true;
    }

    /**
      /**
     * Realización de la registración del los datos del paciente.
     * Registracion del pais
     * @param type $request
     * @return boolean
     */
    public function registracion_paciente_step5($request) {

        if ($request["pais_idpais"] == "") {
            $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
            return false;
        }
        if ($request["idpaciente"] == "") {

            $this->setMsg(["msg" => "Error. No se pudo recuperar el paciente", "result" => false]);
            return false;
        }

        //Apertura Transaccion
        $this->db->StartTrans();



        $record["pais_idpais"] = $request["pais_idpais"];

        $idpaciente = parent::update($record, $request["idpaciente"]);
        if (!$idpaciente) {

            $this->setMsg(["msg" => "No se ha podido actualizar la informacion del paciente", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }


        $this->setMsg(["msg" => "Ha sido dado de alta en el sistema", "result" => true, "idpaciente" => $idpaciente]);

        $this->db->CompleteTrans();

        return true;
    }

    /**
      /**
     * Realización de la registración del los datos del paciente.
     * Carga de los datos e imagenes de las tarjetas de identificacion.
     * @param type $request
     * @return boolean
     */
    public function registracion_paciente_step6($request) {


        if ($request["idpaciente"] == "") {

            $this->setMsg(["msg" => "Error. No se pudo recuperar el paciente", "result" => false]);
            return false;
        }

        $request["no_trabajo_luxemburgo"] = $request["no_trabajo_luxemburgo"] == "" ? 0 : 1;
        //validamos las opciones seleccionada;
        $paciente = parent::get($request["idpaciente"]);

        /**
         *  1-Francia
         *  2-Luxemburgo
         *  3-Bélgica
         *  4-Otro país
         * */
        switch ($paciente["pais_idpais"]) {
            case 1://Francia
                if ($request["tarjeta_vitale"] == "") {
                    $this->setMsg(["msg" => "Error. Ingrese su número de tarjeta Vitale", "result" => false]);
                    return false;
                }

                if (!$this->validarTarjeta_Vitale($request["idpaciente"], $request["tarjeta_vitale"])) {
                    $this->setMsg(["msg" => "Error. Número de tarjeta Vitale no válido", "result" => false]);
                    return false;
                }
                if ($request["trabaja_otro_pais"] == "") {
                    $this->setMsg(["msg" => "Error. Seleccione si trabaja en otro país", "result" => false]);
                    return false;
                }

                if ($request["trabaja_otro_pais"] == 1 && $request["tarjeta_cns"] == "" && $request["no_trabajo_luxemburgo"] != 1) {
                    $this->setMsg(["msg" => "Error. Ingrese su número de tarjeta CNS", "result" => false]);
                    return false;
                }
                if ($request["tarjeta_cns"] != "") {
                    if (!$this->validarTarjeta_CNS($request["idpaciente"], $request["tarjeta_cns"])) {
                        $this->setMsg(["msg" => "Error. Número de tarjeta CNS no válido", "result" => false]);
                        return false;
                    }
                }
                break;
            case 2:
                //Luxemburgo
                if ($request["tarjeta_cns"] == "") {
                    $this->setMsg(["msg" => "Error. Ingrese su número de tarjeta CNS", "result" => false]);
                    return false;
                }

                if (!$this->validarTarjeta_CNS($request["idpaciente"], $request["tarjeta_cns"])) {
                    $this->setMsg(["msg" => "Error. Número de tarjeta CNS no válido", "result" => false]);
                    return false;
                }

                break;

            case 3://Begica
                if ($request["tarjeta_eID"] == "") {
                    $this->setMsg(["msg" => "Error. Ingrese su número de tarjeta e-ID", "result" => false]);
                    return false;
                }

                if (!$this->validarTarjeta_eID($request["idpaciente"], $request["tarjeta_eID"])) {
                    $this->setMsg(["msg" => "Error. Número de tarjeta eID no válido", "result" => false]);
                    return false;
                }
                if ($request["trabaja_otro_pais"] == "") {
                    $this->setMsg(["msg" => "Error. Seleccione si trabaja en otro país", "result" => false]);
                    return false;
                }

                if ($request["trabaja_otro_pais"] == 1 && $request["tarjeta_cns"] == "" && $request["no_trabajo_luxemburgo"] != 1) {
                    $this->setMsg(["msg" => "Error. Ingrese su número de tarjeta CNS", "result" => false]);
                    return false;
                }

                if ($request["tarjeta_cns"] != "") {
                    if (!$this->validarTarjeta_CNS($request["idpaciente"], $request["tarjeta_cns"])) {
                        $this->setMsg(["msg" => "Error. Número de tarjeta CNS no válido", "result" => false]);
                        return false;
                    }
                }
                break;
            case 4://Otro pais
                if ($request["tarjeta_pasaporte"] == "") {
                    $this->setMsg(["msg" => "Error. Ingrese su número de Pasaporte", "result" => false]);
                    return false;
                }

                break;
            default:
                $this->setMsg(["msg" => "No se ha podido actualizar la informacion del paciente", "result" => false]);


                return false;
        }
        //verificamos que se haya cargado la imagen
        foreach ($request["hash"] as $hash) {

            if ($_SESSION[$hash]["name"] == "pasaporte" && $_SESSION[$hash]["realName"] != "") {
                $pasaporte_ext = $_SESSION[$hash]["ext"];
                $pasaporte_path_temp = path_files("temp/" . $hash . "." . $pasaporte_ext);
                $pasaporte_path_file = path_entity_files("$this->imgContainer/{$request["idpaciente"]}/pasaporte.{$pasaporte_ext}");
                $pasaporte_exist = file_exists($pasaporte_path_temp);
                $pasaporte_is_file = is_file($pasaporte_path_temp);

                if ($pasaporte_exist && $pasaporte_is_file) {

                    //copiamos el archivo a su ubicacion final
                    copy($pasaporte_path_temp, $pasaporte_path_file);
                    //comprobamos que se hayan movido
                    if (!file_exists($pasaporte_path_file) || !is_file($pasaporte_path_file)) {
                        $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                        return false;
                    }
                }
            }

            if ($_SESSION[$hash]["name"] == "eID" && $_SESSION[$hash]["realName"] != "") {
                $eID_ext = $_SESSION[$hash]["ext"];
                $eID_path_temp = path_files("temp/" . $hash . "." . $eID_ext);
                $eID_path_file = path_entity_files("$this->imgContainer/{$request["idpaciente"]}/eID.{$eID_ext}");
                $eID_exist = file_exists($eID_path_temp);
                $eID_is_file = is_file($eID_path_temp);

                if ($eID_exist && $eID_is_file) {

                    //copiamos el archivo a su ubicacion final
                    copy($eID_path_temp, $eID_path_file);
                    //comprobamos que se hayan movido
                    if (!file_exists($eID_path_file) || !is_file($eID_path_file)) {
                        $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                        return false;
                    }
                }
            }

            if ($_SESSION[$hash]["name"] == "cns" && $_SESSION[$hash]["realName"] != "") {
                $cns_ext = $_SESSION[$hash]["ext"];
                $cns_path_temp = path_files("temp/" . $hash . "." . $cns_ext);
                $cns_path_file = path_entity_files("$this->imgContainer/{$request["idpaciente"]}/cns.{$cns_ext}");
                $cns_exist = file_exists($cns_path_temp);
                $cns_is_file = is_file($cns_path_temp);

                if ($cns_exist && $cns_is_file) {

                    //copiamos el archivo a su ubicacion final
                    copy($cns_path_temp, $cns_path_file);
                    //comprobamos que se hayan movido
                    if (!file_exists($cns_path_file) || !is_file($cns_path_file)) {
                        $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                        return false;
                    }
                }
            }
            if ($_SESSION[$hash]["name"] == "vitale" && $_SESSION[$hash]["realName"] != "") {
                $vitale_ext = $_SESSION[$hash]["ext"];
                $vitale_path_temp = path_files("temp/" . $hash . "." . $vitale_ext);
                $vitale_path_file = path_entity_files("$this->imgContainer/{$request["idpaciente"]}/vitale.{$vitale_ext}");
                $vitale_exist = file_exists($vitale_path_temp);
                $vitale_is_file = is_file($vitale_path_temp);

                if ($vitale_exist && $vitale_is_file) {

                    //copiamos el archivo a su ubicacion final
                    copy($vitale_path_temp, $vitale_path_file);
                    //comprobamos que se hayan movido
                    if (!file_exists($vitale_path_file) || !is_file($vitale_path_file)) {
                        $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                        return false;
                    }
                }
            }
        }



        if ($request["idpaciente"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo recuperar el paciente", "result" => false]);
            return false;
        }

        //Apertura Transaccion
        $this->db->StartTrans();



        $idpaciente = parent::update($request, $request["idpaciente"]);
        if (!$idpaciente) {

            $this->setMsg(["msg" => "No se ha podido actualizar la informacion del paciente", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        $confirmar = $this->registracion_paciente_confirmar($request);
        if (!$confirmar) {

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        if ($this->db->hasFailedTrans()) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Ha ocurrido un error al registrar el paciente", "result" => false]);
            return false;
        }
        //eliminamos los archivos temporales subidos
        foreach ($request["hash"] as $hash) {
            unlink(path_files("temp/" . $hash . "." . $_SESSION[$hash]["ext"]));
            unset($_SESSION[$hash]);
        }

        $this->setMsg(["msg" => "Ha sido dado de alta en el sistema", "result" => true, "idpaciente" => $idpaciente]);

        $this->db->CompleteTrans();

        return true;
    }

    /**
     * Metodo que valida el numero de tarjeta ingresado
     * @param type $nro
     */
    private function validarTarjeta_Vitale($idpaciente, $nro) {
        /**
          Cantidad de 15 numeros
          Control sobre el sexo : primer digito 1 - hombre 2-mujer
          Digito 2 y 3 son los dos ultimos numero de  año de nacimiento.
          Digito 4 y 5 son los del mes de nacimiento.
         */
        if (strlen($nro) != 15) {
            return false;
        }
        $sexo_tarjeta = substr($nro, 0, 1);
        $anio_tarjeta = substr($nro, 1, 2);
        $mes_tarjeta = substr($nro, 3, 2);
        $paciente = parent::get($idpaciente);
        $usuario_web = $this->getManager("ManagerUsuarioWeb")->get($paciente["usuarioweb_idusuarioweb"]);

        if (($usuario_web["sexo"] == 1 && $sexo_tarjeta != 1) || ($usuario_web["sexo"] == 0 && $sexo_tarjeta != 2)) {

            return false;
        }
        list($yyyy, $mm, $dd) = explode("-", $paciente["fechaNacimiento"]);


        if (substr($yyyy, 2, 2) != $anio_tarjeta || $mm != $mes_tarjeta) {
            return false;
        }

        return true;
    }

    /**
     * Metodo que valida el numero de tarjeta ingresado
     * @param type $nro
     */
    private function validarTarjeta_CNS($idpaciente, $nro) {
        /**
          Cantidad de 13 numeros

          el nro empieza con la fecha de nacimineto-yyymmdd
         */
        if (strlen($nro) != 13) {

            return false;
        }

        $anio_tarjeta = substr($nro, 0, 4);
        $mes_tarjeta = substr($nro, 4, 2);
        $dia_tarjeta = substr($nro, 6, 2);
        $paciente = parent::get($idpaciente);

        list($yyyy, $mm, $dd) = explode("-", $paciente["fechaNacimiento"]);
        if ($yyyy != $anio_tarjeta || $mm != $mes_tarjeta || $dd != $dia_tarjeta) {

            return false;
        }

        return true;
    }

    /**
     * Metodo que valida el numero de tarjeta ingresado
     * @param type $nro
     */
    private function validarTarjeta_eID($idpaciente, $nro) {
        /**
          Cantidad de 12 numeros

         */
        if (strlen($nro) != 12) {
            return false;
        }



        return true;
    }

    /**
      /**
     * Realización de la registración del los datos del paciente.
     * Aceptación de terminos
     * @param type $request
     * @return boolean
     */
    public function registracion_paciente_confirmar($request) {


        if ($request["idpaciente"] == "") {

            $this->setMsg(["msg" => "Error. No se pudo recuperar el paciente", "result" => false]);
            return false;
        }
        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");

        //validamos las opciones seleccionada;
        $paciente = parent::get($request["idpaciente"]);
        //registramos el pais de trabajo segun el pais de residencia y los seleccionado por el usuario
        if ($paciente["beneficios_reintegro"] == 1) {
            switch ($paciente["pais_idpais"]) {
                case 1://francia
                    if ($paciente["trabaja_otro_pais"] == 1 && $paciente["tarjeta_cns"] != "") {
                        $pais_trabajo = 2; //luxemburgo
                    }
                    if ($paciente["trabaja_otro_pais"] == 1 && $paciente["no_trabajo_luxemburgo"] == 1) {
                        $pais_trabajo = 4; //otro pais
                    }
                    if ($paciente["trabaja_otro_pais"] == 0) {
                        $pais_trabajo = 1; //francia
                    }
                    break;

                case 2://luxemburgo
                    $pais_trabajo = 2; //luxemburgo
                    break;
                case 3://belgica
                    if ($paciente["trabaja_otro_pais"] == 1 && $paciente["tarjeta_cns"] != "") {
                        $pais_trabajo = 2; //luxemburgo
                    }
                    if ($paciente["trabaja_otro_pais"] == 1 && $paciente["no_trabajo_luxemburgo"] == 1) {
                        $pais_trabajo = 4; //otro pais
                    }

                    if ($paciente["trabaja_otro_pais"] == 0) {
                        $pais_trabajo = 1; //francia
                    }

                    break;
                case 4://luxemburgo
                    $pais_trabajo = 4; //luxemburgo
                    break;
            }
            $upd_paciente = parent::update(["pais_idpais_trabajo" => $pais_trabajo], $paciente["idpaciente"]);
            if (!$upd_paciente) {
                $this->setMsg(["msg" => "Ha ocurrido un error al registrar el paciente", "result" => false]);
                return false;
            }
        }

        //marcamos el paciente con el registro finalizado
        $rdo_upd = $managerUsuarioWeb->basic_update(["registrado" => 1], $paciente["usuarioweb_idusuarioweb"]);
        if ($request["banderaBeneficiarioExistente"] != '1') {
            if ($request["registro_beneficiario"] == 1) {
                $rdo = $managerUsuarioWeb->sendEmailValidationBeneficiario($paciente["usuarioweb_idusuarioweb"]);
            } else {
                $rdo = $managerUsuarioWeb->sendEmailValidation($paciente["usuarioweb_idusuarioweb"]);
            }
        } else {
            $rdo = true;
        }


        $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");

        if ($request["banderaBeneficiarioExistente"] != '1') {
            //Fix creacion cuenta
            $idcuenta_usuario = $ManagerCuentaUsuario->insert([
                "paciente_idpaciente" => $paciente["idpaciente"],
                "saldo" => 0
            ]);
        }

        //Me tengo que fijar si el paciente tiene una invitacion del medico previa
        $usuario_web = $managerUsuarioWeb->get($paciente["usuarioweb_idusuarioweb"]);
        $ManagerMedicoPacienteInvitacion = $this->getManager("ManagerMedicoPacienteInvitacion");
        $ManagerMedicoPacienteInvitacion->checkPacienteInvitacionFromRegistro([
            "idpaciente" => $paciente["idpaciente"],
            "email" => $usuario_web["email"]
        ]);


        if (!$rdo || !$rdo_upd) {

            $this->setMsg(["msg" => "Ha ocurrido un error al registrar el paciente", "result" => false]);
            return false;
        } else {
            $this->setMsg(["msg" => "Ha sido dado de alta en el sistema", "result" => true, "idpaciente" => $request["idpaciente"]]);


            // <------------------
            // Fix 20191125 Enviamos SMS de creación de nueva cuenta
            $cuerpo = "WorknCare vous a envoyé un email pour confirmer votre compte. Si vous ne le voyez pas, il est peut-être dans les spams!";

            $ManagerLogSMS = $this->getManager("ManagerLogSMS");
            $sms = $ManagerLogSMS->insert([
                "dirigido" => 'P',
                "paciente_idpaciente" => $paciente["idpaciente"],
                //"medico_idmedico" => $request["idmedico"],
                "contexto" => "SMS ALTA",
                "texto" => $cuerpo,
                "numero_cel" => $paciente["numeroCelular"]
            ]);
            // <------------------
            // 
            // 
            // <-- LOG
            $log["data"] = "email, password, celular, surname, family name, birthday, gender, country of residence, country of work, social security or passport number + picture, terms & conditions approval";
            $log["page"] = "Create account";
            $log["usertype"] = "Patient";
            $log["action"] = "val"; //"vis" "del"
            $log["purpose"] = "Create account";
            $log["userid"] = $request["idpaciente"];

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);

            // <--
            return true;
        }
    }

    /**
     * Realización de la registración web del paciente por parte del médico y desde la seccion agenda.
     * @param type $request
     * @return boolean
     */
    public function registracion_paciente_from_medico($request) {

        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");

        if ($request["nombre"] == "" || $request["apellido"] == "") {
            $this->setMsg(["msg" => "Error. Verifique los campos obligatrios", "result" => false]);
            return false;
        }

        //Apertura Transaccion
        $this->db->StartTrans();

        //Registración de usuario 

        $request["tipousuario"] = "paciente";
        $request["cambiar_pass"] = '1';
        $idusuarioweb = $managerUsuarioWeb->registracion_web($request);

        //Si hubo un problema al momento de crear un usuario
        if (!$idusuarioweb) {

            //Seteo el mensaje por el problema que ocurrió en el ManagerUsuarioWeb
            $this->db->FailTrans();
            $msg = $this->setMsg($managerUsuarioWeb->getMsg());

            $this->db->CompleteTrans();
            return false;
        }

        $request["usuarioweb_idusuarioweb"] = $idusuarioweb;

        $request["fechaNacimiento"] = $this->sqlDate($request["fechaNacimiento"]);


        if ((int) $request["usuarioweb_idusuarioweb"] > 0) {
            $calendar = new Calendar();
            $edad = $calendar->calculaEdad($request["fechaNacimiento"]);

            if ($edad < 18) {
                $this->setMsg(["msg" => "Para crear una cuenta en DoctorPlus el paciente titular debe ser mayor de edad.", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }

        //Valido que no haya otro paciente con un email.

        $idpaciente = parent::insert($request);

        if (!$idpaciente) {

            $this->setMsg(["msg" => "No se ha podido dar de alta el paciente", "result" => false]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        //Creo la cuenta del usuario
        if ((int) $request["usuarioweb_idusuarioweb"] > 0) {

            $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
            $idcuenta_usuario = $ManagerCuentaUsuario->insert([
                "paciente_idpaciente" => $idpaciente,
                "saldo" => 0
            ]);

            //FIX Para los 5000, inserto
            $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
            $insert_movimiento = $ManagerMovimientoCuenta->insert([
                "fecha" => date("Y-m-d H:i:s"),
                "monto" => 0,
                "is_ingreso" => 1,
                "cuentaUsuario_idcuentaUsuario" => $idcuenta_usuario,
                "paciente_idpaciente" => $idpaciente,
                "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 3
            ]);

            if (!$insert_movimiento) {
                $this->setMsg(["msg" => "No se ha podido insertar el movimiento de cuenta", "result" => false]);

                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }

        // Actualizo la edad del paciente
        $this->actualizarEdadPaciente($idpaciente);

        //Creo las notificaciones 
        $this->getManager("ManagerNotificacion")->createNotificacionesFromAddPaciente($idpaciente);

        //Inserto un regisgtro en el perfil de salud status
        $this->getManager("ManagerPerfilSaludStatus")->insert(["paciente_idpaciente" => $idpaciente]);


        $usuario_web = $managerUsuarioWeb->get($idusuarioweb);
        //Me tengo que fijar si el paciente tiene una invitacion del medico previa
        $ManagerMedicoPacienteInvitacion = $this->getManager("ManagerMedicoPacienteInvitacion");
        $ManagerMedicoPacienteInvitacion->checkPacienteInvitacionFromRegistro([
            "idpaciente" => $idpaciente,
            "email" => $usuario_web["email"]
        ]);
        if ($request["numeroCelular"] != "") {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            $this->sendSMSInvitacionTurnoMedico($idpaciente, $idmedico);
        }



        $this->setMsg(["msg" => "Ha sido dado de alta en el sistema", "result" => true, "idpaciente" => $idpaciente]);

        $this->db->CompleteTrans();

        return true;
    }

    /**
     * Insert básico para no usar el insert
     * @param type $request
     * @return type
     */
    public function basic_insert($request) {
        $rdo = parent::insert($request);

        if ($rdo) {
            if ((int) $request["usuarioweb_idusuarioweb"] > 0) {
                $ManagerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");
                $ManagerUsuarioWeb->actualiceSessionPaciente($request["usuarioweb_idusuarioweb"]);
            }
            return $rdo;
        } else {
            return false;
        }
    }

    /**
     * Update básico para no usar el insert
     * @param type $request
     * @return type
     */
    public function basic_update($request, $id) {
        $rdo = parent::update($request, $id);

        if ($rdo) {
            if ((int) $request["usuarioweb_idusuarioweb"] > 0) {
                $ManagerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");
                $ManagerUsuarioWeb->actualiceSessionPaciente($request["usuarioweb_idusuarioweb"]);
            }
            return $rdo;
        } else {
            return false;
        }
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {


        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");
        $request["tipousuario"] = "paciente";
        $idusuarioweb = $managerUsuarioWeb->insert($request);

        //Si hubo un problema al momento de crear un usuario
        if (!$idusuarioweb) {
            //Seteo el mensaje por el problema que ocurrió en el ManagerUsuarioWeb
            $this->setMsg($managerUsuarioWeb->getMsg());
            return false;
        }

        $request["usuarioweb_idusuarioweb"] = $idusuarioweb;

        //Colocamos el estado del médico como activo.
        $request["fechaNacimiento"] = $this->sqlDate($request["fechaNacimiento"]);
        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if (!$id) {

            $this->setMsg(["msg" => "No se pudo dar de alta al paciente", "result" => false]);

            return false;
        }


        //Inserto la obra social del paciente!
        if ($request["idobraSocial"] != "")
            $obraSocial_idobraSocial = (int) $request["idobraSocial"];
        else {
            $obraSocial_idobraSocial = (int) $request["idprepaga"];
        }

        $managerObraSocialPaciente = $this->getManager("ManagerObraSocialPaciente");
        $insert = array(
            "paciente_idpaciente" => $id,
            "obraSocial_idobraSocial" => $obraSocial_idobraSocial
        );
        $idObraSocialPaciente = $managerObraSocialPaciente->insert($insert);
        if (!$idObraSocialPaciente) {

            $this->setMsg(["msg" => "Se dió de alta el paciente", "result" => false]);
        }

        if ($id) {
            if ((int) $request["usuarioweb_idusuarioweb"] > 0) {
                $managerUsuarioWeb->actualiceSessionPaciente($idusuarioweb);
            }
        }
        return $id;
    }

    public function getListadoJSON($idpaginate = NULL, $request) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("
                $this->id,
                CONCAT(uw.apellido,', ', uw.nombre) as nombre,
                    
                IF(uw.sexo=1,'Masculino','Femenino') as sexo,
                ps.pais,
                IF(p.trabaja_otro_pais=1,'SI','NO') as trabaja_otro_pais,
                 p.numeroCelular as numeroCelular,
                uw.email,
                IF(uw.estado=1,'SI','NO') as mail_confirmado, 
                DATE_FORMAT(uw.fecha_alta,'%d-%m-%Y') as fecha_alta_format,
                IF(uw.active=1,'Activo','Inactivo') as activo
            ");
        $query->setFrom("
                $this->table p INNER JOIN usuarioweb uw ON (p.usuarioweb_idusuarioweb = uw.idusuarioweb and uw.registrado=1)
                    LEFT JOIN pais ps ON (ps.idpais=p.pais_idpais) 
            ");

        // Filtro
        if ($request["nombre"] != "") {

            $rdo = cleanQuery($request["nombre"]);

            $query->addAnd("(uw.nombre LIKE '%$rdo%' OR uw.apellido LIKE '%$rdo%')");
        }

        if ($request["email"] != "") {

            $rdo = cleanQuery($request["email"]);

            $query->addAnd("uw.email LIKE '%$rdo%'");
        }

        if ($request["sexo"] != "") {

            $rdo = cleanQuery($request["sexo"]);

            $query->addAnd("uw.sexo=$rdo");
        }

        if ($request["estado"] != "") {

            $rdo = cleanQuery($request["estado"]);

            $query->addAnd("uw.active=$rdo");
        }


        if ($request["nro_tarjeta"] != "") {

            $rdo = cleanQuery($request["nro_tarjeta"]);

            $query->addAnd("p.tarjeta_vitale LIKE '%$rdo%' || p.tarjeta_cns LIKE '%$rdo%' ||p.tarjeta_eID LIKE '%$rdo%' ||p.tarjeta_pasaporte LIKE '%$rdo%'  ");
        }



        $query->setOrderBy("uw.nombre ASC");

        $data = $this->getJSONList($query, array("nombre", "pais", "trabaja_otro_pais", "sexo", "numeroCelular", "email", "fecha_alta_format", "mail_confirmado", "activo"), $request, $idpaginate);

        return $data;
    }

    /**
     * Generacion de listado CSV con los médicos registrados 
     * 
     * @param type $request
     * 
     */
    public function ExportarPacientesCSV($request) {



        $data = $this->getListadoJSON(NULL, $request);
        $data_2 = json_decode($data, 1);

        $fecha_actual = date("Y-m-d");
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment;filename=pacientes-' . $fecha_actual . ".csv");


        $out = fopen('php://output', 'w');
        $cabecera = array("Nombre", "DNI", "Sexo", "Celular", "Email", "Fecha alta");
        fputcsv($out, $cabecera, ";");
        foreach ($data_2["rows"] as $registro) {
            unset($registro["cell"][0]);
            utf8_decode_ar($registro["cell"]);
            fputcsv($out, $registro["cell"], ";");
        }

        fclose($out);
    }

    /**
     * Método que retorna un listado conlos pacientes
     * @param type $request
     * @return type
     */
    public function getListPacientes($request) {


        $query = new AbstractSql();
        $query->setSelect("
                pacientes.*
            ");
        $query->setFrom("
                (( SELECT u.nombre, u.apellido, p.fechaNacimiento, p.estado, p.active, p.numeroCelular, u.sexo, p.idpaciente, u.email
			FROM paciente p
				INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb) 
		) 
		UNION 
		( SELECT pf.nombre, pf.apellido, p.fechaNacimiento, p.estado, p.active,IFNULL(p.numeroCelular,p_tit.numeroCelular) as numeroCelular, pf.sexo, p.idpaciente, '' as email
			FROM paciente p 
				INNER JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo) 
				INNER JOIN paciente p_tit ON (p_tit.idpaciente = pf.pacienteTitular) 
		)) as pacientes
            ");

        $query->setWhere("pacientes.active = 1");

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];


        $query->addAnd("pacientes.idpaciente NOT IN
              (
              SELECT tid.idpaciente
              FROM (
                        (SELECT p.idpaciente
			FROM turno t 
				INNER JOIN paciente p ON (t.paciente_idpaciente = p.idpaciente) 
				INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb and u.registrado=1) ) 
			) 
		UNION 
			( SELECT p.idpaciente
			FROM turno t 
				INNER JOIN paciente p ON (t.paciente_idpaciente = p.idpaciente) 
				INNER JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo) 
				INNER JOIN paciente p_tit ON (p_tit.idpaciente = pf.pacienteTitular) 
			)
                UNION
                        ( SELECT p.idpaciente
			FROM asociacion_medicos_pacientes t 
				INNER JOIN paciente p ON (t.paciente_idpaciente = p.idpaciente) 
				LEFT JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb and u.registrado=1) ) 
                                LEFT JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo)
                        WHERE t.medico_idmedico = $idmedico
			) 
                 ) AS tid
              )
            ");

        // Filtro
        if ($request["nombre_modal"] != "") {

            $rdo = cleanQuery($request["nombre_modal"]);

            $query->addAnd("(pacientes.nombre LIKE '%$rdo%') OR (pacientes.apellido LIKE '%$rdo%') OR (pacientes.email LIKE '%$rdo%') ");
        }

        $query->setOrderBy("pacientes.apellido ASC, pacientes.nombre ASC");

        $data = $this->getList($query);

        if ($data) {

            $data = $this->getPathImagesList($data, "idpaciente");
        }

        return $data;
    }

    /**
     * Eliminación multiple de los pacientes
     * También se van a eliminar los pacientes. Esto quedará así ya que por el 
     * momento se toma como una relación de 1 a 1 entre usuario y paciente
     * @param type $ids
     * @param type $force
     * @return boolean
     */
    public function deleteMultiple($ids, $force = false) {

        //Obtengo los records para eliminar
        $records = explode(",", $ids);

        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");

        if (count($records) == 0) {

            $this->setMsg(["result" => false, "msg" => "No se han seleccionado registros para la borrar"]);

            return false;
        } else {

            foreach ($records as $id) {
                $entity = $this->get($id, 0);


                $managerUsuarioWeb->delete($entity["usuarioweb_idusuarioweb"], $force);

                $this->delete($id, $force);
            }
        }
    }

    /*     * Metodo que cambia el estado activo de un paciente
     * 
     * @param type $idpaciente
     * @return type
     */

    public function HabilitarDesabilitarPaciente($idpaciente) {
        $paciente = parent::get($idpaciente);

        $uw = $this->getManager("ManagerUsuarioWeb")->get($paciente["usuarioweb_idusuarioweb"]);

        if ($uw["active"] == 1) {
            $active = 0;
        } else {
            $active = 1;
        }
        $rdo = $this->getManager("ManagerUsuarioWeb")->basic_update(["active" => $active], $uw["idusuarioweb"]);
        if ($rdo) {
            if ($active == 1) {
                $this->setMsg(["result" => true, "msg" => "Paciente habilitado con éxito"]);
            } else {
                $this->setMsg(["result" => true, "msg" => "Paciente deshabilitado con éxito"]);
            }
        } else {
            $this->setMsg(["result" => false, "msg" => "Error no se pudo actualizar el registro"]);
        }
        return $rdo;
    }

    /**
     * Método que retorna un array con información extra del paciente, utilizada para 
     * @param type $idpaciente
     * @return type
     */
    public function getInformacionExtra($idpaciente) {

        //echo "<hr><h1 style='color:#FF0000;'>getInformacionExtra IDPACIENTE:{$idpaciente}</h1><hr>";
        $extra = array();
        //$managerTurno = $this->getManager("ManagerTurno");
        //OBtengo la cantidad de turnos válidos del paciente
        /* $extra["cantidad_turnos"] = $managerTurno->getCantidadTurnosValidosPaciente($idpaciente);

          $profesionales_turnos_pacientes = $managerTurno->getProfesionalesTurnoPaciente($idpaciente, 3);
          if ($profesionales_turnos_pacientes != false) {
          $extra["profesionales_frecuentes"] = $profesionales_turnos_pacientes;
          } */
        $extra["is_permitido"] = $this->isPermitidoConsultaExpress($idpaciente);
        $ManagerNotificacion = $this->getManager("ManagerNotificacion");
        $extra["cant_notificaciones"] = $ManagerNotificacion->getCantidadNotificacionesPaciente($idpaciente);
        $extra["cant_consultaexpress"] = $this->getManager("ManagerConsultaExpress")->getCantidadConsultasExpressPacienteXEstado($idpaciente)["notificacion_general"];
        // $extra["cant_videoconsulta"] = $this->getManager("ManagerVideoConsulta")->getCantidadVideoConsultasPacienteXEstado($idpaciente)["notificacion_general"];
        $extra["cant_total"] = $extra["cant_notificaciones"] + $extra["cant_consultaexpress"] + $extra["cant_videoconsulta"];

        return $extra;
    }

    /**
     * Método que retorna un array con información extra del paciente, utilizada para 
     * @param type $idpaciente
     * @return type
     */
    public function get_notificaciones_menu($idpaciente) {
        $extra = array();

        $ManagerNotificacion = $this->getManager("ManagerNotificacion");
        $extra["cant_notificaciones"] = $ManagerNotificacion->getCantidadNotificacionesPaciente($idpaciente);
        $extra["cant_consultaexpress"] = $this->getManager("ManagerConsultaExpress")->getCantidadConsultasExpressPacienteXEstado($idpaciente)["notificacion_general"];
        $extra["cant_videoconsulta"] = $this->getManager("ManagerVideoConsulta")->getCantidadVideoConsultasPacienteXEstado($idpaciente)["notificacion_general"];
        $extra["cant_total"] = $extra["cant_notificaciones"] + $extra["cant_consultaexpress"] + $extra["cant_videoconsulta"];

        return $extra;
    }

    /**
     * Chequeo del número que ingresó el paciente para la validacion
     * @param type $request
     * @return boolean
     */
    public function checkValidacionCelular($request) {


        if ($request["idpaciente"] == "") {
            $idpaciente = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];
        } else {
            $idpaciente = $request["idpaciente"];
        }

        $paciente = parent::get($idpaciente);
        $request["codigoValidacionCelular"] = strtoupper(trim($request["codigoValidacionCelular"]));
        //  fIX PARA PODER HACER LOGIN DESDE TEST
        if (defined("SMS_TEST") && $request["codigoValidacionCelular"] == 12345) {
            $paciente["codigoValidacionCelular"] = 12345;
        }

        if (($request["codigoValidacionCelular"] == $paciente["codigoValidacionCelular"]) && ($request["codigoValidacionCelular"] != "")) {
            $rdo = parent::update(array("celularValido" => 1), $idpaciente);

            if ($rdo) {
                $this->setMsg(["msg" => "El celular ha sido validado", "result" => true]);
                return true;
            } else {
                $this->setMsg(["msg" => "El código de validación no es válido", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg(["msg" => "El código de validación no es válido", "result" => false]);
            return false;
        }
    }

    /**
     * Método que se utiliza para enviar el código de verificación al paciente
     * @return boolean
     */
    public function sendSMSValidacion($idpaciente = null) {


        if (is_null($idpaciente)) {
            $idpaciente = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];
        }

        $paciente = parent::get($idpaciente);

        $numero = /* $paciente["caracteristicaCelular"] . */ $paciente["numeroCelular"];

        $caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        $numerodeletras = 5;

        $codigo = "";
        for ($i = 0; $i < $numerodeletras; $i++) {
            $codigo .= substr($caracteres, rand(0, strlen($caracteres)), 1); /* Extraemos 1 caracter de los caracteres 
              entre el rango 0 a Numero de letras que tiene la cadena */
        }

        if (defined("SMS_TEST")) {
            $codigo = "12345"; // FIX para test
        }
        //
        //Actualizo el código de validación de celular
        $id = parent::update(array("codigoValidacionCelular" => $codigo), $paciente["idpaciente"]);
        if (!$id) {
            $this->setMsg(["msg" => "Se produjo un error intente más tarde.", "result" => false]);
            return false;
        }

        $cuerpo = "Code de vérification WorknCare: " . $codigo;



        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => "P",
            "paciente_idpaciente" => $paciente["idpaciente"],
            "contexto" => "SMS de validación",
            "texto" => $cuerpo,
            "numero_cel" => $numero
        ]);


        if ($sms) {
            $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);

            return true;
        } else {
            $this->setMsg($ManagerLogSMS->getMsg());

            return false;
        }
    }

    /**
     * Método que se utiliza para enviar el mensaje de invitacion del medico al paciente con un turno agendado
     * @return boolean
     */
    public function sendSMSInvitacionTurnoMedico($idpaciente = null, $idmedico) {


        if (is_null($idpaciente)) {
            $idpaciente = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];
        }

        $paciente = parent::get($idpaciente);

        $numero = /* $paciente["caracteristicaCelular"] . */ $paciente["numeroCelular"];

        $caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        $numerodeletras = 5;

        $codigo = "";
        for ($i = 0; $i < $numerodeletras; $i++) {
            $codigo .= substr($caracteres, rand(0, strlen($caracteres)), 1); /* Extraemos 1 caracter de los caracteres 
              entre el rango 0 a Numero de letras que tiene la cadena */
        }

        if (defined("SMS_TEST")) {
            $codigo = "12345"; // FIX para test
        }
        //
        //Actualizo el código de validación de celular
        $id = parent::update(array("codigoValidacionCelular" => $codigo), $paciente["idpaciente"]);
        if (!$id) {
            $this->setMsg(["msg" => "Se produjo un error intente más tarde.", "result" => false]);
            return false;
        }

        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($idmedico, true);

        $cuerpo = "";

        if ($medico["titulo_profesional"]["titulo_profesional"] != "") {
            $cuerpo .= "Le " . $medico["titulo_profesional"]["titulo_profesional"] . " ";
        }

        if ($medico["mis_especialidades"][0]["tipo"] == 2 && $medico["mis_especialidades"][0]["tipo_identificacion"] == 2) {
            $label_paciente = "clients";
        } else {
            $label_paciente = "patients";
        }
        $cuerpo .= $medico["nombre"] . " " . $medico["apellido"] . " souhaite vous ajouter à ses {$label_paciente}. Inscrivez-vous en vous connectant à: " . URL_ROOT;





        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => "P",
            "paciente_idpaciente" => $paciente["idpaciente"],
            "contexto" => "SMS de validación",
            "texto" => $cuerpo,
            "numero_cel" => $numero
        ]);


        if ($sms) {
            $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);

            return true;
        } else {
            $this->setMsg($ManagerLogSMS->getMsg());

            return false;
        }
    }

    /**
     * Método que retorna un listado con los ID de medicos frecuentes del paciente
     * @param type $request
     * @param type $idpaginate
     * @param type $idpaciente
     * @param type $home
     */
    public function getMedicosFrecuentesList($request, $idpaginate = null, $idpaciente = null, $home = null) {

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->getPacienteXHeader();

        $idpaciente = $paciente["idpaciente"];

        //Seteo el current page
        //$request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        //SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("m.*,
                p.pais as pais_medico,
                pf.medico_cabecera,
                uw.*,
                cons.*,
                tp.titulo_profesional,
                IFNULL(getProximoTurnoVC(m.idmedico),'NO_TURNO') as proximo_turno_vc,
                IF ((SELECT COUNT(*) as cantidad FROM medico m2 JOIN v_consultorio cons2 ON (cons2.medico_idmedico = m2.idmedico) INNER JOIN profesionalesfrecuentes_pacientes pf2 ON (pf2.medico_idmedico = m2.idmedico)   WHERE pf2.paciente_idpaciente = {$idpaciente}  AND m2.idmedico = m.idmedico AND cons2.flag = 1 AND cons2.is_virtual <> 1) > 0, '1','0') as tiene_consultorio_fisico");

        $query->setFrom("medico m
                            INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                            INNER JOIN pais p ON (p.idpais=m.pais_idpais)
                            LEFT JOIN especialidadmedico em ON (em.medico_idmedico=m.idmedico)
                            LEFT JOIN especialidad esp ON (esp.idespecialidad=em.especialidad_idespecialidad)
                            LEFT JOIN v_consultorio cons ON (cons.medico_idmedico = m.idmedico)  
                            INNER JOIN profesionalesfrecuentes_pacientes pf ON (pf.medico_idmedico = m.idmedico)
                            INNER JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional=tp.idtitulo_profesional)");

        $query->setWhere("pf.paciente_idpaciente = $idpaciente");
        $query->addAnd("m.active = 1");
        $query->addAnd("m.validado = 1");
        $query->setGroupBy("m.idmedico");
        $query->setOrderBy("pf.medico_cabecera DESC,esp.acceso_directo DESC,pf.ultima_interaccion DESC");
        if ($home != null) {
            $query->setLimit("0,3");
        }

        $listado_medicos = $this->getList($query);

        if ($listado_medicos && count($listado_medicos) > 0) {
            //si viene desde la home no necesito toda la informacion extra
            if ($home == null) {
                $ManagerEspecialidadMedico = $this->getManager("ManagerEspecialidadMedico");
                $ManagerMedico = $this->getManager("ManagerMedico");
                $ManagerPreferencia = $this->getManager("ManagerPreferencia");
                $ManagerMedicoMisPacientes = $this->getManager("ManagerMedicoMisPacientes");
                $ManagerProfesionalValoracion = $this->getManager("ManagerProfesionalValoracion");
                $ManagerConsultorio = $this->getManager("ManagerConsultorio");
                $ManagerProgramaSaludExcepcion = $this->getManager("ManagerProgramaSaludExcepcion");
                $ManagerMedicoVacaciones = $this->getManager("ManagerMedicoVacaciones");
                foreach ($listado_medicos as $key => $medico) {
                    $listado_medicos[$key]["especialidad"] = $ManagerEspecialidadMedico->getEspecialidadesMedico($medico["idmedico"]);
                    $listado_medicos[$key]["imagen"] = $ManagerMedico->tieneImagen($medico["idmedico"]);
                    $listado_medicos[$key]["agenda"] = $ManagerMedico->getAgendaSemanal($medico["idmedico"], $medico["idconsultorio"]);

                    $listado_medicos[$key]["valoracion"] = $ManagerProfesionalValoracion->getCantidadRecomendaciones($medico["idmedico"]);
                    $listado_medicos[$key]["estrellas"] = $ManagerProfesionalValoracion->getCantidadEstrellas($medico["idmedico"]);
                    $listado_medicos[$key]["preferencia"] = $ManagerPreferencia->getPreferenciaMedico($medico["preferencia_idPreferencia"]);
                    $listado_medicos[$key]["paciente_sincargo"] = $ManagerMedicoMisPacientes->is_paciente_sin_cargo($idpaciente, $medico["idmedico"]);
                    $listado_medicos[$key]["consultorio_virtual"] = $ManagerConsultorio->getConsultorioVirtual($medico["idmedico"]);
                    //formateamos el proximo turno disponible
                    if ($listado_medicos[$key]["proximo_turno_vc"] != "NO_TURNO") {
                        $listado_medicos[$key]["proximo_turno_format"] = $ManagerMedico->formatProximoTurnoVC($listado_medicos[$key]["proximo_turno_vc"]);
                    }

                    //verificamos si el medico está incluido en los planes cubiertos por la empresa
                    if ($request["paciente_empresa"]["empresa_idempresa"] != "") {
                        $medico_bonificado = $ManagerProgramaSaludExcepcion->verificar_medico_bonificado($medico["idmedico"], $request["paciente_empresa"]["empresa_idempresa"]);
                        if ($medico_bonificado) {
                            $listado_medicos[$key]["medico_bonificado"] = 1;
                        }
                    }
                    //verificamos si el medico esta de vacaciones
                    $listado_medicos[$key]["vacaciones"] = $ManagerMedicoVacaciones->getVacacionesMedico($medico["idmedico"]);
                }
            }

            return $listado_medicos;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna un listado con los ID de medicos favoritos del paciente
     * @param type $request
     * @param type $idpaginate
     * @param type $idpaciente
     */
    public function getMedicosFavoritosList($request, $idpaginate = null, $idpaciente = null) {

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];
        $frecuentes = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getFrecuentes($idpaciente);
        //Seteo el current page
        /* $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
          SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate); */

        $query = new AbstractSql();

        $query->setSelect("m.*,
                tp.titulo_profesional,
                p.pais as pais_medico,
                uw.*,
                cons.*,
                IFNULL(getProximoTurnoVC(m.idmedico),'NO_TURNO') as proximo_turno_vc
                ");

        $query->setFrom("medico m
                            INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                            INNER JOIN pais p ON (p.idpais=m.pais_idpais)
                            LEFT JOIN v_consultorio cons ON (cons.medico_idmedico = m.idmedico)  
                            INNER JOIN profesionalfavorito pf ON (pf.medico_idmedico = m.idmedico)
                            INNER JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional=tp.idtitulo_profesional)
                             ");

        $query->setWhere("pf.paciente_idpaciente = $idpaciente");
        $query->addAnd("m.active = 1");
        $query->addAnd("m.validado = 1");
        //evitamos que el mismo medico aparezca en 2 listados repetido
        if ($frecuentes != "") {
            $query->addAnd("m.idmedico not in ($frecuentes)");
        }
        $query->setGroupBy("m.idmedico");


        $listado_medicos = $this->getList($query);

        if ($listado_medicos && count($listado_medicos) > 0) {

            $ManagerEspecialidadMedico = $this->getManager("ManagerEspecialidadMedico");
            $ManagerMedico = $this->getManager("ManagerMedico");
            $ManagerPreferencia = $this->getManager("ManagerPreferencia");
            $ManagerMedicoMisPacientes = $this->getManager("ManagerMedicoMisPacientes");
            $ManagerConsultorio = $this->getManager("ManagerConsultorio");
            $ManagerProfesionalValoracion = $this->getManager("ManagerProfesionalValoracion");
            $ManagerProgramaSaludExcepcion = $this->getManager("ManagerProgramaSaludExcepcion");
            $ManagerMedicoVacaciones = $this->getManager("ManagerMedicoVacaciones");
            foreach ($listado_medicos as $key => $medico) {
                //verificamos si el medico tiene habilitada la CE  para todos los pacientes
                $preferencia = $ManagerPreferencia->getPreferenciaMedico($medico["preferencia_idPreferencia"]);
                if ($request["modulo"] == "consultaexpress" && $preferencia["pacientesConsultaExpress"] == "2") {
                    //elimnamos el medico y saltamos al prox
                    unset($listado_medicos[$key]);
                    continue;
                }
                //verificamos si el medico tiene habilitada la VC  para todos los pacientes
                if ($request["modulo"] == "videoconsulta" && $preferencia["pacientesVideoConsulta"] == "2") {
                    //elimnamos el medico y saltamos al prox
                    unset($listado_medicos[$key]);
                    continue;
                }

                //obtenemos los informacion extra
                $listado_medicos[$key]["preferencia"] = $preferencia;
                $listado_medicos[$key]["especialidad"] = $ManagerEspecialidadMedico->getEspecialidadesMedico($medico["idmedico"]);
                $listado_medicos[$key]["imagen"] = $ManagerMedico->tieneImagen($medico["idmedico"]);
                $listado_medicos[$key]["agenda"] = $ManagerMedico->getAgendaSemanal($medico["idmedico"], $medico["idconsultorio"]);
                $listado_medicos[$key]["valoracion"] = $ManagerProfesionalValoracion->getCantidadRecomendaciones($medico["idmedico"]);
                $listado_medicos[$key]["estrellas"] = $ManagerProfesionalValoracion->getCantidadEstrellas($medico["idmedico"]);
                $listado_medicos[$key]["paciente_sincargo"] = $ManagerMedicoMisPacientes->is_paciente_sin_cargo($idpaciente, $medico["idmedico"]);
                $listado_medicos[$key]["consultorio_virtual"] = $ManagerConsultorio->getConsultorioVirtual($medico["idmedico"]);
                //formateamos el proximo turno disponible
                if ($listado_medicos[$key]["proximo_turno_vc"] != "NO_TURNO") {
                    $listado_medicos[$key]["proximo_turno_format"] = $ManagerMedico->formatProximoTurnoVC($listado_medicos[$key]["proximo_turno_vc"]);
                }

                //verificamos si el medico está incluido en los planes cubiertos por la empresa
                if ($request["paciente_empresa"]["empresa_idempresa"] != "") {
                    $medico_bonificado = $ManagerProgramaSaludExcepcion->verificar_medico_bonificado($medico["idmedico"], $request["paciente_empresa"]["empresa_idempresa"]);
                    if ($medico_bonificado) {
                        $listado_medicos[$key]["medico_bonificado"] = 1;
                    }
                }
                //verificamos si el medico esta de vacaciones
                $listado_medicos[$key]["vacaciones"] = $ManagerMedicoVacaciones->getVacacionesMedico($medico["idmedico"]);
            }

            return $listado_medicos;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna un listado con los ID de medicos frecuentes del paciente
     * @param type $request
     * @param type $idpaginate
     * @param type $idpaciente
     * @param type $home
     */
    public function getMedicosSugeridosList($idpaciente) {

        $query = new AbstractSql();

        $query->setSelect("m.*, uw.*,tp.titulo_profesional");

        $query->setFrom("medico m
                            INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                            INNER JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional=tp.idtitulo_profesional)");

        $query->setWhere("m.idmedico not in (
                                            select medico_idmedico from profesionalesfrecuentes_pacientes where paciente_idpaciente={$idpaciente}
                                            UNION 
                                            select medico_idmedico from profesionalfavorito where paciente_idpaciente={$idpaciente}
                                            )");

        $query->addAnd("m.active = 1");
        $query->addAnd("m.validado = 1");

        $query->setGroupBy("m.idmedico");
        //$query->setLimit("0,12");

        $listado_medicos = $this->getList($query);

        if (count($listado_medicos) > 0) {
            //si viene desde la home no necesito toda la informacion extra

            $ManagerEspecialidadMedico = $this->getManager("ManagerEspecialidadMedico");
            $ManagerMedico = $this->getManager("ManagerMedico");


            $ManagerProfesionalValoracion = $this->getManager("ManagerProfesionalValoracion");


            foreach ($listado_medicos as $key => $medico) {
                $listado_medicos[$key]["especialidad"] = $ManagerEspecialidadMedico->getEspecialidadesMedico($medico["idmedico"]);
                $listado_medicos[$key]["imagen"] = $ManagerMedico->getImagenMedico($medico["idmedico"]);

                $listado_medicos[$key]["valoracion"] = $ManagerProfesionalValoracion->getCantidadRecomendaciones($medico["idmedico"]);
                $listado_medicos[$key]["estrellas"] = $ManagerProfesionalValoracion->getCantidadEstrellas($medico["idmedico"]);
            }

            return $listado_medicos;
        } else {
            return false;
        }
    }

    /**
     * Devuelve la informacion del médicos de cabecera del paciente
     * @param type $idpaciente
     * @return boolean
     */
    public function getMedicoCabecera($idpaciente) {
        $profesional_frecuente_cabecera = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_cabecera"], [$idpaciente, 1]);
        if ($profesional_frecuente_cabecera) {
            return $this->getManager("ManagerMedico")->get($profesional_frecuente_cabecera["medico_idmedico"], true);
        }
        return false;
    }

    /**
     * Método que inicializa en session la información utilizada para el menú del paciente
     * @param type $requerimiento
     */
    public function inicializarPaciente($requerimiento = null) {


        if (is_null($requerimiento) && isset($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"])) {
            $requerimiento = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"]["filter_selected"];
        }

        $managerPacienteGrupoFamiliar = $this->getManager("ManagerPacienteGrupoFamiliar");


        $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"] = array(
            "filter_selected" => !is_null($requerimiento) && $requerimiento != "" ? $requerimiento : "self",
            "filter_selected_prev" => !is_null($requerimiento) && $requerimiento != "" && $requerimiento != "all" ? $requerimiento : $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"]["filter_selected_prev"]
        );
        //Listado de todos los miembros
        $all_members = $managerPacienteGrupoFamiliar->getAllPacientesFamiliares(array());
        if (count($all_members) > 0) {
            $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"]["all_members"] = $all_members;
        } else {
            $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"]["all_members"] = false;
        }



        $smarty = SmartySingleton::getInstance();
        $smarty->assign("header_info", $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"]);
    }

    /**
     * Método que cambia el miembro de la sessión..
     * @param type $request
     * @return boolean
     */
    public function change_member_session($request) {

        $requerimiento = $request["requerimiento"];
        //marcamos si ya se selecciono el miembro al inicio de la sesion
        if ($request["from_home"] == 1) {
            $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["miembro_seleccionado"] = 1;
        }
        if (isset($requerimiento) && $requerimiento != "") {
            $this->inicializarPaciente($requerimiento);

            $this->setMsg(["msg" => "Éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No se puede acceder a la información del usuario seleccionado", "result" => false]);
            return false;
        }
    }

    /**
     * Cambio del miembro de session cuando apretan home
     * @return boolean
     */
    public function change_member_session_go_home() {
        //Si no hay paciente en session, pongo en session al usuario principal
        $paciente = $this->getPacienteXHeader();
        if ($paciente) {
            $this->setMsg(["msg" => "Éxito", "result" => true]);
            return true;
        } else {
            $requerimiento = "self";

            if (isset($requerimiento) && $requerimiento != "") {
                $this->inicializarPaciente($requerimiento);

                $this->setMsg(["msg" => "Éxito", "result" => true]);
                return true;
            } else {
                $this->setMsg(["msg" => "Error. No se puede acceder a la información del usuario seleccionado", "result" => false]);
                return false;
            }
        }
    }

    /**
     * Cambio de miembro en sessión por el id del paciente
     * @param type $idpaciente
     * @return boolean
     */
    public function change_member_session_withID($idpaciente) {
        $paciente = $this->get($idpaciente);

        if ($paciente["email"] == "") {
            //Es un paciente del grupo familiar
            $requerimiento = $paciente[$this->id];
        } else {
            //Es el paciente titular
            $requerimiento = "self";
        }

        if (isset($requerimiento) && $requerimiento != "") {
            $this->inicializarPaciente($requerimiento);
            $this->setMsg(["msg" => "Éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No se puede acceder a la información del usuario seleccionado", "result" => false]);
            return false;
        }
    }

    /**
     * Método que retorna el paciente que se encuentra seleccionado en el array de SESSION de header_paciente
     * @return type
     */
    public function getPacienteXHeader() {

        $header_paciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"];


        if (isset($header_paciente["filter_selected"]) && $header_paciente["filter_selected"] != "") {

            if ($header_paciente["filter_selected"] == "self") {

                $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
            } elseif ($_REQUEST["submodulo"] != "miembros_list" && $header_paciente["filter_selected"] == "all") {

                //si esta seleccionado Todos (all), y no estamos en el listado de miembros, seteamos al paciente anterior o el titular
                //esto es para cuando se accede al listado de miembros, y se vuelve hacia atras en el navegador, pues sino no estará seteado ningun paciente
                if ($header_paciente["filter_selected_prev"] != "" && $header_paciente["filter_selected_prev"] != "all") {

                    $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"]["filter_selected_prev"];
                    $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"]["filter_selected"] = $idpaciente;
                } else {

                    $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
                    $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"]["filter_selected"] = "self";
                }
            } else {

                $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"]["filter_selected"];
            }
        } else {
            $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
        }

        $paciente = $this->get($idpaciente);
        $paciente["is_permitido"] = $this->isPermitidoConsultaExpress($idpaciente);

        return $paciente;
    }

    /**
     * Método que retorna el paciente que se encuentra seleccionado en el array de SESSION de header_paciente
     * @return type
     */
    public function getPacienteXSelectMedico($idpaciente = null) {


        //si no viene el id lo obtenemos de session,
        if (is_null($idpaciente)) {
            $header_paciente = $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"];
            $idpaciente = $header_paciente["idpaciente"];
        } else {
            //lo seteamos en sesion cuando proviene de una URL externa de mail
            $paciente = $this->getManager("ManagerMedico")->getPacienteMedico($idpaciente);
            $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"] = $paciente;
        }

        if ($idpaciente) {

            $data = $this->isPacienteMedico($idpaciente);

            return $data;
        } else {
            return false;
        }
    }

    /**
     * Método utilizado para retornar si un determinado paciente pertenece al médico que se encuentra en session..
     * 
     * @param type $idpaciente
     * @return boolean
     */
    public function isPacienteMedico($idpaciente) {
        //Obtengo el paciente
        $paciente = $this->get($idpaciente);

        if ($paciente) {

            $return_paciente = false;

            switch ((int) $paciente["privacidad_perfil_salud"]) {
                case 0:
                    //No lo puede ver nadie
                    //fix paciente con PS oculto luego de hacer la VC, sino el medico no la puede finalizar
                    if ($_REQUEST["submodulo"] == "terminar_videoconsulta") {
                        $return_paciente = true;
                    } else {
                        $return_paciente = false;
                    }

                    break;
                case 1:

                    //Solamente los profesionales frecuentes
                    /* $ManagerMedico = $this->getManager("ManagerMedico");
                      $paciente = $ManagerMedico->getPacienteMedico($idpaciente);
                      if ($paciente && count($paciente) > 0) {
                      $return_paciente = true;
                      } else { */
                    //si no es de mis pacientes verifico si soy medico favorito o frecuente
                    $freq = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->isFrecuente($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"], $idpaciente);
                    $fav = $this->getManager("ManagerProfesionalFavorito")->isFavorito($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"], $idpaciente);

                    if ($freq || $fav) {
                        $paciente = $this->get($idpaciente);
                        $return_paciente = true;
                    } else {
                        $return_paciente = false;
                    }
                    //}
                    break;
                case 2:
                    //Todos los médicos de DP
                    $return_paciente = true;
                    break;
                default:
                    break;
            }

            if ($return_paciente) {
                $profesional_frecuente_cabecera = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_cabecera"], [$idpaciente, 1]);
                if ($profesional_frecuente_cabecera) {
                    $paciente["medico_cabecera"] = $this->getManager("ManagerMedico")->get($profesional_frecuente_cabecera["medico_idmedico"]);
                }
                $paciente["imagenes_tarjeta"] = $this->getImagenesIdentificacion($idpaciente);
                return $paciente;
            } else {

                throw new ExceptionErrorPage("Information non accessible. Le Profil de Santé de ce patient est privé");
            }
        }
        return false;
    }

    /**
     * 
     * Corre a diario y actualiza la edad del paciente. info que utilziamos luego para perfil pediatrico
     */
    public function cronActualizarEdad() {

        $this->db->Execute("UPDATE paciente p 
                                SET p.edad_anio = (YEAR (CURDATE()) - YEAR (p.fechaNacimiento) - IF (MONTH (CURDATE()) < MONTH (p.fechaNacimiento), 1,IF (MONTH (CURDATE()) = MONTH (p.fechaNacimiento), IF (	DAY (CURDATE()) < DAY (p.fechaNacimiento),	1,	0), 0))),
                                    p.edad_mes = (MONTH (CURDATE()) - MONTH (p.fechaNacimiento) + 12 * IF (MONTH (CURDATE()) < MONTH (p.fechaNacimiento),	1,IF (MONTH (CURDATE()) = MONTH (p.fechaNacimiento),IF (DAY (CURDATE()) < DAY (p.fechaNacimiento),	1,	0), 0)) -IF (	MONTH (CURDATE()) <> MONTH (p.fechaNacimiento),	(DAY (CURDATE()) < DAY (p.fechaNacimiento)),IF (	DAY (CURDATE()) < DAY (p.fechaNacimiento),	1,	0))),
                                    p.edad_dia = (DAY (CURDATE()) - DAY (p.fechaNacimiento) + 30 * (DAY (CURDATE()) < DAY (p.fechaNacimiento)	))
                                WHERE
                                    p.fechaNacimiento IS NOT NULL
                                    AND p.fechaNacimiento <> '0000-00-00'");
    }

    /**
     * Método que realiza la actualización de la edad del paciente
     * @param type $idpaciente
     * @return type
     */
    public function actualizarEdadPaciente($idpaciente) {
        return $this->db->Execute("UPDATE paciente p 
                                SET p.edad_anio = (YEAR (CURDATE()) - YEAR (p.fechaNacimiento) - IF (MONTH (CURDATE()) < MONTH (p.fechaNacimiento), 1,IF (MONTH (CURDATE()) = MONTH (p.fechaNacimiento), IF (	DAY (CURDATE()) < DAY (p.fechaNacimiento),	1,	0), 0))),
                                    p.edad_mes = (MONTH (CURDATE()) - MONTH (p.fechaNacimiento) + 12 * IF (MONTH (CURDATE()) < MONTH (p.fechaNacimiento),	1,IF (MONTH (CURDATE()) = MONTH (p.fechaNacimiento),IF (DAY (CURDATE()) < DAY (p.fechaNacimiento),	1,	0), 0)) -IF (	MONTH (CURDATE()) <> MONTH (p.fechaNacimiento),	(DAY (CURDATE()) < DAY (p.fechaNacimiento)),IF (	DAY (CURDATE()) < DAY (p.fechaNacimiento),	1,	0))),
                                    p.edad_dia = (DAY (CURDATE()) - DAY (p.fechaNacimiento) + 30 * (DAY (CURDATE()) < DAY (p.fechaNacimiento)	))
                                WHERE
                                    p.fechaNacimiento IS NOT NULL
                                    AND p.fechaNacimiento <> '0000-00-00'
                                    AND p.idpaciente = $idpaciente");
    }

    /**
     * Método que retorna el combo box con los profesionales frecuentes pertenecientes a un pacientes
     * @param type $idpaciente
     * @return type
     */
    public function getComboProfesionalesFrecuentes($idpaciente) {

        $query = new AbstractSql();

        $query->setSelect("t.medico_idmedico, CONCAT(uw.nombre, ' ', uw.apellido) ");

        $query->setFrom("profesionalesfrecuentes_pacientes t 
                                INNER JOIN medico m ON (t.medico_idmedico = m.idmedico)
                                INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                     ");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->setGroupBy("t.medico_idmedico");

        $query->setOrderBy("uw.apellido DESC");

        return $this->getComboBox($query, false);
    }

    /**
     * Método para cambiar la privacidad 
     * @param type $request
     */
    public function changePrivacidad($request) {

        if (isset($request["idpaciente"]) && $request["idpaciente"] != "") {
            $idpaciente = $request["idpaciente"];
        } else {
            $paciente = $this->getPacienteXHeader();
            $idpaciente = $paciente["idpaciente"];
        }

        // <-- LOG
        $log["data"] = "Health information accessibility for Professionals";
        $log["page"] = "Home page (connected)";
        $log["action"] = "val"; //"val" "vis" "del"
        $log["purpose"] = "Privacy settings";

        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);
        //


        /* verifico que el paciente proveniente en el request sea familiar del paciente logueado */
        $idpacienteTitular = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];

        if ($idpaciente != $idpacienteTitular) {
            $familiar = $this->getManager("ManagerPacienteGrupoFamiliar")->getPacienteGrupoFamiliar($idpaciente, $idpacienteTitular);
            if ($familiar["idpacienteGrupoFamiliar"] == "") {
                $this->setMsg(["msg" => "Error. No se pudo recuperar el usuario seleccionado", "result" => false]);
                return false;
            }
        }

        //actualizo la privacidad en el paciente

        if (isset($request["perfil-privado"])) {
            $update = array(
                "privacidad_perfil_salud" => $request["perfil-privado"]
            );
            $rdo = parent::update($update, $idpaciente);
            if (!$rdo) {
                $this->setMsg(["msg" => "Error. No se pudo actualizar la información del usuario seleccionado", "result" => false]);
                return false;
            } else {
                $this->setMsg(["msg" => "Se actualizó la privacidad del perfil de salud", "result" => true, "id" => $rdo]);
                return $rdo;
            }
        }
    }

    /**
     * Méotodo que retorna la información del menú del paciente.
     * @param type $idpaciente
     * @return type
     */
    public function getInfoMenu($idpaciente = null) {

        if (is_null($idpaciente)) {
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->getPacienteXHeader();
            $idpaciente = $paciente["idpaciente"];
        }
        $array = array();


        $ManagerNotificacion = $this->getManager("ManagerNotificacion");

        $array["cantidad_notificaciones"] = $ManagerNotificacion->getCantidadNotificacionesPaciente($idpaciente);

        $array["cantidad_controles_chequeos"] = $ManagerNotificacion->getCantidadControlesChequeos($idpaciente);

        return $array;
    }

    /*     * Metodo que devuelve el mail de un paciente ya sea titular o miembro del grupo familiar
     * 
     * @param type $idpaciente
     * @return type
     */

    public function getPacienteEmail($idpaciente) {

        $paciente = $this->get($idpaciente);

        if ($paciente["email"] == "") {

            $relaciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $paciente["idpaciente"]);
            if ($relaciongrupo["pacienteTitular"] != "") {
                //Traigo la informacion del paciente titular
                $titular = $this->get($relaciongrupo["pacienteTitular"]);
                return $titular["email"];
            }
        } else {
            return $paciente["email"];
        }
    }

    /*     * Metodo que devuelve el numero de telefono de un paciente ya sea titular o miembro del grupo familiar
     * 
     * @param type $idpaciente
     * @return type
     */

    public function getPacienteTelefono($idpaciente) {

        $paciente = $this->get($idpaciente);

        if ($paciente["numeroCelular"] == "") {

            $relaciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $paciente["idpaciente"]);
            if ($relaciongrupo["pacienteTitular"] != "") {
                //Traigo la informacion del paciente titular
                $titular = $this->get($relaciongrupo["pacienteTitular"]);
                return $titular["numeroCelular"];
            }
        } else {
            return $paciente["numeroCelular"];
        }
    }

    /**
     * Metodo que retorna un Array encodado en formato JSON para el autossugest de los medicamentos
     * @param type $request
     * @return type
     */
    public function getAutosuggestAgregarMiembro($request) {

        $queryStr = cleanQuery($request["query"]);

        $query = new AbstractSql();

        $query->setSelect("p.$this->id  AS data ,
                                    CONCAT(u.nombre, ' ', u.apellido, ' - ', u.email) AS value,
                                    u.email as email,
                                    u.nombre as nombre, 
                                    u.apellido as apellido, 
                                    DATE_FORMAT( p.fechaNacimiento , '%d/%m/%Y' ) as fechaNacimiento,
                                    p.numeroCelular as numeroCelular
                    ");

        $query->setFrom("paciente p
                            INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb) 
                            ");

        $query->setWhere("CONCAT(u.nombre , ' ', u.apellido, ' - ', u.email) LIKE '%$queryStr%'");

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        $query->addAnd("p.$this->id NOT IN (SELECT paciente_idpaciente
                                                FROM medicomispacientes
                                                WHERE medico_idmedico = $idmedico
                                            )");

        $query->addAnd("p.active = 1");

        $data = array(
            "query" => $request["query"],
            "suggestions" => $this->getList($query, false)
        );

        return json_encode($data);
    }

    /**
     * Método utilizado para guardar la imagen cortada por el usuario.
     * Utiliza la librería de jQuery "Cropper"
     * @param type $request
     * @return boolean
     */
    public function cropAndChangeImage($request) {

        $paciente = $this->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];

        //Obtengo la imagen que voy a modificar.
        $image_to_copy = path_entity_files("pacientes/$idpaciente/{$idpaciente}_copy.jpg");
        $image = path_entity_files("pacientes/$idpaciente/$idpaciente.jpg");

        if (file_exists($image) && (int) $idpaciente > 0) {
            $manImg = new Images();

            $grados = (float) $request["grado"] >= 0 ? (float) $request["grado"] : 360 + (float) $request["grado"];

            $grados = 360 - $grados;

            $rdo = $manImg->resizeCropImg($image, $image_to_copy, $request["width"], $request["height"], $request["left"], $request["top"], $grados, 100);

            if ($rdo) {

                $modify = $this->modifyImgResizeThumb($image_to_copy, $idpaciente);

                rename($image_to_copy, $image);

                $modificar_cabecera = $paciente["usuarioweb_idusuarioweb"] != "" ? true : false;
                if ($modify) {


                    $this->setMsg(["msg" => "Se modificó la imagen", "result" => true, "imgs" => $this->getImagenPaciente($idpaciente), "modificar_cabecera" => $modificar_cabecera]);
                    return $idpaciente;
                } else {
                    $this->setMsg(["msg" => "Error, no se pudieron actualizar las imágenes del paciente", "result" => false]);
                    return false;
                }
            } else {
                $this->setMsg(["msg" => "Error, no se pudo procesar la imagen seleccionada", "result" => false]);
                return false;
            }
        }
        $this->setMsg(["msg" => "Error, no se encontró la imagen seleccionada", "result" => false]);
        return false;
    }

    /**
     * Mëtodo utilizado para realizar el crop de la imagen sobre el hash
     * @param type $request
     * @return boolean
     */
    public function cropAndChangeImageHash($request) {
        $hash = $request["hash"];
        //Obtengo la imagen que voy a modificar.
        $image_to_copy = PATH_ROOT . "/xframework/files/temp/images/{$hash}_copy.jpg";
        $image = PATH_ROOT . "/xframework/files/temp/images/{$hash}.jpg";

        if (file_exists($image) && $hash != "") {
            $manImg = new Images();

            $grados = (float) $request["grado"] >= 0 ? (float) $request["grado"] : 360 + (float) $request["grado"];

            $grados = 360 - $grados;

            $rdo = $manImg->resizeCropImg($image, $image_to_copy, $request["width"], $request["height"], $request["left"], $request["top"], $grados, 100);

            if ($rdo) {

                rename($image_to_copy, $image);


                $this->setMsg(["msg" => "Se modificó la imagen", "result" => true, "imgs" => URL_ROOT . "xframework/files/temp/images/{$hash}.jpg", "modificar_cabecera" => false]);
                return true;
            } else {
                $this->setMsg(["msg" => "Error, no se pudo procesar la imagen seleccionada", "result" => false]);
                return false;
            }
        }
        $this->setMsg(["msg" => "Error, no se encontró la imagen seleccionada", "result" => false]);
        return false;
    }

    /**
     * Mpétodo que retorna los pacientes relacionados pertenecientes a un $idpaciente recibido como parámetro
     * @param type $idpaciente
     * @return boolean
     */
    public function getPacientesRelacionados($idpaciente) {

        $paciente = $this->get($idpaciente);

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        if ($paciente["usuarioweb_idusuarioweb"] != "") {
            //Es un paciente titular
            $query = new AbstractSql();

            $query->setSelect("p.idpaciente,pg.nombre, pg.apellido, DATE_FORMAT(p.fechaNacimiento,'%d/%m/%Y') as fechaNacimiento_format, mmp.idmedicoMedicosMisPacientes, mpi.idmedico_paciente_invitacion");

            $query->setFrom("paciente p 
                                    INNER JOIN pacientegrupofamiliar pg ON (p.idpaciente = pg.pacienteGrupo)
                                    LEFT JOIN medicomispacientes mmp ON (p.idpaciente = mmp.paciente_idpaciente AND mmp.medico_idmedico = $idmedico)
                                    LEFT JOIN medico_paciente_invitacion mpi ON (p.idpaciente = mpi.paciente_idpaciente AND mpi.medico_idmedico = $idmedico)
                        ");

            $query->setWhere("pg.pacienteTitular = $idpaciente ");
        } else {
            //NO es paciente titular
            $ManagerPacienteGrupoFamiliar = $this->getManager("ManagerPacienteGrupoFamiliar");
            //Obtengo el paciente para sacar el paciente titular
            $paciente_grupo = $ManagerPacienteGrupoFamiliar->getByField("pacienteGrupo", $idpaciente);
            $query = new AbstractSql();

            $query->setSelect("t.idpaciente,t.nombre, t.apellido, DATE_FORMAT(t.fechaNacimiento,'%d/%m/%Y') as fechaNacimiento_format,  t.idmedicoMedicosMisPacientes, t.idmedico_paciente_invitacion");

            $query->setFrom("
                    ((
                            SELECT p.idpaciente,pg.nombre, pg.apellido, p.fechaNacimiento,  mmp.idmedicoMedicosMisPacientes, mpi.idmedico_paciente_invitacion
                            FROM paciente p 
                                        INNER JOIN pacientegrupofamiliar pg ON (p.idpaciente = pg.pacienteGrupo)
                                        LEFT JOIN medicomispacientes mmp ON (p.idpaciente = mmp.paciente_idpaciente AND mmp.medico_idmedico = $idmedico)
                                        LEFT JOIN medico_paciente_invitacion mpi ON (pg.pacienteGrupo = mpi.paciente_idpaciente AND mpi.medico_idmedico = $idmedico)
                            WHERE pg.pacienteTitular = " . $paciente_grupo["pacienteTitular"] . " AND pg.pacienteGrupo <> $idpaciente
                    ) UNION
                    (
                            SELECT p.idpaciente,uw.nombre, uw.apellido, p.fechaNacimiento, mmp.idmedicoMedicosMisPacientes, mpi.idmedico_paciente_invitacion
                            FROM paciente p 
                                        INNER JOIN usuarioweb uw ON (p.usuarioweb_idusuarioweb = uw.idusuarioweb and uw.registrado=1)
                                        LEFT JOIN medicomispacientes mmp ON (p.idpaciente = mmp.paciente_idpaciente AND mmp.medico_idmedico = $idmedico)
                                        LEFT JOIN medico_paciente_invitacion mpi ON (p.idpaciente = mpi.paciente_idpaciente AND mpi.medico_idmedico = $idmedico )
                            WHERE p.idpaciente = " . $paciente_grupo["pacienteTitular"] . "
                    )) as t       
                ");
        }

        $listado = $this->getList($query);

        if ($listado && count($listado) > 0) {
            //Tengo que obtener las imágenes de los pacientes
            foreach ($listado as $key => $paciente) {
                $listado[$key]["imagenes"] = $this->getImagenPaciente($paciente[$this->id]);
            }
            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Listado paginado a mis pacientes. Solamente los pacientes que poseen cuenta en DP
     * @param array $request
     * @param type $idpaginate
     */
    public function getListadoPaginadoAllPacientesDP($request, $idpaginate = null) {

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10);
        }

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("t1.*");

        $query->setFrom("(( SELECT u.nombre,
                                        u.apellido,
                                        p.fechaNacimiento,
                                        p.estado,
                                        p.active, 
                                        p.numeroCelular,
                                        u.sexo,
                                        0 as animal,
                                        p.idpaciente, 
                                        u.email,
                                        p.DNI,
                                        p.tarjeta_vitale,
                                        p.tarjeta_cns,
                                        p.tarjeta_eID,
                                        p.tarjeta_pasaporte,
                                        p.trabaja_otro_pais,
                                        p.pais_idpais,
                                        p.pais_idpais_trabajo,
                                        p.beneficios_reintegro,
                                        p.beneficia_ald,
                                        p.codigoValidacionCelular,
                                        p.celularValido,
                                        p.usuarioweb_idusuarioweb,
                                        p.edad,
                                        p.edad_anio, 
                                        p.edad_mes,
                                        p.edad_dia, 
                                        p.privacidad_perfil_salud,
                                        '' as relacionGrupo_idrelacionGrupo
                            FROM paciente p
                                INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb and u.registrado=1) 
                              ) 
                              UNION 
                            ( SELECT pf.nombre, 
                            pf.apellido, 
                            p.fechaNacimiento,
                            p.estado, 
                            p.active,
                            IFNULL(p.numeroCelular,p_tit.numeroCelular) as numeroCelular, 
                            pf.sexo, 
                            pf.animal,
                            p.idpaciente, 
                            '' as email,
                            pf.DNI,
                            pf.tarjeta_vitale,
                            pf.tarjeta_cns,
                            pf.tarjeta_eID,
                            pf.tarjeta_pasaporte,
                            pf.trabaja_otro_pais,
                            pf.pais_idpais,
                            '' as pais_idpais_trabajo,
                            '' as beneficios_reintegro,
                            p.beneficia_ald,
                            p.codigoValidacionCelular,
                            p.celularValido, 
                            '' as usuarioweb_idusuarioweb, 
                            p.edad,
                            p.edad_anio, 
                            p.edad_mes,
                            p.edad_dia, 
                            p.privacidad_perfil_salud,
                            pf.relacionGrupo_idrelacionGrupo
                              FROM paciente p 
                                INNER JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo) 
                                INNER JOIN paciente p_tit ON (p_tit.idpaciente = pf.pacienteTitular) 
                            )) as t1
                        ");


        //El ID del paciente no tiene que estar en la tabla de mis pacientes y de invitación
        $query->addAnd("t1.idpaciente NOT IN (SELECT t.paciente_idpaciente
                                                FROM medicomispacientes t
                                                WHERE t.medico_idmedico = $idmedico
                                            )");

        $query->addAnd("t1.idpaciente NOT IN (SELECT mpi.paciente_idpaciente
                                                FROM medico_paciente_invitacion mpi
                                                WHERE mpi.medico_idmedico = $idmedico 
                                                    AND mpi.paciente_idpaciente IS NOT NULL
                                                    AND mpi.estado = 0
                                            )");

        if (isset($request["query_str"]) && $request["query_str"] != "") {
            $rdo = cleanQuery($request["query_str"]);
            $query->addAnd("(t1.DNI ='$rdo' OR t1.email LIKE '%$rdo%' OR CONCAT(t1.nombre, ' ', t1.apellido) LIKE '%$rdo%')");
        }

        $query->setOrderBy("t1.apellido ASC");

        $listado = $this->getListPaginado($query, $idpaginate);


        if ($listado["rows"] && count($listado["rows"]) > 0) {

            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerProfesionalesFrecuentesPacientes = $this->getManager("ManagerProfesionalesFrecuentesPacientes");


            $calendar = new Calendar();

            foreach ($listado["rows"] as $key => $value) {

                //Tengo que formatear la fecha si es una invitación..
                if ($value["ultimoenvio"] != "") {
                    list($y, $m, $d) = preg_split("[-]", $value["ultimoenvio"]);
                    $mes = $calendar->getMonthsShort((int) $m);
                    $listado["rows"][$key]["ultimoenvio_format"] = "$d $mes $y";
                }

                //Traigo las imágenes de los pacientes
                $listado["rows"][$key]["imagenes"] = $ManagerPaciente->getImagenPaciente($value["idpaciente"]);


                //Debo buscar todos los pacientes relacionados del paciente.
                $listado["rows"][$key]["pacientes_relacionados"] = $ManagerPaciente->getPacientesRelacionados($value["idpaciente"]);

                //Si no es un paciente perteneciente a una invitación
                if ($value["estado_solicitud"] === "") {

                    //Tengo que buscar todos los profesionales frecuentes..
                    $listado["rows"][$key]["medicos_relacionados"] = $ManagerProfesionalesFrecuentesPacientes->getListadoProfesionalesFrecuentesPaciente($value["idpaciente"], $idmedico);
                }

                //Tengo que buscar la información completa del paciente
            }
            return $listado;
        }
    }

    /*     * Metodo que retorna un listado de pacientes a partir de la busqueda por DNI o nombre
     * 
     * @param type $request
     * @return boolean
     */

    public function getListadoPacientesDP($request) {

        $query = new AbstractSql();

        $query->setSelect("t1.*");

        $query->setFrom("(( SELECT u.nombre, u.apellido, p.fechaNacimiento, p.estado, p.active, p.numeroCelular, u.sexo, p.idpaciente, u.email, p.DNI, p.codigoValidacionCelular, p.celularValido, p.usuarioweb_idusuarioweb, p.edad, p.edad_anio, p.edad_mes, p.edad_dia, p.privacidad_perfil_salud, '' as relacionGrupo_idrelacionGrupo
                            FROM paciente p
                                INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb and u.registrado=1) 
                              ) 
                              UNION 
                            ( SELECT pf.nombre, pf.apellido, p.fechaNacimiento, p.estado, p.active,IFNULL(p.numeroCelular,p_tit.numeroCelular) as numeroCelular, pf.sexo, p.idpaciente, '' as email, pf.DNI, p.codigoValidacionCelular, p.celularValido, '' as usuarioweb_idusuarioweb, p.edad, p.edad_anio, p.edad_mes, p.edad_dia, p.privacidad_perfil_salud, pf.relacionGrupo_idrelacionGrupo
                              FROM paciente p 
                                INNER JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo) 
                                INNER JOIN paciente p_tit ON (p_tit.idpaciente = pf.pacienteTitular) 
                            )) as t1
                        ");

        $paramsBind = [];



        if (isset($request["query_str"]) && $request["query_str"] != "") {
            //bindeo de parametros, para evitar sql injection
            $query_str = cleanQuery($request["query_str"]);
            $paramsBind[] = "%" . $query_str . "%";

            $paramsBind[] = "%" . $query_str . "%";
            $query->addAnd("(t1.DNI LIKE ?  OR CONCAT(t1.nombre, ' ', t1.apellido) LIKE ?)");
        }


        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'] != "" && $request["idconsultorio"] != "") {

            $prestador = $this->getManager("ManagerPrestador")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador']);
            $consultorio = $this->getManager("ManagerConsultorio")->get($request["idconsultorio"]);
            if ($consultorio["is_virtual"] == 1) {
                if ($prestador["pacientesVideoConsultaTurno"] == 2) {

                    $query->addAnd("t1.idpaciente in (select paciente_idpaciente from paciente_prestador where paciente_idpaciente is not null and prestador_idprestador={$_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador']})");
                }
            } else {
                if ($prestador["pacientesTurno"] == 2) {

                    $query->addAnd("t1.idpaciente in (select paciente_idpaciente from paciente_prestador where paciente_idpaciente is not null and prestador_idprestador={$_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador']})");
                }
            }
        }

        $query->setOrderBy("t1.nombre ASC");

        $listado = $this->getList($query, null, null, $paramsBind);


        if ($listado && count($listado) > 0) {

            foreach ($listado as $key => $value) {

                //Traigo las imágenes de los pacientes
                $listado[$key]["imagen"] = $this->getImagenPaciente($value["idpaciente"]);
                $listado[$key]["email"] = $this->getPacienteEmail($value["idpaciente"]);
            }


            return $listado;
        } else {
            return false;
        }
    }

    /**
     * 
     * Corre a diario y reenvia la invitacion de medico a paciente
     */
    public function cronReenviarInvitacionPaciente() {

        $query = new AbstractSql();
        $query->setSelect("DATEDIFF(SYSDATE(),t.ultimoenvio) as diferenciaDias, t.*");
        $query->setFrom("medico_paciente_invitacion t");
        $query->setWhere("t.estado=0 and paciente_idpaciente is null and t.reintentos<=3");
        $query->setLimit("0,20");

        $invitaciones_pacientes = $this->getList($query);
        $ManagerMedicoPacienteInvitacion = $this->getManager("ManagerMedicoPacienteInvitacion");
        foreach ($invitaciones_pacientes as $invitacion) {



            if ($invitacion["diferenciaDias"] >= 3 && $invitacion["reintentos"] < 3) {
                if ($invitacion["email"] != "") {

                    $envioEmail = $ManagerMedicoPacienteInvitacion->enviarEmailInvitacion($invitacion);
                }
                if ($invitacion["celular"] != "") {

                    $envioSMS = $ManagerMedicoPacienteInvitacion->sendSMSInvitacion($invitacion);
                }
                $record["ultimoenvio"] = date("Y-m-d H:i:s");
                $record["reintentos"] = (int) $invitacion["reintentos"] + 1;
                $ManagerMedicoPacienteInvitacion->update($record, $invitacion["idmedico_paciente_invitacion"]);
            }
            if ($invitacion["diferenciaDias"] == 7 && $invitacion["reintentos"] == 3) {
                if ($invitacion["email"] != "") {
                    $envioEmail = $ManagerMedicoPacienteInvitacion->enviarEmailInvitacion($invitacion);
                }

                if ($invitacion["celular"] != "") {
                    $envioSMS = $ManagerMedicoPacienteInvitacion->sendSMSInvitacion($invitacion);
                }

                $record["ultimoenvio"] = date("Y-m-d H:i:s");
                $record["reintentos"] = (int) $invitacion["reintentos"] + 1;
                $ManagerMedicoPacienteInvitacion->update($record, $invitacion["idmedico_paciente_invitacion"]);
            }
        }
    }

    /*     * Metodo que envia un  email a una direccion alternativa de paciente cuando se cambia el mail con el codigo de validacion
     * de la nueva direccion.
     * 
     * @param type $request
     */

    public function enviarMailCodigoValidacionEmail() {


        $idpaciente = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];


        $paciente = $this->get($idpaciente, true);



        if ($paciente["cambioEmail"] == "") {
            $this->setMsg(["msg" => "Error al recuperar email del paciente", "result" => false]);
            return false;
        }

        $caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        $numerodeletras = 5;


        for ($i = 0; $i < $numerodeletras; $i++) {
            $cuerpo .= substr($caracteres, rand(0, strlen($caracteres)), 1); /* Extraemos 1 caracter de los caracteres 
              entre el rango 0 a Numero de letras que tiene la cadena */
        }

        //Actualizo el código de validación de celular
        $id = parent::update(array("codigoValidacionEmail" => $cuerpo), $paciente["idpaciente"]);

        if ($id) {

//envio del codigo por mail

            $smarty = SmartySingleton::getInstance();

            $smarty->assign("paciente", $paciente);
            $smarty->assign("codigoValidacionEmail", $cuerpo);


            $mEmail = $this->getManager("ManagerMail");
            $mEmail->setHTML(true);

            //ojo solo arnet local
            $mEmail->setPort("587");

            $mEmail->setSubject(sprintf("WorknCare | Code de validation de compte de messagerie"));

            $mEmail->setBody($smarty->Fetch("email/paciente_cambio_email.tpl"));

            $email = $paciente["cambioEmail"];
            $mEmail->addTo($email);



            if ($mEmail->send()) {
                $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
                return true;
            } else {
                $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * Chequeo del número que ingresó el paciente para la validacion del nuevo mail
     * @param type $request
     * @return boolean
     */
    public function checkValidacionEmail($request) {
        $idpaciente = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];
        $paciente = $this->get($idpaciente);

        $request["codigoValidacionEmail"] = strtoupper(trim($request["codigoValidacionEmail"]));
        if (($request["codigoValidacionEmail"] == $paciente["codigoValidacionEmail"]) && ($request["codigoValidacionEmail"] != "")) {
            $this->db->StartTrans();
            $rdo = $this->getManager("ManagerUsuarioWeb")->basic_update(["email" => $paciente["cambioEmail"]], $paciente["usuarioweb_idusuarioweb"]);
            $rdo1 = parent::update(array("codigoValidacionEmail" => "", "cambioEmail" => ""), $idpaciente);

            if ($rdo && $rdo1) {
                $this->setMsg(["msg" => "El email ha sido validado", "result" => true]);
                $this->db->CompleteTrans();
                return true;
            } else {
                $this->setMsg(["msg" => "No se pudo validar el codigo", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        } else {
            $this->setMsg(["msg" => "El código de validación no es válido", "result" => false]);

            return false;
        }
    }

    /* Metodo que realiza la actualizacion de los campos de email y numero de celular en la configuracion de administracion del paciente
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function updateCelularEmail($request, $idpaciente) {

        if ((int) $idpaciente != (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"] && CONTROLLER == "paciente_p") {
            $this->setMsg(["msg" => "Se produjo un error", "result" => false]);
            return false;
        }

        $paciente = $this->get($idpaciente);

        $this->db->StartTrans();
        $result = true;

        //Verificamos si cambio el mail

        $managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");
        $usuario = $managerUsuarioWeb->get($paciente["usuarioweb_idusuarioweb"]);
        $EmailValidado = 1;
        if ($request["email"] != "" && $request["email"] != $usuario["email"]) {

            //valido descripcion unica Email
            if (!$managerUsuarioWeb->validateUnique("email", $request["email"])) {

                $this->setMsg(["msg" => "La cuenta, [[{$request["email"]}]] ya se encuentra registrada", "result" => false, "field" => "email"]);

                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }



            $id = parent::update(["cambioEmail" => $request["email"]], $idpaciente);
            $mail = $this->enviarMailCodigoValidacionEmail();
            $EmailValidado = 0;
            //Si hubo un problema al momento de cambiar el mail
            if (!$id) {
                $result = false;
                $this->db->FailTrans();
                $this->db->CompleteTrans();
            }
        }



        //Si el número de celular es modificado, se setea celular válido como 0
        $validado = $paciente["celularValido"];

        if (isset($request["numeroCelular"]) && $request["numeroCelular"] != "" && $paciente["numeroCelular"] != $request["numeroCelular"]) {
            $validado = $fields["celularValido"] = 0;
            $fields["codigoValidacionCelular"] = "";
            $fields["numeroCelular"] = str_replace(" ", "", $request["numeroCelular"]);
            $fields["numeroCelular"] = str_replace("-", "", $fields["numeroCelular"]);

            $id = parent::update($fields, $idpaciente);
            $sms = $this->sendSMSValidacion();
            if (!$id) {
                $result = false;
                $this->db->FailTrans();
                $this->db->CompleteTrans();
            }
        }




        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($result) {

            // <-- LOG
            $log["data"] = "email, celular";
            $log["usertype"] = "Patient";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["page"] = "Account settings";
            $log["purpose"] = "Update User log-in dat";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);

            // <--       
            //   
            //si ingresa el mismo numero y no esta validado le recuero que debe validarlo
            if ($paciente["numeroCelular"] == $request["numeroCelular"] && $paciente["celularValido"] == "0") {
                $revalidar_cel = 1;
            }

            $this->setMsg(["msg" => "Se modificaron sus datos con éxito", "result" => true, "celularValido" => $validado, "emailValido" => $EmailValidado, "revalidar_cel" => $revalidar_cel]);

            $this->db->CompleteTrans();
            return $id;
        } else {
            $this->setMsg(["result" => false, "msg" => "Se produjo un error al modificar sus datos"]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }




        $this->db->CompleteTrans();
        return $idpaciente;
    }

    /**
     * Metodo que setea la configuracion de cobertura y facturacion del paciente mediante el wizzar inicial
     * @param type $request
     */
    public function configurar_cobertura_factuacion_inicial($request) {

        if ($request["idpaciente"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar el paciente"]);
            return false;
        }
        if ($request["step"] == "") {
            $this->setMsg(["result" => false, "msg" => "No se ha podido actualizar la información"]);
            return false;
        }

        //verificamos en que paso se encuentra
        switch ($request["step"]) {
            case 1;
                //Afeccion
                if ($request["beneficia_ald"] == "") {
                    $this->setMsg(["result" => false, "msg" => "Complete los datos obligatorios"]);
                    return false;
                }
                if ($request["beneficia_ald"] == 1) {


                    if (isset($request["afeccion_idafeccion"]) && $request["afeccion_idafeccion"] != "") {
                        //Creo la obra social asociada al paciente del grupo
                        $managerAfeccionPaciente = $this->getManager("ManagerAfeccionPaciente");
                        $datos_afeccion = array(
                            "paciente_idpaciente" => $request["idpaciente"],
                            "afeccion_idafeccion" => $request["afeccion_idafeccion"]
                        );

                        $afeccion_paciente = $managerAfeccionPaciente->getByField("paciente_idpaciente", $request["idpaciente"]);

                        if ($afeccion_paciente) {
                            $afeccion = $managerAfeccionPaciente->update($datos_afeccion, $afeccion_paciente["idafeccion_paciente"]);
                        } else {
                            $afeccion = $managerAfeccionPaciente->insert($datos_afeccion);
                        }
                        if (!$afeccion) {
                            //Falla la transacción
                            $this->setMsg(["result" => false, "msg" => "Se produjo un error con los datos de la afección."]);
                            return false;
                        }
                    } else {
                        $this->setMsg(["result" => false, "msg" => "Error. Seleccione la afección de largo plazo que posee"]);
                        return false;
                    }
                }
                $record["beneficia_ald"] = $request["beneficia_ald"];
                break;
            case 2:
                //Exempcion
                if ($request["beneficia_exempcion"] == "") {
                    $this->setMsg(["result" => false, "msg" => "Complete los datos obligatorios"]);
                    return false;
                }
                $record["beneficia_exempcion"] = $request["beneficia_exempcion"];
                break;

            case 3:
                //obra social
                if ($request["posee_cobertura"] == 1) {
                    if (isset($request["idobraSocial"]) && $request["idobraSocial"] != "") {
                        //Creo la obra social asociada al paciente del grupo
                        $managerObraSocialPaciente = $this->getManager("ManagerObraSocialPaciente");
                        $update_obra_social = array(
                            "paciente_idpaciente" => $request["idpaciente"],
                            "obraSocial_idobraSocial" => $request["idobraSocial"],
                        );

                        $obra_social_paciente = $managerObraSocialPaciente->get($request["idpaciente"]);

                        if ($obra_social_paciente) {
                            $idobraSocial = $managerObraSocialPaciente->update($update_obra_social, $obra_social_paciente["idobraSocialPaciente"]);
                        } else {
                            $idobraSocial = $managerObraSocialPaciente->insert($update_obra_social);
                        }
                        if (!$idobraSocial) {
                            //Falla la transacción
                            $this->setMsg(["result" => false, "msg" => "Se produjo un error con los datos de la  cobertura médica. Verifique los datos cargados."]);
                            return false;
                        }
                    } else {

                        $this->setMsg(["result" => false, "msg" => "Error. No ingresó los datos de la cobertura médica"]);
                        return false;
                    }
                }
                $record["posee_cobertura"] = $request["posee_cobertura"];
                break;
            case 4:

                //Medico cabeza
                if ($request["medico_cabeza"] == "") {
                    $this->setMsg(["result" => false, "msg" => "Complete los datos obligatorios"]);
                    return false;
                }
                $record["medico_cabeza"] = $request["medico_cabeza"];
                $record["medico_cabeza_externo"] = $request["medico_cabeza_externo"];
                break;
        }
        $record["cobertura_facturacion_step"] = $request["step"];
        $result = parent::update($record, $request["idpaciente"]);

        // <-- LOG
        $log["data"] = "Data wizzard French residents (ALD, CMU-C, medecin traitant, complementaire)";
        $log["action"] = "val"; //"val" "vis" "del"
        $log["page"] = "Home page (connected)";
        $log["purpose"] = "Complete Personal information";

        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);

        // <--        

        return $result;
    }

    /**
     * Metodo que seate el flag para ocultar el teaser promocional de la home de paciente
     * @param type $request
     * @return type
     */
    public function no_mostrar_teaser_home($request) {
        return parent::update(["teaser_home_paciente" => 0], $request["idpaciente"]);
    }

    /**
     * Metodo que seate el flag para ocultar el teaser promocional de la home de paciente
     * @param type $request
     * @return type
     */
    public function no_completar_perfil_salud_home() {
        return parent::update(["cobertura_facturacion_step" => 4, "no_completar_ps_home" => 1], $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
    }

    /**
     * Método que elimina los archivos subidos en el registro del paciente
     * @param type $idpaciente
     * @param type $file
     */
    public function deleteFiles($idpaciente, $file) {
        if (CONTROLLER != "xadmin") {
            return false;
        }
        $path_dir = path_entity_files("pacientes/$idpaciente/");
        $deleted = false;
        if (file_exists($path_dir)) {
            $archivos = scandir($path_dir);

            foreach ($archivos as $i => $archivo) {

                if ($archivo == "." || $archivo == "..") {
                    unset($archivos[$i]);
                    continue;
                }
                //verificamos el nombre original del archivo encontrado -  no thumb
                if (strrpos($archivo, "{$file}.") !== false) {
                    $path_file = $path_dir . $archivo;
                    if (file_exists($path_file) && is_file($path_file)) {
                        unlink($path_file);
                        $deleted = true;
                    }
                }
            }
        }
        if ($deleted) {
            $this->setMsg(["msg" => "Archivo eliminado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No se pudo eliminar los archivos", "result  " => false]);
            return false;
        }
    }

    /**
     * Método que elimina los archivos subidos en el registro del paciente
     * @param type $idpaciente
     * @param type $file
     */
    public function uploadFiles($request) {
        if (CONTROLLER != "xadmin") {
            return false;
        }
        $uploaded = false;
        $hash = $request["hash"];
        $name = $request["name"];
        //CPS si es frances
        if ($_SESSION[$hash]["name"] == $name && $request["idpaciente"] != "") {
            //creamos el directorio si no existe
            if (!file_exists(path_entity_files($this->imgContainer . "/{$request["idpaciente"]}"))) {
                $dir = new Dir(path_entity_files($this->imgContainer . "/{$request["idpaciente"]}"));
                $dir->chmod(0777);
            }
            $file_ext = $_SESSION[$hash]["ext"];
            $file_path_temp = path_files("temp/" . $hash . "." . $file_ext);
            $path_file = path_entity_files("$this->imgContainer/{$request["idpaciente"]}/$name.{$file_ext}");
            $file_exist = file_exists($file_path_temp);
            $is_file = is_file($file_path_temp);
            if (!$file_exist || !$is_file) {
                $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                return false;
            } else {
                //copiamos el archivo a su ubicacion final
                copy($file_path_temp, $path_file);
                //comprobamos que se hayan movido
                if (!file_exists($path_file) || !is_file($path_file)) {
                    $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                    return false;
                }
                $uploaded = true;
            }
        }
        if ($uploaded) {
            $this->setMsg(["msg" => "Archivo subido con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result  " => false]);
            return false;
        }
    }

    /**
     * actualizo el estado de todos los pacientes asociados a esta empresa que paso a el plan gratuito
     * @param type $idempresa
     */
    public function actualizarExBeneficiarios($idempresa) {
        return $this->db->Execute("UPDATE paciente p INNER JOIN paciente_empresa pe ON (p.idpaciente=pe.paciente_idpaciente) SET beneficios_reintegro=0 WHERE pe.empresa_idempresa=$idempresa and pe.estado=1");
    }

}

//END_class