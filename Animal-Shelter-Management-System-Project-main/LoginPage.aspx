<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginPage.aspx.cs" Inherits="WebApplication.LoginPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>Login</title>
	<link rel="stylesheet" type="text/css" href="SignupPage.css" />
</head>
<body>
	<form id="form2" runat="server">
		 <div class="topnav">
		<a href="HomeDummy.aspx">Home</a>
		<a href="LoginPage.aspx">User Login</a>
		<a href="Signup_page.aspx">User SignUp</a>
		</div>
		<div>
			<asp:Image ID="Image2"  Width="100%" Position="relative" src="WebsiteHeader.jpg"  runat="server" />
		</div>
		<div>
			<br /><br />
			<label>UserId </label><asp:TextBox ID="IdTxt" TextMode="Number" runat="server"></asp:TextBox>
			<br /><br />
			<label>Password </label>&nbsp<asp:TextBox ID="PasswordTxt" TextMode="password" runat="server"></asp:TextBox>
			<br /><br />
			<asp:Button ID="LoginBtn" CssClass="Button1" Text="Login" OnClick="LoginClick" runat="server" />
			<br /><br />
			<asp:Label ID="ErrorMsgLabel" runat="server" Text=""></asp:Label>
		</div>
	</form>
</body>
	<script type="text/javascript" src="LoginPage.js"></script>
</html>
