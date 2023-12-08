# -a: all, -g: geographical, -d: day, -n: night
function wttr {
    param ( $loc, $mode )
    Switch ( $loc ) {
        -h {
            echo "param 1:`n city: new+york`n airport(codes): muc `n resort: ~Eiffel+Tower`n ip address: @github.com`n help: :help"
            echo "param 2:`n a: all`n d: day `n n: night`n g: {geographical`n f: format"
        }
        default {
            Switch ( $mode ) {
                -a { curl wttr.in/$loc }
                -d { curl v2d.wttr.in/$loc }
                -n { curl v2d.wttr.in/$loc }
                -g { curl v3.wttr.in/$loc }
                default { curl v2.wttr.in/$loc }
            }
        }
    }
}