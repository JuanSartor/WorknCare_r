<?php

  $manager = $this->getManager("ManagerObrasSociales");

  $records = $manager->getAutosuggest($this->request);

  echo $records;
  