:global stelegram do={
:local idchat "" # ID do Chat obtido no TELEGRAM
:local token "" # ID do token obtido no TELEGRAM
:local novamsg

for i from=0 to=([:len $msg] - 1) do={
	:local char [:pick $msg $i]
	if ($char = ":") do={
		:set novamsg "$novamsg%3A"
	} else={
		if ($char = " ") do={
			:set novamsg "$novamsg%20"
		} else={
			:set novamsg value=("$novamsg".$char)
		}
	}
}

:local url ("https://api.telegram.org/bot".$token."/sendMessage?chat_id=".$idchat."&text=".$novamsg)

  /tool fetch url=$url keep-result=no
}