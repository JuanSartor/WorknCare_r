<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Las Obras Sociales - Prepagas
 *
 */
class ManagerServiciosMedicos extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "servicio_medico", "idservicio_medico");
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {

            $this->setMsg(["msg" => "El servicio médico ha sido creado en el sistema", "result" => true]);
        }

        return $id;
    }

    public function getListadoJSON($idpaginate = NULL, $request) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("*");

        $query->setFrom("
                $this->table
            ");

        // Filtro
        if ($request["servicio_medico"] != "") {

            $nombre = cleanQuery($request["servicio_medico"]);

            $query->addAnd("servicio_medico LIKE '%$nombre%'");
        }


        $query->setOrderBy("servicio_medico ASC");

        $data = $this->getJSONList($query, array("servicio_medico"), $request, $idpaginate);

        return $data;
    }

    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,servicio_medico");
        $query->setFrom("$this->table");

        return $this->getComboBox($query, false);
    }

}

//END_class
?>