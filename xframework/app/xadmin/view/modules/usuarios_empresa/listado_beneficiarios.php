<?php

/**
 *
 *  Beneficiarios de empresas
 *
 */

$paginate = SmartyPaginate::getPaginate("beneficiarios_listado_".$this->request["idempresa"]);

$this->assign("paginate", $paginate);

?>