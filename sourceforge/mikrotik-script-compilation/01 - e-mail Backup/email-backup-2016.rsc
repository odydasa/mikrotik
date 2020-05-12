# doplnte správne údaje - e-mail adresu kam bude email odoslaný  


:global 1Name [ /system identity get name ]
:global sName "$sName@vasadomena.sk"
:global eName "e-mail@domena.sk"

# doplnte správne údaje SNTP servera

:global ipName "IPadresaServera"
:global eHeslo "heslo na server"


/system script
add name=E-MAIL-Backup owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="{\r\
    \n:local rName [ /system identity get name ];\r\r\
    \n/export file=\"export-\$rName.rsc\";\r\r\
    \n:delay 10s;\r\r\
    \n/tool e-mail send to=$eName subject=\"Router Backup - \$rName \" body=\" Mikrotik Backup \$rName  script.\\n\\n Router date and time : \$[/system clock get date] - \$[/system clock get time]\\n file = \" file=[ /file find name=\"\
    export-\$rName.rsc\" ];\r\
    \n:delay 2s;\r\
    \n/file remove [find name=\"export-\$rName.rsc\"];\r\r\
    \n}"
/tool e-mail
set address=$ipName from=$sName password=$eHeslo user=$eName
system scheduler
add interval=1w name=schedule-backup on-event=E-MAIL-Backup