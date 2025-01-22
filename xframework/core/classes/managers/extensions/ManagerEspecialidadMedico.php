<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	11/07/2014
 * 	Manager de las preferencias de los médicos
 *
 */
class ManagerEspecialidadMedico extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "especialidadmedico", "idespecialidadMedico");
    }

    /**
     *
     *  Obtiene las especialidades y subespecialidades asociadas a un médico
     *
     * */
    public function getEspecialidadesMedico($idmedico) {
        $query = new AbstractSql();
        $query->setSelect("em.idespecialidadMedico,e.*");
        $query->setFrom("
            especialidadmedico em
            LEFT JOIN especialidad e ON(em.especialidad_idespecialidad = e.idespecialidad)
            LEFT JOIN subespecialidad s ON(em.subEspecialidad_idsubEspecialidad = s.idsubEspecialidad)
        ");
        $query->setWhere("em.medico_idmedico = $idmedico");


        return $this->getList($query, false);
    }

    /**
     * Método que retorna un listado con la visualización de todas las especialidades 
     * @param type $idmedico
     * @return type
     */
    public function getListadoVisualizacion($idmedico) {
        $query = new AbstractSql();
        $query->setSelect("em.idespecialidadMedico,e.idespecialidad,e.especialidad,s.idsubEspecialidad,s.subEspecialidad");
        $query->setFrom("
            especialidadmedico em
            LEFT JOIN especialidad e ON(em.especialidad_idespecialidad = e.idespecialidad)
            LEFT JOIN subespecialidad s ON(em.subEspecialidad_idsubEspecialidad = s.idsubEspecialidad)
        ");
        $query->setWhere("em.medico_idmedico = $idmedico");


        $listado = $this->getList($query, false);
        if ($listado && count($listado) > 0) {

            $array = ["especialidad" => $listado[0]["especialidad"]];
            $subespecialidades = "";
            foreach ($listado as $key => $value) {
                if ((int) $key != (int) (count($listado) - 1)) {
                    $subespecialidades .= ", {$value["subEspecialidad"]} ";
                } else {
                    $subespecialidades .= "y {$value["subEspecialidad"]}";
                }
            }
            $subespecialidades = substr($subespecialidades, 1);
            $array["subEspecialidades"] = $subespecialidades;

            return $array;
        }
        return false;
    }

    private function is_exist_medicoEspecialidad($idespecialidad, $idmedico, $idsub_especialidad = null) {
        $query = new AbstractSql();
        $query->setSelect("em.*");
        $query->setFrom("
                            especialidadmedico em
                        ");
        $query->setWhere("em.medico_idmedico = $idmedico");


        $query->addAnd("em.especialidad_idespecialidad = $idespecialidad");
        if (!is_null($idsub_especialidad)) {
            $query->addAnd("em.subEspecialidad_idsubEspecialidad = $idsub_especialidad");
        }

        $rdo = $this->getList($query);

        if (count($rdo) > 0) {
            return $rdo;
        } else {
            return false;
        }
    }

    /**
     * Asocia una especialidad a un medico, si este no ha sido asociada aun
     *
     */
    public function addEspecialidadMedico($idespecialidad) {


        //solo medicos loggueados
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["tipousuario"] == "medico") {



            if (!$this->is_exist_medicoEspecialidad($idespecialidad, $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"])) {

                $list_especialidades = $this->getEspecialidadesList($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]);
                if (COUNT($list_especialidades) > 0) {
                    $this->setMsg([ "result" => false, "msg" => "Solo puede agregar una especialidad"]);
                    return false;
                }
                $id = $this->insert(
                        array(
                            "especialidad_idespecialidad" => $idespecialidad,
                            "medico_idMedico" => $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]
                        )
                );
                if ($id) {
                    $this->setMsg([ "result" => true, "msg" => "Especialidad agregada"]);
                    return true;
                } else {

                    $this->setMsg([ "result" => false, "msg" => "La especialidad ya se encuentra asociada"]);
                    return false;
                }
            } else {
                $this->setMsg([ "result" => false, "msg" => "La especialidad ya se encuentra asociada"]);
                return false;
            }
        } else {
            $this->setMsg([ "result" => false, "msg" => "Error, acceso denegado"]);
            return false;
        }
    }

    /**
     * elimina una especialidad
     *
     */
    public function deleteEspecialidadMedico($idespecialidad) {

        //solo medicos loggueados
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["tipousuario"] == "medico") {

            $list_especialidad_medico = $this->is_exist_medicoEspecialidad($idespecialidad, $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]);

            if (count($list_especialidad_medico) > 0) {
                foreach ($list_especialidad_medico as $key => $value) {
                    $delete = $this->delete($value["idespecialidadMedico"]);
                }
                $this->setMsg([ "result" => true, "msg" => "La especialidad ha sido eliminada"]);
                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "La especialidad ya ha sido eliminada"]);

                return false;
            }
        } else {


            $this->setMsg([ "result" => false, "msg" => "Error, acceso denegado"]);


            return false;
        }
    }

    public function addSubEspecialidadMedico($idespecialidad, $idsub_especialidad) {
        //solo medicos loggueados
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["tipousuario"] == "medico") {

            //verificamos que la especialidad y subespecailidad coincidan al mismo tipo
            $subesp = $this->getManager("ManagerSubespecialidades")->get($idsub_especialidad);
            if ($subesp["especialidad_idespecialidad"] != $idespecialidad) {
                $this->setMsg([ "result" => false, "msg" => "La sub-especialidad no corresponde a esta especialidad"]);


                return false;
            }

            if (!$this->is_exist_medicoEspecialidad($idespecialidad, $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"], $idsub_especialidad)) {

                $id = $this->insert(
                        array(
                            "especialidad_idespecialidad" => $idespecialidad,
                            "subEspecialidad_idsubEspecialidad" => $idsub_especialidad,
                            "medico_idMedico" => $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]
                        )
                );

                if ($id) {

                    $this->setMsg([ "result" => true, "msg" => "Sub-especialidad agregada"]);

                    return true;
                } else {

                    $this->setMsg([ "result" => false, "msg" => "La sub-especialidad ya se encuentra asociada"]);


                    return false;
                }
            } else {
                $this->setMsg([ "result" => false, "msg" => "La sub-especialidad ya se encuentra asociada"]);


                return false;
            }
        } else {


            $this->setMsg([ "result" => false, "msg" => "Error, acceso denegado"]);
            return false;
        }
    }

      public function deleteSubEspecialidadMedico($idespecialidad, $idsub_especialidad) {
       
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["tipousuario"] == "medico") {
            
           $subespecialidad=$this->getByFieldArray(["medico_idmedico","especialidad_idespecialidad","subEspecialidad_idsubEspecialidad"], [$_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"],$idespecialidad, $idsub_especialidad]);
            $delete = parent::delete($subespecialidad["idespecialidadMedico"],true);
                if ($delete) {
                 
                    $this->setMsg([ "result" => true, "msg" => "La sub-especialidad fue eliminada"]);


                    return true;
                } else {
                    $this->setMsg([ "result" => false, "msg" => "No se pudo eliminar la sub-especialidad"]);

                    return false;
                }
            
        } else {
            $this->setMsg([ "result" => false, "msg" => "Error, acceso denegado"]);

            return false;
        }
    }

    /*     * Metodo que retorna el listado de idespecialidad de un medico en formato de string
     * 
     * @param type $idmedico
     */

    public function getEspecialidadesString($idmedico, $first = false) {
        $query = new AbstractSql();
        $query->setSelect("distinct especialidad_idespecialidad");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico=$idmedico");

        $list = $this->getList($query);

        if ($first) {
            return $list[0]["especialidad_idespecialidad"];
        } else {
            $result = "";
            foreach ($list as $especialidad) {
                $result = "," . $especialidad["especialidad_idespecialidad"];
            }
            return substr($result, 1);
        }
    }

    /*     * Metodo que retorna el listado de especialidades de un medico 
     * 
     * @param type $idmedico
     */

    public function getEspecialidadesList($idmedico, $array = false) {

        $query = new AbstractSql();
        $query->setSelect("distinct especialidad_idespecialidad");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico=$idmedico");
        $res = $this->getList($query);

        //retornamos en forma de array
        if ($array) {
            $result = [];
            foreach ($res as $esp) {
                $result[] = $esp["especialidad_idespecialidad"];
            }
            return $result;
        } else {//retornamos en forma de lista
            return $res;
        }
    }

}

//END_class
?>
