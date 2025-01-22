<?php

/**
 * 	Manager de la documentacion del medico adjuntada por el admin
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerDocumentacionMedico extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "documentacionmedico", "iddocumentacionMedico");
    }

    /*     * Metodo que procesa la subida de documentacion creando la entidad con titulo y fecha
     * 
     * 
     * @param type $request
     * @return boolean
     */

    public function process($request) {

        if ($request["titulo"] == "") {
            $this->setMsg(["result" => false, "msg" => "Ingrese una descripción de la documentación"]);
            return false;
        }
        if ($request["cantidad_file"] == 0 && $request["cantidad"] == 0  ) {
            $this->setMsg(["result" => false, "msg" => "No se ha seleccionado ningun archivo"]);
            return false;
        }
        $this->db->StartTrans();
        $request["fecha"] = date("Y-m-d H:i:s");
        $rdo = parent::process($request);
        if (!$rdo) {
            $this->setMsg([ "result" => false, "msg" => "Se produjo un error, verifique los datos"]);

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        $request["iddocumentacionMedico"] = $rdo;
        $ManagerArchivosDocumentacionMedico = $this->getManager("ManagerArchivosDocumentacionMedico");
        $insert_archivos = $ManagerArchivosDocumentacionMedico->process($request);
        if (!$insert_archivos) {
            $this->setMsg($ManagerArchivosDocumentacionMedico->getMsg());

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        } else {
            $this->setMsg([ "result" => true, "msg" => "Se ha guardado la documentación correctamente", "id" => $rdo]);
            $this->db->CompleteTrans();
            return $rdo;
        }
    }

    /*     * Metodo que obtiene el listado de documentacion que se ha adjuntado al medico
     * 
     */

    public function getListadoDocumentacion($idmedico) {
        if ((int) $idmedico > 0) {
            $query = new AbstractSql();
            $query->setSelect("*");
            $query->setFrom("$this->table ");
            $query->setWhere("medico_idmedico={$idmedico}");
            $query->setOrderBy("fecha ASC");


            $listado = $this->getList($query);
            return $listado;
        }
    }

}

//END_class
?>