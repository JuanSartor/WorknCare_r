<?php

/**
 * 	Manager del estado completado los perfiles de salud necesario para ConsultaExpress
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludStatus extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludstatus", "idperfilSaludStatus");
    }

    /*     * Metodo que crea un registro para el status del perfil de salud al crear un nuevo paciente
     * 
     * @param type $record
     */

    public function insert($record) {


        /** Paciente adulto varon=14 pts
         * Paciente pediatrico varon=15 pts
         * Paciente adulta mujer=17 pts
         * Paciente adulta pediatrico=18 pts
         * * */
        //si es paciente titular posee usuarioweb
        $paciente = $this->db->GetRow("select edad_anio, usuarioweb_idusuarioweb, uw.sexo from paciente p
                        inner join usuarioweb uw on (uw.idusuarioweb=p.usuarioweb_idusuarioweb) where idpaciente=" . $record["paciente_idpaciente"]);

        if ($paciente["usuarioweb_idusuarioweb"] == "") {

            $paciente = $this->db->GetRow("select edad_anio, sexo from  paciente p
                        inner join pacientegrupofamiliar pg  on (pg.pacienteGrupo=p.idpaciente) where idpaciente=" . $record["paciente_idpaciente"]);
        }

        //si es varon
        if ($paciente["sexo"] == "1") {

            //si es pediatrico tiene mas campos para completar
            if ((int) $paciente["edad_anio"] < 18) {
                $record["puntaje_total"] = 15;
            } else {
                $record["puntaje_total"] = 14;
            }
        }
        //si es mujer tiene mas items para completar
        else {  //si es pediatrico tiene mas campos para completar
            if ((int) $paciente["edad_anio"] < 18) {
                $record["puntaje_total"] = 18;
            } else {
                $record["puntaje_total"] = 17;
            }
        }
        return parent::insert($record);
    }

    /*     * Metodo que retorna una arreglo con el estado Completado o No (1-0), de los campos requeridos del perfil de salud para consulta express
     * del paciente
     * 
     */

    public function getStatusPerfilPaciente($idpaciente) {

        $this->actualizarStatus($idpaciente);
        $rs = $this->db->getRow("select * from $this->table t where paciente_idpaciente=$idpaciente");

        //si obtenemos una incoherencia en el puntaje recalculamos 

        if ((int) $rs["puntaje_status"] > (int) $rs["puntaje_status"]) {
            // $this->actualizarStatus($idpaciente);
        }

        return $rs;
    }

    /*     * Metodo que retorna una arreglo en formato JSON con el estado Completado o No (1-0), de los campos requeridos del perfil de salud para consulta express
     * del paciente
     * 
     */

    public function getStatusPerfilPacienteJSON($idpaciente) {

        $rs = $this->db->getRow("select * from $this->table t where paciente_idpaciente=$idpaciente");
        //si obtenemos una incoherencia en el puntaje recalculamos 
        if ((int) $rs["puntaje_status"] > (int) $rs["puntaje_status"]) {
            $this->actualizarStatus($idpaciente);
        }

        $rs["PermitidoConsultaExpress"] = $this->getManager("ManagerPaciente")->isPermitidoConsultaExpress($idpaciente);
        $rs["PermitidoVideoConsulta"] = $this->getManager("ManagerPaciente")->isPermitidoVideoConsulta($idpaciente);
        return json_encode($rs);
    }

    /*     * Metodo que retorna una arreglo con el estado de las secciones requeridos del perfil de salud para consulta express
     * del paciente 
     * 
     */

    public function getStatusSeccionesFaltantes($idpaciente) {
        $paciente = $this->getManager("ManagerPaciente")->get($idpaciente);

        $secciones = [];

        $rs = $this->db->getRow("select * from $this->table t where paciente_idpaciente=$idpaciente");
        //si obtenemos una incoherencia en el puntaje recalculamos 
        if ((int) $rs["puntaje_status"] > (int) $rs["puntaje_status"]) {
            $this->actualizarStatus($idpaciente);
        }

        //validamos el estado completo de todos los apartados de las diferentes secciones del perfil de salud
        //-datos biometricos
        if ($rs["datosbiometricos"] == "1") {
            $secciones ["datosbiometricos"] = 1;
        } else {
            $secciones ["datosbiometricos"] = 0;
        }
        //-enfermedades y patologias
        if ($rs["enfermedades"] == "1" && $rs["patologias"] == "1") {
            $secciones ["enfermedades_patologias"] = 1;
        } else {
            $secciones ["enfermedades_patologias"] = 0;
        }



        //-ginecologico
        //si es varon no aplica la evaluacion
        if ($paciente["sexo"] == "1") {
            $secciones ["ginecologico"] = 1;
        } else {
            if ($rs["ginecologico_antecedentes"] == "1" && $rs["ginecologico_controles"] == "1" && $rs["ginecologico_embarazo"] == "1") {
                $secciones ["ginecologico"] = 1;
            } else {
                $secciones ["ginecologico"] = 0;
            }
        }
        //-antecedentes
        if ($rs["antecedentes_familiares"] == "1" && $rs["antecedentes_pediatricos"] == "1") {
            $secciones ["antecedentes"] = 1;
        } else {
            $secciones ["antecedentes"] = 0;
        }

        //-cirugias y protesis
        if ($rs["cirugias_protesis"] == "1") {
            $secciones ["cirugias_protesis"] = 1;
        } else {
            $secciones ["cirugias_protesis"] = 0;
        }

        //-alergias e intolerancias
        if ($rs["alergias_intolerancias"] == "1") {
            $secciones ["alergias_intolerancias"] = 1;
        } else {
            $secciones ["alergias_intolerancias"] = 0;
        }

        //-estilo de vida
        if ($rs["estilovida"] == "1") {
            $secciones ["estilovida"] = 1;
        } else {
            $secciones ["estilovida"] = 0;
        }

        return $secciones;
    }

    /*     * Metodo que actualiza el flag de status de perfil biometrico para CE si se han completado los campos necesarios:
     * - Peso
     * - Altura
     * - Grupo Sanguíneo
     * @param type $idpaciente
     */

    public function actualizarStatusBiometricos($idpaciente, $oldBiometrico, $MasaCorporal) {


        $Status = $this->getByField("paciente_idpaciente", $idpaciente);
        $puntos = $Status["puntaje_status"];

        $rs = $this->db->getRow("select peso, altura, grupofactorsanguineo_idgrupoFactorSanguineo as gruposanguineo from masacorporal m
                                inner join perfilsaludbiometricos pf on (m.perfilSaludBiometricos_idperfilSaludBiometricos=pf.idperfilSaludBiometricos)
                                where pf.paciente_idpaciente=$idpaciente
                                and m.ultimo=1");


        //verificamos si se ingreso desde grupo sanguineo
        if ($oldBiometrico != "-1") {
            //obtenemos los registros actuales para comparar los cambios luego de procesar los datos
            $actualBiometrico = $this->getManager("ManagerPerfilSaludBiometrico")->getByField("paciente_idpaciente", $idpaciente);

            //verificamos si ha cambiado el valor para sumar o restar puntos
            if ($oldBiometrico["grupofactorsanguineo_idgrupoFactorSanguineo"] == "" && $actualBiometrico["grupofactorsanguineo_idgrupoFactorSanguineo"] != "") {

                $puntos++;
            }
            if ($oldBiometrico["grupofactorsanguineo_idgrupoFactorSanguineo"] != "" && $actualBiometrico["grupofactorsanguineo_idgrupoFactorSanguineo"] == "") {

                $puntos--;
            }
        }

        //verificamos si se ingreso desde peso y alura
        if ($MasaCorporal != "-1") {

            $perfilSaludBiometrico = $this->getManager("ManagerPerfilSaludBiometrico")->getByField("paciente_idpaciente", $idpaciente);
            //verificamos si se ha ingresado el primer valor para sumar un punto
            $cantMasa = $this->db->getRow("select count(*) as qty from masacorporal where peso is not null and altura is not null and perfilSaludBiometricos_idperfilSaludBiometricos=" . $perfilSaludBiometrico["idperfilSaludBiometricos"]);
            if ($cantMasa["qty"] == 1) {
                $puntos++;
            }
        }
        //si estan seteados los valores necesarios ponemos el flag en 1
        if ($rs["peso"] != "" && $rs["altura"] != "" && $rs["gruposanguineo"]) {
            $this->db->Execute("update $this->table set datosbiometricos=1, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
        } else {
            $this->db->Execute("update $this->table set datosbiometricos=0, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
        }
    }

    /*     * Metodo que actualiza el flag de status de estilo de vida para CE si se han completado todos los campos
     * 
     */

    public function actualizarStatusEstiloVida($idpaciente, $old) {

        $Status = $this->getByField("paciente_idpaciente", $idpaciente);
        $puntos = $Status["puntaje_status"];

        $rs = $this->db->getRow("select actividad_fisica, consumo_tabaco, consumo_azucares_grasas,consumo_sal, consumo_alcohol from perfilsaludestilovida
                               
                                where paciente_idpaciente=$idpaciente");

        //si estan seteados los valores necesarios ponemos el flag en 1

        $completo = true;

        //verificamos los campos necesarios
        foreach ($rs as $key => $value) {
            //verificamos si ha cambiado el valor para sumar o restar puntos
            if ($old[$key] == "" && $rs[$key] != "") {
                $puntos++;
            }
            if ($old[$key] != "" && $rs[$key] == "") {
                $puntos--;
            }
            //si encontramos un campo vacio el perfil no esta completo
            if ($value == "") {
                $completo = false;
            }
        }


        if ($completo) {

            $this->db->Execute("update $this->table set estilovida=1, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
        } else {

            $this->db->Execute("update $this->table set estilovida=0, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
        }
    }

    /*     * Metodo que actualiza el flag de status de enfermedades para CE si se han completado todos los campos
     * 
     */

    public function actualizarStatusEnfermedades($idpaciente) {
        $Status = $this->getByField("paciente_idpaciente", $idpaciente);
        $puntos = $Status["puntaje_status"];
        $completo = true;

        $rs = $this->db->getRow("select varicela, rubiola, sarampion, escarlatina,eritema, exatema, papera from antecedentespersonales
                               
                                where paciente_idpaciente=$idpaciente");

        //verificamos si hay alguna enfermedad no seteada
        foreach ($rs as $value) {

            if ($value == "") {
                $completo = false;
            }
        }

        if ($completo && $Status["enfermedades"] == "0") {
            $puntos++;
        }
        if (!$completo && $Status["enfermedades"] == "1") {
            $puntos--;
        }
        //si estan seteados los valores necesarios ponemos el flag en 1
        if ($completo) {
            $this->db->Execute("update $this->table set enfermedades=1, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
        } else {
            $this->db->Execute("update $this->table set enfermedades=0, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
        }
    }

    /*     * Metodo que actualiza el flag de status de patologias para CE si se han completado todos los campos
     * 
     */

    public function actualizarStatusPatologias($idpaciente) {
        $Status = $this->getByField("paciente_idpaciente", $idpaciente);
        $puntos = $Status["puntaje_status"];
        $completo = true;

        $rsPatologias = $this->db->getRow("select hepatitisA, hepatitisB, hepatitisC,VPH,HIV from patologiasactuales
                               
                                where paciente_idpaciente=$idpaciente");
        //verificamos si hay alguna patologia no seteada
        foreach ($rsPatologias as $value) {
            if ($value == "") {
                $completo = false;
            }
        }

        if ($completo && $Status["patologias"] == "0") {
            $puntos++;
        }
        if (!$completo && $Status["patologias"] == "1") {
            $puntos--;
        }
        //si estan seteados los valores necesarios ponemos el flag en 1
        if ($completo) {

            $this->db->Execute("update $this->table set patologias=1, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
        } else {
            $this->db->Execute("update $this->table set patologias=0, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
        }
    }

    /*     * Metodo que actualiza el flag de status de anecedentes familiares para CE si se han completado todos los campos necesarios:
     *  un registro o bien marcar explicitamente "Ninguno de los mencionados"
     * 
     */

    public function actualizarStatusAntecedentesFamiliares($idpaciente) {

        $completo = false;
        $antecedentes = $this->getManager("ManagerPerfilSaludAntecedentes")->getByField("paciente_idpaciente", $idpaciente);
        $Status = $this->getByField("paciente_idpaciente", $idpaciente);
        $puntos = $Status["puntaje_status"];


        //verificamos si ha cambiado el valor para sumar o restar puntos
        if ($antecedentes["posee_antecedentesfamiliares"] != "" && $Status["antecedentes_familiares"] == 0) {
            $puntos++;
        }
        if ($antecedentes["posee_antecedentesfamiliares"] == "" && $Status["antecedentes_familiares"] == 1) {
            $puntos--;
        }

        //verificamos si se han completado los campos requeridos del perfil salud
        if ($antecedentes["posee_antecedentesfamiliares"] == "0") {

            $completo = true;
        } else {
            $rs = $this->db->getRow("select count(*) as qty from antecedentes_patologiafamiliar                            
                               where perfilSaludAntecedentes_idperfilSaludAntecedentes=" . $antecedentes["idperfilSaludAntecedentes"]);
            if ($rs["qty"] > 0) {
                $completo = true;
            } else {
                $puntos--;
            }
        }

        if ($completo) {
            $this->db->Execute("update $this->table set antecedentes_familiares=1, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
        } else {
            $this->db->Execute("update $this->table set antecedentes_familiares=0, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
        }

        //verificamos si el paciente es mayor de 18 años, los antecedentes pediatricos no son requeridos por lo que los damos por validados
        $paciente = $this->getManager("ManagerPaciente")->get($idpaciente);
        if ($paciente["edad_anio"] >= 18) {
            $this->db->Execute("update $this->table set antecedentes_pediatricos=1 where paciente_idpaciente=$idpaciente");
        }
    }

    /*     * Metodo que actualiza el flag de status de anecedentes_pediatricos para CE si se han completado todos los campos necesarios:
     *  talla, per_cef, peso, cesarea o parto si es paciente es pediatrico
     * 
     */

    public function actualizarStatusAntecedentesPediatricos($idpaciente, $from_perinatales) {

        $Status = $this->getByField("paciente_idpaciente", $idpaciente);
        $puntos = $Status["puntaje_status"];


        $paciente = $this->getManager("ManagerPaciente")->get($idpaciente);

// si es menor de edad valido los perinatales
        $pediatrico = true;


        if ($from_perinatales && (int) $paciente["edad_anio"] < 18) {


            /* $rs = $this->db->getRow("select talla, per_cef, peso, is_cesarea,is_parto from perfilsaludantecedentes

              where paciente_idpaciente=$idpaciente"); */

            //verificamos los campos necesarios
            $sumar = true;
            /* foreach ($rs as $value) {


              //si encontramos un campo vacio el perfil no esta completo
              if ($value == "") {
              $sumar = false;
              $pediatrico = false;
              }
              } */
            if ($sumar && $Status["antecedentes_pediatricos"] == 0) {
                $puntos++;
            }
            if (!$sumar && $Status["antecedentes_pediatricos"] == 1) {
                $puntos--;
            }
        }

        if ($from_perinatales) {
            if ($pediatrico) {
                $this->db->Execute("update $this->table set antecedentes_pediatricos=1, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
            } else {
                $this->db->Execute("update $this->table set antecedentes_pediatricos=0, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
            }
        }
    }

    /** Metodo que actualiza el flag de status de alergias e intolerancias para CE si se han chequeado si se posee
     * 
     */
    public function actualizarStatusAlergias($idpaciente) {
        $Status = $this->getByField("paciente_idpaciente", $idpaciente);
        $puntos = $Status["puntaje_status"];
        $rs = $this->db->getRow("select posee_intolerancia, posee_causa_intolerancia from perfilsaludalergia
                               
                                where paciente_idpaciente=$idpaciente");



        $completoAlergias = true;
        //verificamos si hay alguna check no seteado en el formulario de Alergias


        if ($rs["posee_intolerancia"] == "") {
            $completoAlergias = false;
        } else if ($rs["posee_intolerancia"] == "1" && $rs["posee_causa_intolerancia"] == "") {
            $completoAlergias = false;
        }
        if ($completoAlergias && $Status["alergias_intolerancias"] == 0) {
            $puntos++;
        }
        if (!$completoAlergias && $Status["alergias_intolerancias"] == 1) {
            $puntos--;
        }



        //si estan seteados los valores necesarios ponemos el flag en 1
        if ($completoAlergias) {
            $this->db->Execute("update $this->table set alergias_intolerancias=1, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
        } else {
            $this->db->Execute("update $this->table set alergias_intolerancias=0, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
        }
    }

    /*     * Metodo que actualiza el flag de status de perfil ginecologico para CE si se han ingresado los campos requeridos obligatorios
     * 
     */

    public function actualizarStatusGinecologico($idpaciente, $request) {
        $Status = $this->getByField("paciente_idpaciente", $idpaciente);
        $puntos = $Status["puntaje_status"];

        $completoAntecedentes = true;
        if ($request["from_antecedentes"]) {
            $rsAntecedentes = $this->db->getRow("select posee_menarca,  vida_sexual_activa from perfilsaludginecologico
                                                               where paciente_idpaciente=$idpaciente");



            //verificamos si hay alguna check no seteado en el formulario de Antecedentes
            foreach ($rsAntecedentes as $value) {
                //verificamos si ha cambiado el valor para sumar o restar puntos
                if ($value == "") {
                    $completoAntecedentes = false;
                }
            }
            if ($completoAntecedentes && $Status["ginecologico_antecedentes"] == 0) {
                $puntos++;
            }
            if (!$completoAntecedentes && $Status["ginecologico_antecedentes"] == 1) {
                $puntos--;
            }

            //si estan seteados los valores necesarios ponemos el flag en 1
            if ($completoAntecedentes) {
                $this->db->Execute("update $this->table set ginecologico_antecedentes=1, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
            } else {
                $this->db->Execute("update $this->table set ginecologico_antecedentes=0, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
            }
        }
        $completoControles = true;
        if ($request["from_controles"]) {

            $rsControles = $this->db->getRow("select no_mam,no_pap, VPH from perfilsaludginecologico
                                                               where paciente_idpaciente=$idpaciente");

            //verificamos si hay alguna check no seteado en el formulario de Controles
            foreach ($rsControles as $value) {
                //verificamos si ha cambiado el valor para sumar o restar puntos
                if ($value == "") {
                    $completoControles = false;
                }
            }
            if ($completoControles && $Status["ginecologico_controles"] == 0) {
                $puntos++;
            }
            if (!$completoControles && $Status["ginecologico_controles"] == 1) {
                $puntos--;
            }

            //si estan seteados los valores necesarios ponemos el flag en 1
            if ($completoControles) {
                $this->db->Execute("update $this->table set ginecologico_controles=1, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
            } else {
                $this->db->Execute("update $this->table set ginecologico_controles=0, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
            }
        }
        $completoEmbarazo = true;
        if ($request["from_embarazo"]) {

            $rsEmbarazo = $this->db->getRow("select  is_embarazada from perfilsaludginecologico
                                                               where paciente_idpaciente=$idpaciente");


            //verificamos si hay alguna check no seteado en el formulario de Embarazo
            foreach ($rsEmbarazo as $value) {
                //verificamos si ha cambiado el valor para sumar o restar puntos
                if ($value == "") {
                    $completoEmbarazo = false;
                }
            }
            if ($completoEmbarazo && $Status["ginecologico_embarazo"] == 0) {
                $puntos++;
            }
            if (!$completoEmbarazo && $Status["ginecologico_embarazo"] == 1) {
                $puntos--;
            }

            //si estan seteados los valores necesarios ponemos el flag en 1
            if ($completoEmbarazo) {
                $this->db->Execute("update $this->table set ginecologico_embarazo=1, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
            } else {
                $this->db->Execute("update $this->table set ginecologico_embarazo=0, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
            }
        }
    }

    /*     * Metodo que actualiza el flag de status de perfil de cirugias y protesis para CE si se han ingresado los campos requeridos 
     * 
     */

    public function actualizarStatusCirugiasProtesis($idpaciente, $old) {

        $actual = $this->getManager("ManagerPerfilSaludCirugiasProtesis")->getByField("paciente_idpaciente", $idpaciente);
        $Status = $this->getByField("paciente_idpaciente", $idpaciente);
        $puntos = $Status["puntaje_status"];

        $rs = $this->db->getRow("select posee_cirugia, posee_protesis from perfilsaludcirugiasprotesis
                               
                                where paciente_idpaciente=$idpaciente");



        $completo = true;

        //verificamos los campos necesarios
        foreach ($rs as $key => $value) {

            //verificamos si ha cambiado el valor para sumar o restar puntos
            if ($old[$key] == "" && $actual[$key] != "") {
                $puntos++;
            }
            if ($old[$key] != "" && $actual[$key] == "") {
                $puntos--;
            }

            //si encontramos un campo vacio el perfil no esta completo
            if ($value == "") {

                $completo = false;
            }
        }


        //si estan seteados los valores necesarios ponemos el flag en 1 y actualizamos el puntaje
        if ($completo) {
            $this->db->Execute("update $this->table set cirugias_protesis=1, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
        } else {
            $this->db->Execute("update $this->table set cirugias_protesis=0, puntaje_status=$puntos where paciente_idpaciente=$idpaciente");
        }
    }

    public function fix_status_perfil() {

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("paciente");
        $list = $this->getList($query);

        foreach ($list as $paciente) {
            $this->actualizarStatus($paciente["idpaciente"]);
        }
    }

    /*     * Metodo que limpia y actualiza  todos los campos del status de perfil de salud de forma forzada recalculando los valores
     * 
     */

    public function actualizarStatus($idpaciente) {

        ////si es paciente titular posee usuarioweb
        $paciente = $this->db->getRow("select p.idpaciente, edad_anio, usuarioweb_idusuarioweb, uw.sexo from paciente p
                        inner join usuarioweb uw on (uw.idusuarioweb=p.usuarioweb_idusuarioweb) where idpaciente=" . $idpaciente);

        if ($paciente["usuarioweb_idusuarioweb"] == "") {
            //si es paciente titular posee usuarioweb
            $paciente = $this->db->getRow("select p.idpaciente,edad_anio, sexo from paciente p
                        inner join pacientegrupofamiliar pg on (pg.pacienteGrupo=p.idpaciente) where idpaciente=" . $idpaciente);
        }

        //si no se ha encontrado el paciente cuyo id viene como parametro cancelamos la ejecucion
        if ($paciente["idpaciente"] == "") {
            return false;
        }

        //borramos el perfil de salud status creado para el paciente
        $old_perfil_salud = $this->getByField("paciente_idpaciente", $idpaciente);
        $this->db->Execute("delete from $this->table where paciente_idpaciente=$idpaciente");
        if ($old_perfil_salud["wizard_step"]) {
            $step = $old_perfil_salud["wizard_step"];
        } else {
            $step = 1;
        }

        //generamos un nuevo registro
        $idperfilsaludstatus = $this->insert(["paciente_idpaciente" => $idpaciente, "wizard_step" => $step]);

        //calculamos los valores
        $puntos = 0;
        //perfil biometricos
        $rsbiometricos = $this->db->getRow("select peso, altura, grupofactorsanguineo_idgrupoFactorSanguineo as gruposanguineo from masacorporal m
                                inner join perfilsaludbiometricos pf on (m.perfilSaludBiometricos_idperfilSaludBiometricos=pf.idperfilSaludBiometricos)
                                where pf.paciente_idpaciente=$idpaciente
                                and m.ultimo=1");
        if ($rsbiometricos["peso"] != "" && $rsbiometricos["altura"] != "") {
            $puntos++;
        }
        if ($rsbiometricos["gruposanguineo"] != "") {
            $puntos++;
        }
        if ($rsbiometricos["peso"] != "" && $rsbiometricos["altura"] != "" && $rsbiometricos["gruposanguineo"] != "") {
            $this->db->Execute("update perfilsaludstatus set datosbiometricos=1 where idperfilsaludstatus=$idperfilsaludstatus");
        }

        //perfil enfermedades y patologias
        $rsEnfermedades = $this->db->getRow("select varicela, rubiola, sarampion, escarlatina,eritema, exatema, papera from antecedentespersonales
                                                               where paciente_idpaciente=$idpaciente");

        $completoEnfermedades = true;

        if (Count($rsEnfermedades) == 0) {
            $completoEnfermedades = false;
        }
        //verificamos si hay alguna enfermedad no seteada
        foreach ($rsEnfermedades as $value) {

            if ($value == "") {
                $completoEnfermedades = false;
            }
        }
        if ($completoEnfermedades) {
            $puntos++;

            $this->db->Execute("update perfilsaludstatus set enfermedades=1 where idperfilsaludstatus=$idperfilsaludstatus");
        }

        $rsPatologias = $this->db->getRow("select hepatitisA, hepatitisB, hepatitisC,VPH,HIV from patologiasactuales
                               
                                where paciente_idpaciente=$idpaciente");

        $completoPatologias = true;
        if (Count($rsPatologias) == 0) {
            $completoPatologias = false;
        }
        //verificamos si hay alguna patologias no seteada
        foreach ($rsPatologias as $value) {

            if ($value == "") {
                $completoPatologias = false;
            }
        }
        if ($completoPatologias) {
            $puntos++;

            $this->db->Execute("update perfilsaludstatus set patologias=1 where idperfilsaludstatus=$idperfilsaludstatus");
        }

        //perfil salud ginecologico  
        //verificamos si aplica siendo mujer

        if ($paciente["sexo"] == "0") {
            /*
              $rsAntecedentes = $this->db->getRow("select posee_menarca,  vida_sexual_activa from perfilsaludginecologico
              where paciente_idpaciente=$idpaciente");
              $completoAntecedentes = true;
              if (Count($rsAntecedentes) == 0) {
              $completoAntecedentes = false;
              }
              //verificamos si hay alguna check no seteado en el formulario de Antecedentes
              foreach ($rsAntecedentes as $value) {
              //verificamos si ha cambiado el valor para sumar o restar puntos
              if ($value == "") {
              $completoAntecedentes = false;
              }
              }
              if ($completoAntecedentes) {

              $puntos++;
              $this->db->Execute("update $this->table set ginecologico_antecedentes=1 where idperfilsaludstatus=$idperfilsaludstatus");
              }
              $rsControles = $this->db->getRow("select no_mam,no_pap, VPH from perfilsaludginecologico
              where paciente_idpaciente=$idpaciente");
              $completoControles = true;
              if (Count($rsControles) == 0) {
              $completoControles = false;
              }
              //verificamos si hay alguna check no seteado en el formulario de Controles
              foreach ($rsControles as $value) {
              //verificamos si ha cambiado el valor para sumar o restar puntos
              if ($value == "") {
              $completoControles = false;
              }
              }
              if ($completoControles) {
              $puntos++;

              $this->db->Execute("update $this->table set ginecologico_controles=1 where idperfilsaludstatus=$idperfilsaludstatus");
              } */

            $completoEmbarazo = true;
            $rsEmbarazo = $this->db->getRow("select  is_embarazada from perfilsaludginecologico
                                                               where paciente_idpaciente=$idpaciente");
            if (Count($rsEmbarazo) == 0) {
                $completoEmbarazo = false;
            }
            //verificamos si hay alguna check no seteado en el formulario de Embarazo
            foreach ($rsEmbarazo as $value) {
                //verificamos si ha cambiado el valor para sumar o restar puntos
                if ($value == "") {
                    $completoEmbarazo = false;
                }
            }
            if ($completoEmbarazo) {
                $puntos++;

                $this->db->Execute("update $this->table set ginecologico_embarazo=1, ginecologico_controles=1, ginecologico_antecedentes=1 where idperfilsaludstatus=$idperfilsaludstatus");
            }
        }

        //perfil salud antecedentes familiares y pediatricos
        //verificamos si se han completado los campos requeridos del perfil salud
        $antecedentes = $this->getManager("ManagerPerfilSaludAntecedentes")->getByField("paciente_idpaciente", $idpaciente);

        if ($antecedentes != "") {


            $completoAntecedentesFamiliares = false;
            if ($antecedentes["posee_antecedentesfamiliares"] == "0") {

                $completoAntecedentesFamiliares = true;
            } else {
                $rsAntecedentesFamilires = $this->db->getRow("select count(*) as qty from antecedentes_patologiafamiliar                            
                               where perfilSaludAntecedentes_idperfilSaludAntecedentes=" . $antecedentes["idperfilSaludAntecedentes"]);
                if ($rsAntecedentesFamilires["qty"] > 0 && $antecedentes["posee_antecedentesfamiliares"] == "1") {
                    $completoAntecedentesFamiliares = true;
                }
            }
            if ($completoAntecedentesFamiliares) {
                $puntos++;

                $this->db->Execute("update $this->table set antecedentes_familiares=1 where idperfilsaludstatus=$idperfilsaludstatus");
            }
        }
        //si es mayor de edad tiene aprobado el perfil pediatrico
        if ((int) $paciente["edad_anio"] >= 18) {
            $this->db->Execute("update $this->table set antecedentes_pediatricos=1 where paciente_idpaciente=$idpaciente");
        } else {
            $completoPediatrico = true;
            /* $rsPediatricos = $this->db->getRow("select talla, per_cef, peso, is_cesarea,is_parto from perfilsaludantecedentes
              where paciente_idpaciente=$idpaciente");
              if (Count($rsPediatricos) == 0) {
              $completoPediatrico = false;
              }
              foreach ($rsPediatricos as $value) {
              if ($value == "") {
              $completoPediatrico = false;
              }
              } */
            if ($completoPediatrico) {
                $puntos++;

                $this->db->Execute("update $this->table set antecedentes_pediatricos=1 where idperfilsaludstatus=$idperfilsaludstatus");
            }
        }
        //perfil salud cirugias y protesis
        $rsCirugiasProtesis = $this->db->getRow("select posee_cirugia, posee_protesis from perfilsaludcirugiasprotesis
                                                 where paciente_idpaciente=$idpaciente");
        $completoCirugiasProtesis = true;
        if (Count($rsCirugiasProtesis) == 0) {
            $completoCirugiasProtesis = false;
        }
        foreach ($rsCirugiasProtesis as $value) {
            //verificamos si ha cambiado el valor para sumar o restar puntos
            if ($value == "") {
                $completoCirugiasProtesis = false;
            } else {
                $puntos++;
            }
        }
        if ($completoCirugiasProtesis) {
            $this->db->Execute("update $this->table set cirugias_protesis=1 where idperfilsaludstatus=$idperfilsaludstatus");
        }

        //perfil salud alergias

        $rsAlergias = $this->db->getRow("select posee_intolerancia, posee_causa_intolerancia from perfilsaludalergia
                               
                                where paciente_idpaciente=$idpaciente");

        $completoAlergias = true;
        if (Count($rsAlergias) == 0) {
            $completoAlergias = false;
        }
        //verificamos si hay alguna check no seteado en el formulario de Alergias


        if ($rsAlergias["posee_intolerancia"] == "") {
            $completoAlergias = false;
        } else if ($rsAlergias["posee_intolerancia"] == "1" && $rsAlergias["posee_causa_intolerancia"] == "") {
            $completoAlergias = false;
        }
        if ($completoAlergias) {

            $puntos++;
            $this->db->Execute("update $this->table set alergias_intolerancias=1 where idperfilsaludstatus=$idperfilsaludstatus");
        }


        //perfil salud estilo vida
        $rsEsiloVida = $this->db->getRow("select actividad_fisica, consumo_tabaco, consumo_azucares_grasas,consumo_sal, consumo_alcohol from perfilsaludestilovida
                               
                                where paciente_idpaciente=$idpaciente");

        $completoEstiloVida = true;
        if (Count($rsEsiloVida) == 0) {
            $completoEstiloVida = false;
        }
        foreach ($rsEsiloVida as $value) {
            //verificamos si ha cambiado el valor para sumar o restar puntos
            if ($value == "") {
                $completoEstiloVida = false;
            } else {
                $puntos++;
            }
        }
        if ($completoEstiloVida) {
            $this->db->Execute("update $this->table set estilovida=1 where idperfilsaludstatus=$idperfilsaludstatus");
        }

        //perfil salud control visual
        $rsControlVisual = $this->db->getRow("select * from perfilsaludcontrolvisual where paciente_idpaciente=$idpaciente");

        $completoControlVisual = false;
        if ($rsControlVisual["idperfilSaludControlVisual"] != "") {
            $completoControlVisual = true;
        }

        if ($completoControlVisual) {
            $puntos++;
            $this->db->Execute("update $this->table set control_visual=1 where idperfilsaludstatus=$idperfilsaludstatus");
        }

        //finalmente asignamos los puntajes del status
        $this->db->Execute("update $this->table set puntaje_status=$puntos where idperfilsaludstatus=$idperfilsaludstatus");
    }

    /*     * Metodo que retorna la url de la primer seccion del perfil de salud  que le falta completar al paciente
     * 
     * @param type $status
     */

    public function getUrlSeccionIncompleta($status) {
        $paciente = $this->getManager("ManagerPaciente")->get($status["paciente_idpaciente"]);
        if ($status["datosbiometricos"] == 0) {
            return URL_ROOT . "panel-paciente/perfil-salud/datos-biometricos.html";
        }
        if ($status["enfermedades"] == 0 || $status["patologias"] == 0) {
            return URL_ROOT . "panel-paciente/perfil-salud/enfermedades-patologias.html";
        }

        if ($status["alergias_intolerancias"] == 0) {
            return URL_ROOT . "panel-paciente/perfil-salud/alergias-intolerancias.html";
        }


        if ($paciente["sexo"] == 0) {
            if ($status["ginecologico_controles"] == 0 || $status["ginecologico_embarazo"] == 0 || $status["ginecologico_antecedentes"] == 0) {
                return URL_ROOT . "panel-paciente/perfil-salud/ginecologico-obstetrico.html";
            }
        }

        if ($status["cirugias_protesis"] == 0) {
            return URL_ROOT . "panel-paciente/perfil-salud/cirugias-protesis.html";
        }

        if ($status["control_visual"] == 0) {
            return URL_ROOT . "panel-paciente/perfil-salud/control-visual.html";
        }
        if ($status["estilovida"] == 0) {
            return URL_ROOT . "panel-paciente/perfil-salud/estilo-vida.html";
        }



        /* No disponibles aun
          if($status["control_dental"]==0){
          return URL_ROOT."panel-paciente/perfil-salud/control-dental.html";
          }
          if($status["control_auditivo"]==0){
          return URL_ROOT."panel-paciente/perfil-salud/control-auditivo.html";
          }
         */

        //si esta todo completo retornamos false
        return false;
    }

    public function update_wizard_step($step, $idpaciente) {

        $perfil_salud = $this->getByField("paciente_idpaciente", $idpaciente);

        return parent::update(["wizard_step" => $step], $perfil_salud["idperfilSaludStatus"]);
    }

}
