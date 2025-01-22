<?php

/**
 * 	Manager de Embajador
 *
 * 	@author lucas
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerEmbajador extends AbstractManager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "embajador", "idembajador");
    }

    /**
     * Metodo que devuelve un combo de opciones de embajadores
     * @return type
     */
    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,CONCAT(nombre,' ',apellido,' | ', email)");
        $query->setFrom("embajador");
        $query->setOrderBy("idembajador ASC");

        return $this->getComboBox($query, false);
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("idembajador,
            nombre,
            apellido,
            email,
            telefono                 
                 ");
        $query->setFrom("embajador");

        // Filtro

        if ($request["nombre"] != "") {
            $busqueda = cleanQuery($request["nombre"]);
            $query->addAnd("nombre  LIKE '%$busqueda%' OR apellido  LIKE '%$busqueda%'");
        }
        if ($request["email"] != "") {
            $busqueda = cleanQuery($request["email"]);
            $query->addAnd("email  LIKE '%$busqueda%'");
        }

        $data = $this->getJSONList($query, array("nombre", "apellido", "email", "telefono"), $request, $idpaginate);
        return $data;
    }

    /**
     * Metodo que devuelve un listado de empresas del embajador
     * @return type
     */
    public function getListadoEmpresas($id) {

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("empresa");
        $query->setWhere("embajador_idembajador=" . $id);

        $listado = $this->getList($query);
        $ManagerUsuarioEmpresa = $this->getManager("ManagerUsuarioEmpresa");
        foreach ($listado as $key => $empresa) {
            $listado[$key]["usuario"] = $ManagerUsuarioEmpresa->getByFieldArray(["empresa_idempresa", "contratante"], [$empresa["idempresa"], 1]);
        }
        return $listado;
    }

}

//END_class
?>