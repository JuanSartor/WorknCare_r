<?php

use OpenTok\OpenTok;
use OpenTok\Role;
use OpenTok\MediaMode;

/**
 * 	Manager de sesiones en opentok de videoconsulta
 *
 * 	@author lucas
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerVideoConsultaSession extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "videoconsulta_session", "idvideoconsulta_session");
    }

    /**
     * Metodo que crea los registros de la sesion de la consulta para conectarse a TokBox
     * @param type $idvideoconsulta
     */
    public function iniciar_sesion_open_tok($idvideoconsulta) {

        if ($_SERVER["HTTP_HOST"] != "localhost") {
            require_once(path_libs("libs_php/OpenTok/vendor/autoload.php"));

            $opentok = new OpenTok(TOKBOX_API_KEY, TOKBOX_SECRET_KEY);
            // Create a session that attempts to use peer-to-peer streaming:
            $session = $opentok->createSession();
            // Store this sessionId in the database for later use
            $sessionId = $session->getSessionId();

            $record["session"] = $sessionId;
            $token_medico = $session->generateToken(array(
                'role' => Role::MODERATOR,
                'data' => 'tipo=medico',
                'expireTime' => time() + (30 * 24 * 60 * 60),
                'initialLayoutClassList' => array('focus')
            ));

            $token_paciente = $session->generateToken(array(
                'data' => 'tipo=paciente',
                'expireTime' => time() + (30 * 24 * 60 * 60),
                'initialLayoutClassList' => array('focus')
            ));
            $record["token_medico"] = $token_medico;
            $record["token_paciente"] = $token_paciente;
        }
        $record["videoconsulta_idvideoconsulta"] = $idvideoconsulta;
        $exist = $this->getByField("videoconsulta_idvideoconsulta", $idvideoconsulta);
        if ($exist) {
            parent::delete($exist[$this->id]);
        }

        return parent::insert($record);
    }
    
     /**
     * Genera el archivo que se utiliza en el checkeo para realizar las video consultas
     * 
     */
    public function generarSessionCheck(){
        
        require_once(path_libs("libs_php/OpenTok/vendor/autoload.php"));

        $opentok = new OpenTok(TOKBOX_API_KEY, TOKBOX_SECRET_KEY);
        // Create a session that attempts to use peer-to-peer streaming:
        
       
        $session = $opentok->createSession( ['mediaMode' => MediaMode::ROUTED]);
        // Store this sessionId in the database for later use
        $sessionId = $session->getSessionId();
        
        $token_check = $session->generateToken(array(
            'role' => Role::PUBLISHER,
            'data' => 'tipo=check',
            'expireTime' => time()+(30 * 24 * 60 * 60),
            'initialLayoutClassList' => array('focus')
        ));  
        
        
        $smarty = SmartySingleton::getInstance();

        $smarty->assign("sessionId", $sessionId);
        $smarty->assign("token", $token_check);        
        $smarty->assign("apiKey", TOKBOX_API_KEY);        
        
        file_put_contents( path_files("session_conectividad.js"), $smarty->Fetch("cron/session_conectividad.html"));
        
    }  

}
