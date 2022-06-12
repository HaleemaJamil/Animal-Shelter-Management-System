using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
namespace WebApplication
{
    namespace DAL_Signup
    {
        public class DALSignup
        {
            SqlConnection conn = null;
            string connectionStr = "Server= localhost; Database= AnimalShelter; Integrated Security=SSPI;";
            public Tuple<string, int,int, int> Signup(BAL.URegister R )
            {
                string msg = "";
                int id1 = -1, id2 = -1;
                using(conn=new SqlConnection(connectionStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand("SIGNUPMEMBER", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@name", SqlDbType.VarChar).Value = R.name;
                    cmd.Parameters.AddWithValue("@password", SqlDbType.VarChar).Value = R.password;
                    cmd.Parameters.AddWithValue("@DOB", SqlDbType.Date).Value = R.DOB;
                    cmd.Parameters.AddWithValue("@Gender", SqlDbType.VarChar).Value = R.gender;
                    cmd.Parameters.AddWithValue("@email", SqlDbType.VarChar).Value = R.email;
                    cmd.Parameters.AddWithValue("@usertype", SqlDbType.Int).Value = R.UserType;
                    cmd.Parameters.AddWithValue("@salary", SqlDbType.Int).Value = 5000;
                    cmd.Parameters.AddWithValue("@gradyear", SqlDbType.Date).Value = R.DOG;
                    cmd.Parameters.AddWithValue("@degree", SqlDbType.VarChar).Value = R.degree;
                    cmd.Parameters.AddWithValue("@exp", SqlDbType.Int).Value = R.exp;

                    cmd.Parameters.Add("@msg", SqlDbType.VarChar, 30);
                    cmd.Parameters["@msg"].Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("@Id_1", SqlDbType.Int);
                    cmd.Parameters["@Id_1"].Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("@Id_2", SqlDbType.Int);
                    cmd.Parameters["@Id_2"].Direction = ParameterDirection.Output;
                    try
                    {
                        int i = cmd.ExecuteNonQuery();
                        msg = Convert.ToString(cmd.Parameters["@msg"].Value);
                        id1 = Convert.ToInt32(cmd.Parameters["@Id_1"].Value);
                        id2 = Convert.ToInt32(cmd.Parameters["@Id_2"].Value);
                    }
                    catch(Exception ex)
                    {
                        ex.GetType();
                    }
                    finally
                    {
                        conn.Close();
                    }
                }
                return new Tuple<string,int, int, int>(msg,R.UserType, id1, id2);
            }
        }
    }
}
