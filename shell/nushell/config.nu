# config.nu: loaded after env.nu. See https://www.nushell.sh/book/configuration.html
# starship, carapace, and zoxide are loaded from the vendor autoload dir (see env.nu).

$env.config.show_banner = false
$env.config.buffer_editor = "code"

# Print the terminfo source for a terminal, searching app bundles on macOS too.
def terminfo-source [term: string]: nothing -> string {
    let dirs = [
        /Applications/kitty.app/Contents/Resources/kitty/terminfo
        /Applications/Ghostty.app/Contents/Resources/terminfo
    ]
    let attempts = [["-x" $term]] | append ($dirs | each {|dir| ["-A" $dir "-x" $term] })
    for args in $attempts {
        let result = ^infocmp ...$args | complete
        if $result.exit_code == 0 { return $result.stdout }
    }
    ""
}

# Install kitty and Ghostty terminfo on a remote host so both terminals work there.
# Writes to the remote ~/.terminfo; --system installs for every user (needed for sudo).
def ssh-terminfo [host: string, --system] {
    let source = [xterm-kitty xterm-ghostty] | each {|term|
        let entry = terminfo-source $term
        if ($entry | is-empty) { print -e $"skip ($term): no local terminfo" }
        $entry
    } | str join
    if ($source | is-empty) { error make {msg: "no terminfo found locally"} }
    if $system {
        $source | ^ssh $host -- 'cat > /tmp/terminfo.src'
        ^ssh -t $host -- 'sudo tic -x /tmp/terminfo.src; rm -f /tmp/terminfo.src'
    } else {
        $source | ^ssh $host -- tic -x -
    }
}
