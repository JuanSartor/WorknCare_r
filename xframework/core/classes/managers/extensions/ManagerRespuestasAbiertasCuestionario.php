<?php

/**
 * 	@autor Juan Sartor
 * 	@version 	16/09/2022
 * 	Manager para guardar las respues de los cuestionario
 *
 */
class ManagerRespuestasAbiertasCuestionario extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    public function __construct($db) {

// Llamamos al constructor del a superclase
        parent::__construct($db, "respuesta_abierta_cuestionario", "idrespuesta_abierta");
    }

    public function process($request) {

        return parent::process($request);
    }

    //funcion para registrar las respuestas
    public function registrarRtasAbiertas($request) {
        // saco la cadena que ocupo para delimitar los elementos del array
        // limpio los espacios vacios y elimino la coma q hay a partir del segundo elemento
        $ArrePRe = explode("._.", $request["respuestasAbiertas"]);
        $arrayFin = Array();
        $arraLimpio = array_filter($ArrePRe);
        $arrayFin[0] = $arraLimpio[0];

        $managerDatos = $this->getManager("ManagerDatosRespuestasAbiertasCuestionario");
        $reDa["nombre"] = $request["nombre"];
        $reDa["apellido"] = $request["apellido"];
        $reDa["email"] = $request["email"];
        $reDa["empresa_idempresa"] = $request["empresa_idempresa"];
        $reDa["fecha_registrada_respuestas"] = date("Y-m-d");
        $idDatosNuevo = $managerDatos->process($reDa);


        for ($i = 1; $i < count($arraLimpio); $i++) {
            $arrayFin[$i] = substr($arraLimpio[$i], 1);
        }

        $reqRepA["datosrespuesta_iddatosrespuesabierta"] = $idDatosNuevo;
        $reqRepA["cuestionario_idcuestionario"] = $request["cuestionario_idcuestionario"];
        foreach ($arrayFin as $rta) {
            $arrR = explode("-_-", $rta);
            $reqRepA["respuesta"] = $arrR[0];
            $reqRepA["preguntaabierta_idpreguntaabierta"] = $arrR[1];
            parent::process($reqRepA);
        }

        // este de abajo es el array final para utilizar
    }

    // obtengo todas las respuestas al cuestionario recibido como parametro
    public function respuestaACuestionario($idcuestionario) {
        $query = new AbstractSql();
        $query->setSelect("t.*, d.*");
        $query->setFrom("$this->table t, datos_respuestas_abiertas d");
        $query->setWhere("t.preguntaabierta_idpreguntaabierta=" . $idcuestionario);
        $query->addAnd("t.datosrespuesta_iddatosrespuesabierta=d.iddatos_respuesta_abierta");
        $data = $this->getList($query);
        return $data;
    }

    public function getCantidaRtasAbiertas($idcuestionario) {
        $query = new AbstractSql();

        $query->setSelect("COUNT(t.{$this->id}) as cantidad");

        $query->setFrom("{$this->table} t");

        $query->setWhere("t.cuestionario_idcuestionario = {$idcuestionario}");

        return $this->db->GetRow($query->getSql());
    }

    /**
     * 
     * @param type $idcuestionario
     * @return type
     * metodo para obtener la lista de ids de las personas que respondieron el cuestionario
     * y ademas se registraron en el sistema
     */
    public function getListaBeneficiariosRegistrados($idcuestionario) {
        $query = new AbstractSql();
        $query->setSelect("u.idusuarioweb");
        $query->setFrom("$this->table t
                                INNER JOIN cuestionarios c ON (c.idcuestionario = t.cuestionario_idcuestionario)
                                INNER JOIN usuarioweb u ON (u.email = t.email)
                    ");
        $query->setWhere("t.cuestionario_idcuestionario=" . $idcuestionario);
        $data = $this->getList($query);
        $arregloRetorno = Array();
        $i = 0;
        foreach ($data as $elemento) {
            $arregloRetorno[$i] = $elemento["idusuarioweb"];
            $i++;
        }
        return $arregloRetorno;
    }

}

//END_class


