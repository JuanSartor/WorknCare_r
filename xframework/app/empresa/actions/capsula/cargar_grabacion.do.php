<?php

/**
 *  cargar video
 */
//print_r($this->request);
//print("holaaaa");
//print_r($this->request);
// aca va a entrar si cambia la grabacion y algo del titulo entonces lo actualizo 
if ($this->request["idGrabacion"]) {
    //  print_r($this->request);
    $mggraba = $this->getManager("ManagerGrabarVideoCapsula");
    $grab = $mggraba->get($this->request["idGrabacion"]);
    $this->request["nombreViejo"] = $grab["nombre"] . "." . $grab["ext"];
    $this->request["empresa_idempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
    $manCap = $this->getManager("ManagerCapsula");
    $manCap->update(["titulo" => $this->request["titulo"]], $grab["capsula_idcapsula"]);
    $cp = $this->getManager("ManagerEmpresaInvitacionCapsula")->getByField("capsula_idcapsula", $grab["capsula_idcapsula"]);
    $this->request["hashCapsula"] = $cp["hash"];

    $mggraba->actualizarGrabarVideo($this->request);
    $this->finish($mggraba->getMsg());
} else {
    $this->request["empresa_idempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
    $Manager = $this->getManager("ManagerGrabarVideoCapsula");
    $result = $Manager->processGrabarVideo($this->request);
    $this->finish($Manager->getMsg());
}

