using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using WebApplication;
namespace WebApplication
{
    namespace DAL_Login
    {
        public class DALLogin
        {
            SqlConnection conn = null;
            string connectionStr = "Server= localhost; Database= AnimalShelter; Integrated Security=SSPI;";
            public int Login(BAL.ULogin R)
            {
                using (conn = new SqlConnection(connectionStr))
                {
                    conn.Open();
                    int Stat = -1;
                    SqlCommand cmd = new SqlCommand("UserLogin", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@userid", SqlDbType.Int).Value = R.uid;
                    cmd.Parameters.AddWithValue("@Pass", SqlDbType.VarChar).Value = R.password;

                    cmd.Parameters.Add("@Status", SqlDbType.Int);
                    cmd.Parameters["@Status"].Direction = ParameterDirection.Output;
                    try
                    {
                        int i = cmd.ExecuteNonQuery();
                        Stat = Convert.ToInt32(cmd.Parameters["@Status"].Value);
                    }
                    catch (Exception ex)
                    {
                        ex.GetType();
                    }
                    finally
                    {
                        conn.Close();
                    }
                    return Stat;
                }
            }
        }
    }
}