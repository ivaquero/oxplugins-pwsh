if ([string]::IsNullOrEmpty($env:OXIDIZER)) {
    $env:OXIDIZER = "$HOME\oxidizer"
}

if (Get-Command scoop -ErrorAction SilentlyContinue) {
    echo "Scoop Already Installed"
}
else {
    echo "Scoop Not Found. Installing..."

    $f_scoop = Join-Path $HOME "install.ps1"

    if ( $env:scoop_mirror ) {
        Invoke-WebRequest 'https://gitee.com/glsnames/scoop-installer/raw/master/bin/install.ps1' -UseBasicParsing -OutFile $f_scoop

        scoop config SCOOP_REPO 'https://gitee.com/glsnames/scoop-installer'
    }
    else {
        Invoke-WebRequest 'https://raw.githubusercontent.com/ScoopInstaller/Install/master/install.ps1' -UseBasicParsing -OutFile $f_scoop
    }
    if ( $env:scoop_test ) { & $f_scoop -RunAsAdmin -ScoopDir 'C:\Scoop' }
    else { & $f_scoop -ScoopDir 'C:\Scoop' }
}

scoop install aria2 7zip

# add additional buckets
if ( $env:scoop_mirror ) {
    $scoopBuckets = @("nerd-fonts https://gitee.com/scoop-bucket/nerd-fonts", "extras https://gitee.com/scoop-bucket/extras.git")
}
else {
    $scoopBuckets = @("nerd-fonts", "extras")
}

ForEach ( $bucket in $scoopBuckets ) {
    scoop bucket add $bucket
}

$pkgs = cat "$env:OXIDIZER\defaults\Scoopfile.txt"

ForEach ( $pkg in $pkgs ) {
    Switch ($pkg) {
        ripgrep { $cmd = "rg" }
        zoxide { $cmd = "z" }
        Default { $cmd = $pkg }
    }
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        Write-Out "$pkg Already Installed"
    }
    else {
        Write-Out "Installing $pkg"
        scoop install $pkg
    }
    scoop install uutils-coreutils scoop-completion posh-git psreadline dark innounp
}

###################################################
# Update PowerShell Settings
###################################################

Remove-Item alias:cp -Force -ErrorAction SilentlyContinue

echo "Adding Oxidizer into $PROFILE..."

if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Force -Path $PROFILE
}

echo '# Oxidizer' >> $PROFILE

if ([string]::IsNullOrEmpty($env:OXIDIZER)) {
    if ($(uname).Contains("Windows")) {
        echo '
        $env:OXIDIZER = "$HOME\oxidizer"' >> $PROFILE
    }
    else {
        echo '
        $env:OXIDIZER = "$env:HOME\oxidizer"' >> $PROFILE
    }
    echo '. $env:OXIDIZER\oxidizer.ps1' >> $PROFILE
}
else {
    echo ". $env:OXIDIZER\oxidizer.ps1" >> $PROFILE
}

echo "Adding Custom settings..."

cp -R -v "$env:OXIDIZER\defaults.ps1" "$env:OXIDIZER\custom.ps1"

# load zoxide
sed -i.bak "s|.* OX_STARTUP = .*|$Global:OX_STARTUP=1|" "$env:OXIDIZER\custom.ps1"
# set path of oxidizer
# sed -i.bak "s| = .*\oxidizer.ps1| = $env:OXIDIZER\oxidizer.ps1|" $PROFILE
# echo $(cat $PROFILE | rg -o 'source .+')

###################################################
# Load Plugins
###################################################

git clone --depth=1 https://github.com/ivaquero/oxplugins-pwsh.git $env:OXIDIZER\oxplugins-pwsh

. $PROFILE

if (Get-Command code -ErrorAction SilentlyContinue) {
    scoop install vscode
    reg import "C:\Scoop\apps\vscode\current\install-associations.reg"
}

echo "Oxidizer installation complete!"
echo "Don't forget to restart your terminal and hit 'edf ox' to tweak your preferences.\n"
echo "Finally, run 'upox' function to activate the plugins. Enjoy!"
