<?php

/**
 *
 *  Usuarios secundarios de empresas
 *
 */

$paginate = SmartyPaginate::getPaginate("usuarios_secundarios_listado_".$this->request["idempresa"]);

$this->assign("paginate", $paginate);

?>