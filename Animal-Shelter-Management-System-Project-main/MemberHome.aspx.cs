using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using  WebApplication.DAL;
namespace WebApplication
{
    public partial class MemberHome : System.Web.UI.Page
    {
        string conStr = "Server= localhost; Database= AnimalShelter; Integrated Security=SSPI;";
        string str;
        SqlCommand com;
        BAL.UBilling UBill = new BAL.UBilling();
        BAL.UPost uPost=new BAL.UPost();
        DALMember DM = new DALMember();
        DALUser DU = new DALUser();
        protected void Page_Load(object sender, EventArgs e)
        { 
            SqlConnection conn = new SqlConnection(conStr);
            conn.Open();
            str = "select * from [User] where UserId='" + Session["UserId"] + "'"+ "; select [MemberID] from [Member] where UserId='" + Session["UserId"] + "'";
            com = new SqlCommand(str, conn);
            SqlDataAdapter da = new SqlDataAdapter(com);
            DataSet ds = new DataSet();
            da.Fill(ds);    // filling data set with output of select
            lbl_UserId.Text = ds.Tables[0].Rows[0]["UserId"].ToString();
            lbl_MemId.Text= ds.Tables[1].Rows[0]["MemberID"].ToString();
            lbl_UserType.Text = ds.Tables[0].Rows[0]["UserType"].ToString();
            lbl_UserName.Text = ds.Tables[0].Rows[0]["UserName"].ToString();
            lbl_Password.Text = ds.Tables[0].Rows[0]["Password"].ToString();
            lbl_DOB.Text = ds.Tables[0].Rows[0]["DOB"].ToString();
            lbl_Gender.Text = ds.Tables[0].Rows[0]["Gender"].ToString();
            lbl_Email.Text = ds.Tables[0].Rows[0]["Email"].ToString();
            conn.Close();
            ds.Dispose();
            da.Dispose();
            com.Dispose();
            string PostHtml=DU.getPostDiv();
            PostContainerDiv.InnerHtml = PostHtml;
        }
        protected void addBilling(object sender, EventArgs e)
        {
            AddBillingDiv.Style["display"] = "block";
        }
        protected void billingCancel(object sender, EventArgs e)
        {
            CardNoTxt.Text = "";
            CvcTxt.Text = "";
            CardExpiryTxt.SelectedDate = DateTime.UtcNow;
            AddBillingDiv.Style["display"] = "none";
        }
        protected void submitBilling(object sender, EventArgs e)
        {
            string regex = "^\\d+$";
            string errorList = "";
            int errorCount = 0;
            BillingMsg.ForeColor = System.Drawing.Color.Red;
            if (CardNoTxt.Text.Length != 16 || !Regex.IsMatch(CardNoTxt.Text, regex))
            {
                errorList += "Invalid Card Number. Enter correct Card# 16 digit numbers only" + "<br />";
                errorCount++;
            }
            if(CvcTxt.Text.Length!=3||!Regex.IsMatch(CvcTxt.Text,regex))
            {
                errorList += "Correct 3 digit CVC required" + "<br />";
                errorCount++;
            }
            if(errorCount>0)
                errorList = "<br />Fix " + errorCount.ToString() + " problems:" + "<br /><br />" + errorList;
            else
            {
                string msg = getBillingFromDAL();
                errorList = "<br />" + msg  + "<br />";
                if(msg=="Billing Added Successfully")
                    BillingMsg.ForeColor = System.Drawing.Color.DarkBlue;
            }
            CardNoTxt.Text = "";
            CvcTxt.Text = "";
            CardExpiryTxt.SelectedDate = DateTime.UtcNow;
            BillingMsg.Text = errorList;
            BillingMsg.Font.Bold = false;
            BillingMsg.Font.Size = 14;
        }
        protected string getBillingFromDAL()
        {
            UBill.mid = Convert.ToInt32(lbl_MemId.Text);
            UBill.cardNo = CardNoTxt.Text;
            UBill.cvc = CvcTxt.Text;
            UBill.expiry = CardExpiryTxt.SelectedDate.ToShortDateString();
            return DM.BillingDAL(UBill);
            
        }
        protected void ShowPostDiv(object sender, EventArgs e)
        {
            CreatePostDiv.Style["display"] = "block";
        }
        protected void HidePostDiv(object sender, EventArgs e)
        {
            CreatePostDiv.Style["display"] = "none";
        }
        protected void submitPost(object sender, EventArgs e)
        {
            PostMsg.ForeColor = System.Drawing.Color.Red;
            string errorList = "", msg="";
            int errorCount = 0, id=0;
            if (PostTxt.Text.Length == 0 || PostTxt.Text.Length > 500)
            {
                errorList += "Post must be between 1 and 500 characters" + "<br />";
                errorCount++;
            }
            else
            {
                id = PostToDal(ref msg);
                errorList = "<br />" + msg + "<br />";
                if (id>0)
                {
                    
                    PostMsg.ForeColor = System.Drawing.Color.DarkBlue;
                }
            }
            PostMsg.Text = errorList;
            PostMsg.Font.Bold = false;
            PostMsg.Font.Size = 14;
        }
        protected int PostToDal(ref string res)
        {
            uPost.uid = Convert.ToInt32(lbl_UserId.Text);
            uPost.PostContent = PostTxt.Text;
            int resu = DU.PostDal(uPost, ref res);
            return resu;
        }
    }
}
