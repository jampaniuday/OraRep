<HTML><HEAD>
 <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-15"/>
 <LINK REL='stylesheet' TYPE='text/css' HREF='../{css}'/>
 <TITLE>OraHelp: Buffer Busy Waits</TITLE>
</HEAD><BODY>

<TABLE WIDTH="95%" ALIGN="center"><TR><TD>
 <H3>What are <CODE>buffer busy waits</CODE>?</H3>
 <P>If two processes try (almost) simultaneously the same block and the block
  is not resident in the <CODE>buffer cache</CODE>, one process will allocate
  a buffer in the buffer cache, lock it and read the block into the buffer.
  The other process is locked until the block is read. This wait is refered to
  as <CODE>buffer busy wait</CODE>.</P>
 <P>The type of buffer that causes the wait can be queried with
  <CODE>v$waitstat</CODE>, which lists the waits per buffer type for
  <CODE>buffer busy waits</CODE> only.</P>
 <H3>What types of buffers is waited for?</H3>
 <TABLE ALIGN="center" BORDER="1">
  <TR><TH>Block</TH><TH>Description</TH></TR>
  <TR><TD>segment header</TD><TD>The problem is probably a freelist contention.</TD></TR>
  <TR><TD>data block</TD><TD>Increasing the size of the <CODE>database buffer
      cache</CODE> can help to reduce these waits.</TD></TR>
  <TR><TD>undo header</TD><TD ROWSPAN="2">If you don't use Undo TableSpaces,
      you probably have too few rollback segments.</TD></TR>
  <TR><TD>undo block</TD></TR>
 </TABLE>

</TD></TR></TABLE>

</BODY></HTML>