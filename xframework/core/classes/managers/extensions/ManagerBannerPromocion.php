<?php

/**
 * 	@autor juan sartor
 * 	@version 1.0	26/10/2021
 * 	Manager de banner promocional
 *
 */
class ManagerBannerPromocion extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "banner_promocion", "idbanner_promocion");
        $this->setImgContainer("banner_promocion");
        $this->addImgType("png");
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

        // Filtro
        if ($request["nombre_banner"] != "") {

            $rdo = cleanQuery($request["nombre_banner"]);

            $query->addAnd("nombre LIKE '%$rdo%'");
        }


        $data = $this->getJSONList($query, array("nombre"), $request, $idpaginate);

        return $data;
    }

    /**
     * Método que devuelve un registro 
     * @param type $id
     */
    public function get($id) {
        $record = parent::get($id);
        $record["banner"] = $this->getBanner($id);
        return $record;
    }

    /**
     * Metodo que devuelve un array con lsa imagenes de portada para categorias
     * @param type $id
     * @return boolean
     */
    public function getBanner($id) {

        if (is_file(path_entity_files("{$this->imgContainer}/$id/banner.png"))) {
            $record = parent::get($id);
            $v = strtotime($record["last_mod"]);
            $banner = array(
                "original" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/banner.png?$v",
                "perfil" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/banner_perfil.png?$v",
                "list" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/banner_list.png?$v",
                "usuario" => URL_ROOT . "xframework/files/entities/{$this->imgContainer}/$id/banner_usuario.png?$v"
            );

            return $banner;
        } else {

            return false;
        }
    }

    /**
     *  Metodo que devuelvo lista de banners activos ordenados por la columna orden
     */
    public function getListadoBannersActivos() {

        $query = new AbstractSql();
        $query->setSelect("
                *
            ");
        $query->setFrom("
                $this->table 
            ");
        $query->setWhere("visible=1");
        $query->setOrderBy("orden ASC");
        $listado = $this->getList($query);
        foreach ($listado as $key => $elemento) {
            $listado[$key]["last_mod"] = strtotime($elemento["last_mod"]);
        }

        return $listado;
    }

}

//END_class
