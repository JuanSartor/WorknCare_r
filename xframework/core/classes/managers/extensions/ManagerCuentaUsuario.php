<?php

/**
 * ManagerCuentaUsuario administra los saldos de las cuentas de medicos y pacientes en el sistema
 *
 * @author lucas
 */
class ManagerCuentaUsuario extends AbstractManager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "cuentausuario", "idcuentaUsuario");
    }

    /**
     * Método que retorna la cuenta perteneciente a un determinado paciente
     * @param type $idpaciente
     * @return type
     */
    public function getCuentaPaciente($idpaciente) {

        $paciente = $this->getManager("ManagerPaciente")->getPacienteTitular($idpaciente);
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("paciente_idpaciente = {$paciente["idpaciente"]}");
        $cuenta = $this->db->GetRow($query->getSql());
//si no existe la creamos
        if ($cuenta["idcuentaUsuario"] == "") {
            $id = parent::insert([
                        "paciente_idpaciente" => $paciente["idpaciente"],
                        "saldo" => 0
            ]);
            $cuenta = parent::get($id);
        }

        $cliente_stripe = $this->getManager("ManagerCustomerStripe")->get_cliente_stripe($paciente["idpaciente"]);
        return array_merge($cliente_stripe, $cuenta, $paciente);
    }

    /**
     * Método que retorna la cuenta perteneciente a un determinado Médico
     * @param type $idmedico
     * @return type
     */
    public function getCuentaMedico($idmedico) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("medico_idmedico = $idmedico");

        $cuenta = $this->db->GetRow($query->getSql());
        //si no existe la creamos
        if ($cuenta["idcuentaUsuario"] == "") {
            $id = parent::insert([
                        "medico_idmedico" => $idmedico,
                        "saldo" => 0
            ]);
            $cuenta = parent::get($id);
        }
        return $cuenta;
    }

    /**
     * Método que actualiza los valores de la cuenta del paciente
     * @param type $idpaciente
     * @return type : Retorna los valores
     */
    public function actualizarCuentaPaciente($idpaciente) {
        return true;
        /*  $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
          $listado_movimientos = $ManagerMovimientoCuenta->getMovimientosPaciente($idpaciente);

          if ($listado_movimientos && count($listado_movimientos) > 0) {
          //Obtengo la cuenta del paciente
          $cuenta = $this->getCuentaPaciente($idpaciente);


          $monto = 0.00;

          //Recorro todos los movimientos y voy procesando, para luego actualizar la cuenta del paciente
          foreach ($listado_movimientos as $key => $movimiento) {
          //verificamos solos los movimientos con credito - no debitados del plan empresa
          if ($movimiento["debito_plan_empresa"] != 1) {
          //Si el tipo es ingreso SUMA. De lo contrario, RESTA
          $tipo = (int) $movimiento["is_ingreso"] == 1 ? 1 : -1;
          $monto += (float) $movimiento["monto"] * $tipo;
          }
          }



          if ($cuenta) {
          //Actualizo la cuenta con el monto
          $rdo = parent::update([
          "saldo" => $monto
          ], $cuenta[$this->id]);
          } else {
          //Realizo el insert de la cuenta, si es que no la tiene
          $rdo = parent::insert([
          "paciente_idpaciente" => $idpaciente,
          "saldo" => $monto
          ]);
          }

          return $rdo;
          } else {
          return true;
          } */
    }

    /**
     * Método que actualiza los valores de la cuenta del paciente
     * @param type $idpaciente
     * @return type : Retorna los valores
     */
    public function actualizarCuentaPacienteFromAdmin($idpaciente) {

        $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
        $listado_movimientos = $ManagerMovimientoCuenta->getMovimientosPaciente($idpaciente);

        if ($listado_movimientos && count($listado_movimientos) > 0) {
            //Obtengo la cuenta del paciente
            $cuenta = $this->getCuentaPaciente($idpaciente);


            $monto = 0.00;

            //Recorro todos los movimientos y voy procesando, para luego actualizar la cuenta del paciente
            foreach ($listado_movimientos as $key => $movimiento) {
                //verificamos solos los movimientos con  credito DP - no debitados del plan empresa ni stripe directo de la tarjeta
                if ($movimiento["debito_plan_empresa"] == 0 && $movimiento["pendiente_stripe"] == 0 && $movimiento["confirmado_stripe"] == 0) {
                    //Si el tipo es ingreso SUMA. De lo contrario, RESTA
                    $tipo = (int) $movimiento["is_ingreso"] == 1 ? 1 : -1;
                    $monto += (float) $movimiento["monto"] * $tipo;
                }
            }



            if ($cuenta) {
                //Actualizo la cuenta con el monto
                $rdo = parent::update([
                            "saldo" => $monto
                                ], $cuenta[$this->id]);
            } else {
                //Realizo el insert de la cuenta, si es que no la tiene
                $rdo = parent::insert([
                            "paciente_idpaciente" => $idpaciente,
                            "saldo" => $monto
                ]);
            }

            return $rdo;
        } else {
            return true;
        }
    }

    /**
     * Método que actualiza los valores de la cuenta del medico
     * @param type $idmedico
     * @return type : Retorna los valores
     */
    public function actualizarCuentaMedico($idmedico) {
        $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
        $listado_movimientos = $ManagerMovimientoCuenta->getMovimientosMedico($idmedico);

        if ($listado_movimientos && count($listado_movimientos) > 0) {
            //Obtengo la cuenta del paciente
            $cuenta = $this->getCuentaMedico($idmedico);

            $monto = 0.00;

            //Recorro todos los movimientos y voy procesando, para luego actualizar la cuenta del paciente
            foreach ($listado_movimientos as $key => $movimiento) {
                //Si el tipo es ingreso SUMA. De lo contrario, RESTA
                $tipo = (int) $movimiento["is_ingreso"] == 1 ? 1 : -1;
                $monto += (float) $movimiento["monto"] * $tipo;
            }


            if ($cuenta) {
                //Actualizo la cuenta con el monto
                $rdo = parent::update([
                            "saldo" => $monto
                                ], $cuenta[$this->id]);
            } else {
                //Realizo el insert de la cuenta, si es que no la tiene
                $rdo = parent::insert([
                            "medico_idmedico" => $idmedico,
                            "saldo" => $monto
                ]);
            }

            return $rdo;
        } else {
            return false;
        }
    }

}
