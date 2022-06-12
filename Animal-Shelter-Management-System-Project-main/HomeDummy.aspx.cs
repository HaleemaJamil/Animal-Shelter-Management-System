using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication
{
    public partial class HomeDummy : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //Response.Write(Request.Form["ErrorMsgLabel"]);
            LoginLabel.Text = Request.QueryString["ErrorMsgLabel"];
            
        }
    }
}