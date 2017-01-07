#!/bin/sh
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Criticas "construtivas"
# Mande me um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Este programa é um software livre; você pode redistribui-lo e/ou
# modifica-lo dentro dos termos da Licença Pública Geral GNU como
# publicada pela Fundação do Software Livre (FSF); na versão 2 da
# Licença, ou (na sua opinião) qualquer versão.
#
# Este programa é distribuído na esperança que possa ser útil,
# mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO a
# qualquer MERCADO ou APLICAÇÃO EM PARTICULAR.
#
# Veja a Licença Pública Geral GNU para mais detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# Script: Delete package from a local directory that you don't want
#
# Last update: 07/01/2017
#
# Tip: Add the packages you want in the packagesList

folderWork=$1
if [ "$folderWork" == '' ]; then
    echo -e "\nError: You need pass the folder to work\n"
elif [ ! -d "$folderWork" ]; then
    echo -e "\nError: The dictory \"$folderWork\" not exist\n"
else
    ## Add the packages you want in the packagesList

    ## Remover games
    packagesList="palapeli bomber granatier
    kblocks ksnakeduel kbounce kbreakout kgoldrunner
    kspaceduel kapman kolf kollision kpat lskat blinken
    khangman pairs ktuberling kdiamond ksudoku kubrick
    picmi bovo kblackbox kfourinline kmahjongg kreversi
    ksquares kigo kiriki kshisen gnuchess katomic
    kjumpingcube kmines knetwalk killbots klickety
    klines konquest ksirk knavalbattle kanagram amor kajongg"

    # Remover servidor X - Leave fluxbox # Safe propose
    packagesList=$packagesList" twm blackbox windowmaker fvwm xfce"

    #Remover kopote
    packagesList=$packagesList" kdenetwork kdenetwork-filesharing kdenetwork-strigi-analyzers kopete"

    ## Remove nepomuk
    packagesList=$packagesList" nepomuk nepomuk-core nepomuk-widgets"

    ## Remove akonadi
    packagesList=$packagesList" akonadi"

    ## Remove gnome "packages"
    packagesList=$packagesList" gcr polkit-gnome gnome-themes gnome-keyring libgnome-keyring"

    ## Remove other packages
    packagesList=$packagesList" seamonkey pidgin xchat dragon thunderbird kplayer
    calligra bluedevil blueman bluez bluez-firmware xine-lib xine-ui
    vim-gvim vim sendmail sendmail-cf xpdf tetex tetex-doc kget"

    filesDeleted="0_filesDeleted.txt"
    filesNotFound="0_filesNotFound.txt"

    for packageName in $packagesList; do
        echo "Looking for \"$packageName\""
        resultFind=`find $folderWork | grep $packageName`

        if [ "$resultFind" == '' ]; then
            echo "    Not found: \"$packageName\"" | tee -a $filesNotFound
        else
            echo -e "    Files removed: \"$packageName\"\n $resultFind\n\n" | tee -a $filesDeleted
            mkdir toBeDeleted 2> /dev/null
            mv $resultFind toBeDeleted/
        fi
    done

    echo -en "$CYAN\n\nWant create a ISO file from work folder?\n(y)es - (n)o (press enter to no): "
    read generateISO

    datePartName=`date +%Hh-%Mmin-%dday-%mmouth-%Yyear`
    isoFileName=$folderWork\_date-$datePartName

    if [ "$generateISO" == 'y' ]; then
        olderIsoSlackware=`ls | grep "slackware.*iso"`

        if [ "$olderIsoSlackware" != '' ]; then
            echo -e "\nOlder ISO file slackware found: $olderIsoSlackware$NC"
            echo -en "\nDelete the older ISO file(s) before continue?\n(y)es - (n)o (press enter to no): "
            read deleteOlderIso

            if [ "$deleteOlderIso" == 'y' ]; then
                rm slackware*.iso
            fi
        fi

        echo -en "\nCreating ISO file. Please wait..."

        mkisofs -pad -r -J -quiet -o $isoFileName.iso $folderWork
        # -pad   Pad output to a multiple of 32k (default)
        # -r     Generate rationalized Rock Ridge directory information
        # -J     Generate Joliet directory information
        # -quiet Run quietly
        # -o     Set output file name

        echo -e "\n\nThe ISO file \"$isoFileName.iso\" was generated by the folder $versionDownload/\n"
    else
        echo -e "\n\nExiting...\n\nIf you want create a ISO file, use:\nmkisofs -pad -r -J -o $isoFileName.iso $folderWork\n"
    fi
fi