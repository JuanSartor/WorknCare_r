<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los PLANES de las Obras Sociales - Prepagas
 *
 */
class ManagerPlanesObrasSociales extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "planObraSocial", "idplanObraSocial");
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {

      

            $this->setMsg(["msg"=>"El plan ha sido creado con éxito","result"=>true]);
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
                nombrePlan
            ");
        $query->setFrom("
                $this->table
            ");
        $idObraSocial = (int) $request["obraSocial_idobraSocial"];
        $query->setWhere("obraSocial_idobraSocial=$idObraSocial");
        // Filtro
        if ($request["nombrePlan"] != "") {

            $nombre = cleanQuery($request["nombrePlan"]);

            $query->addAnd("nombrePlan LIKE '%$nombre%'");
        }

        $query->setOrderBy("nombrePlan ASC");

        $data = $this->getJSONList($query, array("nombrePlan"), $request, $idpaginate);

        return $data;
    }

    /**
     *  combo de los planes de las obras sociales unicamente. 
     * Diferenciadas por el campo tipo de la BD
     *
     * */
    public function getCombo($idObraSocial) {

        $query = new AbstractSql();
        $query->setSelect(" c.idplanObraSocial , c.nombrePlan");
        $query->setFrom(" $this->table c");
        $query->setWhere("c.obraSocial_idobraSocial=$idObraSocial");
        $query->setOrderBy("c.nombrePlan ASC");

        return $this->getComboBox($query, false);
    }

}

//END_class
?>