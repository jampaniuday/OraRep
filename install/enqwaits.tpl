<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML><HEAD>
 <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-15">
 <LINK REL='stylesheet' TYPE='text/css' HREF='../{css}'>
 <TITLE>OraHelp: Enqueue Waits</TITLE>
</HEAD><BODY>

<TABLE WIDTH="95%" ALIGN="center"><TR><TD CLASS="text">
 <P>Below you find a description on selected enqueue types:</P>
 <TABLE STYLE="border:0">
  <TR><TD CLASS="smallname">BL</TD>
      <TD CLASS="text"><B>Buffer Cache Managment</B></TD></TR>
  <TR><TD CLASS="smallname">CF</TD>
      <TD CLASS="text"><B>Control file schema</B> global enqueue</TD></TR>
  <TR><TD CLASS="smallname">CI</TD>
      <TD CLASS="text"><B>Cross Instance</B> call invocation</TD></TR>
  <TR><TD CLASS="smallname">CU</TD>
      <TD CLASS="text"><B>Cursor Bind</B></TD></TR>
  <TR><TD CLASS="smallname">DF</TD>
      <TD CLASS="text"><B>Datafile</B></TD></TR>
  <TR><TD CLASS="smallname">DL</TD>
      <TD CLASS="text"><B>Direct Loader</B> index creation</TD></TR>
  <TR><TD CLASS="smallname">DR</TD>
      <TD CLASS="text"><B>Distributed Recovery</B></TD></TR>
  <TR><TD CLASS="smallname">DX</TD>
      <TD CLASS="text"><B>Distributed Transactions</B></TD></TR>
  <TR><TD CLASS="smallname">IR</TD>
      <TD CLASS="text"><B>Instance Recovery</B></TD></TR>
  <TR><TD CLASS="smallname">HW</TD>
      <TD CLASS="text"><B>Space Management</B> operations on a specific
          segment. This enqueue is used to serialize the allocation of space
	  above the high water mark of a segment:<BR>
	  <CODE>V$SESSION_WAIT.P2 / V$LOCK.ID1</CODE> is the tablespace number<BR>
	  <CODE>V$SESSION_WAIT.P2 / V$LOCK.ID2</CODE> is the relative dba segment
	  header of the object for which space is being allocated<BR>
	  If this is a point of contention for an object, then manual allocation
	  of extents solves the problem.</TD></TR>
  <TR><TD CLASS="smallname">LA..LP</TD>
      <TD CLASS="text"><B>Library Cache</B> Lock</TD></TR>
  <TR><TD CLASS="smallname">MD</TD>
      <TD CLASS="text"><B>Materialized Views:</B> enqueue for change data
          capture materialized view log (gotten internally for DDL on a
	  snapshot log); id1=object# of the snapshot log.</TD></TR>
  <TR><TD CLASS="smallname">NA..NZ</TD>
      <TD CLASS="text"><B>Library Cache</B> Pin</TD></TR>
  <TR><TD CLASS="smallname">RT</TD>
      <TD CLASS="text"><B>Redo Log</B></TD></TR>
  <TR><TD CLASS="smallname">SQ</TD>
      <TD CLASS="text"><B>SeQuences</B> not being cached, having a to small
          cache size or being aged out of the shared pool. Consider pinning
	  sequences or increasing the shared_pool_size.</TD></TR>
  <TR><TD CLASS="smallname">ST</TD>
      <TD CLASS="text"><B>Space management locks</B> could be caused by using
          permanent tablespaces for sorting (rather than temporary), or by
	  dynamic allocation resulting from inadequate storage clauses (only
	  with Dictionary Managed TableSpaces). In the latter case, using
	  locally-managed tablespaces may help avoiding this problem. If this
	  is not an option for some reason, you may at least change the next
	  extent sizes of the growing objects to be large enough to avoid
	  constant space allocation. To determine which segments are growing
	  constantly, monitor the <CODE>EXTENTS</CODE> column of the
	  <CODE>DBA_SEGMENTS</CODE> view for all <CODE>SEGMENT_NAME</CODE>s
	  over time to identify which segments are growing and how quickly.
	  Also, you may pre-allocate space in the regarding segment.<BR>
	  For the first case, the solution is quite obvious: check whether
	  the temporary tablespace uses <CODE>TEMPFILES</CODE> and whether
	  the temporary tablespace for the users is set correctly (at least
	  up to Oracle 8i, if you didn't specify it explicitly it was set
	  to <CODE>SYSTEM</CODE> !).</TD></TR>
  <TR><TD CLASS="smallname">TA</TD>
      <TD CLASS="text"><B>Transaction Recovery</B></TD></TR>
  <TR><TD CLASS="smallname">TM</TD>
      <TD CLASS="text"><B>Table locks</B> point to the possibility of e.g.
          foreign key constraints not being indexed</TD></TR>
  <TR><TD CLASS="smallname">TS</TD>
      <TD CLASS="text"><B>Temporary Segment</B></TD></TR>
  <TR><TD CLASS="smallname">TX</TD>
      <TD CLASS="text"><B>Transaction locks</B> indicate multiple users try
          modifying the same row of a table (row-level-lock) or a row that is
	  covered by the same bitmap index fragment, or a session is waiting
	  for an ITL (interested transaction list) slot in a block, but one or
	  more sessions have rows locked in the same block, and there is no
	  free ITL slot in the block. In the first case, the first user has to
	  <CODE>COMMIT</CODE> or <CODE>ROLLBACK</CODE> to solve the problem. In
	  the second case, increasing the number of ITLs available is the
	  answer - which can be done by changing either the
	  <A HREF="initrans.html"><CODE>INITRANS</CODE> or <CODE>MAXTRANS</CODE></A>
	  for the table in question.</TD></TR>
  <TR><TD CLASS="smallname">US</TD>
      <TD CLASS="text"><B>Undo Segment</B>, serialization</TD></TR>
 </TABLE>
 <P>For more information on enqueue waits, see <A HREF="enqueue.html">Enqueues</A>.</P>
</TD></TR></TABLE>

<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">//<!--
  if ( opener != null && opener.version != '' && opener.version != null )
    version = 'v'+opener.version;
  else version = '';
  document.write('<DIV ALIGN="center" STYLE="margin-top:3px"><IMG SRC="..\/w3c.jpg" ALT="w3c" WIDTH="14" HEIGHT="14" ALIGN="middle" STYLE="margin-right:3px"><SPAN CLASS="small" ALIGN="middle">OraRep '+version+' &copy; {copy} by Itzchak Rehberg &amp; <A STYLE="text-decoration:none" HREF="http://www.izzysoft.de/" TARGET="_blank">IzzySoft<\/A><\/SPAN><IMG SRC="..\/islogo.gif" ALT="IzzySoft" WIDTH="14" HEIGHT="14" ALIGN="middle" STYLE="margin-left:3px"><\/DIV>');
//--></SCRIPT>

</BODY></HTML>
