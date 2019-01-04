#! /bin/bash

pkgName=unisos.marme
bisosVenvName=py2-bisos-3

#########  End-Of-Params-Specification ###########

if [ $( type -t deactivate ) == "function" ] ; then
    deactivate
fi

PATH="$PATH:."

if [ ! -d "${bisosVirtEnvBase}" ] ; then
    bisosBaseDirSetup.sh
fi

bisosRootDir=$( bx-platformInfoManage.py  -i pkgInfoParsGet | grep rootDir_bisos | cut -d '=' -f 2 )
bisosVirtEnvBase="${bisosRootDir}/venv/${bisosVenvName}"

bisosPkgInstall.sh "${bisosVirtEnvBase}" ${pkgName}

