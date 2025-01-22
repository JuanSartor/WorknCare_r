<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Las Obras Sociales - Prepagas
 *
 */
class ManagerIdiomaMedico extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "idiomamedico", "ididiomaMedico");
    }

    /**
     * Asocia un idioma un medico, si este no ha sido asociada aun
     *
     */
    public function addIdioma($ididioma) {


        //solo medicos loggueados
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["tipousuario"] == "medico") {
            if (!$this->medicoManejaIdioma($ididioma, $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"])) {

                $id = $this->insert(
                        array(
                            "idioma_ididioma" => $ididioma,
                            "medico_idMedico" => $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]
                        )
                );

                if ($id) {

                    $this->setMsg([ "result" => true, "msg" => "Idioma agregada"]);
                    return true;
                } else {


                    $this->setMsg([ "result" => false, "msg" => "El idioma ya se encuentra asignado"]);

                    return false;
                }
            } else {
                $this->setMsg([ "result" => false, "msg" => "El idioma ya se encuentra asignado"]);


                return false;
            }
        } else {


            $this->setMsg(["result" => false, "msg" => "Error, acceso denegado"]);

            return false;
        }
    }

    public function addIdiomaMedico($ididioma, $idmedico) {
        if (!$this->medicoManejaIdioma($ididioma, $idmedico)) {
            $id = $this->insert(
                    array(
                        "idioma_ididioma" => $ididioma,
                        "medico_idMedico" => $idmedico
                    )
            );
            if ($id) {

                $this->setMsg([ "result" => true, "msg" => "Idioma agregado"]);
                return $id;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * elimina un idioma
     *
     */
    public function deleteIdioma($ididioma) {

        //solo medicos loggueados
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["tipousuario"] == "medico") {
            $ididiomaMedico = $this->medicoManejaIdioma($ididioma, $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]);
            if ($ididiomaMedico) {

                $result = $this->delete($ididiomaMedico);

                if ($result) {

                    $this->setMsg(["result" => true, "msg" => "El idioma se ha eliminado"]);
                    return true;
                } else {


                    $this->setMsg([ "result" => false, "msg" => "El idioma ya ha sido eliminado"]);


                    return false;
                }
            } else {
                $this->setMsg([ "result" => false, "msg" => "El idioma ya ha sido eliminado"]);
                return false;
            }
        } else {


            $this->setMsg([ "result" => false, "msg" => "Error, acceso denegado"]);

            return false;
        }
    }

    /**
     *  Averigua si si un medico trabaja con un idioma
     *
     * */
    public function medicoManejaIdioma($ididioma, $idMedico) {


        $rs = $this
                ->db
                ->Execute("SELECT ididiomaMedico FROM idiomamedico WHERE idioma_ididioma = $ididioma AND medico_idMedico = $idMedico ")
                ->FetchRow();

        if ($rs) {
            if ((int) $rs["ididiomaMedico"] > 0) {
                return (int) $rs["ididiomaMedico"];
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     *  Todas los idiomas que maneja un profesional
     *
     * */
    public function getIdiomasMedico($idMedico) {


        $query = new AbstractSql();
        $query->setSelect("
            i.ididioma  AS id ,
            i.idioma AS value
        ");
        $query->setFrom("
                   idiomamedico im 
                   JOIN idioma i ON (im.idioma_ididioma = i.ididioma)
        ");

        $query->setWhere("im.medico_idMedico = $idMedico");

        $idiomas = $this->getList($query, false);

        $i = 0;
        foreach ($idiomas as $key => $idioma) {
            $idiomas[$i]["value"] = $idioma["value"];
            $i++;
        }

        return $idiomas;
    }

}

//END_class
?>