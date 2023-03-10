##########################################################
# config
##########################################################

# config files
$Global:OX_ELEMENT.pu = "$env:APPDATA\pueue\pueue.yml"
$Global:OX_ELEMENT.pua = "$env:APPDATA\pueue\pueue_aliases.yml"
# backup files
$Global:OX_OXIDE.bkpu = "$env:OX_BACKUP\pueue\pueue.yml"
$Global:OX_OXIDE.bkpua = "$env:OX_BACKUP\pueue\pueue_aliases.yml"

##########################################################
# management
##########################################################

function pus { pueue start $args }
function purs { pueue restart $args }
function pua { pueue add $args }
function purm { pueue remove $args }
function pupa { pueue pause $args }
function pust { pueue status }
function pucl { pueue clean; pueue status }
function puq { pueue kill $args }

##########################################################
# main
##########################################################

function puh { pueue help $args }
function pued { pueue edit $args }
function purs { pueue reset }
