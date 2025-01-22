<?php

/**
 *  ManagerXSeo
 *
 *  Entidad Seo genera gestiona los registros con metadatos	
 *  @author Xinergia <info@e-xinergia.com>	
 *  @version 1.0
 *
 */
require_once(path_managers("base/Manager.php"));

class ManagerXSeo extends Manager {

    protected $entity = NULL;
    protected $title_seo = NULL;
    private $subfolder_base = NULL;

    /**
     * 	@author Emanuel del Barco
     * 	@version 1.0
     * 	
     * 	constructor de la clase 
     */
    function __construct($db) {

        parent::__construct($db, "x_seo", "idseo");
    }

    /**
     * Setea la entidad y el titulo a partir de donde se va a calcular el seo
     *
     * */
    public function configEntity($entity, $title_seo) {

        $this->entity = $entity;
        $this->title_seo = $title_seo;
    }

    /**
     * Setea el campo de donde calcular el seo
     *
     * */
    public function setEntity($entity) {
        $this->entity = $entity;
    }

    /**
     * Setea el campo de donde calcular el seo
     *
     * */
    public function setTitleSeo($title_seo) {
        $this->title_seo = $title_seo;
    }

    /**
     * Insert
     *
     * */
    public function insert($request) {


        /* if ($request["calculate_seo"]==1){  
          if (!is_null($this->title_seo)){
          $request["seo"] = str2seo($request[$this->title_seo] );
          }
          } */

        if (!is_null($this->entity)) {

            $manager = $this->getManager("ManagerXSeoEntity");

            $entity = $manager->getByEntity($this->entity);

            if ($entity) {
                $request["seo_type"] = $entity["seo_type"];
            }

            //si tiene directorio
            if ($entity["directory"] != "") {
                $request["directory"] = $entity["directory"];
            }

            $request["changefreq"] = $entity["changefreq"];
            $request["priority"] = $entity["priority"];

            $request["entity"] = $this->entity;
        }

        return parent::insert($request);
    }

    /**
     * Update
     *
     * */
    public function update($request, $id) {

        if ($request["calculate_seo"] == 1) {
            if (!is_null($this->title_seo)) {
                $request["seo"] = str2seo($request[$this->title_seo]);
            }
        }

        if (!is_null($this->entity)) {

            $manager = $this->getManager("ManagerXSeoEntity");

            $entity = $manager->getByEntity($this->entity);

            if ($entity) {
                $request["seo_type"] = $entity["seo_type"];
            }

            //si tiene directorio
            if ($entity["directory"] != "") {
                $request["directory"] = $entity["directory"];
            }

            $request["entity"] = $this->entity;
            $request["changefreq"] = $entity["changefreq"];
            $request["priority"] = $entity["priority"];
        }

        return parent::update($request, $id);
    }

    /**
     *  Obtiene un registro a partir de una entidad y un idrelated
     *
     * */
    public function getSeo($idrelated) {

        $entity = $this->entity;

        $rs = $this->db->Execute("SELECT idseo FROM x_seo WHERE entity='$entity' AND idrelated = $idrelated");

        if ($rs) {

            $result = $rs->FetchRow();

            return $this->get($result["idseo"]);
        } else {
            return false;
        }
    }

    /**
     *  Obtiene un registro a de un seo
     *
     * */
    public function getBySeo($seo) {

        $entity = $this->entity;

        $rs = $this->db->Execute("SELECT * FROM x_seo WHERE entity='$entity' AND seo='$seo'");

        if ($rs) {

            $result = $rs->FetchRow();

            return $result;
        } else {
            return false;
        }
    }

    /**
     * set Seo
     *
     * */
    public function setSeo($id, $record) {

        $seo = $this->getSeo($id);

        $record["idrelated"] = $id;

        if ($seo) {
            return $this->update($record, $seo["idseo"]);
        } else {
            return $this->insert($record);
        }
    }

    /**
     *  Elimina un registro de seo
     *
     * */
    public function deleteSeo($idrelated) {

        $entity = $this->entity;

        $rs = $this->db->Execute("SELECT idseo FROM x_seo WHERE entity='$entity' AND idrelated = $idrelated");

        if ($rs) {

            $result = $rs->FetchRow();

            return $this->delete($result["idseo"]);
        } else {
            return false;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	Obtiene la configuracion SEO de una URL
     *
     * 	@param string $url url que stá solicitando el SEO
     *
     * 	@return void
     */
    public function getSeoByUrl($url) {

//            $this->db->debug = true;

        $url_seo = $url;

        // Armamos la consulta para leer desde x_seo
        $query = new AbstractSql();
        $query->setSelect("s.*");
        $query->setFrom("x_seo s");
        $query->setWhere(sprintf("seo_generic(s.idseo) = '%s'", $url_seo)); //idioma español

        $rs = $this->db->Execute($query->getSql());
        if ($rs) {
            return $rs->FetchRow();
        } else {
            return false;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 
     * 	Setea el subdirectorio base sobre el cual va a trabajar el seo
     * 	
     *   @param string $subfolder subdirectorio          		
     *
     */
    public function setSubFolderBase($subfolder) {

        $this->subfolder_base = $subfolder;
        return;
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *
     *   Update
     */

    public function getList($idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 15);
        }


        $query = new AbstractSql();
        $query->setSelect("s.*");
        $query->setFrom("x_seo s");
        $query->setOrderBy("s.entity,s.directory,s.seo");

        return parent::getList($query, false, $idpaginate);
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *
     *    
     */

    public function getListadoJSON($idpaginate = NULL, $request) {

        //$this->debug();

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 25);
        }

        $query = new AbstractSql();
        $query->setSelect(" s.idseo,
                                IFNULL(s.directory,'--') AS directory,
                                s.seo,
                                IF(s.seo_type = 1, 'Directory','.html') AS type 
                            ");
        $query->setFrom("x_seo s");


        if ($request["product"] != "") {

            $product = cleanQuery($request["product"]);

            $query->addAnd("p.product LIKE '%$product%'");
        }


        $data = $this->getJSONList($query, array("directory", "seo", "type"), $request, $idpaginate);


        return $data;
    }

    /**
     * 	@author Emanuel del Barco
     * 	@version 1.0
     * 	
     * 	Obtiene  un combo de las frecuencias de actualizacion para el sitemap 
     * 	
     * 	@retorna un registro
     */
    public function getComboChangeFreq() {

        return array(
            "always" => "always",
            "hourly" => "hourly",
            "daily" => "daily",
            "weekly" => "weekly",
            "monthly" => "monthly",
            "yearly" => "yearly",
            "never" => "never"
        );
    }

    /**
     * 	@author Emanuel del Barco
     * 	@version 1.0
     * 	
     * 	Obtiene  un combo de las frecuencias de actualizacion para el sitemap 
     * 	
     * 	@retorna un registro
     */
    public function getComboPriority() {

        return array(
            "0.0" => "0.0",
            "0.1" => "0.1",
            "0.2" => "0.2",
            "0.3" => "0.3",
            "0.4" => "0.4",
            "0.5" => "0.5",
            "0.6" => "0.6",
            "0.7" => "0.7",
            "0.8" => "0.8",
            "0.9" => "0.9",
            "1.0" => "1.0"
        );
    }

    /**
     * 	@author Emanuel del Barco
     * 	@version 1.0
     * 	
     * 	Obtiene  un combo de las frecuencias de actualizacion para el sitemap 
     * 	
     * 	@retorna un registro
     */
    public function getSitemap() {

        $query = new AbstractSql();
        $query->setSelect("seo_generic(s.idseo) AS seo,s.changefreq,s.priority");
        $query->setFrom("x_seo s");
        $query->setOrderBy("s.entity,s.directory,s.seo");

        return parent::getList($query, false);
    }

    public function generate_sitemap() {
        $listado_programas = $this->getManager("ManagerProgramaSalud")->getList();
        //print_r($listado_programas);
        //URL PROGRAMA
        foreach ($listado_programas as $programa) {

            $url = URL_ROOT . "thematique/{$programa["idprograma_salud"]}-" . str2seo($programa["programa_salud"]) . ".html";
            $date = date("Y-m-d");

            echo "<url>
                    <loc>{$url}</loc>
                    <lastmod>{$date}</lastmod>
                    <changefreq>weekly</changefreq>
                    <priority>1.0</priority>
                    </url>";

            //URL CATEGORIAS
            $listado_categorias = $this->getManager("ManagerProgramaSaludCategoria")->getListadoCategorias($programa["idprograma_salud"]);
            foreach ($listado_categorias as $categoria) {
                $url_categoria = URL_ROOT . "thematique/" . $programa["idprograma_salud"] . "-" . str2seo($programa["programa_salud"]) . "/" . $categoria["idprograma_categoria"] . "-" . str2seo($categoria["programa_categoria"]) . ".html";
                $date = date("Y-m-d");

                echo "<url>
                    <loc>{$url_categoria}</loc>
                    <lastmod>{$date}</lastmod>
                    <changefreq>weekly</changefreq>
                    <priority>1.0</priority>
                    </url>";
            }
        }

        //URL MEDICOS
        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom("(
                        select idmedico,nombre,apellido from programa_medico_referente pmr 
                        INNER JOIN v_medicos vm1 ON (pmr.medico_idmedico=vm1.idmedico)
                        UNION 
                        select idmedico,nombre,apellido from programa_medico_complementario pmc 
                        INNER JOIN v_medicos vm2 ON (pmc.medico_idmedico=vm2.idmedico) 
                    ) t");
        $query->setGroupBy("t.idmedico");

        $listado_medicos = parent::getList($query);
        foreach ($listado_medicos as $medico) {
            $url_medico = URL_ROOT . "recherche-medecin/professionnels/" . $medico["idmedico"] . "-" . str2seo($medico["nombre"]) . "-" . str2seo($medico["apellido"]) . ".html";
            $date = date("Y-m-d");

            echo "<url>
                    <loc>{$url_medico}</loc>
                    <lastmod>{$date}</lastmod>
                    <changefreq>weekly</changefreq>
                    <priority>0.9</priority>
                    </url>";
        }
    }

}

// EndClass
?>