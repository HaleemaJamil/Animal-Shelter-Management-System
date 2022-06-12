<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MemberHome.aspx.cs" Inherits="WebApplication.MemberHome" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Member</title>
    <link rel="stylesheet" type="text/css" href="SignupPage.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="topnav">
        <a href="MemberHome.aspx">Home</a>
        <a href="LoginPage.aspx">Logout</a>
        </div>
        <div>
            <asp:Image ID="Image2"  Width="100%" Position="relative" src="WebsiteHeader.jpg"  runat="server" />
        </div>
     <div id="MemberInfo" style="display: none;">
        <asp:Label ID="lbl_UserId" runat="server"></asp:Label>
         <asp:Label ID="lbl_MemId" runat="server"></asp:Label>
         <asp:Label ID="lbl_UserType" runat="server"></asp:Label>
         <asp:Label ID="lbl_UserName" runat="server"></asp:Label>
          <asp:Label ID="lbl_Password" runat="server"></asp:Label>
          <asp:Label ID="lbl_DOB" runat="server"></asp:Label>
          <asp:Label ID="lbl_Gender" runat="server"></asp:Label>
          <asp:Label ID="lbl_Email" runat="server"></asp:Label>
     </div>

    <div id = "boxes">
        <div id = "leftbox">
            <asp:Button ID="BillingBtn" CssClass="Button1" Text="Add Billing" OnClick="addBilling" runat="server" />
            <div id="AddBillingDiv" runat="server" style="display: none;">
                <asp:TextBox ID="CardNoTxt" runat="server">Card No</asp:TextBox>
                <asp:TextBox ID="CvcTxt" runat="server">CVC</asp:TextBox>
                <asp:Calendar ID = "CardExpiryTxt" SelectionMode="Day" Caption="Expiry" runat = "server">
                </asp:Calendar>
                <asp:Button ID="BillingSubmitBtn" CssClass="Button1" Text="Submit" OnClick="submitBilling" runat="server" />
                <asp:Button ID="BillingCancelBtn" CssClass="Button1" Text="Close" OnClick="billingCancel" runat="server" />
                <asp:Label ID="BillingMsg" runat="server"></asp:Label>
            </div>
        </div> 
              
        <div id = "middlebox">
            <asp:Button ID="CreatePostBtn" CssClass="Button1" Text="Create Post" OnClick="ShowPostDiv" runat="server" />
            <div id="CreatePostDiv" runat="server" style="display: none;">
                <asp:TextBox ID="PostTxt" runat="server" TextMode="MultiLine"></asp:TextBox>
                <asp:Button ID="PostBtn" CssClass="Button1" Text="Create" OnClick="submitPost" runat="server" />
                <asp:Button ID="CancelPostBtn" CssClass="Button1" Text="Close" OnClick="HidePostDiv" runat="server" />
                <asp:Label ID="PostMsg" runat="server"></asp:Label>
            </div>
            <div id="PostContainerDiv" runat="server" style="overflow:auto;">
            </div>
        </div>
              
        <div id = "rightbox">
            <asp:Button ID="Buy" CssClass="Button1" Text="Create Post" runat="server" />
        </div>
    </div>
    </form>
</body>
</html>
