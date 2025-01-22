<?php

class ManagerLinkCapsula extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    public function __construct($db) {

// Llamamos al constructor del a superclase
        parent::__construct($db, "linkcapsula", "idlink");
    }

    /*
     *  1 es file
     *  2 es link
     *  3 es vdeio
     *  4 es grabacion de video
     * 
     */

    public function process($request) {
        $managerEmprea = $this->getManager("ManagerEmpresa");
        $managerEmprea->generar_hash_invitacion_capsula($request["capsula_idcapsula"]);
        $msje = $managerEmprea->getMsg();
        $rdo = parent::process($request);
        if ($rdo) {
            $this->setMsg(["msg" => "Creado Correctamente", "result" => true, "hash" => $msje["hash"]]);
            return true;
        } else {
            $this->setMsg(["msg" => "Error, no se pudo crear", "result" => false, "hash" => $msje["hash"]]);
            return false;
        }
    }

}

//END_class


