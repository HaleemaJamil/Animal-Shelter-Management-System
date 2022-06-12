using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication.DAL_Signup;

namespace WebApplication
{
    public partial class Signup_page : System.Web.UI.Page
    {
        BAL.URegister R = new BAL.URegister();
        DALSignup dalSignup = new DALSignup();
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void SubmitClick(object sender, EventArgs e)
        {
            MsgLabel.ForeColor = System.Drawing.Color.Red;
            string errorList = "";
            int errorCount = 0;
            if(NameTxt.Text.Length==0)
            {
                errorList += "Username is required." + "<br />";
                errorCount++;
            }
            if(EmailTxt.Text.Length==0)
            {
                errorCount++;
                errorList += "Email is required." + "<br />";
            }
            else if(validateEmail(EmailTxt.Text)==false)
            {
                errorCount++;
                errorList += "Enter a valid Email and avoid an organization's email." + "<br />";
            }
            if(PassTxt.Text.Length==0)
            {
                errorCount++;
                errorList += "Password is required. " + "<br />";
            }
            else if(validatePassword(PassTxt.Text)==false)
            {
                errorCount++;
                errorList += "Password must be b/w 8-20 characters, Have at least: 1 Uppercase, 1 Lowercase, 1 Special Character and 1 Number. " + "<br />";
            }
            if(rdVet.Checked==true)
            {
                if(DegTxt.Text.Length==0)
                {
                    errorCount++;
                    errorList += "Degree is required." + "<br />";
                }
                if(ExpTxt.Text.Length==0)
                {
                    errorCount++;
                    errorList += "Experience in years is required." + "<br />";
                }
                else
                {
                    int xp = 0;
                    if(int.TryParse(ExpTxt.Text,out xp)==true)//is number valid
                    {
                        if(xp<0)
                        {
                            errorCount++;
                            errorList += "Experience in years must be a positive number or 0." + "<br />";
                        }
                    }
                    else
                    {
                        errorCount++;
                        errorList += "Experience in years must be a positive number or 0. " + "<br />";
                    }
                }
            }
            if (errorCount == 0)
            {
                
                var res=GetFromDAL();
                errorList = res.Item1;
                int id1 = res.Item3, id2 = res.Item4, utype = res.Item2;

                if (errorList == "Signup Success")
                {
                    errorList = "Signup Success ! ! !" + "<br />" + "Your Credentials: UserId: " + id1.ToString() + "<br />";
                    if (utype == 0)
                        errorList += "MemberId: ";
                    else
                        errorList += "EmployeeId: ";
                    errorList += id2.ToString();
                   /* string script = "window.onload = function(){ alert('";
                    script += errorList;
                    script += "')};";
                    ClientScript.RegisterStartupScript(this.GetType(), "SuccessMessage", script, true);*/
                    MsgLabel.ForeColor = System.Drawing.Color.DarkBlue;
                }
                else
                    errorCount = 1;
            }
            else
                errorList = "Fix " + errorCount.ToString() + " problems:" + "<br /><br />" + errorList;
            MsgLabel.Text = errorList;
            MsgLabel.Font.Bold = false;
            MsgLabel.Font.Size = 14;
        }
        public static bool validateEmail(string email)
        {
            string regex = "^(([^<>()[\\]\\\\.,;:\\s@\"]+(\\.[^<>()[\\]\\\\.,;:\\s@\\\"]+)*)|(\\\".+\\\"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$";
            if(Regex.IsMatch(email,regex))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        public static bool validatePassword(string password)
        {
            string regex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\\s).{8,20}$";
            if (Regex.IsMatch(password, regex))
                return true;
            else
                return false;
        }
        protected Tuple<string, int, int, int> GetFromDAL()
        {
            string msg = "";
            int id1 = 0, id2 = 0,utype=-1;
            R.degree = "";
            R.DOG = "";
            R.exp = 0;
            R.name = NameTxt.Text;
            R.password = PassTxt.Text;
            R.email = EmailTxt.Text;
            R.DOB = DOB.SelectedDate.ToShortDateString();
            if (rdMale.Checked)
                R.gender = "M";
            else
                R.gender = "F";
            if (rdMember.Checked)
                R.UserType = 0;
            else if (rdEmployee.Checked)
                R.UserType = 1;
            else if(rdVet.Checked)
            {
                R.UserType = 2;
                R.DOG = DOG.SelectedDate.ToShortDateString();
                R.degree = DegTxt.Text;
                int xp = 0;
                int.TryParse(ExpTxt.Text, out xp);
                R.exp = xp;
            }
            Tuple<string, int,int, int> ret = new Tuple<string, int, int, int>(msg,utype,id1,id2);
            ret = dalSignup.Signup(R);
            NameTxt.Text = "";
            EmailTxt.Text = "";
            PassTxt.Text = "";
            rdMale.Checked = true;
            DegTxt.Text = "";
            ExpTxt.Text = "";
            rdMember.Checked = true;
            return ret;
        }

        protected void DOB_SelectionChanged(object sender, EventArgs e)
        {

        }
    }
}
