<?php

/**
 * 	@autor Juan Sartor
 * 	@version 1.0	18/01/2022
 * 	Manager de IbanBeneficiario
 *
 */
class ManagerIbanBeneficiario extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "ibanbeneficiario", "idIbanBeneficiario");
    }

    /**
     * Metodo que carga asocia el iban a un beneficiario 
     */
    public function insertarIban($request) {

        $requesInsert["iban"] = $request["ibanForm2"];
        $requesInsert["usuarioWeb_idusuarioweb"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuarioweb"];

        //inserto el nuevo iban
        if (parent::insert($requesInsert)) {
            $this->setMsg(["msg" => "Exito. Se han cargado los archivos correctamente", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No se pudo cargar los archivos", "result" => false]);
            return false;
        }
    }

    /**
     *   funcion para eliminar iban 
     * @param type $idIbanBeneficiario
     * @return boolean
     */
    public function deleteIban($idIbanBeneficiario) {
//        $this->debug();
        $delete = parent::delete($idIbanBeneficiario);
        if ($delete) {
            $this->setMsg(["msg" => "El Iban se eliminó con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "El Iban no pudo ser eliminado con éxito", "result" => false]);
            return false;
        }
    }

}

//END_class
?>