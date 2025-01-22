<?php

$this->start();

$recompensa = $this->getManager("ManagerGanadoresRecompensa")->getRecoByIdpaci($this->request["paciente_idpaciente"]);
if (count($recompensa) > 0) {
    $this->getManager("ManagerGanadoresRecompensa")->update(["recompensa_utilizada" => "1"], $recompensa["idganadorrecompensa"]);
}
$manager = $this->getManager("ManagerPerfilSaludConsulta");

$result = $manager->processFromMedico($this->request);

$this->finish($manager->getMsg());


