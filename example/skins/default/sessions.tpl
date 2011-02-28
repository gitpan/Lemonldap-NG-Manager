<!DOCTYPE html
	PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en-US" xml:lang="en-US">
<head>
<title><lang en="LemonLDAP::NG session explorer" fr="Explorateur de sessions LemonLDAP::NG"/></title>
<link href="<TMPL_VAR NAME="DIR">/lemonldap-ng.ico" rel="icon" type="image/x-icon" />
<link href="<TMPL_VAR NAME="DIR">/lemonldap-ng.ico" rel="shortcut icon" />
<!-- jQuery UI CSS -->
<link rel="stylesheet" type="text/css" id="csstheme" href="<TMPL_VAR NAME="DIR">/<TMPL_VAR NAME="CSS_THEME">/jquery-ui-1.8.6.custom.css" />
<!-- Manager CSS -->
<link rel="stylesheet" type="text/css" id="cssmenu" href="<TMPL_VAR NAME="DIR">/css/<TMPL_VAR NAME="CSS">" />
<script src="<TMPL_VAR NAME="DIR">/js/jquery-1.4.2.min.js" type="text/JavaScript"></script>
<script src="<TMPL_VAR NAME="DIR">/js/jquery-ui-1.8.6.custom.min.js" type="text/JavaScript"></script>
<script src="<TMPL_VAR NAME="DIR">/js/jquery.cookie.js" type="text/JavaScript"></script>
<script src="<TMPL_VAR NAME="DIR">/js/tree.js" type="text/JavaScript"></script>
<script src="<TMPL_VAR NAME="DIR">/js/sessions.js" type="text/JavaScript"></script>
<script type="text/JavaScript">//<![CDATA[
	var scriptname='<TMPL_VAR NAME="SCRIPT_NAME">';
	var imagepath='<TMPL_VAR NAME="DIR">/images/';
	var csspath='<TMPL_VAR NAME="DIR">/css/';
        var jqueryuiversion='1.8.6';
        var css_menu='<TMPL_VAR NAME="CSS">';
        var css_theme='<TMPL_VAR NAME="CSS_THEME">';
        var themepath='<TMPL_VAR NAME="DIR">/';
	var treejquerycss='false';
	var treeautoclose='false';
//]]></script>
<script src="<TMPL_VAR NAME="DIR">/js/manager.js" type="text/JavaScript"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
</head>
<body>

<!-- Tree CSS choice -->
<div id="css-switch" title="<lang en="Menu style" fr="Style de menu" />">
   <div id="organization">
   <p class="ui-widget-header ui-corner-all"><lang en="Organization" fr="Organisation" /></p>
   <button alt="tree"><lang en="Tree" fr="Arbre" /></button>
   <button alt="accordion"><lang en="Accordion" fr="Accordéon" /></button>
   </div>
   <div id="theme">
   <p class="ui-widget-header ui-corner-all"><lang en="Theme" fr="Thème" /></p>
   <button alt="ui-lightness"><lang en="Lightness" fr="Lumineux" /></button>
   <button alt="ui-darkness"><lang en="Darkness" fr="Obscur" /></button>
   </div>
</div>

<!-- Header -->
<div id="header">
   <a href="index.pl"><lang en="Configuration management" fr="Gestion de la configuration"/></a>
   <a href="sessions.pl"><lang en="Sessions explorer" fr="Explorateur de sessions"/></a>
   <span id="css-switch-link"><lang en="Menu style" fr="Style de menu" /></span>
<!-- Header -->
</div>

<!-- Menu (tree) -->
<div id="menu" class="ui-corner-all ui-helper-clearfix ui-widget-content">

   <!-- Query choice -->
   <div class="ui-corner-all ui-widget-header" style="text-align:center;">
      <span><lang en="Query" fr="Requête" /></span>
   </div>
   <div id="query-switch">
      <a href="<TMPL_VAR NAME="SCRIPT_NAME">" alt="user"><lang en="per user" fr="par utilisateur" /></a>
      <a href="<TMPL_VAR NAME="SCRIPT_NAME">?ipclasses=1" alt="ip"><lang en="per IP" fr="par IP" /></a>
      <a href="<TMPL_VAR NAME="SCRIPT_NAME">?doubleIp=1" alt="2ip"><lang en="double IP" fr="doubles IP" /></a>
   </div>

   <TMPL_VAR NAME="TREE">
</div>

<!-- Data -->
<div id="data" class="ui-corner-all ui-helper-clearfix ui-widget-content">
<!-- Container -->
</div>

</body>
</html>
