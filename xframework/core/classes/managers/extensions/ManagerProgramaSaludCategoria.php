<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	20/11/2020
 * 	Manager de Categorias de Programas de salud.
 *
 */
class ManagerProgramaSaludCategoria extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "programa_categoria", "idprograma_categoria");
        $this->setImgContainer("programa_categoria");
        $this->addImgType("svg");
        $this->addThumbConfig(50, 50, "_perfil");
        $this->addThumbConfig(150, 150, "_usuario");
        $this->addThumbConfig(110, 110, "_list");
    }

    /**
     * Metodo que procesa un registro
     * @param array $request
     * @return type
     */
    public function process($request) {
        $request["last_mod"] = date("Y-m-d H:i:s");
        return parent::process($request);
    }

    public function getListadoJSON($request, $idpaginate = NULL) {
        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $query = new AbstractSql();
        $query->setSelect("
                *
            ");
        $query->setFrom("
                $this->table 
            ");
        $query->setWhere("programa_salud_idprograma_salud=" . $request["idprograma_salud"]);

        // Filtro
        if ($request["programa_categoria"] != "") {

            $rdo = cleanQuery($request["programa_categoria"]);

            $query->addAnd("programa_categoria LIKE '%$rdo%'");
        }

        $data = $this->getJSONList($query, array("programa_categoria"), $request, $idpaginate);

        return $data;
    }

    /**
     * Método que devuelve un registro 
     * @param type $id
     */
    public function get($id) {
        $record = parent::get($id);
        $record["imagen"] = $this->getImagenes($id);
        $record["portada"] = $this->getPortadas($id);
        $record["ilustracion"] = $this->getIlustraciones($id);
        return $record;
    }

    /**
     * Metodo que devuelve un array con lsa imagenes de la entidad
     * @param type $id
     * @return boolean
     */
    public function getImagenes($id) {


        if (is_file(path_entity_files("{$this->imgContainer}/$id/$id.png"))) {
            $record = parent::get($id);
            $v = strtotime($record["last_mod"]);
            $imagen = array(
                "original" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/{$id}.png?$v",
                "perfil" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/{$id}_perfil.png?$v",
                "list" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/{$id}_list.png?$v",
                "usuario" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/{$id}_usuario.png?$v"
            );

            return $imagen;
        } else {

            return false;
        }
    }

    /**
     * Metodo que devuelve un array con lsa imagenes de portada para categorias
     * @param type $id
     * @return boolean
     */
    public function getPortadas($id) {

        if (is_file(path_entity_files("{$this->imgContainer}/$id/portada.png"))) {
            $record = parent::get($id);
            $v = strtotime($record["last_mod"]);
            $portada = array(
                "original" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/portada.png?$v",
                "perfil" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/portada_perfil.png?$v",
                "list" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/portada_list.png?$v",
                "usuario" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/portada_usuario.png?$v"
            );

            return $portada;
        } else {

            return false;
        }
    }

    public function getIlustraciones($id) {

        if (is_file(path_entity_files("{$this->imgContainer}/$id/ilustracion.png"))) {
            $record = parent::get($id);
            $v = strtotime($record["last_mod"]);
            $portada = array(
                "original" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/ilustracion.png?$v",
                "perfil" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/ilustracion_perfil.png?$v",
                "list" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/ilustracion_list.png?$v",
                "usuario" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/ilustracion_usuario.png?$v"
            );

            return $portada;
        } else {

            return false;
        }
    }

    /**
     * Metodo que devuelve el listao completo de categorias de programas salud con sus imagenes correspondientes
     * @return type
     */
    public function getListadoCategorias($idprograma_salud) {
        $query = new AbstractSql();
        $query->setSelect("
                *
            ");
        $query->setFrom("
                $this->table 
            ");
        $query->setWhere("programa_salud_idprograma_salud={$idprograma_salud}");
        $query->setOrderBy("orden ASC");
        $listado = $this->getList($query);

        //recorremos el listado y agregamos las imagenes
        foreach ($listado as $key => $item) {
            $listado[$key]["imagenes"] = $this->getImagenes($item[$this->id]);
            $listado[$key]["portadas"] = $this->getPortadas($item[$this->id]);
            $listado[$key]["ilustraciones"] = $this->getIlustraciones($item[$this->id]);
        }
        return $listado;
    }

    /**
     * Metodo que devuelve un combo completo de categorias y con progrmas de salud
     * @return type
     */
    public function getComboCategorias() {

        $query = new AbstractSql();
        $query->setSelect("
                idprograma_categoria, CONCAT(ps.programa_salud,' - ',pc.programa_categoria)
            ");
        $query->setFrom("programa_categoria pc INNER JOIN programa_salud ps on pc.programa_salud_idprograma_salud=ps.idprograma_salud ");
        $query->setWhere("ps.visible=1");
        $query->setOrderBy("ps.orden asc");
        return $this->getComboBox($query, false);
    }

    /**
     * Metodo que devuelve un listado completo de categorias y con progrmas de salud
     * @return type
     */
    public function getComboFullCategorias() {
        $listado_programas = $this->getManager("ManagerProgramaSalud")->getListadoProgramas();
        foreach ($listado_programas as $key => $programa) {
            $listado_programas[$key]["programa_categoria"] = $this->getListadoCategorias($programa["idprograma_salud"]);
        }

        return $listado_programas;
    }

    /**
     * Metodo que devuelve un listado completo de categorias y con progrmas de salud para un medico particular
     * @return type
     */
    public function getComboFullCategoriasByMedico($idmedico) {

        $query = new AbstractSql();
        $query->setSelect("T.*");
        $query->setFrom("(
                        SELECT * FROM programa_medico_referente pmr INNER JOIN programa_categoria  pc ON (pc.idprograma_categoria=pmr.programa_categoria_idprograma_categoria) WHERE pmr.medico_idmedico=$idmedico
                        UNION 
                        SELECT * FROM programa_medico_complementario pmc INNER JOIN programa_categoria  pc ON (pc.idprograma_categoria=pmc.programa_categoria_idprograma_categoria) WHERE pmc.medico_idmedico=$idmedico
                        ) as T");
        $listado_programas_medico = $this->getList($query);
        $listado_programas = [];
        $ManagerProgramaSalud = $this->getManager("ManagerProgramaSalud");
        //recorremos las cateogrias a las que esta asociado el medico 
        //recuperamos la info de programa y la categoria
        foreach ($listado_programas_medico as $programa_medico) {
            //si no existe agreagmos el programa 
            if (!is_array($listado_programas[$programa_medico["programa_salud_idprograma_salud"]])) {
                $listado_programas[$programa_medico["programa_salud_idprograma_salud"]] = $ManagerProgramaSalud->get($programa_medico["programa_salud_idprograma_salud"]);
            }
            //sumamos todas las categorias de ese programa
            $listado_programas[$programa_medico["programa_salud_idprograma_salud"]]["programa_categoria"][] = $programa_medico;
        }

        return $listado_programas;
    }

}

//END_class
