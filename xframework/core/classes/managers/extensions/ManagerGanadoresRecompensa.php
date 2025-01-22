<?php

/**
 * 	@autor Juan Sartor
 * 	@version 	16/09/2022
 * 	Manager para guardar las respues de los cuestionario
 *
 */
class ManagerGanadoresRecompensa extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    public function __construct($db) {

// Llamamos al constructor del a superclase
        parent::__construct($db, "ganadores_recompensa", "idganadorrecompensa");
    }

    public function process($request) {

        return parent::process($request);
    }

    public function sortearRecompensas($idcuestionario, $idsParticipantes) {
        $cuestionario = $this->getManager("ManagerCuestionario")->get($idcuestionario);

        if (count($idsParticipantes) > $cuestionario["cantidad"]) {

            if (count($idsParticipantes) < 1) {
                $this->setMsg(["result" => true, "msg" => "No se pudo realizar el sorteo", "ganadores" => false]);
                return true;
            } else {

                $posicionesGanadoras = array_rand($idsParticipantes, $cuestionario["cantidad"]);

                $arraegloIdsGanadores = Array();
                $i = 0;
                if (count($posicionesGanadoras) == 1) {
                    $arraegloIdsGanadores[$i] = $idsParticipantes[$posicionesGanadoras];
                } else {
                    foreach ($posicionesGanadoras as $pos) {
                        $arraegloIdsGanadores[$i] = $idsParticipantes[$pos];
                        $i++;
                    }
                }

                $arrayPerdedores = Array();
                $j = 0;
                foreach ($idsParticipantes as $eleme) {
                    if (!(in_array($eleme, $arraegloIdsGanadores))) {
                        $arrayPerdedores[$j] = $eleme;
                        $j++;
                    }
                }
                $request["cuestionario_idcuestionario"] = $idcuestionario;
                foreach ($arraegloIdsGanadores as $idganador) {
                    $request["id_idusuarioweb_ganador"] = $idganador;
                    parent::process($request);
                }

                $usuariosGanadores = Array();
                $manaUsuaWeb = $this->getManager("ManagerUsuarioWeb");
                $l = 0;
                foreach ($arraegloIdsGanadores as $idg) {
                    $usuariosGanadores[$l] = $manaUsuaWeb->get($idg);
                    $l++;
                }

                foreach ($arrayPerdedores as $idp) {
                    $resultado = $this->sendEmailNoGanadorRecompensa($idp);
                }
                foreach ($arraegloIdsGanadores as $id) {
                    $resultado = $this->sendEmailGanadorRecompensa($id);
                }
                $requestu["fecha_sorteo"] = date('Y-m-d', time());
                $this->getManager("ManagerCuestionario")->update($requestu, $idcuestionario);

                if ($resultado) {
                    $this->setMsg(["result" => true, "msg" => "Sorteo realizado correctamente", "ganadores" => $usuariosGanadores]);
                    return true;
                } else {
                    $this->setMsg(["result" => false, "msg" => "Ha ocurrido un error"]);
                    return false;
                }
            }
        } else {
            $this->setMsg(["result" => true, "msg" => "No se pudo realizar el sorteo", "ganadores" => false]);
            return true;
        }
    }

    public function sendEmailGanadorRecompensa($idwebGanador) {

        $manaUsWeb = $this->getManager("ManagerUsuarioWeb");
        $usWeb = $manaUsWeb->get($idwebGanador);
        $manaPac = $this->getManager("ManagerPaciente");
        $paciente = $manaPac->getByField("usuarioweb_idusuarioweb", $idwebGanador);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

//ojo solo arnet local
        $mEmail->setPort("587");
        $mEmail->setFromName("Notifications WorknCare");
        $mEmail->setSubject("WorknCare : jour de chance !");


        $smarty = SmartySingleton::getInstance();

        $smarty->assign("usuario", $usWeb);
        $smarty->assign("paciente", $paciente);
        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $mEmail->setBody($smarty->Fetch("email/ganador_sorteo_recompensa.tpl"));

        $mEmail->addTo($usWeb["email"]);

//header a todos los comentarios!
        if ($mEmail->send()) {

            return true;
        } else {
//$this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    public function sendEmailNoGanadorRecompensa($idwebGanador) {

        $manaUsWeb = $this->getManager("ManagerUsuarioWeb");
        $usWeb = $manaUsWeb->get($idwebGanador);
        $manaPac = $this->getManager("ManagerPaciente");
        $paciente = $manaPac->getByField("usuarioweb_idusuarioweb", $idwebGanador);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

//ojo solo arnet local
        $mEmail->setPort("587");
        $mEmail->setFromName("Notifications WorknCare");
        $mEmail->setSubject("WorknCare: Récompense de résultat");


        $smarty = SmartySingleton::getInstance();

        $smarty->assign("usuario", $usWeb);
        $smarty->assign("paciente", $paciente);
        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $mEmail->setBody($smarty->Fetch("email/noganador_sorteo_recompensa.tpl"));

        $mEmail->addTo($usWeb["email"]);

//header a todos los comentarios!
        if ($mEmail->send()) {

            return true;
        } else {
//$this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    /**
     * 
     * @param type $idcuestionario
     * obtengo los ganadores del cuestionario pasado como parametro
     */
    public function getGanadores($idcuestionario) {

        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("
                       $this->table t
                                INNER JOIN usuarioweb u ON (t.id_idusuarioweb_ganador = u.idusuarioweb)
            ");

        $query->setWhere("t.cuestionario_idcuestionario = $idcuestionario");

        $resultado = $this->getList($query, false);
        if ($resultado) {
            $this->setMsg(["result" => true, "msg" => "Ganadores", "ganadores" => $resultado]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "Ha ocurrido un error"]);
            return false;
        }
    }

    public function getCantRecompensasGanadas($idusweb) {

        $query = new AbstractSql();
        $query->setSelect("count(*) as cantidad");
        $query->setFrom("ganadores_recompensa g");
        $query->setWhere("g.id_idusuarioweb_ganador=" . $idusweb);
        $query->addAnd("g.recompensa_utilizada=0");
        return $this->db->GetRow($query->getSql());
    }

    public function obtenerRecompensasGanadas($idusweb) {

        $query = new AbstractSql();

        $query->setSelect("DISTINCT c.programasalud_idprogramasalud");

        $query->setFrom("
                       $this->table t
                                INNER JOIN cuestionarios c ON (t.cuestionario_idcuestionario = c.idcuestionario)
            ");

        $query->setWhere("t.id_idusuarioweb_ganador = $idusweb");
        // si esta en 0 es porque no ocupo todavia la recompensa ganada
        $query->addAnd("t.recompensa_utilizada=0");
        return $this->getList($query, false);
    }

    public function getRecompensByIdPrograma($idProgr) {

        $iduweb = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuarioweb"];

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("ganadores_recompensa g, cuestionarios c");
        $query->setWhere("g.cuestionario_idcuestionario=c.idcuestionario");
        $query->addAnd("c.programasalud_idprogramasalud=$idProgr");
        $query->addAnd("g.recompensa_utilizada=0");
        $query->addAnd("g.id_idusuarioweb_ganador=$iduweb");
        return $this->db->GetRow($query->getSql());
    }

    public function getRecoByIdpaci($idpac) {

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("ganadores_recompensa g, paciente p, usuarioweb u");
        $query->setWhere("g.recompensa_utilizada=2");
        $query->addAnd("p.idpaciente=$idpac");
        $query->addAnd("p.usuarioweb_idusuarioweb=u.idusuarioweb");
        $query->addAnd("g.id_idusuarioweb_ganador=u.idusuarioweb");
        return $this->db->GetRow($query->getSql());
    }

}

//END_class


