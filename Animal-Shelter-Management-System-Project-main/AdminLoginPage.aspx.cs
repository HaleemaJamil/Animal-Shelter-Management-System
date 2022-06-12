using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class AdminLoginPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void AdminLogin(object sender, EventArgs e)
        {
            if(AdminNameTxt.Text!="admin"&&AdminPasswordTxt.Text!="admin")
            {
                ErrorMsgLabel.ForeColor = System.Drawing.Color.Red;
                ErrorMsgLabel.Text = "<br />Invalid Name or Password";
            }
            else
            {
                Response.Redirect("AdminHome.aspx");
            }
        }
    }
}