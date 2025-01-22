
<title>{$seoArray.meta_title}</title>
{if $url=="https://www.workncare.io/"}
    <meta name="robots" content="noodp" />
    <meta name="robots" content="noydir" />
    <meta name="robots" content="index,follow" />
{/if}
<meta http-equiv="content-language" content="fr-FR" />

<meta name="revisit" content="3 days"/>
<meta name="distribution" content="Global"/>

<meta name="DC.Language" scheme="RFC1766" content="French">


{**** Código Genérico SEO ***}
<meta content="{$seoArray.meta_title}" name="title">
<meta content="{$seoArray.meta_description}" name="description">
<meta content="{$seoArray.meta_keywords}" name="keywords">
<meta name="dc.title" CONTENT="{$seoArray.meta_title}">
<meta name="dc.description" CONTENT="{$seoArray.meta_description}">

<meta property="og:url" content="{$SELF}" />
<meta property="og:type" content="article" />
<meta property="og:title" content="{$seoArray.meta_title}" />
<meta property="og:description" content="{$seoArray.meta_description}" />
<meta property="og:image" content="{$seoArray.image}" />

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
