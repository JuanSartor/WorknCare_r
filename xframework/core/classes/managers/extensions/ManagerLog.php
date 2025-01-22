<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	2008-04-14
 * 	Manager de usuarios
 *
 */

/**
 * @autor Xinergia
 * @version 1.0
 * Class ManagerUsuarios
 * 	
 * Emcapsula el manejo de los Usuarios del sistema
 */
class ManagerLog extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "log", "idlog");

        $this->default_paginate = "dp_log_listado";
    }

    /**
     * Graba el log de eventos del sistema
     * @param type $record Registro a guardar log
     */
    public function track($log) {

        // Detectamos el usuario generador del LOG
        // Ajusto. Si no está seteado el userid lo tomo de la sessión. Si no, lo tomo del parámetro con el que me llegó.
        if (!isset($log["userid"])) {
            if (!isset($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"])) {
                $log["userid"] = "N/A";
            } else {
                if (CONTROLLER == "empresa") {
                    $log["userid"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
                } else {
                    $log["userid"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuarioweb"];
                }
            }
        }

        //print_r($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]);
        // Tipo de usuario automático de acuerdo al controller en que sucede
        switch (CONTROLLER) {

            case "medico":
                $log["usertype"] = "Professional";
                break;
            case "paciente_p":
                $log["usertype"] = "Patient";
                break;
            case "empresa":
                $log["usertype"] = "Entreprise";
                break;
            default:
                if ($log["usertype"] == "") {
                    $log["usertype"] = "N/A";
                }
        }



        if (!isset($log["data"]) || $log["data"] == "") {
            $log["data"] = "-";
        }

        // Fecha y hora
        $log["date"] = date("Y-m-d");
        $log["time"] = date("H:i:s");

        // Link e IP
        $log["ipaddress"] = $_SERVER['REMOTE_ADDR'];

        if ($_SERVER["HTTP_REFERER"] != "") {
            $log["link"] = $_SERVER["HTTP_REFERER"];
        } elseif ($_SERVER["REDIRECT_URL"] != "") {
            $log["link"] = URL_ROOT . substr($_SERVER["REDIRECT_URL"], 1, strlen($_SERVER["REDIRECT_URL"]) - 1);
        } elseif ($_SERVER["REQUEST_URI"] != "") {
            $log["link"] = URL_ROOT . substr($_SERVER["REQUEST_URI"], 1, strlen($_SERVER["REQUEST_URI"]) - 1);
        } else {
            $log["link"] = URL_ROOT;
        }
        // FIX para los eventos de visualización
        // Tipo de acción
        switch ($log["action"]) {
            case "val":
                $log["action"] = "Validate";
                break;
            case "vis":
                $log["action"] = "Visualize";
                $log["link"] = URL_ROOT . substr($_SERVER["REQUEST_URI"], 1, strlen($_SERVER["REQUEST_URI"]) - 1);
                break;
            case "del":
                $log["action"] = "Delete";
                break;

            default:
                $log["action"] = "-";
        }

        // echo "<pre>";print_r($_SERVER); die();

        $log["script"] = $_SERVER['PHP_SELF'];


        return $this->insert($log);
    }

    /**
     * Listado de registros de mail
     * @param type $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, $request["rows"]);
        }

        $query = new AbstractSql();
        $query->setSelect("
                            idlog,
                            CONCAT( l.date, ' ', l.time ) AS fecha,
                            l.usertype,
                            l.userid,
                            if(m.idmedico is not null, CONCAT(m.nombre,' ',m.apellido),CONCAT(p.nombre,' ',p.apellido)) as nombre,
                            ifnull( m.email, p.email ) AS email,
                            l.page,
                            l.purpose,
                            l.data,
                            l.link          
                 ");
        $query->setFrom("
                $this->table l 
                    LEFT JOIN v_pacientes p ON (l.userid <> 0 and p.usuarioweb_idusuarioweb = l.userid AND usertype = 'Patient' AND p.usuarioweb_idusuarioweb IS NOT NULL )
                    LEFT JOIN v_medicos m ON (l.userid <> 0 and m.idusuarioweb = l.userid AND usertype = 'Professional' AND m.idusuarioweb IS NOT NULL ) 
                ");

        if ($request["email"] != "") {
            $busqueda = cleanQuery($request["email"]);
            $query->addAnd("(m.email  LIKE '%$busqueda%' OR p.email LIKE '%$busqueda%' )");
        }
        // Filtro
        if ($request["fecha"] != "") {
            $fecha = $this->sqlDate($request["fecha"]);
            $query->addAnd("date >= '{$fecha} 00:00:00' AND date <= '{$fecha} 23:59:59'");
        }

        $data = $this->getJSONList($query, array("fecha", "usertype", "nombre", "email", "page", "purpose", "link", "data"), $request, $idpaginate);

        return $data;
    }

}

//END_class 
?>