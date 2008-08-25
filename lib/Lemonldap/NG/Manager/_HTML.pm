package Lemonldap::NG::Manager::_HTML;

# This package contains all subroutines that are provided after a
# 'header_public' call. So those functions are called only if the browser
# comes for the first time.

use AutoLoader qw(AUTOLOAD);
require Lemonldap::NG::Manager::_i18n;
use Lemonldap::NG::Manager::Conf::Constants;

our $VERSION = '0.31';

# TODO: Delete buttons in headers and rules if 'read-only'

# TODO: Display errors in saveConf
1;
__END__

=pod
=cut
sub css {
    print <<EOT;
/* xSplitter Styles */
.clsSplitter
{
  position: absolute;
  overflow: hidden;
  visibility: hidden;
  margin: 0;
  padding: 0;
  background: #FFF;
  border: none;
}

.clsPane
{
  position: absolute;
  overflow: auto;
  visibility: visible;
  margin: 0;
  padding: 0;
  background: #FFF;
  border: none;
}

.clsDragBar
{
  position: absolute;
  overflow: hidden;
  visibility: visible;
  margin: 0;
  padding: 0;
  background: lightgrey;
  border: none;
}

/* Application Styles */

#xBody { overflow: visible; background-color: #FFF; }
.clsTemporaryContainer /* replace this with something like xFenster */
{
  position: relative;
  overflow: visible;
  visibility: visible;
  background: transparent;
  border: none;
}
#idSplitter3 { border: 4px solid lightgrey; }
h3, p { padding: 0 0 0 6px; border: none; }
#buttons { text-align: center; }
#help { text-align: left; }
EOT
}

sub javascript {
    my $self = shift;
    Lemonldap::NG::Manager::_i18n::import( $ENV{HTTP_ACCEPT_LANGUAGE} )
      unless ( __PACKAGE__->can('txt_newVirtualHost') );
    my %text;
    foreach (
        qw(newVirtualHost newMacro newGroup newVar newGSOpt saveConf
               deleteNode locationRules unableToSave confSaved saveFailure
               newRule newHeader httpHeaders waitingResult unknownError
               configurationWasChanged configLoaded warningConfNotApplied
               applyConf prevConf lastConf nextConf deleteVirtualHost
               areYouSure syntaxError deleteConf confirmDeleteConf
        invalidVirtualHostName)
      )
    {
        $text{$_} = &{"txt_$_"};
        $text{$_} =~ s/'/\\'/g;
    }
    print qq#
function loadConf(n) {
  document.body.style.cursor='wait';
  document.getElementById('treeBox').innerHTML='';
  tree=new dhtmlXTreeObject(document.getElementById('treeBox'),"100%","100%",0);
  tree.setImagePath("$self->{dhtmlXTreeImageLocation}");
  tree.setXMLAutoLoading("$ENV{SCRIPT_NAME}?lmQuery=conf");
  tree.loadXML("$ENV{SCRIPT_NAME}?lmQuery=conf&cfgNum="+n);
  tree.setOnClickHandler(onNodeSelect);
  tree.selectItem('virtualHosts',true,false);
  document.getElementById('help').innerHTML='<h3>$text{configLoaded}</h3>';
  window.setTimeout("document.body.style.cursor='auto'",1000);
}

var s3,s32;

window.onload=function(){
  var w=X.clientWidth()-12;
  var h=X.clientHeight()-12;
  //var h=window.outerHeight;
  s32=new xSplitter('idSplitter32',0,0,0,0,false,4,h/2,h/8,true,0);
  s3=new xSplitter('idSplitter3',0,0,w,h,true,4,w/4,w/8,true,4,null,s32);
  X.addEventListener(window,'resize',win_onresize,false);
  document.getElementById('help').innerHTML='<h3>$text{waitingResult}</h3>';
  loadConf(0);
};

function win_onresize(){
  var cw=X.clientWidth();
  var w=X.clientWidth()-12;
  var h=X.clientHeight()-12;
  s3.paint(w,h,w/4,w/5);
}

var indice=1;

function onNodeSelect(nodeId) {
  var k,v;
  if(tree.getUserData(nodeId,"modif")) {
    switch(tree.getUserData(nodeId,"modif")) {
      case 'text':
        k='valeur';
        v='<input size="$self->{inputSize}" value="'+tree.getItemText(nodeId)+'" onChange="tree.setItemText('+"'"+nodeId+"'"+',this.value);">';
        break;
      case 'both':
        k='<input size="$self->{inputSize}" value="'+tree.getItemText(nodeId)+'" onChange="tree.setItemText('+"'"+nodeId+"'"+',this.value)">';
        v='<textarea cols="$self->{textareaW}" rows="$self->{textareaH}" onChange="tree.setUserData('+"'"+nodeId+"'"+','+"'"+'value'+"'"+',this.value)">'+tree.getUserData(nodeId,'value')+'</textarea>';
        break;
      case 'value':
        k=tree.getItemText(nodeId);
        v='<textarea cols="$self->{textareaW}" rows="$self->{textareaH}" onChange="tree.setUserData('+"'"+nodeId+"'"+','+"'"+'value'+"'"+',this.value)">'+tree.getUserData(nodeId,'value')+'</textarea>';
        break;
      case 'ro':
        k=tree.getItemText(nodeId);
        v='<p>'+tree.getUserData(nodeId,'value')+'</p>';
        break;
      case 'none':
        k=tree.getItemText(nodeId);
        v='<p>&nbsp;</p>';
        break;
    }
    document.getElementById('formulaire').style.display='block';
    document.getElementById('name').innerHTML = k;
    document.getElementById('value').innerHTML = v;
  }
  else {
    document.getElementById('formulaire').style.display='none';
  }
  var but='';
  if(nodeIs(nodeId,"virtualHosts") && tree.getUserData(nodeId,"modif") != "none" && tree.getUserData(nodeId,"modif") != 'ro' ){
    but+=button('$text{newVirtualHost}','newVirtualHost',nodeId);
    if(nodeIs(nodeId,"virtualHost")){
      but+=button('$text{deleteVirtualHost}','deleteVirtualHost',nodeId);
      but+=button('$text{newRule}','newRule',nodeId);
      but+=button('$text{newHeader}','newHeader',nodeId);
    }
    help('virtualHosts');
  }
  else if(nodeIs(nodeId,"macros")){
    but+=button('$text{newMacro}','newMacro',nodeId);
    help('macros');
  }
  else if(nodeIs(nodeId,"groups")){
    but+=button('$text{newGroup}','newGroup',nodeId);
    help('groups');
  }
  else if(nodeIs(nodeId,"whatToTrace")){
    help('whatToTrace');
  }
  else if(nodeIs(nodeId,"generalParameters")){
    if(nodeIs(nodeId,"ldapParameters")){
      help('ldap');
    }
    else if(nodeIs(nodeId,"exportedVars")){
      but+=button('$text{newVar}','newVar',nodeId);
      help('vars');
    }
    else if(nodeIs(nodeId,'sessionStorage')){
      if(nodeIs(nodeId,"globalStorageOptions")){
        but+=button('$text{newGSOpt}','newGSOpt',nodeId);
      }
      help('storage');
    }
    else if(nodeIs(nodeId,'authParams')){
      help('authParams');
    }
    else if(nodeIs(nodeId,'cookieName')){
      help('cookieName');
    }
    else if(nodeIs(nodeId,'timeout')){
      help('timeout');
    }
    else if(nodeIs(nodeId,'domain')){
      help('domain');
    }
  }
  if(tree.getUserData(nodeId,"modif")=='both') but+=button('$text{deleteNode}','deleteNode',nodeId);
  but+=button('$text{saveConf}','saveConf',nodeId);
  if(nodeId == 'root') but+=button('$text{prevConf}','prevConf',nodeId)
                           +button('$text{nextConf}','nextConf',nodeId)
                           +button('$text{lastConf}','lastConf',nodeId)
                           +button('$text{deleteConf}','deleteConf',nodeId);
  #;
    if ( $self->{applyConfFile} ) {
        print "but+=button('$text{applyConf}','applyConf',nodeId);";
    }
  print qq#
  document.getElementById('buttons').innerHTML = but;
}

function nodeIs(id,type) {
  if(id==type)return 1;
  if(id=="root")return 0;
  var next=tree.getParentId(id);
  if(type=="virtualHost" && next=="virtualHosts")return 1;
  return nodeIs(next,type);
}

function vhostId(id){
  var next=tree.getParentId(id);
  if(next=="virtualHosts") return id;
  return vhostId(next);
}

function button(text,func,nodeId){
  return '<input type=button value="'+text+'" onclick="'+func+'('+"'"+nodeId+"'"+')"> &nbsp; ';
}

function insertNewChild(a,c) {
  indice++;
  tree.insertNewChild(a,'js_'+indice,c);
  tree.setItemColor('js_'+indice,"\#000000","\#0000FF");
  return 'js_'+indice;
}

function newVirtualHost() {
  var rep=prompt("$text{newVirtualHost}");
  if(rep) {
    if(!rep.match(/^\\w[\\w\\.\\-]*\\w\$/)){
      alert('$text{invalidVirtualHostName}');
      return 0;
    }
    var tmp=insertNewChild('virtualHosts',rep)
    tree.setUserData(tmp,'modif','text');
    //var tmp_eh=insertNewChild(tmp,'$text{httpHeaders}');
    var tmp_eh=tmp+'_exportedHeaders';
    tree.insertNewChild(tmp,tmp_eh,'$text{httpHeaders}');
    tree.setItemColor(tmp_eh,"\#000000","\#0000FF");
    var tmp_eh1=insertNewChild(tmp_eh,'Auth-User');
    tree.setUserData(tmp_eh1,'modif','both');
    tree.setUserData(tmp_eh1,'value','\$uid');
    var tmp_lr=tmp+'_locationRules';
    tree.insertNewChild(tmp,tmp_lr,'$text{locationRules}');
    tree.setItemColor(tmp_lr,"\#000000","\#0000FF");
    var tmp_lr1=insertNewChild(tmp_lr,'default');
    tree.setUserData(tmp_lr1,'modif','value');
    tree.setUserData(tmp_lr1,'value','deny');
  }
}

function deleteVirtualHost(id) {
  var vh=vhostId(id);
  if(confirm('$text{areYouSure}')) tree.deleteItem(vh);
}

function newValue(id,text,type,value){
  var tmp=insertNewChild(id,text);
  tree.setUserData(tmp,'modif',type);
  tree.setUserData(tmp,'value',value);
  tree.selectItem(tmp,true);
}

function newRule(id){
  var lr=tree.getItemIdByIndex(vhostId(id),1);
  newValue(lr,'^/New/rule','both','deny');
}

function newHeader(id){
  var eh=tree.getItemIdByIndex(vhostId(id),0);
  newValue(eh,'New-Header','both','\$uid');
}

function newGroup(id){
  newValue('groups','NewGroup','both','');
}

function newMacro(id){
  newValue('macros','NewMacro','both','');
}

function newVar(id){
  newValue('exportedVars','NewVar','both','uid');
}

function newGSOpt(id){
  newValue('globalStorageOptions','NewOpt','both','');
}

function deleteNode(id){
  tree.deleteItem(id);
}

var xhr_object = null; 

if(window.XMLHttpRequest) // Firefox 
  xhr_object = new XMLHttpRequest(); 
else if(window.ActiveXObject) // Internet Explorer 
  xhr_object = new ActiveXObject("Microsoft.XMLHTTP"); 
else { // XMLHttpRequest non support� par le navigateur 
  alert('$text{unableToSave}');
} 

function help(s){
  xhr_object.open("GET", "$ENV{SCRIPT_NAME}?lmQuery=help&help="+s, true); 
  xhr_object.onreadystatechange = function() { 
    if(xhr_object.readyState == 4) document.getElementById('help').innerHTML=xhr_object.responseText; 
  }
  xhr_object.send(null);
}

function saveConf(){
  var h=tree2txt('root');
  xhr_object.open("POST", "$ENV{SCRIPT_NAME}?lmQuery=upload",true);
  xhr_object.setRequestHeader("Content-type", "text/xml");
  xhr_object.setRequestHeader("Content-length", h.length);
  xhr_object.onreadystatechange = function() {
    if(xhr_object.readyState == 4){
      window.setTimeout(xhr_object.responseText,0);
    }
    else document.getElementById('help').innerHTML='<h3>$text{waitingResult}</h3>';
  }
  xhr_object.send(h);
}

function tree2txt(id){
  var s=tree.getSubItems(id);
  var c;
  id = id.replace(/^[0-9]*_/,'');
  var r='<'+id+"><text>"+ec(tree.getItemText(id))+"</text>\\n";
  if((!s) || s==''){
    r+= '<value>'+ec(tree.getUserData(id,'value'))+"</value>\\n";
  }
  else {
    c=s.split(',');
    for(var i=0;i<c.length;i++){
      r+=tree2txt(c[i]);
    }
  }
  r+="</"+id+">\\n";
  return r;
}

function applyConf(){
  xhr_object.open('GET', "$ENV{SCRIPT_NAME}?lmQuery=apply",true);
  xhr_object.onreadystatechange = function() { 
    if(xhr_object.readyState == 4) document.getElementById('help').innerHTML=xhr_object.responseText; 
  }
  xhr_object.send(null);
}

var previous = 0;
function prevConf(){
  previous--;
  loadConf(previous);
}

function nextConf(){
  if(previous<0){
    previous++;
    loadConf(previous);
  }
}

function lastConf(){
  previous=0;
  loadConf(0);
}

function deleteConf(){
  if(!(confirm('$text{confirmDeleteConf}'))) return 0;
  previous=0;
  xhr_object.open('GET', "$ENV{SCRIPT_NAME}?lmQuery=delete&cfgNum="+previous,true);
  xhr_object.onreadystatechange = function() { 
    if(xhr_object.readyState == 4){
      document.getElementById('help').innerHTML=xhr_object.responseText;
      loadConf(0);
    } 
  }
  xhr_object.send(null);
}

function ec(s){
  if((!s) || s=='') return s;
  return s.replace(/>/g,'&gt;').replace(/</g,'&lt;');
}
#;
}

sub start_html {
    my $self = shift;
    my %args = @_;
    $args{'-style'} = { -src => [ $args{'-style'} ] }
      if ( $args{'-style'} and !ref( $args{'-style'} ) );
    unshift @{ $args{'-style'}->{'-src'} }, "$ENV{SCRIPT_NAME}?lmQuery=css";
    $args{'-title'}    ||= 'Lemonldap::NG Configuration';
    $args{'-encoding'} ||= 'utf8';
    $self->CGI::start_html(%args);
}

sub main {
    Lemonldap::NG::Manager::_i18n::import( $ENV{HTTP_ACCEPT_LANGUAGE} )
      unless ( __PACKAGE__->can('txt_field') );
    my %text;
    foreach (qw(field value)) {
        $text{$_} = &{"txt_$_"};
        $text{$_} =~ s/'/\\'/g;
    }

    # Lemonldap::Manager javascripts;
    print
qq#<script type="text/javascript" src="$ENV{SCRIPT_NAME}?lmQuery=libjs"></script>\n#;
    print
qq#<script type="text/javascript" src="$ENV{SCRIPT_NAME}?lmQuery=lmjs"></script>\n#;

    # HTML code
    print <<EOT;
  <div id='xBody'>
    <div class="clsTemporaryContainer">
      <div style="visibility: visible;" id="idSplitter3" class="clsSplitter">
        <div style="z-index: 2;" id="gauche" class="clsPane">
           <div id="treeBox" style="width:200;height:200"></div>
        </div><!-- end Pane -->

        <div style="overflow: hidden; z-index: 2;" id="droit" class="clsPane">
          <div style="visibility: visible;" id="idSplitter32" class="clsSplitter">
            <div style="z-index: 2;" id="haut" class="clsPane">
             <div id="buttons"></div>
             <div id="formulaire" style="display:none;">
              <form onsubmit="return false" action="$ENV{SCRIPT_NAME}">
               <p></p>
               <table border="1" width="100%" style="empty-cells:show;">
                <tr>
                 <th width="200">$text{field}</th>
                 <th width="400">$text{value}</th>
                </tr>
                <tr>
                 <td>
                  <div id="name">&nbsp;</div>
                 </td>
                 <td>
                  <div id="value">&nbsp;</div>
                 </td>
                </tr>
               </table>
              </form>
             </div>
            </div><!-- end Pane -->

            <div style="z-index: 2;" id="bas" class="clsPane">
            <div id="help"></div>
            </div><!-- end Pane -->

            <div style="z-index: 1; cursor: n-resize;" id="barre2" class="clsDragBar">
              &nbsp;
            </div>
          </div><!-- end Splitter -->
        </div><!-- end Pane -->

        <div style="z-index: 1; cursor: e-resize;" class="clsDragBar">
          &nbsp;
        </div>
      </div><!-- end Splitter -->
    </div><!-- end TemporaryContainer -->
  </div>
EOT
}

