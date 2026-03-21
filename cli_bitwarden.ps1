##########################################################
# config
##########################################################

function up_bitwarden { bw import $args }
function back_bitwarden { bw export $args }
function bwcf { bw config $args }

##########################################################
# query
##########################################################

function bwsc {
    param ( $cmd, $obj )
    switch ( $cmd ) {
        -h { bw get --help }
        -u { bw get username $obj }
        -p { bw get password $obj }
        -n { bw get notes $obj }
        default { bw get item $obj --pretty }
    }
}

function bwst { bw status --pretty }
function bwh { bw --help }

##########################################################
# project management
##########################################################

function bwup { bw sync }

##########################################################
# item management
##########################################################

function bwe {
    param ( $cmd, $obj )
    switch ( $cmd ) {
        -d { bw edit folder $obj }
        default { bw edit item $obj }
    }
}

function bwrm {
    param ( $cmd, $obj )
    switch ( $cmd ) {
        -d { bw delete folder $obj }
        default { bw delete item $obj }
    }
}

function bwa { bw create $args }
function bwls { bw list $args }
