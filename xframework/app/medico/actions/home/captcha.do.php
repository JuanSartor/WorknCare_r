<?php
	/********** FRONT END CAPTCHA *************/
	
	require_once(path_root("xframework/core/libs/libs_php/captcha/captcha.class.php"));
	
	$captcha = new SimpleCaptcha();
	
	$captcha->minWordLength = 3;
	
	$captcha->wordsFile = "";
	
	$captcha->resourcesPath = path_root("xframework/core/libs/libs_php/captcha/resources");
	
	$captcha->session_var = "frontend_captcha";

	$captcha->CreateImage();

?>