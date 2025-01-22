<?php

  /**
   * Manager de las comprobante de cobro de cuotas 
   */
  $this->start();
  $manager = $this->getManager("ManagerCuota");
 
  $result = $manager->process($this->request);

  $this->finish($manager->getMsg());
  