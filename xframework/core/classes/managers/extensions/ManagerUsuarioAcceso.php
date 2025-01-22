<?php

/**
 * 	@autor Xinergia
 * 	Manager de los menus asociados a un usuario
 *
 */
class ManagerUsuarioAcceso extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "usuario_acceso", "idusuario_acceso");
    }

    /**
     * Metodo que obtiene el listado de accesos al meno que tiene un usuario
     * @param type $id
     * @return type
     */
    function getByUsuario($id) {

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("{$this->table} ua INNER JOIN usuario_menu um ON (ua.usuario_menu_idusuario_menu=um.idusuario_menu)");
        $query->setWhere("ua.usuario_idusuario=$id");
        return $this->getList($query);
    }

    /**
     * Método que devuelve los id de menu a los que tiene accesos un usuario
     * @param type $id
     * @return type
     */
    function getListAccesosByUsuario($id) {
       
        $query = new AbstractSql();
        $query->setSelect("usuario_menu_idusuario_menu");
        $query->setFrom("{$this->table} ua INNER JOIN usuario_menu um ON (ua.usuario_menu_idusuario_menu=um.idusuario_menu)");
        $query->setWhere("ua.usuario_idusuario=$id");
        $listado = $this->getList($query);
        $accesos_usuario = [];
        foreach ($listado as $menu_usuario) {
            $accesos_usuario[] = $menu_usuario["usuario_menu_idusuario_menu"];
        }
        return $accesos_usuario;
    }

}

//END_class
?>