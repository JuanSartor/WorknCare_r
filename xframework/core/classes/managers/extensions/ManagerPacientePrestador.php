<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ManagerPrestador
 *
 * @author lucas
 */
class ManagerPacientePrestador extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "paciente_prestador", "idpaciente_prestador");
    }

    /*     * Metodo que obtiene el liostado en formato JSON de los pacientes asignados a un prestador
     * 
     * @param type $idpaginate
     * @param type $request
     * @return type
     */

    public function getListadoJSON($request, $idpaginate = NULL) {

 
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
            $request["idprestador"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];
        }
        if ($request["idprestador"] == "") {
            return false;
        }
        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("
                pacientes.*
            ");
        $query->setFrom("
                (( SELECT mp.$this->id,CONCAT(u.nombre,' ' ,u.apellido) as nombre,p.DNI, p.fechaNacimiento, p.estado, p.active, p.numeroCelular, u.sexo, p.idpaciente, u.email,'Titular' as titular,mp.prestador_idprestador,pp.nombre as plan,mp.nro_afiliado,suscripcion_desde,DATE_FORMAT(mp.suscripcion_desde,'%d/%m/%Y') as suscripcion_desde_format,suscripcion_hasta,DATE_FORMAT(mp.suscripcion_hasta,'%d/%m/%Y') as suscripcion_hasta_format
			FROM paciente p
				INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb) 
                                inner join $this->table mp ON (mp.paciente_idpaciente=p.idpaciente)
                                left join plan_prestador pp on (pp.idplan_prestador=mp.plan_prestador_idplan_prestador)
		) 
		UNION 
		( SELECT mp.$this->id,CONCAT(pf.nombre,' ' ,pf.apellido) as nombre, pf.DNI,p.fechaNacimiento, p.estado, p.active,IFNULL(p.numeroCelular,p_tit.numeroCelular) as numeroCelular, pf.sexo, p.idpaciente, u.email,CONCAT(CONCAT(UCASE(LEFT(rg.relacionInversa, 1)), LCASE(SUBSTRING(rg.relacionInversa, 2))),' de ',u.nombre,' ' ,u.apellido) as titular,mp.prestador_idprestador,pp.nombre as plan,mp.nro_afiliado,suscripcion_desde,DATE_FORMAT(mp.suscripcion_desde,'%d/%m/%Y') as suscripcion_desde_format,suscripcion_hasta,DATE_FORMAT(mp.suscripcion_hasta,'%d/%m/%Y') as suscripcion_hasta_format
			FROM paciente p 
				INNER JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo) 
                                INNER JOIN relaciongrupo rg ON (rg.idrelacionGrupo = pf.relacionGrupo_idrelacionGrupo) 
				INNER JOIN paciente p_tit ON (p_tit.idpaciente = pf.pacienteTitular) 
                                INNER JOIN usuarioweb u ON (p_tit.usuarioweb_idusuarioweb = u.idusuarioweb) 
                                inner join $this->table mp ON (mp.paciente_idpaciente=p.idpaciente)
                                left join plan_prestador pp on (pp.idplan_prestador=mp.plan_prestador_idplan_prestador)
		)) as pacientes
            ");





        $query->setWhere("pacientes.prestador_idprestador={$request["idprestador"]}");
        if (isset($request["busqueda"]) && $request["busqueda"] != "") {


            $rdo = cleanQuery($request["busqueda"]);

            $query->addAnd("((pacientes.nombre LIKE '%$rdo%') OR (pacientes.DNI LIKE '%$rdo%') OR (pacientes.email LIKE '%$rdo%') OR (pacientes.nro_afiliado LIKE '%$rdo%'))");
        }

        $query->setOrderBy("pacientes.nombre ASC");

        $data = $this->getJSONList($query, array("nombre", "DNI", "titular", "email", "plan", "nro_afiliado", "suscripcion_desde_format", "suscripcion_hasta_format", "idpaciente"), $request, $idpaginate);
        $data_2 = json_decode($data, true);

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        //agregamos una columna para saber si tienen el perfil de salud completo
        foreach ($data_2["rows"] as $key => $item) {

            $permitido = $ManagerPaciente->isPermitidoConsultaExpress($item["cell"][9]);

            $data_2["rows"][$key]["cell"][] = $permitido;
        }

        return json_encode($data_2);
    }

    /*     * Metodo que obtiene el liostado en formato JSON de los pacientes que no estan asignados asignados a un prestador
     * 
     * @param type $idpaginate
     * @param type $request
     * @return type
     */

    public function getListadoPacientesJSON($request, $idpaginate = NULL) {

        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
            $request["idprestador"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];
        }
        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("
                pacientes.*
            ");
        $query->setFrom("
                (( SELECT p.idpaciente as $this->id ,CONCAT(u.nombre,' ' ,u.apellido) as nombre, p.DNI,p.fechaNacimiento, p.estado, p.active, p.numeroCelular, u.sexo, p.idpaciente, u.email,'Titular' as titular
			FROM paciente p
				INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb) 
		) 
		UNION 
		( SELECT p.idpaciente as $this->id ,CONCAT(pf.nombre,' ' ,pf.apellido) as nombre, pf.DNI,p.fechaNacimiento, p.estado, p.active,IFNULL(p.numeroCelular,p_tit.numeroCelular) as numeroCelular, pf.sexo, p.idpaciente, u.email,CONCAT(u.nombre,' ' ,u.apellido) as titular
			FROM paciente p 
				INNER JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo) 
				INNER JOIN paciente p_tit ON (p_tit.idpaciente = pf.pacienteTitular) 
                                INNER JOIN usuarioweb u ON (p_tit.usuarioweb_idusuarioweb = u.idusuarioweb)
		)) as pacientes
            ");





        $query->setWhere("pacientes.idpaciente not in (select paciente_idpaciente from {$this->table} where prestador_idprestador = {$request["idprestador"]})");
        if (isset($request["busqueda"]) && $request["busqueda"] != "") {


            $rdo = cleanQuery($request["busqueda"]);

            $query->addAnd("((pacientes.nombre LIKE '%$rdo%') OR (pacientes.DNI LIKE '%$rdo%') OR (pacientes.email LIKE '%$rdo%'))");
        }

        $query->setOrderBy("pacientes.nombre ASC");

        $data = $this->getJSONList($query, array("nombre", "DNI", "titular", "email"), $request, $idpaginate);

        return $data;
    }

    /*     * Metodo que crea la relacion entre un paciente y el prestador
     * 
     * @param type $request
     * @return boolean
     */

    public function process($request) {
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['idusuario_prestador'] != "") {
            $request["idprestador"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];
        }
        if ($request["idprestador"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo recuperar el prestador", "result" => false]);
            return false;
        }


        $ids_pacientes = explode(',', $request["ids"]);

        if (count($ids_pacientes) == 0) {
            $this->setMsg(["msg" => "Seleccione al menos un paciente", "result" => false]);
            return false;
        }

        $this->db->StartTrans();
        foreach ($ids_pacientes as $idpaciente) {
            $record["paciente_idpaciente"] = $idpaciente;
            $record["prestador_idprestador"] = $request["idprestador"];
            $exist = $this->getByFieldArray(["paciente_idpaciente", "prestador_idprestador"], [$idpaciente, $request["idprestador"]]);
            if ($exist) {
                $this->setMsg(["msg" => "Error. El paciente seleccionado ya se encuentra asignado", "result" => false]);
                return false;
            }
            $record["plan_prestador_idplan_prestador"] = $request["plan_prestador_idplan_prestador"];
            $rdo = parent::insert($record);
            if (!$rdo) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error. No se pudo agregar el paciente", "result" => false]);
                return false;
            }
        }
        $this->db->CompleteTrans();
        $this->setMsg(["msg" => "Pacientes agregados", "result" => true]);
        return true;
    }

    /*     * Metodo mediante el cual un prestador puede editar los datos de un paciente
     * 
     */

    public function processPacienteFromPrestador($request) {

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($request["idpaciente"]);
        $request["fechaNacimiento"] = $this->sqlDate($request["fechaNacimiento"]);
        //verificamos si es un usuario titualar o familiar
        if ($paciente["usuarioweb_idusuarioweb"] != "") {
            $this->db->StartTrans();
            $upd_uw = $this->getManager("ManagerUsuarioWeb")->update($request, $paciente["usuarioweb_idusuarioweb"]);
            $upd_paciente = $ManagerPaciente->basic_update($request, $request["idpaciente"]);
            $record["plan_prestador_idplan_prestador"] = $request["plan_prestador_idplan_prestador"];
            $record["nro_afiliado"] = $request["nro_afiliado"];
            if ($request["suscripcion_desde"] != "") {
                $record["suscripcion_desde"] = $this->sqlDate($request["suscripcion_desde"]);
            } else {
                $record["suscripcion_desde"] = date("Y-m-d");
            }

            if ($request["suscripcion_hasta"] != "") {
                $record["suscripcion_hasta"] = $this->sqlDate($request["suscripcion_hasta"]);
            }
            $upd = parent::update($record, $request["idpaciente_prestador"]);
            if ($upd_paciente && $upd_uw && $upd) {
                $this->db->CompleteTrans();
                $this->setMsg(["result" => true, "msg" => "Paciente actualizado con éxito"]);
                return true;
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["result" => false, "msg" => "Ha ocurrido un error al actualizar el paciente"]);
                return false;
            }
        } else {
            $this->db->StartTrans();
            $ManagerPacienteGrupoFamiliar = $this->getManager("ManagerPacienteGrupoFamiliar");
            $paciente_familiar = $ManagerPacienteGrupoFamiliar->getByField("pacienteGrupo", $request["idpaciente"]);
            $upd_paciente = $ManagerPacienteGrupoFamiliar->basic_update($request, $paciente_familiar["idpacienteGrupoFamiliar"]);
            //actualizamoz el registro del paciente-prestador
            $record["plan_prestador_idplan_prestador"] = $request["plan_prestador_idplan_prestador"];
            $record["nro_afiliado"] = $request["nro_afiliado"];
            if ($request["suscripcion_desde"] != "") {
                $record["suscripcion_desde"] = $this->sqlDate($request["suscripcion_desde"]);
            } else {
                $record["suscripcion_desde"] = date("Y-m-d");
            }

            if ($request["suscripcion_hasta"] != "") {
                $record["suscripcion_hasta"] = $this->sqlDate($request["suscripcion_hasta"]);
            }
            $upd = parent::update($record, $request["idpaciente_prestador"]);
            if ($upd_paciente && $upd) {

                $this->db->CompleteTrans();
                $this->setMsg(["result" => true, "msg" => "Paciente actualizado con éxito"]);
                return true;
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["result" => false, "msg" => "Ha ocurrido un error al actualizar el paciente"]);
                return false;
            }
        }
    }

    /*     * Metodod que setea un nuevo plan de prestador a los pacientes seleccionados
     * 
     * @param type $request
     * @return boolean
     */

    public function cambiar_plan_paciente($request) {


        $ids_pacientes_prestador = explode(',', $request["ids"]);

        if (count($ids_pacientes_prestador) == 0) {
            $this->setMsg(["msg" => "Seleccione al menos un paciente", "result" => false]);
            return false;
        }

        $this->db->StartTrans();
        foreach ($ids_pacientes_prestador as $idpaciente_prestador) {

            $record["plan_prestador_idplan_prestador"] = $request["plan_prestador_idplan_prestador"];
            $rdo = parent::update($record, $idpaciente_prestador);
            if (!$rdo) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error. No se pudo actualizar el plan", "result" => false]);
                return false;
            }
        }
        $this->db->CompleteTrans();
        $this->setMsg(["msg" => "Planes actualizados con éxito", "result" => true]);
        return true;
    }

    /*     * Metodo que crea un nuevo paciente a traves del prestador y lo asocia a el. se envia un mail con los datos de la cuenta
     * 
     * @param type $request
     * @return boolean
     */

    public function crear_paciente($request) {


        //buscamos si ya existe una cuenta con ese email
        $usuario_web = $this->getManager("ManagerUsuarioWeb")->getByField("email", $request["email"]);
        if ($usuario_web && $usuario_web["tipousuario"] == "paciente") {
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente_aux = $ManagerPaciente->getByField("usuarioweb_idusuarioweb", $usuario_web["idusuarioweb"]);
            $paciente = $ManagerPaciente->get($paciente_aux["idpaciente"]);
            $this->setMsg(array("result" => true, "paciente_existente" => 1, "idpaciente" => $paciente["idpaciente"], "paciente" => "{$paciente["nombre"]} {$paciente["apellido"]}", "msg" => "Ya existe una cuenta registrada con el mail [[{$request["email"]}]]"));
            return true;
        }



        $request["prestador_idprestador"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];

        //verificamos la edad del paciente  a crear
        $fecha_nac_sql = $this->sqlDate($request["fechaNacimiento"]);
        $calendar = new Calendar();
        $edad = $calendar->calculaEdad($fecha_nac_sql);
        if ($edad < 18) {

            $this->setMsg([
                "msg" => "Para crear una cuenta en DoctorPlus el paciente titular debe ser mayor de edad.",
                "result" => false
            ]);

            return false;
        } else {
            //verificamos los campos obligatgorios del formularios
            $campos_requerido = ["nombre", "apellido", "fechaNacimiento", "email", "DNI", "sexo"];
            foreach ($campos_requerido as $field) {
                if ($request[$field] == "") {
                    $this->setMsg([
                        "msg" => "Error. Verfique los campos obligatorios",
                        "result" => false
                    ]);

                    return false;
                }
            }
            //creamos el paciente titular mayor de edad
            $this->db->StartTrans();


            //generamos una password aleatoria
            $randomPass = $this->getManager("ManagerUsuarioWeb")->getRandomEasyPass(8);

            $randomPass_secure = sha1($randomPass);
            $randomPass_secure = base64_encode($randomPass_secure);
            $request["password"] = $randomPass_secure;

            $ManagerPaciente = $this->getManager("ManagerPaciente");

            $alta_from_admin = 1;
            $rdo_insert = $ManagerPaciente->registracion_paciente($request, $alta_from_admin);
            //verificamos si se pudo crear el paciente
            if (!$rdo_insert) {
                //Ocurrio un error, fallamos la transaccion

                $this->setMsg($ManagerPaciente->getMsg());
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }

            $idpaciente = $ManagerPaciente->getMsg()["idpaciente"];
            //creamos la realcion del prestador con el paciente
            $record["paciente_idpaciente"] = $idpaciente;
            $record["prestador_idprestador"] = $request["prestador_idprestador"];
            $record["plan_prestador_idplan_prestador"] = $request["plan_prestador_idplan_prestador"];
            $record["nro_afiliado"] = $request["nro_afiliado"];
            if ($request["suscripcion_desde"] != "") {
                $record["suscripcion_desde"] = $this->sqlDate($request["suscripcion_desde"]);
            } else {
                $record["suscripcion_desde"] = date("Y-m-d");
            }

            if ($request["suscripcion_hasta"] != "") {
                $record["suscripcion_hasta"] = $this->sqlDate($request["suscripcion_hasta"]);
            }


            $insert = parent::insert($record);

            if (!$insert) {
                //Ocurrio un error, fallamos la transaccion

                $this->setMsg([
                    "msg" => "Ocurrió un error al asociar el paciente.",
                    "result" => false
                ]);

                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }







            $request["password"] = $randomPass;
            $mEmail = $this->getManager("ManagerMail");
            $mEmail->setHTML(true);

            //ojo solo arnet local
            $mEmail->setPort("587");

            $mEmail->setSubject("WorknCare | Activation du compte");


            $smarty = SmartySingleton::getInstance();



            $prestador = $this->getManager("ManagerPrestador")->get($request["prestador_idprestador"]);
            $smarty->assign("prestador", $prestador);

            $smarty->assign("paciente", $request);


            $mEmail->setBody($smarty->Fetch("email/invitacion_registro_paciente.tpl"));


            $mEmail->addTo($request["email"]);


            //header a todos los comentarios!
            if ($mEmail->send()) {


                $this->setMsg(["msg" => "El paciente ha sido dado de alta exitosamente", "result" => true]);
                $this->db->CompleteTrans();
                return true;
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Ha ocurrido un error al dar de alta el paciente.",
                    "result" => false]);
                return false;
            }
        }
    }

    /**
     *  Metodo que valida un usuario contra el servicio de ISIC y crea la relacion en la base de datos como paciente del prestador
     * 
     * @param type $request
     * @return boolean
     */
    public function processLoginFromISIC($request) {

        $params = "token=" . ISIC_TOKEN . "&dni=" . $request["DNI"];

        $ch = curl_init();
// Establecer URL y otras opciones apropiadas
        curl_setopt($ch, CURLOPT_URL, ISIC_URL);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
        // curl_setopt($ch, CURLOPT_VERBOSE, 1);
        // $fp = fopen('/var/www/html/xframework/files/error_curl_log.txt', 'w+');
        //curl_setopt($ch, CURLOPT_STDERR, $fp);

        curl_setopt($ch, CURLOPT_POSTFIELDS, $params);

// Capturar la URL y pasarla al navegador
        $response = curl_exec($ch);


        // Cerrar el recurso cURL y liberar recursos del sistema
        $data = json_decode($response, 1)[0];

        if ($data["status"] == 1) {

            //buscamos si ya existe el registro
            $afiliado["nro_afiliado"] = $data["Numero"];
            $afiliado["suscripcion_desde"] = $this->sqlDate($data["Emision"]);
            $afiliado["suscripcion_hasta"] = $this->sqlDate($data["Vencimiento"]);
            $afiliado["paciente_idpaciente"] = $request["idpaciente"];
            $afiliado["prestador_idprestador"] = ISIC_ID;
            $paciente_prestador = $this->getByFieldArray(["paciente_idpaciente", "prestador_idprestador"], [$request["idpaciente"], ISIC_ID]);
            if ($paciente_prestador) {
                $rdo = parent::update($afiliado, $paciente_prestador["idpaciente_prestador"]);
            } else {
                $rdo = parent::insert($afiliado);
            }
            curl_close($ch);
            return $rdo;
        } else {
            curl_close($ch);
            return false;
        }
    }

    /**
     *  Metodo que valida un usuario contra el servicio de ISIC 
     * 
     * @param type $request
     * @return boolean
     */
    public function validar_paciente_ISIC($request) {

        $params = "token=" . ISIC_TOKEN . "&dni=" . $request["dni"];

        $ch = curl_init();
// Establecer URL y otras opciones apropiadas
        curl_setopt($ch, CURLOPT_URL, ISIC_URL);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
        // curl_setopt($ch, CURLOPT_VERBOSE, 1);
        // $fp = fopen('/var/www/html/xframework/files/error_curl_log.txt', 'w+');
        //curl_setopt($ch, CURLOPT_STDERR, $fp);

        curl_setopt($ch, CURLOPT_POSTFIELDS, $params);

// Capturar la URL y pasarla al navegador
        $response = curl_exec($ch);


        // Cerrar el recurso cURL y liberar recursos del sistema
        $data = json_decode($response, 1)[0];

        if ($data["status"] == 1) {
            $this->setMsg(["msg" => "Su tarjeta ISIC ha sido verificada con éxito.",
                "result" => true]);
            curl_close($ch);
            return true;
        } else {
            $this->setMsg(["msg" => "No hemos encontrado una suscripción activa con tarjeta ISIC.",
                "result" => false]);
            curl_close($ch);
            return false;
        }
    }

}
