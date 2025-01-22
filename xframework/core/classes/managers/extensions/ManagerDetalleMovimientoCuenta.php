<?php

/**
 * ManagerDetalleMovimientoCuenta mantiene un listado con los detalles de los posibles movimientos
 *  que se realizan en las cuentas de los usuarios y DoctorPlus
 *
 * @author lucas
 */
class ManagerDetalleMovimientoCuenta extends AbstractManager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "detallemovimientocuenta", "iddetalleMovimientoCuenta");
    }

}
