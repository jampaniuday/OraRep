#!/bin/bash
# $Id$
#
# =============================================================================
# Simple Database Analysis Report (c) 2003-2004 by IzzySoft (devel@izzysoft.de)
# -----------------------------------------------------------------------------
# This report script creates a HTML document containing an overview on the
# database, whichs SID you either provide at the command line or configure it
# in the block below. But more than this, it not only reads the usual
# performance indicators out of the usual views, but connects values and gives
# you hints about how to use these results.
# I'ld never claim this report tool to be perfect, complete or "state of the
# art". But it's simple to use and very helpful to those not having a license
# to the expensive AddOns available at Oracle. Any hints on errors or bugs as
# well as recommendations for additions are always welcome.
#                                                              Itzchak Rehberg
# -----------------------------------------------------------------------------
# Don't edit this file (at least not if you don't know what it's all about).
# If you look for the configuration options, this is the wrong place - they
# are kept in the file "config" in the same directory as this script resides.
#
version='0.2.9'
if [ -z "$1" ]; then
  SCRIPT=${0##*/}
  echo
  echo ============================================================================
  echo "OraRep v$version                (c) 2003 by Itzchak Rehberg (devel@izzysoft.de)"
  echo ----------------------------------------------------------------------------
  echo This script is intended to generate a HTML report for a given instance. Look
  echo inside the script header for closer details, and check for the configuration
  echo there as well.
  echo ----------------------------------------------------------------------------
  echo "Syntax: ${SCRIPT} <ORACLE_SID> [Options]"
  echo "  Options:"
  echo "     -c <alternative ConfigFile>"
  echo "     -d <StartDir>"
  echo "     -p <Password>"
  echo "     -s <ORACLE_SID/Connection String for Target DB>"
  echo "     -u <username>"
  echo ============================================================================
  echo
  exit 1
fi
# =================================================[ Configuration Section ]===
BINDIR=${0%/*}
PLUGINDIR=$BINDIR/plugins
CONFIG=$BINDIR/config
ARGS=$*

# ------------------------------------------[ process command line options ]---
while [ -n "$1" ] ; do
  case "$1" in
    -s) shift; ORACLE_CONNECT=$1;;
    -u) shift; username=$1;;
    -p) shift; passwd=$1;;
    -d) shift; startdir=$1;;
    -c) shift; CONFIG=$1;;
  esac
  shift
done
. $CONFIG $ARGS
if [ -z "$ORACLE_CONNECT" ]; then
  ORACLE_CONNECT=$ORACLE_SID
fi
if [ -n "$username" ]; then
  user=$username
fi
if [ -n "$passwd" ]; then
  password=$passwd
fi

SQLSET=$TMPDIR/orarep_sqlset_$ORACLE_SID.$$
TMPOUT=$TMPDIR/orarep_tmpout_$ORACLE_SID.$$
TMPADV=$TMPDIR/orarep_tmpadv_$ORACLE_SID.$$

# If called from another script, we may have to change to another directory
# before generating the reports
if [ -n "$startdir" ]; then
  cd $startdir
fi

# --------------------------------[ Get the Oracle version of the DataBase ]---
cat >$SQLSET<<ENDSQL
CONNECT $user/$password@$ORACLE_CONNECT
Set TERMOUT OFF
Set SCAN OFF
Set SERVEROUTPUT On Size 1000000
Set LINESIZE 300
Set TRIMSPOOL On 
Set FEEDBACK OFF
Set Echo Off
Set PAGESIZE 0
SPOOL $TMPOUT
ENDSQL

cat $SQLSET $BINDIR/getver.sql | $ORACLE_HOME/bin/sqlplus -s /NOLOG >/dev/null
DBVER=`cat $TMPOUT`
if [ $DBVER -gt 91 ]; then
  WAITHEAD=$PLUGINDIR/92wait_head.pls
  WAITBODY=$PLUGINDIR/92wait_body.pls
  SPADVHEAD=$PLUGINDIR/92spadv_head.pls
  SPADVBODY=$PLUGINDIR/92spadv_body.pls
else
  WAITHEAD=$PLUGINDIR/81wait_head.pls
  WAITBODY=$PLUGINDIR/81wait_body.pls
  SPADVHEAD=$PLUGINDIR/dummy.pls
  SPADVBODY=$PLUGINDIR/dummy.pls
fi
if [ $MK_ENQ -eq 1 ]; then
  if [ $DBVER -gt 89 ]; then
    ENQHEAD=$PLUGINDIR/90enq_head.pls
    ENQBODY=$PLUGINDIR/90enq_body.pls
  else
    ENQHEAD=$PLUGINDIR/dummy.pls
    ENQBODY=$PLUGINDIR/dummy.pls
  fi
fi
if [ $DBVER -lt 89 ]; then
  ENQHEAD=$PLUGINDIR/81enq_head.pls
fi
# ----------------------------------[ Include optional Features if defined ]---
if [ $MK_RSRC -eq 1 ]; then
  RSRCBODY=$PLUGINDIR/81resource_body.pls
  if [ $DBVER -gt 89 ]; then
    RSRCHEAD=$PLUGINDIR/90resource_head.pls
  else
    RSRCHEAD=$PLUGINDIR/81resource_head.pls
  fi
fi
if [ $MK_TSQUOT -eq 1 ]; then
  TSQUOTHEAD=$PLUGINDIR/tsquot_head.pls
  TSQUOTBODY=$PLUGINDIR/tsquot_body.pls
fi
if [ $MK_DBAPROF -eq 1 ]; then
  PROFHEAD=$PLUGINDIR/prof_head.pls
  PROFBODY=$PLUGINDIR/prof_body.pls
fi
if [ $MK_FILES -eq 1 ]; then
  FILESHEAD=$PLUGINDIR/files_head.pls
  FILESBODY=$PLUGINDIR/files_body.pls
fi
if [ $MK_RBS -eq 1 ]; then
  RBSHEAD=$PLUGINDIR/rbs_head.pls
  RBSBODY=$PLUGINDIR/rbs_body.pls
fi
if [ $MK_MEMVAL -eq 1 ]; then
  MEMVALHEAD=$PLUGINDIR/memval_head.pls
  MEMVALBODY=$PLUGINDIR/memval_body.pls
fi
if [ $MK_POOL -eq 1 ]; then
  POOLHEAD=$PLUGINDIR/pool_head.pls
  POOLBODY=$PLUGINDIR/pool_body.pls
fi
if [ $MK_BUFFRAT -eq 1 ]; then
  BUFFRATHEAD=$PLUGINDIR/buffrat_head.pls
  BUFFRATBODY=$PLUGINDIR/buffrat_body.pls
fi
if [ $MK_FLC -eq 1 ]; then
  FLCHEAD=$PLUGINDIR/freelist_head.pls
  FLCBODY=$PLUGINDIR/freelist_body.pls
fi


cat >$TMPADV<<ENDSQL
  IF MK_ADVICE THEN
    get_dbc_advice();
  END IF;
ENDSQL
cat $SPADVBODY>>$TMPADV
cat >>$TMPADV<<ENDSQL
  IF MK_ADVICE THEN
    print('<HR>');
  END IF;
ENDSQL

cat >$SQLSET<<ENDSQL
CONNECT $user/$password@$ORACLE_CONNECT
Set TERMOUT OFF
Set SCAN OFF
Set SERVEROUTPUT On Size 1000000
Set LINESIZE 300
Set TRIMSPOOL On 
Set FEEDBACK OFF
Set Echo Off
variable CSS VARCHAR2(255);
variable SCRIPTVER VARCHAR2(20);
variable TOP_N_WAITS NUMBER;
variable TOP_N_TABLES NUMBER;
variable MK_RSRC NUMBER;
variable MK_TSQUOT NUMBER;
variable MK_DBAPROF NUMBER;
variable MK_FILES NUMBER;
variable MK_RBS NUMBER;
variable MK_MEMVAL NUMBER;
variable MK_POOL NUMBER;
variable MK_BUFFRAT NUMBER;
variable MK_ENQ NUMBER;
variable MK_FLC NUMBER;
variable TPH_NOLOG NUMBER;
variable WPH_NOLOG NUMBER;
variable WR_BUFF NUMBER;
variable AR_BUFF NUMBER;
variable WR_FILEUSED NUMBER;
variable AR_FILEUSED NUMBER;
BEGIN
  :CSS         := '$CSS';
  :SCRIPTVER   := '$version';
  :TOP_N_WAITS := $TOP_N_WAITS;
  :TOP_N_TABLES := $TOP_N_TABLES;
  :MK_RSRC     := $MK_RSRC;
  :MK_DBAPROF  := $MK_DBAPROF;
  :MK_TSQUOT   := $MK_TSQUOT;
  :MK_FILES    := $MK_FILES;
  :MK_RBS      := $MK_RBS;
  :MK_MEMVAL   := $MK_MEMVAL;
  :MK_POOL     := $MK_POOL;
  :MK_BUFFRAT  := $MK_BUFFRAT;
  :MK_FLC      := $MK_FLC;
  :MK_ENQ      := $MK_ENQ;
  :TPH_NOLOG   := $TPH_NOLOG;
  :WPH_NOLOG   := $WPH_NOLOG;
  :WR_BUFF     := $WR_BUFF;
  :AR_BUFF     := $AR_BUFF;
  :WR_FILEUSED := $WR_FILEUSED;
  :AR_FILEUSED := $AR_FILEUSED;
END;
/
SPOOL $REPDIR/${ORACLE_SID}.html
ENDSQL

# ====================================================[ Script starts here ]===
#cat $SQLSET $BINDIR/rephead.pls $PLUGINDIR/formatting.pls $PLUGINDIR/wtevt_head.pls $WAITHEAD $ENQHEAD $SPADVHEAD $RSRCHEAD $PROFHEAD $TSQUOTHEAD $FILESHEAD $RBSHEAD $MEMVALHEAD $POOLHEAD $BUFFRATHEAD $FLCHEAD $BINDIR/repopen.pls $RSRCBODY $PROFBODY $TSQUOTBODY $FILESBODY $RBSBODY $MEMVALBODY $POOLBODY $TMPADV $BINDIR/repmiddle.pls $BUFFRATBODY $FLCBODY $WAITBODY $ENQBODY $BINDIR/repclose.pls >rep.out
cat $SQLSET $BINDIR/rephead.pls $PLUGINDIR/formatting.pls $PLUGINDIR/wtevt_head.pls $WAITHEAD $ENQHEAD $SPADVHEAD $RSRCHEAD $PROFHEAD $TSQUOTHEAD $FILESHEAD $RBSHEAD $MEMVALHEAD $POOLHEAD $BUFFRATHEAD $FLCHEAD $BINDIR/repopen.pls $RSRCBODY $PROFBODY $TSQUOTBODY $FILESBODY $RBSBODY $MEMVALBODY $POOLBODY $TMPADV $BINDIR/repmiddle.pls $BUFFRATBODY $FLCBODY $WAITBODY $ENQBODY $BINDIR/repclose.pls | $ORACLE_HOME/bin/sqlplus -s /NOLOG
rm -f $SQLSET $TMPOUT $TMPADV
