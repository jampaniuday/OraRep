<HTML><HEAD>
 <TITLE>OraRep Help: INI_TRANS / MAX_TRANS</TITLE>
 <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-15"/>
 <LINK REL='stylesheet' TYPE='text/css' HREF='../{css}'/>
</HEAD><BODY>
<TABLE WIDTH="95%" ALIGN="center"><TR><TD CLASS="text">
 <P>Each datablock has a number of transaction entries that are used for row
  locking purposes. Initially, this number is specified by the
  <code>INI_TRANS</code> parameter; the default value (1 for tables, 2 for
  indices) is generally sufficient. However: if a table (or index) is known to
  have many rows for each block with a high possibility of many concurrent
  updates, it is beneficial to set a higher value - which must be done at the
  <code>CREATE TABLE/CREATE INDEX</code> time to have it set for all blocks
  of the object.</P>
 <P>So how do you know whether sone object needs adjustment here? Either your
  planning and design of the database did foresee, or your performance report
  gave you indications: if an object has either many <code>buffer busy get</code>s,
  or is subject to <code>TX enqueue waits</code>, you have found a candidate for
  adjustment.</P>
 <TABLE WIDTH="95%" ALIGN="center" BORDER="1">
   <TR><TD CLASS="td_name" ROWSPAN="2">Recommended values:</TD>
       <TD CLASS="text">[# of CPUs] &lt;= <code>INI_TRANS</code> &lt; 100</TD></TR>
   <TR><TD><code>MAX_TRANS</code> &lt; 100</TD>
   <TR><TD CLASS="td_name">Side-Effects:</TD>
       <TD CLASS="text">If the value for either of these parameters is too high,
           Oracle will use more space for the transaction layer block header
	   and less for the data layer variable header; this can result in more
	   I/O.</TD></TR>
 </TABLE>
 </TD></TR></TABLE>
</BODY></HTML>
