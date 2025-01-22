<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de las vacunas 
 *
 */
class ManagerVacuna extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "vacuna", "idvacuna");

        $this->flag = "activo";
    }

    public function process($request) {

        if ($request["genera_notificacion"] != 1) {
            $request["genera_notificacion"] = 0;
        }
        return parent::process($request);
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {
        $request["activo"] = 1;
        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {

            $this->setMsg(["result" => true, "msg" => "La vacuna ha sido creado con éxito"]);
        }

        return $id;
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("idvacuna,vacuna,descripcion,CASE activo
                  WHEN 1 THEN 'SI'
                  WHEN 0 THEN 'NO'
                  END as activo,
                  CASE genera_notificacion
                  WHEN 1 THEN 'SI'
                  WHEN 0 THEN 'NO'
                  END as genera_notificacion
                  ");

        $query->setFrom("
                $this->table
            ");

        // Filtro
        if ($request["vacuna"] != "") {

            $nombre = cleanQuery($request["vacuna"]);

            $query->addAnd("vacuna LIKE '%$nombre%'");
        }


        $query->setOrderBy("vacuna ASC");

        $data = $this->getJSONList($query, array("vacuna", "descripcion", "activo", "genera_notificacion"), $request, $idpaginate);

        return $data;
    }

    public function getListadoVacunas() {



        $query = new AbstractSql();
        $query->setSelect("idvacuna,vacuna,descripcion
                  ");

        $query->setFrom("
                $this->table
            ");

        $query->setWhere("activo=1");


        $data = $this->getList($query);

        return $data;
    }

    /**
     * ComboBox de vacunas
     * @return type
     */
    public function getCombo() {

        $query = new AbstractSql();

        $query->setSelect("$this->id, vacuna");

        $query->setFrom("$this->table");

        $query->setWhere("activo = 1");

        return $this->getComboBox($query, false);
    }

    public function getInformationTable($idpaciente) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("activo = 1 ");

        $listado_vacuna = $this->getList($query);


        if ($listado_vacuna && count($listado_vacuna) > 0) {
            $ManagerVacunaEdad = $this->getManager("ManagerVacunaEdad");
            $ManagerVacunaVacunaEdad = $this->getManager("ManagerVacunaVacunaEdad");

            $listado_vacuna_edad = $ManagerVacunaEdad->getListVacunaEdad();

            foreach ($listado_vacuna as $key => $vacuna) {


                $listado_vacuna[$key]["vacunaedad"] = $listado_vacuna_edad;

                //Por cada vacuna listo la vacuna edad..
                //Le voy a agregar un listado en el cual si está la configuración que la cargue
                foreach ($listado_vacuna_edad as $key2 => $vacuna_edad) {


                    $vacuna_vacunaedad = $ManagerVacunaVacunaEdad->getXRelacion($vacuna[$this->id], $vacuna_edad["idvacunaEdad"], $idpaciente);
                    //if($vacuna["idvacuna"]==3){
                    //                        $this->debug(false);
                    //                  }
                    //si hay vacuna en esa edad la agregamos
                    if ($vacuna_vacunaedad) {
                        $listado_vacuna[$key]["vacunaedad"][$key2]["vacuna_vacunaedad"] = $vacuna_vacunaedad;
                    } else {
                        $listado_vacuna[$key]["vacunaedad"][$key2]["vacuna_vacunaedad"] = false;
                    }
                }
                //      if($vacuna["idvacuna"]==3){
                //        print_r($listado_vacuna[$key]); 
                //     }
            }

            return $listado_vacuna;
        } else {
            return false;
        }
    }

}

//END_class
?>