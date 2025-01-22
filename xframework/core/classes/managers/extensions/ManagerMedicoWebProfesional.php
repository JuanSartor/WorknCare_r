<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	20/11/2020
 * 	Manager de webs profesionales del medico
 *
 */
class ManagerMedicoWebProfesional extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "medico_web_profesional", "idmedico_web_profesional");
    }

    public function agregar_web_profesional($request) {
        $record["tipo_web"] = $request["tipo_web"];
        $record["url_web"] = $request["url_web"];
        //aseguramos de agregar https al principio
        $record["url_web"] = str_replace("http://", "", $record["url_web"]);
        $record["url_web"] = str_replace("https://", "", $record["url_web"]);
        $record["url_web"] = "https://" . $record["url_web"];
        $record["medico_idmedico"] = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        $exist = $this->getByFieldArray(["tipo_web", "medico_idmedico"], [$record["tipo_web"], $record["medico_idmedico"]]);
        if ($exist) {
            $this->setMsg(["msg" => "Usted ya agrgado una web profesional de este tipo", "result" => false]);
            return false;
        }

        $id = parent::insert($record);
        if ($id) {
            $this->setMsg(["msg" => "Se ha registrado su web profesional", "result" => true]);
            return $id;
        } else {
            $this->setMsg(["msg" => "Error. No se ha podido registrar su web profesional", "result" => false]);
            return false;
        }
    }

    /*
     * Metodo que devuelve el listado de webs profesionales cargadas por el medico
     */

    public function listado_web_profesional($idmedico) {

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico=$idmedico");
        return $this->getList($query);
    }

    /**
     * Método que elimina un registro de las web profesionales cargadas por el medico
     * @param type $id
     * @param type $force
     * @return type
     */
    public function delete($id, $force = true) {
        $record = parent::get($id);
        if ($record["medico_idmedico"] == $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]) {
            return parent::delete($id, $force);
        }
    }

}

//END_class
?>