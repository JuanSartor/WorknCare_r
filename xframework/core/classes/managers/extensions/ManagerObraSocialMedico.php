<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los tipos de DNI.
 *
 */
class ManagerObraSocialMedico extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "obrasocialmedico", "idobraSocialMedico");
    }

    /**
     * Asocia una obra social a un medico, si esta no ha sido asociada aun
     *
     */
    public function addObracial($idobraSocial) {


        //solo medicos loggueados
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["tipousuario"] == "medico") {
            if (!$this->medicoTrabajaConObraSocial($idobraSocial, $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"])) {

                $id = $this->insert(
                        array(
                            "obraSocial_idobraSocial" => $idobraSocial,
                            "medico_idmedico" => $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]
                        )
                );

                if ($id) {
                    $nombre = $this->getManager("ManagerObrasSociales")->get($idobraSocial)["nombre"];
                    $this->setMsg([ "result" => true, "msg" => "Cobertura agregada", "nombre" => $nombre]);
                    return true;
                } else {


                    $this->setMsg([ "result" => false, "msg" => "La cobertura ya ha sido asignada"]);
                    return false;
                }
            } else {
                $this->setMsg([ "result" => false, "msg" => "La Cobertura ya ha sido asignada"]);
                return false;
            }
        } else {


            $this->setMsg([ "result" => false, "msg" => "Error, acceso denegado"]
            );
            return false;
        }
    }

    /**
     * Delete obra Social
     *
     */
    public function deleteObracial($idobraSocial) {


        //solo medicos loggueados
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["tipousuario"] == "medico") {
            $idobraSocialMedico = $this->medicoTrabajaConObraSocial($idobraSocial, $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]);
            if ($idobraSocialMedico) {

                $result = $this->delete($idobraSocialMedico);

                if ($result) {

                    $this->setMsg([ "result" => true, "msg" => "La Cobertura se ha eliminado"]);
                    return true;
                } else {


                    $this->setMsg([ "result" => false, "msg" => "La cobertura ya ha sido eliminada"]);
                    return false;
                }
            } else {
                $this->setMsg([ "result" => false, "msg" => "La obra social ya ha sido eliminada"]);
                return false;
            }
        } else {


            $this->setMsg([ "result" => false, "msg" => "Error, acceso denegado"]);
            return false;
        }
    }

    /**
     *  Averigua si si un medico trabaja con una obra social
     *
     * */
    public function medicoTrabajaConObraSocial($idobraSocial, $idMedico) {


        $rs = $this
                ->db
                ->Execute("SELECT idobraSocialMedico FROM obrasocialmedico WHERE obraSocial_idobraSocial = $idobraSocial AND medico_idMedico = $idMedico ")
                ->FetchRow();

        if ($rs) {
            if ((int) $rs["idobraSocialMedico"] > 0) {
                return (int) $rs["idobraSocialMedico"];
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     *  Todas las obras sociales que trabaja un medico
     *
     * */
    public function getObrasSocialesMedico($idmedico) {

        $query = new AbstractSql();
        $query->setSelect("
                os.idobraSocial  AS id ,
                os.nombre AS value ,
                os.*
            ");
        $query->setFrom("
                       obrasocialmedico osm 
                       JOIN obrasocial os ON (osm.obraSocial_idobraSocial = os.idobraSocial)
            ");

        $query->setWhere("osm.medico_idmedico = $idmedico");

        $obrassociales = $this->getList($query, false);


        $i = 0;
        foreach ($obrassociales as $key => $os) {
            $obrassociales[$i]["value"] = utf8_decode($os["value"]);
            $i++;
        }

        return $obrassociales;
    }

    /**
     *  Todas las obras sociales que trabaja un medico, formato combo
     *
     * */
    public function getCombo($idmedico) {

        $query = new AbstractSql();
        $query->setSelect("
                os.idobraSocial,
                os.nombre 
            ");
        $query->setFrom("
                       obrasocialmedico osm 
                       JOIN obrasocial os ON (osm.obraSocial_idobraSocial = os.idobraSocial)
            ");

        $query->setWhere("osm.medico_idmedico = $idmedico");

        $obrassociales = $this->getComboBox($query, false);


        return $obrassociales;
    }

    /**
     * Método que retorna la oabra social del médico que tiene en común con el paciente
     * @param type $idmedico
     * @param type $idpaciente
     */
    public function getObraSocialEnComunPaciente($idmedico, $idpaciente) {

        $query = new AbstractSql();

        $query->setSelect("
                os.idobraSocial,
                os.nombre,
                osp.*,
                pos.nombrePlan
            ");

        $query->setFrom("
                        obrasocialmedico osm 
                        INNER JOIN obrasocial os ON (osm.obraSocial_idobraSocial = os.idobraSocial)
                        INNER JOIN obrasocialpaciente osp ON (osp.obraSocial_idobraSocial = osm.obraSocial_idobraSocial AND osp.paciente_idpaciente = $idpaciente)
                        LEFT JOIN planobrasocial pos ON (osp.planObraSocial_idplanObraSocial = pos.idplanObraSocial)
            ");

        $query->setWhere("osm.medico_idmedico = $idmedico");

        $execute = $this->db->Execute($query->getSql());

        if ($execute) {
            return $execute->FetchRow();
        } else {
            return false;
        }
    }

    /**
     *   Listado de Las Obras sociales con filtro de busqueda para autosugeridor
     * 		
     * 	@author Xinergia
     * 	@version 1.0
     *
     * 	@param int $request con parametros para la busqueda
     * 	@return array Listado de registros
     */
    public function getAutosuggest($request) {

        $queryStr = cleanQuery($request["query"]);


        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        $query = new AbstractSql();

        $query->setSelect("os.idobraSocial AS data, os.nombre AS value ");

        $query->setFrom(" obrasocial os ");

        $query->setWhere("os.nombre LIKE '%$queryStr%'");

        $query->addAnd("os.idobraSocial NOT IN (SELECT obraSocial_idobraSocial
                                                        FROM obrasocialmedico WHERE medico_idmedico = $idmedico)");

        $query->setOrderBy("os.nombre ASC");


        $data = array(
            "query" => $request["query"],
            "suggestions" => $this->getList($query, false)
        );


        return json_encode($data);
    }

}

//END_class
?>