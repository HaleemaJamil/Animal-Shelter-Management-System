<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminHome.aspx.cs" Inherits="WebApplication.AdminHome" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Home</title>
	<link rel="stylesheet" type="text/css" href="SignupPage.css" />
</head>

<body>
    <form id="form1" runat="server">
        <div class="topnav">
		<a href="HomeDummy.aspx">Home</a>
		<a href="LoginPage.aspx">User Login</a>
		<a href="Signup_page.aspx">User SignUp</a>
		</div>
		<div>
			<asp:Image ID="Image2"  Width="100%" Position="relative" src="WebsiteHeader.jpg"  runat="server" />
		</div>
		 <asp:Button ID="ShowMemberBtn" CssClass="Button1" Text="DisplayMembers" OnClick="ShowMembers" runat="server" />
		<div id="MembersDiv" runat="server" style="display:none;">	
		<asp:GridView id="MembersList" AutoGenerateColumns="false" runat="server" style="border:inset 5px; padding: 10px 10px 10px 10px;">
				<Columns>
					<asp:BoundField DataField="UserId" HeaderText="UserId" />
					<asp:BoundField DataField="MemberID" HeaderText="MemberID" />
					<asp:BoundField DataField="UserName" HeaderText="UserName" />
					<asp:BoundField DataField="Email" HeaderText="Email" />
					<asp:BoundField DataField="DOB" HeaderText="Date Of Birth" />
					<asp:ButtonField ButtonType="Button" HeaderText="Blacklist" Text="Blacklist" CausesValidation="false" CommandName="Black" />
					<asp:ButtonField ButtonType="Button" HeaderText="Un_Blacklist" Text="Remove From Blacklist" CausesValidation="false" CommandName="UnBlack" />
				</Columns>
			</asp:GridView>
			<asp:Button ID="HideMemberBtn" CssClass="Button1" Text="Close" OnClick="HideMembers" runat="server" />
		</div>
		<asp:Label ID="BLMsg" runat="server" Text="" ForeColor="Black" Font-Size="15" ></asp:Label>
    </form>
</body>
</html>
