<?php

/**
 * 	Manager de traduccion
 *
 * 	@author UTN
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerTraduccion extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "traduccion", "idtraduccion");
        $this->default_paginate = "listado_traduccion";
    }

    /**
     * 	Inserta un registro en la tabla correspondiente basandose en el arreglo recibido como par�metro
     *
     * 	@author UTN
     * 	@version 1.0
     *
     * 	@param mixed $request Arreglo que contiene todos los campos a insertar
     * 	@return int Retorna el ID Insertado o 0
     */
    public function insert($request) {

        $request["original"] = trim($request["original"]);

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");

        $query->setWhere("original like \"{$request["original"]}\" COLLATE utf8_bin and tipo= {$request["tipo"]}");

        //creo el registro
        $exist = $this->db->getRow($query->getSql());

        if ($exist) {

            $this->setMsg(["msg" => "La traducción ya existe", "result" => false]);
            return false;
        }
        $request["date"] = date("Y-m-d h:i:s");
        $id = parent::insert($request);

        if ($id) {
            $this->setMsg(["msg" => "Traducción creada con éxito", "result" => true]);
        }

        return $id;
    }

    /**
     * 	Realiza Update de un registro
     *
     * 	@author UTN
     * 	@version 1.0
     *
     * 	@param mixed $request Arreglo que contiene todos los campos para su actualizaci�n
     * 	@param int $id clave primaria del registro a actualizar.
     * 	@return int|booelan Retorna el id del registro actualizado o falso dependiendo de que se haya realizado correctamente el UPDATE
     */
    public function update($request, $id) {

        //Guardo el registro
        $result = parent::update($request, $id);

        //si se crea correctamente asocio las funcionaldades y si aplica o no
        if ($result) {
            $this->setMsg(["result" => "Traducción actualizada con éxito", "result" => true]);
        }

        return $result;
    }

    /**
     * Listado de registros de traducciones
     * @param type $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, $request["rows"]);
        }

        $query = new AbstractSql();
        $query->setSelect("idtraduccion,
                original,
                traduccion_fr,
                traduccion_en,
                descripcion,
                CASE tipo
                WHEN 1 THEN 'Mensajes de alerta'
                WHEN 2 THEN 'Página web (HTML)' 
                 WHEN 3 THEN 'Página web (JS)' END as tipo
                ");
        $query->setFrom("$this->table");
        // Filtro

        if ($request["original"] != "") {
            $descripcion = cleanQuery($request["original"]);
            $query->addAnd("original LIKE '%$descripcion%'");
        }
        if ($request["traduccion"] != "") {
            $descripcion = cleanQuery($request["traduccion"]);
            $query->addAnd("traduccion_" . TRADUCCION_DEFAULT . " LIKE '%$descripcion%'");
        }
        if ($request["tipo"] != "") {
            $tipo = cleanQuery($request["tipo"]);
            $query->addAnd("tipo=$tipo");
        }

        if ($request["estado"] == 1) {
            $tipo = cleanQuery($request["tipo"]);
            $query->addAnd("(traduccion_fr LIKE '%(fr)' OR traduccion_fr LIKE '%(en)' OR traduccion_fr = traduccion_en)");
        }
        if ($request["estado"] == 2) {
            $tipo = cleanQuery($request["tipo"]);
            $query->addAnd("(traduccion_fr NOT LIKE '%(fr)' AND traduccion_en NOT LIKE '%(en)')");
        }


        $data = $this->getJSONList($query, array("original", "traduccion_fr", "traduccion_en", "tipo", "descripcion"), $request, $idpaginate);

        return $data;
    }

    /**
     * Metodo que obtiene los registros de traducciones guardados y actualiza el archivo js y php con un arreglo de traducciones del par clave-valor
     */
    public function compilarTraducciones() {
        if (IDIOMAS_TRADUCCION != "") {
            $idiomas_traduccion = explode(",", IDIOMAS_TRADUCCION);
            foreach ($idiomas_traduccion as $idioma) {
                $rdo1 = $this->compilar_traducciones_js($idioma);
                $rdo2 = $this->compilar_traducciones_html_modulos($idioma);

                if (!$rdo1 || !$rdo2) {
                    $this->setMsg(["result" => false, "msg" => "Ha ocurrido un error."]);
                    return false;
                }
            }

            $this->setMsg(["result" => true, "msg" => "Traducciones compiladas con éxito"]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo compilar las traduccion"]);
            return false;
        }
    }

    /**
     * Metodo que obtiene las traducciones de la base de datos de html de pantallas,  y los escribe en el archivo de traducciones PHP
     * @param type $idioma
     * @return type
     */
    private function compilar_traducciones_html_modulos($idioma) {

        $filePHP = path_root("xframework/translate/translate_$idioma.php");

        $queryPHP = new AbstractSql();
        $queryPHP->setSelect("original,traduccion_$idioma");
        $queryPHP->setFrom("$this->table");
        $queryPHP->setWhere("tipo=2");

        $list2 = $this->getList($queryPHP);

        //armamos el contendio del archivo php
        $str_content2 = '<?php' . PHP_EOL . PHP_EOL .
                'class Translations  {' . PHP_EOL . PHP_EOL .
                'private static $translations = [' . PHP_EOL;

        foreach ($list2 as $tr) {

            //escapamos los caracteres especiales
            $original = str_replace('"', '\"', $tr["original"]);
            $traduccion = str_replace('"', '\"', $tr["traduccion_$idioma"]);


            $str_content2 .= "\t" . "\t" . '"' . $original . '"=>"' . $traduccion . '",' . PHP_EOL;
        }

        $str_content2 .= "\t" . '];' . PHP_EOL . PHP_EOL .
                "\t" . ' public static function getTranslations(){' . PHP_EOL .
                "\t\t" . 'return self::$translations;' . PHP_EOL . "\t" . '}' . PHP_EOL . PHP_EOL . '}';

        //reemplazar el contenido con el nuevo valor

        $rdo2 = file_put_contents($filePHP, $str_content2, LOCK_EX);
        return $rdo2;
    }

    /**
     * Metodo que obtiene las traducciones de la base de datos del texto con javascript de pantallas o mensajes de los managers,  y los escribe en el archivo de traducciones JS
     */
    private function compilar_traducciones_js($idioma) {
        //traducciones de javascript en modulos- JS
        $fileJS = path_root("xframework/translate/translate_$idioma.js");


        $queryJS2 = new AbstractSql();
        $queryJS2->setSelect("original,traduccion_$idioma");
        $queryJS2->setFrom("$this->table");
        $queryJS2->setWhere("tipo=3");

        $list2 = $this->getList($queryJS2);

        $content_modulos_ = [];
        foreach ($list2 as $tr) {
            //escapamos los caracteres especiales
            $original = str_replace('"', '\"', $tr["original"]);
            $traduccion = str_replace('"', '\"', $tr["traduccion_$idioma"]);

            $content_modulos[$original] = $traduccion;
        }

        //traducciones de mensajes en los managers
        $queryJS = new AbstractSql();
        $queryJS->setSelect("original,traduccion_$idioma");
        $queryJS->setFrom("$this->table");
        $queryJS->setWhere("tipo=1");

        $list = $this->getList($queryJS);


        $content_msg = [];
        foreach ($list as $tr) {
            //escapamos los caracteres especiales
            $original = str_replace('"', '\"', $tr["original"]);
            $traduccion = str_replace('"', '\"', $tr["traduccion_$idioma"]);

            $content_msg[$original] = $traduccion;
        }

        $array_content = array_merge($content_modulos, $content_msg);
        //reemplazar el contenido con el nuevo valor
        $str_content = "var translations=" . json_encode($array_content);
        $comentario = "//traducciones de mensajes x_alert- JS";
        $rdo = file_put_contents($fileJS, $comentario . PHP_EOL . $str_content . PHP_EOL, LOCK_EX);



        return $rdo;
    }

    /**
     * Metodo que busca las ocurrencias de las funcion de traduccion 'x_translate' en los archivos del sistema.   
     * Se recupera el texto original a traducir y lo guarda en la base de datos
     */
    public function get_traducciones_sistema($request) {
        ini_set('max_execution_time', 1000); //300 seconds = 5 minutes

        if ($request["step"] == 1) {
            //limpiamos la tabla temporal antes de comenzar la busqueda
            $this->db->Execute("truncate table traduccion_temp");
            $cant_js1 = $this->get_traducciones_sistema_JS("js");
        } else if ($request["step"] == 2) {
            $cant_js2 = $this->get_traducciones_sistema_JS("tpl");
        } else if ($request["step"] == 3) {
            $cant_html = $this->get_traducciones_sistema_HTML();
        } else if ($request["step"] == 4) {
            $cant_manager = $this->get_traducciones_sistema_Manager();
        }

        $this->setMsg(["result" => true, "msg" => "Busqueda de traducciones en archivos del sistema finalizada."]);
        return true;
    }

    /**
     * Metodo que busca las ocurrencias de las funcion de traduccion 'x_translate' en los archivos del sistema.   
     * Se recupera el texto original a traducir y lo guarda en la base de datos
     */
    public function parse_traducciones_sistema() {

        $cant_js = 0;
        $cant_manager = 0;
        $cant_html = 0;

        $cant_js = $this->parse_traducciones_sistema_JS();
        $cant_html = $this->parse_traducciones_sistema_HTML();
        $cant_manager = $this->parse_traducciones_sistema_Manager();
        //$cant_manager = $this->test();
        $total = $this->db->getRow("select count(*) as total from traduccion_temp ")["total"];
        $procesado = $this->db->getRow("select count(*) as qty from traduccion_temp where status =1 ")["qty"];

        if ($procesado < $total) {
            $porcentaje = round($procesado * 100 / $total, 0);
        } else {
            $porcentaje = 100;
            //$this->db->Execute("truncate table traduccion_temp");
        }
        $this->setMsg(["result" => true, "msg" => "Busqueda de traducciones finalizada", "porcentaje" => $porcentaje]);
        return true;
    }

    /**
     * Metodo que busca en los archivos del sistema las ocurrencias de las funcion de traduccion 'x_translate' de php en el codigo HTML .   
     * @return int cantidad de traducciones halladas
     */
    private function get_traducciones_sistema_HTML() {
        //archivo donde se guardan las lineas de archivos que contienen la funcion de traduccion
        $my_file = path_files("temp/") . 'app_translations-html.txt';
        if (file_exists($my_file)) {
            unlink($my_file);
        }

        //ejecutamos el comando de consola que busca la ocurrencia de la funcion de php de traduccion en el texto de los archivos de sistema
        //WINDOWS
        if ($_SERVER["HTTP_HOST"] == "localhost") {
            $cmd = 'findstr /si "|x_translate" *.tpl > ' . $my_file;
        } else {
            //LINUX
            $cmd = 'grep -r --include="*.tpl" "|x_translate" /var/www/html/xframework/app >' . $my_file;
        }



        shell_exec($cmd);

        //recorremos y procesamos el archivo para obtener el texto que traduce la funcion 'translate'
        $handle = fopen($my_file, 'r');

        $ManagerTraduccionTemp = $this->getManager("ManagerTraduccionTemp");

        while (($line = fgets($handle)) !== false) {
            $ManagerTraduccionTemp->insert(["line" => $line, "tipo" => 2]);
        }

        fclose($handle);
        if (file_exists($my_file)) {
            unlink($my_file);
        }
        return true;
    }

    private function parse_traducciones_sistema_HTML() {
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("traduccion_temp");
        $query->setWhere("status=0 and tipo=2");
        $query->setLimit("0,300");
        $list = $this->getList($query);

        $cant_traducciones = 0;
        if (count($list) == 0) {

            return 0;
        }

        $ManagerTraduccionTemp = $this->getManager("ManagerTraduccionTemp");

        foreach ($list as $field) {

            $line = $field["line"];
            //marcamos la linea como procesada
            $rdo1 = $ManagerTraduccionTemp->update(["status" => 1], $field["id"]);
            //selecciomaos solo la ocurrencia del string a traduccir
            preg_match('/\{\".+\"\|x_translate\}/', $line, $coincidencias, PREG_OFFSET_CAPTURE);
            $texto = $coincidencias[0][0];

            //verificamos cuantos translate hay en la linea
            $count = mb_substr_count($texto, "x_translate}");

            if ($count > 1) {

                $aux_count = $count;
                $texto_orig = $texto;
                //iteramos por cada funcion de traduccion en la linea del archivo
                while ($aux_count > 0) {
                    //posicion de la primera ocurrencia;

                    $pos = strpos($texto, "x_translate}");
                    $pos_ini = strpos($texto, '{"');
                    $pos_fin = $pos - $pos_ini + 12;
                    $primera_traduccion = substr($texto, $pos_ini, $pos_fin);

                    //obtenemos el texto limpio a traducir y lo guardamos en la BD
                    $texto = $primera_traduccion;
                    $texto = str_replace('"|x_translate}', "", $texto);
                    $texto = str_replace('{"', "", $texto);

                    //reemplazamos el texto variable por %s si existe
                    if (strpos($texto, '[[') != false) {
                        $patrón = '/\[\[.+\]\]/';
                        $texto = preg_replace($patrón, "[[%s]]", $texto);
                    }

                    $record["tipo"] = 2; //texto pagina html
                    $record["original"] = $texto;

                    $idiomas_traduccion = explode(",", IDIOMAS_TRADUCCION);
                    foreach ($idiomas_traduccion as $idioma) {
                        $record["traduccion_" . $idioma] = $texto . "(" . $idioma . ")";
                    }


                    //ubicacion de la traduccion en el framework
                    $posPath1 = strpos($line, "xfamework/");
                    $posPath2 = strpos($line, ":");
                    $path = substr($line, $posPath1, $posPath2);
                    $record["descripcion"] = $record["path"] = $path;
                    $record["line"] = $line;


                    $rdo = $this->insert($record);

                    if ($rdo) {
                        $cant_traducciones++;
                    }
                    //quitamos la primera traduccion del texto para seguir con las restantes
                    $restantes = substr($texto_orig, $pos + 12);
                    //  $restantes=str_re
                    $texto = $restantes;

                    $aux_count = $aux_count - 1;
                }
            } else {
                //obtenemos el texto limpio a traducir y lo guardamos en la BD
                $texto = str_replace('"|x_translate}', "", $texto);
                $texto = str_replace('{"', "", $texto);

                //reemplazamos el texto variable por %s si existe
                if (strpos($texto, '[[') != false) {
                    $patrón = '/\[\[.+\]\]/';
                    $texto = preg_replace($patrón, "[[%s]]", $texto);
                }

                $record["tipo"] = 2; //texto pagina html
                $record["original"] = $texto;

                $idiomas_traduccion = explode(",", IDIOMAS_TRADUCCION);
                foreach ($idiomas_traduccion as $idioma) {
                    $record["traduccion_" . $idioma] = $texto . "(" . $idioma . ")";
                }


                //ubicacion de la traduccion en el framework
                $posPath1 = strpos($line, "xfamework/");
                $posPath2 = strpos($line, ":");
                $path = substr($line, $posPath1, $posPath2);
                $record["descripcion"] = $record["path"] = $path;
                $record["line"] = $line;

                $rdo = $this->insert($record);

                if ($rdo) {
                    $cant_traducciones++;
                }
            }
        }



        return $cant_traducciones;
    }

    /**
     * Metodo que busca en los archivos del sistema las ocurrencias de las funcion de traduccion 'x_translate' de php en el codigo HTML .   
     * @return int cantidad de traducciones halladas
     */
    private function get_traducciones_sistema_Manager() {
        //archivo donde se guardan las lineas de archivos que contienen la funcion de traduccion
        $my_file = path_files("temp/") . 'app_translations_manager.txt';
        if (file_exists($my_file)) {
            unlink($my_file);
        }

        //ejecutamos el comando de consola que busca la ocurrencia de la funcion de php de traduccion en el texto de los archivos de sistema
        //WINDOWS
        if ($_SERVER["HTTP_HOST"] == "localhost") {
            $cmd = 'findstr /si "setMsg(" *.php > ' . $my_file;
        } else {
            //LINUX
            $cmd = 'grep -r --include="*.php" "setMsg(" /var/www/html/xframework/core >' . $my_file;
        }
        shell_exec($cmd);


        //recorremos y procesamos el archivo para obtener el texto que traduce la funcion 'translate'
        $handle = fopen($my_file, 'r');

        $ManagerTraduccionTemp = $this->getManager("ManagerTraduccionTemp");

        while (($line = fgets($handle)) !== false) {
            $ManagerTraduccionTemp->insert(["line" => $line, "tipo" => 1]);
        }

        fclose($handle);
        if (file_exists($my_file)) {
            unlink($my_file);
        }

        return true;
    }

    /**
     * Metodo que busca en los archivos del sistema las ocurrencias de las funcion de traduccion 'x_translate' de php en el codigo HTML .   
     * @return int cantidad de traducciones halladas
     */
    private function parse_traducciones_sistema_Manager() {

        // $trans = new GoogleTranslate();

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("traduccion_temp");
        $query->setWhere("status=0 and tipo=1");
        $query->setLimit("0,300");
        $list = $this->getList($query);
        $cant_traducciones = 0;

        if (count($list) == 0) {

            return 0;
        }

        $ManagerTraduccionTemp = $this->getManager("ManagerTraduccionTemp");

        foreach ($list as $field) {
            $line = $field["line"];
            //marcamos la linea como procesada
            $rdo1 = $ManagerTraduccionTemp->update(["status" => 1], $field["id"]);
            //buscamos si la linea tiene traduccion con la ocurrencia de la funcion |translate
            if (strpos($line, "setMsg(") !== FALSE) {


                //selecciomaos solo la ocurrencia del string a traduccir
                preg_match('/setMsg\(.+/', $line, $coincidencias, PREG_OFFSET_CAPTURE);
                $texto = $coincidencias[0][0];

                //buscamos en la line de texto la ocurrencia del campo msg del array
                $pos = strpos($texto, '"msg" => "');
                if ($pos !== false) {

                    //reemplazamos el texto variable por %s si existe
                    if (strpos($texto, '[[') != false) {
                        $patrón = '/\[\[.+\]\]/';
                        $texto = preg_replace($patrón, "[[%s]]", $texto);
                    }

                    //cortamos el texto limpio de la traudccion solamente
                    $texto = substr($texto, $pos + 10);
                    $pos1 = strpos($texto, '"');
                    $texto = substr($texto, 0, $pos1);


                    if ($texto != "") {

                        $record["tipo"] = 1; //texto managaers
                        $record["original"] = $texto;


                        // $source = 'es';
                        //$target = 'fr';
                        //$result = $trans->translate($source, $target, $texto);
                        $idiomas_traduccion = explode(",", IDIOMAS_TRADUCCION);
                        foreach ($idiomas_traduccion as $idioma) {
                            $record["traduccion_" . $idioma] = $texto . "(" . $idioma . ")";
                        }
                        //ubicacion de la traduccion en el framework
                        $posPath1 = strpos($line, "xfamework/");
                        $posPath2 = strpos($line, ":");
                        $path = substr($line, $posPath1, $posPath2);

                        $record["descripcion"] = $record["path"] = $path;
                        $record["line"] = $line;
                        $rdo = $this->insert($record);

                        if ($rdo) {
                            $cant_traducciones++;
                        }
                    }
                }
            }
        }

        return true;
    }

    /**
     * Metodo que busca  en los archivos del sistema las ocurrencias de las funcion de traduccion 'x_translate' de javascript en el codigo JS de los modulos.  
     * @return int cantidad de traducciones halladas
     */
    private function get_traducciones_sistema_JS($file = "js") {

        //archivo donde se guardan las lineas de archivos que contienen la funcion de traduccion
        $my_file = path_files("temp/") . 'app_translations_' . $file . '.txt';
        if (file_exists($my_file)) {
            unlink($my_file);
        }


        //ejecutamos el comando de consola que busca la ocurrencia de la funcion de php de traduccion en el texto de los archivos de sistema
        //WINDOWS
        if ($_SERVER["HTTP_HOST"] == "localhost") {
            $cmd = 'findstr /si "x_translate(" *.' . $file . ' > ' . $my_file;
        } else {
            //LINUX
            $cmd = 'grep -r --include="*.' . $file . '" "x_translate(" /var/www/html/xframework/app >' . $my_file;
        }



        shell_exec($cmd);

        //recorremos y procesamos el archivo para obtener el texto que traduce la funcion 'translate'
        $handle = fopen($my_file, 'r');


        $ManagerTraduccionTemp = $this->getManager("ManagerTraduccionTemp");

        while (($line = fgets($handle)) !== false) {
            $ManagerTraduccionTemp->insert(["line" => $line, "tipo" => 3]);
        }

        fclose($handle);
        if (file_exists($my_file)) {
            unlink($my_file);
        }
        return true;
    }

    private function parse_traducciones_sistema_JS() {


        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("traduccion_temp");
        $query->setWhere("status=0 and tipo=3");
        $query->setLimit("0,300");
        $list = $this->getList($query);
        $cant_traducciones = 0;
        if (count($list) == 0) {

            return 0;
        }

        $ManagerTraduccionTemp = $this->getManager("ManagerTraduccionTemp");
        foreach ($list as $field) {
            $line = $field["line"];
            //marcamos la linea como procesada
            $rdo1 = $ManagerTraduccionTemp->update(["status" => 1], $field["id"]);

            //buscamos si la linea tiene traduccion con la ocurrencia de la funcion |translate
            if (strpos($line, "x_translate(") !== FALSE) {
                //selecciomaos solo la ocurrencia del string a traduccir
                preg_match('/x_translate\(.+\)/', $line, $coincidencias, PREG_OFFSET_CAPTURE);
                $texto = $coincidencias[0][0];


                //verificamos cuantos translate hay en la linea
                $count = mb_substr_count($texto, "x_translate(");



                if ($count > 1) {
                    $aux_count = $count;
                    //iteramos por cada funcion de traduccion en la linea del archivo
                    while ($aux_count > 0) {
                        //posicion de la primera ocurrencia;

                        $texto_orig = $texto;
                        $pos = strpos($texto, "x_translate(");

                        $primera_traduccion = substr($texto, $pos + 12);




                        //obtenemos el texto limpio a traducir y lo guardamos en la BD
                        $texto = $primera_traduccion;
                        $pos2 = strpos($texto, '")');
                        $texto = substr($texto, 0, $pos2 + 2);
                        $texto = substr($texto, 0, -1);

                        //verififcamos si el texto esta encerrados por comillas simples '  y las quitamos
                        if (substr($texto, 0, 1) == '"' && substr($texto, -1) == '"') {
                            $texto = substr($texto, 1);
                            $texto = substr($texto, 0, -1);
                        }


                        $record["tipo"] = 3; //texto js en paginas html
                        $record["original"] = $texto;
                        $idiomas_traduccion = explode(",", IDIOMAS_TRADUCCION);
                        foreach ($idiomas_traduccion as $idioma) {
                            $record["traduccion_" . $idioma] = $texto . "(" . $idioma . ")";
                        }


                        //ubicacion de la traduccion en el framework
                        $posPath1 = strpos($line, "xfamework/");
                        $posPath2 = strpos($line, ":");
                        $path = substr($line, $posPath1, $posPath2);
                        $record["descripcion"] = $record["path"] = $path;
                        $record["line"] = $line;

                        $rdo = $this->insert($record);

                        if ($rdo) {
                            $cant_traducciones++;
                        }
                        //quitamos la primera traduccion del texto para seguir con las restantes
                        $pos3 = strpos($texto_orig, $texto);
                        $leng = strlen($texto);
                        $restantes = substr($texto_orig, $pos3 + $leng);
                        $texto = $restantes;

                        $aux_count -= 1;
                    }
                } else {

                    //obtenemos el texto limpio a traducir y lo guardamos en la BD

                    $texto = str_replace('x_translate(', "", $texto);

                    $pos_fin = strpos($texto, ')');
                    $texto = substr($texto, 0, $pos_fin);

                    //verififcamos si el texto esta encerrados por comillas simples '  y las quitamos
                    if (substr($texto, 0, 1) == "'" && substr($texto, -1) == "'") {
                        $texto = substr($texto, 1);
                        $texto = substr($texto, 0, -1);
                    }

                    if (substr($texto, 0, 1) == '"' && substr($texto, -1) == '"') {
                        $texto = substr($texto, 1);
                        $texto = substr($texto, 0, -1);
                    }

                    $record["tipo"] = 3; //texto js en paginas html
                    $record["original"] = $texto;


                    $idiomas_traduccion = explode(",", IDIOMAS_TRADUCCION);

                    foreach ($idiomas_traduccion as $idioma) {
                        $record["traduccion_" . $idioma] = $texto . "(" . $idioma . ")";
                    }


                    //ubicacion de la traduccion en el framework
                    $posPath1 = strpos($line, "xfamework/");
                    $posPath2 = strpos($line, ":");
                    $path = substr($line, $posPath1, $posPath2);
                    $record["path"] = $path;
                    $rdo = $this->insert($record);

                    if ($rdo) {
                        $cant_traducciones++;
                    }
                }
            }
        }

        //recorremos y procesamos el archivo para obtener el texto que traduce la funcion 'translate'

        return $cant_traducciones;
    }

}

//END_class
?>