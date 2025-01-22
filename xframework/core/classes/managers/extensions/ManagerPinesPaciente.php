<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de los packs de SMS del Médico
 *
 */
class ManagerPinesPaciente extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "packpinespaciente", "idpackPinesPaciente");
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {
        
            $this->setMsg(["msg"=>"El pack ha sido creado con éxito","result"=>true]);
        }

        return $id;
    }

    public function getListadoJSON($idpaginate = NULL, $request) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("p.*");
        $query->setFrom("
                $this->table p
            ");

        $query->setOrderBy("p.cantidadPines ASC");

        $data = $this->getJSONList($query, array("cantidadPines", "precioPack"), $request, $idpaginate);

        return $data;
    }


}

//END_class
?>