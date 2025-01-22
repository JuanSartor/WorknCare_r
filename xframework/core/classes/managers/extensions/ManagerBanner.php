<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los médicos
 *
 */
class ManagerBanner extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "banner", "idbanner");

        $this->setImgContainer("banners");
        $this->addThumbConfig(50, 50, "_perfil");

        $this->addImgType("*");
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();

        $query->setSelect("p.*, tb.tipoBanner");

        $query->setFrom("
                $this->table p 
                    INNER JOIN tipobanner tb ON (tb.idtipoBanner = p.tipoBanner_idtipoBanner)
            ");

        $data = $this->getJSONList($query, array("banner", "descripcion", "tipoBanner"), $request, $idpaginate);

        return $data;
    }

    public function get($id) {
        $rdo = parent::get($id);
        if ($rdo) {
            if (is_file(path_entity_files("banners/$id/desktop.jpg")) || is_file(path_entity_files("banners/$id/mobile.jpg"))) {
                $rdo["image_desktop"] = URL_ROOT . "xframework/files/entities/banners/$id/desktop.jpg";
                $rdo["image_desktop_perfil"] = URL_ROOT . "xframework/files/entities/banners/$id/desktop_perfil.jpg";
                $rdo["image_mobile"] = URL_ROOT . "xframework/files/entities/banners/$id/mobile.jpg";
                $rdo["image_mobile_perfil"] = URL_ROOT . "xframework/files/entities/banners/$id/mobile_perfil.jpg";
            }
            return $rdo;
        } else {
            return false;
        }
    }

}
