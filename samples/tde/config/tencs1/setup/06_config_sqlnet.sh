#!/bin/bash
# -----------------------------------------------------------------------
# OraDBA - Oracle Database Infrastructure and Security, 5630 Muri, Switzerland
# -----------------------------------------------------------------------
# Name.......: 06_config_sqlnet.sh
# Author.....: Stefan Oehrli (oes) stefan.oehrli@oradba.ch
# Editor.....: Stefan Oehrli
# Date.......: 2019.02.20
# Revision...: --
# Purpose....: Script to configure SQLNet
# Notes......: --
# Reference..: https://github.com/oehrlis/oudbase
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# -----------------------------------------------------------------------
# Modified...:
# see git revision history with git log for more information on changes
# -----------------------------------------------------------------------

# - configure SQLNet ----------------------------------------------------

# - configure instance --------------------------------------------------
echo "Enable Unified Audit for Database ${ORACLE_SID}:"
echo "  ORACLE_SID          :   ${ORACLE_SID}"
echo "  ORACLE_HOME         :   ${ORACLE_HOME}"

cat << EOF > /u00/app/oracle/network/admin/listener.ora
LISTENER =
    (ADDRESS_LIST =
        (ADDRESS = (PROTOCOL=IPC )(KEY=LISTENER ))
        (ADDRESS = 
            (PROTOCOL = TCP )
            (HOST = $(hostname) )
            (PORT = 1521 )
        )
    )
SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
     (GLOBAL_DBNAME = ${ORACLE_SID}.trivadislabs.com)
     (ORACLE_HOME = ${ORACLE_HOME})
     (SID_NAME = ${ORACLE_SID})
    )
   )
EOF

cat << EOF > /u00/app/oracle/network/admin/tnsnames.ora
TENCS1.trivadislabs.com=(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = tencs1)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = TENCS1.trivadislabs.com))(UR=A))
TENCS2.trivadislabs.com=(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = tencs2)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = TENCS2.trivadislabs.com))(UR=A))
EOF

cat << EOF > /u00/app/oracle/network/admin/sqlnet.ora
# Dead Connection Detection
# interval in minutes for a probe to verify that connections are active
SQLNET.EXPIRE_TIME = 10

# Default database domain
NAMES.DEFAULT_DOMAIN=trivadislabs.com

# Name resolution priority
NAMES.DIRECTORY_PATH=(LDAP, TNSNAMES, EZCONNECT )

##############################################################################
# you need to disable ADR if you need to trace Oracle Net
#DIAG_ADR_ENABLED=OFF
##############################################################################

##############################################################################
# Logging, only apply if ADR is disabled
##############################################################################
LOG_DIRECTORY_CLIENT= /u00/app/oracle/network/log
LOG_FILE_CLIENT=sqlnet_client.log
LOG_DIRECTORY_SERVER= /u00/app/oracle/network/log
LOG_FILE_SERVER=sqlnet_server.log

##############################################################################
# Tracing, only apply if ADR is disabled
##############################################################################
TRACE_LEVEL_CLIENT=OFF
TRACE_DIRECTORY_CLIENT= /u00/app/oracle/network/trc
TRACE_FILE_CLIENT=sqlnet_client.trc
TRACE_LEVEL_SERVER=OFF
TRACE_DIRECTORY_SERVER= /u00/app/oracle/network/trc
TRACE_FILE_SERVER=sqlnet_server.trc

# Security
# restrict access to database via listener to specific nodes
#TCP.VALIDNODE_CHECKING=yes
#TCP.EXCLUDED_NODES=(badclient1,192.168.1.* )
#TCP.INVITED_NODES=(client1,client2,client3,client4,192.168.2.* )

# Oracle Net encryption 
# avaiable encryption algorithms in favored priority (default all )
#SQLNET.ENCRYPTION_TYPES_CLIENT = (AES256, RC4_256, AES192, AES128, RC4_128 )
#SQLNET.ENCRYPTION_TYPES_SERVER = (AES256, RC4_256, AES192, AES128, RC4_128 )
# additional less secure algorithms: 3DES168, 3DES112, RC4_56, DES, RC4_40, DES40
# enable encryption by following parameters
# ENCRYPTION_CLIENT and ENCRYPTION_SERVER can be set to
# REJECTED, ACCEPTED (default), REQUESTED or REQUIRED
#SQLNET.ENCRYPTION_CLIENT = REQUIRED
#SQLNET.ENCRYPTION_SERVER = REQUIRED

# Oracle Net checksumming for data integrity
# avaiable checksumming algorithms in favored priority (default is SHA1, MD5, SHA512, SHA256, SHA384 )
#SQLNET.CRYPTO_CHECKSUM_TYPES_CLIENT = (SHA512, SHA384, SHA256 )
#SQLNET.CRYPTO_CHECKSUM_TYPES_SERVER = (SHA512, SHA384, SHA256 )
# additional less secure algorithms: SHA1, MD5
# enable checksumming by following parameters
# CRYPTO_CHECKSUM_CLIENT and CRYPTO_CHECKSUM_SERVER can be set to
# REJECTED, ACCEPTED (default), REQUESTED or REQUIRED
#SQLNET.CRYPTO_CHECKSUM_CLIENT = REQUIRED
#SQLNET.CRYPTO_CHECKSUM_SERVER = REQUIRED

# Wallet settings
# for secure external password store
# use "mkstore -wrl <wallet_location> -create" to create the wallet
# use "mkstore -wrl <wallet_location> -createCredential <connect_string> <username>"
# to create credentials
#WALLET_LOCATION =
#   (SOURCE =
#     (METHOD = FILE)
#     (METHOD_DATA =
#       (DIRECTORY = /u00/app/oracle/network/admin)
#     )
#    )
#SQLNET.WALLET_OVERRIDE = TRUE
EOF
# - EOF -----------------------------------------------------------------
