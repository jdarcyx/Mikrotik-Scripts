:local tolerancia 75
:local ipmtr { "8.8.8.8"; "8.8.4.4"; "1.1.1.1"; "1.0.0.1" }
:local gws { [/ip route find where distance=1 and dst-address=0.0.0.0/0]; [/ip route find where distance=2 and dst-address=0.0.0.0/0] }
:local ifaces { [/ip arp get number=[find where address=[/ip route get number=($gws->0) gateway]] interface ]; [/ip arp get number=[find where address=[/ip route get number=($gws->1) gateway]] interface ] }
:local count 4
:local ttreq ($count * [/len $ipmtr])
:local srcaddr "201.71.216.143"
:local intindex 0
:local ssreq
:local percent
:local toffline

:foreach iface in=$ifaces do={
  :set percent 0
  :set ssreq 0

  :foreach ip in=$ipmtr do={
    :local ping [/ping address=$ip src-address=$srcaddr count=$count interface=$iface]
    :set ssreq ($ssreq + $ping)
  }
  
   :set percent ($ssreq * 100 / $ttreq) 

  if ($percent < $tolerancia) do={
    :log warning ("Perda maior que 25%. Desativando rota padrão pelo gw ".[/ip route get value-name=gateway number=($gws->$intindex)])
    :ip route disable numbers=($gws->$intindex)
  } else={
    :log warning ("Perda menor que 25%. Ativando rota padrão pelo gw ".[/ip route get value-name=gateway number=($gws->$intindex)])
    :ip route enable numbers=($gws->$intindex)
  }

  :set intindex ($intindex + 1)

}

  if ([/ip route get value-name=disabled number=($gws->0)] && [/ip route get value-name=disabled number=($gws->1)]) do={
    :log warning "Todas rotas padrão desativadas. Ativando todas!"
    foreach gw in=$gws do={
      :ip route enable numbers=$gw
    }
  }
