<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Grillas
 *
 */
class ManagerGrilla extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "grilla", "idgrilla");
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("
                    idgrilla,
                    grilla, 
                    codigo, 
                    CASE sector1
                        WHEN 0 THEN 'No aplica'
                        WHEN 1 THEN IF(condicion_sector1=1,CONCAT('&euro;',valor_sector1),CONCAT('&euro;',valor_sector1,IF(condicion_sector1=2,' max',' min')))
                        WHEN 2 THEN 'Libre'
                        ELSE '-'
                    END as sector1,
                        CASE sector2
                        WHEN 0 THEN 'No aplica'
                        WHEN 1 THEN IF(condicion_sector2=1,CONCAT('&euro;',valor_sector2),CONCAT('&euro;',valor_sector2,IF(condicion_sector2=2,' max',' min')))                       WHEN 2 THEN 'Libre'
                        WHEN 2 THEN 'Libre'
                        ELSE '-'
                    END as sector2,
                        CASE optam
                        WHEN 0 THEN 'No aplica'
                        WHEN 1 THEN IF(condicion_optam=1,CONCAT('&euro;',valor_optam),CONCAT('&euro;',valor_optam,IF(condicion_optam=2,' max',' min')))
                        WHEN 2 THEN 'Libre'
                        ELSE '-'
                    END as optam
                ");

        $query->setFrom("
                $this->table
            ");
        if ($request["grilla"] != "") {

            $grilla = cleanQuery($request["grilla"]);

            $query->addAnd("grilla =$grilla");
        }

        if ($request["codigo"] != "") {

            $codigo = cleanQuery($request["codigo"]);

            $query->addAnd("codigo LIKE '%$codigo%'");
        }




        $data = $this->getJSONList($query, array("grilla", "codigo", "sector1", "sector2", "optam"), $request, $idpaginate);

        return $data;
    }

    /**
     * Metodo que detemrina el precio de una videoconsulta. si esta aplica reintegro o la tarifa original del medico en caso contrario
     * @param type $paciente
     * @param type $medico
     * @return type
     */
    public function getTarifaVideoConsulta($paciente, $medico) {


        $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($medico["idmedico"]);
 
        //si el paciente no es frances, el medico no es frances o no es profesional medico se aplica la tarifa original del medico
        if (($paciente["titular"] == 1 &&$paciente["pais_idpais"] != 1) || $medico["pais_idpais"] != 1 || $medico["mis_especialidades"][0]["tipo"] != 1) {
           
            $monto["monto"] = $preferencia["valorPinesVideoConsultaTurno"];
        } else {
        
            //determinamos a que grilla corresponde la consulta
            $idgrilla = $this->determinar_grilla($paciente, $medico);
         
            if ($idgrilla == 0) {
                $monto["monto"] = $preferencia["valorPinesVideoConsultaTurno"];
            } else {
                $grilla = parent::get($idgrilla);
                if ($grilla) {
                   
                    //vemos si hay alguna excepcion de tarifa por especialidad cargada para la grilla

                    $excepcion_tarifa = $this->getManager("ManagerGrillaExcepcion")->get_excepcion_tarifa($medico, $grilla,$preferencia);
                    if ($excepcion_tarifa) {
                        $monto = $excepcion_tarifa;
                    } else {
                        //buscamos la tarifa general de la grilla
                        $idsector_medico = $medico["preferencia"]["sector"]["idsector"];

                        switch ($idsector_medico) {
                           
                            case 1:
                                if ($grilla["sector1"] == 1 && $grilla["sector1"] != "") {

                                    //verificamos si la tarifa es de maximo
                                    if ($grilla["condicion_sector1"] == 2) {
                                        //si el medico cobra mas del maximo establecido, solo se reintegra el maximo
                                        if ($grilla["valor_sector1"] < $preferencia["valorPinesVideoConsultaTurno"]) {
                                            $monto["monto"] = $grilla["valor_sector1"];
                                            $monto["grilla"] = $grilla;
                                        } else {
                                            //sino se reintegra lo que cobra el medico
                                            $monto["monto"] = $preferencia["valorPinesVideoConsultaTurno"];
                                            $monto["grilla"] = $grilla;
                                        }
                                    } else {
                                        $monto["monto"] = $grilla["valor_sector1"];
                                        $monto["grilla"] = $grilla;
                                    }
                                }
                                break;
                            case 2:
                                if ($grilla["sector2"] == 1 && $grilla["valor_sector2"] != "") {

                                    //verificamos si la tarifa es de maximo
                                    if ($grilla["condicion_sector2"] == 2) {
                                        //si el medico cobra mas del maximo establecido, solo se reintegra el maximo
                                        if ($grilla["valor_sector2"] < $preferencia["valorPinesVideoConsultaTurno"]) {
                                            $monto["monto"] = $grilla["valor_sector2"];
                                            $monto["grilla"] = $grilla;
                                        } else {
                                            //sino se reintegra lo que cobra el medico
                                            $monto["monto"] = $preferencia["valorPinesVideoConsultaTurno"];
                                            $monto["grilla"] = $grilla;
                                        }
                                    } else {
                                        $monto["monto"] = $grilla["valor_optam"];
                                        $monto["grilla"] = $grilla;
                                    }
                                }
                                break;
                            case 3:
                                if ($grilla["optam"] == 1 && $grilla["valor_optam"] != "") {

                                    //verificamos si la tarifa es de maximo
                                    if ($grilla["condicion_optam"] == 2) {
                                        //si el medico cobra mas del maximo establecido, solo se reintegra el maximo
                                        if ($grilla["valor_optam"] < $preferencia["valorPinesVideoConsultaTurno"]) {
                                            $monto["monto"] = $grilla["valor_optam"];
                                            $monto["grilla"] = $grilla;
                                        } else {
                                            //sino se reintegra lo que cobra el medico
                                            $monto["monto"] = $preferencia["valorPinesVideoConsultaTurno"];
                                            $monto["grilla"] = $grilla;
                                        }
                                    } else {
                                        $monto["monto"] = $grilla["valor_optam"];
                                        $monto["grilla"] = $grilla;
                                    }
                                }
                                break;
                            default:
                                $monto["monto"] = $preferencia["valorPinesVideoConsultaTurno"];
                        }
                    }
                }
            }
        }
        if ($monto["monto"] == "") {
            $monto["monto"] = $preferencia["valorPinesVideoConsultaTurno"];
        }
        $monto["monto"]= number_format($monto["monto"],2);
        return $monto;
    }

    /**
     * Metodo que determina que grilla de tarifas se aplica a la consulta para determinar el precio
     * @param type $paciente
     * @param type $medico
     * @return int
     */
    public function determinar_grilla($paciente, $medico) {
        $ManagerProfesionalesFrecuentesPacientes = $this->getManager("ManagerProfesionalesFrecuentesPacientes");
        //1. CONSULTA CON MEDICO DE CABEZA
        //verificamos si es medico de cabecera
        $prof_frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_idmedico"], [$paciente["idpaciente"], $medico["idmedico"]]);
        if ($prof_frecuente["medico_cabecera"] == 1) {
            // 15. PACIENTE ALD - CONSULTA CON MEDICO DE CABEZA
            if ($paciente["beneficia_ald"] == 1) {
                return 15;
            } else {
                return 1;
            }
        } else {
            // 16. PACIENTE ALD - CONSULTA CON MEDICO CUALQUIERA INCRIPTO EN PROTOCOLIO
            if ($paciente["beneficia_ald"] == 1) {
                return 16;
            }
        }

        //1. PACIENTE MIEMBRO CONSULTA CON MEDICO GENERALISTA
        if ($paciente["titular"] == 0 && $medico["mis_especialidades"][0]["acceso_directo"] == 1) {
            return 1;
        }
        //4. PACIENTE MIEMBRO CONSULTA MEDICO GENERALISTA POR CONSULTA CON PACIENTE MIEMBRO < 6 ANOS
        if ($paciente["titular"] == 0 && $medico["mis_especialidades"][0]["idespecialidad"] == 32 && $paciente["edad_anio"] < 6) {
            return 4;
        }
        //titulas
        if ($paciente["titular"] == 1) {
            //6. PACIENTE (CON MEDICO DE CABEZA DECLARADO), CONSULTA CON MEDICO ESPECIALISTA DE ACCESO DIRECTO
            $posee_medico_cabeza = $ManagerProfesionalesFrecuentesPacientes->getByFieldArray(["paciente_idpaciente", "medico_cabecera"], [$paciente["idpaciente"], 1]);
            if ($posee_medico_cabeza) {
                if ($medico["mis_especialidades"][0]["acceso_directo"] == 1) {
                    return 6;
                }
            } else {
                //7. PACIENTE (SIN MEDICO DE CABEZA), CONSULTA CON MEDICO ESPECIALISTA DE ACCESO DIRECTO
                 if ($medico["mis_especialidades"][0]["acceso_directo"] == 1) {
                    return 7;
                }
             
            }
        } else {
            ////miembro
            //8. PACIENTE MIEMBRO CONSULTA CON ESPECIALISTA CARDIOLOGO
            //8. PACIENTE MIEMBRO CONSULTA CON MEDICO GENERALISTA
            //8. PACIENTE MIEMBRO CONSULTA CON PSIQUIATRA O NEUROPSIQUIATRA
            //8. PACIENTE MIEMBRO CONSULTA CON ESPECIALISTA (NO CARDIOLOGA, NO GENERALISTA,  NO PSIQUIATRA O NEUROPSIQUIATRANO, NO PEDIATRA)

            if ($medico["mis_especialidades"][0]["tipo"]==1 && $medico["mis_especialidades"][0]["idespecialidad"] !=54  ) {
                return 8;
            }

            if ($medico["mis_especialidades"][0]["idespecialidad"] == 54) {
               
                //pediatra
                //9a. PACIENTE MIEMBRO CONSULTA CON PEDIATRA SECTEUR 1 + ESE PACIENTE MIEMBRO < 2 ANOS
                if ($medico["sector_idsector"] == 1) {
                    if ($paciente["edad_anio"] < 2) {
                        return 9;
                    }
                          //9b. PACIENTE MIEMBRO CONSULTA CON PEDIATRA SECTEUR 1 + ESE PACIENTE MIEMBRO >= 2 ANOS y < 6 Años
                    if ($paciente["edad_anio"]>=2&&$paciente["edad_anio"] < 6) {
                        return 17;
                    }
                    
                    // 10. PACIENTE MIEMBRO CONSULTA CON PEDIATRA SECTEUR 1 + ESE PACIENTE MIEMBRO >= 6 ANOS < 16 ANOS
                    if ($paciente["edad_anio"] >= 6 && $paciente["edad_anio"] < 16) {
                        return 10;
                    }
                }
                // 12. PACIENTE MIEMBRO CONSULTA CON PEDIATRA SECTEUR 2 + ESE PACIENTE MIEMBRO < 2 ANOS
                if ($medico["sector_idsector"] == 2) {
                    if ($paciente["edad_anio"] < 2) {
                        return 12;
                    }

                    // 13. PACIENTE MIEMBRO CONSULTA CON PEDIATRA SECTEUR 2 + ESE PACIENTE MIEMBRO > 2 ANOS < 16 ANOS
                    if ($paciente["edad_anio"] >= 2&& $paciente["edad_anio"] < 16) {
                        return 13;
                    }
                }
            }
        }
        return 0;
    }

}

//END_class
?>