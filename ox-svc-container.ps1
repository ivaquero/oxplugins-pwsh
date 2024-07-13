##########################################################
# info
##########################################################

ForEach ($tool in "docker", "podman") {
    if (Get-Command $tool -ErrorAction SilentlyContinue) {
        $OX_CONTAINER = $tool
        break
    }
}

function cth { . $OX_CONTAINER --help $args }
function ctif { . $OX_CONTAINER info $args }

##########################################################
# containers
##########################################################}

function ctc { . $OX_CONTAINER container $args }
function ctch { . $OX_CONTAINER container --help $args }
function ctcls { . $OX_CONTAINER container ls $args }
function ctcat { . $OX_CONTAINER container attach $args }
function ctcr { . $OX_CONTAINER container run -it --name $args }
function ctcs { . $OX_CONTAINER container start $args }
function ctcrs { . $OX_CONTAINER container restart $args }
function ctcst { . $OX_CONTAINER container stats $args }
function ctcpa { . $OX_CONTAINER container pause $args }
function ctcupa { . $OX_CONTAINER container unpause $args }
function ctcq { . $OX_CONTAINER container kill $args }
function ctcdf { . $OX_CONTAINER container diff $args }
function ctccl { . $OX_CONTAINER container prune $args }
function ctca { . $OX_CONTAINER container create --name $args }
function ctcrm { . $OX_CONTAINER container rm $args }
function ctcif { . $OX_CONTAINER container inspect $args }
function ctcii { . $OX_CONTAINER container init $args }

##########################################################
# images
##########################################################

function cti { . $OX_CONTAINER image $args }
function ctih { . $OX_CONTAINER image --help $args }
function ctisc { . $OX_CONTAINER image search $args }
function ctils { . $OX_CONTAINER image list $args }
function ctirm { . $OX_CONTAINER image rm $args }
function cticl { . $OX_CONTAINER image prune $args }
function ctidf { . $OX_CONTAINER image diff $args }
function ctiif { . $OX_CONTAINER image inspect $args }
function ctib { . $OX_CONTAINER image build $args }
function ctcup { . $OX_CONTAINER image update $args }
function ctipl { . $OX_CONTAINER image pull $args }
function ctips { . $OX_CONTAINER image push $args }
