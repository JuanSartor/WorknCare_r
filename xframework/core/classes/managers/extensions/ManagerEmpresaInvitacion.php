<?php

/**
 * 	@autor Xinergia
 * 	Manager de los link de invitacion al pass
 *
 */
class ManagerEmpresaInvitacion extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "empresa_invitacion", "idempresa_invitacion");

        $this->default_paginate = "empresa_invitacion";
    }

}

//END_class
?>