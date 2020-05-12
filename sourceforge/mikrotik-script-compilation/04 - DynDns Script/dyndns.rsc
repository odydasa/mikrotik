/system script
add name=no-ip owner=martin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive source="############## Nastavenia Scriptu ##################\r\
    \n\r\
    \n:local noipuser \”email@.sk\"\r\
    \n:local noippass \”heslo\"\r\
    \n:local noiphost \”hostname.ddns.net\"\r\
    \n:local inetinterface \"pppoe-out1 -priklad interface alebo etherX\"\r\
    \n:global previousIP\r\
    \n\r\
    \n:if ([/interface get \$inetinterface value-name=running]) do={\r\
    \n   :local currentIP [/ip address get [find interface=\"\$inetinterface\" disabled=no] address]\r\
    \n   :for i from=( [:len \$currentIP] - 1) to=0 do={\r\
    \n       :if ( [:pick \$currentIP \$i] = \"/\") do={ \r\
    \n           :set currentIP [:pick \$currentIP 0 \$i]\r\
    \n       } \r\
    \n   }\r\
    \n\r\
    \n   :if (\$currentIP != \$previousIP) do={\r\
    \n       :log info \"No-IP: Current IP \$currentIP is not equal to previous IP \$previousIP, update needed\"\r\
    \n       :set previousIP \$currentIP\r\
    \n       :local url \"http://dynupdate.no-ip.com/nic/update\\3Fmyip=\$currentIP\"\r\
    \n       :local noiphostarray\r\
    \n       :set noiphostarray [:toarray \$noiphost]\r\
    \n       :foreach host in=\$noiphostarray do={\r\
    \n           :log info \"No-IP: Posielam update pre domenu \$host\"\r\
    \n           /tool fetch url=(\$url . \"&hostname=\$host\") user=\$noipuser password=\$noippass mode=http dst-path=(\"no-ip_ddns_update-\" . \$host . \".txt\")\r\
    \n           :log info \"No-IP: Domena \$host ma zmenenu novu IP \$currentIP\"\r\
    \n       }\r\
    \n   }  else={\r\
    \n       :log info \"No-IP:  IP \$previousIP je rovnaka ako predchadzajuca IP, netreba update\"\r\
    \n   }\r\
    \n} else={\r\
    \n   :log info \"No-IP: \$inetinterface nema IP, preto nevykonavam update.\"\r\
    \n}"
/system scheduler
add interval=10m name=schedule3 on-event=no-ip
