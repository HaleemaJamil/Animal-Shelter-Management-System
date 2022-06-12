
function Show_Employee_Det()
{    // if user clicks Vet radio button, textboxes for experience & degree and calender
    //  for graduation date will appear, else they will hide
    var radioVet = document.getElementById("rdVet");                    
    var vetDiv = document.getElementById("DivVet");
    if (radioVet.checked) {
        vetDiv.style.display = "block";
    }
    else {
        vetDiv.style.display = "none";
    }
}

function validate_email(event)
{
    var regex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    if (!regex.test(event))
    {
        alert("Invalid Email");
        return false;
    }
    return true;
}
function validate_password(event)
{
    var regex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,20}$/;   //8-20 characters, ucase, lcase, special char & number
    if (!regex.test(event))
    {
        alert("Password must contain 8-20 characters, Ucase, Lcase, Number and Special characters");
        return false;
    }
    return true;
}
function ClientSubmitClick()
{
    var success = false;
    var errorCount = 0;
    var errorMsg = "";
    var username = document.getElementById("NameTxt").value;
    if (username.length == 0)
    {
        errorCount += 1;
        errorMsg = errorMsg + "A username is required. \n";
    }
    if (document.getElementById("rdMale").checked == false && document.getElementById("rdFemale").checked == false)
    {
        errorCount += 1;
        errorMsg = errorMsg + "Gender is required. \n";
    }
    if (document.getElementById("rdMember").checked == false && document.getElementById("rdEmployee").checked == false && document.getElementById("rdVet").checked == false)
    {
        errorCount += 1;
        errorMsg = errorMsg + "User Type is required. \n";
    }
    if (document.getElementById("rdVet").checked == true)
    {
        var exp = document.getElementById("ExpTxt").value;
        var degree = document.getElementById("DegTxt").value;
        if (degree.length == 0)
        {
            errorCount += 1;
            errorMsg = errorMsg + "Degree is required. \n";
        }
        if (exp.length == 0) {
            errorCount += 1;
            errorMsg = errorMsg + "Experience in years is required. \n";
        }
        else
        {
            if (parseInt(exp) < 0 || parseInt(exp) == NaN)
            {
                errorCount += 1;
                errorMsg = errorMsg + "Experience in years must be a positive numeric value or 0. \n";
            }
        }
    }
    //password validation client side:
    var password = document.getElementById("PassTxt").value;
    if (password.length > 0) {
        if (validate_password(password) == false) {
            errorCount += 1;
            errorMsg = errorMsg + "Password must be strong. \n";
        }
    }
    else
    {
        errorCount += 1;
        errorMsg = errorMsg + "Password is required. \n";
    }
    //email validation
    var email = document.getElementById("EmailTxt").value;
    if (email.length > 0) {
        document.print(email);
        if (validate_email(email) == false) {
            errorCount += 1;
            errorMsg = errorMsg + "Enter a valid email. Avoid organization email. \n";
        }
    }
    else
    {
        errorCount += 1;
        errorMsg = errorMsg + "Email is required. \n";
    }
    if (errorCount == 0) {
        success = true;
        errorMsg = "Signup Success ! ! !";
    }
    else
    {
        errorMsg = "There were " + errorCount.toString() + " problems:\n" + errorMsg;
    }
    alert(errorMsg);
    return success;
}