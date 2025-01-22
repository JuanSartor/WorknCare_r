<?php

/**
 * @author Sebastian Balestrini <sbalestrini@gmail.com>
 * @version 2.0
 *
 * Clase que procesa las solicitudes del sistema. 
 * Sirve tanto para AJAX como para REQUEST. Esto se determina seg�n elv alor de $_REQUEST["fromajax"] (parsea un template completo o solo el modulo solicitado. Esto es asi para poder ser llamado)
 *
 * class RequestController: Clase que gestiona y procesa las solicitudes por REQUEST
 *
 * 	
 */
abstract class RequestController {

    /**
     * Utilizado para determinar si el controlador trabajara en modo SEO
     *
     * @var boolean
     */
    protected $seo = false;

    /**
     * Utilizado para trabajar con SEO cuando se esta por encima del nivel raiz del sitio web
     *
     * @var string
     */
    protected $seo_subfolder = ""; // Esto es para la configuracion SEO
    /**
     * Determina si se trabaja en modo Debug o no
     *
     * @var boolean
     */
    protected $debug = false;

    /**
     * Nombre del controlador
     *
     * @var string
     */
    protected $name = NULL;

    /**
     * Charset para la web que se est� procesando
     *
     * @var string
     */
    protected $charset = "utf-8";

    /**
     * Modulo por defecto
     *
     * @var string
     */
    protected $default_module = "home";

    /**
     * Submodulo por defecto
     *
     * @var string
     */
    protected $default_submodule = "home";

    /**
     * Modulo para el procesamiento de la solicitud actual
     *
     * @var string
     */
    protected $actual_module = NULL;

    /**
     * Submodulo para el procesamiento de la solicitud actual
     *
     * @var string
     */
    protected $actual_submodule = NULL;

    /**
     * Nombre que se utilizar� para referenciar a los modulos
     *
     * @var string
     */
    protected $module_name = "modulo";

    /**
     * Nombre que se utilizar� para referenciar a los submodulos
     *
     * @var string
     */
    protected $submodule_name = "submodulo";

    /**
     * Determina si el procesamiento de plantillas se realiza en modo Debug
     *
     * @var boolean
     */
    protected $smarty_debugging = false;

    /**
     * Activa el cache de smarty
     *
     * @var boolean
     */
    protected $smarty_caching = false;

    /**
     * Indica que deben limpiarse los templates compilados con cada ejecuci�n
     *
     * @var boolean
     */
    protected $smarty_clear_compiled_tpl = false;

    /**
     * Indica que se trabajar� multi idioma
     *
     * @var boolean
     */
    protected $smarty_internationalization = true;

    /**
     * Lenguaje por defecto del controlador
     *
     * @var string
     */
    protected $smarty_default_lang = "es";

    /**
     * Lenguaje para el procesamiento actual
     *
     * @var strings
     */
    protected $smarty_actual_lang = NULL;

    /**
     * Indica que se est� trabajando o no por AJAX la solicitud
     *
     * @var boolean
     */
    protected $ajax = false; // Por defecto no usa ajax
    /**
     * Almacena la instancia de Smarty
     *
     * @var object
     */
    protected $smarty_instance = NULL;

    /**
     * Almmacena el REQUEST
     *
     * @var array
     */
    protected $request = NULL;

    /**
     * Valor que representa el ID del elemento que ser� destino del HTML que se procese. 
     *
     * @var string
     */
    protected $content_target = "content";

    /**
     * Nombre del Layout que se utilizar� para procesar los templates y renderizar el HTML
     *
     * @var string
     */
    private $layout = "";

    /**
     * Instancia del DBConnector: Administador de conexiones de base de datos
     *
     * @var object
     */
    private $db = NULL;

    /**
     * Arreglo que almacenar� la configuracion SEO para la solicitud realizada
     *
     * @var array
     */
    private $seo_array = NULL; //Almacena el array SEO actual
    /**
     * Idioma por defecto
     *
     * @var string
     */
    private $default_lang = "es";

    /**
     * Indica que se procesar� la solicitud como multilenguaje
     *
     * @var boolean
     */
    private $multi_lang = false;

    /**
     * Solo para ptrabajo muliidioma, Indica que al modulo se le debe anexar al final del nombre del archivo el _<IDIOMA>
     *
     * @var boolean
     */
    private $module_append_lang = false;

    /**
     *  Instancia del Controllador
     *
     * @var instance
     */
    private static $instance;

    /**
     * Configuraci�n de managers
     *
     * @var array
     */
    // private classes_array = $this->classes_array  = array("db"=> 1, "files"=>1,"media"=>1,"pdf"=>1,"social"=>1,"web"=>1);  

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Constructor por defecto
     *
     * 	@param boolean $debug DEtermina si se utilizar� Debug	
     *
     * 	@return bool
     */
    function __construct($name, $debug = false) {

        $this->setName($name);
        // Llamamos a la funcion Abstracta		

        $this->setUpController();

        $this->setSeoSubfolder(SUB_FOLDER);


        //smarty
        $this->setUpSmarty();

        //db
        $this->setUpConnection();

        $this->debug = $debug;
        $this->setPath();

        $this->request = $_REQUEST;
        $this->determineLanguage();

        $this->ajax = (isset($this->request['fromajax'])) ? true : false;

        // Inicializamos el controllador para el procesamiento de la solicitud
        $this->init();
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Realiza todo el procesamiento de la solicitud
     *
     *
     * 	@return void
     */
    public function process() {

        if ($this->request[$this->module_name] == "error") {
            $this->setLayout("maestra_error");
        }

        // Determina que modulo procesar tanto para las acciones como para los modulos
        $module_file = $this->determineModule();


        // Si est� permitida la accion
        if ($this->isAllowed()) {

            if ($this->isDebug()) {
                ini_set('display_errors', '1');
                error_reporting(6143);
            }


            //charset de la pagina
            $this->assign("charset", $this->charset);

            //Nombre del controlador
            $this->assign("controller", $this->name);

            // Explicitamos para el controller si vamos a hacer debug o no sobre la Base de datos.    
            $this->db->setDebug(DEBUG_DB);

            //Root path
            // 
            //$this->setPath();
            //interfaces con theme
            if (defined("THEME")) {

                $this->assign("PATH_THEME_IMGS", URL_ROOT . "xframework/app/themes/" . THEME . "/imgs/");
                $this->assign("IMGS", URL_ROOT . "xframework/app/themes/" . THEME . "/imgs/");
                $this->assign("ICONS", URL_ROOT . "xframework/app/themes/" . THEME . "/imgs/");
                //$this->assign("IMGS", URL_ROOT."xframework/app/".CONTROLLER."/themes/".THEME."/imgs/");
            }
            // Segun sea o no accion, se ejecutan diferentes funciones
            if (!$this->isAction()) {

                if (file_exists($module_file)) {

                    require_once ($module_file);
                }

                if ($this->debug) {

                    $this->debugRequest();
                }

                // Determina si hay o no JS que procesar para dicho modulo. 
                $js = $this->determineJavaScript();

                // Determinamios si cargamos o no el JS
                if ($this->ajax != "1" && $js) {
                    $this->assign("load_js", "1");
                } else {
                    $this->assign("load_js", "");
                }

                if ($this->ajax) {
                    $this->assign("fromajax", "1");
                }


                if ($this->isMultilang()) {
                    $this->parseInternationalization();
                }

                // Parseamos los modulos PHP correspondientes.
                $this->parseModules();

                if ($this->isSeo()) {
                    $seoArray = $this->getSeo();
                    $this->assign("seoArray", $seoArray);
                }

                // Se parsea un action por defecto para el modulo solicitado. Especialmente importante para los sistemas
                $this->parseDefaultAction();

                // Parsea el contenido que corresponde a la solicitud
                $this->parseContent();
            } else {
                // ACCION
                //las acciones se dividen para cada modulo

                $this->doAction();
            }
        } else {

            // Se ejecuta el codigo para una accion no permitida: ej: modulo incorrecto, se requiere login, accion no permitida, etc.
            //$this->doNotAllowedAction();
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Determina en base a la solicitud recibida que es lo que se debe hacer. Obtiene los modulso y submodulos necesarios y los almacena en su variable de instancia
     *    		
     * 	@return void
     */
    private function determineModule() {

        if (isset($this->request[$this->module_name])) {

            if (isset($this->request["submodulo"])) {
                $module_file = path_view("modules/" . $this->request[$this->module_name] . "/" . $this->appendLang($this->request[$this->submodule_name], true) . ".php");
            } else {
                $module_file = path_view("modules/" . $this->request[$this->default_module] . "/" . $this->appendLang($this->default_submodule, true) . ".php");
            }
            $this->actual_module = $this->request[$this->module_name];
            $this->actual_submodule = $this->appendLang($this->request[$this->submodule_name], true);
        } else {

            $this->actual_module = $this->default_module;
            $this->actual_submodule = $this->appendLang($this->default_submodule, true);

            $module_file = path_view("modules/$this->actual_module/$this->actual_submodule.php");
        }

        return $module_file;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Determina si el modulo solicitado tiene un Archivo Js que casrgar o no
     *
     * 	@return bool
     */
    private function determineJavaScript() {

        // Verificamos si hay un JS para cargar con el nombre del modulo. Se utiliza para ejecutar el JS propio de cada modulo
        $modulo_js = "$this->actual_module/$this->actual_submodule.js";
        return (file_exists(path_smarty_templates($modulo_js)));
    }

    /**
     * 	@author Sebastian  Balestrini
     * 	@version 2.0
     * 
     * 	Determina el lenguaje para los templates
     *
     * 	@return void
     */
    private function determineLanguage() {

//			print_r($_REQUEST);echo "<hr>";print_r($this->request);
        if (isset($this->request['lang'])) {
            $_SESSION[URL_ROOT]['lang'] = $this->smarty_actual_lang = $this->request['lang'];
        } else if (!isset($_SESSION[URL_ROOT]['lang'])) {
            if (is_null($this->smarty_actual_lang)) {
                $_SESSION[URL_ROOT]['lang'] = $this->smarty_actual_lang = $this->smarty_default_lang;
            } else {
                $_SESSION[URL_ROOT]['lang'] = $this->smarty_actual_lang;
            }
        } else {
            $this->smarty_actual_lang = $_SESSION[URL_ROOT]['lang'];
        }


        define("LANG", $this->smarty_actual_lang);
        //echo "Idioma = ".$this->smarty_actual_lang ."<hr>";
    }

    /**
     * 	@author Sebastian  Balestrini
     * 	@version 2.0
     * 
     * 	retorna el lenguaje actual para los templates
     *
     * 	@return string
     */
    private function getLanguage() {
        return $this->smarty_actual_lang;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Realiza el Parseo a Smarty de la Internacionalziacion en caso de que corresponda
     *
     * 	@return viod
     */
    private function parseInternationalization() {

        // Cargamos  el archivo "config"
        if ($this->smarty_internationalization) {
            $this->smarty_instance->assign("config", "$this->actual_module.conf");
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	  Realiza el Parseo de las variables smarty del modulo y submodulo actuales
     *
     * 	@return void
     */
    private function parseModules() {


        // Parseamos el nombre del modulo
        $this->smarty_instance->assign($this->module_name, $this->actual_module);
        $this->smarty_instance->assign("module_name", $this->module_name);
        // Parseamos el nombre del submodulo
        $this->smarty_instance->assign("submodule_name", $this->submodule_name);
        $this->smarty_instance->assign($this->submodule_name, $this->actual_submodule);
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Realiza el Parseo a variable de Smarty del Action que le corresponde por defecto al Modulo
     *
     * 	@return void
     */
    private function parseDefaultAction() {

        // Parseamos el action por defecto del formulario
        $this->smarty_instance->assign("action", "actions/$this->actual_module/$this->actual_submodule.do.php");
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Parsea el contenido HTML del modulo y submodulo solicitado
     *
     * 	@return void
     */
    private function parseContent() {

        $content = $this->actual_module . "/" . $this->appendLang($this->actual_submodule) . ".tpl";


        // Definimos las variables de Smarty
        $this->smarty_instance->assign($this->content_target, $content);

        if ($this->ajax == 0) {
            $this->smarty_instance->display("$this->layout.tpl");
        } else {
            $output = $this->smarty_instance->fetch($content);

            // Explicitamos el charset de salida
            header("Content-type: text/html;charset=$this->charset");
            header('Expires: Sun, 01 Jan 2020 00:00:00 GMT');
            header('Cache-Control: no-store, no-cache, must-revalidate');
            header('Cache-Control: post-check=0, pre-check=0', FALSE);
            header('Pragma: no-cache');

            echo $output;
        }
    }

    /**
     * 	@author Sebastian  Balestrini
     * 	@version 2.0
     * 
     * 	Crea una instancia de Smarty y setea todas los valores
     * 	  		
     *
     * 	@return void
     */
    private function setUpSmarty() {

        // Inclumimos la lib de Smarty
        //require_once(path_libs_php("Smarty/Smarty.class.php"));
        /* 	echo "<hr>Templates: ".path_smarty_templates()."<hr>";
          echo "<hr>Compilados: ".path_smarty_templates_c()."<hr>";
          echo "<hr>Configs: ".path_smarty_configs()."<hr>";
          echo "<hr>Cache: ".path_smarty_cache()."<hr>"; */


        $this->smarty_instance = SmartySingleton::getInstance();

        // Inicializamos Sarty
        /* $this->smarty_instance =& new Smarty;

          $this->smarty_instance->template_dir 	=  path_smarty_templates();
          $this->smarty_instance->compile_dir 	= path_smarty_templates_c();
          $this->smarty_instance->config_dir 		= path_smarty_configs();
          $this->smarty_instance->cache_dir 		= path_smarty_cache();

          $this->smarty_instance->debugging  	= $this->smarty_debugging;
          $this->smarty_instance->caching 	= $this->smarty_caching; */

        //incluyo paginate
        require_once(path_libs_php("SmartyPaginate/SmartyPaginate.class.php"));
    }

    /**
     * 	@author Sebastian  Balestrini
     * 	@version 2.0
     * 
     *   Devuelve la instancia de Smarty de la clase
     *
     * 	@return Smarty Instance 
     */
    public function getSmarty() {

        return $this->smarty_instance;
    }

    /**
     * 	@author Sebastian  Balestrini
     * 	@version 2.0
     * 
     * 	  devuelve la instancia de ManagerCconnections
     * 	  		
     * 	@return ManagerConnections 
     */
    public function getDb() {

        return $this->db->getDb();
    }

    /**
     * 	@author Sebastian  Balestrini
     * 	@version 2.0
     * 
     * 	Assigna el contenido a una variable de smarty utilizando la instacia de la clase.		
     *
     * 	@return void
     */
    public function assign($var_name, $var_content) {

        $this->smarty_instance->assign($var_name, $var_content);
    }

    /**
     * 	@author Sebastian  Balestrini
     * 	@version 2.0
     * 
     * 	Setea el nombre del template maestro o layout que se va a utilizar
     * 	@param string $name nuevo nombre del template maestra.		
     *
     * 	@return void
     */
    public function setLayout($layout) {

        $this->layout = $layout;
        $this->assign("layout", $layout);
    }

    /**
     * 	@author Sebastian  Balestrini
     * 	@version 2.0
     * 
     * 	Setea el nombre del modulo por defecto�
     *
     * 	@param string  $module nombre del modulo.		
     *
     * 	@return void
     */
    public function setDefaultModule($module) {
        $this->default_module = $module;
    }

    /**
     * 	@author Sebastian  Balestrini
     * 	@version 2.0
     * 
     * 	Setea el nombre del submodulo por defecto
     * 	
     * 	@param string $submodule nombre del submodulo.		
     *
     * 	@return void
     */
    public function setDefaultSubModule($submodule) {
        $this->default_submodule = $submodule;
    }

    /**
     * 	@author Sebastian  Balestrini
     * 	@version 2.0
     * 
     * 	Setea el controlador en modo SEO
     *
     * 	@param boolean $seo True/false segun desee o no trabajar en modo SEO
     *
     * 	@return void
     */
    public function setSeo($seo = true) {
        $this->seo = $seo;
    }

    public function setSeoSubfolder($seo_subfolder = "") {
        $this->seo_subfolder = $seo_subfolder;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Setea el idioma de la web
     * 	
     * 	@param string $lang Idioma de la web
     *
     * 	@return void
     */
    public function setLang($lang) {
        $this->smarty_actual_lang = $lang;
        $_SESSION[URL_ROOT]['lang'] = $lang;

        switch ($lang) {

            case "es": $_SESSION[URL_ROOT]['ididioma'] = 1;
                break;
            case "en": $_SESSION[URL_ROOT]['ididioma'] = 2;
                break;
            case "pt": $_SESSION[URL_ROOT]['ididioma'] = 3;
                break;
        }
    }

    /**
     * 	@author Sebastian  Balestrini
     * 	@version 2.0
     * 
     * 	Incluye un submodulo sin depender de un parseo de smarty.
     * 	Util para cuando se incluye un modulo en el home siempre por ejemplo.		
     *    		
     * 	@return void
     */
    public function includeSubmodule($module, $submodule) {

        $module_file = path_view("modules/$module/$submodule.php");
        if (file_exists($module_file)) {
            require_once ($module_file);
        }
        return;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Ejecuta una Acci�n
     *
     * 	@return void
     */
    private function doAction() {

        // Primero debemos validar que el llamador sea un script propio
        // Debemos validar que tenga permiso de ejecutar accion        

        if (isset($this->request["helper"])) {

            $file = "actions/helpers/help." . $this->request["helper"] . ".do.php";
        } else {

            $file = "actions/" . $this->actual_module . "/" . $this->actual_submodule . ".do.php";
        }

        // Ejecutamos la accion
        if (file_exists(path_my_app($file))) {
            require_once(path_my_app($file));
        } else {
            return false;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Determina si la solicitud es una accion o no
     *
     * 	@return void
     */
    protected function isAction() {

        if (isset($this->request['action']) && (int) $this->request['action'] == 1) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Determina segun la segurdad si se puede acceder a un modulo/submodulo
     * 	En caso que sea necesario, las subclases debera�n implementar esta fuci�n		
     *
     * 	@return void
     */
    protected function isAllowed() {

        return true;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Realiza un print_r del arreglo de REQUEST que le ha llegado al modulo
     *
     * 	@return void
     */
    public function debugRequest() {

        echo "<pre>";
        print_r($this->request);
        echo "</pre>";
    }

    /**
     * 	@author Emanuel del barco
     * 	@author Sebastian Balestrini		
     * 	@version 2.0
     * 
     * 	Realiza la instanciacion y devolucion de un mananger 
     * 	@param string $name  nombre del manager		
     * 	@param string $table  tabla a la que hace referencia el manager
     * 	@param string $primaryKey  clave primaria a la tabla que hace referencia el manager		
     * 			
     * 	@return Manager|false si el manager no existe.
     */
    public function getManager() {

        $num_args = func_num_args();

        if ($num_args > 0) {

            $manager = func_get_arg(0);

            //$fileManager = path_managers("$manager.php");

            if (class_exists($manager)) {

                //require_once($fileManager);

                $params = func_get_args();

                $params[0] = '$this->getDb()';

                if (count($params) > 1) {
                    $db_code = array_shift($params);
                    $php_code = sprintf('$manager = new %s(%s);', $manager, "$db_code,'" . implode("','", $params) . "'");
                } else {
                    $php_code = sprintf('$manager = new %s(%s);', $manager, implode(",", $params));
                }

                eval($php_code);

                return $manager;
            } else {

                //lanzo una exepcion, el manager solicitado no existe
                throw new Exception("$manager NO ha sido definido");
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * 	@author Sebastian Balestrini		
     * 	@version 2.0
     * 
     * 	Realiza la inclusion de una Clase
     * 	@param string $name  nombre de la clase
     * 			
     * 	@return Manager|false si el manager no existe.
     */
    private function getClass($name, $instantiate = false) {

        $file = path_classes("$name.php");


        if (file_exists($file)) {

            require_once($file);

            if ($instantiate)
                return new $name();
            else
                return true;
        }else {
            return false;
        }
    }

    /**
     * 	@author Emanuel del barco
     * 	@author Sebastian Balestrini		
     * 	@version 2.0
     * 	
     * 	Devuelve el arreglo almacenado en la variable request
     */
    public function getRequest() {
        return $this->request;
    }

    /**
     * 	@author Emanuel del barco
     * 	@author Sebastian Balestrini		
     * 	@version 2.0
     * 	
     * 	Realiza utf-8 decode sobre todos los datos de request
     */
    function utf8_decode_request(& $array) {

        foreach ($array as $k => $v) {
            if (!is_array($v)) {

                $v = str_replace(chr(226) . chr(128) . chr(156), '"', $v);
                $v = str_replace(chr(226) . chr(128) . chr(157), '"', $v);

                $array[$k] = utf8_decode($v);
            } else {
                $this->utf8_decode_request($array[$k]);
            }
        }

        return;
    }

    /**
     * 	@author Emanuel del barco
     * 	@author Sebastian Balestrini		
     * 	@version 2.0
     * 	
     * 	Realiza utf-8 encode sobre todos los datos de request
     */
    function utf8_encode_request(& $array) {

        foreach ($array as $k => $v) {
            if (!is_array($v)) {


                $array[$k] = utf8_encode($v);
            } else {
                $this->utf8_encode_request($array[$k]);
            }
        }
    }

    /**
     * 	@author Emanuel del barco
     * 	@author Sebastian Balestrini		
     * 	@version 2.0
     * 	
     * 	Realiza utf-8 encode sobre todos los datos de request
     */
    function fixQuotes(& $array) {

        foreach ($array as $k => $v) {

            if (!is_array($v)) {

                $v = str_replace(chr(226) . chr(128) . chr(156), '"', $v);
                $v = str_replace(chr(226) . chr(128) . chr(157), '"', $v);

                $array[$k] = $v;
            } else {
                $this->fixQuotes($array[$k]);
            }
        }
    }

    /**
     * 	@author Emanuel del barco
     * 	@author Sebastian Balestrini		
     * 	@version 2.0
     * 
     * 	Inicializa los valores antes de realizar las salidas. Realiza
     * 	el utf-8 decode si es que el charset de website es iso 88859-1
     * 	y los datos vienen x ajax        		
     * 
     */
    function start() {

        if ($this->charset == "iso-8859-1" && $this->ajax) {

            $this->utf8_decode_request($this->request);
        }
        return;
    }

    /**
     * 	@author Emanuel del barco
     * 	@author Sebastian Balestrini		
     * 	@version 2.0
     * 
     * 	Realiza la salida de un mensaje terminando la ejecucion de un script
     * 	Es utilizado por los metodos llamados por ajax que devuelven alguna
     * 	clase de informacion para el usuario        		
     * 	
     *   @param string $msg Mensaje para dar salida          		
     * 	@return void Produce una salida de texto
     */
    function finish($msg, $do_return = false) {

        header("Content-type: application/json");
        if ($do_return) {
            return json_encode($msg);
        } else {
            echo json_encode($msg);
        }
    }

    /**
     * 	@author Sebastian Balestrini		
     * 	@version 2.0
     * 
     * 	Realiza la salida de un mensaje terminando la ejecucion de un script
     * 	Es utilizado por los metodos llamados por ajax que devuelven alguna
     * 	clase de informacion para el usuario        		
     * 	
     *   @param string $msg Mensaje para dar salida          		
     * 	@return void Produce una salida de texto
     */
    public function getSeo() {

        $managerSeo = $this->getManager("ManagerXSeo");

        $managerSeo->setSubfolderBase($this->seo_subfolder);

        return $managerSeo->getSeoByUrl();
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Anexa al final de la cadena el posfijo que corresponde la idioma. Si idioma =default no anexa nada          		
     * 	@return string
     */
    private function appendLang($string, $is_module = false) {

        if (($this->module_append_lang && $is_module) || !$is_module) {
            if ($this->default_lang != $this->smarty_actual_lang) {
                $string .= "_" . $this->smarty_actual_lang;
            }
        }
        return $string;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Setea el parametro multilang. Define si el controlador trabajar� multi idioma
     *
     * 	@param boolean $multi_lang Valor booleano que indica si se trabajar� en forma multiidioma    		
     * 	@return string
     */
    public function SetMultilang($multi_lang) {
        $this->multi_lang = $multi_lang;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Devuelve un valor booleano que determina si el controlador est� procesando multi idioma o no
     * 	
     * 	@return string
     */
    public function isMultilang() {
        return $this->multi_lang;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Devuelve un valor booleano que determina si el controlador est� procesando las solicitudes con o sin SEO
     * 		
     * 	@return string
     */
    public function isSeo() {
        return $this->seo;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Devuelve un valor booleano que determina si el controlador est� haciendo debug al procesar las solicitudes
     * 		
     * 	@return string
     */
    public function isDebug() {
        return $this->debug;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Setea Todos los paths necesarios para la aplicacion
     *
     * 	@return void
     */
    private function setPath() {

        // URL estandar para las imagenes

        if (defined("THEME")) {
            $this->assign("IMGS", URL_ROOT . "xframework/app/themes/" . THEME . "/imgs/");
        } else {
            $this->assign("IMGS", URL_ROOT . "xframework/app/" . $this->name . "/view/imgs/");
        }

        // URL estandar para los CSS
        $this->assign("CSS", URL_ROOT . "xframework/app/" . $this->name . "/view/css/");

        // URL de la pagina web que est� haciendo la solicitud
        $this->assign("SELF", "https://" . $_SERVER["HTTP_HOST"] . $_SERVER["REQUEST_URI"]);

        // URL WEB del Sistema
        $this->assign("url", URL_ROOT);
        $this->assign("url_lang", URL_ROOT . LANG . "/");

        // Xinha configuration
        $this->assign("xinha_path", XINHA_PATH);
        $this->assign("xinha_lang", XINHA_LANG);

        // Archivos JS del Idioma, siempre y cuando corresponda
        $this->setJsLang();
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Setea la URL del/los archivos JavaSCript del sistema multi idioma
     * 	@return string
     */
    private function setJsLang() {
        if ($this->isMultilang()) {
            if (file_exists(path_view(CONTROLLER . "/js/" . $this->getLanguage() . ".js"))) {

                $this->assign("js_lang", URL_VIEW . CONTROLLER . "/js/" . $this->getLanguage() . ".js");
            }
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     *
     * 	Funci�n abstracta que se redefine en cada instancia de controlador
     * 	@return void
     */
    abstract protected function init();

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Realiza los seteos basicos del controller
     * 	@return void
     */
    public function setUpController() {

        // Definimos los PATHS basicos
        if (!defined('PATH_TO_CONFIG')) {


            // Cargamos las funciones globales
            require_once(PATH_ROOT . "/xframework/core/functions/function.global.php");
            require_once(PATH_ROOT . "/xframework/core/functions/function.path.php");
            //JSON Para versiones menores a 5.2
            if (!function_exists('json_encode')) {
                require_once(PATH_ROOT . "/xframework/core/functions/function.JSON.php");
            }

            // Cargamos las configuraciones iniciales
            define('PATH_TO_CONFIG', PATH_ROOT . "/xframework/config/", true);
            $this->loadConfigs(PATH_TO_CONFIG);
        }

        // Trabajamos con una variable de Session por controllador. Alli almacenamos todo lo necesario para el procesamiento
        if (!isset($_SESSION[URL_ROOT])) {
            $_SESSION[URL_ROOT] = array();
        }

        // Hacemos la precarga de las clases BASE del sistema
        $this->loadClasses();

        $this->loadClasses(path_managers("base"), NULL);
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     *
     * 	Funci�n que realiza la carga de los archivos de configuraci�n del sistema
     * 	@return void
     */
    protected function loadConfigs($path) {

        if (file_exists(PATH_ROOT . "/xframework/config/init.config.php"))
            require_once(PATH_ROOT . "/xframework/config/init.config.php");
        if (file_exists(PATH_ROOT . "/xframework/config/db.config.php"))
            require_once(PATH_ROOT . "/xframework/config/db.config.php");
        if (file_exists(PATH_ROOT . "/xframework/config/mail.config.php"))
            require_once(PATH_ROOT . "/xframework/config/mail.config.php");
        if (file_exists(PATH_ROOT . "/xframework/config/libs.config.php"))
            require_once(PATH_ROOT . "/xframework/config/libs.config.php");
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     *
     * 	Realiza la carga de todas las Classes del sistema
     * 	@return void
     */
    protected function loadClasses($path = NULL, $filter = '.class.php') {



        if (is_null($path)) {
            $path = path_helpers("base");
        }


        if (is_dir($path)) {

            //recorro todos los directorios                                

            $d = dir($path);

            while (($entry = $d->read())) { // Recorre hasta vaciar el directorio
                if ($entry != "." && $entry != "..") {

                    //echo "Reading: $path/$entry <br>";

                    if (is_file("$path/$entry")) {

                        //echo "Is file: $path/$entry <br>";
                        //si es un archivo una class
                        if (is_null($filter) || (stripos($entry, $filter) !== false)) {

                            //echo "---Load: $path/$entry <br>";

                            if (stripos($entry, 'php.swp') === false) {
                                require_once("$path/$entry");
                            }
                        }
                    } else {
                        if (is_dir("$path/$entry") && $entry != "none" && stripos($entry, '.svn') === false) {
                            $this->loadClasses("$path/$entry", $filter);
                        }
                    }
                }
            }
        } else {
            return;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Retorna la instancia para poder implementar el patr�n Singleton
     *
     * 	@return void
     */
    public static function getInstance() {
        if (!self::$instance) {
            self::$instance = new RequestController();
        }
        return self::$instance;
    }

    /**
     * 	@author Sebastian  Balestrini
     * 	@version 2.0
     *
     * 	Crea una instancia de la conexion a Base de Datos
     *
     * 	@return void
     */
    protected function setUpConnection() {

        //parametro en true para debug.
        $this->db = DBConnector::getInstance();
    }

    protected function setName($name) {
        $this->name = $name;
        define('CONTROLLER', $this->name);
    }

    public function print_r($request) {
        echo "<pre>";
        print_r($request);
        echo "</pre>";
    }

    /**
     * Manejador de los errores fatal que puedan ocurrir en el sistema
     * 
     */
    public function fatalError() {

        // Getting Last Error
        $last_error = error_get_last();


        // Check if Last error is of type FATAL
        if (isset($last_error['type']) && in_array($last_error['type'], [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR, E_USER_ERROR])) {
            if ($this->isAction()) {

                if ($this->debug) {

                    $msg = [
                        "result" => false,
                        "msg" => print_r($last_error, false)
                    ];
                } else {

                    $msg = [
                        "result" => false,
                        "msg" => "Error 500 - Error interno"
                    ];
                }
                //$this->notificarErrorFatal($last_error);
                $this->finish($msg);

                return;
            } else {
                if ($this->debug) {

                    $this->request[$this->module_name] = "error";

                    $this->request[$this->submodule_name] = "500";

                    $this->smarty_instance->assign("fatal_error", $last_error);

                    if (count($this->post) > 0) {

                        $this->smarty_instance->assign("type_request", "POST");
                    } else {

                        $this->smarty_instance->assign("type_request", "GET");
                    }

                    $this->smarty_instance->assign("request", $this->request);
                } else {

                    $this->request[$this->module_name] = "error";
                    $this->request[$this->submodule_name] = "500";
                    // $this->notificarErrorFatal($last_error);
                    $this->smarty_instance->assign("codigoError", base64_encode($this->actual_module . "&" . $this->actual_submodule));
                }

                return $this->process();
            }
        }
    }

    /**
     * Notificador de los errores fatal que puedan ocurrir en el sistema
     * 
     */
    public function notificarErrorFatal($error) {
        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);
        $mEmail->setSubject("ERROR 500 | DoctorPlus ");
        //armamos el cuerpo del error
        $url = $_SERVER["HTTP_HOST"] . $_SERVER["REQUEST_URI"];
        $ip = $_SERVER["REMOTE_ADDR"];
        $body = "<strong>URL:</strong>{$url}<br><strong>IP ADDR:</strong>$ip<br><strong>ERROR:</strong>" . json_encode($error) . "<br><strong>SESSION:</strong>" . json_encode($_SESSION[URL_ROOT]);


        $mEmail->setBody($body);
        $mEmail->addTo(DEFAULT_ERROR_EMAIL);
        $mEmail->send();
    }

    /**
     * Manejador de los errores fatal que puedan ocurrir en el sistema
     * 
     */
    public function accessError(ExceptionErrorPage $e) {

        // Getting Last Error
        $last_error = $e->getMessage();

        // Check if Last error is of type FATAL


        if ($this->isAction()) {

            if ($this->debug) {

                $msg = [
                    "result" => false,
                    "msg" => print_r($last_error, false)
                ];
            } else {

                $msg = [
                    "result" => false,
                    "msg" => $last_error
                ];
            }

            $this->finish($msg);

            return;
        } else {
            if ($this->debug) {

                $this->request[$this->module_name] = "error";

                $this->request[$this->submodule_name] = "403";

                $this->smarty_instance->assign("fatal_error", $last_error);

                if (count($this->post) > 0) {
                    $this->smarty_instance->assign("type_request", "POST");
                } else {
                    $this->smarty_instance->assign("type_request", "GET");
                }

                $this->smarty_instance->assign("request", $this->request);
            } else {

                $this->request[$this->module_name] = "error";

                $this->request[$this->submodule_name] = "403";

                $this->smarty_instance->assign("codigoError", base64_encode($this->actual_module . "&" . $this->actual_submodule));
            }

            return $this->process();
        }
    }

}

// end_class
?>
