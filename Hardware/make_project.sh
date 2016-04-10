#!/bin/sh

###############################################################################
# make_project.sh
#
# Create the Quartus-II project files according to scripts/ and LIST file in src/.
#
# After running this script, use the Makefile in the new project directory to
# build the project and configure the FPGA.
#
###############################################################################

PROJECT_NAME="lsd_cv"

# Relative path to the (future) project directory
PROJECT_PATH=proj

# Relative path to the (existing) source directory
SOURCE_PATH=src

# Relative path and name of the project settings script
SETTINGS_SCRIPT=scripts/settings.tcl

MAKEFILE_TEMPLATE=scripts/Makefile.template


#-------------------------------------------------------#

# Determine how to move between project and source paths
CURRENT_PATH_CAN=$(readlink -m .)
PROJECT_PATH_CAN=$(readlink -m $PROJECT_PATH)
PATH_DIFF=${PROJECT_PATH_CAN#$CURRENT_PATH_CAN}
PATH_LVLS=$(echo $PATH_DIFF | tr -dc '/' | wc -m)
PATH_BACK=$(printf '../%.0s' {1..$PATH_LVLS})


# Create the project
mkdir -p $PROJECT_PATH
cd $PROJECT_PATH
quartus_sh -t "$PATH_BACK$SETTINGS_SCRIPT" "$PROJECT_NAME" "$PATH_BACK$SOURCE_PATH"
cd $PATH_BACK

# Create the Makefile
sed -e "s|TODO_PROJECT_TODO|$PROJECT_NAME|g" \
    -e "s|TODO_SOURCES_TODO|$PATH_BACK$SOURCE_PATH|g" \
    $MAKEFILE_TEMPLATE > $PROJECT_PATH/Makefile

