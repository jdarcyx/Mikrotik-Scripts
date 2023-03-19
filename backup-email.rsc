:global stelegram
:system script run send_msg

:local data [:system clock get date]
:local hora [:system clock get time]
:local nome ([:pick $data 7 11]."-".[:pick $data 0 3]."-".[:pick $data 4 6 ]."--".[:pick $hora 0 2]."-".[:pick $hora 3 5]."-".[:system identity get name])

:local dests { "email@email.com"; "email2@email.com" }
:local from [:tool e-mail get from]
:local user [:tool e-mail get user]
:local pass [:tool e-mail get password]
:local smtp [:tool e-mail get address]
:local port [:tool e-mail get port]
:local assunto ("Backup ".[:system identity get name])

:system backup save name=$nome

:foreach dest in=$dests do={
 $stelegram msg=("Enviando backup para $dest")
 :tool e-mail send password="$pass" server=$smtp subject="$assunto" to=$dest port=$port user=$user from=$from file="$nome.backup" body="$assunto"
}

:delay 10s
:file remove numbers=[:file find where name="$nome.backup"]
