<?php

/**
 * 	@autor Xinergia
 * 	Manager de los link de invitacion al pass
 *
 */
class ManagerEmpresaInvitacionCapsula extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "empresa_invitacion_capsula", "idempresainvitacioncapsulta");

        $this->default_paginate = "empresa_invitacion_capsula";
    }

    public function getCapsulaByHash($request) {

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table t, capsula c");
        $query->setWhere("t.hash = '$request'");
        $query->addAnd("t.capsula_idcapsula =c.idcapsula");
        return $this->db->GetRow($query->getSql());
    }

    public function getultimoHash($request) {

        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom("$this->table t");
        $query->setWhere("t.capsula_idcapsula = $request");
        $query->setOrderBy("t.idempresainvitacioncapsulta DESC");
        $listado = $this->getList($query);

        //si se crea correctamente asocio las funcionaldades y si aplica o no

        if ($listado) {

            $this->setMsg(["msg" => "La Enfermedad ha sido creado con éxito", "result" => true, "hash" => $listado[0]["hash"]]);
        }

        return $id;
    }

}

//END_class
?>