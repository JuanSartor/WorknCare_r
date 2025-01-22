<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los PLANES de las Obras Sociales - Prepagas
 *
 */
class ManagerSubTipoAlergia extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "subTipoAlergia", "idsubTipoAlergia");
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $id = parent::insert($request);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($id) {
            $this->setMsg(["msg"=>"La sub tipo alergia ha sido creado con éxito","result"=>true]);
        }

        return $id;
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $query = new AbstractSql();
        $query->setSelect("
                $this->id,
                subTipoAlergia
            ");
        $query->setFrom("
                $this->table
            ");
        $idespecialidad = (int) $request["tipoAlergia_idtipoAlergia"];
        $query->setWhere("tipoAlergia_idtipoAlergia=$idespecialidad");
        // Filtro
        if ($request["subTipoAlergia"] != "") {

            $nombre = cleanQuery($request["subTipoAlergia"]);

            $query->addAnd("subTipoAlergia LIKE '%$nombre%'");
        }

        $query->setOrderBy("subTipoAlergia ASC");

        $data = $this->getJSONList($query, array("subTipoAlergia"), $request, $idpaginate);

        return $data;
    }

    public function getCombo($idtipoAlergia) {

        $query = new AbstractSql();
        $query->setSelect("$this->id,subTipoAlergia");
        $query->setFrom("$this->table");
        $query->setWhere("tipoAlergia_idtipoAlergia=$idtipoAlergia");

        return $this->getComboBox($query, false);
    }

    public function getArrayAlergiasPaciente($idpaciente) {
        //OBtengo el perfil de salud alergia perteneciente al usuario
        $ManagerPerfilSaludAlergia = $this->getManager("ManagerPerfilSaludAlergia");
        $perfil_salud_alergia = $ManagerPerfilSaludAlergia->getByField("paciente_idpaciente", $idpaciente);



        $query = new AbstractSql();

        $query->setSelect("ta.*");

        $query->setFrom("tipoalergia ta");

        $listado = $this->getList($query);

        if ($listado && count($listado) > 0) {
            foreach ($listado as $key => $value) {
                if ($perfil_salud_alergia) {
                    //Si hay perfil de salud alergia, entonces obtengo todos que sean iguales al perfil salud alergia
                    $sub_tipo_alergia = $this->getListXTipoAlergiaAndPaciente($value["idtipoAlergia"], $perfil_salud_alergia["idperfilSaludAlergia"]);
                } else {
                    $sub_tipo_alergia = $this->getListXTipoAlergia($value["idtipoAlergia"]);
                }

                if ($sub_tipo_alergia) {
                    $listado[$key]["array_subtipoAlergia"] = $sub_tipo_alergia;
                }
            }
            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Sub tipo de alergia paciente
     * @param type $idpaciente
     * @return type
     */
    public function getArraySubTipoAlergiaPaciente($idpaciente) {

        $query = new AbstractSql();

        $query->setSelect("
               t.*,psa.texto
            ");

        $query->setFrom("
                subtipoalergia t
                        LEFT JOIN perfilsaludalergia_subtipoalergia psa ON (t.idsubTipoAlergia = psa.subTipoAlergia_idsubTipoAlergia)
                        LEFT JOIN perfilsaludalergia a ON (a.idperfilSaludAlergia = psa.perfilSaludAlergia_idperfilSaludAlergia)
            ");

        $query->setWhere("a.paciente_idpaciente = $idpaciente");

        return $this->getList($query);
    }

    /**
     * Listado por tipo de alergia 
     * @param type $idtipoAlergia
     */
    public function getListXTipoAlergia($idtipoAlergia) {
        $query = new AbstractSql();

        $query->setSelect("
               *,
               0 as is_checked,
               '' as texto
            ");

        $query->setFrom("
                $this->table
            ");

        $query->setWhere("tipoAlergia_idtipoAlergia=$idtipoAlergia");

        return $this->getList($query);
    }

    /**
     * Listado por tipo de alergia 
     * @param type $idtipoAlergia
     */
    public function getListXTipoAlergiaAndPaciente($idtipoAlergia, $idperfilSaludAlergia) {
        $query = new AbstractSql();
        $query->setSelect("
               *,
               IF(ISNULL(psa.subTipoAlergia_idsubTipoAlergia), 0, 1) as is_checked,
               psa.texto
            ");
        $query->setFrom("
                $this->table t 
                    LEFT JOIN perfilsaludalergia_subtipoalergia psa ON (t.$this->id = psa.subTipoAlergia_idsubTipoAlergia AND perfilSaludAlergia_idperfilSaludAlergia=$idperfilSaludAlergia)
            ");

        $query->setWhere("tipoAlergia_idtipoAlergia=$idtipoAlergia");

        return $this->getList($query);
    }

    /**
     * Método que recibe un listado, donde los keys del listado son los $this->id...
     * retorna un listado de NOT IN en esos id´s
     * 
     * @param type $listado
     * @return boolean
     */
    public function getListadoNotIn($listado, $idperfilSaludAlergia) {
       

        if (count($listado) >= 0) {
            $not_in = "";
            foreach ($listado as $key => $subtipo) {
                $not_in .= ", $key";
            }
            //seteamos un array vacio para el NOT IN si no tenemos elementos en el listado
            if (count($listado) == 0) {
                $not_in = "''";
            } else {
                $not_in = substr($not_in, 1);
            }
            $query = new AbstractSql();
            $query->setSelect("
                            *
                         ");
            $query->setFrom("
                            $this->table t 
                                LEFT JOIN perfilsaludalergia_subtipoalergia psa ON (t.$this->id = psa.subTipoAlergia_idsubTipoAlergia AND perfilSaludAlergia_idperfilSaludAlergia=$idperfilSaludAlergia)
                        ");

            $query->setWhere("subTipoAlergia_idsubTipoAlergia NOT IN ($not_in)");

            return $this->getList($query);
        } else {
            return false;
        }
    }

}

//END_class
?>