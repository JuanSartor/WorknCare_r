<?php

/**
 * 	DBConnector
 *
 * 	@author Sebastian Balestrini <sbalestrini@gmail.com>
 * 	@version 1.0
 * 	Gestiona las conexiones a las Bases de Datos solicitadas
 */
// Requerimos la libreria ADODB Original
require_once(path_libs("libs_php/adodb/adodb.inc.php"));

/**
 * class DBConnector: Clase Administradora de conexiones MySQL
 *
 */
class DBConnector {

    private $db;
    private $db_type;
    private $debug;
    private static $instance;
    protected $isConnected = false;

    function __construct($debug = false, $db_type = NULL) {

        if (is_null($db_type)) {
            $this->db_type = 'mysqli';
        } else {
            $this->db_type = $db_type;
        }

        $this->debug = false;
        $this->connect();
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Inicializa la conexion
     *
     * 	@return void
     */
    private function connect() {

        $this->db = &ADONewConnection($this->db_type);
        $this->db->debug = $this->debug;
        if (($this->isConnected = $this->db->Connect(DB_SERVER, DB_USER, DB_PASS, DB_NAME))) {

            $this->db->SetFetchMode(ADODB_FETCH_ASSOC);
            //$this->db->Execute("SET NAMES 'utf8'");
            mysqli_set_charset($this->db->_connectionID, 'utf8');
        }
    }

    /** 	
     * 	@author Xinergia
     * 	@version 1.0
     *
     *
     * 	Retorna el status de conección True/False
     *
     * 	@return boolean
     */
    public function isConnected() {

        return $this->isConnected;
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
            self::$instance = new DBConnector();
        }
        return self::$instance;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Activa/desactiva el debug de adodb
     *
     * 	@param bool $state  estado del debug
     * 	@return void
     */
    public function setDebug($debug = false) {

        $this->db->debug = $debug;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Cierra una Instancia AdoDB  a la base solicitada
     *
     * 	@param string $base  Nombre de la Base de Datos
     * 	@return void
     */
    public function close() {

        $this->db->Close();
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Retorna la bariable DB
     *
     * 	@return ADONewConnection instancia de ADODb
     */
    public function getDb() {

        return $this->db;
    }

}

?>
