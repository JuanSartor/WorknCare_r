<?php

$this->start();

$_SESSION[URL_ROOT]['idioma'] = $this->request["idioma"];
$this->finish(["result" => true]);
