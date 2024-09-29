##########################################################
# config
##########################################################

function olh { ollama help $args }

function ol_host {
    if ([string]::IsNullOrEmpty( $args[0] )) {
        $Global:OLLAMA_HOST = "127.0.0.1"
    }
    else {
        $Global:OLLAMA_HOST = $args[0]
    }
}

function ol_origns {
    if ([string]::IsNullOrEmpty( $args[0] )) {
        $Global:OLLAMA_ORIGINS = "\*"
    }
    else {
        $Global:OLLAMA_ORIGINS = $args[0]
    }
}

function ol_max_models {
    if ([string]::IsNullOrEmpty( $args[0] )) {
        $Global:OLLAMA_MAX_LOADED_MODELS = 2
    }
    else {
        $Global:OLLAMA_MAX_LOADED_MODELS = $args[0]
    }
}

function ol_num_parallel {
    if ([string]::IsNullOrEmpty( $args[0] )) {
        $Global:OLLAMA_NUM_PARALLEL = 4
    }
    else {
        $Global:OLLAMA_NUM_PARALLEL = $args[0]
    }
}

##########################################################
# local
##########################################################

function olls { ollama list $args }
function olif { ollama show $args }
function ols { ollama start $args }
function olr { ollama run $args }
function ola { ollama create $args }
function olrm { ollama rm $args }
function olst { ollama ps $args }

##########################################################
# remote
##########################################################

function olps { ollama push $args }
function olpl { ollama pull $args }
