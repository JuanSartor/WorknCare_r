<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los pacientes que pertenecen a un grupo familiar
 *    No son usuarios web.
 *
 */
class ManagerPacienteGrupoFamiliar extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {
        $this->flag = "active";
        $this->setImgContainer("pacientes");
        $this->addImgType("jpg");
        $this->setFilters("img_pdf");
        $this->addThumbConfig(50, 50, "_perfil");
        $this->addThumbConfig(150, 150, "_usuario");
        $this->addThumbConfig(110, 110, "_list");
        // Llamamos al constructor del a superclase
        parent::__construct($db, "pacientegrupofamiliar", "idpacienteGrupoFamiliar");
    }

    public function insert($request) {



        //En primer lugar creo el paciente
        $managerPaciente = $this->getManager("ManagerPaciente");

        //Abro una transacción con la base de datos.
        $this->db->StartTrans();

        $request["fechaNacimiento"] = $this->sqlDate($request["fechaNacimiento"]);
        if ($request["animal"] != "1") {
            $calendar = new Calendar();
            $edad = $calendar->calculaEdad($request["fechaNacimiento"]);
            if ($edad > 18) {
                $this->setMsg(["msg" => "El paciente familiar no debe ser mayor de 18 años.", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }
        if ($request["animal"] == "1") {
            $request["privacidad_perfil_salud"] = 2;
        }

        $idpacienteGrupo = $managerPaciente->basic_insert($request);

        if (!$idpacienteGrupo) {
            //Falla la transacción
            $this->db->FailTrans();
            if ($request["animal"] != "1") {
                $this->setMsg(["result" => false, "msg" => "Se produjo un error al crear el paciente familiar. Intente más tarde."]);
            } else {
                $this->setMsg(["result" => false, "msg" => "Se produjo un error al crear la mascota. Intente más tarde."]);
            }

            $this->db->CompleteTrans();
            return false;
        }

        $managerPaciente->actualizarEdadPaciente($idpacienteGrupo);




        //OBtengo el id del paciente Titular.
        if ($request["alta_from_medico"] != 1) {
            $idpacienteTitular = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
        } else {
            $idpacienteTitular = $request["idpaciente_titular"];
        }


        if (isset($request["sexo"]) && $request["sexo"] == "on") {
            $request["sexo"] = 1;
        } else {
            $request["sexo"] = 0;
        }


        $record = array(
            "pacienteGrupo" => $idpacienteGrupo,
            "pacienteTitular" => $idpacienteTitular,
            "nombre" => $request["nombre"],
            "apellido" => $request["apellido"],
            "DNI" => $request["DNI"],
            "sexo" => $request["sexo"],
            "tipoDNI_idtipoDNI" => $request["tipoDNI_idtipoDNI"],
            "relacionGrupo_idrelacionGrupo" => $request["relacionGrupo_idrelacionGrupo"]
        );

        if ($request["animal"] == "1") {
            $record["tipo_animal"] = $request["tipo_animal"];
            $record["apellido"] = "({$request["tipo_animal"]})";
            $record["animal"] = 1;
        }

        $id = parent::insert($record);

        //Inserto un regisgtro en el perfil de salud status
        $idStatusPerfilSalud = $this->getManager("ManagerPerfilSaludStatus")->insert(["paciente_idpaciente" => $idpacienteGrupo]);


        if (!$id || !$idStatusPerfilSalud) {
            //Falla la transacción
            $this->db->FailTrans();
            if ($request["animal"] != "1") {
                $this->setMsg(["result" => false, "msg" => "Se produjo un error al crear el paciente familiar. Intente más tarde."]);
            } else {
                $this->setMsg(["result" => false, "msg" => "Se produjo un error al crear la mascota. Intente más tarde."]);
            }
            $this->db->CompleteTrans();
            return false;
        }
        if ($request["animal"] != "1") {
            //Genero los controles y chequeos
            $controles_chequeos = $this->getManager("ManagerNotificacion")->insertControlesChequeosPaciente($idpacienteGrupo, date("Y-m-d"));
        }
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
            $this->getManager("ManagerPacientePrestador")->insert(["paciente_idpaciente" => $idpacienteGrupo, "prestador_idprestador" => $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador']]);
        }

        /**
         * Si todo anduvo bien, voy a copiar las imágenes
         */
        $this->copyImagesFromPacientes($idpacienteGrupo);

        //verificamos que se haya cargado la imagen de identificacion
        //creamos el directorio si no existe
        if (!file_exists(path_entity_files($this->imgContainer . "/{$idpacienteGrupo}"))) {
            $dir = new Dir(path_entity_files($this->imgContainer . "/{$idpacienteGrupo}"));
            $dir->chmod(0777);
        }
        foreach ($request["hash"] as $hash) {

            if ($_SESSION[$hash]["name"] == "cns" && $_SESSION[$hash]["realName"] != "") {
                $cns_ext = $_SESSION[$hash]["ext"];
                $cns_path_temp = path_files("temp/" . $hash . "." . $cns_ext);
                $cns_path_file = path_entity_files("$this->imgContainer/{$idpacienteGrupo}/cns.{$cns_ext}");
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
        }
        //eliminamos los archivos temporales subidos
        foreach ($request["hash"] as $hash) {
            unlink(path_files("temp/" . $hash . "." . $_SESSION[$hash]["ext"]));
            unset($_SESSION[$hash]);
        }


        $this->db->CompleteTrans();
        if ($request["animal"] != "1") {
            $this->setMsg(["result" => true, "msg" => "Se registrado el paciente como parte del grupo familiar", "id" => $id, "idpaciente" => $idpacienteGrupo]);
        } else {
            $this->setMsg(["result" => true, "msg" => "Se registrado su mascota como parte del grupo familiar", "id" => $id, "idpaciente" => $idpacienteGrupo]);
        }
        // <-- LOG
        $log["data"] = "Surname, family name, birthday, gender, relationship with patient, Health profile accesibility for Professionals";
        $log["action"] = "val"; //"val" "vis" "del"
        $log["page"] = "Members (kids)";
        $log["purpose"] = "Add Member";

        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);

        // <--        

        return true;
    }

    public function update($request) {

        //En primer lugar creo el paciente
        $managerPaciente = $this->getManager("ManagerPaciente");

        //Abro una transacción con la base de datos.
        $this->db->StartTrans();



        $request["fechaNacimiento"] = $this->sqlDate($request["fechaNacimiento"]);

        if ($request["animal"] != "1") {
            $calendar = new Calendar();
            $edad = $calendar->calculaEdad($request["fechaNacimiento"]);
            if ($edad > 18) {
                $this->setMsg(["msg" => "El paciente familiar no debe ser mayor de 18 años.", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }
        $idpacienteGrupo = $managerPaciente->basic_update($request, $request["idpaciente"]);


        if (!$idpacienteGrupo) {
            //Falla la transacción
            $this->db->FailTrans();
            if ($request["animal"] != "1") {
                $this->setMsg(["result" => false, "msg" => "Se produjo un error al crear el paciente familiar. Intente más tarde."]);
            } else {
                $this->setMsg(["result" => false, "msg" => "Se produjo un error al crear la mascota. Intente más tarde."]);
            }
            $this->db->CompleteTrans();
            return false;
        }

        $managerPaciente->actualizarEdadPaciente($request["idpaciente"]);


        //OBtengo el id del paciente Titular.
        $idpacienteTitular = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];

        if (isset($request["sexo"]) && $request["sexo"] == "on") {
            $request["sexo"] = 1;
        } else {
            $request["sexo"] = 0;
        }

        $record = array(
            "pacienteGrupo" => $idpacienteGrupo,
            "pacienteTitular" => $idpacienteTitular,
            "nombre" => $request["nombre"],
            "apellido" => $request["apellido"],
            "DNI" => $request["DNI"],
            "sexo" => $request["sexo"],
            "tipoDNI_idtipoDNI" => $request["tipoDNI_idtipoDNI"],
            "relacionGrupo_idrelacionGrupo" => $request["relacionGrupo_idrelacionGrupo"]
        );

        if ($request["animal"] == "1") {
            $record["tipo_animal"] = $request["tipo_animal"];
            $record["apellido"] = "({$request["tipo_animal"]})";
            $record["animal"] = 1;
        }
        $paciente_grupo_familiar = $this->getPacienteGrupoFamiliar($idpacienteGrupo, $idpacienteTitular);

        if ($paciente_grupo_familiar) {

            $id = parent::update($record, $paciente_grupo_familiar["idpacienteGrupoFamiliar"]);
        } else {
            $id = false;
        }

        if (!$id) {
            //Falla la transacción
            $this->db->FailTrans();
            if ($request["animal"] != "1") {
                $this->setMsg(["result" => false, "msg" => "Se produjo un error al crear el paciente familiar. Intente más tarde."]);
            } else {
                $this->setMsg(["result" => false, "msg" => "Se produjo un error al crear la mascota. Intente más tarde."]);
            }
            $this->db->CompleteTrans();
            return false;
        }

        //verificamos que se haya cargado la imagen de identificacion
        //creamos el directorio si no existe
        if (!file_exists(path_entity_files($this->imgContainer . "/{$idpacienteGrupo}"))) {
            $dir = new Dir(path_entity_files($this->imgContainer . "/{$idpacienteGrupo}"));
            $dir->chmod(0777);
        }
        foreach ($request["hash"] as $hash) {
            $imagenes_tarjetas = $this->getManager("ManagerPaciente")->getImagenesIdentificacion($idpacienteGrupo);
            if ($_SESSION[$hash]["name"] == "cns" && $_SESSION[$hash]["realName"] != "") {
                $cns_ext = $_SESSION[$hash]["ext"];
                $cns_path_temp = path_files("temp/" . $hash . "." . $cns_ext);
                $cns_path_file = path_entity_files("$this->imgContainer/{$idpacienteGrupo}/cns.{$cns_ext}");
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
        }
        //eliminamos los archivos temporales subidos
        foreach ($request["hash"] as $hash) {
            unlink(path_files("temp/" . $hash . "." . $_SESSION[$hash]["ext"]));
            unset($_SESSION[$hash]);
        }



        /**
         * Si todo anduvo bien, voy a copiar las imágenes
         */
        //$this->copyImagesFromPacientes($idpacienteGrupo);

        $this->db->CompleteTrans();
        if ($request["animal"] != "1") {
            $this->setMsg(["result" => true, "msg" => "Los datos del paciente han sido modificados.", "id" => $id]);
        } else {
            $this->setMsg(["result" => true, "msg" => "Los datos de su mascota han sido modificados.", "id" => $id]);
        }
        // <-- LOG
        $log["data"] = "Social security or Passport number + picture, ALD category, CMU-C, Medecin traitant, Mutual company name)";
        $log["page"] = "Personal information";
        $log["action"] = "val"; //"val" "vis" "del"
        $log["purpose"] = "Update Personal information";

        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);
        // 

        return true;
    }

    /**
     * Update básico para no usar el insert
     * @param type $request
     * @return type
     */
    public function basic_update($request, $id) {
        $rdo = parent::update($request, $id);

        if ($rdo) {

            return $rdo;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna un registro perteneciente a un paciente grupo familiar
     * en base a su id de paciente de grupo o id de paciente titular
     * @param type $idpacienteGrupo
     * @param type $idpacienteTitular
     * @return boolean
     */
    public function getPacienteGrupoFamiliar($idpacienteGrupo, $idpacienteTitular = null) {

        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("pacienteGrupo = {$idpacienteGrupo}");

        if (!is_null($idpacienteTitular)) {
            $query->addAnd("pacienteTitular = {$idpacienteTitular}");
        }

        return $this->db->GetRow($query->getSql());
    }

    /**
     * Función que copia las imágenes que se encuentran en los directorios del paciente titular,
     * debido a que es encesario para crear el nuevo paciente del grupo familiar
     * @param type $idpaciente_new
     */
    private function copyImagesFromPacientes($idpaciente_new) {
        //Obtengo el id del paciente Titular. En este directorio se encuentran las imágenes del nuevo Paciente
        $idpaciente = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];


        $name_image_crop = "perfil_crop_$idpaciente" . "_g.jpg";
        $name_image = "perfil_g.jpg";

        $DestinationDirectory = path_entity_files("pacientes/$idpaciente/");

        $DestinationDirectory_new = path_entity_files("pacientes/$idpaciente_new/");

        if (is_file($DestinationDirectory . $name_image)) {
            //Directorio donde se van a copiar esas dos imágenes
            $name_image_new = "perfil_$idpaciente_new" . ".jpg";

            //Copio los archivos que están en el directorio del paciente titular 
            //y los pongo en los directorios de los nuevos pacientes creados
            copy($DestinationDirectory . $name_image, $DestinationDirectory_new . $name_image_new);

            //Elimino las imagenes de los archivos anteriores
            unlink($DestinationDirectory . $name_image);
        }

        if (is_file($DestinationDirectory . $name_image_crop)) {
            //Directorio donde se van a copiar esas dos imágenes
            $name_image_crop_new = "perfil_crop_$idpaciente_new.jpg";

            //Copio los archivos que están en el directorio del paciente titular 
            //y los pongo en los directorios de los nuevos pacientes creados
            copy($DestinationDirectory . $name_image_crop, $DestinationDirectory_new . $name_image_crop_new);

            //Elimino las imagenes de los archivos anteriores
            unlink($DestinationDirectory . $name_image_crop);
        }

        //Recorro todos los thumb que hay configurados
        if (count($this->thumbs_config) > 0) {
            foreach ($this->thumbs_config as $key => $config) {
                //evaluar anchos y si es un thumb proporcional					
                //$rdo = $manImg->resizeImgProportional($DestRandImageName, path_entity_files("pacientes/" . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"] . "/" . $config["suffix"] . ".jpg"), $config["w"]);
                $path_thumb = $DestinationDirectory . $config["suffix"] . ".jpg";
                $thumb_name_new = substr($config["suffix"], 0, strlen($config["suffix"]) - 2); //Elimino el _g

                if (is_file($path_thumb)) {
                    copy($path_thumb, $DestinationDirectory_new . $thumb_name_new . ".jpg");

                    unlink($path_thumb);
                }
            }
        }
    }

    /**
     * retorno de un lista con los pacientes de los grupos familiares según lo que quiera el paciente
     * @param type $request
     * @return type
     */
    public function getPacientesFamiliares($request) {
        $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
        $filtros = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"];


        $query = new AbstractSql();

        $query->setSelect("p.*,pg.*,DATE_FORMAT(p.fechaNacimiento,'%d/%m/%Y') as fechaNacimiento_format");


        if (isset($filtros["filter_selected"]) && $filtros["filter_selected"] == "self") {
            //Si el paciente desea centralizar la información en sí mísmo.
            $query->setFrom("paciente p INNER JOIN usuarioweb pg ON (p.usuarioweb_idusuarioweb = pg.idusuarioweb)");
            $query->setWhere("p.idpaciente= $idpaciente");
        } elseif (isset($filtros["filter_selected"]) && $filtros["filter_selected"] == "all") {
            //Si se desea ver todos los pacientes
            $query->setFrom("paciente p INNER JOIN $this->table pg ON (p.idpaciente = pg.pacienteGrupo)");
            $query->setWhere("pg.pacienteTitular = $idpaciente ");
        } else {
            //ID del paciente del grupo familiar sobre el que se quiere realizar la consulta
            $filtro = cleanQuery($filtros["filter_selected"]);
            $query->setFrom("paciente p INNER JOIN $this->table pg ON (p.idpaciente = pg.pacienteGrupo)");
            $query->addAnd("pg.pacienteGrupo = $filtro AND pg.pacienteTitular = $idpaciente");
        }

        $listado = $this->getList($query);
        if ($listado && count($listado) > 0) {
            $ManagerPaciente = $this->getManager("ManagerPaciente");

            foreach ($listado as $key => $paciente) {
                $listado[$key]["info_extra"] = $ManagerPaciente->getInformacionExtra($paciente["idpaciente"]);
            }
            return $listado;
        } else {
            return $listado;
        }
    }

    /**
     * Obtención del combo del paciente titular y su grupo familiar
     * @return type
     */
    public function getComboAllPacientesFamiliares() {
        $idpaciente = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];

        $query = new AbstractSql();
        $query->setSelect("idpaciente, nombre_paciente");
        $query->setFrom("((
                                        select p.idpaciente, CONCAT(pg.nombre, ' ', pg.apellido) as nombre_paciente 
                                        from paciente p 
                                                INNER JOIN pacientegrupofamiliar pg ON (p.idpaciente = pg.pacienteGrupo)	
                                        where pg.pacienteTitular = $idpaciente
                                )
                                union
                                (
                                        select p.idpaciente, CONCAT(pg.nombre, ' ', pg.apellido) as nombre_paciente
                                        from paciente p 
                                                INNER JOIN usuarioweb pg ON (p.usuarioweb_idusuarioweb = pg.idusuarioweb)
                                        where p.idpaciente = $idpaciente
                                )) as tabla");
        $query->setOrderBy("idpaciente asc");

        return $this->getComboBox($query, false);
    }

    /**
     * Método que obtiene un listado de los pacientes que 
     * @return boolean
     */
    public function getListadoPacienteConsultaExpress() {
        $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];

        $query = new AbstractSql();
        $query->setSelect("idpaciente, nombre_paciente");
        $query->setFrom("((
                                        select p.idpaciente, CONCAT(pg.nombre, ' ', pg.apellido) as nombre_paciente 
                                        from paciente p 
                                                INNER JOIN pacientegrupofamiliar pg ON (p.idpaciente = pg.pacienteGrupo)	
                                        where pg.pacienteTitular = $idpaciente
                                )
                                union
                                (
                                        select p.idpaciente, CONCAT(pg.nombre, ' ', pg.apellido) as nombre_paciente
                                        from paciente p 
                                                INNER JOIN usuarioweb pg ON (p.usuarioweb_idusuarioweb = pg.idusuarioweb)
                                        where p.idpaciente = $idpaciente
                                )) as tabla");
        $query->setOrderBy("idpaciente asc");

        $listado = $this->getList($query);

        if ($listado && count($listado) > 0) {
            $managerPerfilSaludStatus = $this->getManager("ManagerPerfilSaludStatus");
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $listado = $ManagerPaciente->getPathImagesList($listado);

            foreach ($listado as $key => $paciente) {
                $rdo = $ManagerPaciente->isPermitidoConsultaExpress($paciente["idpaciente"]);
                $listado[$key]["is_permitido"] = $rdo;
                $listado[$key]["listado_secciones"] = $managerPerfilSaludStatus->getStatusSeccionesFaltantes($paciente["idpaciente"]);
            }

            return $listado;
        } else {
            return false;
        }
    }

    /**
     * retorno de un lista con los pacientes de los grupos familiares según lo que quiera el paciente
     * @param type $request
     * @return type
     */
    public function getAllPacientesFamiliares($request, $extra = true) {
        if (isset($request["idpaciente"]) && $request["idpaciente"] != "") {
            $idpaciente = $request["idpaciente"];
        } else {
            $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
        }


        $query = new AbstractSql();

        $query->setSelect("pacientes.*");

        $query->setFrom("(( SELECT u.nombre, u.apellido, p.fechaNacimiento, p.estado, p.active, u.sexo, p.idpaciente, u.email, DATE_FORMAT(p.fechaNacimiento,'%d/%m/%Y') as fechaNacimiento_format, p.privacidad_perfil_salud,p.DNI,'' as relacionGrupo_idrelacionGrupo,p.cobertura_facturacion_step, 0 as animal
                                FROM paciente p
                                    INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb) 
                                WHERE p.idpaciente = $idpaciente
                            ) 
                            UNION 
                            ( SELECT pf.nombre, pf.apellido, p.fechaNacimiento, p.estado, p.active, pf.sexo, p.idpaciente, '' as email, DATE_FORMAT(p.fechaNacimiento,'%d/%m/%Y') as fechaNacimiento_format,p.privacidad_perfil_salud,pf.DNI,pf.relacionGrupo_idrelacionGrupo,p.cobertura_facturacion_step, pf.animal as animal
                                FROM paciente p 
                                    INNER JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo) 
                                WHERE pf.pacienteTitular = $idpaciente
                            )) as pacientes");


        $listado = $this->getList($query);
        $primer_miembro = [];
        $mover_paciente = false;
        if ($listado && count($listado) > 0) {

            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerRelacionGrupo = $this->getManager("ManagerRelacionGrupo");
            $seleccionado = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"]["filter_selected"];
            foreach ($listado as $key => $value) {



                if ($value["relacionGrupo_idrelacionGrupo"] != "") {
                    $listado[$key]["relacionGrupo"] = $ManagerRelacionGrupo->get($value["relacionGrupo_idrelacionGrupo"]);
                }


                $listado[$key]["nombre_corto"] = $ManagerPaciente->get_nombre_corto($value);

                $listado[$key]["image"] = $ManagerPaciente->getImagenPaciente($value["idpaciente"]);

                if ($extra) {
                    $listado[$key]["info_extra"] = $ManagerPaciente->getInformacionExtra($value["idpaciente"]);
                }

                if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
                    $paciente_prestador = $this->getManager("ManagerPacientePrestador")->getByFieldArray(["paciente_idpaciente", "prestador_idprestador"], [$value["idpaciente"], $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador']]);
                    $listado[$key]["idpaciente_prestador"] = $paciente_prestador["idpaciente_prestador"];
                }

                //seteamos el paciente seleccionado al principio del listado
                if ($seleccionado == "self" && $value["email"] != "") {
                    $primer_miembro = $listado[$key];
                    unset($listado[$key]);
                    $mover_paciente = true;
                } else {
                    if ($seleccionado == $value["idpaciente"]) {
                        $primer_miembro = $listado[$key];
                        unset($listado[$key]);
                        $mover_paciente = true;
                    }
                }
            }
            if ($mover_paciente) {
                array_unshift($listado, $primer_miembro);
            }



            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Metodo que retorna true si un paciente no ha superado la cantidad maxima de familiares en el grupo familiar y puede añadir otro
     */
    public function countMembers() {

        //OBtengo el id del paciente Titular.
        $idpacienteTitular = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];

        $rdo = $this->db->Execute(
                        "SELECT count(*) as qty "
                        . "FROM $this->table "
                        . "WHERE  pacienteTitular = $idpacienteTitular"
                )->FetchRow();
        if (!$rdo) {
            return false;
        } else {
            //solo se permiten 7 miembros en el grupo familiar
            if ($rdo["qty"] < 7) {
                $this->setMsg(["result" => true]);
                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "Soló puede registrar un máximo de 7 miembros a su grupo familiar"]);
                return false;
            }
        }
    }

    /**
     * Metodo que retorna la cantidad de familiares agregados en el grupo familiar
     */
    public function cantidadFamiliares() {

        //OBtengo el id del paciente Titular.
        $idpacienteTitular = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];

        $rdo = $this->db->Execute(
                        "SELECT count(*) as qty "
                        . "FROM $this->table "
                        . "WHERE  pacienteTitular = $idpacienteTitular"
                )->FetchRow();
        if (!$rdo) {
            return 0;
        } else {

            return $rdo["qty"];
        }
    }

    /**
     * Eliminación de paciente del grupo familiar
     * También se van a eliminar los pacientes. Esto quedará así ya que por el 
     * momento se toma como una relación de 1 a 1 entre usuario y paciente
     * @param type $request
     * @return boolean
     */
    public function dropMiembro($request) {
        $managerPaciente = $this->getManager("ManagerPaciente");
        $rdo = $managerPaciente->delete($request["pacienteGrupo"], true);
        $request["requerimiento"] = "self";
        $managerPaciente->change_member_session($request);
        if ($rdo) {
            $this->setMsg(["result" => true, "msg" => "Se ha eliminado con éxito el paciente de su grupo familiar"]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo eliminar el paciente de su grupo familiar"]);
            return false;
        }
    }

    /*     * Metodo que retorna el listado de los familiares de un paciente
     * 
     */

    public function getListFamiliares($idpaciente) {
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("pacienteTitular=$idpaciente");
        return $this->getList($query);
    }

}

//END_class
?>