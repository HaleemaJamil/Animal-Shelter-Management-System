using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApplication
{
    public class BAL
    {
        public class ULogin
        {
            public int uid { get; set; }
            public string password { get; set; }
        }
        public class URegister
        {
            public string name { get; set; }
            public string password { get; set; }
            public string email { get; set; }
            public string DOB { get; set; }
            public string gender { get; set; }
            public int UserType { get; set; }
            public string DOG { get; set; }
            public string degree { get; set; }
            public int exp { get; set; }

        }
        public class UBilling
        {
            public int mid { get; set; }
            public string cardNo { get; set; }
            public string cvc { get; set; }
            public string expiry { get; set; }
        }
        public class MakeTransaction
        {
            public int mid { get; set; }
            public string cardNo { get; set; }
            public string cvc { get; set; }
            public string expiry { get; set; }
            public float cost { get; set; }
        }
        public class UPost
        {
            public int uid { get; set; }
            public string PostContent { get; set; }
        }
        public class UComment
        {
            public int uid { get; set; }
            public int pid { get; set; }
            public string CommentContent { get; set; }
        }

        public class UpdateBlacklist
        {
            public int uid { get; set; }
            public int operation { get; set; }
            public string reason { get; set; }
        }

        public class AddAnimal
        {
            public string specie { get; set; }
            public string gender { get; set; }
            public string colour { get; set; }
            public int age { get; set; }
        }

        public class AdmitInjured
        {
            public int id { get; set; }
            public string injury { get; set; }
            public string disease { get; set; }
        }

        public class DischargeAnimal
        {
            public int id { get; set; }
            public DateTime admitDate { get; set; }
        }
    }
}
