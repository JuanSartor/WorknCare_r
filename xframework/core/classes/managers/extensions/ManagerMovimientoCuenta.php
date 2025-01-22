<?php

/**
 * ManagerMovimientoCuenta administra el listado de los movimientos de ingreso y egreso de las cuentas corrientes de los usuarios
 *
 * @author lucas
 */
class ManagerMovimientoCuenta extends AbstractManager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

// Llamamos al constructor del a superclase
        parent::__construct($db, "movimientocuenta", "idmovimientoCuenta");
    }

    /**
     * Método que retorna un listado de los movimientos contables pertenecientes a un determinado paciente
     * @param type $idpaciente
     * @return type
     */
    public function getMovimientosPaciente($idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("paciente_idpaciente = $idpaciente");

        return $this->getList($query);
    }

    /**
     * Método que retorna un listado de los movimientos contables pertenecientes a un determinado médico
     * @param type $idmedico
     * @return type
     */
    public function getMovimientosMedico($idmedico) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("medico_idmedico = $idmedico");

        return $this->getList($query);
    }

    /**
     * Método que realiza el proceso de la publicación del movimiento perteneciente a una consulta express publicada
     * a profesionales de la red o a un determinado profesional frecuente
     * @param type $request
     * @return boolean
     */
    public function processMovimientoPlublicacionCE($request) {

//Tengo que obtener la cuenta del paciente titular, porque es él el que tiene la cuenta en DP
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->getPacienteTitular($request["paciente_idpaciente"]);

//Obtengo la cuenta del paciente, asociado a la consulta express... 
        $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
        $cuenta_paciente = $ManagerCuentaUsuario->getCuentaPaciente($paciente["idpaciente"]);

        $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
        $consulta = $ManagerConsultaExpress->get($request["idconsultaExpress"]);

        $ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");

        if ($cuenta_paciente) {

            $insert_movimiento = [
                "fecha" => date("Y-m-d H:i:s"),
                "is_ingreso" => 0,
                "cuentaUsuario_idcuentaUsuario" => $cuenta_paciente["idcuentaUsuario"],
                "consultaExpress_idconsultaExpress" => $request["idconsultaExpress"],
                "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 1, //Publicación Consulta Express
                "paciente_idpaciente" => $paciente["idpaciente"]
            ];

            if ($consulta["tipo_consulta"] == "0") {
//SI ocurre esto, la consulta express fue realizada profesionales de la red
//El valor que se le descuenta es el mayor de la bolsa
                $insert_movimiento["monto"] = $request["rango_maximo"];
            } else {
//Si ocurre esto, la consulta se Hizo a un médico frecuente
                $insert_movimiento["monto"] = $request["precio_tarifa"];
            }
//el monto puede ser 0 cuando es un profesional sin cargo, o mayor a 0 para el resto de los medicos
            if ((float) $insert_movimiento["monto"] < 0) {
                $this->setMsg(["msg" => "Error. Se produjo un error al actualizar el monto", "result" => false]);
                return false;
            }
//si el monto es mayor a 0 cobramos en Stripe
            if ((float) $insert_movimiento["monto"] > 0) {
                $insert_movimiento["pendiente_stripe"] = 1;
            } else {
                $insert_movimiento["pendiente_stripe"] = 0;
            }
//si es pago de paciente empresa
            if ($paciente["is_paciente_empresa"] == 1) {
                $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
                $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);

//verificamos si tiene consultas disponibles en el plan
                if ($paciente_empresa["cant_consultaexpress"] < $plan_contratado["cant_consultaexpress"]) {

//verificamos si el programa esta bonificado si es consulta en la red
                    if ($consulta["tipo_consulta"] == "0") {

                        $filtro = $this->getManager("ManagerFiltrosBusquedaConsultaExpress")->getByField("consultaExpress_idconsultaExpress", $request["idconsultaExpress"]);

//verificamos si el medico está incluido en los planes cubiertos por la empresa
                        $programa_bonificado = $this->getManager("ManagerProgramaSaludExcepcion")->verificar_programa_bonificado($filtro["idprograma_categoria"], $paciente_empresa["empresa_idempresa"]);
                        if ($programa_bonificado) {
                            $insert_movimiento["debito_plan_empresa"] = 1;
                            $insert_movimiento["pendiente_stripe"] = 0; //no cobramos en stripe - Se debita del plan
                        }
                    }
//verificamos si el medico está bonificado si es consulta particular
                    if ($consulta["tipo_consulta"] == "1") {
//verificamos si el medico está incluido en los planes cubiertos por la empresa
                        $medico_bonificado = $this->getManager("ManagerProgramaSaludExcepcion")->verificar_medico_bonificado($consulta["medico_idmedico"], $paciente_empresa["empresa_idempresa"], $consulta["idprograma_categoria"]);
                        if ($medico_bonificado) {
                            $insert_movimiento["debito_plan_empresa"] = 1;
                            $insert_movimiento["pendiente_stripe"] = 0; //no cobramos en stripe - Se debita del plan
                        }
                    }
                }
            }

//registramos el metodo de pago de stripe
            if ($insert_movimiento["pendiente_stripe"] == 1) {
                if ($request["payment_method"] == "") {
                    $this->setMsg(["msg" => "Error. Se produjo un error al actualizar el monto", "result" => false]);
                    return false;
                }

                $insert_movimiento["stripe_payment_method"] = $request["payment_method"]; //id tarjeta utilizada para el cobro futuro
            }

            $insert = parent::insert($insert_movimiento);

            if ($insert) {
//debitamos una consulta realizada del plan empresa
                if ($insert_movimiento["debito_plan_empresa"] == 1) {
                    $record["cant_consultaexpress"] = (int) $paciente_empresa["cant_consultaexpress"] + 1;
                    $upd_paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->update($record, $paciente_empresa["idpaciente_empresa"]);

                    if (!$upd_paciente_empresa) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                        $this->setMsg(["msg" => "Error. No se pudo insertar el movimiento perteneciente a la publicación de la consulta express, intente nuevamente", "result" => false]);
                        return false;
                    }

                    $upd_ce = $ManagerConsultaExpress->update(["debito_plan_empresa" => 1], $request["idconsultaExpress"]);
                    if (!$upd_ce) {
                        $this->setMsg(["msg" => "Error. Se produjo un error al actualizar el monto", "result" => false]);
                        return false;
                    }
                }

                if ($insert_movimiento["pendiente_stripe"] == 1) {

                    $cobro_stripe = $ManagerCustomerStripe->process_cobro_consulta($request["idconsultaExpress"], $insert, "consultaexpress");
                    if (!$cobro_stripe) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                        $this->setMsg($ManagerCustomerStripe->getMsg());
                        return false;
                    }
                }

//Si se pudo crear el movimiento perteneciente a la CE, actualizo la cuenta del paciente
                $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaPaciente($paciente["idpaciente"]);
                if ($cuenta_update) {
                    return $insert;
                }
            }


//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
            $this->setMsg(["msg" => "Error. No se pudo insertar el movimiento perteneciente a la publicación de la consulta express, intente nuevamente", "result" => false]);
            return false;
        } else {
            $this->setMsg(["msg" => "Error. No posee cuenta en DoctorPlus.", "result" => false]);
            return false;
        }
    }

    /**
     *  Metodo que verifica si tiene disponibles consultas express sin cargo, o si se debe pagar la tarifa del prestador y devulve el precio a cobrar
     */
    public function getMontoConsultaExpressPrestador($idconsultaExpress) {


        $consulta = $this->getManager("ManagerConsultaExpress")->get($idconsultaExpress);

        $prestador = $this->getManager("ManagerPrestador")->get($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"]);
//obtenemos el plan del paciente
        $rs_plan = $this->db->getRow("select plp.*,p.idpaciente from paciente p
                 inner join paciente_prestador pp on (pp.paciente_idpaciente=p.idpaciente)
                 INNER JOIN plan_prestador plp ON (plp.idplan_prestador=pp.plan_prestador_idplan_prestador) 
                 where p.idpaciente={$consulta["paciente_idpaciente"]}");

//obtenemos cuantas consulta realizó el paciente
        $cant_ce = $this->db->getRow("select count(*) as cant_mes_actual 
              from consultaexpress ce where paciente_idpaciente={$consulta["paciente_idpaciente"]} 
              and prestador_idprestador={$_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"]}  
              and MONTH(ce.fecha_inicio)=MONTH(SYSDATE()) 
              and YEAR(ce.fecha_inicio)=YEAR(SYSDATE())");
//si no tiene plan o agoto la cantidad mensual, seteamos el precio de consulta del prestador
        if ($rs_plan["cantidad_ce"] == "" || (int) $cant_ce["cant_mes_actual"] > (int) $rs_plan["cantidad_ce"]) {
//si el prestador tiene decuento seteado, lo aplicamos sobre el precio de la consulta del medico

            if ((int) $prestador["descuento"] > 0) {

                $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($consulta["medico_idmedico"]);

                $valor_medico = (int) $preferencia["valorPinesConsultaExpress"];
                $monto = (int) $valor_medico - ((int) $valor_medico * (int) $prestador["descuento"] / 100);
                return round($monto, 0);
            } else {
                return $prestador["valorConsultaExpress"];
            }
        } else {
            return 0;
        }
    }

    /**
     *  Metodo que verifica si tiene disponibles videoconsultas consultas sin cargo, o si se debe pagar la tarifa del prestador y devulve el precio a cobrar
     */
    public function getMontoVideoConsultaPrestador($idvideoconsulta) {

        $consulta = $this->getManager("ManagerVideoConsulta")->get($idvideoconsulta);

        $prestador = $this->getManager("ManagerPrestador")->get($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"]);
//obtenemos el plan del paciente
        $rs_plan = $this->db->getRow("select plp.*,p.idpaciente from paciente p
                 inner join paciente_prestador pp on (pp.paciente_idpaciente=p.idpaciente)
                 INNER JOIN plan_prestador plp ON (plp.idplan_prestador=pp.plan_prestador_idplan_prestador) 
                 where p.idpaciente={$consulta["paciente_idpaciente"]}");

//obtenemos cuantas consulta realizó el paciente
        $cant_vc = $this->db->getRow("select count(*) as cant_mes_actual 
              from videoconsulta vc where paciente_idpaciente={$consulta["paciente_idpaciente"]} 
              and prestador_idprestador={$_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"]}  
              and MONTH(vc.fecha_inicio)=MONTH(SYSDATE()) 
              and YEAR(vc.fecha_inicio)=YEAR(SYSDATE())");
//si no tiene plan o agoto la cantidad mensual, seteamos el precio de consulta del prestador
        if ($rs_plan["cantidad_vc"] == "" || (int) $cant_vc["cant_mes_actual"] >= (int) $rs_plan["cantidad_vc"]) {
            if ((int) $prestador["descuento"] > 0) {
//si el prestador tiene decuento seteado, lo aplicamos sobre el precio de la consulta del medico
                $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($consulta["medico_idmedico"]);
                if ($consulta["turno_idturno"] != "") {
                    $valor_medico = (int) $preferencia["valorPinesVideoConsultaTurno"];
                } else {
                    $valor_medico = (int) $preferencia["valorPinesVideoConsulta"];
                }

                $monto = $valor_medico - ($valor_medico * (int) $prestador["descuento"] / 100);
                return round($monto, 0);
            } else {
                if ($consulta["turno_idturno"] != "") {
                    return $prestador["valorVideoConsultaTurno"];
                } else {
                    return $prestador["valorVideoConsulta"];
                }
            }
        } else {
            return 0;
        }
    }

    /**
     *  Metodo que verifica si tiene disponibles videoconsultas consultas sin cargo, o si se debe pagar la tarifa del prestador y devulve el precio a cobrar
     */
    public function getMontoVideoConsultaTurnoPrestador($idturno) {

        $turno = $this->getManager("ManagerTurno")->get($idturno);

        $prestador = $this->getManager("ManagerPrestador")->get($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"]);
//obtenemos el plan del paciente
        $rs_plan = $this->db->getRow("select plp.*,p.idpaciente from paciente p
                 inner join paciente_prestador pp on (pp.paciente_idpaciente=p.idpaciente)
                 INNER JOIN plan_prestador plp ON (plp.idplan_prestador=pp.plan_prestador_idplan_prestador) 
                 where p.idpaciente={$turno["paciente_idpaciente"]}");

//obtenemos cuantas consulta realizó el paciente
        $cant_vc = $this->db->getRow("select count(*) as cant_mes_actual 
              from videoconsulta vc where paciente_idpaciente={$turno["paciente_idpaciente"]} 
              and prestador_idprestador={$_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"]}  
              and MONTH(vc.fecha_inicio)=MONTH(SYSDATE()) 
              and YEAR(vc.fecha_inicio)=YEAR(SYSDATE())");
//si no tiene plan o agoto la cantidad mensual, seteamos el precio de consulta del prestador
        if ($rs_plan["cantidad_vc"] == "" || (int) $cant_vc["cant_mes_actual"] >= (int) $rs_plan["cantidad_vc"]) {
            if ((int) $prestador["descuento"] > 0) {
//si el prestador tiene decuento seteado, lo aplicamos sobre el precio de la consulta del medico
                $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($turno["medico_idmedico"]);

                $valor_medico = (int) $preferencia["valorPinesVideoConsultaTurno"];
                $monto = $valor_medico - ($valor_medico * (int) $prestador["descuento"] / 100);
                return round($monto, 0);
            } else {
                return $prestador["valorVideoConsultaTurno"];
            }
        } else {
            return 0;
        }
    }

    /**
     * Metodo que devuelve el monto de la videoconsulta con turno cobrado al paciente
     * @param type $idturno
     * @param type $idpaciente
     * @return type
     */
    public function getMontoVideoConsultaTurnoPaciente($idturno, $idpaciente) {
        $query = new AbstractSql();
        $query->setSelect("monto,debito_plan_empresa,$this->id");
        $query->setFrom("$this->table");
        $query->setWhere(" turno_idturno = $idturno   AND   paciente_idpaciente = $idpaciente AND is_ingreso=0");
        $query->setOrderBy("fecha desc");
        $query->setLimit("0,1");

        $result = $this->getList($query)[0];

        return $result;
    }

    /**
     * Método que realiza el proceso de la publicación del movimiento perteneciente a una video consulta publicada
     * a profesionales de la red o a un determinado profesional frecuente
     * @param type $request
     * @return boolean
     */
    public function processMovimientoPlublicacionVC($request) {

//Tengo que obtener la cuenta del paciente titular, porque es él el que tiene la cuenta en DP
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->getPacienteTitular($request["paciente_idpaciente"]);

//Obtengo la cuenta del paciente, asociado a la video consulta... 
        $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
        $cuenta_paciente = $ManagerCuentaUsuario->getCuentaPaciente($paciente["idpaciente"]);

        $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
        $consulta = $ManagerVideoConsulta->get($request["idvideoconsulta"]);

        $ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
        if ($cuenta_paciente) {

//Tengo que descontar el dinero de la cuenta del paciente e insertarla en la cuenta de DP 
//DoctorPlus retendrá el dinero perteneciente a DP

            $insert_movimiento = [
                "fecha" => date("Y-m-d H:i:s"),
                "is_ingreso" => 0,
                "cuentaUsuario_idcuentaUsuario" => $cuenta_paciente["idcuentaUsuario"],
                "videoconsulta_idvideoconsulta" => $request["idvideoconsulta"],
                "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 6, //Publicación Video Consulta
                "paciente_idpaciente" => $paciente["idpaciente"]
            ];
//verificamos si el paciente se logueo con su prestador 
            if ($consulta["tipo_consulta"] == "0") {
//SI ocurre esto, la video consulta fue realizada profesionales de la red
//El valor que se le descuenta es el mayor de la bolsa
                $insert_movimiento["monto"] = $request["rango_maximo"];
            } else {
//Si ocurre esto, la consulta se Hizo a un médico frecuente
                $insert_movimiento["monto"] = $request["precio_tarifa"];
            }

            if ((float) $insert_movimiento["monto"] < 0) {
                $this->setMsg(["msg" => "Error. Se produjo un error al actualizar el monto", "result" => false]);
                return false;
            }
            //      print($request["recompensa"]);
//si el monto es mayor a 0 cobramos en Stripe
            if ((float) $insert_movimiento["monto"] > 0) {
                $insert_movimiento["pendiente_stripe"] = 1;
            } else {
                $insert_movimiento["pendiente_stripe"] = 0;
            }

//si es pago de paciente empresa
            if ($paciente["is_paciente_empresa"] == 1) {
                $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
                $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);

//verificamos si tiene consultas disponibles en el plan
                if ($paciente_empresa["cant_videoconsulta"] < $plan_contratado["cant_videoconsulta"]) {
//verificamos si el programa esta bonificado si es consulta en la red
                    if ($consulta["tipo_consulta"] == "0") {

                        $filtro = $this->getManager("ManagerFiltrosBusquedaVideoConsulta")->getByField("videoconsulta_idvideoconsulta", $request["idvideoconsulta"]);

//verificamos si el medico está incluido en los planes cubiertos por la empresa
                        $programa_bonificado = $this->getManager("ManagerProgramaSaludExcepcion")->verificar_programa_bonificado($filtro["idprograma_categoria"], $paciente_empresa["empresa_idempresa"]);
                        if ($programa_bonificado) {
                            $insert_movimiento["debito_plan_empresa"] = 1;
                            $insert_movimiento["pendiente_stripe"] = 0; //no cobramos en stripe - Se debita del plan
                        }
                    }
//verificamos si el medico está bonificado si es consulta particular
                    if ($consulta["tipo_consulta"] == "1") {
//verificamos si el medico está incluido en los planes cubiertos por la empresa
                        $medico_bonificado = $this->getManager("ManagerProgramaSaludExcepcion")->verificar_medico_bonificado($consulta["medico_idmedico"], $paciente_empresa["empresa_idempresa"], $consulta["idprograma_categoria"]);
                        if ($medico_bonificado) {
                            $insert_movimiento["debito_plan_empresa"] = 1;
                            $insert_movimiento["pendiente_stripe"] = 0; //no cobramos en stripe - Se debita del plan
                        }
                    }
                }
            }

//registramos el metodo de pago de stripe
            if ($insert_movimiento["pendiente_stripe"] == 1) {
                if ($request["payment_method"] == "") {
                    $this->setMsg(["msg" => "Error. Se produjo un error al actualizar el monto", "result" => false]);
                    return false;
                }

                $insert_movimiento["stripe_payment_method"] = $request["payment_method"]; //id tarjeta utilizada para el cobro futuro
            }

            $insert = parent::insert($insert_movimiento);

            if ($insert) {
//debitamos una consulta realizada del plan empresa
                if ($insert_movimiento["debito_plan_empresa"] == 1) {
                    $record["cant_videoconsulta"] = (int) $paciente_empresa["cant_videoconsulta"] + 1;
                    $upd_paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->update($record, $paciente_empresa["idpaciente_empresa"]);

                    if (!$upd_paciente_empresa) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                        $this->setMsg(["msg" => "Error. No se pudo insertar el movimiento perteneciente a la publicación de la video consulta, intente nuevamente", "result" => false]);
                        return false;
                    }

                    $upd_vc = $ManagerVideoConsulta->update(["debito_plan_empresa" => 1], $request["idvideoconsulta"]);
                    if (!$upd_vc) {
                        $this->setMsg(["msg" => "Error. Se produjo un error al actualizar el monto", "result" => false]);
                        return false;
                    }
                }
                if ($insert_movimiento["pendiente_stripe"] == 1) {

                    $cobro_stripe = $ManagerCustomerStripe->process_cobro_consulta($request["idvideoconsulta"], $insert, "videoconsulta");
                    if (!$cobro_stripe) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                        $this->setMsg($ManagerCustomerStripe->getMsg());
                        return false;
                    }
                }



//Si se pudo crear el movimiento perteneciente a la CE, actualizo la cuenta del paciente
                $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaPaciente($paciente["idpaciente"]);
                if ($cuenta_update) {
                    return $insert;
                }
            }


//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
            $this->setMsg(["msg" => "Error. No se pudo insertar el movimiento perteneciente a la publicación de la video consulta, intente nuevamente", "result" => false]);
            return false;
        } else {
            $this->setMsg(["msg" => "Error. No posee cuenta en DoctorPlus.", "result" => false]);
            return false;
        }
    }

    /**
     * Método que realiza el proceso de la publicación del movimiento perteneciente a un turno 
     * de video llamada 
     * @param type $request
     * @return boolean
     */
    public function processMovimientoTurnoVideoConsulta($request) {

//Tengo que obtener la cuenta del paciente titular, porque es él el que tiene la cuenta en DP
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
        $ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
        if ($request["paciente_idpaciente"] == "") {
            $request["paciente_idpaciente"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];
        }
//Obtengo la cuenta del paciente, asociado a la consulta express... 
        $cuenta_paciente = $ManagerCuentaUsuario->getCuentaPaciente($request["paciente_idpaciente"]);
        $paciente = $ManagerPaciente->getPacienteTitular($request["paciente_idpaciente"]);

        $turno = $this->getManager("ManagerTurno")->get($request["idturno"]);

        if ($cuenta_paciente) {

//Tengo que descontar el dinero de la cuenta del paciente e insertarla en la cuenta de DP 
//DoctorPlus retendrá el dinero perteneciente a DP

            $insert_movimiento = [
                "fecha" => date("Y-m-d H:i:s"),
                "is_ingreso" => 0,
                "cuentaUsuario_idcuentaUsuario" => $cuenta_paciente["idcuentaUsuario"],
                "turno_idturno" => $request["idturno"],
                "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 6, //Publicación VideoConsulta
                "paciente_idpaciente" => $paciente["idpaciente"],
                "monto" => $request["monto"]
            ];

//si el monto es mayor a 0 cobramos en Stripe
            if ((float) $request["monto"] > 0) {
                $insert_movimiento["pendiente_stripe"] = 1;
            } else {
                $insert_movimiento["pendiente_stripe"] = 0;
            }


//si es pago de paciente empresa
            if ($paciente["is_paciente_empresa"] == 1) {
                $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
                $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);

//verificamos si tiene consultas disponibles en el plan
                if ($paciente_empresa["cant_videoconsulta"] < $plan_contratado["cant_videoconsulta"]) {
//verificamos si el medico está incluido en los planes cubiertos por la empresa
                    $medico_bonificado = $this->getManager("ManagerProgramaSaludExcepcion")->verificar_medico_bonificado($turno["medico_idmedico"], $paciente_empresa["empresa_idempresa"], $turno["idprograma_categoria"]);
                    if ($medico_bonificado) {
                        $insert_movimiento["debito_plan_empresa"] = 1;
                        $insert_movimiento["pendiente_stripe"] = 0; //no cobramos en stripe - Se debita del plan
                    }
                }
            }
//registramos el metodo de pago de stripe
            if ($insert_movimiento["pendiente_stripe"] == 1) {
                if ($request["payment_method"] == "") {
                    $this->setMsg(["msg" => "Error. Se produjo un error al actualizar el monto", "result" => false]);
                    return false;
                }

                $insert_movimiento["stripe_payment_method"] = $request["payment_method"]; //id tarjeta utilizada para el cobro futuro
            }

            $insert = parent::insert($insert_movimiento);

            if ($insert) {
//debitamos una consulta realizada del plan empresa
                if ($insert_movimiento["debito_plan_empresa"] == 1) {
                    $record["cant_videoconsulta"] = (int) $paciente_empresa["cant_videoconsulta"] + 1;
                    $upd_paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->update($record, $paciente_empresa["idpaciente_empresa"]);

                    if (!$upd_paciente_empresa) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                        $this->setMsg(["msg" => "Error. No se pudo insertar el movimiento perteneciente a la publicación de la video consulta, intente nuevamente", "result" => false]);
                        return false;
                    }
                }
                if ($insert_movimiento["pendiente_stripe"] == 1) {

                    $cobro_stripe = $ManagerCustomerStripe->process_cobro_consulta($request["idturno"], $insert, "turno");
                    if (!$cobro_stripe) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                        $this->setMsg($ManagerCustomerStripe->getMsg());
                        return false;
                    }
                }
//Si se pudo crear el movimiento perteneciente a la CE, actualizo la cuenta del paciente
                $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaPaciente($paciente["idpaciente"]);
                if ($cuenta_update) {
                    return $insert;
                }
            }
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
            $this->setMsg(["msg" => "Error. No se pudo insertar el movimiento perteneciente a la publicación de la video consulta, intente nuevamente", "result" => false]);
            return false;
        } else {
            $this->setMsg(["msg" => "Error. No posee cuenta en DoctorPlus.", "result" => false]);
            return false;
        }
    }

    /**
     * Método que realiza la devolucion de dinero de un turno de videoconsulta cuando el medico rechaza el turno
     * 
     * @param type $idturno
     */
    public function processDevolucionTurnoVideoConsulta($idturno) {
        ini_set('max_execution_time', '600');
        $turno = $this->getManager("ManagerTurno")->get($idturno);
        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);
        $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
        $videoconsulta = $ManagerVideoConsulta->getByField("turno_idturno", $idturno);
        if ($consultorio["is_virtual"] == "1" && $videoconsulta) {


//Tengo que obtener la cuenta del paciente titular, porque es él el que tiene la cuenta en DP
            $ManagerPaciente = $this->getManager("ManagerPaciente");

            $paciente = $ManagerPaciente->getPacienteTitular($turno["paciente_idpaciente"]);

//Obtengo la cuenta del paciente, asociado a la consulta express... 
            $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
            $cuenta_paciente = $ManagerCuentaUsuario->getCuentaPaciente($paciente["idpaciente"]);
//Obtengo el monto de la videoconsulta..
//verificamos si el turno de VC se saco mediante prestador
            if ($videoconsulta["prestador_idprestador"] != "") {

                $monto = $videoconsulta["precio_tarifa_prestador"];
            } else {
                $monto = $videoconsulta["precio_tarifa"];
            }

            if ($monto >= 0) {
                $insert_movimiento = [
                    "fecha" => date("Y-m-d H:i:s"),
                    "is_ingreso" => 1,
                    "cuentaUsuario_idcuentaUsuario" => $cuenta_paciente["idcuentaUsuario"],
                    "turno_idturno" => $turno["idturno"],
                    "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 7, //Devolucion turno videoconsulta
                    "paciente_idpaciente" => $paciente["idpaciente"],
                    "monto" => $monto
                ];
//marcamos si se debito de las consultas del plan empresa
                if ($paciente["is_paciente_empresa"] == 1 && $videoconsulta["debito_plan_empresa"] == 1) {
                    $insert_movimiento["debito_plan_empresa"] = 1;
                }

//Inserto el movimiento referido a la cuenta del paciente
                $insert = parent::insert($insert_movimiento);


                if ($insert) {
//devolvemos la consulta realizada del plan empresa
                    if ($paciente["is_paciente_empresa"] == 1 && $videoconsulta["debito_plan_empresa"] == 1) {
                        $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
                        $record["cant_videoconsulta"] = (int) $paciente_empresa["cant_videoconsulta"] - 1;
                        $upd_paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->update($record, $paciente_empresa["idpaciente_empresa"]);

                        if (!$upd_paciente_empresa) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                            $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
                            return false;
                        }
                    }
//Si se pudo crear el movimiento perteneciente a la CE, actualizo la cuenta del paciente
                    $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaPaciente($paciente["idpaciente"]);
                    if ($cuenta_update) {
                        $ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
                        $cobro_stripe = $ManagerCustomerStripe->reembolsar_cobro_consulta($turno["idturno"], $insert, "turno");
                        if (!$cobro_stripe) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                            $this->setMsg($ManagerCustomerStripe->getMsg());
                            return false;
                        }
                        return $insert;
                    }
                }
            }
        } else {

// si se está declinando un turno que no tiene aún la VC creada se devuelve igual. programamos excepción
            if ($consultorio["is_virtual"] == "1" && !$videoconsulta) {


//seteamos el precio de la videoconsulta
                $idpacienteTitular = $this->getManager("ManagerPaciente")->getPacienteTitular($turno["paciente_idpaciente"])["idpaciente"];

                $result_monto = $this->getManager("ManagerMovimientoCuenta")->getMontoVideoConsultaTurnoPaciente($idturno, $idpacienteTitular);
                $monto = $result_monto["monto"];

//Tengo que obtener la cuenta del paciente titular, porque es él el que tiene la cuenta en DP
                $ManagerPaciente = $this->getManager("ManagerPaciente");

                $paciente = $ManagerPaciente->getPacienteTitular($turno["paciente_idpaciente"]);

//Obtengo la cuenta del paciente, asociado a la consulta express... 
                $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
                $cuenta_paciente = $ManagerCuentaUsuario->getCuentaPaciente($paciente["idpaciente"]);
//Obtengo el monto de la videoconsulta..


                if ($monto >= 0) {
                    $insert_movimiento = [
                        "fecha" => date("Y-m-d H:i:s"),
                        "is_ingreso" => 1,
                        "cuentaUsuario_idcuentaUsuario" => $cuenta_paciente["idcuentaUsuario"],
                        "turno_idturno" => $turno["idturno"],
                        "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 7, //Devolucion turno videoconsulta
                        "paciente_idpaciente" => $paciente["idpaciente"],
                        "monto" => $monto
                    ];
//marcamos si se debito de las consultas del plan empresa
                    if ($paciente["is_paciente_empresa"] == 1 && $result_monto["debito_plan_empresa"] == 1) {
                        $insert_movimiento["debito_plan_empresa"] = 1;
                    }

//Inserto el movimiento referido a la cuenta del paciente
                    $insert = parent::insert($insert_movimiento);


                    if ($insert) {
//devolvemos la consulta realizada del plan empresa
                        if ($paciente["is_paciente_empresa"] == 1 && $result_monto["debito_plan_empresa"] == 1) {
                            $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
                            $record["cant_videoconsulta"] = (int) $paciente_empresa["cant_videoconsulta"] - 1;
                            $upd_paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->update($record, $paciente_empresa["idpaciente_empresa"]);

                            if (!$upd_paciente_empresa) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                                $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
                                return false;
                            }
                        }
//Si se pudo crear el movimiento perteneciente a la CE, actualizo la cuenta del paciente
                        $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaPaciente($paciente["idpaciente"]);
                        if ($cuenta_update) {
                            $ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
                            $cobro_stripe = $ManagerCustomerStripe->reembolsar_cobro_consulta($turno["idturno"], $insert, "turno");
                            if (!$cobro_stripe) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                                $this->setMsg($ManagerCustomerStripe->getMsg());
                                return false;
                            }
                            return $insert;
                        }
                    }
                }
            }
        }

        $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
        return false;
    }

    /**
     * Método que realiza el procesamiento de la diferencia de publicación,
     * Esto ocurre cuando se toma la tarifa máxima del rango elegida 
     * @param type $request
     */
    public function processDiferenciaPublicacionCE($request) {

        $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");

        $consulta_express = $ManagerConsultaExpress->get($request["idconsultaExpress"]);

//Para que se efectúe la devolución, tiene que haber sido en el primer mensaje del médico

        if ($consulta_express) {

//Tengo que obtener la cuenta del paciente titular, porque es él el que tiene la cuenta en DP
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->getPacienteTitular($request["paciente_idpaciente"]);


//Obtengo la cuenta del paciente, asociado a la consulta express... 
            $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
            $cuenta_paciente = $ManagerCuentaUsuario->getCuentaPaciente($paciente["idpaciente"]);

            if ($cuenta_paciente) {

//Obtengo el monto de la consulta express...
                $monto_consulta_express = $consulta_express["precio_tarifa"];

                $ManagerFiltrosBusquedaConsultaExpress = $this->getManager("ManagerFiltrosBusquedaConsultaExpress");
                $filtro_consulta_express = $ManagerFiltrosBusquedaConsultaExpress->getByField("consultaExpress_idconsultaExpress", $consulta_express["idconsultaExpress"]);


//Saco la diferencia, del monto de la consulta express con el rango mínimo del filtro...
                $diferencia_a_devolver = (float) $filtro_consulta_express["rango_maximo"] - (float) $monto_consulta_express;

//no debo devolver dinero si el monto es igual
                if ($diferencia_a_devolver == 0) {
                    return true;
                }
                if ($diferencia_a_devolver > 0) {
                    $insert_movimiento = [
                        "fecha" => date("Y-m-d H:i:s"),
                        "is_ingreso" => 1,
                        "cuentaUsuario_idcuentaUsuario" => $cuenta_paciente["idcuentaUsuario"],
                        "consultaExpress_idconsultaExpress" => $request["idconsultaExpress"],
                        "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 2, //Diferencia de tarifa
                        "paciente_idpaciente" => $paciente["idpaciente"],
                        "monto" => $diferencia_a_devolver
                    ];

//Inserto el movimiento referido a la cuenta del paciente
                    $insert = parent::insert($insert_movimiento);

                    if ($insert) {
//Si se pudo crear el movimiento perteneciente a la CE, actualizo la cuenta del paciente
                        $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaPaciente($paciente["idpaciente"]);
                        if ($cuenta_update) {
                            return $insert;
                        }
                    }
                }
            }
        }

        $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
        return false;
    }

    /**
     * Método que realiza el procesamiento de la diferencia de publicación de una videoconsulta,
     * Esto ocurre cuando se toma la tarifa máxima del rango elegida 
     * @param type $request
     */
    public function processDiferenciaPublicacionVC($request) {

        $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");

        $videoconsulta = $ManagerVideoConsulta->get($request["idvideoconsulta"]);

//Para que se efectúe la devolución, tiene que haber sido en el primer mensaje del médico

        if ($videoconsulta) {

//Tengo que obtener la cuenta del paciente titular, porque es él el que tiene la cuenta en DP
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->getPacienteTitular($request["paciente_idpaciente"]);


//Obtengo la cuenta del paciente, asociado a la consulta express... 
            $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
            $cuenta_paciente = $ManagerCuentaUsuario->getCuentaPaciente($paciente["idpaciente"]);

            if ($cuenta_paciente) {

//Obtengo el monto de la consulta express...
                $monto_videoconsulta = $videoconsulta["precio_tarifa"];

                $ManagerFiltrosBusquedaVideoConsulta = $this->getManager("ManagerFiltrosBusquedaVideoConsulta");
                $filtro_videoconsulta = $ManagerFiltrosBusquedaVideoConsulta->getByField("videoconsulta_idvideoconsulta", $videoconsulta["idvideoconsulta"]);


//Saco la diferencia, del monto de la consulta express con el rango mínimo del filtro...
                $diferencia_a_devolver = (float) $filtro_videoconsulta["rango_maximo"] - (float) $monto_videoconsulta;

//no debo devolver dinero si el monto es igual
                if ($diferencia_a_devolver == 0) {
                    return true;
                }
                if ($diferencia_a_devolver > 0) {
                    $insert_movimiento = [
                        "fecha" => date("Y-m-d H:i:s"),
                        "is_ingreso" => 1,
                        "cuentaUsuario_idcuentaUsuario" => $cuenta_paciente["idcuentaUsuario"],
                        "videoconsulta_idvideoconsulta" => $request["idvideoconsulta"],
                        "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 7, //Diferencia de tarifa
                        "paciente_idpaciente" => $paciente["idpaciente"],
                        "monto" => $diferencia_a_devolver
                    ];

//Inserto el movimiento referido a la cuenta del paciente
                    $insert = parent::insert($insert_movimiento);

                    if ($insert) {
//Si se pudo crear el movimiento perteneciente a la CE, actualizo la cuenta del paciente
                        $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaPaciente($paciente["idpaciente"]);
                        if ($cuenta_update) {
                            return $insert;
                        }
                    }
                }
            }
        }

        $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
        return false;
    }

    /**
     * Método encargado de procesar los movimientos referidos a la finalización de una consulta express
     * La consulta express será eliminada cuando se cierre la consulta desde la consulta express.
     * 
     * @param type $request
     */
    public function processFinalizacionCE($request) {
        $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
        $consulta_express = $ManagerConsultaExpress->get($request["idconsultaExpress"]);

        if ($consulta_express["estadoConsultaExpress_idestadoConsultaExpress"] != "2" && $consulta_express["estadoConsultaExpress_idestadoConsultaExpress"] != "4") {
            $this->setMsg(["msg" => "Error. La consulta no se encuentra abierta.", "result" => false]);

            return false;
        }

        $this->db->StartTrans();
        if ($consulta_express) {
            $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
            $cuenta_medico = $ManagerCuentaUsuario->getCuentaMedico($request["medico_idmedico"]);

            if ($cuenta_medico) {

// $monto = $consulta_express["prestador_idprestador"] != "" ? $consulta_express["precio_tarifa_prestador"] : $consulta_express["precio_tarifa"];
                $monto = $consulta_express["precio_tarifa"];

//Tengo que insertar el dinero por el monto de la tarifa de la consulta express al médico
                $insert_movimiento = [
                    "fecha" => date("Y-m-d H:i:s"),
                    "is_ingreso" => 1,
                    "cuentaUsuario_idcuentaUsuario" => $cuenta_medico["idcuentaUsuario"],
                    "consultaExpress_idconsultaExpress" => $request["idconsultaExpress"],
                    "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 1, // Consulta Express
                    "medico_idmedico" => $request["medico_idmedico"],
                    "monto" => (float) $monto
                ];
//Inserto el movimiento de finalización
                $insert = parent::insert($insert_movimiento);
                $insert2 = true;
//si la consulta tiene comision la insertamos como
                if ((float) $consulta_express["comision_doctor_plus"] > 0) {
                    $insert_comision_dp = [
                        "fecha" => date("Y-m-d H:i:s"),
                        "is_ingreso" => 0,
                        "cuentaUsuario_idcuentaUsuario" => $cuenta_medico["idcuentaUsuario"],
                        "consultaExpress_idconsultaExpress" => $request["idconsultaExpress"],
                        "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 4, // Comision DoctorPlus
                        "medico_idmedico" => $request["medico_idmedico"],
                        "monto" => (float) $consulta_express["comision_doctor_plus"]
                    ];
                    $insert2 = parent::insert($insert_comision_dp);
                }

                $insert3 = true;
//si la consulta tiene comision prestador la insertamos como
                if ((float) $consulta_express["precio_tarifa_prestador"] > 0) {
                    $insert_prestador = [
                        "fecha" => date("Y-m-d H:i:s"),
                        "is_ingreso" => 0,
                        "cuentaUsuario_idcuentaUsuario" => $cuenta_medico["idcuentaUsuario"],
                        "consultaExpress_idconsultaExpress" => $request["idconsultaExpress"],
                        "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 9, // Comision Prestador
                        "medico_idmedico" => $request["medico_idmedico"],
                        "monto" => (float) $monto - (float) $consulta_express["precio_tarifa_prestador"]
                    ];
                    $insert3 = parent::insert($insert_prestador);
                }

//actualizamos las consultas del periodo que se acreditas
                $acutualizar_periodo = $this->getManager("ManagerPeriodoPago")->actualizarValoresFromCierreCE();
                if ($insert && $insert2 && $acutualizar_periodo) {
//Si se pudo crear el movimiento perteneciente a la CE, actualizo la cuenta del paciente
                    $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaMedico($request["medico_idmedico"]);
                    if ($cuenta_update) {

                        $this->db->CompleteTrans();
                        return $insert;
                    }
                } else {

//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                    $this->setMsg(["msg" => "Error. No se pudo insertar el movimiento perteneciente a la publicación de la consulta express, intente nuevamente", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            } else {
                $this->setMsg(["msg" => "Error. No posee cuenta en DoctorPlus.", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }

        $this->db->FailTrans();
        $this->db->CompleteTrans();
        $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
        return false;
    }

    /**
     * Método encargado de procesar los movimientos referidos a la finalización de una videoconsulta
     * 
     * 
     * @param type $request
     */
    public function processFinalizacionVC($request) {

        $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
        $videoconsulta = $ManagerVideoConsulta->get($request["idvideoconsulta"]);

        $this->db->StartTrans();
        if ($videoconsulta) {

            $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
            $cuenta_medico = $ManagerCuentaUsuario->getCuentaMedico($request["medico_idmedico"]);

            if ($cuenta_medico) {

//$monto = $videoconsulta["prestador_idprestador"] != "" ? $videoconsulta["precio_tarifa_prestador"] : $videoconsulta["precio_tarifa"];
                $monto = $videoconsulta["precio_tarifa"];

//Tengo que insertar el dinero por el monto de la tarifa de la video consulta al médico
                $insert_movimiento = [
                    "fecha" => date("Y-m-d H:i:s"),
                    "is_ingreso" => 1,
                    "cuentaUsuario_idcuentaUsuario" => $cuenta_medico["idcuentaUsuario"],
                    "videoconsulta_idvideoconsulta" => $request["idvideoconsulta"],
                    "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 6, // Video Consulta
                    "medico_idmedico" => $request["medico_idmedico"],
                    "monto" => $monto
                ];

//Inserto el movimiento de finalización
                $insert = parent::insert($insert_movimiento);
                $insert2 = true;
//si la consulta tiene comision la insertamos como
                if ((float) $videoconsulta["comision_doctor_plus"] > 0) {
                    $insert_devolucion = [
                        "fecha" => date("Y-m-d H:i:s"),
                        "is_ingreso" => 0,
                        "cuentaUsuario_idcuentaUsuario" => $cuenta_medico["idcuentaUsuario"],
                        "videoconsulta_idvideoconsulta" => $request["idvideoconsulta"],
                        "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 4, // Comision DoctorPlus
                        "medico_idmedico" => $request["medico_idmedico"],
                        "monto" => (float) $videoconsulta["comision_doctor_plus"]
                    ];
                    $insert2 = parent::insert($insert_devolucion);
                }

                $insert3 = true;
//si la consulta tiene comision prestador la insertamos como
                if ((float) $videoconsulta["precio_tarifa_prestador"] > 0) {
                    $insert_prestador = [
                        "fecha" => date("Y-m-d H:i:s"),
                        "is_ingreso" => 0,
                        "cuentaUsuario_idcuentaUsuario" => $cuenta_medico["idcuentaUsuario"],
                        "videoconsulta_idvideoconsulta" => $request["idvideoconsulta"],
                        "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 9, // Comision Prestador
                        "medico_idmedico" => $request["medico_idmedico"],
                        "monto" => (float) $monto - (float) $videoconsulta["precio_tarifa_prestador"]
                    ];
                    $insert3 = parent::insert($insert_prestador);
                }
//actualizamos las consultas del periodo que se acreditas
//$idmedico para el medico se obtiene de sesion, para el paciente se pasa por parametro desde la videoconsulta que se finaliza
                if (CONTROLLER == "medico") {

                    $acutualizar_periodo = $this->getManager("ManagerPeriodoPago")->actualizarValoresFromCierreVC();
                } else {
                    $acutualizar_periodo = $this->getManager("ManagerPeriodoPago")->actualizarValoresFromCierreVC($request["medico_idmedico"]);
                }
                if ($insert && $insert2 && $acutualizar_periodo) {


//Si se pudo crear el movimiento perteneciente a la CE, actualizo la cuenta del paciente
                    $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaMedico($request["medico_idmedico"]);
                    if ($cuenta_update) {

                        $this->db->CompleteTrans();
                        return $insert;
                    }
                } else {

//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                    $this->setMsg(["msg" => "Error. No se pudo insertar el movimiento perteneciente a la publicación de la video consulta, intente nuevamente", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            } else {
                $this->setMsg(["msg" => "Error. No posee cuenta en DoctorPlus.", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }

        $this->db->FailTrans();
        $this->db->CompleteTrans();
        $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
        return false;
    }

    /**
     * Método encargado de procesar los movimientos referidos a la facutracion de una consulta con reintegro
     * 
     * 
     * @param type $request
     */
    public function processFacturacionReintegro($request) {

        $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
        $videoconsulta = $ManagerVideoConsulta->get($request["idvideoconsulta"]);

        $this->db->StartTrans();
        if ($videoconsulta) {

            $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
            $cuenta_medico = $ManagerCuentaUsuario->getCuentaMedico($request["medico_idmedico"]);

            if ($cuenta_medico) {


//si la consulta tiene comision la insertamos como
                if ((float) $videoconsulta["comision_doctor_plus"] > 0) {
                    $insert_devolucion = [
                        "fecha" => date("Y-m-d H:i:s"),
                        "is_ingreso" => 0,
                        "cuentaUsuario_idcuentaUsuario" => $cuenta_medico["idcuentaUsuario"],
                        "videoconsulta_idvideoconsulta" => $request["idvideoconsulta"],
                        "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 4, // Comision DoctorPlus
                        "medico_idmedico" => $request["medico_idmedico"],
                        "monto" => (float) $videoconsulta["comision_doctor_plus"]
                    ];
                    $insert = parent::insert($insert_devolucion);
                }



//actualizamos las consultas del periodo que se acreditas
//$idmedico para el medico se obtiene de sesion, para el paciente se pasa por parametro desde la videoconsulta que se finaliza
                if (CONTROLLER == "medico") {

                    $acutualizar_periodo = $this->getManager("ManagerPeriodoPago")->actualizarValoresFromCierreVC();
                } else {
                    $acutualizar_periodo = $this->getManager("ManagerPeriodoPago")->actualizarValoresFromCierreVC($request["medico_idmedico"]);
                }

                if ($insert) {


//Si se pudo crear el movimiento perteneciente a la CE, actualizo la cuenta del paciente
                    $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaMedico($request["medico_idmedico"]);
                    if ($cuenta_update) {

                        $this->db->CompleteTrans();
                        return $insert;
                    }
                } else {

//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                    $this->setMsg(["msg" => "Error. No se pudo insertar el movimiento perteneciente a la publicación de la video consulta, intente nuevamente", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            } else {
                $this->setMsg(["msg" => "Error. No posee cuenta en DoctorPlus.", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }

        $this->db->FailTrans();
        $this->db->CompleteTrans();
        $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
        return false;
    }

    /**
     * Método encargado de procesar los movimientos referidos a la finalización de una videoconsulta cuando el paciente es ALD
     * 
     * 
     * @param type $request
     */
    public function processDevolucionVCPacienteALD($request) {

        $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
        $videoconsulta = $ManagerVideoConsulta->get($request["idvideoconsulta"]);

        $this->db->StartTrans();
        if ($videoconsulta) {
//Tengo que obtener la cuenta del paciente titular, porque es él el que tiene la cuenta en DP
            $ManagerPaciente = $this->getManager("ManagerPaciente");

            $paciente = $ManagerPaciente->getPacienteTitular($videoconsulta["paciente_idpaciente"]);
            $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
            $cuenta_paciente = $ManagerCuentaUsuario->getCuentaPaciente($paciente["idpaciente"]);

            if ($cuenta_paciente) {

//$monto = $videoconsulta["prestador_idprestador"] != "" ? $videoconsulta["precio_tarifa_prestador"] : $videoconsulta["precio_tarifa"];
                $monto = $videoconsulta["precio_tarifa"];

//Tengo que insertar el dinero por el monto de la tarifa de la video consulta al médico
                $insert_movimiento = [
                    "fecha" => date("Y-m-d H:i:s"),
                    "is_ingreso" => 1,
                    "cuentaUsuario_idcuentaUsuario" => $cuenta_paciente["idcuentaUsuario"],
                    "videoconsulta_idvideoconsulta" => $request["idvideoconsulta"],
                    "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 10, //Devolución VC
                    "paciente_idpaciente" => $paciente["idpaciente"],
                    "monto" => $monto
                ];

//Inserto el movimiento referido a la cuenta del paciente
                $insert = parent::insert($insert_movimiento);

                if ($insert) {
//Si se pudo crear el movimiento perteneciente a la VC, actualizo la cuenta del paciente
                    $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaPaciente($paciente["idpaciente"]);

                    if ($cuenta_update) {
//devolvemos el dinero de la consulta
                        $ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
                        if ($videoconsulta["turno_idturno"] != "") {
                            $cobro_stripe = $ManagerCustomerStripe->reembolsar_cobro_consulta($videoconsulta["turno_idturno"], $insert, "turno");
                        } else {
                            $cobro_stripe = $ManagerCustomerStripe->reembolsar_cobro_consulta($request["idvideoconsulta"], $insert, "videoconsulta");
                        }
                        if (!$cobro_stripe) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                            $this->setMsg($ManagerCustomerStripe->getMsg());
                            return false;
                        }
                        $this->db->CompleteTrans();
                        return $insert;
                    }
                }
            } else {
                $this->setMsg(["msg" => "Error. No posee cuenta en DoctorPlus.", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }

        $this->db->FailTrans();
        $this->db->CompleteTrans();
        $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
        return false;
    }

    /**
     * Método encargado de procesar los movimientos referidos devolucion una videoconsulta cuando el paciente es ALD
     * 
     * 
     * @param type $request
     */
    public function processDevolucionVCMedicoALD($request) {

        $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
        $videoconsulta = $ManagerVideoConsulta->get($request["idvideoconsulta"]);

        $this->db->StartTrans();
        if ($videoconsulta) {
//Tengo que obtener la cuenta del medico



            $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
            $cuenta_medico = $ManagerCuentaUsuario->getCuentaMedico($videoconsulta["medico_idmedico"]);

            if ($cuenta_medico) {

//$monto = $videoconsulta["prestador_idprestador"] != "" ? $videoconsulta["precio_tarifa_prestador"] : $videoconsulta["precio_tarifa"];
                $monto = $videoconsulta["precio_tarifa"];

//Tengo que insertar el dinero por el monto de la tarifa de la video consulta al médico
                $insert_movimiento = [
                    "fecha" => date("Y-m-d H:i:s"),
                    "is_ingreso" => 0,
                    "cuentaUsuario_idcuentaUsuario" => $cuenta_medico["idcuentaUsuario"],
                    "videoconsulta_idvideoconsulta" => $request["idvideoconsulta"],
                    "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 10, //Devolución VC Paciente ALD
                    "medico_idmedico" => $videoconsulta["medico_idmedico"],
                    "monto" => $monto
                ];

//Inserto el movimiento referido a la cuenta del paciente
                $insert = parent::insert($insert_movimiento);

                if ($insert) {
//Si se pudo crear el movimiento perteneciente a la VC, actualizo la cuenta del paciente
                    $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaMedico($videoconsulta["medico_idmedico"]);

                    if ($cuenta_update) {
                        $this->db->CompleteTrans();
                        return $insert;
                    }
                }
            } else {
                $this->setMsg(["msg" => "Error. No posee cuenta en DoctorPlus.", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }

        $this->db->FailTrans();
        $this->db->CompleteTrans();
        $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
        return false;
    }

    /**
     * Método que realiza el procesamiento del rechazo de una consulta express
     * Esto ocurre cuando se toma la tarifa máxima del rango elegida 
     * @param type $request
     */
    public function processRechazarPublicacionCE($request) {
        ini_set('max_execution_time', '600');
        $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");

        $consulta_express = $ManagerConsultaExpress->get($request["idconsultaExpress"]);

        if ($consulta_express) {

//Tengo que obtener la cuenta del paciente titular, porque es él el que tiene la cuenta en DP
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->getPacienteTitular($consulta_express["paciente_idpaciente"]);

//Obtengo la cuenta del paciente, asociado a la consulta express... 
            $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
            $cuenta_paciente = $ManagerCuentaUsuario->getCuentaPaciente($paciente["idpaciente"]);
            if ($cuenta_paciente) {
//Obtengo el monto de la consulta express...
                $monto_consulta_express = (float) $consulta_express["precio_tarifa"];


                if ($monto_consulta_express >= 0) {
                    $insert_movimiento = [
                        "fecha" => date("Y-m-d H:i:s"),
                        "is_ingreso" => 1,
                        "cuentaUsuario_idcuentaUsuario" => $cuenta_paciente["idcuentaUsuario"],
                        "consultaExpress_idconsultaExpress" => $request["idconsultaExpress"],
                        "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 2, //Devolucion Consulta Express
                        "paciente_idpaciente" => $paciente["idpaciente"],
                        "monto" => $monto_consulta_express
                    ];

//verificamos si se debito del plan o la pago el paciente
                    if ($paciente["is_paciente_empresa"] == 1 && $consulta_express["debito_plan_empresa"] == 1) {
                        $insert_movimiento["debito_plan_empresa"] = 1;
                    }
//Inserto el movimiento referido a la cuenta del paciente
                    $insert = parent::insert($insert_movimiento);

                    if ($insert) {
//devolvemos la consulta realizada del plan empresa
                        if ($paciente["is_paciente_empresa"] == 1 && $consulta_express["debito_plan_empresa"] == 1) {
                            $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
                            $record["cant_consultaexpress"] = (int) $paciente_empresa["cant_consultaexpress"] - 1;
                            $upd_paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->update($record, $paciente_empresa["idpaciente_empresa"]);

                            if (!$upd_paciente_empresa) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                                $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
                                return false;
                            }
                        }


//Si se pudo crear el movimiento perteneciente a la CE, actualizo la cuenta del paciente
                        $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaPaciente($paciente["idpaciente"]);
                        if ($cuenta_update) {
//devolvemos el dinero de la consulta
                            $ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
                            $cobro_stripe = $ManagerCustomerStripe->reembolsar_cobro_consulta($request["idconsultaExpress"], $insert, "consultaexpress");
                            if (!$cobro_stripe) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                                $this->setMsg($ManagerCustomerStripe->getMsg());
                                return false;
                            }

                            return $insert;
                        }
                    }
                }
            }
        }

        $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
        return false;
    }

    /**
     * Método que realiza el procesamiento del rechazo de una video consulta
     * Esto ocurre cuando se toma la tarifa máxima del rango elegida 
     * @param type $request
     */
    public function processRechazarPublicacionVC($request) {
        ini_set('max_execution_time', '600');
        $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");

        $videoconsulta = $ManagerVideoConsulta->get($request["idvideoconsulta"]);

        if ($videoconsulta) {

//Tengo que obtener la cuenta del paciente titular, porque es él el que tiene la cuenta en DP
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->getPacienteTitular($videoconsulta["paciente_idpaciente"]);

//Obtengo la cuenta del paciente, asociado a la video consulta... 
            $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
            $cuenta_paciente = $ManagerCuentaUsuario->getCuentaPaciente($paciente["idpaciente"]);
            if ($cuenta_paciente) {
//Obtengo el monto de la video consulta...
                /* if ((float) $videoconsulta["tipo_consulta"] == 0) {
                  $ManagerFiltrosBusquedaVideoConsulta = $this->getManager("ManagerFiltrosBusquedaVideoConsulta");
                  $filtro = $ManagerFiltrosBusquedaVideoConsulta->getByField("videoconsulta_idvideoconsulta", $videoconsulta["idvideoconsulta"]);

                  if ($filtro && (float) $filtro["rango_maximo"] >= 0) {
                  $monto_videoconsulta = $filtro["rango_maximo"];
                  } else {
                  return false;
                  }
                  } else {
                  $monto_videoconsulta = (float) $videoconsulta["precio_tarifa"];
                  } */
                $monto_videoconsulta = (float) $videoconsulta["precio_tarifa"];

                if ($monto_videoconsulta >= 0) {
                    $insert_movimiento = [
                        "fecha" => date("Y-m-d H:i:s"),
                        "is_ingreso" => 1,
                        "cuentaUsuario_idcuentaUsuario" => $cuenta_paciente["idcuentaUsuario"],
                        "videoconsulta_idvideoconsulta" => $request["idvideoconsulta"],
                        "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 7, // Devolucion Consulta Express
                        "paciente_idpaciente" => $paciente["idpaciente"],
                        "monto" => $monto_videoconsulta
                    ];
                    if ($paciente["is_paciente_empresa"] == 1 && $videoconsulta["debito_plan_empresa"] == 1) {
                        $insert_movimiento["debito_plan_empresa"] = 1;
                    }
//Inserto el movimiento referido a la cuenta del paciente
                    $insert = parent::insert($insert_movimiento);

                    if ($insert) {
//devolvemos la consulta realizada del plan empresa
                        if ($paciente["is_paciente_empresa"] == 1 && $videoconsulta["debito_plan_empresa"] == 1) {
                            $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
                            $record["cant_videoconsulta"] = (int) $paciente_empresa["cant_videoconsulta"] - 1;
                            $upd_paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->update($record, $paciente_empresa["idpaciente_empresa"]);

                            if (!$upd_paciente_empresa) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                                $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
                                return false;
                            }
                        }
//Si se pudo crear el movimiento perteneciente a la VC, actualizo la cuenta del paciente
                        $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaPaciente($paciente["idpaciente"]);
                        if ($cuenta_update) {
//devolvemos el dinero de la consulta
                            $ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
                            if ($videoconsulta["turno_idturno"] != "") {
                                $cobro_stripe = $ManagerCustomerStripe->reembolsar_cobro_consulta($videoconsulta["turno_idturno"], $insert, "turno");
                            } else {
                                $cobro_stripe = $ManagerCustomerStripe->reembolsar_cobro_consulta($request["idvideoconsulta"], $insert, "videoconsulta");
                            }
                            if (!$cobro_stripe) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                                $this->setMsg($ManagerCustomerStripe->getMsg());
                                return false;
                            }

                            return $insert;
                        }
                    }
                }
            }
        }

        $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
        return false;
    }

    /**
     * Método que realiza el procesamiento del vencimiento de la consulta express..
     * @param type $request
     * @return boolean
     */
    public function processVencimientoCE($request) {
        ini_set('max_execution_time', '600');
        $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");

        $consulta_express = $ManagerConsultaExpress->get($request["idconsultaExpress"]);
//verifico que no este vencida
        if ($consulta_express["estadoConsultaExpress_idestadoConsultaExpress"] != "5") {

            if ((int) $consulta_express["tipo_consulta"] == 0) {
                $ManagerFiltrosBusquedaConsultaExpress = $this->getManager("ManagerFiltrosBusquedaConsultaExpress");
                $filtro = $ManagerFiltrosBusquedaConsultaExpress->getByField("consultaExpress_idconsultaExpress", $consulta_express["idconsultaExpress"]);

                if ($filtro && (int) $filtro["rango_maximo"] >= 0) {
                    $monto = $filtro["rango_maximo"];
                } else {
                    return false;
                }
            } else {
                $monto = $consulta_express["precio_tarifa"];
            }

//Tengo que obtener la cuenta del paciente titular, porque es él el que tiene la cuenta en DP
            $ManagerPaciente = $this->getManager("ManagerPaciente");

            $paciente = $ManagerPaciente->getPacienteTitular($consulta_express["paciente_idpaciente"]);

//Obtengo la cuenta del paciente, asociado a la consulta express... 
            $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
            $cuenta_paciente = $ManagerCuentaUsuario->getCuentaPaciente($paciente["idpaciente"]);

            if ($paciente && $cuenta_paciente) {

                $insert_movimiento = [
                    "fecha" => date("Y-m-d H:i:s"),
                    "is_ingreso" => 1,
                    "cuentaUsuario_idcuentaUsuario" => $cuenta_paciente["idcuentaUsuario"],
                    "consultaExpress_idconsultaExpress" => $request["idconsultaExpress"],
                    "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 2, //Devolución CE
                    "paciente_idpaciente" => $paciente["idpaciente"],
                    "monto" => $monto
                ];

                if ($paciente["is_paciente_empresa"] == 1 && $consulta_express["debito_plan_empresa"] == 1) {
                    $insert_movimiento["debito_plan_empresa"] = 1;
                }
//Inserto el movimiento referido a la cuenta del paciente
                $insert = parent::insert($insert_movimiento);

                if ($insert) {

//devolvemos la consulta realizada del plan empresa
                    if ($paciente["is_paciente_empresa"] == 1 && $consulta_express["debito_plan_empresa"] == 1) {
                        $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
                        $record["cant_consultaexpress"] = (int) $paciente_empresa["cant_consultaexpress"] - 1;
                        $upd_paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->update($record, $paciente_empresa["idpaciente_empresa"]);

                        if (!$upd_paciente_empresa) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                            $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
                            return false;
                        }
                    }
//Si se pudo crear el movimiento perteneciente a la CE, actualizo la cuenta del paciente
                    $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaPaciente($paciente["idpaciente"]);
                    if ($cuenta_update) {
                        $ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
                        $cobro_stripe = $ManagerCustomerStripe->reembolsar_cobro_consulta($request["idconsultaExpress"], $insert, "consultaexpress");
                        if (!$cobro_stripe) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                            $this->setMsg($ManagerCustomerStripe->getMsg());
                            return false;
                        }
                        return $insert;
                    }
                }
            }
        }
        $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
        return false;
    }

    /**
     * Método que realiza el procesamiento del vencimiento de la videoconsulta..
     * @param type $request
     * @return boolean
     */
    public function processVencimientoVC($request) {
        ini_set('max_execution_time', '600');
        $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");

        $videoconsulta = $ManagerVideoConsulta->get($request["idvideoconsulta"]);
//verifico que no este vencida

        if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != "5") {

            if ((int) $videoconsulta["tipo_consulta"] == 0) {
                $ManagerFiltrosBusquedaVideoConsulta = $this->getManager("ManagerFiltrosBusquedaVideoConsulta");
                $filtro = $ManagerFiltrosBusquedaVideoConsulta->getByField("videoconsulta_idvideoconsulta", $videoconsulta["idvideoconsulta"]);

                if ($filtro && (int) $filtro["rango_maximo"] >= 0) {
                    $monto = $filtro["rango_maximo"];
                } else {
                    return false;
                }
            } else {
                $monto = $videoconsulta["precio_tarifa"];
            }

//Tengo que obtener la cuenta del paciente titular, porque es él el que tiene la cuenta en DP
            $ManagerPaciente = $this->getManager("ManagerPaciente");

            $paciente = $ManagerPaciente->getPacienteTitular($videoconsulta["paciente_idpaciente"]);

//Obtengo la cuenta del paciente, asociado a la consulta express... 
            $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
            $cuenta_paciente = $ManagerCuentaUsuario->getCuentaPaciente($paciente["idpaciente"]);


            if ($paciente && $cuenta_paciente) {

                $insert_movimiento = [
                    "fecha" => date("Y-m-d H:i:s"),
                    "is_ingreso" => 1,
                    "cuentaUsuario_idcuentaUsuario" => $cuenta_paciente["idcuentaUsuario"],
                    "videoconsulta_idvideoconsulta" => $request["idvideoconsulta"],
                    "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => 7, //Devolución VC
                    "paciente_idpaciente" => $paciente["idpaciente"],
                    "monto" => $monto
                ];
                if ($paciente["is_paciente_empresa"] == 1 && $videoconsulta["debito_plan_empresa"] == 1) {
                    $insert_movimiento["debito_plan_empresa"] = 1;
                }
//Inserto el movimiento referido a la cuenta del paciente
                $insert = parent::insert($insert_movimiento);

                if ($insert) {
//devolvemos la consulta realizada del plan empresa
                    if ($paciente["is_paciente_empresa"] == 1 && $videoconsulta["debito_plan_empresa"] == 1) {
                        $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
                        $record["cant_videoconsulta"] = (int) $paciente_empresa["cant_videoconsulta"] - 1;
                        $upd_paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->update($record, $paciente_empresa["idpaciente_empresa"]);

                        if (!$upd_paciente_empresa) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                            $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
                            return false;
                        }
                    }
//Si se pudo crear el movimiento perteneciente a la VC, actualizo la cuenta del paciente
                    $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaPaciente($paciente["idpaciente"]);

                    if ($cuenta_update) {
                        $ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
                        if ($videoconsulta["turno_idturno"] != "") {
                            $cobro_stripe = $ManagerCustomerStripe->reembolsar_cobro_consulta($videoconsulta["turno_idturno"], $insert, "turno");
                        } else {
                            $cobro_stripe = $ManagerCustomerStripe->reembolsar_cobro_consulta($videoconsulta["idvideoconsulta"], $insert, "videoconsulta");
                        }

                        if (!$cobro_stripe) {
//Si se produjo un error en cualquiera de los pasos anteriores, retorno falso
                            $this->setMsg($ManagerCustomerStripe->getMsg());
                            return false;
                        }
                        return $insert;
                    }
                }
            }
        }

        $this->setMsg(["msg" => "Error. No se pudo procesar el movimiento a la cuenta", "result" => false]);
        return false;
    }

    /**
     * Método que retorna el listado de movimientos del paciente 
     * @return boolean
     */
    public function getListadoMovimientosPaciente($request, $idpaginate = null) {

        $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];

        if ($idpaciente) {
            if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
                $this->resetPaginate($idpaginate);
            }

            if (!is_null($idpaginate)) {
                $this->paginate($idpaginate, 20);
            }

//Seteo el current page
            $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
            SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);
//obtenemos los movimientos de consultaexpress
            $queryCE = new AbstractSql();
            $queryCE->setSelect("
                                    mc.*,
                                    ce.medico_idmedico as idmedico,
                                    uw.nombre as nombre_medico,
                                    uw.apellido as apellido_medico,
                                    tp.titulo_profesional,
                                    ce.tipo_consulta,
                                    ce.prestador_idprestador,
                                    CONCAT(dmc.detalleMovimientoCuenta,' ','Nº',ce.numeroConsultaExpress) as detalleMovimientoCuenta
                                ");
            $queryCE->setFrom("$this->table mc 
                                INNER JOIN detallemovimientocuenta dmc ON (mc.detalleMovimientoCuenta_iddetalleMovimientoCuenta = dmc.iddetalleMovimientoCuenta)
                                INNER JOIN consultaexpress ce ON (ce.idconsultaExpress = mc.consultaExpress_idconsultaExpress)
                                LEFT JOIN medico m ON (ce.medico_idmedico = m.idmedico)
                                LEFT JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                                LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                        ");
            $queryCE->setWhere("mc.paciente_idpaciente = $idpaciente");
//obtenemos los movimientos de videoconsulta
            $queryVC = new AbstractSql();
            $queryVC->setSelect("
                                    mc.*,
                                    vc.medico_idmedico as idmedico,
                                    uw.nombre as nombre_medico,
                                    uw.apellido as apellido_medico,
                                    tp.titulo_profesional,
                                    vc.tipo_consulta,
                                    vc.prestador_idprestador,
                                    CONCAT(dmc.detalleMovimientoCuenta,' ','Nº',vc.numeroVideoConsulta) as detalleMovimientoCuenta
                                ");
            $queryVC->setFrom("$this->table mc 
                                INNER JOIN detallemovimientocuenta dmc ON (mc.detalleMovimientoCuenta_iddetalleMovimientoCuenta = dmc.iddetalleMovimientoCuenta)
                                INNER JOIN videoconsulta vc ON (vc.idvideoconsulta = mc.videoconsulta_idvideoconsulta)
                                LEFT JOIN medico m ON (vc.medico_idmedico = m.idmedico)
                                LEFT JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                                LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                        ");
            $queryVC->setWhere("mc.paciente_idpaciente = $idpaciente");

//obtenemos los movimientos de turnos
            $queryTRN = new AbstractSql();
            $queryTRN->setSelect("
                                    mc.*,
                                    trn.medico_idmedico as idmedico,
                                    uw.nombre as nombre_medico,
                                    uw.apellido as apellido_medico,
                                    tp.titulo_profesional,
                                    '' as tipo_consulta,
                                    trn.prestador_idprestador,
                                   CONCAT(dmc.detalleMovimientoCuenta,' (sur RDV) ','Nº',mc.turno_idturno) as detalleMovimientoCuenta
                                ");
            $queryTRN->setFrom("$this->table mc 
                                INNER JOIN detallemovimientocuenta dmc ON (mc.detalleMovimientoCuenta_iddetalleMovimientoCuenta = dmc.iddetalleMovimientoCuenta)
                                INNER JOIN turno trn ON (trn.idturno = mc.turno_idturno)
                                LEFT JOIN medico m ON (trn.medico_idmedico = m.idmedico)
                                LEFT JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                                LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                        ");

            $queryTRN->setWhere("mc.paciente_idpaciente = $idpaciente");

//obtenemos los otros movimientos
            $query2 = new AbstractSql();
            $query2->setSelect("
                                    mc.*,
                                    '' as idmedico,
                                    '' as nombre_medico,
                                    '' as apellido_medico,
                                    '' as titulo_profesional,
                                    '' as tipo_consulta,
                                    '' as prestador_idprestador,
                                    dmc.detalleMovimientoCuenta
                                ");
            $query2->setFrom("$this->table mc 
                                INNER JOIN detallemovimientocuenta dmc ON (mc.detalleMovimientoCuenta_iddetalleMovimientoCuenta = dmc.iddetalleMovimientoCuenta)
                               
                        ");
            $query2->setWhere("mc.paciente_idpaciente = $idpaciente");
            $query2->addAnd("turno_idturno is null and videoconsulta_idvideoconsulta is null and consultaExpress_idconsultaExpress is NULL");

            $query = new AbstractSql();
            $query->setSelect("*");
            $query->setFrom("((" . $queryCE->getSql() . ")UNION(" . $queryVC->getSql() . ")UNION(" . $queryTRN->getSql() . ")UNION(" . $query2->getSql() . "))as t");
            $query->setOrderBy("t.fecha DESC");

            $listado = $this->getListPaginado($query, $idpaginate);
            $ManagerPrestador = $this->getManager("ManagerPrestador");
            foreach ($listado["rows"] as $key => $movimiento) {

                if ($movimiento["prestador_idprestador"] != "") {
                    $prestador = $ManagerPrestador->get($movimiento["prestador_idprestador"]);
                    $listado["rows"][$key]["prestador"] = "({$prestador["nombre"]})";
                }
            }
            if (count($listado["rows"]) > 0) {
                return $listado;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * Método que retorna el listado de movimientos del paciente en formato json
     * @return boolean
     */
    public function getListadoMovimientosPacienteJson($request, $idpaginate = null) {

        $idpaciente = $request["idpaciente"];

        if ($idpaciente) {
            if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
                $this->resetPaginate($idpaginate);
            }

            if (!is_null($idpaginate)) {
                $this->paginate($idpaginate, 100);
            }

//Seteo el current page
            $request["current_page"] = $request["page"] != "" ? $request["page"] : 1;
            SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);
//obtenemos los movimientos de consultaexpress
            $queryCE = new AbstractSql();
            $queryCE->setSelect("
                                   	mc.idmovimientoCuenta,
                                        mc.fecha,
                                        if(mc.is_ingreso=1,if(mc.debito_plan_empresa=1,'+1 Consulta por chat',concat('+',mc.monto)),if(mc.debito_plan_empresa=1,'-1 Consulta por chat',concat('-',mc.monto))) as monto,
                                        concat(tp.titulo_profesional,'',uw.nombre,' ',uw.apellido) AS nombre_medico,
                                        CONCAT( dmc.detalleMovimientoCuenta, ' ', 'Nº', ce.numeroConsultaExpress ) AS detalleMovimientoCuenta 
                                ");
            $queryCE->setFrom("$this->table mc 
                                INNER JOIN detallemovimientocuenta dmc ON (mc.detalleMovimientoCuenta_iddetalleMovimientoCuenta = dmc.iddetalleMovimientoCuenta)
                                INNER JOIN consultaexpress ce ON (ce.idconsultaExpress = mc.consultaExpress_idconsultaExpress)
                                LEFT JOIN medico m ON (ce.medico_idmedico = m.idmedico)
                                LEFT JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                                LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                        ");
            $queryCE->setWhere("mc.paciente_idpaciente = $idpaciente");
//obtenemos los movimientos de videoconsulta
            $queryVC = new AbstractSql();
            $queryVC->setSelect("
                                    	mc.idmovimientoCuenta,
                                        mc.fecha,
                                        if(mc.is_ingreso=1,if(mc.debito_plan_empresa=1,'+1 Consulta por video',concat('+',mc.monto)),if(mc.debito_plan_empresa=1,'-1 Consulta por video',concat('-',mc.monto))) as monto,
					concat(tp.titulo_profesional,'',uw.nombre,' ',uw.apellido) AS nombre_medico,
                                        CONCAT( dmc.detalleMovimientoCuenta, ' ', 'Nº', vc.numeroVideoConsulta ) AS detalleMovimientoCuenta 
                                ");
            $queryVC->setFrom("$this->table mc 
                                INNER JOIN detallemovimientocuenta dmc ON (mc.detalleMovimientoCuenta_iddetalleMovimientoCuenta = dmc.iddetalleMovimientoCuenta)
                                INNER JOIN videoconsulta vc ON (vc.idvideoconsulta = mc.videoconsulta_idvideoconsulta)
                                LEFT JOIN medico m ON (vc.medico_idmedico = m.idmedico)
                                LEFT JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                                LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                        ");
            $queryVC->setWhere("mc.paciente_idpaciente = $idpaciente");

//obtenemos los movimientos de turnos
            $queryTRN = new AbstractSql();
            $queryTRN->setSelect("
                                   	mc.idmovimientoCuenta,
                                        mc.fecha,
                                        if(mc.is_ingreso=1,if(mc.debito_plan_empresa=1,'+1 Consulta por video',concat('+',mc.monto)),if(mc.debito_plan_empresa=1,'-1 Consulta por video',concat('-',mc.monto))) as monto,
					concat(tp.titulo_profesional,'',uw.nombre,' ',uw.apellido) AS nombre_medico,
                                        CONCAT( dmc.detalleMovimientoCuenta, ' (sur RDV) ', 'Nº', mc.turno_idturno ) AS detalleMovimientoCuenta 
                                ");
            $queryTRN->setFrom("$this->table mc 
                                INNER JOIN detallemovimientocuenta dmc ON (mc.detalleMovimientoCuenta_iddetalleMovimientoCuenta = dmc.iddetalleMovimientoCuenta)
                                INNER JOIN turno trn ON (trn.idturno = mc.turno_idturno)
                                LEFT JOIN medico m ON (trn.medico_idmedico = m.idmedico)
                                LEFT JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                                LEFT JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional = tp.idtitulo_profesional)
                        ");

            $queryTRN->setWhere("mc.paciente_idpaciente = $idpaciente");

//obtenemos los otros movimientos
            $query2 = new AbstractSql();
            $query2->setSelect("
                                   mc.idmovimientoCuenta,
                                    mc.fecha,
                                    if(mc.is_ingreso=1,concat('+',mc.monto),concat('-',mc.monto)) as monto,
                                    '' AS nombre_medico,
                                    dmc.detalleMovimientoCuenta 
                                ");
            $query2->setFrom("$this->table mc 
                                INNER JOIN detallemovimientocuenta dmc ON (mc.detalleMovimientoCuenta_iddetalleMovimientoCuenta = dmc.iddetalleMovimientoCuenta)
                               
                        ");
            $query2->setWhere("mc.paciente_idpaciente = $idpaciente");
            $query2->addAnd("turno_idturno is null and videoconsulta_idvideoconsulta is null and consultaExpress_idconsultaExpress is NULL");

            $query = new AbstractSql();
            $query->setSelect("*");
            $query->setFrom("((" . $queryCE->getSql() . ")UNION(" . $queryVC->getSql() . ")UNION(" . $queryTRN->getSql() . ")UNION(" . $query2->getSql() . "))as t");
            $query->setOrderBy("t.fecha DESC");



            $data = $this->getJSONList($query, array("fecha", "detalleMovimientoCuenta", "monto", "nombre_medico"), $request, $idpaginate);
            return $data;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna el último movimeinto perteneciente a una recarga
     * @return boolean
     */
    public function getUltimoMovimientoCarga() {
        $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
        if ($idpaciente) {
            $query = new AbstractSql();

            $query->setSelect("*");

            $query->setFrom("$this->table mc");

            $query->setWhere("mc.paciente_idpaciente = $idpaciente");

            $query->addAnd("mc.detalleMovimientoCuenta_iddetalleMovimientoCuenta = 3");

            $query->setOrderBy("mc.fecha DESC");

            $query->setLimit("0,1");

            return $this->db->GetRow($query->getSql());
        } else {
            return false;
        }
    }

    /*     * Metodo que retorna los movimientos de cuenta correspondiente a las acreditaciones de VC y CE  las retenciones por comisiones
     * realzados en un periodo del medico
     * 
     * @param type $fecha_inicio
     * @param type $fecha_fin
     * @param type $idmedico
     * @return type
     */

    public function getListadoMovimientosPeriodoMedico($fecha_inicio, $fecha_fin, $idmedico) {

//obtenemos el detalle de videoconsultas del periodo
        $queryVC = new AbstractSql();
        $queryVC->setSelect("
                        mv.idmovimientoCuenta,
                        vc.paciente_idpaciente AS titular,
                        vc.paciente_idpaciente AS paciente,
			vc.numeroVideoConsulta AS numero,
			mv.fecha,
			CASE mv.detalleMovimientoCuenta_iddetalleMovimientoCuenta
                            WHEN 4 THEN	CONCAT('- EUR', mv.monto)
                            WHEN 9 THEN	CONCAT('- EUR', mv.monto)
                            WHEN 10 THEN CONCAT('- EUR', mv.monto)
                            ELSE CONCAT('EUR', mv.monto)
			END AS monto,
                        CASE mv.detalleMovimientoCuenta_iddetalleMovimientoCuenta
                            WHEN 10 THEN 'Patient ALD (tiers payant)'
                            ELSE d.detalleMovimientoCuenta
			END AS  detalle,
                        vc.prestador_idprestador");
        $queryVC->setFrom("movimientocuenta mv
                        INNER JOIN videoconsulta vc ON (vc.idvideoconsulta = mv.videoconsulta_idvideoconsulta)
                        INNER JOIN detallemovimientocuenta d ON (d.iddetalleMovimientoCuenta = mv.detalleMovimientoCuenta_iddetalleMovimientoCuenta)");
        $queryVC->setWhere("mv.medico_idmedico = $idmedico");
//quitamos los movimientos de reembolso paciente ALD
        $queryVC->addAnd("mv.detalleMovimientoCuenta_iddetalleMovimientoCuenta <> 10 ");
        $queryVC->addAnd("vc.fecha_inicio between '$fecha_inicio' and '$fecha_fin'");
//$queryVC->setGroupBy("idvideoconsulta");
//obtenemos el detalle de consulta express del periodo
        $queryCE = new AbstractSql();
        $queryCE->setSelect("
                        mv.idmovimientoCuenta,
                        ce.paciente_idpaciente AS titular,
                        ce.paciente_idpaciente AS paciente,
			ce.numeroConsultaExpress AS numero,
			mv.fecha,
			CASE mv.detalleMovimientoCuenta_iddetalleMovimientoCuenta
                            WHEN 4 THEN	CONCAT('- EUR', mv.monto)
                            WHEN 9 THEN	CONCAT('- EUR', mv.monto)
                            ELSE CONCAT('EUR', mv.monto)
			END AS monto,
                      	d.detalleMovimientoCuenta as detalle,
                       ce.prestador_idprestador");
        $queryCE->setFrom("movimientocuenta mv
                        INNER JOIN consultaexpress ce ON (ce.idconsultaExpress = mv.consultaExpress_idconsultaExpress)
                        INNER JOIN detallemovimientocuenta d ON (d.iddetalleMovimientoCuenta = mv.detalleMovimientoCuenta_iddetalleMovimientoCuenta)");
        $queryCE->setWhere("mv.medico_idmedico = $idmedico");
        $queryCE->addAnd("ce.fecha_inicio between '$fecha_inicio' and '$fecha_fin'");
//   $queryCE->setGroupBy("idconsultaExpress");
//unimos los 2 resultados
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("((" . $queryVC->getSql() . ")UNION(" . $queryCE->getSql() . ")) as T");
        $query->setOrderBy("T.idmovimientoCuenta asc");

        $rdo = $this->getList($query);

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $ManagerPrestador = $this->getManager("ManagerPrestador");
        foreach ($rdo as $key => $movimiento) {

//paciente
            $paciente = $ManagerPaciente->get($movimiento["paciente"]);
            if ($movimiento["prestador_idprestador"] != "") {

                $prestador = $ManagerPrestador->get($movimiento["prestador_idprestador"]);
                $nombre_paciente = $paciente["nombre"] . " " . $paciente["apellido"] . " ({$prestador["nombre"]})";
            } else {

                $nombre_paciente = $paciente["nombre"] . " " . $paciente["apellido"];
            }
            unset($rdo[$key]["prestador_idprestador"]);
            unset($rdo[$key]["idmovimientoCuenta"]);
            $rdo[$key]["paciente"] = $nombre_paciente;
//paciente titular
            $paciente_titular = $ManagerPaciente->getPacienteTitular($movimiento["titular"]);
            $nombre_paciente_titular = $paciente_titular["nombre"] . " " . $paciente_titular["apellido"];
            $rdo[$key]["titular"] = $nombre_paciente_titular;

//$rdo[$key]["fecha"]=fechaToString($movimiento["fecha"], 1);
            $date = date_create($movimiento["fecha"]);
            $rdo[$key]["fecha"] = date_format($date, "Y/m/d H:i");
        }

        return $rdo;
    }

    /**
     * Metodo que permite ghenerar una carga de credito desde el panel administrativo al paciente
     * @param type $request
     */
    public function cargar_credito_from_admin($request) {

        if ($request["idpaciente"] == "" || $request["monto"] == "") {
            $this->setMsg(["msg" => "Error. Ingrese los campos obligatorios.", "result" => false]);
            return false;
        }
        $is_ingreso = $request["is_ingreso"] == "1" ? 1 : 0;
        $tipo_movimiento = $request["is_ingreso"] == "1" ? 3 : 11; // crédit compre / remboursement credit
        $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
        $cuenta = $ManagerCuentaUsuario->getByField("paciente_idpaciente", $request["idpaciente"]);
        $insert_movimiento = $this->insert([
            "fecha" => date("Y-m-d H:i:s"),
            "monto" => (float) $request["monto"],
            "is_ingreso" => $is_ingreso,
            "from_admin" => 1,
            "cuentaUsuario_idcuentaUsuario" => $cuenta["idcuentaUsuario"],
            "paciente_idpaciente" => $request["idpaciente"],
            "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => $tipo_movimiento
        ]);

        if (!$insert_movimiento) {
            $this->setMsg(["msg" => "No se ha podido insertar el movimiento de cuenta", "result" => false]);


            return false;
        }


//Si se pudo crear el movimiento perteneciente a la CE, actualizo la cuenta del paciente
        $cuenta_update = $ManagerCuentaUsuario->actualizarCuentaPacienteFromAdmin($request["idpaciente"]);
        if (!$cuenta_update) {
            $this->setMsg(["msg" => "No se ha podido insertar el movimiento de cuenta", "result" => false]);
            return false;
        }

        return $insert_movimiento;
    }

    /**
     *  cargo el movimiento del reembolso en la tabla movimientocuenta
     * @param type $request
     */
    public function cargarMovimientoReembolso($request) {
        if ($request["rechazarreembolso"] == 1) {
            $is_ingreso = 0;
            $idreembolso = $request["idreembolso"];
            $detallemovimiento = 13;
        } else {
            $is_ingreso = 1;
            $idreembolso = $request["reembolsos_idReembolso"];
            $detallemovimiento = 12;
        }
        $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
// ojo estoy insertando monto cero y no actualizo la tabla cuentausuario
// arriba de este metodo hay un ejemplo que esta bien
        $ManagerCuentaUsuario = $this->getManager("ManagerCuentaUsuario");
        $cuenta = $ManagerCuentaUsuario->getByField("paciente_idpaciente", $idpaciente);
        $insert_movimiento = $this->insert([
            "fecha" => date("Y-m-d H:i:s"),
            "monto" => (float) 0,
            "is_ingreso" => $is_ingreso,
            "cuentaUsuario_idcuentaUsuario" => $cuenta["idcuentaUsuario"],
            "paciente_idpaciente" => $idpaciente,
            "detalleMovimientoCuenta_iddetalleMovimientoCuenta" => $detallemovimiento,
            "reembolso_idreembolso" => $idreembolso
        ]);

        if (!$insert_movimiento) {
            $this->setMsg(["msg" => "No se ha podido insertar el movimiento de cuenta", "result" => false]);


            return false;
        } else {
            $this->setMsg(["msg" => "Se ha podido insertar el movimiento de cuenta", "result" => true]);


            return true;
        }
    }

}
