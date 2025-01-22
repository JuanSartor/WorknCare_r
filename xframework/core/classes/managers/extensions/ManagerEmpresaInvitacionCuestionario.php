<?php

/**
 * 	@autor Xinergia
 * 	Manager de los link de invitacion al pass
 *
 */
class ManagerEmpresaInvitacionCuestionario extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "empresa_invitacion_cuestionario", "idempresa_invitacion_cuestionario");

        $this->default_paginate = "empresa_invitacion_cuestionario";
    }

    public function getultimoHash($request) {

        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom("$this->table t");
        $query->setWhere("t.cuestionario_idcuestionario = $request");
        $query->setOrderBy("t.idempresa_invitacion_cuestionario DESC");
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