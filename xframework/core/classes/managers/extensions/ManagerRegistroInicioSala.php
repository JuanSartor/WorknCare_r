<?php


/**Manager que se encarga de administrar la fecha y hora que se inicia la sala de una videoconsulta cuando es
 * aceptada por un medico
 * @author lucas
 */
class ManagerRegistroInicioSala extends Manager{
    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db,"registro_inicio_sala","idregistro_inicio_sala"); 
        
    }
    
    /**Metodo que retorna la cantidad de llamadas (ingresos a la sala) que ha hecho el medico para una consulta que
     * ha sido interrumpida y quedo pendiente de finalizacon
     * 
     * @param type $idvideoconsulta
     * @return type
     */
    public function getCantidadLlamadas($idvideoconsulta){
      
        $query=new AbstractSql();
        $query->setSelect("count(*) as qty");
        $query->setFrom("$this->table");
        $query->setWhere("videoconsulta_idvideoconsulta=$idvideoconsulta");
        
        $rdo=$this->db->getRow($query->getSql());
        return $rdo["qty"];
        
        
    }
}


