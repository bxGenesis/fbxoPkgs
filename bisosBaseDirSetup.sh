#! /bin/bash

#
# Running user should have sudo privileges
# 
#

function echoErr { echo "E: $@" 1>&2; }
function echoAnn { echo "A: $@" 1>&2; }
function echoOut { echo "$@"; }


function bisosBaseDirSetup {
    local currentUser=$(id -un)
    local currentUserGroup=$(id -g -n ${currentUser})

    local bisosRootDir="/bisos"
    local bxoRootDir="/bxo"
    local deRunRootDir="/de/run"        

    if [ $( type -t deactivate ) == "function" ] ; then
        deactivate
    fi

    sudo -H pip install --no-cache-dir --upgrade pip

    sudo -H pip install --no-cache-dir --upgrade virtualenv

    sudo -H pip install --no-cache-dir --upgrade bisos.bx-bases

    bx-platformInfoManage.py --bisosUserName="${currentUser}"  -i pkgInfoParsSet
    bx-platformInfoManage.py --bisosGroupName="${currentUserGroup}"  -i pkgInfoParsSet     

    bx-platformInfoManage.py --rootDir_bisos="${bisosRootDir}"  -i pkgInfoParsSet
    bx-platformInfoManage.py --rootDir_bxo="${bxoRootDir}"  -i pkgInfoParsSet
    bx-platformInfoManage.py --rootDir_deRun="${deRunRootDir}"  -i pkgInfoParsSet    

    echoAnn "========= bx-platformInfoManage.py -i pkgInfoParsGet ========="
    bx-platformInfoManage.py -i pkgInfoParsGet

    sudo mkdir -p "${bisosRootDir}"
    sudo chown -R ${currentUser}:${currentUserGroup} "${bisosRootDir}"

    sudo mkdir -p "${bxoRootDir}"
    sudo chown -R ${currentUser}:${currentUserGroup} "${bxoRootDir}"

    sudo mkdir -p "${deRunRootDir}"
    sudo chown -R ${currentUser}:${currentUserGroup} "${deRunRootDir}"
    
    #
    # With the above rootDirs in place, bx-bases need not do any sudo-s
    #
    bx-bases -v 20 --baseDir="${bisosRootDir}" -i pbdUpdate all
}

bisosBaseDirSetup
