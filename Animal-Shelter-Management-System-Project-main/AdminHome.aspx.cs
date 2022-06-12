using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
namespace WebApplication
{
    public partial class AdminHome : System.Web.UI.Page
    {
        BAL.UpdateBlacklist Ubl = new BAL.UpdateBlacklist();
        SqlConnection conn = null;
        string connectionStr = "Server= localhost; Database= AnimalShelter; Integrated Security=SSPI;";
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void ShowMembers(object sender, EventArgs e)
        {
            fillMembersList();
            MembersDiv.Style["display"] = "block";
        }
        protected void HideMembers(object sender, EventArgs e)
        {
            MembersDiv.Style["display"] = "none";
        }
        protected void fillMembersList()
        {
            using (conn = new SqlConnection(connectionStr))
            {
                string query = "select [User].UserId, MemberID, UserName, [Email], DOB  from [User] Join Member on[User].UserId = [Member].UserId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                    DataTable dt = new DataTable();
                    dt.Load(dr);
                    MembersList.DataSource = dt;
                    MembersList.DataBind();
                    conn.Close();
                }
            }
        }
        void MembersList_RowCommand(Object sender, GridViewCommandEventArgs e)
        {
            string msg="";
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow selectedRow = MembersList.Rows[index];
            TableCell celll = selectedRow.Cells[0];
            int uid = Convert.ToInt32(celll.Text);
            Console.WriteLine(uid);
            Ubl.uid = uid;
            if (e.CommandName.Equals("Black"))
            {
                Ubl.operation = 0;
            }
            else if(e.CommandName.Equals("UnBlack"))
            {
                Ubl.operation = 1;
            }
            Ubl.reason = "Admin ki marzi";
            using (conn = new SqlConnection(connectionStr))
            {
                SqlCommand cmd = new SqlCommand("UpdateBlacklist");
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@uid", SqlDbType.Int).Value = Ubl.uid;
                cmd.Parameters.AddWithValue("@operation", SqlDbType.Int).Value = Ubl.operation;
                cmd.Parameters.AddWithValue("@reason", SqlDbType.VarChar).Value = Ubl.reason;
                cmd.Parameters.Add("@MSG", SqlDbType.VarChar, 100);
                cmd.Parameters["@MSG"].Direction = ParameterDirection.Output;
                try
                {
                    int i = cmd.ExecuteNonQuery();
                    msg = Convert.ToString(cmd.Parameters["@MSG"].Value);
                }
                catch (Exception ex)
                {
                    ex.GetType();
                    msg = ex.ToString();
                }
                finally
                {
                    conn.Close();
                }
                BLMsg.Text = msg;
            }
        }
    }
}