<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	20/11/2020
 * 	Manager de planes de Programas de salud.
 *
 */
class ManagerProgramaSaludPlan extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "programa_salud_plan", "idprograma_salud_plan");
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");

        $data = $this->getJSONList($query, array("programa_salud_plan", "precio"), $request, $idpaginate);

        return $data;
    }

    /**
     * Metodo para obtener todos los planes activos y poder modifciar el texto desde el xadmin
     * 
     * @param type $request
     * @param type $idpaginate
     * @return type
     * 
     */
    public function getListadoJSONTexto($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $query = new AbstractSql();
        $query->setSelect("*, if(particular ='1','Particular','Empresa') as part");
        $query->setFrom("$this->table");
        $query->setWhere("active='1'");

        $data = $this->getJSONList($query, array("nombre", "precio", "part"), $request, $idpaginate);

        return $data;
    }

    /**
     * ComboBox de vacunas
     * @return type
     */
    public function getCombo() {

        $query = new AbstractSql();

        $query->setSelect("$this->id, nombre");

        $query->setFrom("$this->table");

        return $this->getComboBox($query, false);
    }

    /**
     * Listado planes y packs de programas de bien estar
     * @return type
     */
    public function getList($pack = 0, $tipo_contratacion = "empresa") {

        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");
        $query->setWhere("active=1");
        if ($pack == 0) {
            $query->addAnd("pack=0");
        } else {
            $query->addAnd("pack=1");
        }
        if ($tipo_contratacion == "empresa") {
            $query->addAnd("particular=0");
        } else {
            $query->addAnd("particular=1");
        }

        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"] != '') {
            $query->addAnd("idprograma_salud_plan!=21");
            $query->addAnd("idprograma_salud_plan!=22");
            $query->addAnd("idprograma_salud_plan!=23");
        }

        return parent::getList($query);
    }

    /**
     * Método que devuelve el plan asociado a un usuario contratante
     * @param type $id
     * @return type
     */
    public function getByUser($id) {
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($id);
        $plan_contratado = parent::get($usuario_empresa["plan_idplan"]);
        $plan_contratado["fecha_adhesion"] = $usuario_empresa["fecha_adhesion"];
        $plan_contratado["fecha_adhesion_format"] = fechaToString($usuario_empresa["fecha_adhesion"]);
        $plan_contratado["fecha_vencimiento"] = $usuario_empresa["fecha_vencimiento"];
        $plan_contratado["fecha_vencimiento_format"] = fechaToString($usuario_empresa["fecha_vencimiento"]);
        $plan_contratado["codigo_pass"] = $usuario_empresa["codigo_pass"];
        $plan_contratado["fecha_alta_format"] = fechaToString($usuario_empresa["fecha_alta"]);
        return $plan_contratado;
    }

    /**
     * Método que devuelve el plan asociado a un usuario contratante por hash encodado de usuario
     * @param type $hash
     * @return type
     */
    public function getByUserHash($hash) {
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->getByHash($hash);
        $plan_contratado = parent::get($usuario_empresa["plan_idplan"]);
        $plan_contratado["fecha_adhesion"] = $usuario_empresa["fecha_adhesion"];
        $plan_contratado["fecha_adhesion_format"] = fechaToString($usuario_empresa["fecha_adhesion"]);
        $plan_contratado["codigo_pass"] = $usuario_empresa["codigo_pass"];
        $plan_contratado["hash"] = $usuario_empresa["hash"];
        return $plan_contratado;
    }

}

//END_class
?>