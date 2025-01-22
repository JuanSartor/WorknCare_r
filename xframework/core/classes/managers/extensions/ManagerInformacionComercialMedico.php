<?php

/**
 * 	Manager de De la información comercial de los médicos
 *
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerInformacionComercialMedico extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "informacion_comercial_medico", "idinformacion_comercial_medico");
    }

    /**
     * Retorno de la información comercial del médico..
     * Este registro es único para cada médico
     * @param type $idmedico
     * @return type
     */
    public function getInformacionComercialMedico($idmedico = null) {

        if (is_null($idmedico)) {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        }


        $query = new AbstractSql();
        $query->setSelect("icm.*, b.nombre_banco");
        $query->setFrom("$this->table icm "
                . "INNER JOIN medico m  ON (icm.medico_idmedico=m.idmedico)"
                . "INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb=uw.idusuarioweb)"
                . "LEFT JOIN banco b ON (icm.banco_idbanco = b.idbanco) ");
        $query->setWhere("medico_idmedico = $idmedico");


        $info = $this->db->getRow($query->getSql());

        if (!$info) {
            return false;
        } else {
            return $info;
        }
    }

    public function processFromFrontEnd($request) {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        if ($request["iban"] == "") {
            $this->setMsg([ "msg" => "Ingrese un código IBAN válido", "result" => true]);
            return true;
        }

        if ($request["nombre_beneficiario"] == "") {
            $this->setMsg([ "msg" => "Ingrese el nombre del beneficiario", "result" => true]);
            return true;
        }

        $banco = $this->getManager("ManagerBanco")->getBancoXIBAN($request["iban"]);
        if (!$banco) {
            $this->setMsg([ "msg" => "Ingrese un código IBAN válido", "result" => true]);
            return true;
        }
        $request["banco_idbanco"] = $banco["idbanco"];

        $request["medico_idmedico"] = $idmedico;


        $id = parent::process($request);

        if ($id) {
            //$mail = $this->enviarMailModificacionDatosComerciales($idmedico);
            $this->setMsg([ "msg" => "Datos comerciales actualizados con éxito", "result" => true]);
            
            // <-- LOG
            $log["data"] = "IBAN, Bank";
            $log["page"] = "Professional information";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "Update bank account details";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // 
            
            return true;
        }

        return $id;
    }

    /**
     * 
     * sube la constancia de inscripcion si es que el usuario seleccino obviamente
     * @param array $idmedico int con identificador del médico
     * @param array $request Array con parametros suminstrados por el usuario
     * 
     */
    private function subirConstanciaInscripcion($idmedico, $request) {
        //si se subieron ficheros
        if (isset($request["hash"]) && is_array($request["hash"])) {


            foreach ($request["hash"] as $k => $hash) {

                $file = $_SESSION[$hash];


                if ($file["realName"] != "" && file_exists(path_files("temp/" . $file["name"]))) {

                    $name = $file["realName"];

                    $miPDF = path_files("entities/medicos/$idmedico/constancia-de-inscripcion.pdf");

                    if (file_exists($miPDF)) {

                        unlink($miPDF);
                    }

                    rename(path_files("temp/" . $file["name"]), $miPDF);

                    unset($_SESSION[$hash]["files"][$k]);

                    return;
                }
            }
        }
        return;
    }

    /*     * Metodo que envia un mensaje via email a medico cuando se realizan modificaciones en sus datos comerciales
     * 
     * @param type $request
     */

    public function enviarMailModificacionDatosComerciales($idmedico) {


        $ManagerMedico = $this->getManager("ManagerMedico");

        $medico = $ManagerMedico->get($idmedico);



        if ($medico["email"] == "") {
            $this->setMsg([ "msg" => "Error al recuperar email del medico ", "result" => false]);
            return false;
        }

        //envio de la invitacion por mail
        $smarty = SmartySingleton::getInstance();


        $smarty->assign("medico", $medico);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);
        $mEmail->setBody($smarty->Fetch("email/mensaje_modificacion_datos_comerciales.tpl"));
        $mEmail->setSubject("WorknCare | Avis de modification de données commerciales");

        $email = $medico["email"];

        $mEmail->addTo($email);
        //ojo solo arnet local
        $mEmail->setPort("587");

        return $mEmail->send();
    }

}

//END_class 
?>