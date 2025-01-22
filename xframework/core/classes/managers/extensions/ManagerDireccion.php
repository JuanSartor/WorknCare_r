<?php

/**
 * 	Manager de Direccion
 *
 * 	@author UTN
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerDireccion extends ManagerMaestros {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "direccion", "iddireccion");
    }

    /**
     * Obtiene un registro de dirección
     * @param int $id identificador de la dirección 
     * @return array 
     * 
     */
    public function get($id) {

        $direccion = parent::get($id);

        if ($direccion) {

            $localidad = $this->getManager("ManagerLocalidad")->getFull($direccion["localidad_idlocalidad"]);

            if ($localidad) {
                $direccion = array_merge($direccion, $localidad);
            }
        }

        return $direccion;
    }

    /**
     * Metodo que proces la direccion del consultorio.  Se asocia al medico y a sus consultorios
     * @param type $request
     */
    public function processDireccionMedico($request) {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        $ManagerMedico = $this->getManager("ManagerMedico");
        $ManagerConsultorio = $this->getManager("ManagerConsultorio");

        //obtenemos info del medico previamente para comparar la actualizacion de datos
        $info_medico = $ManagerMedico->getInfoMenuMedico($idmedico);

        //limpiamos el telefono del formato del plugin
        $request["telefono"] = str_replace(" ", "", $request["telefono"]);
        $request["telefono"] = str_replace("-", "", $request["telefono"]);
        $request["mostrar_direccion"] = $request["mostrar_direccion"] == 1 ? 1 : 0;
        $this->db->StartTrans();

        //guardamos los datos
        $id = parent::process($request);

        if (!$id) {
            $this->setMsg(["result" => false, "msg" => "Ha ocurrido un error."]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        $direccion["direccion_iddireccion"] = $id;
        //asociamos la direccion del consulorio
        $list_consultorios = $ManagerConsultorio->getListconsultorioMedico($idmedico);

        foreach ($list_consultorios as $consultorio) {

            $upd_consultorio = $ManagerConsultorio->update($direccion, $consultorio["idconsultorio"]);
            if (!$upd_consultorio) {
                $this->setMsg(["result" => false, "msg" => "Ha ocurrido un error."]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }
        //asociamos la direccion al médico
        $upd_medicos = $ManagerMedico->basic_update($direccion, $idmedico);
        if (!$upd_medicos) {
            $this->setMsg(["result" => false, "msg" => "Ha ocurrido un error."]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        //verificamos si compelto los datos minimos requeridos

        $showModal = false;

        // completo la direccion -> Hacemos la consulta de los datos restantes
        if ($info_medico["consultorio_virtual"]["idconsultorio"] != "" && //tiene consultorio virtual
                $info_medico["medico"]["direccion_iddireccion"] == "" && //NO tenia direccion seteada antes
                $info_medico["medico"]["preferencia"]["valorPinesVideoConsultaTurno"] != "") { //tiene precio VC seteados
            // En este caso forzamos a mostrar el modal.
            $showModal = true;
        }

        $this->setMsg(["result" => true, "msg" => "Datos guardados con éxito", "showModal" => $showModal]);
        $this->db->CompleteTrans();
        return $id;
    }

    /**
     *  Metodo que retorna las coordenadas e informacion de los medicos para listar los puntero de google maps
     * @param type $idmedico
     * @return type
     */
    public function getDireccionToGoogleMap($idmedico) {
        $query = new AbstractSql();

        $query->setSelect("d.iddireccion, d.direccion,d.numero,l.localidad,p.pais,m.idmedico, d.lat, d.lng,uw.nombre, uw.apellido, CONCAT(tp.titulo_profesional,' ',uw.nombre, ' ', uw.apellido ) as name");

        $query->setFrom("direccion d "
                . "INNER JOIN localidad l ON (d.localidad_idlocalidad = l.idlocalidad)"
                . "INNER JOIN pais p ON (d.pais_idpais = p.idpais)"
                . "INNER JOIN medico m ON (d.iddireccion = m.direccion_iddireccion)"
                . "INNER JOIN usuarioweb uw ON (uw.idusuarioweb = m.usuarioweb_idusuarioweb) "
                . "LEFT JOIN titulo_profesional tp ON (tp.idtitulo_profesional=m.titulo_profesional_idtitulo_profesional)");

        $query->setWhere("m.idmedico =$idmedico");

        $rdo = $this->getList($query);


        $ManagerEspecialidadMedico = $this->getManager("ManagerEspecialidadMedico");
        $ManagerMedico = $this->getManager("ManagerMedico");

        foreach ($rdo as $key => $medico) {
            $rdo[$key]["especialidad"] = $ManagerEspecialidadMedico->getEspecialidadesMedico($medico["idmedico"])[0]["especialidad"];
            $rdo[$key]["imagen"] = $ManagerMedico->getImagenMedico($medico["idmedico"]);


            $str_name = $rdo[$key]["idmedico"] . "-" . $rdo[$key]["nombre"] . "-" . $rdo[$key]["apellido"];
            $rdo[$key]["seo"] = str2seo($str_name);
        }
        return $rdo;
    }

}

//END_class 
?>