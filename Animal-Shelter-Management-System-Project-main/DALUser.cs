using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
namespace WebApplication
{
    namespace DAL
    {
        public class DALUser
        {
            SqlConnection conn = null;
            string connectionStr = "Server= localhost; Database= AnimalShelter; Integrated Security=SSPI;";
            public int PostDal(BAL.UPost U, ref string res)
            {
                int id = 0;
                using (conn = new SqlConnection(connectionStr))
                {
                    conn.Open();
                    string msg = "";
                    SqlCommand cmd = new SqlCommand("MakePost", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@uid", SqlDbType.Int).Value = U.uid;
                    cmd.Parameters.AddWithValue("@PostContent", SqlDbType.VarChar).Value = U.PostContent;

                    cmd.Parameters.Add("@msg", SqlDbType.VarChar,100);
                    cmd.Parameters["@msg"].Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("@id", SqlDbType.Int);
                    cmd.Parameters["@id"].Direction = ParameterDirection.Output;
                    try
                    {
                        int i = cmd.ExecuteNonQuery();
                        msg = Convert.ToString(cmd.Parameters["@msg"].Value);
                        id = Convert.ToInt32(cmd.Parameters["@id"].Value);
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
                    res = msg;
                    return id;
                }
            }
            public string getPostDiv()
            {
                SqlCommand com;
                string innHtml = "";
                using (conn = new SqlConnection(connectionStr))
                {
                    conn.Open();
                    string str = "SELECT UserID,PostID,PostDate,Content FROM [Post] ORDER BY PostDate Desc, PostID Desc; SELECT UserID,PostID,CommentID,CommentDate,Content FROM Comment ORDER BY CommentDate DESC, PostID Desc, CommentID Desc";
                    com = new SqlCommand(str, conn);
                    SqlDataAdapter da = new SqlDataAdapter(com);
                    DataSet ds = new DataSet();
                    da.Fill(ds);    // filling data set with output of select
                    conn.Close();
                    int noOfPosts = ds.Tables[0].Rows.Count;
                    for(int i=0;i<noOfPosts;i++)
                    {
                        innHtml += ("<br /> <div id=\"pst" + (i + 1).ToString() + "\" class=\"postDiv\" runat=\"server\"> <asp:Label ID=\"pstLbl" + (i + 1).ToString() + "\" runat=\"server\" >" +
                             ds.Tables[0].Rows[i]["Content"].ToString() + "</asp:Label> </div>");
                    }
                }
                return innHtml;
            }
        }
    }
}