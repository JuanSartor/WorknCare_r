<?php

/**
 * ManagerMensajeTurno administra los mensajes enviados entre medico y pacientes en un turno
 *
 * @author lucas
 */
class ManagerMensajeTurno extends AbstractManager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "mensajeturno", "idmensajeTurno");
    }

    /**
     *  Inserta un registro en la tabla correspondiente
     * 
     * @param type $request
     */
    public function basic_insert($request) {
        return parent::insert($request);
    }

    /**
     *  Metodo que inserta un registro cuando se envia un mensaje de un paciente en un turno
     * @param type $request
     * @return boolean
     */
    public function insert($request) {

        $turno = $this->getManager("ManagerTurno")->get($request["idturno"]);
        $request["turno_idturno"] = $turno["idturno"];

        //verifiamos que la consulta pertenezca al paciente
        if (CONTROLLER == "paciente_p") {

            //validamos la consulta que pertenezca al paciente 

            if ($request["idturno"] == "" || $turno["paciente_idpaciente"] != $request["paciente_idpaciente"]) {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la consulta a actualizar"]);
                return false;
            }
        }

        //agregar toda la logica necesaria
        if ($request["mensaje"] == "") {
            $this->setMsg(["msg" => "Ingrese el texto del mensaje", "result" => false]);
            return false;
        }

        $this->db->StartTrans();

        $request["fecha"] = date("Y-m-d H:i:s");
        $request["leido"] = 0;

        //seteamos quien es el emisor y el flag leido en 0 de la consulta express para que le aparezca la notificacion al receptor
        if (CONTROLLER == "medico") {
            $leido = "leido_paciente";
            $request["emisor"] = "m";
        }
        if (CONTROLLER == "paciente_p" || CONTROLLER == "paciente") {
            $leido = "leido_medico";
            $request["emisor"] = "p";
        }


        $rdo = parent::insert($request);

        if ($rdo) {
            $ManagerArchivosMensajeTurno = $this->getManager("ManagerArchivosMensajeTurno");
            $request["idmensajeTurno"] = $rdo;

            $process_images = $ManagerArchivosMensajeTurno->processAllFiles($request);
            if (!$process_images) {
                $this->setMsg(["msg" => "Error. No se pudo insertar el mensaje de la consulta express", "result" => false]);

                return false;
            }

            if (CONTROLLER == "paciente_p") {
                // <-- LOG
                $log["data"] = "Patient consulting, patient consent, reason for medical appointment, comentary, file added, profesional name, specialty, date & time request, consultation fee";
                $log["page"] = "Conseil";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Answer Conseil ONGOING";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // 
            }

            $this->setMsg(["msg" => "Su mensaje se ha enviado con éxito.", "result" => true]);
            $this->db->CompleteTrans();
            return $rdo;
        } else {
            $this->setMsg(["msg" => "Error. No se ha podido enviar el mensaje.", "result" => false]);
            $this->db->FailTrans();
            return false;
        }
    }

    /**
     * Mpétodo utilizado para clonar los mensajes desde otro mensaje
     * @param type $request
     */
    public function cloneMensaje($idmensajeToClone, $idturno) {
        $mensaje = parent::get($idmensajeToClone);

        if ($mensaje) {
            $insert = $mensaje;

            unset($insert[$this->id]);
            $insert["turno_idturno"] = $idturno;
            $idmensajeNew = parent::insert($insert);

            if ($idmensajeNew) {
                /**
                 * Copio las imagenes
                 */
                $ManagerArchivosMensajeTurno = $this->getManager("ManagerArchivosMensajeTurno");
                $listado = $ManagerArchivosMensajeTurno->getListImages($mensaje[$this->id]);

                if ($listado && count($listado) > 0) {

                    foreach ($listado as $key => $value) {
                        $rdo = $ManagerArchivosMensajeTurno->cloneArchivoMensaje($value["idarchivosMensajeTurno"], $idmensajeNew);
                        if (!$rdo) {
                            return false;
                        }
                    }

                    return $idmensajeNew;
                } else {

                    return $idmensajeNew;
                }
            }
        } else {

            return false;
        }
    }

    /**
     * Método que retorna el primer mensaje
     * @param type $idturno
     * @return type
     */
    public function getPrimerMensaje($idturno) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("turno_idturno = {$idturno}");

        $query->setOrderBy("fecha DESC");

        $query->setLimit("0,1");

        return $this->db->GetRow($query->getSql());
    }

    /*     * metodo que retorna el listado de los mensajes entre paciente y medicos en un turno
     * 
     */

    public function getListadoMensajes($idturno, $idpaciente) {

        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table t 
                            INNER JOIN turno ce ON (t.turno_idturno = ce.idturno)
                    ");

        $query->setWhere("t.turno_idturno={$idturno} and t.paciente_idpaciente=$idpaciente");

        $query->setOrderBy("t.fecha DESC");

        $rdo = $this->getList($query)[0];

        if ($rdo) {
            $ManagerMedico = $this->getManager("ManagerMedico");
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerArchivosMensajeTurno = $this->getManager("ManagerArchivosMensajeTurno");
           
           
                //Si al mensaje lo envío el médico, le inicializo la imagen de perfil del médico
                if (CONTROLLER != "medico" && $rdo["medico_idmedico"] != "") {
                    $rdo["imagen_medico"] = $ManagerMedico->getImagenMedico($rdo["medico_idmedico"]);
                } elseif ($rdo["paciente_idpaciente"] != "") {
                    //Si los mensajes se listan desde el lado del médico, muestre la foto del paciente
                    $rdo["imagen_paciente"] = $ManagerPaciente->getImagenPaciente($rdo["paciente_idpaciente"]);
                }

                //Tengo que formatear la fecha de inicio.
                if ($rdo["fecha"] != "") {
                    $rdo["fecha_format"] = fechaToString($rdo["fecha"], 1);
                }

                $cantidad_archivos = $ManagerArchivosMensajeTurno->getCantidadArchivosMensaje($rdo[$this->id]);
                if ($cantidad_archivos && (int) $cantidad_archivos["cantidad"] > 0) {
                    $rdo["cantidad_archivos_mensajes"] = (int) $cantidad_archivos["cantidad"];
                }
                $rdo["archivos_mensaje"] = $ManagerArchivosMensajeTurno->getListImages($rdo[$this->id]);
            
        }
        return $rdo;
    }

}
