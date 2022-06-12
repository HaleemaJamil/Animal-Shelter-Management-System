using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication 
{

    public partial class LoginPage : System.Web.UI.Page
    {
        WebApplication.BAL.ULogin L = new WebApplication.BAL.ULogin();
        WebApplication.DAL_Login.DALLogin dalLogin = new WebApplication.DAL_Login.DALLogin();
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void LoginClick(object sender, EventArgs e)
        {
            int userType = -2;
            int v = Convert.ToInt32(IdTxt.Text);
            if (IdTxt.Text.Length == 0 || PasswordTxt.Text.Length == 0)
            {
                ErrorMsgLabel.Text = "All fields are required.";
            }
            else
            {
                userType = GetFromDAL();
                switch (userType)
                {
                    case -1: ErrorMsgLabel.Text = "Invalid Username and Password."; ErrorMsgLabel.ForeColor = System.Drawing.Color.Red; break;
                    case 0:  ErrorMsgLabel.Text = "Logged in as Member."; ErrorMsgLabel.ForeColor = System.Drawing.Color.DarkBlue; break;
                    case 1: ErrorMsgLabel.Text = "Logged in as Employee."; ErrorMsgLabel.ForeColor = System.Drawing.Color.DarkBlue; break;
                    case 2: ErrorMsgLabel.Text = "Logged in as Vet."; ErrorMsgLabel.ForeColor = System.Drawing.Color.DarkBlue; break;
                }
            }
            ErrorMsgLabel.Font.Bold = false;
            ErrorMsgLabel.Font.Size = 14;
            if (userType != -1)
            {
                Session["UserId"] = v;
                Response.Redirect("MemberHome.aspx");
                //Response.Redirect("HomeDummy.aspx?ErrorMsgLabel=" + ErrorMsgLabel.Text);
            }
        }
        protected int GetFromDAL()
        {
            int userType = -1;   // @status from stored procedure returns usertype on login, -1 on fail
            L.uid = Convert.ToInt32(IdTxt.Text);
            L.password = PasswordTxt.Text;
            userType = dalLogin.Login(L);
            IdTxt.Text = "";
            PasswordTxt.Text = "";
            return userType;
        }
    }
}