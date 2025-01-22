<?php
    /**
     *  Formulario de creación/edición de turno de para la agenda de medico
     *
     **/              

    $ManagerConfiguracionAgenda = $this->getManager("ManagerConfiguracionAgenda");
    

    $horarios_dia = $ManagerConfiguracionAgenda->getHorariosDia($this->request["dia_iddia"], $this->request["idconsultorio"]);
   
    $this->assign("horarios", $horarios_dia);
    