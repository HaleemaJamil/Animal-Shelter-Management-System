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
        public class DALMember
        {
            SqlConnection conn = null;
            string connectionStr = "Server= localhost; Database= AnimalShelter; Integrated Security=SSPI;";

            public string BillingDAL(BAL.UBilling U)
            {
                using (conn = new SqlConnection(connectionStr))
                {
                    conn.Open();
                    string msg = "";
                    SqlCommand cmd = new SqlCommand("AddBilling", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@mid", SqlDbType.Int).Value = U.mid;
                    cmd.Parameters.AddWithValue("@C_no", SqlDbType.VarChar).Value = U.cardNo;
                    cmd.Parameters.AddWithValue("@cvc", SqlDbType.VarChar).Value = U.cardNo;
                    cmd.Parameters.AddWithValue("@expiry", SqlDbType.Date).Value = U.expiry;
                    cmd.Parameters.AddWithValue("@bal", SqlDbType.Float).Value = 20000f;

                    cmd.Parameters.Add("@msg", SqlDbType.VarChar,100);
                    cmd.Parameters["@msg"].Direction = ParameterDirection.Output;
                    try
                    {
                        int i = cmd.ExecuteNonQuery();
                        msg = Convert.ToString(cmd.Parameters["@msg"].Value);
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
                    return msg;
                }
            }
        }
    }
}