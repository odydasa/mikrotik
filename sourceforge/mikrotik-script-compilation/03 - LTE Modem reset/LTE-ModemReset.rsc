
# mar/11/2016 18:02:58 by RouterOS 6.35rc19

/system scheduler
add interval=10m name=LTE-TEST on-event=RUN policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive start-date=mar/06/2016 start-time=22:00:54

/system script
add name=TEST0 owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive source=":global \"signalstrengh_LTE\";\r\
    \n:global i 0;\r\
    \n/interface ppp-client info ppp-out2 do={\r\
    \n:set i (\$i+1);\r\
    \n:if (\$i=4) do={\r\
    \n:global \"signalstrengh_LTE\" [:pick \$\"signal-strengh\" 0 3];\r\
    \n/queue simple set 0 name=\"\$\"signalstrengh_LTE\"\" ;\r\
    \n/system script job remove [ find script=TEST0];\r\
    \n}\r\
    \n}"
add name=TEST1 owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive source=":global i 0;\r\
    \n:global Result 0;\r\
    \n:global LTEStatus\r\
    \n:global PingFailCount 0;\r\
    \n:global PingCount 10;\r\
    \n:global PingNumber 0;\r\
    \n:global InterfaceISP ppp-out2;\r\
    \n\r\
    \n:log info \"****** Starting LTE down check *******\";\r\
    \n\r\
    \n# check modem status\r\
    \n/interface ppp-client monitor \$InterfaceISP once do={\r\
    \n  :set LTEStatus \$status\r\
    \n  }\r\
    \n:if (\$LTEStatus != \"connected\") do={\r\
    \n  :set Result (\$Result+1);\r\
    \n  }\r\
    \n"
add name=RESET owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive source=":global Result\r\
    \n:global PingFailCount\r\
    \n:global LTEStatus\r\
    \n\r\
    \n#ping has failed PingCount times or ping check was skipped \r\
    \n:if (\$PingFailCount !=10 ) do={\r\
    \n:set Result (\$Result+1);\r\
    \n}\r\
    \n\r\
    \n:if (\$Result != 0) do={\r\
    \n  :log info \"Starting LTE Modem Reset Sequence\";\r\
    \n  /system routerboard usb power-reset duration=210\r\
    \n  :delay 180\r\
    \n  /system reboot;\r\
    \n}\r\
    \n\r\
    \n:log info \"****** LTE status check  \$LTEStatus *******\";"
add name=RUN owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive source=\
    "system script run TEST0;\r\
    \n:delay 10;\r\
    \nsystem script run TEST1;\r\
    \n:delay 10;\r\
    \nsystem script run PING;\r\
    \n:delay 15;\r\
    \nsystem script run RESET;"
add name=PING owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive source=\
    ":log info \"****** Starting PING check *******\";\r\
    \n{\r\
    \n:global PingFailCount [/ping 8.8.8.8 count=10 interval=1]\r\
    \n}"


