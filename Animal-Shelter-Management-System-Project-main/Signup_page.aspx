<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Signup_page.aspx.cs" Inherits="WebApplication.Signup_page" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SignUp</title>
    <link rel="stylesheet" type="text/css" href="SignupPage.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="topnav">
        <a href="HomeDummy.aspx">Home</a>
        <a href="LoginPage.aspx">Login</a>
        </div>
        <div>
            <asp:Image ID="Image2"  Width="100%" Position="relative" src="WebsiteHeader.jpg"  runat="server" />
        </div>
        <div>
<%--        <div class="divCenter" style="width:400px;height:350px;line-height:350px">
        </div>--%>
        <div style="width:70%; margin:0 auto; ">
            <asp:HyperLink ID="LoginLink" runat="server" Text="Have an Account ? Visit Login Page" NavigateUrl="~/LoginPage.aspx"></asp:HyperLink>
            <br />
            <label>Name </label>
            <asp:TextBox ID="NameTxt" runat="server"></asp:TextBox>
            <br /><br />
            <label>Email </label>
            <asp:TextBox ID="EmailTxt" runat="server"></asp:TextBox>
            <br /><br />
            <label>Password </label>
            <asp:TextBox ID="PassTxt" TextMode="password" runat="server"></asp:TextBox>
            <br /><br />
            <asp:Calendar ID = "DOB" SelectionMode="Day" OnSelectionChanged="DOB_SelectionChanged" Caption="Date of Birth" runat = "server">
            </asp:Calendar>
            <br />
            <label>Gender:</label>
            <small>Male</small> <asp:RadioButton ID="rdMale" cssclass= "RadioButton1" Checked="true" GroupName="Gender" name="gender" runat="server" />
            <small>Female</small> <asp:RadioButton ID="rdFemale" cssclass= "RadioButton1" GroupName="Gender" name="gender" runat="server" />
             <br /><br />
           <label>UserType:</label>
            <small>Member</small><asp:RadioButton ID="rdMember" value="0" GroupName="UserType" Checked="true" onclick="Show_Employee_Det();" runat="server" />
            <small>Employee</small><asp:RadioButton ID="rdEmployee" value ="1" GroupName="UserType" onclick="Show_Employee_Det();"  runat="server" />
            <small>Vet</small> <asp:RadioButton ID="rdVet" value ="2" GroupName="UserType" onclick="Show_Employee_Det();" runat="server" />
             <br /><br />
        </div>
        <div id="DivVet" style="display: none; width:70%; margin:0 auto;">
            <label>Degree </label>
            <asp:TextBox ID="DegTxt" runat="server"></asp:TextBox>
            <br /><br />
            <label>Experience in Years </label>
            <asp:TextBox ID="ExpTxt" runat="server"></asp:TextBox>
            <br /><br />
            <asp:Calendar ID = "DOG" SelectionMode="Day" Caption="Graduated On" runat = "server">
            </asp:Calendar>
            <br /><br />
        </div>
        <div style="width:70%; margin:0 auto;">
            <asp:Button ID="btn1" cssClass="Button1" Text="Create Account" OnClick="SubmitClick" OnClientClick="ClientSubmitClick();" runat="server" />
            <br /><br />
            <asp:Label ID="MsgLabel" runat="server"></asp:Label>
        </div>
         </div>
    </form>
</body>
<script type="text/javascript" src="SignupPage.js"></script>
</html>

