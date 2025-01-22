<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de ManagerGrillaExcepcion
 *
 */
class ManagerGrillaExcepcion extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "grilla_excepcion", "idgrilla_excepcion");
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }


        $query = new AbstractSql();
        $query->setSelect("idgrilla_excepcion,
                    e.especialidad, 
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
                        ELSE '-'
                    END as sector2,
                        CASE optam
                        WHEN 0 THEN 'No aplica'
                        WHEN 1 THEN IF(condicion_optam=1,CONCAT('&euro;',valor_optam),CONCAT('&euro;',valor_optam,IF(condicion_optam=2,' max',' min')))
                        WHEN 2 THEN 'Libre'
                        ELSE '-'
                    END as optam");

        $query->setFrom("$this->table g left join especialidad e on (g.especialidad_idespecialidad=e.idespecialidad)");

        // Filtro
        $query->addAnd("grilla_idgrilla=" . $request["idgrilla"]);


        $data = $this->getJSONList($query, array("especialidad", "codigo","sector1", "sector2", "optam"), $request, $idpaginate);

        return $data;
    }

    /**
     * Metodo que devuelve las tarifas que aplican para la especialidad de un medico si hay cargada una excepcion de tarifa a la grilla 
     */
    public function get_excepcion_tarifa($medico, $grilla,$preferencia) {

        $idespecialdidad = $medico["mis_especialidades"][0]["idespecialidad"];
        $idgrilla = $grilla["idgrilla"];
        $excepcion = parent::getByFieldArray(["especialidad_idespecialidad", "grilla_idgrilla"], [$idespecialdidad, $idgrilla]);
        if (!$excepcion) {
            return false;
        }
        //buscamos la tarifa general de la grilla
        $idsector_medico = $medico["preferencia"]["sector"]["idsector"];

        switch ($idsector_medico) {
            case 1:
                if ($excepcion["sector1"] == 1 && $excepcion["sector1"] != "") {
                      
                    //verificamos si la tarifa es de maximo
                    if ($excepcion["condicion_sector1"] == 2) {
                   
                        //si el medico cobra mas del maximo establecido, solo se reintegra el maximo
                        if ($excepcion["valor_sector1"] < $preferencia["valorPinesVideoConsultaTurno"]) {
                            $monto["monto"] = $excepcion["valor_sector1"];
                            $monto["grilla"] = $excepcion;
                        
                        } else {
                            //sino se reintegra lo que cobra el medico
                            $monto["monto"] = $preferencia["valorPinesVideoConsultaTurno"];
                            $monto["grilla"] = $excepcion;
                          
                        }
                    } else {
                        $monto["monto"] = $excepcion["valor_sector1"];
                        $monto["grilla"] = $excepcion;
                       
                    }
                }
                break;
            case 2:
                if ($excepcion["sector2"] == 1 && $excepcion["valor_sector2"] != "") {
                    //verificamos si la tarifa es de maximo
                    if ($excepcion["condicion_sector2"] == 2) {
                        //si el medico cobra mas del maximo establecido, solo se reintegra el maximo
                        if ($excepcion["valor_sector2"] < $preferencia["valorPinesVideoConsultaTurno"]) {
                            $monto["monto"] = $excepcion["valor_sector2"];
                            $monto["grilla"] = $excepcion;
                      
                        } else {
                            //sino se reintegra lo que cobra el medico
                            $monto["monto"] = $preferencia["valorPinesVideoConsultaTurno"];
                            $monto["grilla"] = $excepcion;
                         
                        }
                    } else {
                        $monto["monto"] = $excepcion["valor_sector2"];
                        $monto["grilla"] = $excepcion;
                      
                    }
                }
                break;
            case 3:
                if ($excepcion["optam"] == 1 && $excepcion["valor_optam"] != "") {
                    //verificamos si la tarifa es de maximo
                    if ($excepcion["condicion_optam"] == 2) {
                        //si el medico cobra mas del maximo establecido, solo se reintegra el maximo
                        if ($excepcion["valor_optam"] < $preferencia["valorPinesVideoConsultaTurno"]) {
                            $monto["monto"] = $excepcion["valor_optam"];
                            $monto["grilla"] = $excepcion;
                            
                        } else {
                            //sino se reintegra lo que cobra el medico
                            $monto["monto"] = $preferencia["valorPinesVideoConsultaTurno"];
                            $monto["grilla"] = $excepcion;
                        
                        }
                    } else {
                        $monto["monto"] = $excepcion["valor_optam"];
                        $monto["grilla"] = $excepcion;
                       
                    }
                }
                break;
            default:
                return false;
        }
        return $monto;
    }

}

//END_class
?>